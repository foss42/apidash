import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:apidash/consts.dart';
import 'package:apidash/utils/file_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

import 'atomic_file_io.dart';
import 'workspace_paths.dart';

Directory? _workspaceRoot;

String _environmentFileName(String id) => '$id$kJsonFileExtension';

String _historyRecordPath(String id) =>
    p.join(kWorkspaceHistoryDir, '$id$kJsonFileExtension');

String _collectionDir(String collectionId) =>
    p.join(kWorkspaceCollectionsDir, collectionId);

String _collectionFilePath(String collectionId) =>
    p.join(_collectionDir(collectionId), kWorkspaceRequestIndexFile);

String _requestDirRelative(String collectionId, String requestId) => p.join(
      _collectionDir(collectionId),
      requestId,
    );

String _requestJsonRelative(String collectionId, String requestId) => p.join(
      _requestDirRelative(collectionId, requestId),
      kWorkspaceRequestFile,
    );

String _responseJsonRelative(String collectionId, String requestId) => p.join(
      _requestDirRelative(collectionId, requestId),
      kWorkspaceResponseFile,
    );

const Set<String> _kMediaFileTypes = {'image', 'audio', 'video'};

String? _contentTypeFromResponseMap(Map<String, Object?> response) {
  final headers = response['headers'];
  if (headers is! Map) {
    return null;
  }
  for (final entry in headers.entries) {
    if (entry.key.toString().toLowerCase() == 'content-type') {
      return entry.value?.toString();
    }
  }
  return null;
}

bool _isBinaryMediaContentType(String? contentType) {
  if (contentType == null) {
    return false;
  }
  final value = contentType.split(';').first.trim().toLowerCase();
  final parts = value.split('/');
  if (parts.length != 2 || parts[0].isEmpty || parts[1].isEmpty) {
    return false;
  }
  final type = parts[0];
  final subtype = parts[1];
  if (_kMediaFileTypes.contains(type)) {
    return true;
  }
  if (type == 'application') {
    return subtype == 'pdf' || subtype == 'octet-stream';
  }
  return false;
}

String _responseBodyFileName(String? contentType) {
  final mimeType = contentType?.split(';').first.trim();
  final ext = getFileExtension(mimeType) ?? 'bin';
  return '$kWorkspaceResponseBodyFilePrefix.$ext';
}

File? _resolveSafeResponseBodyFile(String requestDirPath, String fileName) {
  final trimmed = fileName.trim();
  if (trimmed.isEmpty || trimmed == '.' || trimmed == '..') {
    return null;
  }
  if (trimmed != p.basename(trimmed)) {
    return null;
  }

  final requestDir = p.normalize(requestDirPath);
  final resolved = p.normalize(p.join(requestDir, trimmed));
  if (resolved == requestDir || !p.isWithin(requestDir, resolved)) {
    return null;
  }
  return File(resolved);
}

Uint8List? _bytesFromJsonList(Object? value) {
  if (value is! List) {
    return null;
  }
  return Uint8List.fromList(
    value.map((e) => (e as num).toInt()).toList(growable: false),
  );
}

Future<bool> initWorkspaceStorage(
  bool initializeUsingPath,
  String? workspaceFolderPath, {
  bool createIfMissing = false,
}) async {
  try {
    final rootPath = await resolveWorkspaceRoot(
      useDesktopPath: initializeUsingPath,
      desktopPath: workspaceFolderPath,
    );
    if (rootPath == null) {
      return false;
    }
    final root = Directory(rootPath);
    if (!await root.exists()) {
      if (initializeUsingPath && !createIfMissing) {
        return false;
      }
      await root.create(recursive: true);
    }
    _workspaceRoot = root;
    await _ensureWorkspaceStructure(root);
    debugPrint('Workspace opened at ${root.path}');
    return true;
  } catch (e, st) {
    debugPrint('initWorkspaceStorage failed: $e\n$st');
    return false;
  }
}

Future<void> _ensureWorkspaceStructure(Directory root) async {
  final collectionsRoot = Directory(p.join(root.path, kWorkspaceCollectionsDir));
  if (!await collectionsRoot.exists()) {
    await collectionsRoot.create(recursive: true);
  }

  final indexFile = File(
    p.join(
      root.path,
      kWorkspaceCollectionsDir,
      kWorkspaceCollectionsIndexFile,
    ),
  );
  // Seed the default collection only for a brand-new workspace (no index file
  // yet). Once the index exists we respect it verbatim, including an empty
  // list, so a workspace the user has fully emptied is not reseeded on restart.
  final indexExists = await indexFile.exists();

  if (!indexExists) {
    await writeJsonAtomic(indexFile.path, {
      kWorkspaceCollectionsIndexKey: [
        {kWorkspaceCollectionNameKey: kDefaultCollectionName},
      ],
    });

    final defaultCollectionDir = Directory(
      p.join(
        root.path,
        kWorkspaceCollectionsDir,
        kDefaultCollectionName,
      ),
    );
    if (!await defaultCollectionDir.exists()) {
      await defaultCollectionDir.create(recursive: true);
    }

    final collectionFile = File(
      p.join(
        root.path,
        kWorkspaceCollectionsDir,
        kDefaultCollectionName,
        kWorkspaceRequestIndexFile,
      ),
    );
    if (!await collectionFile.exists()) {
      await writeJsonAtomic(collectionFile.path, {
        kWorkspaceCollectionNameKey: kDefaultCollectionName,
        kWorkspaceRequestsKey: <Map<String, Object?>>[],
      });
    }
  }

  final environmentsDir = Directory(p.join(root.path, kWorkspaceEnvironmentsDir));
  if (!await environmentsDir.exists()) {
    await environmentsDir.create(recursive: true);
  }
  final historyDir = Directory(p.join(root.path, kWorkspaceHistoryDir));
  if (!await historyDir.exists()) {
    await historyDir.create(recursive: true);
  }

  final envIndexFile = File(
    p.join(root.path, kWorkspaceEnvironmentsDir, kWorkspaceEnvironmentIndexFile),
  );
  if (!await envIndexFile.exists()) {
    await writeJsonAtomic(envIndexFile.path, {
      kWorkspaceEnvironmentIdsKey: <String>[kGlobalEnvironmentId],
    });
  }

  final globalEnvFile = File(
    p.join(
      root.path,
      kWorkspaceEnvironmentsDir,
      _environmentFileName(kGlobalEnvironmentId),
    ),
  );
  if (!await globalEnvFile.exists()) {
    await writeJsonAtomic(globalEnvFile.path, {
      'id': kGlobalEnvironmentId,
      'name': kGlobalEnvironmentName,
      'values': <Map<String, Object?>>[],
    });
  }

}

final workspaceStorage = WorkspaceStorage();

class WorkspaceStorage {
  WorkspaceStorage();

  String get rootPath => _root.path;

  Directory get _root {
    if (_workspaceRoot == null) {
      throw StateError(
        'Workspace not initialized. Call initWorkspaceStorage before using workspaceStorage.',
      );
    }
    return _workspaceRoot!;
  }

  String _path(String relative) => p.join(_root.path, relative);

  List<({String id, String name})> getCollectionsIndex() {
    final json = _readJsonSync(
      p.join(kWorkspaceCollectionsDir, kWorkspaceCollectionsIndexFile),
    );
    if (json == null) {
      return [];
    }
    final entries = json[kWorkspaceCollectionsIndexKey];
    if (entries is! List) {
      return [];
    }
    final result = <({String id, String name})>[];
    for (final item in entries) {
      if (item is! Map) {
        continue;
      }
      final name = item[kWorkspaceCollectionNameKey] as String?;
      if (name == null || name.trim().isEmpty) {
        continue;
      }
      result.add((id: makeCollectionId(name), name: name));
    }
    return result;
  }

  Future<void> setCollectionsIndex(
    List<({String id, String name})> collections,
  ) async {
    await writeJsonAtomic(
      _path(
        p.join(kWorkspaceCollectionsDir, kWorkspaceCollectionsIndexFile),
      ),
      {
        kWorkspaceCollectionsIndexKey: [
          for (final entry in collections)
            {kWorkspaceCollectionNameKey: entry.name},
        ],
      },
    );
  }

  Map<String, dynamic>? getCollection(String collectionId) {
    final json = _readJsonSync(_collectionFilePath(collectionId));
    if (json == null) {
      return null;
    }
    // The folder name is the authoritative id; inject it so callers never
    // depend on an id field persisted inside collection.json.
    json[kWorkspaceCollectionIdKey] = collectionId;
    return Map<String, dynamic>.from(json);
  }

  Future<void> setCollection(
    String collectionId,
    Map<String, dynamic> collectionJson,
  ) async {
    final dir = Directory(_path(_collectionDir(collectionId)));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    final payload = Map<String, Object?>.from(collectionJson)
      ..remove(kWorkspaceCollectionIdKey);
    await writeJsonAtomic(
      _path(_collectionFilePath(collectionId)),
      payload,
    );
  }

  Future<void> deleteCollection(String collectionId) async {
    final dir = Directory(_path(_collectionDir(collectionId)));
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  Future<void> renameCollection(String oldId, String newId) async {
    if (oldId == newId) {
      return;
    }
    final oldDir = Directory(_path(_collectionDir(oldId)));
    if (!await oldDir.exists()) {
      return;
    }
    final newDirPath = _path(_collectionDir(newId));
    final isCaseOnlyRename =
        oldDir.path.toLowerCase() == newDirPath.toLowerCase();
    if (!isCaseOnlyRename && await Directory(newDirPath).exists()) {
      return;
    }
    oldDir.renameSync(newDirPath);
  }

  List<String> getIds(String collectionId) {
    final json = _readJsonSync(_collectionFilePath(collectionId));
    if (json == null) {
      return [];
    }
    final requests = json[kWorkspaceRequestsKey];
    if (requests is! List) {
      return [];
    }
    return [
      for (final item in requests)
        if (item is Map && item['id'] != null) item['id'].toString(),
    ];
  }

  bool requestExistsOnDisk(String collectionId, String id) {
    return File(_path(_requestJsonRelative(collectionId, id))).existsSync();
  }

  Map<String, dynamic>? getRequestModel(String collectionId, String id) {
    final requestJson = _readJsonSync(_requestJsonRelative(collectionId, id));
    if (requestJson == null) {
      return null;
    }
    final merged = Map<String, Object?>.from(requestJson);
    final responseJson = _readJsonSync(_responseJsonRelative(collectionId, id));
    if (responseJson != null) {
      final requestDirPath = _path(_requestDirRelative(collectionId, id));
      merged['httpResponseModel'] =
          _inlineResponseBodyFile(requestDirPath, responseJson);
    }
    return Map<String, dynamic>.from(_fixBodyBytesForFromJson(merged));
  }

  Future<void> setRequestModel(
    String collectionId,
    String id,
    Map<String, dynamic>? requestModelJson, {
    bool saveMediaAsFiles = false,
  }) async {
    if (requestModelJson == null) {
      await _deleteRequestStorage(collectionId, id);
      return;
    }

    final payload = Map<String, Object?>.from(requestModelJson);
    final response = payload.remove('httpResponseModel');

    final requestDirPath = _path(_requestDirRelative(collectionId, id));
    final requestDir = Directory(requestDirPath);
    if (!await requestDir.exists()) {
      await requestDir.create(recursive: true);
    }

    await writeJsonAtomic(
      p.join(requestDirPath, kWorkspaceRequestFile),
      payload,
    );

    final responsePath = p.join(requestDirPath, kWorkspaceResponseFile);
    if (response is Map) {
      await _writeResponseStorage(
        requestDirPath,
        responsePath,
        Map<String, Object?>.from(response),
        saveMediaAsFiles,
      );
    } else {
      await _deleteResponseStorage(requestDirPath, responsePath);
    }
  }

  Future<void> _writeResponseStorage(
    String requestDirPath,
    String responsePath,
    Map<String, Object?> response,
    bool saveMediaAsFiles,
  ) async {
    await _deleteExistingResponseBodyFile(requestDirPath, responsePath);

    final contentType = _contentTypeFromResponseMap(response);
    final bytes = _bytesFromJsonList(response['bodyBytes']);
    final shouldExtract = saveMediaAsFiles &&
        bytes != null &&
        bytes.isNotEmpty &&
        _isBinaryMediaContentType(contentType);

    if (shouldExtract) {
      final fileName = _responseBodyFileName(contentType);
      await saveFile(p.join(requestDirPath, fileName), bytes);
      response.remove('bodyBytes');
      response[kWorkspaceResponseBodyFileKey] = fileName;
    } else {
      response.remove(kWorkspaceResponseBodyFileKey);
    }

    await writeJsonAtomic(responsePath, response);
  }

  Future<void> _deleteResponseStorage(
    String requestDirPath,
    String responsePath,
  ) async {
    await _deleteExistingResponseBodyFile(requestDirPath, responsePath);
    final responseFile = File(responsePath);
    if (await responseFile.exists()) {
      await responseFile.delete();
    }
  }

  Future<void> _deleteExistingResponseBodyFile(
    String requestDirPath,
    String responsePath,
  ) async {
    final existing = _readJsonFileSync(responsePath);
    final fileName = existing?[kWorkspaceResponseBodyFileKey];
    if (fileName is! String || fileName.isEmpty) {
      return;
    }
    final bodyFile = _resolveSafeResponseBodyFile(requestDirPath, fileName);
    if (bodyFile == null) {
      debugPrint(
        'Ignoring unsafe response bodyFile path for delete: $fileName',
      );
      return;
    }
    if (await bodyFile.exists()) {
      await bodyFile.delete();
    }
  }

  /// If [responseJson] points to a separate body file, reads it back into
  /// `bodyBytes` so the in-memory model is identical to an inlined response.
  Map<String, Object?> _inlineResponseBodyFile(
    String requestDirPath,
    Map<String, Object?> responseJson,
  ) {
    final fileName = responseJson[kWorkspaceResponseBodyFileKey];
    if (fileName is! String || fileName.isEmpty) {
      return responseJson;
    }
    final result = Map<String, Object?>.from(responseJson);
    result.remove(kWorkspaceResponseBodyFileKey);
    final bodyFile = _resolveSafeResponseBodyFile(requestDirPath, fileName);
    if (bodyFile == null) {
      debugPrint(
        'Ignoring unsafe response bodyFile path for read: $fileName',
      );
      return result;
    }
    try {
      if (bodyFile.existsSync()) {
        result['bodyBytes'] = bodyFile.readAsBytesSync();
      }
    } catch (e) {
      debugPrint('Failed to read response body file $fileName: $e');
    }
    return result;
  }

  Future<void> _deleteRequestStorage(String collectionId, String id) async {
    final requestDir = Directory(_path(_requestDirRelative(collectionId, id)));
    if (await requestDir.exists()) {
      await requestDir.delete(recursive: true);
    }
  }

  Future<void> renameRequest(
    String collectionId,
    String oldId,
    String newId,
  ) async {
    renameRequestSync(collectionId, oldId, newId);
  }

  void renameRequestSync(String collectionId, String oldId, String newId) {
    if (oldId == newId) {
      return;
    }
    final oldDir = Directory(_path(_requestDirRelative(collectionId, oldId)));
    if (!oldDir.existsSync()) {
      return;
    }
    final newDirPath = _path(_requestDirRelative(collectionId, newId));
    oldDir.renameSync(newDirPath);
    final requestFile = File(p.join(newDirPath, kWorkspaceRequestFile));
    if (!requestFile.existsSync()) {
      return;
    }
    final json = _readJsonSync(
      p.join(
        _requestDirRelative(collectionId, newId),
        kWorkspaceRequestFile,
      ),
    );
    if (json == null) {
      return;
    }
    json['id'] = newId;
    unawaited(
      writeJsonAtomic(requestFile.path, Map<String, Object?>.from(json)),
    );
  }

  // --- Environments ---

  List<String>? getEnvironmentIds() {
    final json = _readJsonSync(
      p.join(kWorkspaceEnvironmentsDir, kWorkspaceEnvironmentIndexFile),
    );
    if (json == null) {
      return null;
    }
    final ids = json[kWorkspaceEnvironmentIdsKey];
    if (ids is List) {
      return ids.map((e) => e.toString()).toList();
    }
    return null;
  }

  Future<void> setEnvironmentIds(List<String>? ids) async {
    await writeJsonAtomic(
      _path(p.join(kWorkspaceEnvironmentsDir, kWorkspaceEnvironmentIndexFile)),
      {kWorkspaceEnvironmentIdsKey: ids ?? <String>[]},
    );
  }

  Map<String, dynamic>? getEnvironment(String id) {
    final json = _readJsonSync(
      p.join(kWorkspaceEnvironmentsDir, _environmentFileName(id)),
    );
    if (json == null) {
      return null;
    }
    return Map<String, dynamic>.from(json);
  }

  Future<void> setEnvironment(
    String id,
    Map<String, dynamic>? environmentJson,
  ) async {
    if (environmentJson == null) {
      await deleteEnvironment(id);
      return;
    }
    await writeJsonAtomic(
      _path(p.join(kWorkspaceEnvironmentsDir, _environmentFileName(id))),
      Map<String, Object?>.from(environmentJson),
    );
  }

  Future<void> deleteEnvironment(String id) async {
    final file = File(
      _path(p.join(kWorkspaceEnvironmentsDir, _environmentFileName(id))),
    );
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<void> renameEnvironment(String oldId, String newId) async {
    renameEnvironmentSync(oldId, newId);
  }

  void renameEnvironmentSync(String oldId, String newId) {
    if (oldId == newId) {
      return;
    }
    final oldPath = _path(
      p.join(kWorkspaceEnvironmentsDir, _environmentFileName(oldId)),
    );
    final newPath = _path(
      p.join(kWorkspaceEnvironmentsDir, _environmentFileName(newId)),
    );
    final oldFile = File(oldPath);
    if (!oldFile.existsSync()) {
      return;
    }
    oldFile.renameSync(newPath);
    final json = getEnvironment(newId);
    if (json != null) {
      json['id'] = newId;
      unawaited(
        writeJsonAtomic(newPath, Map<String, Object?>.from(json)),
      );
    }
  }

  String _historyMetasPath() =>
      p.join(kWorkspaceHistoryDir, kWorkspaceHistoryIndexFile);

  Map<String, Map<String, dynamic>>? getAllHistoryMetas() {
    final json = _readJsonSync(_historyMetasPath());
    if (json == null) {
      return null;
    }
    final metas = json[kWorkspaceHistoryMetasKey];
    if (metas is! Map || metas.isEmpty) {
      return null;
    }
    return Map<String, Map<String, dynamic>>.fromEntries(
      metas.entries.map((e) {
        final value = e.value;
        if (value is! Map) {
          return MapEntry(e.key.toString(), <String, dynamic>{});
        }
        return MapEntry(
          e.key.toString(),
          Map<String, dynamic>.from(value),
        );
      }),
    );
  }

  Map<String, dynamic>? getHistoryMeta(String id) {
    return getAllHistoryMetas()?[id];
  }

  Future<void> setAllHistoryMetas(
    Map<String, Map<String, dynamic>>? metas,
  ) async {
    await writeJsonAtomic(
      _path(_historyMetasPath()),
      {
        kWorkspaceHistoryMetasKey:
            metas?.map((k, v) => MapEntry(k, Map<String, Object?>.from(v))) ??
                <String, Map<String, Object?>>{},
      },
    );
  }

  Future<void> setHistoryMeta(
    String id,
    Map<String, dynamic>? historyMetaJson,
  ) async {
    if (historyMetaJson == null) {
      await deleteHistoryMeta(id);
      return;
    }
    final all = Map<String, Map<String, dynamic>>.from(
      getAllHistoryMetas() ?? {},
    );
    all[id] = Map<String, dynamic>.from(historyMetaJson);
    await setAllHistoryMetas(all);
  }

  Future<void> deleteHistoryMeta(String id) async {
    final all = getAllHistoryMetas();
    if (all == null || !all.containsKey(id)) {
      return;
    }
    all.remove(id);
    await setAllHistoryMetas(all.isEmpty ? null : all);
  }

  Future<dynamic> getHistoryRequest(String id) async {
    final json = await readJsonFile(_path(_historyRecordPath(id)));
    if (json == null) {
      return null;
    }
    return _fixBodyBytesForFromJson(json);
  }

  Future<void> setHistoryRequest(
    String id,
    Map<String, dynamic>? historyRequestJson,
  ) async {
    if (historyRequestJson == null) {
      await deleteHistoryRequest(id);
      return;
    }
    await writeJsonAtomic(
      _path(_historyRecordPath(id)),
      Map<String, Object?>.from(historyRequestJson),
    );
  }

  Future<void> deleteHistoryRequest(String id) async {
    final recordFile = File(_path(_historyRecordPath(id)));
    if (await recordFile.exists()) {
      await recordFile.delete();
    }
  }


  Future<void> clearAllHistory() async {
    final historyDir = Directory(_path(kWorkspaceHistoryDir));
    if (await historyDir.exists()) {
      await for (final entity in historyDir.list()) {
        if (entity is File) {
          final name = p.basename(entity.path);
          if (name == kWorkspaceHistoryIndexFile) {
            continue;
          }
          if (name.endsWith(kJsonFileExtension)) {
            await entity.delete();
          }
        } else if (entity is Directory) {
          await entity.delete(recursive: true);
        }
      }
    }
    await setAllHistoryMetas(null);
  }

  Future<void> clear() async {
    final collectionIds = getCollectionsIndex().map((e) => e.id).toList();
    if (collectionIds.isEmpty) {
      collectionIds.add(kDefaultCollectionName);
    }
    for (final collectionId in collectionIds) {
      final existing = getCollection(collectionId);
      await setCollection(collectionId, {
        kWorkspaceCollectionIdKey: collectionId,
        kWorkspaceCollectionNameKey:
            existing?[kWorkspaceCollectionNameKey] as String? ??
                (collectionId == kDefaultCollectionName
                    ? kDefaultCollectionName
                    : collectionId),
        kWorkspaceRequestsKey: <Object?>[],
      });
      final collectionDir = Directory(_path(_collectionDir(collectionId)));
      if (await collectionDir.exists()) {
        await for (final entity in collectionDir.list()) {
          if (entity is Directory) {
            await entity.delete(recursive: true);
          }
        }
      }
    }

    final envIds = getEnvironmentIds() ?? [kGlobalEnvironmentId];
    for (final id in envIds) {
      if (id != kGlobalEnvironmentId) {
        await deleteEnvironment(id);
      }
    }
    await setEnvironmentIds([kGlobalEnvironmentId]);
    final globalJson = getEnvironment(kGlobalEnvironmentId);
    if (globalJson != null) {
      globalJson['values'] = <Map<String, Object?>>[];
      await setEnvironment(kGlobalEnvironmentId, globalJson);
    }

    await clearAllHistory();
  }

  Future<void> removeUnused(
    String collectionId, {
    Set<String>? requestIds,
  }) async {
    final ids = requestIds ?? getIds(collectionId).toSet();
    final collectionDir = Directory(_path(_collectionDir(collectionId)));
    if (await collectionDir.exists()) {
      await for (final entity in collectionDir.list()) {
        if (entity is Directory) {
          final dirName = p.basename(entity.path);
          if (!ids.contains(dirName)) {
            await entity.delete(recursive: true);
          }
        }
      }
    }

    final environmentIds = getEnvironmentIds();
    if (environmentIds != null) {
      final envDir = Directory(_path(kWorkspaceEnvironmentsDir));
      if (await envDir.exists()) {
        await for (final entity in envDir.list()) {
          if (entity is! File || !entity.path.endsWith(kJsonFileExtension)) {
            continue;
          }
          final fileName = p.basenameWithoutExtension(entity.path);
          if (fileName ==
              p.basenameWithoutExtension(kWorkspaceEnvironmentIndexFile)) {
            continue;
          }
          if (!environmentIds.contains(fileName)) {
            await entity.delete();
          }
        }
      }
    }
  }

  static Map<String, Object?> _fixBodyBytesForFromJson(Map<String, Object?> json) {
    final http = json['httpResponseModel'];
    if (http is Map) {
      final response = Map<String, Object?>.from(http);
      final bytes = response['bodyBytes'];
      if (bytes is List && bytes is! List<int>) {
        response['bodyBytes'] =
            bytes.map((e) => (e as num).toInt()).toList(growable: false);
      }
      return {...json, 'httpResponseModel': response};
    }
    return json;
  }

  Map<String, Object?>? _readJsonSync(String relativePath) {
    return _readJsonFileSync(_path(relativePath));
  }

  Map<String, Object?>? _readJsonFileSync(String absolutePath) {
    final file = File(absolutePath);
    if (!file.existsSync()) {
      return null;
    }
    try {
      final raw = file.readAsStringSync();
      if (raw.isEmpty) {
        return null;
      }
      final decoded = jsonDecode(raw);
      if (decoded is! Map) {
        return null;
      }
      return Map<String, Object?>.from(decoded);
    } catch (e) {
      debugPrint('_readJsonFileSync failed for $absolutePath: $e');
      return null;
    }
  }
}
