import 'dart:convert';
import 'package:apidash/models/api_explorer_models.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/foundation.dart';
import 'package:yaml/yaml.dart';

class ApiProcessingService {
  Future<ApiCollection> parseSingleSpec(String content, String source) async {
    try {
      final json = await _convertToJson(content, source);
      if (!_isValidOpenApi(json)) {
        throw ApiProcessingException('Invalid OpenAPI specification');
      }

      return ApiCollection(
        id: 'imported_${source.hashCode}',
        name: json['info']?['title']?.toString() ?? 'Imported API',
        sourceUrl: source,
        description: json['info']?['description']?.toString(),
        endpoints: _parseOpenApi(json),
      );
    } catch (e) {
      debugPrint('Error processing spec from $source: $e');
      throw ApiProcessingException('Failed to process API spec: $e');
    }
  }

 Future<Map<String, dynamic>> _convertToJson(String content, String source) async {
  try {
    try {
      return jsonDecode(content) as Map<String, dynamic>;
    } on FormatException {
      return jsonDecode(jsonEncode(loadYaml(content))) as Map<String, dynamic>;
    }
  } catch (e) {
    throw ApiProcessingException('Failed to parse content. Neither valid JSON nor YAML: $e');
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
          endpoints.add(_parseEndpoint(
            path: path,
            method: method,
            endpointData: endpointData,
            components: components,
            baseUrl: baseUrl,
          ));
        } catch (e, stack) {
          debugPrint('Failed to parse endpoint $method $path: $e\n$stack');
        }
      });
    });

    return endpoints;
  }

  ApiEndpoint _parseEndpoint({
    required String path,
    required String method,
    required Map<String, dynamic> endpointData,
    required Map<String, dynamic> components,
    required String baseUrl,
  }) {
    final operationId = endpointData['operationId']?.toString() ??
        '${method}_${path}'.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');

    return ApiEndpoint(
      id: operationId,
      name: (endpointData['summary'] ?? 
            endpointData['operationId'] ?? 
            '${method.toUpperCase()} $path').toString(),
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
      headers: _parseHeaders(endpointData['headers'] as Map<String, dynamic>?),
      responses: _parseResponses(
        endpointData['responses'] as Map<String, dynamic>?,
        components['responses'] as Map<String, dynamic>?,
      ),
    );
  }

  HTTPVerb _parseHttpMethod(String method) {
    switch (method.toLowerCase()) {
      case 'get': return HTTPVerb.get;
      case 'post': return HTTPVerb.post;
      case 'put': return HTTPVerb.put;
      case 'delete': return HTTPVerb.delete;
      case 'patch': return HTTPVerb.patch;
      case 'head': return HTTPVerb.head;
      default: return HTTPVerb.get;
    }
  }

  List<ApiParameter>? _parseParameters(
    List<dynamic>? parameters,
    Map<String, dynamic>? components,
  ) {
    if (parameters == null) return null;
    return parameters.map((p) {
      if (p is! Map<String, dynamic>) throw ApiProcessingException('Invalid parameter format');
      return ApiParameter.fromJson(_resolveRef(p, components));
    }).toList();
  }

  ApiRequestBody? _parseRequestBody(
    Map<String, dynamic>? requestBody,
    Map<String, dynamic>? components,
  ) {
    if (requestBody == null) return null;
    return ApiRequestBody.fromJson(_resolveRef(requestBody, components));
  }

  Map<String, ApiHeader>? _parseHeaders(Map<String, dynamic>? headers) {
    if (headers == null) return null;
    return headers.map((k, v) {
      if (v is! Map<String, dynamic>) throw ApiProcessingException('Invalid header format');
      return MapEntry(k, ApiHeader.fromJson(v));
    });
  }

  Map<String, ApiResponse>? _parseResponses(
    Map<String, dynamic>? responses,
    Map<String, dynamic>? components,
  ) {
    if (responses == null) return null;
    return responses.map((statusCode, response) {
      if (response is! Map<String, dynamic>) throw ApiProcessingException('Invalid response format');
      return MapEntry(statusCode, ApiResponse.fromJson(_resolveRef(response, components)));
    });
  }

  Map<String, dynamic> _resolveRef(Map<String, dynamic> item, Map<String, dynamic>? components) {
    if (item.containsKey('\$ref')) {
      final refPath = item['\$ref'] as String;
      final refKey = refPath.split('/').last;
      return components?[refKey] ?? item;
    }
    return item;
  }

  String _getBaseUrl(Map<String, dynamic> spec) {
    try {
      if (spec['servers'] is List && (spec['servers'] as List).isNotEmpty) {
        return (spec['servers'][0] as Map<String, dynamic>)['url']?.toString() ?? '';
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  bool _isYaml(String path) => path.toLowerCase().endsWith('.yaml') || 
                            path.toLowerCase().endsWith('.yml');
}

class ApiProcessingException implements Exception {
  final String message;
  ApiProcessingException(this.message);
  @override
  String toString() => 'ApiProcessingException: $message';
}