import 'dart:convert';

import 'package:apidash/models/models.dart';
import 'package:apidash_core/apidash_core.dart';

class GitCollectionPaths {
  static const String collection = 'collection.json';
  static const String environments = 'environments.json';
  static const String gitignore = '.gitignore';
  static const String requestsDir = 'requests';

  static String requestFilePath(String requestFileName) =>
      '$requestsDir/$requestFileName.json';
}

/// Same contents as `collections/<id>/.gitignore` on disk ([FileSystemHandler]).
const String kGitCollectionGitignoreContents = '# macOS Finder\n.DS_Store\n';

class GitCollectionFiles {
  const GitCollectionFiles({
    required this.files,
  });

  final Map<String, String> files;
}

class MalformedRequestFile {
  const MalformedRequestFile({
    required this.path,
    required this.reason,
  });

  final String path;
  final String reason;
}

class GitCollectionImportResult {
  const GitCollectionImportResult({
    required this.collection,
    required this.requestsById,
    required this.environmentsById,
    required this.environmentOrder,
    required this.malformedRequests,
  });

  final CollectionModel collection;
  final Map<String, RequestModel> requestsById;
  final Map<String, EnvironmentModel> environmentsById;
  final List<String> environmentOrder;
  final List<MalformedRequestFile> malformedRequests;
}

class GitCollectionSerializer {
  const GitCollectionSerializer();

  GitCollectionFiles toGitFiles({
    required CollectionModel collection,
    required Map<String, RequestModel> requestsById,
    required List<String> requestOrder,
    required Map<String, EnvironmentModel> environmentsById,
    required List<String> environmentOrder,
    String? activeEnvironmentId,
  }) {
    final files = <String, String>{};

    files[GitCollectionPaths.gitignore] = kGitCollectionGitignoreContents;

    // [collection.id] is the workspace folder name (slug), not a random UUID.
    files[GitCollectionPaths.collection] = _encodePretty(<String, dynamic>{
      'id': collection.id,
      'name': collection.name,
      'description': collection.description,
      'requestOrder': requestOrder,
      ...?activeEnvironmentId == null
          ? null
          : <String, dynamic>{'activeEnvironmentId': activeEnvironmentId},
    });

    files[GitCollectionPaths.environments] = _encodePretty(<String, dynamic>{
      ...?activeEnvironmentId == null
          ? null
          : <String, dynamic>{'activeEnvironmentId': activeEnvironmentId},
      'environmentOrder': environmentOrder,
      'environments': environmentOrder
          .where(environmentsById.containsKey)
          .map((id) => environmentsById[id]!.toJson())
          .toList(),
    });

    for (final requestId in requestOrder) {
      final request = requestsById[requestId];
      if (request == null) continue;
      final fileName = _buildUniqueRequestFileName(
        requestName: request.name,
        usedNames: files.keys
            .where((p) =>
                p.startsWith('${GitCollectionPaths.requestsDir}/') &&
                p.endsWith('.json'))
            .map((p) => p.split('/').last.replaceAll('.json', ''))
            .toSet(),
      );
      files[GitCollectionPaths.requestFilePath(fileName)] =
          _encodePretty(request.toJson());
    }

    return GitCollectionFiles(files: files);
  }

  /// [fallbackCollectionId] is always used as [CollectionModel.id]: it must match
  /// `apidash-data/collections/<id>/` on disk (slug from the collection name).
  /// Remote `collection.json` may still contain a legacy UUID `id`; that value is ignored.
  GitCollectionImportResult fromGitFiles({
    required Map<String, String> files,
    required String fallbackCollectionId,
    required String fallbackCollectionName,
  }) {
    final malformed = <MalformedRequestFile>[];
    final requestsById = <String, RequestModel>{};
    final environmentsById = <String, EnvironmentModel>{};
    final environmentOrder = <String>[];

    final collectionData = _decodeObject(
      files[GitCollectionPaths.collection],
    );
    final requestOrder = (collectionData['requestOrder'] as List<dynamic>? ?? [])
        .whereType<String>()
        .toList();
    final activeEnvironmentId = collectionData['activeEnvironmentId'] as String?;

    for (final entry in files.entries) {
      final path = entry.key;
      if (!path.startsWith('${GitCollectionPaths.requestsDir}/') ||
          !path.endsWith('.json')) {
        continue;
      }

      final payload = _decodeObject(entry.value);
      if (payload.isEmpty) {
        malformed.add(
          MalformedRequestFile(
            path: path,
            reason: 'Invalid JSON object',
          ),
        );
        continue;
      }

      try {
        final model = RequestModel.fromJson(_normalizeRequestPayload(payload));
        if (model.id.isEmpty) {
          malformed.add(
            MalformedRequestFile(
              path: path,
              reason: 'Missing request id',
            ),
          );
          continue;
        }
        requestsById[model.id] = model;
      } catch (e) {
        try {
          final normalized = _normalizeRequestPayload(payload);
          final fallback = Map<String, dynamic>.from(normalized)
            ..remove('httpResponseModel')
            ..remove('responseStatus')
            ..remove('message');
          final model = RequestModel.fromJson(fallback);
          if (model.id.isNotEmpty) {
            requestsById[model.id] = model;
            continue;
          }
        } catch (_) {}
        malformed.add(
          MalformedRequestFile(
            path: path,
            reason: 'Malformed request payload: $e',
          ),
        );
      }
    }

    final envData = _decodeObject(files[GitCollectionPaths.environments]);
    final envList = envData['environments'] as List<dynamic>? ?? const <dynamic>[];
    for (final dynamic raw in envList) {
      if (raw is! Map<String, dynamic>) continue;
      try {
        final env = EnvironmentModel.fromJson(raw);
        environmentsById[env.id] = env;
      } catch (_) {}
    }

    final configuredEnvOrder =
        (envData['environmentOrder'] as List<dynamic>? ?? const <dynamic>[])
            .whereType<String>()
            .toList();
    if (configuredEnvOrder.isNotEmpty) {
      environmentOrder.addAll(
        configuredEnvOrder.where(environmentsById.containsKey),
      );
    } else {
      environmentOrder.addAll(environmentsById.keys);
    }

    final normalizedOrder = requestOrder.where(requestsById.containsKey).toList();
    if (normalizedOrder.length != requestsById.length) {
      final missing = requestsById.keys
          .where((id) => !normalizedOrder.contains(id))
          .toList(growable: false);
      normalizedOrder.addAll(missing);
    }

    final collection = CollectionModel(
      id: fallbackCollectionId,
      name: (collectionData['name'] as String?) ?? fallbackCollectionName,
      description: (collectionData['description'] as String?) ?? '',
      requestIds: normalizedOrder,
      activeEnvironmentId: activeEnvironmentId,
    );

    return GitCollectionImportResult(
      collection: collection,
      requestsById: requestsById,
      environmentsById: environmentsById,
      environmentOrder: environmentOrder,
      malformedRequests: malformed,
    );
  }

  static String _encodePretty(Map<String, dynamic> input) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(input);
  }

  static Map<String, dynamic> _decodeObject(String? source) {
    if (source == null || source.trim().isEmpty) {
      return <String, dynamic>{};
    }
    try {
      final json = jsonDecode(source);
      if (json is Map<String, dynamic>) return json;
      return <String, dynamic>{};
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  static String _buildUniqueRequestFileName({
    required String requestName,
    required Set<String> usedNames,
  }) {
    final base = _slugifyRequestName(requestName);
    var candidate = base.isEmpty ? 'untitled-request' : base;
    var suffix = 2;
    while (usedNames.contains(candidate)) {
      candidate = '${base.isEmpty ? 'untitled-request' : base}-$suffix';
      suffix += 1;
    }
    usedNames.add(candidate);
    return candidate;
  }

  static String _slugifyRequestName(String input) {
    final trimmed = input.trim().toLowerCase();
    if (trimmed.isEmpty) return '';
    final normalized = trimmed
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    return normalized;
  }

  static Map<String, dynamic> _normalizeRequestPayload(
    Map<String, dynamic> payload,
  ) {
    final out = Map<String, dynamic>.from(payload);

    final http = out['httpRequestModel'];
    if (http is Map) {
      final hm = http.map((key, value) => MapEntry(key.toString(), value));
      hm['headers'] = _normalizeListOrEmpty(hm['headers']);
      hm['params'] = _normalizeListOrEmpty(hm['params']);
      hm['isHeaderEnabledList'] =
          _normalizeListOrEmpty(hm['isHeaderEnabledList']);
      hm['isParamEnabledList'] = _normalizeListOrEmpty(hm['isParamEnabledList']);
      hm['formData'] = _normalizeListOrEmpty(hm['formData']);
      final auth = hm['authModel'];
      if (auth == null) {
        hm['authModel'] = <String, dynamic>{'type': 'none'};
      } else if (auth is Map) {
        hm['authModel'] =
            auth.map((key, value) => MapEntry(key.toString(), value));
      }
      out['httpRequestModel'] = hm;
    }

    final response = out['httpResponseModel'];
    if (response is Map) {
      final rm = response.map((key, value) => MapEntry(key.toString(), value));
      rm['headers'] = _normalizeMapOrEmpty(rm['headers']);
      rm['requestHeaders'] = _normalizeMapOrEmpty(rm['requestHeaders']);
      rm['bodyBytes'] = _normalizeListOrEmpty(rm['bodyBytes']);
      out['httpResponseModel'] = rm;
    }

    return out;
  }

  static List<dynamic> _normalizeListOrEmpty(dynamic value) {
    if (value is List) return value;
    return const <dynamic>[];
  }

  static Map<String, dynamic> _normalizeMapOrEmpty(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, val) => MapEntry(key.toString(), val));
    }
    return <String, dynamic>{};
  }

}
