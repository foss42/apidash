import 'dart:async';
import 'dart:convert';
import 'package:apidash/models/api_explorer_models.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;

class ApiSpecsRepository {
  static const Duration _maxProcessingTime = Duration(seconds: 15);
  final String _downloadUrl;

  ApiSpecsRepository({String? downloadUrl})
      : _downloadUrl = downloadUrl ??
            'https://github.com/pratapsingh9/api-catalog-repo/releases/latest/download/final.zip';

  Future<List<ApiCollection>> fetchSpecs() async {
    final completer = Completer<List<ApiCollection>>();
    final timer = Timer(_maxProcessingTime, () {
      if (!completer.isCompleted) {
        completer.completeError(ApiSpecsException('Specs processing timed out'));
      }
    });

    try {
      debugPrint('[API_SPECS] Starting specs fetch');
      final stopwatch = Stopwatch()..start();
      final zipBytes = await _downloadSpecsZip();
      final collections = await _processZipContents(zipBytes);
      
      debugPrint('[API_SPECS] Processed ${collections.length} collections in ${stopwatch.elapsedMilliseconds}ms');
      timer.cancel();
      completer.complete(collections);
    } catch (e, stackTrace) {
      timer.cancel();
      debugPrint('[API_SPECS_ERROR] Fetch failed: $e\n$stackTrace');
      completer.completeError(e is ApiSpecsException ? e : ApiSpecsException('Fetch failed: $e'));
    }

    return completer.future;
  }

  Future<List<int>> _downloadSpecsZip() async {
    const requestId = 'api-specs-fetch';
    try {
      debugPrint('[API_SPECS] Downloading specs ZIP');
      final (zipRes, _, zipErr) = await sendHttpRequest(
        requestId,
        APIType.rest,
        HttpRequestModel(url: _downloadUrl, method: HTTPVerb.get),
      );

      if (zipErr != null) throw ApiSpecsException('Download failed: $zipErr');
      if (zipRes == null) throw ApiSpecsException('No response received');
      if (zipRes.statusCode != 200) throw ApiSpecsException('HTTP ${zipRes.statusCode}');
      if (zipRes.bodyBytes.isEmpty) throw ApiSpecsException('Empty ZIP content');

      return zipRes.bodyBytes;
    } finally {
      httpClientManager.closeClient(requestId);
    }
  }

  Future<List<ApiCollection>> _processZipContents(List<int> zipBytes) async {
    try {
      final archive = _decodeZipArchive(zipBytes);
      final collections = <ApiCollection>[];
      final jsonFiles = archive.files.where((f) => f.isFile && f.name.endsWith('.json'));

      await Future.wait(jsonFiles.map((file) async {
        try {
          final content = utf8.decode(file.content);
          final json = jsonDecode(content) as Map<String, dynamic>;
          
          if (!_isValidOpenApiSpec(json)) {
            throw ApiSpecsException('Invalid OpenAPI specification');
          }

          final collection = ApiCollection(
            id: path.basename(file.name),
            name: json['info']?['title']?.toString() ?? 'Unnamed Collection',
            description: json['info']?['description']?.toString(),
            endpoints: _parseEndpoints(json),
            sourceUrl: json['info']?['contact']?['url']?.toString(),
          );

          collections.add(collection);
          debugPrint('[API_SPECS] Processed file: ${file.name}');
        } catch (e) {
          debugPrint('[API_SPECS_WARN] Failed to process file: $e');
        }
      }));

      if (collections.isEmpty) throw ApiSpecsException('No valid specs found');
      return collections;
    } on FormatException {
      throw ApiSpecsException('Invalid ZIP file format');
    } catch (e) {
      throw ApiSpecsException('Failed to process ZIP contents: $e');
    }
  }

  List<ApiEndpoint> _parseEndpoints(Map<String, dynamic> specJson) {
    final endpoints = <ApiEndpoint>[];
    final paths = specJson['paths'] as Map<String, dynamic>? ?? {};
    final baseUrl = specJson['servers']?[0]?['url']?.toString() ?? '';

    paths.forEach((path, pathData) {
      if (pathData is! Map<String, dynamic>) return;

      pathData.forEach((method, endpointData) {
        if (endpointData is! Map<String, dynamic>) return;

        try {
          endpoints.add(ApiEndpoint(
            id: '${path}_${method}',
            name: (endpointData['summary'] ?? '${method.toUpperCase()} $path').toString(),
            description: endpointData['description']?.toString(),
            path: path,
            method: HTTPVerb.values.firstWhere(
              (v) => v.name.toLowerCase() == method.toLowerCase(),
              orElse: () => HTTPVerb.get,
            ),
            baseUrl: baseUrl,
            parameters: _parseParameters(endpointData['parameters'] as List<dynamic>?),
            requestBody: _parseRequestBody(endpointData['requestBody'] as Map<String, dynamic>?),
            headers: _parseHeaders(endpointData['headers'] as Map<String, dynamic>?),
            responses: _parseResponses(endpointData['responses'] as Map<String, dynamic>?),
          ));
        } catch (e) {
          debugPrint('[API_SPECS_WARN] Failed to parse endpoint $method $path: $e');
        }
      });
    });

    return endpoints;
  }

  bool _isValidOpenApiSpec(Map<String, dynamic> json) {
    return json.containsKey('openapi') || json.containsKey('swagger');
  }

  Archive _decodeZipArchive(List<int> bytes) {
    try {
      final archive = ZipDecoder().decodeBytes(bytes);
      if (archive.files.isEmpty) throw ApiSpecsException('Empty ZIP archive');
      return archive;
    } catch (e) {
      throw ApiSpecsException('ZIP extraction failed: $e');
    }
  }

  List<ApiParameter>? _parseParameters(List<dynamic>? parameters) {
    if (parameters == null) return null;
    return parameters.map((p) => ApiParameter.fromJson(p as Map<String, dynamic>)).toList();
  }

  ApiRequestBody? _parseRequestBody(Map<String, dynamic>? requestBody) {
    if (requestBody == null) return null;
    return ApiRequestBody.fromJson(requestBody);
  }

  Map<String, ApiHeader>? _parseHeaders(Map<String, dynamic>? headers) {
    if (headers == null) return null;
    return headers.map((k, v) => MapEntry(k, ApiHeader.fromJson(v as Map<String, dynamic>)));
  }

  Map<String, ApiResponse>? _parseResponses(Map<String, dynamic>? responses) {
    if (responses == null) return null;
    return responses.map((k, v) => MapEntry(k, ApiResponse.fromJson(v as Map<String, dynamic>)));
  }
}

class ApiSpecsException implements Exception {
  final String message;
  final String? details;

  ApiSpecsException(this.message, [this.details]);

  @override
  String toString() => details != null 
      ? 'ApiSpecsException: $message ($details)'
      : 'ApiSpecsException: $message';
}