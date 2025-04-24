import 'package:apidash/models/api_explorer_models.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/providers/ui_providers.dart';
import 'package:apidash/services/apiproccessing.dart';
import 'package:apidash/services/apipackagezip_service.dart';
import 'package:apidash/services/hive_services.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Main API Explorer Provider
final apiExplorerProvider =
    StateNotifierProvider<ApiExplorerNotifier, List<ApiCollection>>(
  (ref) => ApiExplorerNotifier(),
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
final selectedCollectionProvider = Provider<ApiCollection?>((ref) {
  final collectionId = ref.watch(selectedCollectionIdProvider);
  if (collectionId == null) return null;

  final collections = ref.watch(apiExplorerProvider);
  return collections.firstWhere(
    (c) => c.id == collectionId,
  );
});

final selectedEndpointProvider = Provider<ApiEndpoint?>((ref) {
  final endpointId = ref.watch(selectedEndpointIdProvider);
  final collection = ref.watch(selectedCollectionProvider);

  if (endpointId == null || collection == null) return null;

  try {
    return collection.endpoints.firstWhere((e) => e.id == endpointId);
  } catch (e) {
    return null; 
  }
});

final filteredCollectionsProvider = Provider<List<ApiCollection>>((ref) {
  final query = ref.watch(apiSearchQueryProvider);
  final collections = ref.watch(apiExplorerProvider);

  if (query.isEmpty) return collections;

  return collections
      .map((collection) {
        final filteredEndpoints = collection.endpoints.where((endpoint) {
          return endpoint.name.toLowerCase().contains(query.toLowerCase()) ||
              endpoint.path.toLowerCase().contains(query.toLowerCase());
        }).toList();

        return collection.copyWith(endpoints: filteredEndpoints);
      })
      .where((collection) => collection.endpoints.isNotEmpty)
      .toList();
});

class ApiExplorerNotifier extends StateNotifier<List<ApiCollection>> {
  final ApiProcessingService _apiService;
  final ApiSpecsRepository _specsRepository;

  ApiExplorerNotifier()
      : _apiService = ApiProcessingService(),
        _specsRepository = ApiSpecsRepository(),
        super([]);

  Future<void> loadApis(WidgetRef ref) async {
    ref.read(apiExplorerLoadingProvider.notifier).state = true;
    ref.read(apiExplorerErrorProvider.notifier).state = null;

    try {
      // First try to load from cache via HiveHandler
      final cachedCollections = hiveHandler.getCachedApiSpecsCollections();

      if (cachedCollections.isNotEmpty) {
        state = cachedCollections;
      } else {
        // If no cache, fetch fresh
        await refreshApis(ref);
      }
    } catch (e) {
      ref.read(apiExplorerErrorProvider.notifier).state = e.toString();
    } finally {
      ref.read(apiExplorerLoadingProvider.notifier).state = false;
    }
  }

  Future<void> refreshApis(WidgetRef ref) async {
    ref.read(apiExplorerLoadingProvider.notifier).state = true;
    ref.read(apiExplorerErrorProvider.notifier).state = null;

    try {
      final collections = await _specsRepository.fetchSpecs();
      await hiveHandler.cacheApiSpecsCollections(collections);
      state = collections;
    } catch (e) {
      ref.read(apiExplorerErrorProvider.notifier).state = e.toString();
    } finally {
      ref.read(apiExplorerLoadingProvider.notifier).state = false;
    }
  }

  Future<void> addCollectionFromUrl(String url, WidgetRef ref) async {
    const requestId = 'api-spec-import';
    ref.read(apiExplorerLoadingProvider.notifier).state = true;
    ref.read(apiExplorerErrorProvider.notifier).state = null;

    try {
      final uri = Uri.tryParse(url);
      if (uri == null || !uri.isAbsolute) {
        throw const FormatException('Invalid URL format');
      }

      final requestModel = HttpRequestModel(
          url: url, method: HTTPVerb.get, bodyContentType: ContentType.text);

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

      final content = response!.body;
      if (content.isEmpty) throw Exception('Empty response from server');

      final collection = await _apiService.parseSingleSpec(content, url);

      state = [...state, collection];
      await hiveHandler.cacheApiSpecsCollections(state);
    } catch (e, stack) {
      debugPrint('Error adding collection from URL: $e\n$stack');
      ref.read(apiExplorerErrorProvider.notifier).state =
          'Failed to import API: ${e.toString()}';
      rethrow;
    } finally {
      ref.read(apiExplorerLoadingProvider.notifier).state = false;
      httpClientManager.closeClient(requestId);
    }
  }

  Future<void> importEndpoint(ApiEndpoint endpoint, WidgetRef ref) async {
    try {
      final requestModel = HttpRequestModel(
        url: endpoint.baseUrl + endpoint.path,
        method: endpoint.method,
        bodyContentType: ContentType.json,
      );

      ref
          .read(collectionStateNotifierProvider.notifier)
          .addRequestModel(requestModel);
      ref.read(navRailIndexStateProvider.notifier).state = 0;
    } catch (e) {
      debugPrint('Error importing endpoint: $e');
    }
  }
}
