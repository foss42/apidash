import 'dart:convert';
import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:archive/archive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../utils/utils.dart';

class GitHubSpecsService {
  static const String _kLatestZipUrl =
      'https://github.com/pratapsingh9/api-catalog-repo/releases/latest/download/final.zip';
  static const String _kRequestId = 'github-specs-fetch';

  Future<List<ApiExplorerModel>> fetchAndStoreSpecs() async {
    try {
      debugPrint('[GitHubSpecs] Starting spec fetch from GitHub...');
      final specs = await _downloadAndProcessZip();
      final models = await _storeInHive(specs);
      debugPrint('[GitHubSpecs] Successfully stored ${models.length} specs');
      return models;
    } catch (e) {
      debugPrint('[GitHubSpecs] ERROR - Fetch failed: $e');
      rethrow;
    }
  }

  Future<List<ApiExplorerModel>> _downloadAndProcessZip() async {
    try {
      debugPrint('[GitHubSpecs] Downloading specs from GitHub...');
      final (response, _, error) = await sendHttpRequest(
        _kRequestId,
        APIType.rest,
        HttpRequestModel(url: _kLatestZipUrl, method: HTTPVerb.get),
      );

      if (error != null) {
        throw _GitHubFetchException('Download failed: $error');
      }
      if (response == null) {
        throw _GitHubFetchException('No response received from GitHub');
      }
      if (response.statusCode != 200) {
        throw _GitHubFetchException(
            'HTTP ${response.statusCode} received from GitHub');
      }

      final specs = _extractValidSpecs(response.bodyBytes);
      if (specs.isEmpty) {
        debugPrint('[GitHubSpecs] No valid specs found in downloaded archive');
      }
      return specs;
    } catch (e) {
      debugPrint('[GitHubSpecs] ERROR - Download/processing failed: $e');
      rethrow;
    }
  }

  List<ApiExplorerModel> _extractValidSpecs(List<int> zipBytes) {
    try {
      debugPrint('[GitHubSpecs] Extracting ZIP contents...');
      final archive = ZipDecoder().decodeBytes(zipBytes);
      final specs = <ApiExplorerModel>[];
      var validCount = 0;

      for (final file in archive.files.where((f) => f.isFile)) {
        final filename = path.basename(file.name).toLowerCase();
        if (!isOpenApiFile(filename)) continue;

        try {
          final contentString = utf8.decode(file.content);
          final content = jsonDecode(contentString) as Map<String, dynamic>;

          if (isValidOpenApiSpec(content)) {
            final model = ApiExplorerModel.fromJson(content);
            specs.add(model);
            validCount++;
            debugPrint('[GitHubSpecs] Found valid spec: $filename');
          }
        } catch (e) {
          debugPrint('[GitHubSpecs] WARN - Failed to process $filename: $e');
        }
      }

      debugPrint('[GitHubSpecs] Found $validCount valid specs in archive');
      return specs;
    } catch (e) {
      debugPrint('[GitHubSpecs] ERROR - Extraction failed: $e');
      throw _GitHubFetchException('Failed to extract specs: $e');
    }
  }

  Future<List<ApiExplorerModel>> _storeInHive(List<ApiExplorerModel> specs) async {
    try {
      if (!Hive.isBoxOpen(kApiSpecsBox)) {
        await Hive.openBox(kApiSpecsBox);
      }

      final box = Hive.box(kApiSpecsBox);
      debugPrint('[GitHubSpecs] Storing ${specs.length} specs in Hive...');
      
      await box.clear();
      for (final spec in specs) {
        await box.put(spec.id, spec.toJson());
      }
      
      await box.put(kApiSpecsBoxIds, specs.map((s) => s.id).toList());
      
      debugPrint('[GitHubSpecs] Successfully stored specs in Hive');
      return specs;
    } catch (e) {
      debugPrint('[GitHubSpecs] ERROR - Hive storage failed: $e');
      throw _GitHubFetchException('Failed to store specs in Hive: $e');
    }
  }
}

class _GitHubFetchException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  _GitHubFetchException(this.message, [this.stackTrace]);

  @override
  String toString() =>
      'GitHubFetchException: $message${stackTrace != null ? '\n$stackTrace' : ''}';
}