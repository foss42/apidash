import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/providers/ui_providers.dart';
import 'package:apidash/services/apiExplorerServices/apiProccessing_service.dart';
import 'package:apidash/services/apiExplorerServices/api_fetcher.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Main API Explorer Provider
final apiExplorerProvider =
    StateNotifierProvider<ApiExplorerNotifier, List<Map<String, dynamic>>>(
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
final selectedCollectionProvider = Provider<Map<String, dynamic>?>((ref) {
  final collectionId = ref.watch(selectedCollectionIdProvider);
  if (collectionId == null) return null;

  final collections = ref.watch(apiExplorerProvider);
  return collections.firstWhere(
    (c) => c['id'] == collectionId,
    orElse: () => {},
  );
});

final selectedEndpointProvider = Provider<Map<String, dynamic>?>((ref) {
  final endpointId = ref.watch(selectedEndpointIdProvider);
  final collection = ref.watch(selectedCollectionProvider);

  if (endpointId == null || collection == null) return null;

  final endpoints = collection['endpoints'] as List<dynamic>? ?? [];
  try {
    return endpoints.firstWhere(
      (e) => e['id'] == endpointId,
    ) as Map<String, dynamic>;
  } catch (_) {
    return null;
  }
});

final filteredCollectionsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final query = ref.watch(apiSearchQueryProvider);
  final collections = ref.watch(apiExplorerProvider);

  if (query.isEmpty) return collections;

  return collections
      .map((collection) {
        final endpoints = collection['endpoints'] as List<dynamic>? ?? [];
        final filteredEndpoints = endpoints.where((endpoint) {
          final endpointMap = endpoint as Map<String, dynamic>;
          return endpointMap['name']
                  ?.toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ??
              false ||
                  endpointMap['path']!
                      .toString()
                      .toLowerCase()
                      .contains(query.toLowerCase());
        }).toList();

        return {
          ...collection,
          'endpoints': filteredEndpoints,
        };
      })
      .where((collection) => (collection['endpoints'] as List).isNotEmpty)
      .toList();
});

class ApiExplorerNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final ApiProcessingService _apiService;
  final GitHubSpecsFetcher _specsFetcher;
  ApiExplorerNotifier()
      : _apiService = ApiProcessingService(),
        _specsFetcher = GitHubSpecsFetcher(),
        super([]);

  Future<void> loadApis(WidgetRef ref) async {
    ref.read(apiExplorerLoadingProvider.notifier).state = true;
    ref.read(apiExplorerErrorProvider.notifier).state = null;

    try {
      // First try to load from cache
      final cachedSpecs = GitHubSpecsFetcher.getCachedSpecs();
      List<Map<String, dynamic>> processedCollections = [];

      if (cachedSpecs.isNotEmpty) {
        // Process the cached specs
        processedCollections = await _apiService.processHiveSpecs(cachedSpecs);
      } else {
        // If no cache, fetch fresh from GitHub
        final freshSpecs = await _specsFetcher.fetchAndStoreSpecs();
        processedCollections = await _apiService.processHiveSpecs(freshSpecs);
      }

      state = processedCollections;
    } catch (e) {
      ref.read(apiExplorerErrorProvider.notifier).state = e.toString();
    } finally {
      ref.read(apiExplorerLoadingProvider.notifier).state = false;
    }
  }

  Future<void> refreshApis(WidgetRef ref) async {
    ref.read(apiExplorerLoadingProvider.notifier).state = true;
    try {
      final freshSpecs = await _specsFetcher.fetchAndStoreSpecs();
      final processedCollections =
          await _apiService.processHiveSpecs(freshSpecs);
      state = processedCollections;
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

      final endpoints =
          await _apiService.parseOpenApiContent(response!.body, url);
      final newCollection = _createCollection(endpoints, url, 'url');

      state = [...state, newCollection];
    } catch (e) {
      ref.read(apiExplorerErrorProvider.notifier).state = e.toString();
    } finally {
      ref.read(apiExplorerLoadingProvider.notifier).state = false;
      httpClientManager.closeClient(requestId);
    }
  }

HTTPVerb convert(String verb) {
    switch (verb.toLowerCase()) {
      case 'get':
        return HTTPVerb.get;
      case 'post':
        return HTTPVerb.post;
      case 'put':
        return HTTPVerb.put;
      case 'delete':
        return HTTPVerb.delete;
      case 'patch':
        return HTTPVerb.patch;
      default:
        return HTTPVerb.get; 
    }
}
  Future<void> importEndpoint(Map<String, dynamic>? endpoint , WidgetRef ref) async  {
   try {
      final requestMode = HttpRequestModel(
      url: (endpoint?['baseUrl']?.toString() ?? '') + (endpoint?['path'] ?? ''),
      method:  convert(endpoint?['method']),
      bodyContentType: ContentType.json,
    );
    ref.read(collectionStateNotifierProvider.notifier).addRequestModel(requestMode);
    ref.read(navRailIndexStateProvider.notifier).state = 0;
   } catch (e) {
     debugPrint('Error importing endpoint: $e');
   }
  }


  Map<String, dynamic> _createCollection(
    List<Map<String, dynamic>> endpoints,
    String source,
    String type,
  ) {
    return {
      'id': '$type-${DateTime.now().millisecondsSinceEpoch}',
      'name': _getSourceName(source),
      'source': source,
      'updatedAt': DateTime.now().toIso8601String(),
      'endpoints': endpoints,
    };
  }

  String _getSourceName(String source) {
    try {
      return source.split('/').last.replaceAll(RegExp(r'\.(ya?ml|json)$'), '');
    } catch (e) {
      return 'Unnamed API';
    }
  }

}