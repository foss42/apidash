import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:yaml/yaml.dart';
import 'package:apidash_core/apidash_core.dart';
import '../models/models.dart';

class ApiProcessingService {
  final String _sourcesDir;
  final String _outputDir;

  ApiProcessingService({
    String? sourcesDir,
    String? outputDir,
  })  : _sourcesDir = sourcesDir ?? 'lib/api_sources',
        _outputDir = outputDir ?? 'lib/api_templates';

  Future<List<ApiExplorerModel>> processHiveSpecs(
    Map<String, dynamic> hiveSpecs,
  ) async {
    final processedData = <ApiExplorerModel>[];

    for (final entry in hiveSpecs.entries) {
      try {
        debugPrint('Processing spec: ${entry.key}');
        final jsonContent = await _convertToJson(entry.value, entry.key);
        
        if (!_isValidOpenApi(jsonContent)) {
          debugPrint('Invalid OpenAPI spec: ${entry.key}');
          continue;
        }

        final endpoints = _parseOpenApiToEndpoints(jsonContent);
        if (endpoints.isEmpty) continue;

        final collection = ApiExplorerModel(
          id: 'col-${entry.key.hashCode}',
          name: jsonContent['info']?['title']?.toString() ?? _getSourceName(entry.key),
          source: 'Hive: ${entry.key}',
          updatedAt: DateTime.now(),
          path: '',
          method: HTTPVerb.get,
          baseUrl: _getBaseUrl(jsonContent),
          parameters: [],
        );

        processedData.add(collection);
      } catch (e) {
        debugPrint('Error processing ${entry.key}: $e');
      }
    }

    debugPrint('Successfully processed ${processedData.length} collections');
    return processedData;
  }

  Future<List<ApiExplorerModel>> processApiFiles() async {
    try {
      debugPrint('[API Processor] Starting file processing...');
      final files = await _getApiSpecFiles();
      if (files.isEmpty) return [];

      final processedData = <ApiExplorerModel>[];

      for (final file in files) {
        try {
          final content = await file.readAsString();
          final jsonContent = await _convertToJson(content, file.path);

          if (!_isValidOpenApi(jsonContent)) {
            debugPrint('[API Processor] Skipping non-OpenAPI file: ${file.path}');
            continue;
          }

          final endpoints = _parseOpenApiToEndpoints(jsonContent);
          if (endpoints.isEmpty) continue;

          final collection = ApiExplorerModel(
            id: 'col-${file.path.hashCode}',
            name: jsonContent['info']?['title']?.toString() ?? _getSourceName(file.path),
            source: file.path,
            updatedAt: DateTime.now(),
            path: '',
            method: HTTPVerb.get,
            baseUrl: _getBaseUrl(jsonContent),
            parameters: [],
          );

          processedData.add(collection);
        } catch (e) {
          debugPrint('[API Processor] Error processing ${file.path}: $e');
        }
      }

      return processedData;
    } catch (e) {
      debugPrint('[API Processor] Critical error in file processing: $e');
      return [];
    }
  }

  Future<List<ApiExplorerModel>> parseOpenApiContent(
    String content,
    String source,
  ) async {
    try {
      final jsonContent = await _convertToJson(content, source);

      if (!_isValidOpenApi(jsonContent)) {
        throw const FormatException('Invalid OpenAPI specification');
      }

      final endpoints = _parseOpenApiToEndpoints(jsonContent);
      if (endpoints.isEmpty) {
        throw const FormatException('No endpoints found in specification');
      }

      return endpoints;
    } catch (e) {
      debugPrint('[API Processor] Error parsing OpenAPI content: $e');
      rethrow;
    }
  }

  List<ApiExplorerModel> _parseOpenApiToEndpoints(Map<String, dynamic> spec) {
    final endpoints = <ApiExplorerModel>[];
    final paths = spec['paths'] as Map<String, dynamic>? ?? {};
    final components = spec['components'] as Map<String, dynamic>? ?? {};
    final baseUrl = _getBaseUrl(spec);

    for (final pathEntry in paths.entries) {
      final path = _normalizePath(pathEntry.key);
      final pathItem = pathEntry.value as Map<String, dynamic>;

      final operations = _getOperations(pathItem);

      for (final methodEntry in operations.entries) {
        final method = _parseHttpVerb(methodEntry.key);
        final operation = methodEntry.value as Map<String, dynamic>;

        endpoints.add(ApiExplorerModel(
          id: '${method.name}_${path}_${operation['operationId'] ?? '${path.hashCode}'}',
          name: operation['summary'] ?? operation['operationId'] ?? path,
          source: baseUrl,
          description: operation['description'] ?? '',
          updatedAt: DateTime.now(),
          path: path,
          method: method,
          baseUrl: baseUrl,
          parameters: _parseParameters(operation['parameters'] ?? [], components),
          headers: _parseHeaders(operation['parameters'] ?? [], components),
          requestBody: operation['requestBody'],
          responses: operation['responses'],
        ));
      }
    }

    return endpoints;
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

  HTTPVerb _parseHttpVerb(String? method) {
    if (method == null) return HTTPVerb.get;
    
    switch (method.toUpperCase()) {
      case 'POST': return HTTPVerb.post;
      case 'PUT': return HTTPVerb.put;
      case 'DELETE': return HTTPVerb.delete;
      case 'PATCH': return HTTPVerb.patch;
      case 'HEAD': return HTTPVerb.head;
      default: return HTTPVerb.get;
    }
  }

  List<NameValueModel> _parseParameters(
    List<dynamic> parameters,
    Map<String, dynamic> components,
  ) {
    return parameters.map<NameValueModel>((param) {
      if (param is Map && param.containsKey(r'$ref')) {
        param = _resolveRef(param[r'$ref'] as String, components);
      }

      return NameValueModel(
        name: param['name']?.toString() ?? '',
        value: param['example']?.toString() ?? '',
      );
    }).toList();
  }

  List<NameValueModel> _parseHeaders(
    List<dynamic> parameters,
    Map<String, dynamic> components,
  ) {
    return parameters
        .where((param) => param['in'] == 'header')
        .map<NameValueModel>((param) {
          if (param is Map && param.containsKey(r'$ref')) {
            param = _resolveRef(param[r'$ref'] as String, components);
          }

          return NameValueModel(
            name: param['name']?.toString() ?? '',
            value: param['example']?.toString() ?? '',
          );
        })
        .toList();
  }

  Map<String, dynamic> _resolveRef(String ref, Map<String, dynamic> components) {
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

  Future<List<File>> _getApiSpecFiles() async {
    try {
      final dir = Directory(_sourcesDir);
      if (!await dir.exists()) {
        debugPrint('[API Processor] Directory $_sourcesDir does not exist');
        return [];
      }

      return dir
          .listSync(recursive: true)
          .whereType<File>()
          .where(_isValidSourceFile)
          .toList();
    } catch (e) {
      debugPrint('[API Processor] Error getting API spec files: $e');
      return [];
    }
  }

  bool _isValidSourceFile(FileSystemEntity file) {
    final path = file.path.toLowerCase();
    return path.endsWith('.yaml') ||
        path.endsWith('.yml') ||
        path.endsWith('.json');
  }

  bool _isYaml(String path) =>
      path.toLowerCase().endsWith('.yaml') ||
      path.toLowerCase().endsWith('.yml');

  Future<Map<String, dynamic>> _convertToJson(
    dynamic content,
    String source,
  ) async {
    try {
      if (content is String) {
        final cleanedContent = content
            .replaceAll(RegExp(r'\s+'), ' ')
            .replaceAll(RegExp(r',\s*}'), '}')
            .replaceAll(RegExp(r',\s*]'), ']');

        if (_isYaml(source)) {
          final yamlMap = loadYaml(cleanedContent);
          return jsonDecode(jsonEncode(yamlMap)) as Map<String, dynamic>;
        }
        return jsonDecode(cleanedContent) as Map<String, dynamic>;
      } else if (content is Map) {
        return Map<String, dynamic>.from(content);
      }
      throw FormatException('Unsupported content type for $source');
    } catch (e) {
      debugPrint('[API Processor] Error converting to JSON: $e');
      throw FormatException('Failed to parse $source: ${e.toString()}');
    }
  }

  bool _isValidOpenApi(dynamic spec) {
    return spec is Map<String, dynamic> &&
        (spec.containsKey('openapi') || spec.containsKey('swagger')) &&
        spec['paths'] is Map;
  }
}