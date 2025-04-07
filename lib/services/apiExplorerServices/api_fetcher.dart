import 'dart:convert';
import 'dart:developer';
import 'package:apidash_core/apidash_core.dart';
import 'package:archive/archive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

class GitHubSpecsFetcher {
  static const String _latestReleaseUrl =
      'https://github.com/pratapsingh9/api-catalog-repo/releases/latest/download/final.zip';
  static const String _hiveBoxName = 'api_specs';
  static const String _specNamesKey = '_spec_names';

  Future<Map<String, String>> fetchAndStoreSpecs() async {
    const requestId = 'github-specs-fetch';
    try {
      final zipBytes = await _downloadZip(requestId, _latestReleaseUrl);

      final specs = _extractAndValidateSpecs(zipBytes);
      await _storeWithVerification(specs);

      log('[SUCCESS] Stored ${specs.length} API specs');
      return specs;
    } catch (e) {
      log('[ERROR] Failed to fetch and store specs: $e', error: e);
      rethrow;
    } finally {
      httpClientManager.closeClient(requestId);
    }
  }

  Future<Map<String, dynamic>> _fetchReleaseMetadata(String requestId) async {
    log('[STEP] Fetching release metadata...');
    final (releaseRes, _, releaseErr) = await sendHttpRequest(
      requestId,
      APIType.rest,
      HttpRequestModel(
        url: _latestReleaseUrl,
        method: HTTPVerb.get,
        
      ),
    );

    if (releaseErr != null) {
      throw _GitHubFetchException('Release fetch failed: $releaseErr');
    }
    if (releaseRes == null)
      throw _GitHubFetchException('No release response received');
    if (releaseRes.statusCode != 200) {
      throw _GitHubFetchException('HTTP ${releaseRes.statusCode} received');
    }

    try {
      final releaseJson = jsonDecode(releaseRes.body) as Map<String, dynamic>;
      if (releaseJson['zipball_url'] == null) {
        throw _GitHubFetchException('No zipball_url in release');
      }

      log('[VERIFIED] Release metadata for tag: ${releaseJson['tag_name']}');
      return releaseJson;
    } catch (e) {
      throw _GitHubFetchException('Invalid release JSON: $e');
    }
  }

  Future<List<int>> _downloadZip(String requestId, String zipUrl) async {
    log('[STEP] Downloading ZIP from $zipUrl...');
    final (zipRes, _, zipErr) = await sendHttpRequest(
      requestId,
      APIType.rest,
      HttpRequestModel(url: zipUrl, method: HTTPVerb.get),
    );

    if (zipErr != null)
      throw _GitHubFetchException('ZIP download failed: $zipErr');
    if (zipRes == null) throw _GitHubFetchException('No ZIP response received');
    if (zipRes.statusCode != 200) {
      throw _GitHubFetchException(
          'ZIP download failed with HTTP ${zipRes.statusCode}');
    }
    if (zipRes.bodyBytes.isEmpty)
      throw _GitHubFetchException('Empty ZIP content');

    log('[VERIFIED] ZIP downloaded (${zipRes.bodyBytes.length} bytes)');
    return zipRes.bodyBytes;
  }

Map<String, String> _extractAndValidateSpecs(List<int> zipBytes) {
  final archive = _decodeZipArchive(zipBytes);
  final specs = <String, String>{};

  for (final file in archive.files.where((f) => f.isFile)) {
    final filename = path.basename(file.name);
    if (!filename.endsWith('.json')) continue;

    try {
      final content = utf8.decode(file.content);
      specs[filename] = content;
      log('[ADDED] $filename');
    } catch (e) {
      log('[ERROR] Processing $filename: $e');
    }
  }

  return specs;
}

  bool _isYaml(String filename) {
    return filename.endsWith('.yaml') || filename.endsWith('.yml');
  }

  Archive _decodeZipArchive(List<int> bytes) {
    try {
      final archive = ZipDecoder().decodeBytes(bytes);
      if (archive.files.isEmpty)
        throw _GitHubFetchException('Empty ZIP archive');
      return archive;
    } catch (e) {
      throw _GitHubFetchException('ZIP extraction failed: $e');
    }
  }

  bool _isValidOpenApiSpec(Map<String, dynamic> json) {
    return true;
  }

  Future<void> _storeWithVerification(Map<String, String> specs) async {
    log('[STEP] Storing ${specs.length} specs...');
    final box = await _getHiveBox();

    try {
      // Clear previous data
      await box.clear();

      // Store all specs
      await Future.wait([
        ...specs.entries.map((e) => box.put(e.key, e.value)),
        box.put(_specNamesKey, specs.keys.toList()),
      ]);

      // Verify storage
      await _verifyStorage(box, specs.keys.toList());

      log('[VERIFIED] All specs stored successfully');
    } catch (e) {
      await box.clear(); // Clear potentially corrupted data
      throw _GitHubFetchException('Storage failed: $e');
    }
  }

  Future<void> _verifyStorage(Box box, List<String> expectedKeys) async {
    log('[VERIFY] Checking storage integrity...');

    // Check spec names list
    final storedNames = (box.get(_specNamesKey) as List?)?.cast<String>();
    if (storedNames == null || !_listsMatch(storedNames, expectedKeys)) {
      throw _GitHubFetchException('Spec names list verification failed');
    }

    // Sample check some specs (first, middle, last)
    final sampleIndices = [0, expectedKeys.length ~/ 2, expectedKeys.length - 1]
        .where((i) => i < expectedKeys.length);

    for (final i in sampleIndices) {
      final key = expectedKeys[i];
      if (!box.containsKey(key)) {
        throw _GitHubFetchException('Missing spec: $key');
      }

      try {
        jsonDecode(box.get(key) as String);
      } catch (e) {
        throw _GitHubFetchException('Corrupted spec $key: $e');
      }
    }
  }

  bool _listsMatch(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  Future<Box> _getHiveBox() async {
    try {
      if (!Hive.isBoxOpen(_hiveBoxName)) {
        await Hive.openBox(_hiveBoxName);
      }
      return Hive.box(_hiveBoxName);
    } catch (e) {
      throw _GitHubFetchException('Hive initialization failed: $e');
    }
  }

  static Map<String, String> getCachedSpecs() {
    try {
      final box = Hive.box(_hiveBoxName);
      final names = (box.get(_specNamesKey) as List?)?.cast<String>() ?? [];

      return Map.fromEntries(
          names.map((name) => MapEntry(name, box.get(name) as String)));
    } catch (e) {
      log('[ERROR] Failed to get cached specs: $e');
      return {};
    }
  }

  static Future<bool> verifyCacheIntegrity() async {
    try {
      final box = await Hive.openBox(_hiveBoxName);
      final names = (box.get(_specNamesKey) as List?)?.cast<String>();

      if (names == null || names.isEmpty) return false;

      for (final name in [names.first, names.last]) {
        if (!box.containsKey(name)) return false;
        jsonDecode(box.get(name) as String);
      }

      return true;
    } catch (e) {
      log('[CACHE VERIFY] Failed: $e');
      return false;
    }
  }
}

class _GitHubFetchException implements Exception {
  final String message;
  _GitHubFetchException(this.message);
  @override
  String toString() => 'GitHubFetchException: $message';
}
