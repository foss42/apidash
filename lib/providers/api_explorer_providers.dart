import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/providers/ui_providers.dart';
import 'package:apidash/services/api_fetcher.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../services/services.dart';
import '../models/models.dart';

// Main API Explorer Provider
final apiExplorerProvider =
    StateNotifierProvider<ApiExplorerNotifier, List<ApiExplorerModel>>(
  (ref) => ApiExplorerNotifier(ref),
);

// Loading and Error States
final apiExplorerLoadingProvider = StateProvider<bool>((ref) => false);
final apiExplorerErrorProvider = StateProvider<String?>((ref) => null);

// UI State Providers
final apiExplorerCodePaneVisibleStateProvider =
    StateProvider<bool>((ref) => false);
final selectedEndpointIdProvider = StateProvider<String?>((ref) => null);
final selectedCollectionIdProvider = StateProvider<String?>((ref) => null);
final apiSearchQueryProvider = StateProvider<String>((ref) => '');

// Derived Providers
final selectedCollectionProvider = Provider<ApiExplorerModel?>((ref) {
  final collectionId = ref.watch(selectedCollectionIdProvider);
  if (collectionId == null) return null;

  final collections = ref.watch(apiExplorerProvider);
  try {
    return collections.firstWhere((c) => c.id == collectionId);
  } catch (_) {
    return null;
  }
});

final selectedEndpointProvider = Provider<ApiExplorerModel?>((ref) {
  final endpointId = ref.watch(selectedEndpointIdProvider);
  final collection = ref.watch(selectedCollectionProvider);

  if (endpointId == null || collection == null) return null;
  
  return collection.copyWith(
    id: endpointId,
    name: endpointId,
  );
});

final filteredCollectionsProvider = Provider<List<ApiExplorerModel>>((ref) {
  final query = ref.watch(apiSearchQueryProvider);
  final collections = ref.watch(apiExplorerProvider);

  if (query.isEmpty) return collections;

  final queryLower = query.toLowerCase();
  return collections.where((collection) {
    return collection.name.toLowerCase().contains(queryLower) ||
        collection.path.toLowerCase().contains(queryLower);
  }).toList();
});

class ApiExplorerNotifier extends StateNotifier<List<ApiExplorerModel>> {
  final ApiProcessingService _apiService;
  final Ref _ref;

  ApiExplorerNotifier(this._ref)
      : _apiService = ApiProcessingService(),
        super([]);

  Future<void> loadApis() async {
    _ref.read(apiExplorerLoadingProvider.notifier).state = true;
    _ref.read(apiExplorerErrorProvider.notifier).state = null;

    try {
      // Attempt 1: Load from Hive
      if (await _tryLoadFromHive()) return;

      // Attempt 2: Load from local files
      if (await _tryLoadFromFiles()) return;
      
      // Attempt 3: Load from templates
      if (await _tryLoadFromTemplates()) return;
      
      _handleNoApisFound();
    } catch (e) {
      _handleLoadError(e);
    } finally {
      _ref.read(apiExplorerLoadingProvider.notifier).state = false;
    }
  }

  Future<bool> _tryLoadFromHive() async {
    try {
      if (!Hive.isBoxOpen(kApiSpecsBox)) {
        await Hive.openBox(kApiSpecsBox);
      }

      final box = Hive.box(kApiSpecsBox);
      final ids = (box.get(kApiSpecsBoxIds, defaultValue: <dynamic>[]) as List)
          .map((e) => e.toString())
          .toList();

      if (ids.isEmpty) return false;
      
      final collections = <ApiExplorerModel>[];
      for (final id in ids) {
        final dynamic data = box.get(id);
        if (data is Map) {
          try {
            final jsonData = Map<String, dynamic>.from(data);
            final collection = ApiExplorerModel.fromJson(jsonData);
            collections.add(collection);
          } catch (e) {
            debugPrint('[API Explorer] Skipping invalid collection: $id, $e');
          }
        }
      }

      if (collections.isNotEmpty) {
        state = collections;
        debugPrint('[API Explorer] Loaded ${collections.length} collections from Hive');
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('[API Explorer] Hive load failed: $e');
      return false;
    }
  }

  Future<bool> _tryLoadFromFiles() async {
    try {
      debugPrint('Attempting to load from local files');
      final processed = await _apiService
          .processApiFiles()
          .timeout(const Duration(seconds: 10));

      if (processed.isNotEmpty) {
        debugPrint('Loaded ${processed.length} collections from files');
        state = processed;
        await _storeInHive(processed);
        return true;
      }
    } catch (e) {
      debugPrint('File load failed: $e');
    }
    return false;
  }

  Future<bool> _tryLoadFromTemplates() async {
    try {
      final templatesDir = await getApplicationSupportDirectory();
      final templatesPath = '${templatesDir.path}/templates';

      if (await Directory(templatesPath).exists()) {
        debugPrint('Loading from templates folder');
        final files = await Directory(templatesPath)
            .list()
            .where((entity) => entity is File)
            .cast<File>()
            .toList();

        final specs = <String, String>{};

        for (final file in files) {
          try {
            specs[path.basename(file.path)] = await file.readAsString();
          } catch (e) {
            debugPrint('Error reading ${file.path}: $e');
          }
        }

        if (specs.isNotEmpty) {
          // Changed from processApiFiles to processHiveSpecs since we're processing specs
          final processedData = await _apiService.processHiveSpecs(specs);

          final updatedData = processedData.map((collection) {
            return collection.copyWith(
              source: 'Template: ${collection.source}',
            );
          }).toList();

          if (updatedData.isNotEmpty) {
            state = updatedData;
            await _storeInHive(updatedData);
            return true;
          }
        }
      }
    } catch (e) {
      debugPrint('Template load failed: $e');
    }
    return false;
  }

  Future<void> _storeInHive(List<ApiExplorerModel> collections) async {
    try {
      final box = Hive.box(kApiSpecsBox);
      await box.clear();

      for (final collection in collections) {
        await box.put(collection.id, collection.toJson());
      }

      await box.put(kApiSpecsBoxIds, collections.map((c) => c.id).toList());
      debugPrint('[API Explorer] Stored ${collections.length} collections in Hive');
    } catch (e) {
      debugPrint('[API Explorer] ERROR - Hive storage failed: $e');
      rethrow;
    }
  }

  void _handleNoApisFound() {
    debugPrint('No API collections found in any source');
    state = [];
    _ref.read(apiExplorerErrorProvider.notifier).state =
        'No API collections available. Please check your connection and try again.';
  }

  void _handleLoadError(dynamic e) {
    debugPrint('Critical API load error: $e');
    state = [];
    _ref.read(apiExplorerErrorProvider.notifier).state =
        'Failed to load APIs: ${e.toString()}';
  }

  Future<void> importEndpoint(ApiExplorerModel endpoint) async {
    try {
      final requestModel = endpoint.toHttpRequestModel();
      _ref
          .read(collectionStateNotifierProvider.notifier)
          .addRequestModel(requestModel);
      _ref.read(navRailIndexStateProvider.notifier).state = 0;
    } catch (e) {
      debugPrint('Failed to import endpoint: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> addCollection({
    required String url,
    String? name,
  }) async {
    try {
      if (url.isEmpty) throw Exception('URL cannot be empty');
      final processedUrl = _addRawPrefix(url);
      final collectionName = name ?? shortenLongUrl(processedUrl);
      
      // This should return a List<ApiExplorerModel> representing endpoints
      final endpoints = await _apiService.parseOpenApiContent(processedUrl, url);

      if (endpoints.isEmpty) {
        throw Exception('No valid endpoints found in the specification');
      }

      // For now, we'll just add the first endpoint as a collection
      // This should likely be updated to handle multiple endpoints
      final newCollection = endpoints.first.copyWith(
        id: 'col-${DateTime.now().millisecondsSinceEpoch}',
        name: collectionName,
        source: processedUrl,
      );

      state = [...state, newCollection];
      await _persistCollections();
    } catch (e) {
      debugPrint('Failed to add collection: ${e.toString()}');
      rethrow;
    }
  }

  String _addRawPrefix(String url) {
    if (!url.contains('://raw.')) {
      return url.replaceFirst('://', '://raw.');
    }
    return url;
  }

  String shortenLongUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final pathSegments = uri.pathSegments;
      if (pathSegments.isEmpty) return url;

      final lastSegment = pathSegments.last;
      return '${uri.host}/../$lastSegment';
    } catch (_) {
      return url.length > 40
          ? '${url.substring(0, 20)}...${url.substring(url.length - 15)}'
          : url;
    }
  }

  Future<void> refreshApis() async {
    _ref.read(apiExplorerLoadingProvider.notifier).state = true;
    try {
      await Future.delayed(const Duration(seconds: 1));
      await loadApis();
    } catch (e) {
      _ref.read(apiExplorerErrorProvider.notifier).state = e.toString();
      rethrow;
    } finally {
      _ref.read(apiExplorerLoadingProvider.notifier).state = false;
    }
  }

  Future<void> addCollectionFromUrl(String url, {String? name}) async {
    const requestId = 'api-spec-import';
    _ref.read(apiExplorerLoadingProvider.notifier).state = true;
    _ref.read(apiExplorerErrorProvider.notifier).state = null;
    
    try {
      final uri = Uri.tryParse(url);
      if (uri == null || !uri.isAbsolute) {
        throw const FormatException('Invalid URL format');
      }
      
      final requestModel = HttpRequestModel(
        url: url, 
        method: HTTPVerb.get, 
        bodyContentType: ContentType.text
      );

      final (response, _, error) = await sendHttpRequest(
        requestId,
        APIType.rest,
        requestModel,
        noSSL: true,
      );

      if (error != null) throw Exception(error);
      if (response?.statusCode != 200) {
        throw Exception('Received HTTP ${response?.statusCode}');
      }
      
      final content = response?.body ?? '';
      final endpoints = await _apiService.parseOpenApiContent(content, url);

      if (endpoints.isEmpty) {
        throw Exception('No valid endpoints found in the specification');
      }

      // For now, we'll just add the first endpoint as a collection
      // This should likely be updated to handle multiple endpoints
      final newCollection = endpoints.first.copyWith(
        id: 'col-${DateTime.now().millisecondsSinceEpoch}',
        name: name ?? shortenLongUrl(url),
        source: url,
      );

      state = [...state, newCollection];
      await _persistCollections();
    } catch (e) {
      _ref.read(apiExplorerErrorProvider.notifier).state = e.toString();
      rethrow;
    } finally {
      _ref.read(apiExplorerLoadingProvider.notifier).state = false;
      httpClientManager.closeClient(requestId);
    }
  }

  Future<void> removeCollection(String collectionId) async {
    state = state.where((c) => c.id != collectionId).toList();
    await _persistCollections();
  }

  Future<void> _persistCollections() async {
    try {
      final box = Hive.box(kApiSpecsBox);
      await box.clear();
      
      for (final collection in state) {
        await box.put(collection.id, collection.toJson());
      }
      
      await box.put(kApiSpecsBoxIds, state.map((c) => c.id).toList());
      debugPrint('[API Explorer] Persisted ${state.length} collections to Hive');
    } catch (e) {
      debugPrint('[API Explorer] Error persisting collections: $e');
      rethrow;
    }
  }
}