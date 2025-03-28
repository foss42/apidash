import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/providers/ui_providers.dart';
import 'package:apidash/services/apiProccessing_service.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_core/consts.dart';
import 'package:apidash_core/models/http_request_model.dart';
import 'package:apidash_core/services/http_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Main API Explorer Provider
final apiExplorerProvider = StateNotifierProvider<ApiExplorerNotifier, List<Map<String, dynamic>>>(
  (ref) => ApiExplorerNotifier(),
);

// Loading and Error States
final apiExplorerLoadingProvider = StateProvider<bool>((ref) => false);
final apiExplorerErrorProvider = StateProvider<String?>((ref) => null);

// UI State Providers
final apiExplorerCodePaneVisibleStateProvider = StateProvider<bool>((ref) => false);
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
                  endpointMap['path']
                      !.toString()
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
  ApiExplorerNotifier() : _apiService = ApiProcessingService(), super([]);

  Future<void> loadApis(WidgetRef ref) async {
    ref.read(apiExplorerLoadingProvider.notifier).state = true;
    ref.read(apiExplorerErrorProvider.notifier).state = null;
    try {
      final processedCollections = await _apiService.processApiFiles();
      state = processedCollections;
    } catch (e) {
      ref.read(apiExplorerErrorProvider.notifier).state = e.toString();
    } finally {
      ref.read(apiExplorerLoadingProvider.notifier).state = false;
    }
  }

Future<void> importEndpoint(
    Map<String, dynamic> endpoint, 
    WidgetRef ref,
  ) async {
    try {
      final method = HTTPVerb.values.firstWhere(
        (v) => v.name.toLowerCase() == 
               (endpoint['method']?.toString().toLowerCase() ?? 'get'),
        orElse: () => HTTPVerb.get,
      );
      final baseUrl = endpoint['baseUrl']?.toString() ?? '';
      final path = endpoint['path']?.toString() ?? '';
      final url = Uri.parse('$baseUrl$path').toString();
      final headers = <NameValueModel>[];
      final headersMap = endpoint['headers'] as Map<String, dynamic>? ?? {};
      headersMap.forEach((name, headerDef) {
        if (headerDef is Map) {
          headers.add(NameValueModel(
            name: name,
            value: headerDef['example']?.toString() ?? '',
          ));
        }
      });

      // Convert OpenAPI parameters format to NameValueModel
      final params = <NameValueModel>[];
      final parametersList = endpoint['parameters'] as List<dynamic>? ?? [];
      for (final param in parametersList) {
        if (param is Map) {
          params.add(NameValueModel(
            name: param['name']?.toString() ?? '',
            value: param['example']?.toString() ?? 
                  param['schema']?['example']?.toString() ?? '',
          ));
        }
      }

      final requestModel = HttpRequestModel(
        method: method,
        url: url,
        headers: headers,
        params: params,
      );

      ref.read(collectionStateNotifierProvider.notifier).addRequestModel(requestModel);
      ref.read(navRailIndexStateProvider.notifier).state = 0;
    } catch (e) {
      throw Exception('Failed to import endpoint: ${e.toString()}');
    }
  }

 
  Future<void> refreshApis(WidgetRef ref) async {
    ref.read(apiExplorerLoadingProvider.notifier).state = true;
    try {
      await Future.delayed(const Duration(seconds: 1));
      await loadApis(ref);
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

      final endpoints = await _apiService.parseOpenApiContent(response!.body, url);
      final newCollection = _createCollection(endpoints, url, 'url');
      
      state = [...state, newCollection];
    } catch (e) {
      ref.read(apiExplorerErrorProvider.notifier).state = e.toString();
    } finally {
      ref.read(apiExplorerLoadingProvider.notifier).state = false;
      httpClientManager.closeClient(requestId);
    }
  }

  Map<String, dynamic> _createCollection(
    List<Map<String, dynamic>> endpoints,
    String source,
    String type,
  ) {
    return {
      'id': '$type-${DateTime.now().millisecondsSinceEpoch}',
      'name': _apiService.getCollectionName(source),
      'source': source,
      'updatedAt': DateTime.now().toIso8601String(),
      'endpoints': endpoints,
    };
  }

  Future<void> removeCollection(String collectionId) async {
    state = state.where((c) => c['id'] != collectionId).toList();
  }
}