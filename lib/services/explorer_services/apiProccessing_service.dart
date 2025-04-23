import 'dart:async';
import 'dart:convert';
import 'package:apidash/models/api_explorer_models.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/foundation.dart';
import 'package:yaml/yaml.dart';

class ApiProcessingService {
  Future<ApiCollection> parseSingleSpec(String content, String source) async {
    try {
      final jsonContent = await _convertToJson(content, source);
      if (!_isValidOpenApi(jsonContent)) {
        throw ApiProcessingException('Invalid OpenAPI specification');
      }

      return ApiCollection(
        id: 'imported_${source.hashCode}',
        name: jsonContent['info']?['title']?.toString() ?? 'Imported API',
        sourceUrl: source,
        description: jsonContent['info']?['description']?.toString(),
        endpoints: _parseOpenApi(jsonContent),
      );
    } catch (e) {
      debugPrint('Error processing spec from $source: $e');
      throw ApiProcessingException('Failed to process API spec: $e');
    }
  }

  Future<Map<String, dynamic>> _convertToJson(
      String content, String source) async {
    try {
      if (_isYaml(source)) {
        return jsonDecode(jsonEncode(loadYaml(content)))
            as Map<String, dynamic>;
      }
      return jsonDecode(content) as Map<String, dynamic>;
    } catch (e) {
      throw ApiProcessingException('Failed to parse $source: $e');
    }
  }

  bool _isValidOpenApi(Map<String, dynamic> spec) {
    return spec.containsKey('openapi') || spec.containsKey('swagger');
  }

  List<ApiEndpoint> _parseOpenApi(Map<String, dynamic> spec) {
    final endpoints = <ApiEndpoint>[];
    final paths = spec['paths'] as Map<String, dynamic>? ?? {};
    final baseUrl = _getBaseUrl(spec);
    final components = spec['components'] as Map<String, dynamic>? ?? {};

    paths.forEach((path, pathData) {
      if (pathData is! Map<String, dynamic>) return;

      pathData.forEach((method, endpointData) {
        if (endpointData is! Map<String, dynamic>) return;

        try {
          final operationId = endpointData['operationId']?.toString() ??
              '${method}_${path}'.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');

          final name = (endpointData['summary'] ??
                  endpointData['operationId'] ??
                  '${method.toUpperCase()} $path')
              .toString();

          endpoints.add(ApiEndpoint(
            id: operationId,
            name: name,
            description: endpointData['description']?.toString(),
            path: path,
            method: _parseHttpMethod(method),
            baseUrl: baseUrl,
            parameters: _parseParameters(
              endpointData['parameters'] as List<dynamic>?,
              components['parameters'] as Map<String, dynamic>?,
            ),
            requestBody: _parseRequestBody(
              endpointData['requestBody'] as Map<String, dynamic>?,
              components['requestBodies'] as Map<String, dynamic>?,
            ),
            headers:
                _parseHeaders(endpointData['headers'] as Map<String, dynamic>?),
            responses: _parseResponses(
              endpointData['responses'] as Map<String, dynamic>?,
              components['responses'] as Map<String, dynamic>?,
            ),
          ));
        } catch (e, stack) {
          debugPrint('Failed to parse endpoint $method $path: $e\n$stack');
        }
      });
    });

    return endpoints;
  }

  HTTPVerb _parseHttpMethod(String method) {
    switch (method.toLowerCase()) {
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
      case 'head':
        return HTTPVerb.head;
      default:
        return HTTPVerb.get;
    }
  }

  List<ApiParameter>? _parseParameters(
    List<dynamic>? parameters,
    Map<String, dynamic>? components,
  ) {
    if (parameters == null) return null;

    return parameters.map((p) {
      if (p is Map<String, dynamic>) {
        // Handle $ref references
        if (p.containsKey('\$ref')) {
          final refPath = p['\$ref'] as String;
          final refParts = refPath.split('/');
          final refKey = refParts.last;
          final componentParam = components?[refKey] as Map<String, dynamic>?;
          if (componentParam != null) {
            return ApiParameter.fromJson(componentParam);
          }
        }
        return ApiParameter.fromJson(p);
      }
      throw ApiProcessingException('Invalid parameter format');
    }).toList();
  }

  ApiRequestBody? _parseRequestBody(
    Map<String, dynamic>? requestBody,
    Map<String, dynamic>? components,
  ) {
    if (requestBody == null) return null;

    // Handle $ref references
    if (requestBody.containsKey('\$ref')) {
      final refPath = requestBody['\$ref'] as String;
      final refParts = refPath.split('/');
      final refKey = refParts.last;
      final componentBody = components?[refKey] as Map<String, dynamic>?;
      if (componentBody != null) {
        return ApiRequestBody.fromJson(componentBody);
      }
    }

    return ApiRequestBody.fromJson(requestBody);
  }

  Map<String, ApiHeader>? _parseHeaders(Map<String, dynamic>? headers) {
    if (headers == null) return null;

    return headers.map((k, v) {
      if (v is Map<String, dynamic>) {
        return MapEntry(k, ApiHeader.fromJson(v));
      }
      throw ApiProcessingException('Invalid header format');
    });
  }

  Map<String, ApiResponse>? _parseResponses(
    Map<String, dynamic>? responses,
    Map<String, dynamic>? components,
  ) {
    if (responses == null) return null;

    return responses.map((statusCode, response) {
      if (response is Map<String, dynamic>) {
        // Handle $ref references
        if (response.containsKey('\$ref')) {
          final refPath = response['\$ref'] as String;
          final refParts = refPath.split('/');
          final refKey = refParts.last;
          final componentResponse =
              components?[refKey] as Map<String, dynamic>?;
          if (componentResponse != null) {
            return MapEntry(
                statusCode, ApiResponse.fromJson(componentResponse));
          }
        }
        return MapEntry(statusCode, ApiResponse.fromJson(response));
      }
      throw ApiProcessingException('Invalid response format');
    });
  }

  String _getBaseUrl(Map<String, dynamic> spec) {
    try {
      if (spec['servers'] is List && (spec['servers'] as List).isNotEmpty) {
        return (spec['servers'][0] as Map<String, dynamic>)['url']
                ?.toString() ??
            '';
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  bool _isYaml(String path) =>
      path.toLowerCase().endsWith('.yaml') ||
      path.toLowerCase().endsWith('.yml');
}

class ApiProcessingException implements Exception {
  final String message;
  ApiProcessingException(this.message);

  @override
  String toString() => 'ApiProcessingException: $message';
}
