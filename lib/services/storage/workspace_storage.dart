import 'dart:convert';
import 'dart:io';

import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

import 'atomic_file_io.dart';
import 'workspace_paths.dart';

Directory? _workspaceRoot;

String _requestFileName(String id) => '$id$kJsonFileExtension';

String _environmentFileName(String id) => '$id$kJsonFileExtension';

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
  final collectionDir = Directory(
    p.join(
      root.path,
      kWorkspaceCollectionsDir,
      kDefaultCollectionId,
      kWorkspaceRequestsSubdir,
    ),
  );
  if (!await collectionDir.exists()) {
    await collectionDir.create(recursive: true);
  }
  final environmentsDir = Directory(p.join(root.path, kWorkspaceEnvironmentsDir));
  if (!await environmentsDir.exists()) {
    await environmentsDir.create(recursive: true);
  }
  final historyDir = Directory(p.join(root.path, kWorkspaceHistoryDir));
  if (!await historyDir.exists()) {
    await historyDir.create(recursive: true);
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
      kWorkspaceRequestIdsKey: <String>[],
    });
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

  final settingsFile = File(p.join(root.path, kAppSettingsFileName));
  if (!await settingsFile.exists()) {
    const defaults = SettingsModel();
    final json = Map<String, Object?>.from(defaults.toJson());
    json[kAppSettingsVersionKey] = kAppSettingsVersion;
    await writeJsonAtomic(settingsFile.path, json);
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

  // --- Collection (requests) ---

  List<String>? getIds() {
    final json = _readJsonSync(
      p.join(
        kWorkspaceCollectionsDir,
        kDefaultCollectionId,
        kWorkspaceCollectionFile,
      ),
    );
    if (json == null) {
      return null;
    }
    final ids = json[kWorkspaceRequestIdsKey];
    if (ids is List) {
      return ids.map((e) => e.toString()).toList();
    }
    return null;
  }

  Future<void> setIds(List<String>? ids) async {
    await writeJsonAtomic(
      _path(
        p.join(
          kWorkspaceCollectionsDir,
          kDefaultCollectionId,
          kWorkspaceCollectionFile,
        ),
      ),
      {kWorkspaceRequestIdsKey: ids ?? <String>[]},
    );
  }

  Map<String, dynamic>? getRequestModel(String id) {
    final json = _readJsonSync(
      p.join(
        kWorkspaceCollectionsDir,
        kDefaultCollectionId,
        kWorkspaceRequestsSubdir,
        _requestFileName(id),
      ),
    );
    if (json == null) {
      return null;
    }
    return Map<String, dynamic>.from(json);
  }

  Future<void> setRequestModel(
    String id,
    Map<String, dynamic>? requestModelJson,
  ) async {
    final filePath = _path(
      p.join(
        kWorkspaceCollectionsDir,
        kDefaultCollectionId,
        kWorkspaceRequestsSubdir,
        _requestFileName(id),
      ),
    );
    if (requestModelJson == null) {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
      return;
    }
    await writeJsonAtomic(filePath, Map<String, Object?>.from(requestModelJson));
  }

  Future<void> delete(String key) async {
    final file = File(
      _path(
        p.join(
          kWorkspaceCollectionsDir,
          kDefaultCollectionId,
          kWorkspaceRequestsSubdir,
          _requestFileName(key),
        ),
      ),
    );
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
    await setIds([]);
    final requestsDir = Directory(
      _path(
        p.join(
          kWorkspaceCollectionsDir,
          kDefaultCollectionId,
          kWorkspaceRequestsSubdir,
        ),
      ),
    );
    if (await requestsDir.exists()) {
      await for (final entity in requestsDir.list()) {
        if (entity is File) {
          await entity.delete();
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

  Future<void> removeUnused() async {
    final ids = getIds();
    if (ids != null) {
      final requestsDir = Directory(
        _path(
          p.join(
            kWorkspaceCollectionsDir,
            kDefaultCollectionId,
            kWorkspaceRequestsSubdir,
          ),
        ),
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
