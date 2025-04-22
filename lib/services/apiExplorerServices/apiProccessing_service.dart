import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:yaml/yaml.dart';

class ApiProcessingService {
Future<List<Map<String, dynamic>>> processHiveSpecs(
  Map<String, dynamic> hiveSpecs,
) async {
  final collections = <Map<String, dynamic>>[];

  for (final entry in hiveSpecs.entries) {
    try {
      if (entry.key == '_spec_names') continue;
      final jsonContent = await _convertToJson(entry.value, entry.key);

      if (!_isValidOpenApi(jsonContent)) {
        debugPrint('Invalid OpenAPI spec: ${entry.key}');
        continue;
      }

      collections.add({
        'id': 'cat_${entry.key}',
        'name': jsonContent['info']['title'] ?? entry.key,
        'sourceUrl': _getBaseUrl(jsonContent),
        'description': jsonContent['info']['description'] ?? '',
        'endpoints': _parseOpenApi(jsonContent),
      });
    } catch (e) {
      debugPrint('Error processing ${entry.key}: $e');
    }
  }

  debugPrint('Successfully processed ${collections.length} collections');
  return collections;
}

  List<Map<String, dynamic>> _createEndpointsFromCatalog(Map<String, dynamic> catalog) {
  return [
    {
      'id': '${catalog['id']}-root',
      'name': 'Root Endpoint',
      'path': '/',
      'method': 'GET',
      'baseUrl': catalog['sourceUrl'],
      'description': catalog['description'],
    }
  ];
}

  Future<List<Map<String, dynamic>>> parseOpenApiContent(
    String content,
    String source,
  ) async {
    try {
      final jsonContent = await _convertToJson(content, source);

      if (!_isValidOpenApi(jsonContent)) {
        throw const FormatException('Invalid OpenAPI specification');
      }

      final endpoints = _parseOpenApi(jsonContent);
      if (endpoints.isEmpty) {
        throw const FormatException('No endpoints found in specification');
      }

      return endpoints;
    } catch (e) {
      debugPrint('[API Processor] Error parsing OpenAPI content: $e');
      rethrow;
    }
  }

  Map<String, dynamic> _createCollectionFromSpec(
    Map<String, dynamic> spec, {
    required String source,
    required String idPrefix,
  }) {
    try {
      if (!_isValidOpenApi(spec)) {
        debugPrint('[API Processor] Invalid OpenAPI spec from $source');
        return {};
      }

      final endpoints = _parseOpenApi(spec);
      if (endpoints.isEmpty) {
        debugPrint('[API Processor] No endpoints found in $source');
        return {};
      }

      final collection = {
        'id': '$idPrefix-${DateTime.now().millisecondsSinceEpoch}',
        'name': spec['info']?['title']?.toString() ?? _getSourceName(source),
        'source': source,
        'updatedAt': DateTime.now().toIso8601String(),
        'endpoints': endpoints,
      };

      debugPrint('[API Processor] Created collection: ${collection['name']}');
      return collection;
    } catch (e) {
      debugPrint('[API Processor] Error creating collection from $source: $e');
      return {};
    }
  }

  List<Map<String, dynamic>> _parseOpenApi(Map<String, dynamic> spec) {
    try {
      final endpoints = <Map<String, dynamic>>[];
      final paths = spec['paths'] as Map<String, dynamic>? ?? {};
      final components = spec['components'] as Map<String, dynamic>? ?? {};

      for (final pathEntry in paths.entries) {
        final path = _normalizePath(pathEntry.key);
        final pathItem = pathEntry.value as Map<String, dynamic>;

        final operations = _getOperations(pathItem);

        for (final methodEntry in operations.entries) {
          final method = methodEntry.key.toUpperCase();
          final operation = methodEntry.value as Map<String, dynamic>;

          // Combine path-level and operation-level parameters
          final pathParameters =
              (pathItem['parameters'] as List<dynamic>? ?? []);
          final operationParameters =
              (operation['parameters'] as List<dynamic>? ?? []);
          final allParameters = [...pathParameters, ...operationParameters];

          endpoints.add(_createEndpointFromOperation(
            operation,
            path: path,
            method: method,
            baseUrl: _getBaseUrl(spec),
            components: components,
            parameters: allParameters,
          ));
        }
      }

      return endpoints;
    } catch (e) {
      debugPrint('[API Processor] Error parsing OpenAPI paths: $e');
      return [];
    }
  }

  Map<String, dynamic> _createEndpointFromOperation(
    Map<String, dynamic> operation, {
    required String path,
    required String method,
    required String baseUrl,
    required Map<String, dynamic> components,
    required List<dynamic> parameters,
  }) {
    return {
      'id':
          '${method}_${path}_${operation['operationId'] ?? '${path.hashCode}'}',
      'name': operation['summary'] ?? operation['operationId'] ?? path,
      'description': operation['description'],
      'path': path,
      'method': method,
      'baseUrl': baseUrl,
      'parameters': _parseParameters(parameters, components),
      'requestBody': operation['requestBody'] != null
          ? _parseRequestBody(operation['requestBody'], components)
          : null,
      'headers': _parseHeaders(operation, components),
      'responses': _parseResponses(operation['responses'], components),
    };
  }

  String _getBaseUrl(Map<String, dynamic> spec) {
    try {
      if (spec['servers'] is List && spec['servers'].isNotEmpty) {
        return spec['servers'][0]['url']?.toString() ?? '';
      }
      return '';
    } catch (e) {
      debugPrint('[API Processor] Error getting base URL: $e');
      return '';
    }
  }

  List<Map<String, dynamic>> _parseParameters(
    dynamic parameters,
    Map<String, dynamic> components,
  ) {
    if (parameters is! List) return [];

    return parameters
        .map<Map<String, dynamic>>((param) {
          try {
            if (param is Map && param.containsKey(r'$ref')) {
              param = _resolveRef(param[r'$ref'] as String, components);
            }

            // Extract example from parameter or schema
            dynamic example = param['example'];
            if (example == null) {
              final schema = param['schema'] as Map<String, dynamic>?;
              if (schema != null) {
                example = schema['example'] ?? _getDefaultExample(schema);
              }
            }

            return {
              'name': param['name']?.toString() ?? '',
              'in': param['in']?.toString() ?? 'query',
              'description': param['description'],
              'required': param['required'] == true,
              'schema': _parseSchema(param['schema'], components),
              'example':
                  example?.toString() ?? _getDefaultExample(param['schema']),
            };
          } catch (e) {
            debugPrint('[API Processor] Error parsing parameter: $e');
            return {};
          }
        })
        .where((p) => p.isNotEmpty)
        .toList();
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

  Map<String, dynamic> _parseHeaders(
    Map<String, dynamic> operation,
    Map<String, dynamic> components,
  ) {
    try {
      final headers = <String, dynamic>{};
      final parameters = _parseParameters(operation['parameters'], components)
          .where((p) => p['in'] == 'header');

      for (final param in parameters) {
        headers[param['name']] = param;
      }

      return headers;
    } catch (e) {
      debugPrint('[API Processor] Error parsing headers: $e');
      return {};
    }
  }

  Map<String, dynamic> _parseRequestBody(
    dynamic requestBody,
    Map<String, dynamic> components,
  ) {
    try {
      if (requestBody is! Map) return {};
      if (requestBody.containsKey(r'$ref')) {
        requestBody = _resolveRef(requestBody[r'$ref'] as String, components);
      }

      return {
        'description': requestBody['description'],
        'content': _parseContent(requestBody['content'], components),
      };
    } catch (e) {
      debugPrint('[API Processor] Error parsing request body: $e');
      return {};
    }
  }

  Map<String, dynamic> _parseResponses(
    dynamic responses,
    Map<String, dynamic> components,
  ) {
    try {
      final result = <String, dynamic>{};
      if (responses is! Map) return result;

      for (final entry in responses.entries) {
        result[entry.key] = {
          'description': entry.value['description'],
          'content': _parseContent(entry.value['content'], components),
        };
      }

      return result;
    } catch (e) {
      debugPrint('[API Processor] Error parsing responses: $e');
      return {};
    }
  }

  Map<String, dynamic> _parseContent(
    dynamic content,
    Map<String, dynamic> components,
  ) {
    try {
      final result = <String, dynamic>{};
      if (content is! Map) return result;

      for (final entry in content.entries) {
        result[entry.key] = {
          'schema': _parseSchema(entry.value['schema'], components),
        };
      }

      return result;
    } catch (e) {
      debugPrint('[API Processor] Error parsing content: $e');
      return {};
    }
  }

  Map<String, dynamic> _parseSchema(
    dynamic schema,
    Map<String, dynamic> components,
  ) {
    try {
      if (schema is Map && schema.containsKey(r'$ref')) {
        return _parseSchema(
          _resolveRef(schema[r'$ref'] as String, components),
          components,
        );
      }

      if (schema is! Map) return {};

      return {
        'type': schema['type'],
        'format': schema['format'],
        'description': schema['description'],
        'example': schema['example'],
        'items': _parseSchema(schema['items'], components),
        'properties': _parseProperties(schema['properties'], components),
      };
    } catch (e) {
      debugPrint('[API Processor] Error parsing schema: $e');
      return {};
    }
  }

  Map<String, dynamic> _parseProperties(
    dynamic properties,
    Map<String, dynamic> components,
  ) {
    try {
      if (properties is! Map) return {};

      return properties.map<String, dynamic>((key, value) {
        return MapEntry(
          key.toString(),
          _parseSchema(value, components),
        );
      });
    } catch (e) {
      debugPrint('[API Processor] Error parsing properties: $e');
      return {};
    }
  }

  Map<String, dynamic> _resolveRef(
    String ref,
    Map<String, dynamic> components,
  ) {
    try {
      final parts = ref.split('/').skip(2).toList();
      dynamic current = components;

      for (final part in parts) {
        current = current[part];
        if (current == null) break;
      }

      return current is Map ? Map<String, dynamic>.from(current) : {};
    } catch (e) {
      debugPrint('[API Processor] Error resolving reference: $e');
      return {};
    }
  }
  Future<Map<String, dynamic>> _convertToJson(
    dynamic content, // This 'content' IS the JSON STRING from Hive
    String source,   // source ends with .json
  ) async {
    try {
      if (content is String) {
        final rawContent = content; // Use the original string

        // REMOVED the .replaceAll lines that caused the problem

        // Keep the YAML check just in case, though it won't run for .json
        if (_isYaml(source)) {
          try {
            final yamlMap = loadYaml(rawContent);
            return jsonDecode(jsonEncode(yamlMap)) as Map<String, dynamic>;
          } catch (e) {
            debugPrint("YAML parsing failed for $source, trying JSON fallback: $e");
            // Fallback will parse rawContent as JSON
            return jsonDecode(rawContent) as Map<String, dynamic>;
          }
        }

        // THIS IS THE PATH FOR YOUR .json FILES:
        // Parse the original, untouched JSON string.
        return jsonDecode(rawContent) as Map<String, dynamic>;

      } else if (content is Map) {
        return Map<String, dynamic>.from(content); // Should not happen from Hive storage
      }
      throw FormatException('Unsupported content type for $source: ${content.runtimeType}');
    } catch (e) {
      debugPrint('[CONVERSION ERROR] Failed to convert/parse $source: $e');
      if (content is String) {
         debugPrint('Content sample (first 200 chars): ${content.substring(0, content.length > 200 ? 200 : content.length)}...');
      }
      rethrow;
    }
  }
bool _isValidOpenApi(dynamic spec) {
  try {
    if (spec is! Map<String, dynamic>) return false;
    final version = spec['openapi'] ?? spec['swagger'];
    if (version == null) return false;
    if (spec['paths'] is! Map || spec['info'] is! Map) return false;
    final info = spec['info'] as Map;
    if (info['title'] == null || info['version'] == null) return false;
    return true;
  } catch (e) {
    debugPrint('[VALIDATION ERROR] $e');
    return false;
  }
}

  String _normalizePath(String path) {
    return path.replaceAllMapped(
      RegExp(r':(\w+)'),
      (match) => '{${match.group(1)}}',
    );
  }

  String _getSourceName(String source) {
    try {
      return source.split('/').last.replaceAll(RegExp(r'\.(ya?ml|json)$'), '');
    } catch (e) {
      return 'Unnamed API';
    }
  }

  Map<String, dynamic> _getOperations(Map<String, dynamic> pathItem) {
    return pathItem.entries.fold<Map<String, dynamic>>(
      {},
      (map, entry) {
        final key = entry.key.toLowerCase();
        if (['get', 'post', 'put', 'delete', 'patch', 'head'].contains(key)) {
          return {...map, key: entry.value};
        }
        return map;
      },
    );
  }

  bool _isYaml(String path) =>
      path.toLowerCase().endsWith('.yaml') ||
      path.toLowerCase().endsWith('.yml');
}

String getCollectionName(String source) {
  final uri = Uri.tryParse(source);
  if (uri != null && uri.host.isNotEmpty) return uri.host;

  final filename = source.split(Platform.pathSeparator).last;
  final cleanName = filename
      .replaceAll(RegExp(r'\.(json|yml|yaml)$'), '')
      .replaceAll(RegExp(r'[^a-zA-Z0-9]'), ' ');

  return cleanName.trim();
}

String getCollectionId(String source) {
  final uri = Uri.tryParse(source);
  if (uri != null && uri.host.isNotEmpty) return uri.host;

  final filename = source.split(Platform.pathSeparator).last;
  final cleanName = filename
      .replaceAll(RegExp(r'\.(json|yml|yaml)$'), '')
      .replaceAll(RegExp(r'[^a-zA-Z0-9]'), ' ');

  return cleanName.trim().hashCode.toString();
}