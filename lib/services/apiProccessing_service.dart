import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';

class ApiProcessingService {
  final String _sourcesDir;
  final String _outputDir;

  ApiProcessingService({
    String? sourcesDir,
    String? outputDir,
  })  : _sourcesDir = sourcesDir ?? 'lib/api_sources',
        _outputDir = outputDir ?? 'lib/api_templates';

  Future<List<Map<String, dynamic>>> processApiFiles() async {
    final files = await _getApiSpecFiles();
    final collections = <Map<String, dynamic>>[];
    final outputDir = Directory(_outputDir);

    for (final file in files) {
      try {
        final outputFile =
            File('${outputDir.path}/${_getOutputFileName(file.path)}');
        if (await outputFile.exists() &&
            outputFile.lastModifiedSync().isAfter(file.lastModifiedSync())) {
          final cachedContent = await outputFile.readAsString();
          collections.add(jsonDecode(cachedContent));
          continue;
        }
        final content = await file.readAsString();
        final endpoints = await parseOpenApiContent(content, file.path);
        final collection = {
          'id': _generateFileId(file.path),
          'name': getCollectionName(file.path),
          'source': file.path,
          'updatedAt': DateTime.now().toIso8601String(),
          'endpoints': endpoints,
        };

        collections.add(collection);
        await _writeTemplate(outputFile, collection);
      } catch (e) {
        debugPrint('Error processing ${file.path}: $e');
      }
    }
    return collections;
  }

  String _getOutputFileName(String sourcePath) {
  return '${_slugify(getCollectionName(sourcePath))}.json';
}

Future<void> _writeTemplate(File file, Map<String, dynamic> collection) async {
  await file.create(recursive: true);
  await file.writeAsString(JsonEncoder.withIndent('  ').convert(collection));
}

  Future<List<Map<String, dynamic>>> parseOpenApiContent(
      String content, String source) async {
    try {
      dynamic parsed;
      if (source.endsWith('.yaml') || source.endsWith('.yml')) {
        parsed = loadYaml(content);
        parsed = _convertYamlToJson(parsed);
      } else {
        parsed = jsonDecode(content);
      }

      if (parsed['openapi'] == null && parsed['swagger'] == null) {
        throw Exception('Not an OpenAPI/Swagger specification file');
      }

      return _parseOpenApi(parsed);
    } catch (e) {
      throw Exception('Failed to parse OpenAPI spec: $e');
    }
  }

  List<Map<String, dynamic>> _parseOpenApi(dynamic spec) {
    final endpoints = <Map<String, dynamic>>[];
    try {
      final paths = spec['paths'] as Map<String, dynamic>? ?? {};

      for (final pathEntry in paths.entries) {
        final path = pathEntry.key;
        final operations = pathEntry.value as Map<String, dynamic>;

        for (final methodEntry in operations.entries) {
          final method = methodEntry.key.toUpperCase();
          final operation = methodEntry.value as Map<String, dynamic>;

          endpoints.add({
            'id': '${method}_${path.hashCode}',
            'name': _getOperationSummary(operation),
            'path': path,
            'method': method,
            'baseUrl': _getBaseUrl(spec),
            'parameters': _parseParameters(operation['parameters']),
            'headers': _parseHeaders(operation),
            'requestBody': _parseRequestBody(operation['requestBody']),
            'responses': _parseResponses(operation['responses']),
          });
        }
      }
    } catch (e) {
      debugPrint('Error parsing OpenAPI: $e');
    }
    return endpoints;
  }

  String _getBaseUrl(dynamic spec) {
    try {
      if (spec['servers'] != null &&
          spec['servers'] is List &&
          spec['servers'].isNotEmpty) {
        return spec['servers'][0]['url']?.toString() ?? '';
      } else {
        return [
          _getScheme(spec),
          '://',
          _getHost(spec),
          _getBasePath(spec),
        ].join('');
      }
    } catch (e) {
      debugPrint('Error getting base URL: $e');
      return '';
    }
  }

  String _getOperationSummary(dynamic operation) {
    return operation['summary']?.toString() ??
        operation['operationId']?.toString() ??
        operation['description']?.toString() ??
        'Unnamed Endpoint';
  }

  List<Map<String, dynamic>> _parseParameters(dynamic parameters) {
    if (parameters is! List) return [];
    return parameters.map<Map<String, dynamic>>((param) {
      return {
        'name': param['name']?.toString() ?? '',
        'in': param['in']?.toString() ?? 'query',
        'description': param['description']?.toString(),
        'required': param['required'] == true,
        'type': param['type']?.toString() ?? 'string',
        'schema': _parseSchema(param['schema']),
      };
    }).toList();
  }

  Map<String, dynamic> _parseHeaders(dynamic operation) {
    final headers = <String, dynamic>{};
    final parameters = _parseParameters(operation['parameters'])
        .where((p) => p['in'] == 'header');
    for (final param in parameters) {
      headers[param['name']] = param;
    }
    return headers;
  }

  Map<String, dynamic> _parseRequestBody(dynamic requestBody) {
    if (requestBody is! Map) return {};
    return {
      'description': requestBody['description']?.toString(),
      'content': _parseContent(requestBody['content']),
    };
  }

  Map<String, dynamic> _parseContent(dynamic content) {
    if (content is! Map) return {};
    final result = <String, dynamic>{};
    for (final entry in content.entries) {
      result[entry.key.toString()] = _parseMediaType(entry.value);
    }
    return result;
  }

  Map<String, dynamic> _parseMediaType(dynamic mediaType) {
    return {
      'schema': _parseSchema(mediaType?['schema']),
    };
  }

  Map<String, dynamic> _parseSchema(dynamic schema) {
    if (schema is! Map) return {};
    return {
      'type': schema['type']?.toString(),
      'format': schema['format']?.toString(),
      'ref': schema['\$ref']?.toString(),
      'items': _parseSchema(schema['items']),
      'properties': _parseProperties(schema['properties']),
    };
  }

  Map<String, dynamic> _parseProperties(dynamic properties) {
    if (properties is! Map) return {};
    return properties.map<String, dynamic>((key, value) {
      return MapEntry(key.toString(), _parseSchema(value));
    });
  }

  Map<String, dynamic> _parseResponses(dynamic responses) {
    if (responses is! Map) return {};
    return responses.map<String, dynamic>((code, response) {
      return MapEntry(code.toString(), {
        'description': response['description']?.toString(),
        'content': _parseContent(response['content']),
      });
    });
  }

  Future<List<File>> _getApiSpecFiles() async {
    final dir = Directory(_sourcesDir);
    if (!dir.existsSync()) {
      debugPrint('Directory does not exist: $_sourcesDir');
      return [];
    }

    return dir
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) =>
            file.path.endsWith('.yaml') ||
            file.path.endsWith('.yml') ||
            file.path.endsWith('.json'))
        .toList();
  }

  String getCollectionName(String source) {
    final filename = source.split(Platform.pathSeparator).last;
    return filename
        .replaceAll(RegExp(r'\.(json|yml|yaml)$'), '')
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), ' ')
        .trim();
  }

  String _slugify(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w-]'), '-')
        .replaceAll(RegExp(r'-{2,}'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
  }

  String _generateFileId(String path) {
    return path.hashCode.toString();
  }

  dynamic _convertYamlToJson(dynamic yaml) {
    if (yaml is YamlMap) {
      return Map.fromEntries(yaml.entries
          .map((e) => MapEntry(e.key.toString(), _convertYamlToJson(e.value))));
    } else if (yaml is YamlList) {
      return yaml.map(_convertYamlToJson).toList();
    }
    return yaml;
  }

  String _getScheme(dynamic spec) =>
      _getFirstListItem(spec['schemes']) ?? 'https';

  String _getHost(dynamic spec) => spec['host']?.toString() ?? '';

  String _getBasePath(dynamic spec) => spec['basePath']?.toString() ?? '';

  dynamic _getFirstListItem(dynamic list) {
    if (list is List && list.isNotEmpty) return list.first.toString();
    return null;
  }
}
