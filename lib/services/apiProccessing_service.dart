import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:yaml/yaml.dart';
import 'package:apidash_core/apidash_core.dart';
import '../models/api_catalog.dart';
import '../models/api_endpoint.dart';

class ApiProcessingService {
  final String _sourcesDir;
  final String _outputDir;

  ApiProcessingService({
    String? sourcesDir,
    String? outputDir,
  })  : _sourcesDir = sourcesDir ?? 'lib/api_sources',
        _outputDir = outputDir ?? 'lib/api_templates';

  Future<List<ApiEndpointModel>> processHiveSpecs(Map<String, dynamic> hiveSpecs) async {
    final processed = <ApiEndpointModel>[];

    for (final entry in hiveSpecs.entries) {
      try {
        final content = entry.value is String
            ? jsonDecode(entry.value as String)
            : entry.value;

        if (!_isValidOpenApi(content)) continue;

        final endpoints = _parseOpenApiToEndpoints(content as Map<String, dynamic>);
        if (endpoints.isNotEmpty) processed.addAll(endpoints);
      } catch (e, stack) {
        debugPrint('Error processing hive spec [${entry.key}]: $e\n$stack');
      }
    }

    return processed;
  }

  Future<List<ApiEndpointModel>> processApiFiles() async {
    try {
      final files = await _getApiSpecFiles();
      final allEndpoints = <ApiEndpointModel>[];

      for (final file in files) {
        try {
          final content = await file.readAsString();
          final jsonContent = await convertToJson(content, file.path);

          if (!_isValidOpenApi(jsonContent)) continue;

          final endpoints = _parseOpenApiToEndpoints(jsonContent);
          allEndpoints.addAll(endpoints);
        } catch (e) {
          debugPrint('Error processing file ${file.path}: $e');
        }
      }

      return allEndpoints;
    } catch (e) {
      debugPrint('Fatal error in API file processing: $e');
      return [];
    }
  }

  Future<List<ApiEndpointModel>> parseOpenApiContent(
    String content,
    String source,
  ) async {
    try {
      final jsonContent = await convertToJson(content, source);
      return _parseOpenApiToEndpoints(jsonContent);
    } catch (e) {
      debugPrint('Error parsing OpenAPI from $source: $e');
      rethrow;
    }
  }

  List<ApiEndpointModel> _parseOpenApiToEndpoints(Map<String, dynamic> spec) {
    final paths = spec['paths'] as Map<String, dynamic>? ?? {};
    final endpoints = <ApiEndpointModel>[];

    for (final entry in paths.entries) {
      final path = _normalizePath(entry.key);
      final methods = _getOperations(entry.value);

      for (final method in methods.entries) {
        final httpVerb = _parseHttpVerb(method.key);
        final operation = method.value as Map<String, dynamic>? ?? {};
        final operationId = operation['operationId']?.toString() ?? '';
        final name = operation['summary']?.toString() ?? path;

        endpoints.add(
          ApiEndpointModel(
            id: '${httpVerb.name}_$path',
            name: name,
            catalogId: _getSourceName(_getBaseUrl(spec)),
            description: operation['description']?.toString() ?? '',
            operationId: operationId,
            path: path,
            method: httpVerb,
            parameters: operation['parameters'] is List
                ? {'parameters': operation['parameters']}
                : {},
            responses: operation['responses'] as Map<String, dynamic>? ?? {},
          ),
        );
      }
    }

    return endpoints;
  }

  String _normalizePath(String path) {
    return path.replaceAllMapped(RegExp(r':(\w+)'), (match) => '{${match[1]}}');
  }

  String _getBaseUrl(Map<String, dynamic> spec) {
    try {
      final servers = spec['servers'];
      if (servers is List && servers.isNotEmpty) {
        return servers[0]['url']?.toString() ?? '';
      }
    } catch (e) {
      debugPrint('Error retrieving base URL: $e');
    }
    return '';
  }

  Map<String, dynamic> _getOperations(Map<String, dynamic> pathItem) {
    final allowedMethods = ['get', 'post', 'put', 'delete', 'patch', 'head'];
    return Map.fromEntries(
      pathItem.entries.where((e) => allowedMethods.contains(e.key.toLowerCase())),
    );
  }

  Future<List<File>> _getApiSpecFiles() async {
    try {
      final dir = Directory(_sourcesDir);
      if (!await dir.exists()) {
        debugPrint('Source directory $_sourcesDir does not exist.');
        return [];
      }

      return dir
          .listSync(recursive: true)
          .whereType<File>()
          .where(_isValidSourceFile)
          .toList();
    } catch (e) {
      debugPrint('Error reading source directory: $e');
      return [];
    }
  }

  bool _isValidSourceFile(FileSystemEntity file) {
    final path = file.path.toLowerCase();
    return path.endsWith('.yaml') || path.endsWith('.yml') || path.endsWith('.json');
  }

  Future<Map<String, dynamic>> convertToJson(dynamic content, String source) async {
    try {
      if (content is String) {
        if (_isYaml(source)) {
          final yamlMap = loadYaml(content);
          return jsonDecode(jsonEncode(yamlMap)) as Map<String, dynamic>;
        }
        return jsonDecode(content) as Map<String, dynamic>;
      } else if (content is Map) {
        return Map<String, dynamic>.from(content);
      }
    } catch (e) {
      debugPrint('Conversion error for $source: $e');
    }

    return {};
  }

  bool _isYaml(String path) {
    final p = path.toLowerCase();
    return p.endsWith('.yaml') || p.endsWith('.yml');
  }

  bool _isValidOpenApi(dynamic spec) {
    return spec is Map<String, dynamic> &&
        (spec.containsKey('openapi') || spec.containsKey('swagger')) &&
        spec['paths'] is Map;
  }

  Map<String, dynamic> _resolveRef(String ref, Map<String, dynamic> components) {
    try {
      final parts = ref.split('/').skip(2);
      dynamic current = components;

      for (final part in parts) {
        if (current is Map) {
          current = current[part];
        } else {
          return {};
        }
      }

      return current is Map<String, dynamic> ? current : {};
    } catch (e) {
      debugPrint('Failed to resolve ref $ref: $e');
      return {};
    }
  }

  List<NameValueModel> _parseParameters(List<dynamic> params, Map<String, dynamic> components) {
    return params.map<NameValueModel>((param) {
      if (param is Map && param.containsKey(r'$ref')) {
        param = _resolveRef(param[r'$ref'] as String, components);
      }

      return NameValueModel(
        name: param['name']?.toString() ?? '',
        value: param['example']?.toString() ?? '',
      );
    }).toList();
  }

  List<NameValueModel> _parseHeaders(List<dynamic> params, Map<String, dynamic> components) {
    return params
        .where((param) => param['in'] == 'header')
        .map<NameValueModel>((param) {
          if (param is Map && param.containsKey(r'$ref')) {
            param = _resolveRef(param[r'$ref'] as String, components);
          }

          return NameValueModel(
            name: param['name']?.toString() ?? '',
            value: param['example']?.toString() ?? '',
          );
        }).toList();
  }

  HTTPVerb _parseHttpVerb(String? method) {
    switch (method?.toUpperCase()) {
      case 'POST':
        return HTTPVerb.post;
      case 'PUT':
        return HTTPVerb.put;
      case 'DELETE':
        return HTTPVerb.delete;
      case 'PATCH':
        return HTTPVerb.patch;
      case 'HEAD':
        return HTTPVerb.head;
      default:
        return HTTPVerb.get;
    }
  }

  String _getSourceName(String source) {
    try {
      return source.split('/').last.replaceAll(RegExp(r'\.(ya?ml|json)$'), '');
    } catch (_) {
      return 'Unnamed API';
    }
  }
}
