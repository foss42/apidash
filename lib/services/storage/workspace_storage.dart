import 'dart:convert';
import 'dart:io';

import 'package:apidash/consts.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

import 'atomic_file_io.dart';
import 'workspace_paths.dart';

Directory? _workspaceRoot;

String _requestFileName(String id) => '$id$kJsonFileExtension';

String _environmentFileName(String id) => '$id$kJsonFileExtension';

String _collectionDir(String collectionId) =>
    p.join(kWorkspaceCollectionsDir, collectionId);

String _collectionFilePath(String collectionId) =>
    p.join(_collectionDir(collectionId), kWorkspaceCollectionFile);

String _requestFilePath(String collectionId, String requestId) => p.join(
      _collectionDir(collectionId),
      kWorkspaceRequestsSubdir,
      _requestFileName(requestId),
    );

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
  if (!await indexFile.exists()) {
    await writeJsonAtomic(indexFile.path, {
      kWorkspaceCollectionIdsKey: <String>[kDefaultCollectionId],
    });
  }

  final defaultCollectionDir = Directory(
    p.join(
      root.path,
      kWorkspaceCollectionsDir,
      kDefaultCollectionId,
      kWorkspaceRequestsSubdir,
    ),
  );
  if (!await defaultCollectionDir.exists()) {
    await defaultCollectionDir.create(recursive: true);
  }

  final collectionFile = File(
    p.join(
      root.path,
      kWorkspaceCollectionsDir,
      kDefaultCollectionId,
      kWorkspaceCollectionFile,
    ),
  );
  if (!await collectionFile.exists()) {
    await writeJsonAtomic(collectionFile.path, {
      kWorkspaceCollectionIdKey: kDefaultCollectionId,
      kWorkspaceCollectionNameKey: kDefaultCollectionName,
      kWorkspaceRequestIdsKey: <String>[],
    });
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

  final historyIndexFile = File(
    p.join(root.path, kWorkspaceHistoryDir, kWorkspaceHistoryIndexFile),
  );
  if (!await historyIndexFile.exists()) {
    await writeJsonAtomic(historyIndexFile.path, {
      kWorkspaceHistoryIdsKey: <String>[],
    });
  }
}

final workspaceStorage = WorkspaceStorage();

class WorkspaceStorage {
  WorkspaceStorage() {
    if (_workspaceRoot == null) {
      throw StateError(
        'Workspace not initialized. Call initWorkspaceStorage before using workspaceStorage.',
      );
    }
    _root = _workspaceRoot!;
  }

  late final Directory _root;

  bool get isInitialized => _workspaceRoot != null;

  String _path(String relative) => p.join(_root.path, relative);

  String get workspaceRootPath => _root.path;


  List<String>? getCollectionIds() {
    final json = _readJsonSync(
      p.join(kWorkspaceCollectionsDir, kWorkspaceCollectionsIndexFile),
    );
    if (json == null) {
      return null;
    }
    final ids = json[kWorkspaceCollectionIdsKey];
    if (ids is List) {
      return ids.map((e) => e.toString()).toList();
    }
    return null;
  }

  Future<void> setCollectionIds(List<String> ids) async {
    await writeJsonAtomic(
      _path(
        p.join(kWorkspaceCollectionsDir, kWorkspaceCollectionsIndexFile),
      ),
      {kWorkspaceCollectionIdsKey: ids},
    );
  }

  Map<String, dynamic>? getCollection(String collectionId) {
    final json = _readJsonSync(_collectionFilePath(collectionId));
    if (json == null) {
      return null;
    }
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
    final requestsDir = Directory(
      p.join(dir.path, kWorkspaceRequestsSubdir),
    );
    if (!await requestsDir.exists()) {
      await requestsDir.create(recursive: true);
    }
    await writeJsonAtomic(
      _path(_collectionFilePath(collectionId)),
      Map<String, Object?>.from(collectionJson),
    );
  }

  Future<void> deleteCollection(String collectionId) async {
    final dir = Directory(_path(_collectionDir(collectionId)));
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }


  List<String>? getIds(String collectionId) {
    final json = _readJsonSync(_collectionFilePath(collectionId));
    if (json == null) {
      return null;
    }
    final ids = json[kWorkspaceRequestIdsKey];
    if (ids is List) {
      return ids.map((e) => e.toString()).toList();
    }
    return null;
  }

  Future<void> setIds(String collectionId, List<String>? ids) async {
    final existing = getCollection(collectionId);
    final payload = Map<String, Object?>.from(existing ?? {
      kWorkspaceCollectionIdKey: collectionId,
      kWorkspaceCollectionNameKey: kDefaultCollectionName,
      kWorkspaceRequestIdsKey: <String>[],
    });
    payload[kWorkspaceRequestIdsKey] = ids ?? <String>[];
    await setCollection(collectionId, Map<String, dynamic>.from(payload));
  }

  Map<String, dynamic>? getRequestModel(String collectionId, String id) {
    final json = _readJsonSync(_requestFilePath(collectionId, id));
    if (json == null) {
      return null;
    }
    return Map<String, dynamic>.from(json);
  }

  Future<void> setRequestModel(
    String collectionId,
    String id,
    Map<String, dynamic>? requestModelJson,
  ) async {
    final filePath = _path(_requestFilePath(collectionId, id));
    if (requestModelJson == null) {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
      return;
    }
    await writeJsonAtomic(filePath, Map<String, Object?>.from(requestModelJson));
  }

  Future<void> delete(String collectionId, String key) async {
    final file = File(_path(_requestFilePath(collectionId, key)));
    if (await file.exists()) {
      await file.delete();
    }
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

  // --- History ---

  List<String>? getHistoryIds() {
    final json = _readJsonSync(
      p.join(kWorkspaceHistoryDir, kWorkspaceHistoryIndexFile),
    );
    if (json == null) {
      return null;
    }
    final ids = json[kWorkspaceHistoryIdsKey];
    if (ids is List) {
      return ids.map((e) => e.toString()).toList();
    }
    return null;
  }

  Future<void> setHistoryIds(List<String>? ids) async {
    await writeJsonAtomic(
      _path(p.join(kWorkspaceHistoryDir, kWorkspaceHistoryIndexFile)),
      {kWorkspaceHistoryIdsKey: ids ?? <String>[]},
    );
  }

  Map<String, dynamic>? getHistoryMeta(String id) {
    final json = _readJsonSync(
      p.join(kWorkspaceHistoryDir, id, kWorkspaceHistoryMetaFile),
    );
    if (json == null) {
      return null;
    }
    return Map<String, dynamic>.from(json);
  }

  Future<void> setHistoryMeta(
    String id,
    Map<String, dynamic>? historyMetaJson,
  ) async {
    if (historyMetaJson == null) {
      await deleteHistoryMeta(id);
      return;
    }
    await writeJsonAtomic(
      _path(p.join(kWorkspaceHistoryDir, id, kWorkspaceHistoryMetaFile)),
      Map<String, Object?>.from(historyMetaJson),
    );
  }

  Future<void> deleteHistoryMeta(String id) async {
    final file = File(
      _path(p.join(kWorkspaceHistoryDir, id, kWorkspaceHistoryMetaFile)),
    );
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<dynamic> getHistoryRequest(String id) async {
    final json = await readJsonFile(
      _path(p.join(kWorkspaceHistoryDir, id, kWorkspaceHistoryBodyFile)),
    );
    return json;
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
      _path(p.join(kWorkspaceHistoryDir, id, kWorkspaceHistoryBodyFile)),
      Map<String, Object?>.from(historyRequestJson),
    );
  }

  Future<void> deleteHistoryRequest(String id) async {
    final bodyFile = File(
      _path(p.join(kWorkspaceHistoryDir, id, kWorkspaceHistoryBodyFile)),
    );
    if (await bodyFile.exists()) {
      await bodyFile.delete();
    }
    final dir = Directory(_path(p.join(kWorkspaceHistoryDir, id)));
    if (await dir.exists()) {
      try {
        await dir.delete(recursive: true);
      } catch (e) {
        debugPrint('deleteHistoryRequest dir cleanup: $e');
      }
    }
  }

  // --- DashBot (in-memory only; no persistence in v1) ---

  Future<dynamic> getDashbotMessages() async => null;

  Future<void> saveDashbotMessages(String messages) async {}

  // --- Clear / maintenance ---

  Future<void> clearAllHistory() async {
    final historyDir = Directory(_path(kWorkspaceHistoryDir));
    if (await historyDir.exists()) {
      await for (final entity in historyDir.list()) {
        if (entity is File &&
            entity.path.endsWith(kWorkspaceHistoryIndexFile)) {
          continue;
        }
        await entity.delete(recursive: true);
      }
    }
    await setHistoryIds([]);
  }

  Future<void> clear() async {
    final collectionIds = getCollectionIds() ?? [kDefaultCollectionId];
    for (final collectionId in collectionIds) {
      await setIds(collectionId, []);
      final requestsDir = Directory(
        _path(p.join(_collectionDir(collectionId), kWorkspaceRequestsSubdir)),
      );
      if (await requestsDir.exists()) {
        await for (final entity in requestsDir.list()) {
          if (entity is File) {
            await entity.delete();
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

  Future<void> removeUnused(String collectionId) async {
    final ids = getIds(collectionId);
    if (ids != null) {
      final requestsDir = Directory(
        _path(p.join(_collectionDir(collectionId), kWorkspaceRequestsSubdir)),
      );
      if (await requestsDir.exists()) {
        await for (final entity in requestsDir.list()) {
          if (entity is! File) {
            continue;
          }
          final fileName = p.basenameWithoutExtension(entity.path);
          if (!ids.contains(fileName)) {
            await entity.delete();
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

  Map<String, Object?>? _readJsonSync(String relativePath) {
    final file = File(_path(relativePath));
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
      debugPrint('_readJsonSync failed for $relativePath: $e');
      return null;
    }
  }
}
