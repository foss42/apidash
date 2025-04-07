import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/providers/ui_providers.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../services/services.dart';


// Main API Catalog Provider
final apiCatalogProvider =
    StateNotifierProvider<ApiCatalogNotifier, List<ApiCatalogModel>>(
  (ref) => ApiCatalogNotifier(ref),
);

// Loading and Error States
final apiCatalogLoadingProvider = StateProvider<bool>((ref) => false);
final apiCatalogErrorProvider = StateProvider<String?>((ref) => null);

// UI State Providers
final apiCatalogCodePaneVisibleStateProvider =
    StateProvider<bool>((ref) => false);
final selectedEndpointIdProvider = StateProvider<String?>((ref) => null);
final selectedCatalogIdProvider = StateProvider<String?>((ref) => null);
final apiSearchQueryProvider = StateProvider<String>((ref) => '');

// Derived Providers
final selectedCatalogProvider = Provider<ApiCatalogModel?>((ref) {
  final catalogId = ref.watch(selectedCatalogIdProvider);
  if (catalogId == null) return null;

  final catalogs = ref.watch(apiCatalogProvider);
  try {
    return catalogs.firstWhere((c) => c.id == catalogId);
  } catch (_) {
    return null;
  }
});

final selectedEndpointProvider = Provider<ApiEndpointModel?>((ref) {
  final endpointId = ref.watch(selectedEndpointIdProvider);
  final catalog = ref.watch(selectedCatalogProvider);

  if (endpointId == null || catalog == null) return null;

  try {
    return catalog.endpoints?.firstWhere((e) => e.id == endpointId);
  } catch (_) {
    return null;
  }
});

final filteredCatalogsProvider = Provider<List<ApiCatalogModel>>((ref) {
  final query = ref.watch(apiSearchQueryProvider);
  final catalogs = ref.watch(apiCatalogProvider);

  if (query.isEmpty) return catalogs;

  final queryLower = query.toLowerCase();
  return catalogs.where((catalog) {
    return catalog.name.toLowerCase().contains(queryLower) ||
        catalog.description!.toLowerCase().contains(queryLower) ||
        catalog.endpoints!.any((endpoint) =>
            endpoint.name.toLowerCase().contains(queryLower) ||
            endpoint.path.toLowerCase().contains(queryLower));
  }).toList();
});

class ApiCatalogNotifier extends StateNotifier<List<ApiCatalogModel>> {
  final ApiProcessingService _apiService;
  final Ref _ref;

  ApiCatalogNotifier(this._ref)
      : _apiService = ApiProcessingService(),
        super([]);

  Future<void> loadApis() async {
    _ref.read(apiCatalogLoadingProvider.notifier).state = true;
    _ref.read(apiCatalogErrorProvider.notifier).state = null;

    try {
      // Attempt 1: Load from Hive
      if (await _tryLoadFromHive()) return;

      // Attempt 2: Load from local files
      if (await _tryLoadFromFiles()) return;


      _handleNoApisFound();
    } catch (e) {
      _handleLoadError(e);
    } finally {
      _ref.read(apiCatalogLoadingProvider.notifier).state = false;
    }
  }
Future<bool> _tryLoadFromHive() async {
  try {
    final box = Hive.box(kApiSpecsBox);
    final ids = (box.get(kApiSpecsBoxIds, defaultValue: <dynamic>[])) as List;

    final catalogs = <ApiCatalogModel>[];
    for (final id in ids) {
      try {
        final data = box.get(id);
        if (data == null) continue;

        Map<String, dynamic> jsonData;
        if (data is String) {
          jsonData = jsonDecode(data) as Map<String, dynamic>;
        } else if (data is Map) {
          jsonData = data.cast<String, dynamic>();
        } else {
          continue;
        }

        // Add null checks for required fields
        if (jsonData['id'] == null || 
            jsonData['name'] == null || 
            jsonData['sourceUrl'] == null ||
            jsonData['updatedAt'] == null) {
          continue;
        }

        catalogs.add(ApiCatalogModel.fromJson(jsonData));
      } catch (e) {
        debugPrint('Error loading catalog $id: $e');
      }
    }

    if (catalogs.isNotEmpty) {
      state = catalogs;
      return true;
    }
    return false;
  } catch (e) {
    debugPrint('Hive load failed: $e');
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
        debugPrint('Loaded ${processed.length} catalogs from files');
        state = processed.cast<ApiCatalogModel>();
        await _storeInHive(processed.cast<ApiCatalogModel>());
        return true;
      }
    } catch (e) {
      debugPrint('File load failed: $e');
    }
    return false;
  }

  Map<String, int> _countMethods(List<ApiEndpointModel> endpoints) {
    final counts = <String, int>{};
    for (final endpoint in endpoints) {
      counts.update(
        endpoint.method.name,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
    }
    return counts;
  }

  Future<void> _storeInHive(List<ApiCatalogModel> catalogs) async {
    try {
      final box = Hive.box(kApiSpecsBox);
      await box.clear();

      for (final catalog in catalogs) {
        await box.put(catalog.id, jsonEncode(catalog.toJson()));
      }

      await box.put(kApiSpecsBoxIds, catalogs.map((c) => c.id).toList());
    } catch (e) {
      debugPrint('[API Catalog] ERROR - Hive storage failed: $e');
      rethrow;
    }
  }

  void _handleNoApisFound() {
    debugPrint('No API catalogs found in any source');
    state = [];
    _ref.read(apiCatalogErrorProvider.notifier).state =
        'No API catalogs available. Please check your connection and try again.';
  }

  void _handleLoadError(dynamic e) {
    debugPrint('Critical API load error: $e');
    state = [];
    _ref.read(apiCatalogErrorProvider.notifier).state =
        'Failed to load APIs: ${e.toString()}';
  }

  Future<void> importEndpoint(ApiEndpointModel endpoint) async {
    try {
      final catalog = state.firstWhere((c) => c.id == endpoint.catalogId);
      final baseUrl = catalog.baseUrl;
      
      final requestModel = HttpRequestModel(
        url: baseUrl!.isEmpty ? endpoint.path : '$baseUrl${endpoint.path}',
        method: endpoint.method,
        bodyContentType: ContentType.json,
      );
      
      _ref
          .read(collectionStateNotifierProvider.notifier)
          .addRequestModel(requestModel);
      _ref.read(navRailIndexStateProvider.notifier).state = 0;
    } catch (e) {
      debugPrint('Failed to import endpoint: ${e.toString()}');
      rethrow;
    }
  }

  // Future<void> addCatalog({
  //   required String url,
  //   String? name,
  // }) async {
  //   try {
  //     if (url.isEmpty) throw Exception('URL cannot be empty');
  //     final processedUrl = _addRawPrefix(url);
  //     final catalogName = name ?? shortenLongUrl(processedUrl);

  //     final apiSpec = await _fetchOpenApiSpec(processedUrl);
      
  //     if (apiSpec == null || apiSpec.isEmpty) {
  //       throw Exception('No valid specification found at the provided URL');
  //     }
      
  //     final catalog = await _createCatalogFromSpec(apiSpec, processedUrl, catalogName);
      
  //     state = [...state, catalog];
  //     await _persistCatalogs();
  //   } catch (e) {
  //     debugPrint('Failed to add catalog: ${e.toString()}');
  //     rethrow;
  //   }
  // }
  
  // Future<Map<String, dynamic>?> _fetchOpenApiSpec(String url) async {
  //   const requestId = 'api-spec-fetch';
  //   try {
  //     final requestModel = HttpRequestModel(
  //       url: url, 
  //       method: HTTPVerb.get, 
  //       bodyContentType: ContentType.text
  //     );

  //     final (response, _, error) = await sendHttpRequest(
  //       requestId,
  //       APIType.rest,
  //       requestModel,
  //       noSSL: true,
  //     );

  //     if (error != null) throw Exception(error);
  //     if (response?.statusCode != 200) {
  //       throw Exception('Received HTTP ${response?.statusCode}');
  //     }

  //     final content = response?.body ?? '';
      
  //     try {
  //       return jsonDecode(content) as Map<String, dynamic>;
  //     } catch (_) {
  //       return _apiService.(content);
  //     }
  //   } finally {
  //     httpClientManager.closeClient(requestId);
  //   }
  // }
  
  Future<ApiCatalogModel> _createCatalogFromSpec(
    Map<String, dynamic> spec, 
    String sourceUrl, 
    String name
  ) async {
    final info = spec['info'] as Map<String, dynamic>? ?? {};
    final servers = spec['servers'] as List? ?? [];
    final paths = spec['paths'] as Map<String, dynamic>? ?? {};
    
    final baseUrl = servers.isNotEmpty ? servers.first['url']?.toString() ?? '' : '';
    final version = info['version']?.toString() ?? '';
    final description = info['description']?.toString() ?? '';
    
    final endpoints = <ApiEndpointModel>[];
    final catalogId = 'cat_${DateTime.now().millisecondsSinceEpoch}';
    
    paths.forEach((path, pathItem) {
      if (pathItem is Map<String, dynamic>) {
        pathItem.forEach((method, operation) {
          if (method.toLowerCase() == 'parameters' || 
              !(operation is Map<String, dynamic>)) {
            return;
          }
          
          try {
            final httpMethod = _parseHttpMethod(method);
            final operationId = operation['operationId']?.toString() ?? '';
            final summary = operation['summary']?.toString() ?? '';
            final operationDescription = operation['description']?.toString() ?? '';
            
            final endpointId = '${method}_${path.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}';
            final endpointName = summary.isNotEmpty ? summary : operationId.isNotEmpty ? operationId : path;
            
            final parameters = <String, dynamic>{};
            final parametersList = operation['parameters'] as List? ?? [];
            for (final param in parametersList) {
              if (param is Map<String, dynamic>) {
                final paramName = param['name']?.toString();
                if (paramName != null) {
                  parameters[paramName] = param;
                }
              }
            }
            
            final responses = operation['responses'] as Map<String, dynamic>? ?? {};
            
            endpoints.add(ApiEndpointModel(
              id: endpointId,
              name: endpointName,
              catalogId: catalogId,
              description: operationDescription,
              operationId: operationId,
              path: path,
              method: httpMethod,
              parameters: parameters,
              responses: responses,
            ));
          } catch (e) {
            debugPrint('Error processing endpoint $method $path: $e');
          }
        });
      }
    });
    
    final methodCounts = _countMethods(endpoints);
    
    return ApiCatalogModel(
      id: catalogId,
      name: name,
      sourceUrl: sourceUrl,
      description: description,
      updatedAt: DateTime.now(),
      version: version,
      baseUrl: baseUrl,
      openApiSpec: spec,
      endpoints: endpoints,
      endpointCount: endpoints.length,
      methodCounts: methodCounts,
    );
  }
  
  HTTPVerb _parseHttpMethod(String method) {
    final normalizedMethod = method.toLowerCase();
    return HTTPVerb.values.firstWhere(
      (verb) => verb.name.toLowerCase() == normalizedMethod,
      orElse: () => HTTPVerb.get,
    );
  }

  String _addRawPrefix(String url) {
    if (url.contains('github.com') && !url.contains('raw.githubusercontent.com')) {
      return url.replaceFirst('github.com', 'raw.githubusercontent.com')
               .replaceFirst('/blob/', '/');
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
    _ref.read(apiCatalogLoadingProvider.notifier).state = true;
    try {
      await Future.delayed(const Duration(seconds: 1));
      await loadApis();
    } catch (e) {
      _ref.read(apiCatalogErrorProvider.notifier).state = e.toString();
      rethrow;
    } finally {
      _ref.read(apiCatalogLoadingProvider.notifier).state = false;
    }
  }

  // Future<void> addCatalogFromUrl(String url, {String? name}) async {
  //   _ref.read(apiCatalogLoadingProvider.notifier).state = true;
  //   _ref.read(apiCatalogErrorProvider.notifier).state = null;

  //   try {
  //     final apiSpec = await _fetchOpenApiSpec(url);
      
  //     if (apiSpec == null || apiSpec.isEmpty) {
  //       throw Exception('No valid specification found at the provided URL');
  //     }
      
  //     final catalog = await _createCatalogFromSpec(
  //       apiSpec, 
  //       url, 
  //       name ?? shortenLongUrl(url)
  //     );
      
  //     state = [...state, catalog];
  //     await _persistCatalogs();
  //   } catch (e) {
  //     _ref.read(apiCatalogErrorProvider.notifier).state = e.toString();
  //     rethrow;
  //   } finally {
  //     _ref.read(apiCatalogLoadingProvider.notifier).state = false;
  //   }
  // }

  Future<void> removeCatalog(String catalogId) async {
    state = state.where((c) => c.id != catalogId).toList();
    await _persistCatalogs();
  }

  Future<void> _persistCatalogs() async {
    try {
      final box = Hive.box(kApiSpecsBox);
      await box.clear();

      for (final catalog in state) {
        await box.put(catalog.id, jsonEncode(catalog.toJson()));
      }

      await box.put(kApiSpecsBoxIds, state.map((c) => c.id).toList());
      debugPrint(
          '[API Catalog] Persisted ${state.length} catalogs to Hive');
    } catch (e) {
      debugPrint('[API Catalog] Error persisting catalogs: $e');
      rethrow;
    }
  }
}