import 'dart:async';
import 'dart:convert';
import 'package:apidash/models/api_explorer_models.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

class ApiSpecsRepository {
  static const maxProcessingTime = Duration(seconds: 15);
  final String downloadUrl;

  ApiSpecsRepository({String? downloadUrl})
      : downloadUrl = downloadUrl ??
            'https://github.com/pratapsingh9/api-catalog-repo/releases/latest/download/final.zip';

  Future<List<ApiCollection>> fetchSpecs() async {
    final completer = Completer<List<ApiCollection>>();
    final timer = Timer(maxProcessingTime, () {
      if (!completer.isCompleted) {
        completer
            .completeError(ApiSpecsException('Specs processing timed out'));
      }
    });

    try {
      debugPrint('[API_SPECS] Starting specs fetch');
      final stopwatch = Stopwatch()..start();
      final zipBytes = await downloadSpecsZip();
      final collections = await processZipContents(zipBytes);

      debugPrint(
          '[API_SPECS] Processed ${collections.length} collections in ${stopwatch.elapsedMilliseconds}ms');
      timer.cancel();
      completer.complete(collections);
    } catch (e, stackTrace) {
      timer.cancel();
      debugPrint('[API_SPECS_ERROR] Fetch failed: $e\n$stackTrace');
      completer.completeError(
          e is ApiSpecsException ? e : ApiSpecsException('Fetch failed: $e'));
    }

    return completer.future;
  }

  Future<List<int>> downloadSpecsZip() async {
    const requestId = 'api-specs-fetch';
    try {
      debugPrint('[API_SPECS] Downloading specs ZIP');
      final (zipRes, _, zipErr) = await sendHttpRequest(
        requestId,
        APIType.rest,
        HttpRequestModel(url: downloadUrl, method: HTTPVerb.get),
      );

      if (zipErr != null) throw ApiSpecsException('Download failed: $zipErr');
      if (zipRes == null) throw ApiSpecsException('No response received');
      if (zipRes.statusCode != 200)
        throw ApiSpecsException('HTTP ${zipRes.statusCode}');
      if (zipRes.bodyBytes.isEmpty)
        throw ApiSpecsException('Empty ZIP content');

      return zipRes.bodyBytes;
    } finally {
      httpClientManager.closeClient(requestId);
    }
  }

  Future<List<ApiCollection>> processZipContents(List<int> zipBytes) async {
    try {
      final archive = decodeZipArchive(zipBytes);
      final collections = <ApiCollection>[];
      final errors = <String>[];

      for (final file in archive.files.where((f) => f.isFile)) {
        try {
          if (!file.name.endsWith('.json') &&
              !file.name.endsWith('.yaml') &&
              !file.name.endsWith('.yml')) {
            continue;
          }

          final content = utf8.decode(file.content);
          final json = await compute(_parseJson, content);

          if (!isValidOpenApiSpec(json)) {
            throw ApiSpecsException(
                'Invalid OpenAPI specification in ${file.name}');
          }

          final collection = ApiCollection(
            id: '${path.basenameWithoutExtension(file.name)}_${file.crc32}',
            name: json['info']?['title']?.toString() ?? 'Unnamed Collection',
            description: json['info']?['description']?.toString(),
            endpoints: parseEndpoints(json),
            sourceUrl: json['info']?['contact']?['url']?.toString(),
          );

          collections.add(collection);
        } catch (e) {
          errors.add('Failed to process ${file.name}: $e');
        }
      }

      if (errors.isNotEmpty) {
        debugPrint(
            '[API_SPECS_WARN] Processing completed with ${errors.length} errors');
      }

      if (collections.isEmpty) {
        throw ApiSpecsException(
            'No valid specs found${errors.isNotEmpty ? '. Errors: ${errors.join(", ")}' : ''}');
      }
      return collections;
    } on FormatException {
      throw ApiSpecsException('Invalid ZIP file format');
    } catch (e) {
      throw ApiSpecsException('Failed to process ZIP contents: $e');
    }
  }

  static Future<Map<String, dynamic>> _parseJson(String content) async {
    try {
      return jsonDecode(content) as Map<String, dynamic>;
    } on FormatException catch (e) {
      try {
        return jsonDecode(jsonEncode(loadYaml(content)))
            as Map<String, dynamic>;
      } catch (_) {
        throw ApiSpecsException('Invalid JSON/YAML: ${e.message}');
      }
    }
  }

  List<ApiEndpoint> parseEndpoints(Map<String, dynamic> specJson) {
    final endpoints = <ApiEndpoint>[];
    final paths = specJson['paths'] as Map<String, dynamic>? ?? {};
    final baseUrl = specJson['servers']?[0]?['url']?.toString() ?? '';

    paths.forEach((path, pathData) {
      if (pathData is! Map<String, dynamic>) return;

      pathData.forEach((method, endpointData) {
        if (endpointData is! Map<String, dynamic>) return;

        try {
          final endpointName = (endpointData['summary'] ??
                      endpointData['operationId'] ??
                      '${method.toUpperCase()} $path')
                  ?.toString() ??
              '${method.toUpperCase()} $path';

          endpoints.add(ApiEndpoint(
            id: '${path}_${method}'.hashCode.toString(),
            name: endpointName,
            description: endpointData['description']?.toString(),
            path: path,
            method: HTTPVerb.values.firstWhere(
              (v) => v.name.toLowerCase() == method.toLowerCase(),
              orElse: () => HTTPVerb.get,
            ),
            baseUrl: baseUrl,
            parameters:
                parseParameters(endpointData['parameters'] as List<dynamic>?),
            requestBody: parseRequestBody(
                endpointData['requestBody'] as Map<String, dynamic>?),
            headers:
                parseHeaders(endpointData['headers'] as Map<String, dynamic>?),
            responses: parseResponses(
                endpointData['responses'] as Map<String, dynamic>?),
          ));
        } catch (e, stack) {
          debugPrint(
              '[API_SPECS_WARN] Failed to parse endpoint $method $path: $e\n$stack');
        }
      });
    });

    return endpoints;
  }

  bool isValidOpenApiSpec(Map<String, dynamic> json) {
    return json.containsKey('openapi') || json.containsKey('swagger');
  }

  Archive decodeZipArchive(List<int> bytes) {
    try {
      final archive = ZipDecoder().decodeBytes(bytes);
      if (archive.files.isEmpty) throw ApiSpecsException('Empty ZIP archive');
      return archive;
    } catch (e) {
      throw ApiSpecsException('ZIP extraction failed: $e');
    }
  }

  List<ApiParameter>? parseParameters(List<dynamic>? parameters) {
    if (parameters == null) return null;

    return parameters
        .map((p) {
          if (p is! Map<String, dynamic>) return null;
          try {
            final schema = p['schema'] != null
                ? ApiSchema.fromJson(p['schema'] as Map<String, dynamic>)
                : null;
            return ApiParameter(
              name: p['name']?.toString() ?? '',
              inLocation: p['in']?.toString() ?? 'query',
              description: p['description']?.toString(),
              required: p['required'] as bool? ?? false,
              schema: schema,
              example: p['example']?.toString(),
            );
          } catch (e) {
            debugPrint('[API_SPECS_WARN] Failed to parse parameter: $e');
            return null;
          }
        })
        .where((p) => p != null)
        .cast<ApiParameter>()
        .toList();
  }

  ApiRequestBody? parseRequestBody(Map<String, dynamic>? requestBody) {
    if (requestBody == null) return null;

    try {
      final content = (requestBody['content'] as Map<String, dynamic>?)
          ?.entries
          .where((entry) => entry.value['schema'] != null)
          .map((entry) {
        final schema =
            ApiSchema.fromJson(entry.value['schema'] as Map<String, dynamic>);
        return MapEntry(entry.key, ApiContent(schema: schema));
      }).toList();

      return ApiRequestBody(
        description: requestBody['description']?.toString(),
        content: content != null ? Map.fromEntries(content) : {},
      );
    } catch (e) {
      debugPrint('[API_SPECS_WARN] Failed to parse request body: $e');
      return null;
    }
  }

  Map<String, ApiHeader>? parseHeaders(Map<String, dynamic>? headers) {
    if (headers == null) return null;

    final result = <String, ApiHeader>{};

    headers.forEach((key, value) {
      try {
        if (value is! Map<String, dynamic>) return;
        final schema = value['schema'] != null
            ? ApiSchema.fromJson(value['schema'] as Map<String, dynamic>)
            : null;
        if (schema != null) {
          result[key] = ApiHeader(
            description: value['description']?.toString(),
            required: value['required'] as bool? ?? false,
            schema: schema,
            example: value['example']?.toString(),
          );
        }
      } catch (e) {
        debugPrint('[API_SPECS_WARN] Failed to parse header $key: $e');
      }
    });

    return result;
  }

  Map<String, ApiResponse>? parseResponses(Map<String, dynamic>? responses) {
    if (responses == null) return null;

    final result = <String, ApiResponse>{};

    responses.forEach((statusCode, response) {
      try {
        if (response is! Map<String, dynamic>) return;
        final content = (response['content'] as Map<String, dynamic>?)
            ?.entries
            .where((entry) => entry.value['schema'] != null)
            .map((entry) {
          final schema =
              ApiSchema.fromJson(entry.value['schema'] as Map<String, dynamic>);
          return MapEntry(entry.key, ApiContent(schema: schema));
        }).toList();

        result[statusCode] = ApiResponse(
          description: response['description']?.toString(),
          content: content != null ? Map.fromEntries(content) : {},
        );
      } catch (e) {
        debugPrint('[API_SPECS_WARN] Failed to parse response $statusCode: $e');
      }
    });

    return result;
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
