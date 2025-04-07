import 'dart:convert';
import 'package:apidash/consts.dart';
import 'package:apidash/models/api_catalog.dart';
import 'package:apidash/models/api_endpoint.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:archive/archive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';

class GitHubSpecsService {
  static const String _kLatestZipUrl =
      'https://github.com/pratapsingh9/api-catalog-repo/releases/latest/download/final.zip';
  static const String _kRequestId = 'github-specs-fetch';

  Future<List<ApiCatalogModel>> fetchAndStoreSpecs() async {
    try {
      debugPrint('[GitHubSpecs] Starting spec fetch from GitHub...');
      final catalogs = await _downloadAndProcessZip();
      final stored = await _storeInHive(catalogs);
      debugPrint('[GitHubSpecs] Successfully stored ${stored.length} specs');
      return stored;
    } catch (e) {
      debugPrint('[GitHubSpecs] ERROR - Fetch failed: $e');
      rethrow;
    }
  }

  Future<List<ApiCatalogModel>> _downloadAndProcessZip() async {
    try {
      final (response, _, error) = await sendHttpRequest(
        _kRequestId,
        APIType.rest,
        HttpRequestModel(url: _kLatestZipUrl, method: HTTPVerb.get),
      );

      if (error != null) {
        throw _GitHubFetchException('Download failed: $error');
      }
      if (response == null || response.statusCode != 200) {
        throw _GitHubFetchException(
            'Invalid response: ${response?.statusCode ?? 'null'}');
      }

      final catalogs = _extractValidCatalogs(response.bodyBytes);
      if (catalogs.isEmpty) {
        debugPrint('[GitHubSpecs] No valid catalogs found in archive');
      }
      return catalogs;
    } catch (e) {
      debugPrint('[GitHubSpecs] ERROR - Download/processing failed: $e');
      rethrow;
    }
  }

  List<ApiCatalogModel> _extractValidCatalogs(List<int> zipBytes) {
    final archive = ZipDecoder().decodeBytes(zipBytes);
    final catalogs = <ApiCatalogModel>[];

    for (final file in archive.files.where((f) => f.isFile)) {
      try {
        final content = jsonDecode(utf8.decode(file.content));
        if (content is! Map<String, dynamic>) continue;
        if (!_isValidOpenApi(content)) continue;

        final id = _generateCatalogId(file.name);
        final endpoints = _parseOpenApiToEndpoints(content, id);

        final catalog = ApiCatalogModel(
          id: id,
          name: content['info']?['title']?.toString() ?? 'Untitled',
          sourceUrl: _kLatestZipUrl,
          description: content['info']?['description']?.toString() ?? '',
          updatedAt: DateTime.now(),
          version: content['info']?['version']?.toString() ?? '',
          baseUrl: _getBaseUrl(content),
          openApiSpec: content,
          endpoints: endpoints,
          endpointCount: endpoints.length,
          methodCounts: _countMethods(endpoints),
        );

        catalogs.add(catalog);
      } catch (e) {
        debugPrint('Error processing ${file.name}: $e');
      }
    }

    return catalogs;
  }

  List<ApiEndpointModel> _parseOpenApiToEndpoints(
      Map<String, dynamic> spec, String catalogId) {
    final endpoints = <ApiEndpointModel>[];
    final paths = spec['paths'] as Map<String, dynamic>? ?? {};

    for (final pathEntry in paths.entries) {
      final path = pathEntry.key;
      final operations = _getOperations(pathEntry.value);

      for (final methodEntry in operations.entries) {
        final method = _parseHttpVerb(methodEntry.key);
        final operation = methodEntry.value as Map<String, dynamic>;

        endpoints.add(ApiEndpointModel(
          id: '${catalogId}_${methodEntry.key}_${path.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}',
          name: operation['summary']?.toString() ?? path,
          catalogId: catalogId,
          description: operation['description']?.toString() ?? '',
          operationId: operation['operationId']?.toString() ?? '',
          path: path,
          method: method,
          parameters: _parseParameters(operation['parameters']),
          responses: _parseResponses(operation['responses']),
        ));
      }
    }

    return endpoints;
  }

  Map<String, dynamic> _parseParameters(dynamic parameters) {
    if (parameters == null) return {};
    if (parameters is! List) return {};
    
    final result = <String, dynamic>{};
    for (final param in parameters) {
      if (param is Map<String, dynamic>) {
        final name = param['name']?.toString();
        if (name != null) {
          result[name] = param;
        }
      }
    }
    return result;
  }

  Map<String, dynamic> _parseResponses(dynamic responses) {
    if (responses == null) return {};
    if (responses is! Map<String, dynamic>) return {};
    return responses;
  }

  HTTPVerb _parseHttpVerb(String method) {
    switch (method.toLowerCase()) {
      case 'post':
        return HTTPVerb.post;
      case 'put':
        return HTTPVerb.put;
      case 'delete':
        return HTTPVerb.delete;
      case 'patch':
        return HTTPVerb.patch;
      case 'head':
        return HTTPVerb.head;
      default:
        return HTTPVerb.get;
    }
  }

  Map<String, dynamic> _getOperations(Map<String, dynamic> pathItem) {
    return pathItem.entries.fold<Map<String, dynamic>>({}, (map, entry) {
      final key = entry.key.toLowerCase();
      if (['get', 'post', 'put', 'delete', 'patch', 'head'].contains(key)) {
        map[key] = entry.value;
      }
      return map;
    });
  }

  bool _isValidOpenApi(Map<String, dynamic> spec) {
    return (spec.containsKey('openapi') || spec.containsKey('swagger')) &&
        spec['paths'] is Map;
  }

  String _getBaseUrl(Map<String, dynamic> spec) {
    try {
      final servers = spec['servers'] as List?;
      if (servers != null && servers.isNotEmpty) {
        final server = servers[0] as Map?;
        return server?['url']?.toString() ?? '';
      }
    } catch (_) {}
    return '';
  }

  Map<String, int> _countMethods(List<ApiEndpointModel> endpoints) {
    final counts = <String, int>{};
    for (final endpoint in endpoints) {
      final method = endpoint.method.name;
      counts[method] = (counts[method] ?? 0) + 1;
    }
    return counts;
  }

  String _generateCatalogId(String fileName) {
    return 'cat_${fileName.split('.').first.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}';
  }

  Future<List<ApiCatalogModel>> _storeInHive(
      List<ApiCatalogModel> catalogs) async {
    try {
      if (!Hive.isBoxOpen(kApiSpecsBox)) {
        await Hive.openBox(kApiSpecsBox);
      }
      final box = Hive.box(kApiSpecsBox);
      await box.clear();

      for (final catalog in catalogs) {
        await box.put(catalog.id, jsonEncode(catalog.toJson()));
      }

      await box.put(kApiSpecsBoxIds, catalogs.map((c) => c.id).toList());
      return catalogs;
    } catch (e) {
      debugPrint('[GitHubSpecs] ERROR - Hive storage failed: $e');
      throw _GitHubFetchException('Failed to store specs in Hive: $e');
    }
  }
}

class _GitHubFetchException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  _GitHubFetchException(this.message, [this.stackTrace]);

  @override
  String toString() =>
      'GitHubFetchException: $message${stackTrace != null ? '\n$stackTrace' : ''}';
}