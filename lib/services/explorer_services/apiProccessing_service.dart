import 'dart:async';
import 'dart:convert';
import 'package:apidash/models/api_explorer_models.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/foundation.dart';
import 'package:yaml/yaml.dart';

class ApiProcessingService {
  Future<List<ApiCollection>> processHiveSpecs(Map<String, String> hiveSpecs) async {
    final collections = <ApiCollection>[];
    final futures = <Future>[];

    for (final entry in hiveSpecs.entries) {
      if (entry.key == '_spec_names') continue;
      
      futures.add(_processSpecEntry(entry).then((collection) {
        if (collection != null) {
          collections.add(collection);
        }
      }));
    }

    await Future.wait(futures);
    return collections;
  }

  Future<ApiCollection?> _processSpecEntry(MapEntry<String, String> entry) async {
    try {
      final jsonContent = await _convertToJson(entry.value, entry.key);
      if (!_isValidOpenApi(jsonContent)) {
        debugPrint('Invalid OpenAPI spec: ${entry.key}');
        return null;
      }

      return ApiCollection(
        id: 'col_${entry.key.hashCode}',
        name: jsonContent['info']['title']?.toString() ?? entry.key,
        sourceUrl: _getBaseUrl(jsonContent),
        description: jsonContent['info']['description']?.toString() ?? '',
        endpoints: _parseOpenApi(jsonContent),
      );
    } catch (e) {
      debugPrint('Error processing ${entry.key}: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> _convertToJson(String content, String source) async {
    try {
      if (_isYaml(source)) {
        return jsonDecode(jsonEncode(loadYaml(content))) as Map<String, dynamic>;
      }
      return jsonDecode(content) as Map<String, dynamic>;
    } catch (e) {
      throw ApiProcessingException('Failed to parse $source: $e');
    }
  }

  bool _isValidOpenApi(Map<String, dynamic> spec) {
    try {
      final version = spec['openapi'] ?? spec['swagger'];
      if (version == null) return false;
      if (spec['paths'] is! Map || spec['info'] is! Map) return false;
      return true;
    } catch (e) {
      return false;
    }
  }

  List<ApiEndpoint> _parseOpenApi(Map<String, dynamic> spec) {
    final endpoints = <ApiEndpoint>[];
    final paths = spec['paths'] as Map<String, dynamic>? ?? {};
    final components = spec['components'] as Map<String, dynamic>? ?? {};

    paths.forEach((path, pathItem) {
      final normalizedPath = _normalizePath(path);
      final pathItemMap = pathItem as Map<String, dynamic>;

      for (final method in ['get', 'post', 'put', 'delete', 'patch', 'head']) {
        if (pathItemMap.containsKey(method)) {
          final operation = pathItemMap[method] as Map<String, dynamic>;
          endpoints.add(_createEndpoint(
            operation,
            path: normalizedPath,
            method: method,
            baseUrl: _getBaseUrl(spec),
            components: components,
            pathItem: pathItemMap,
          ));
        }
      }
    });

    return endpoints;
  }

  ApiEndpoint _createEndpoint(
    Map<String, dynamic> operation, {
    required String path,
    required String method,
    required String baseUrl,
    required Map<String, dynamic> components,
    required Map<String, dynamic> pathItem,
  }) {
    // Combine path-level and operation-level parameters
    final pathParameters = (pathItem['parameters'] as List<dynamic>? ?? []);
    final operationParameters = (operation['parameters'] as List<dynamic>? ?? []);
    final allParameters = [...pathParameters, ...operationParameters];

    return ApiEndpoint(
      id: '${method}_${path}_${operation['operationId'] ?? path.hashCode}',
      name: operation['summary'] ?? operation['operationId'] ?? path,
      description: operation['description']?.toString(),
      path: path,
      method: HTTPVerb.values.firstWhere(
        (e) => e.name.toLowerCase() == method.toLowerCase(),
        orElse: () => HTTPVerb.get,
      ),
      baseUrl: baseUrl,
      parameters: _parseParameters(allParameters, components),
      requestBody: operation['requestBody'] != null
          ? _parseRequestBody(operation['requestBody'], components)
          : null,
      headers: _parseHeaders(operation, components),
      responses: _parseResponses(operation['responses'], components),
    );
  }

  List<ApiParameter> _parseParameters(
    List<dynamic> parameters,
    Map<String, dynamic> components,
  ) {
    return parameters.map((param) {
      try {
        if (param is Map && param.containsKey(r'$ref')) {
          param = _resolveRef(param[r'$ref'] as String, components);
        }

        return ApiParameter(
          name: param['name']?.toString() ?? '',
          inLocation: param['in']?.toString() ?? 'query',
          description: param['description']?.toString(),
          required: param['required'] == true,
          schema: _parseSchema(param['schema'], components),
          example: param['example']?.toString() ?? 
              _getDefaultExample(param['schema']),
        );
      } catch (e) {
        debugPrint('Error parsing parameter: $e');
        return ApiParameter(name: 'invalid', inLocation: 'query');
      }
    }).where((p) => p.name.isNotEmpty).toList();
  }

  Map<String, ApiHeader> _parseHeaders(
    Map<String, dynamic> operation,
    Map<String, dynamic> components,
  ) {
    final headers = <String, ApiHeader>{};
    final parameters = _parseParameters(operation['parameters'], components)
        .where((p) => p.inLocation == 'header');

    for (final param in parameters) {
      headers[param.name] = ApiHeader(
        description: param.description,
        required: param.required,
        schema: param.schema,
        example: param.example,
      );
    }

    return headers;
  }

  ApiRequestBody? _parseRequestBody(
    dynamic requestBody,
    Map<String, dynamic> components,
  ) {
    try {
      if (requestBody is! Map) return null;
      if (requestBody.containsKey(r'$ref')) {
        requestBody = _resolveRef(requestBody[r'$ref'] as String, components);
      }

      return ApiRequestBody(
        description: requestBody['description']?.toString(),
        content: _parseContent(requestBody['content'], components),
      );
    } catch (e) {
      debugPrint('Error parsing request body: $e');
      return null;
    }
  }

  Map<String, ApiResponse> _parseResponses(
    dynamic responses,
    Map<String, dynamic> components,
  ) {
    final result = <String, ApiResponse>{};
    if (responses is! Map) return result;

    responses.forEach((code, response) {
      try {
        result[code.toString()] = ApiResponse(
          description: response['description']?.toString(),
          content: _parseContent(response['content'], components),
        );
      } catch (e) {
        debugPrint('Error parsing response $code: $e');
      }
    });

    return result;
  }

  Map<String, ApiContent> _parseContent(
    dynamic content,
    Map<String, dynamic> components,
  ) {
    final result = <String, ApiContent>{};
    if (content is! Map) return result;

    content.forEach((contentType, contentData) {
      try {
        result[contentType.toString()] = ApiContent(
          schema: _parseSchema(contentData['schema'], components) ?? ApiSchema(type: 'unknown'),
        );
      } catch (e) {
        debugPrint('Error parsing content $contentType: $e');
      }
    });

    return result;
  }

  ApiSchema? _parseSchema(
    dynamic schema,
    Map<String, dynamic> components,
  ) {
    try {
      if (schema == null) return null;
      if (schema is Map && schema.containsKey(r'$ref')) {
        return _parseSchema(_resolveRef(schema[r'$ref'] as String, components), components);
      }
      if (schema is! Map) return null;

      return ApiSchema(
        type: schema['type']?.toString(),
        format: schema['format']?.toString(),
        description: schema['description']?.toString(),
        example: schema['example']?.toString(),
        items: _parseSchema(schema['items'], components),
        properties: _parseProperties(schema['properties'], components),
      );
    } catch (e) {
      debugPrint('Error parsing schema: $e');
      return null;
    }
  }

  Map<String, ApiSchema>? _parseProperties(
    dynamic properties,
    Map<String, dynamic> components,
  ) {
    if (properties is! Map) return null;
    final result = <String, ApiSchema>{};

    properties.forEach((key, value) {
      try {
        final schema = _parseSchema(value, components);
        if (schema != null) {
          result[key.toString()] = schema;
        }
      } catch (e) {
        debugPrint('Error parsing property $key: $e');
      }
    });

    return result.isNotEmpty ? result : null;
  }

  dynamic _resolveRef(String ref, Map<String, dynamic> components) {
    try {
      final parts = ref.split('/').skip(2).toList();
      dynamic current = components;

      for (final part in parts) {
        current = current[part];
        if (current == null) break;
      }

      return current is Map ? Map<String, dynamic>.from(current) : null;
    } catch (e) {
      debugPrint('Error resolving reference $ref: $e');
      return null;
    }
  }

  String _getBaseUrl(Map<String, dynamic> spec) {
    try {
      if (spec['servers'] is List && spec['servers'].isNotEmpty) {
        return spec['servers'][0]['url']?.toString() ?? '';
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  String _getDefaultExample(dynamic schema) {
    if (schema is Map) {
      switch (schema['type']?.toString()) {
        case 'integer':
        case 'number':
          return '1';
        case 'boolean':
          return 'true';
        default:
          return 'example';
      }
    }
    return 'example';
  }

  bool _isYaml(String path) => 
      path.toLowerCase().endsWith('.yaml') || 
      path.toLowerCase().endsWith('.yml');

  String _normalizePath(String path) => 
      path.replaceAllMapped(RegExp(r':(\w+)'), (m) => '{${m.group(1)}}');
}

class ApiProcessingException implements Exception {
  final String message;
  ApiProcessingException(this.message);
  
  @override
  String toString() => 'ApiProcessingException: $message';
}