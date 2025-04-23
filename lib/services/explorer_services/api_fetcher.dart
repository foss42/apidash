import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:apidash/models/api_explorer_models.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart' as path;

class ApiSpecsRepository {
  static const String _hiveBoxName = 'api_specs_box';
  static const String _specNamesKey = '_spec_names';
  static const Duration _maxProcessingTime = Duration(seconds: 15);

  final String _downloadUrl;
  final Box<String> _specsBox;

  ApiSpecsRepository({
    String? downloadUrl,
    Box<String>? box,
  })  : _downloadUrl = downloadUrl ??
            'https://github.com/pratapsingh9/api-catalog-repo/releases/latest/download/final.zip',
        _specsBox = box ?? Hive.box(_hiveBoxName);

  /// Fetches and caches API specifications, returning parsed model objects
  Future<List<ApiCollection>> fetchAndCacheSpecs() async {
    final completer = Completer<List<ApiCollection>>();
    final timer = Timer(_maxProcessingTime, () {
      if (!completer.isCompleted) {
        completer.completeError(
          ApiSpecsException('Specs processing timed out'),
        );
      }
    });

    try {
      debugPrint('[API_SPECS] Starting specs fetch');
      final stopwatch = Stopwatch()..start();

      // 1. Download the zip file
      final zipBytes = await _downloadSpecsZip();
      
      // 2. Process contents into models
      final collections = await _processZipContents(zipBytes);
      
      // 3. Cache the models
      await _cacheCollections(collections);

      debugPrint('[API_SPECS] Processed ${collections.length} collections in ${stopwatch.elapsedMilliseconds}ms');
      timer.cancel();
      completer.complete(collections);
    } catch (e, stackTrace) {
      timer.cancel();
      debugPrint('[API_SPECS_ERROR] Fetch failed: $e\n$stackTrace');
      completer.completeError(
        e is ApiSpecsException ? e : ApiSpecsException('Fetch failed: $e'),
      );
    }

    return completer.future;
  }

  /// Returns cached API specifications as model objects
  List<ApiCollection> getCachedSpecs() {
    try {
      final idsJson = _specsBox.get(_specNamesKey);
      if (idsJson == null) return [];

      final ids = (jsonDecode(idsJson) as List).cast<String>();
      return ids.map((id) {
        final json = _specsBox.get(id);
        if (json == null) throw Exception('Missing collection $id');
        return ApiCollection.fromJson(jsonDecode(json) as Map<String, dynamic>);
      }).toList();
    } catch (e, stackTrace) {
      debugPrint('[API_SPECS_ERROR] Cache read failed: $e\n$stackTrace');
      return [];
    }
  }

  Future<List<int>> _downloadSpecsZip() async {
    const requestId = 'api-specs-fetch';
    try {
      debugPrint('[API_SPECS] Downloading specs ZIP');
      final (zipRes, _, zipErr) = await sendHttpRequest(
        requestId,
        APIType.rest,
        HttpRequestModel(
          url: _downloadUrl,
          method: HTTPVerb.get,
        ),
      );

      if (zipErr != null) throw ApiSpecsException('Download failed: $zipErr');
      if (zipRes == null) throw ApiSpecsException('No response received');
      if (zipRes.statusCode != 200) {
        throw ApiSpecsException('Server responded with HTTP ${zipRes.statusCode}');
      }
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
            name: json['info']?['title'] ?? 'Unnamed Collection',
            description: json['info']?['description'],
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
            name: endpointData['summary'] ?? '${method.toUpperCase()} $path',
            description: endpointData['description']?.toString(),
            path: path,
            method: HTTPVerb.values.firstWhere(
              (v) => v.name.toLowerCase() == method.toLowerCase(),
              orElse: () => HTTPVerb.get,
            ),
            baseUrl: baseUrl,
            parameters: _parseParameters(endpointData['parameters']),
            requestBody: _parseRequestBody(endpointData['requestBody']),
            headers: _parseHeaders(endpointData),
            responses: _parseResponses(endpointData['responses']),
          ));
        } catch (e) {
          debugPrint('[API_SPECS_WARN] Failed to parse endpoint $method $path: $e');
        }
      });
    });

    return endpoints;
  }

Future<void> _cacheCollections(List<ApiCollection> collections) async {
  try {
    await _specsBox.clear();

    await _specsBox.put(
      _specNamesKey,
      jsonEncode(collections.map((c) => c.id).toList()),
    );

    // Store each collection as JSON
    for (final collection in collections) {
      await _specsBox.put(
        collection.id,
        jsonEncode(collection.toJson()),
      );
    }

    await _verifyCache(collections);
  } catch (e) {
    await _specsBox.clear();
    throw ApiSpecsException('Cache update failed: $e');
  }
}


  Future<void> _verifyCache(List<ApiCollection> collections) async {
    try {
      final idsJson = _specsBox.get(_specNamesKey);
      if (idsJson == null) throw Exception('Missing IDs list');

      final storedIds = (jsonDecode(idsJson) as List).cast<String>();
      if (storedIds.length != collections.length) {
        throw ApiSpecsException('Cache verification failed: count mismatch');
      }

      // Verify random samples
      final random = Random();
      final samples = collections.length > 5
          ? [collections.first, collections[random.nextInt(collections.length)], collections.last]
          : collections;

      for (final collection in samples) {
        final json = _specsBox.get(collection.id);
        if (json == null) throw Exception('Missing collection');
        ApiCollection.fromJson(jsonDecode(json) as Map<String, dynamic>);
      }
    } catch (e) {
      throw ApiSpecsException('Cache verification failed: $e');
    }
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

  // Model parsing helpers
  List<ApiParameter>? _parseParameters(dynamic parameters) {
    if (parameters is! List) return null;
    return parameters.map((p) => ApiParameter.fromJson(p)).toList();
  }

  ApiRequestBody? _parseRequestBody(dynamic requestBody) {
    if (requestBody is! Map<String, dynamic>) return null;
    return ApiRequestBody.fromJson(requestBody);
  }

  Map<String, ApiHeader>? _parseHeaders(dynamic headers) {
    // Implement based on your header structure
    return null;
  }

  Map<String, ApiResponse>? _parseResponses(dynamic responses) {
    if (responses is! Map<String, dynamic>) return null;
    return responses.map((k, v) => MapEntry(k, ApiResponse.fromJson(v)));
  }
}

/// Custom exception for API specs operations
class ApiSpecsException implements Exception {
  final String message;
  final String? details;

  ApiSpecsException(this.message, [this.details]);

  @override
  String toString() => details != null 
      ? 'ApiSpecsException: $message ($details)'
      : 'ApiSpecsException: $message';
}