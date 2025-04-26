import 'dart:convert';

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
      // Process path parameters first
      String processedPath = endpoint.path;
      final pathParams = endpoint.parameters
          ?.where((p) => p.inLocation == 'path' && p.example != null)
          .toList();

      if (pathParams != null && pathParams.isNotEmpty) {
        for (final param in pathParams) {
          processedPath =
              processedPath.replaceAll('{${param.name}}', param.example ?? '');
        }
      }

      // Process query parameters
      final List<NameValueModel>? params = endpoint.parameters
          ?.where((p) => p.inLocation == 'query' && p.example != null)
          .map((p) => NameValueModel(name: p.name, value: p.example!))
          .toList();

      // Process headers
      final List<NameValueModel>? headers = endpoint.headers?.entries
          .where((e) => e.value.example != null)
          .map((e) => NameValueModel(name: e.key, value: e.value.example!))
          .toList();

      // Handle content type and body
      ContentType contentType = ContentType.json;
      String? requestBody;
      List<FormDataModel>? formData;

      if (endpoint.requestBody != null &&
          endpoint.requestBody!.content.isNotEmpty) {
        final contentEntry = endpoint.requestBody!.content.entries.first;
        final mediaType = contentEntry.key;
        final content = contentEntry.value;

        contentType = _getContentTypeFromMediaType(mediaType);

        if (contentType == ContentType.formdata) {
          formData = _convertToFormData(content.schema);
        } else {
          requestBody = content.schema.example?.toString() ??
              jsonEncode(_convertSchemaToJson(content.schema));
        }
      }
      // 1. Build base URL + path
      String baseUrl = endpoint.baseUrl;
      if (baseUrl.endsWith('/')) {
        baseUrl = baseUrl.substring(0, baseUrl.length - 1);
      }
      String path =
          processedPath.startsWith('/') ? processedPath : '/$processedPath';
      String fullUrl = '$baseUrl$path';

      // 2.  query parameters if any exist
      final queryParams = endpoint.parameters
          ?.where((p) => p.inLocation == 'query' && p.example != null)
          .map((p) =>
              '${Uri.encodeComponent(p.name)}=${Uri.encodeComponent(p.example!)}')
          .join('&');

      if (queryParams != null && queryParams.isNotEmpty) {
        fullUrl += '?$queryParams'; // FINAL URL HAS QUERY PARAMS
      }

      final requestModel = HttpRequestModel(
        method: endpoint.method,
        url: fullUrl, // NOW INCLUDES QUERY PARAMS
        headers: headers,
        // params: params, // REMOVE THIS IF NOT USED ELSEWHERE
        bodyContentType: contentType,
        body: requestBody,
        formData: formData,
      );
      ref
          .read(collectionStateNotifierProvider.notifier)
          .addRequestModel(requestModel);
      ref.read(navRailIndexStateProvider.notifier).state = 0;
    } catch (e) {
      debugPrint('Error importing endpoint: $e');
      rethrow;
    }
  }

  ContentType _getContentTypeFromMediaType(String mediaType) {
    if (mediaType.contains('application/json')) {
      return ContentType.json;
    } else if (mediaType.contains('multipart/form-data') ||
        mediaType.contains('application/x-www-form-urlencoded')) {
      return ContentType.formdata;
    } else if (mediaType.contains('text/')) {
      return ContentType.text;
    }
    return ContentType.json; // default
  }

  List<FormDataModel>? _convertToFormData(ApiSchema? schema) {
    if (schema == null || schema.properties == null) return null;

    return schema.properties!.entries.map((entry) {
      return FormDataModel(
        name: entry.key,
        value: entry.value.example?.toString() ?? '',
        type: _determineFormDataType(entry.value),
      );
    }).toList();
  }

  FormDataType _determineFormDataType(ApiSchema schema) {
    if (schema.type == 'string' && schema.format == 'binary') {
      return FormDataType.file;
    }
    return FormDataType.text;
  }

  Object _convertSchemaToJson(ApiSchema schema) {
    if (schema.example != null) {
      return {'value': schema.example};
    }

    final result = <String, dynamic>{};
    if (schema.properties != null) {
      for (final entry in schema.properties!.entries) {
        result[entry.key] = _convertSchemaToJson(entry.value);
      }
    } else if (schema.type == 'array' && schema.items != null) {
      return [_convertSchemaToJson(schema.items!)];
    }
    return result;
  }
}
