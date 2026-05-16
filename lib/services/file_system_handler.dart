import 'dart:convert';
import 'dart:io';

import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/services/git_collection_serializer.dart'
    show kGitCollectionGitignoreContents;
import 'package:apidash/utils/utils.dart'
    show
        collectionFolderIdFromDisplayName,
        collectionIdLooksLikeUuid,
        getNewUuid,
        uniqueCollectionFolderId;
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// On-disk paths under [FileSystemHandler.root].
abstract final class FsLayout {
  static const String manifest = 'manifest.json';
  static const String collectionsDir = 'collections';
  static const String environmentsDir = 'environments';
  static const String workflowsDir = 'workflows';
  static const String historyDir = 'history';
  static const String dashbotDir = 'dashbot';

  static String collectionFile(String collectionId) =>
      'collections/$collectionId/collection.json';

  static String collectionRequestsDir(String collectionId) =>
      'collections/$collectionId/requests';

  static String collectionRequestFile(String collectionId, String requestId) =>
      'collections/$collectionId/requests/$requestId.json';

  static String environmentFile(String envId) => 'environments/$envId.json';

  static String workflowFile(String workflowId) => 'workflows/$workflowId.json';

  static String workflowRunsFile(String workflowId) =>
      'workflows/runs_$workflowId.json';

  static String historyFile(String historyId) => 'history/$historyId.json';

  static const String dashbotMessages = 'dashbot/messages.json';
}

/// Absolute folder where a collection is stored (`apidash-data/collections/<id>`).
String collectionStorageDirectory(String collectionId) {
  return p.join(
    fileSystemHandler.root.path,
    FsLayout.collectionsDir,
    collectionId,
  );
}

Directory _apidashDataDirectoryUnder(Directory parent) =>
    Directory(p.join(parent.path, kApidashDataDirectoryName));

Future<bool> initFileSystemHandler(
  bool initializeUsingPath,
  String? workspaceFolderPath,
) async {
  try {
    await fileSystemHandler.init(
      initializeUsingPath: initializeUsingPath,
      workspaceFolderPath: workspaceFolderPath,
    );
    return true;
  } catch (e) {
    debugPrint('ERROR initFileSystemHandler: $e');
    return false;
  }
}

final fileSystemHandler = FileSystemHandler._();

/// Data loaded synchronously from disk after [FileSystemHandler.init] for immediate UI bootstrap.
typedef FileBootstrapSnapshot = ({
  Map<String, CollectionModel> collections,
  String activeCollectionId,
  List<String> requestSequence,
  Map<String, RequestModel> requestsById,
});

/// Filesystem-backed persistence replacing [HiveHandler].
class FileSystemHandler {
  FileSystemHandler._();

  Directory? _root;

  List<String> _collectionIds = [];
  String? _activeCollectionId;
  List<String> _requestSequenceIds = [];
  List<String> _environmentIds = [];
  List<String> _workflowIds = [];
  String? _activeWorkflowId;
  List<String> _historyIds = [];
  String? _dashbotMessages;

  final Map<String, Map<String, dynamic>> _requestMetaById = {};

  Directory get root {
    final r = _root;
    if (r == null) {
      throw StateError('FileSystemHandler not initialized');
    }
    return r;
  }

  Future<void> init({
    required bool initializeUsingPath,
    String? workspaceFolderPath,
  }) async {
    if (initializeUsingPath) {
      if (workspaceFolderPath != null) {
        _root = _apidashDataDirectoryUnder(Directory(workspaceFolderPath));
      } else {
        throw StateError('workspaceFolderPath required when initializeUsingPath');
      }
    } else {
      final doc = await getApplicationDocumentsDirectory();
      _root = _apidashDataDirectoryUnder(Directory(doc.path));
    }
    await root.create(recursive: true);
    await _loadManifest();
    await _migrateUuidCollectionFoldersToSlugIds();
    await _ensureGlobalEnvironment();
    if (_collectionIds.isEmpty) {
      await _seedDefaultCollectionIfEmpty();
    }
    await _ensureAllCollectionGitignores();
  }

  Future<void> _seedDefaultCollectionIfEmpty() async {
    final collectionId =
        collectionFolderIdFromDisplayName('Default Collection');
    final requestId = getNewUuid();
    final now = DateTime.now();
    final collection = CollectionModel(
      id: collectionId,
      name: 'Default Collection',
      requestIds: [requestId],
      createdAt: now,
      updatedAt: now,
    );
    final request = RequestModel(
      id: requestId,
      httpRequestModel: const HttpRequestModel(),
    );
    _collectionIds = [collectionId];
    _activeCollectionId = collectionId;
    _requestSequenceIds = [requestId];
    await _persistManifest();
    await setCollectionMeta(collectionId, collection.toJson());
    await setCollectionRequestModel(
      collectionId,
      requestId,
      request.toJson(),
    );
    await _loadRequestMetaFromDisk();
  }

  Future<void> _ensureGlobalEnvironment() async {
    final f = _file(FsLayout.environmentFile(kGlobalEnvironmentId));
    if (!await f.exists()) {
      const global = EnvironmentModel(
        id: kGlobalEnvironmentId,
        name: 'Global',
        values: [],
      );
      await _writeJsonFile(f, global.toJson());
    }
    if (!_environmentIds.contains(kGlobalEnvironmentId)) {
      _environmentIds = [kGlobalEnvironmentId, ..._environmentIds];
      await _persistManifest();
    }
  }

  Future<void> _loadManifest() async {
    final file = _file(FsLayout.manifest);
    if (!await file.exists()) {
      _resetCaches();
      return;
    }
    try {
      final map = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      _collectionIds = (map['collectionIds'] as List<dynamic>?)
              ?.whereType<String>()
              .toList() ??
          [];
      _activeCollectionId = map['activeCollectionId'] as String?;
      _requestSequenceIds = (map['requestSequenceIds'] as List<dynamic>?)
              ?.whereType<String>()
              .toList() ??
          [];
      _environmentIds = (map['environmentIds'] as List<dynamic>?)
              ?.whereType<String>()
              .toList() ??
          [];
      _workflowIds =
          (map['workflowIds'] as List<dynamic>?)?.whereType<String>().toList() ??
              [];
      _activeWorkflowId = map['activeWorkflowId'] as String?;
      _historyIds =
          (map['historyIds'] as List<dynamic>?)?.whereType<String>().toList() ??
              [];
      _dashbotMessages = map['dashbotMessages'] as String?;
    } catch (_) {
      _resetCaches();
    }
    await _loadRequestMetaFromDisk();
  }

  /// When [init] has populated caches and JSON exists on disk, load everything synchronously
  /// so [CollectionStateNotifier] can set state before the first async tick (tests + UX).
  FileBootstrapSnapshot? loadBootstrapSnapshotSync() {
    if (_collectionIds.isEmpty) return null;
    final active = _activeCollectionId ?? _collectionIds.first;
    final collections = <String, CollectionModel>{};
    for (final cid in _collectionIds) {
      final cf = _file(FsLayout.collectionFile(cid));
      if (!cf.existsSync()) continue;
      try {
        final j = jsonDecode(cf.readAsStringSync());
        if (j is Map) {
          collections[cid] = CollectionModel.fromJson(
            Map<String, dynamic>.from(j),
          );
        }
      } catch (_) {}
    }
    if (collections.isEmpty) return null;
    final requests = <String, RequestModel>{};
    for (final rid in _requestSequenceIds) {
      final f = _file(FsLayout.collectionRequestFile(active, rid));
      if (!f.existsSync()) continue;
      try {
        final j = jsonDecode(f.readAsStringSync());
        if (j is Map) {
          var m = RequestModel.fromJson(Map<String, dynamic>.from(j));
          if (m.httpRequestModel == null) {
            m = m.copyWith(httpRequestModel: const HttpRequestModel());
          }
          requests[rid] = m;
        }
      } catch (_) {}
    }
    return (
      collections: collections,
      activeCollectionId: active,
      requestSequence: List<String>.from(_requestSequenceIds),
      requestsById: requests,
    );
  }

  void _resetCaches() {
    _collectionIds = [];
    _activeCollectionId = null;
    _requestSequenceIds = [];
    _environmentIds = [];
    _workflowIds = [];
    _activeWorkflowId = null;
    _historyIds = [];
    _dashbotMessages = null;
    _requestMetaById.clear();
  }

  Future<void> _loadRequestMetaFromDisk() async {
    _requestMetaById.clear();
    final cid = _activeCollectionId;
    if (cid == null) return;
    for (final id in _requestSequenceIds) {
      final raw = await getCollectionRequestModel(cid, id);
      if (raw is Map) {
        _putRequestMetaForRequestMap(id, Map<String, dynamic>.from(raw));
      }
    }
  }

  File _file(String relative) => File(p.join(root.path, relative));

  Future<void> _writeJsonFile(File file, Map<String, dynamic> data) async {
    const encoder = JsonEncoder.withIndent('  ');
    await writeAtomicString(file, encoder.convert(data));
  }

  Future<void> _persistManifest() async {
    await _writeJsonFile(_file(FsLayout.manifest), {
      'version': 1,
      'collectionIds': _collectionIds,
      'activeCollectionId': _activeCollectionId,
      'requestSequenceIds': _requestSequenceIds,
      'environmentIds': _environmentIds,
      'workflowIds': _workflowIds,
      'activeWorkflowId': _activeWorkflowId,
      'historyIds': _historyIds,
      'dashbotMessages': _dashbotMessages,
    });
  }

  void _putRequestMetaForRequestMap(
    String requestId,
    Map<String, dynamic>? requestModelJson,
  ) {
    if (requestModelJson == null) {
      _requestMetaById.remove(requestId);
      return;
    }
    final m = RequestModel.fromJson(requestModelJson);
    final meta = RequestMetaModel(
      id: m.id,
      name: m.name,
      url: m.httpRequestModel?.url ?? '',
      method: m.httpRequestModel?.method ?? HTTPVerb.get,
      apiType: m.apiType,
      responseStatus: m.responseStatus,
      description: m.description,
    );
    _requestMetaById[requestId] = meta.toJson();
  }

  dynamic getIds() =>
      _requestSequenceIds.isEmpty ? null : [..._requestSequenceIds];

  Future<void> setIds(List<String>? ids) async {
    _requestSequenceIds = ids == null ? [] : [...ids];
    await _persistManifest();
  }

  List<RequestMetaModel> loadRequestMeta() {
    final ids = getIds();
    if (ids == null || ids is! List) return [];
    final metaList = <RequestMetaModel>[];
    for (final id in ids) {
      if (id is! String) continue;
      final metaJson = _requestMetaById[id];
      if (metaJson == null) continue;
      try {
        metaList.add(
          RequestMetaModel.fromJson(Map<String, dynamic>.from(metaJson)),
        );
      } catch (_) {}
    }
    return metaList;
  }

  Future<RequestModel?> loadRequest(String id) async {
    final json = await getRequestModel(id);
    if (json != null && json is Map) {
      return RequestModel.fromJson(Map<String, dynamic>.from(json));
    }
    return null;
  }

  Future<dynamic> getRequestModel(String id) async {
    final cid = _activeCollectionId;
    if (cid == null) return null;
    return getCollectionRequestModel(cid, id);
  }

  Future<void> setRequestModel(
    String id,
    Map<String, dynamic>? requestModelJson,
  ) async {
    final cid = _activeCollectionId;
    if (cid == null) return;
    await setCollectionRequestModel(cid, id, requestModelJson);
  }

  Future<void> setCollectionRequestModel(
    String collectionId,
    String requestId,
    Map<String, dynamic>? requestModelJson,
  ) async {
    final file = _file(FsLayout.collectionRequestFile(collectionId, requestId));
    if (requestModelJson == null) {
      if (await file.exists()) await file.delete();
      _requestMetaById.remove(requestId);
      return;
    }
    await file.parent.create(recursive: true);
    await _writeJsonFile(file, requestModelJson);
    _putRequestMetaForRequestMap(requestId, requestModelJson);
    await _writeCollectionGitignore(collectionId);
  }

  Future<dynamic> getCollectionRequestModel(
    String collectionId,
    String requestId,
  ) async {
    final file = _file(FsLayout.collectionRequestFile(collectionId, requestId));
    if (!await file.exists()) return null;
    try {
      final text = await file.readAsString();
      final json = jsonDecode(text);
      if (json is Map<String, dynamic>) return json;
      if (json is Map) {
        return json.map((k, v) => MapEntry(k.toString(), v));
      }
    } catch (_) {}
    return null;
  }

  Future<dynamic> getCollectionIds() async {
    if (_collectionIds.isEmpty) return null;
    return [..._collectionIds];
  }

  Future<void> setCollectionIds(List<String>? ids) async {
    _collectionIds = ids == null ? [] : [...ids];
    await _persistManifest();
  }

  Future<String?> getActiveCollectionId() async => _activeCollectionId;

  Future<void> setActiveCollectionId(String? collectionId) async {
    _activeCollectionId = collectionId;
    await _persistManifest();
    await _loadRequestMetaFromDisk();
  }

  Future<dynamic> getCollectionMeta(String collectionId) async {
    final file = _file(FsLayout.collectionFile(collectionId));
    if (!await file.exists()) return null;
    try {
      final text = await file.readAsString();
      final json = jsonDecode(text);
      if (json is Map<String, dynamic>) return json;
      if (json is Map) {
        return json.map((k, v) => MapEntry(k.toString(), v));
      }
    } catch (_) {}
    return null;
  }

  Future<void> setCollectionMeta(
    String collectionId,
    Map<String, dynamic>? collectionMetaJson,
  ) async {
    final file = _file(FsLayout.collectionFile(collectionId));
    if (collectionMetaJson == null) {
      if (await file.exists()) await file.delete();
      return;
    }
    await file.parent.create(recursive: true);
    await _writeJsonFile(file, collectionMetaJson);
    await _writeCollectionGitignore(collectionId);
  }

  Future<void> _writeCollectionGitignore(String collectionId) async {
    final dir = Directory(
      p.join(root.path, FsLayout.collectionsDir, collectionId),
    );
    if (!await dir.exists()) return;
    final gf = File(p.join(dir.path, '.gitignore'));
    await gf.writeAsString(kGitCollectionGitignoreContents);
  }

  Future<void> _ensureAllCollectionGitignores() async {
    for (final id in List<String>.from(_collectionIds)) {
      await _writeCollectionGitignore(id);
    }
  }

  Future<dynamic> getCollectionRequestIds(String collectionId) async {
    final meta = await getCollectionMeta(collectionId);
    if (meta is Map) {
      final ids = meta['requestIds'];
      if (ids is List) {
        return ids.whereType<String>().toList();
      }
    }
    final dir = Directory(p.join(root.path, FsLayout.collectionRequestsDir(collectionId)));
    if (!await dir.exists()) return <String>[];
    final out = <String>[];
    await for (final e in dir.list()) {
      if (e is! File || !e.path.endsWith('.json')) continue;
      out.add(p.basenameWithoutExtension(e.path));
    }
    return out;
  }

  Future<void> setCollectionRequestIds(
    String collectionId,
    List<String>? ids,
  ) async {
    final raw = await getCollectionMeta(collectionId);
    Map<String, dynamic> map;
    if (raw is Map) {
      map = Map<String, dynamic>.from(
        raw.map((k, v) => MapEntry(k.toString(), v)),
      );
    } else {
      map = <String, dynamic>{
        'id': collectionId,
        'name': 'Collection',
        'requestIds': ids ?? [],
      };
    }
    map['requestIds'] = ids ?? [];
    await setCollectionMeta(collectionId, map);
  }

  Future<dynamic> getWorkflowIds() async {
    if (_workflowIds.isEmpty) return null;
    return [..._workflowIds];
  }

  Future<void> setWorkflowIds(List<String>? ids) async {
    _workflowIds = ids == null ? [] : [...ids];
    await _persistManifest();
  }

  Future<String?> getActiveWorkflowId() async => _activeWorkflowId;

  Future<void> setActiveWorkflowId(String? workflowId) async {
    _activeWorkflowId = workflowId;
    await _persistManifest();
  }

  Future<dynamic> getWorkflow(String workflowId) async {
    final file = _file(FsLayout.workflowFile(workflowId));
    if (!await file.exists()) return null;
    try {
      final text = await file.readAsString();
      final json = jsonDecode(text);
      if (json is Map<String, dynamic>) return json;
      if (json is Map) {
        return json.map((k, v) => MapEntry(k.toString(), v));
      }
    } catch (_) {}
    return null;
  }

  Future<void> setWorkflow(
    String workflowId,
    Map<String, dynamic>? workflowJson,
  ) async {
    final file = _file(FsLayout.workflowFile(workflowId));
    if (workflowJson == null) {
      if (await file.exists()) await file.delete();
      return;
    }
    await file.parent.create(recursive: true);
    await _writeJsonFile(file, workflowJson);
  }

  Future<dynamic> getWorkflowRunHistory(String workflowId) async {
    final file = _file(FsLayout.workflowRunsFile(workflowId));
    if (!await file.exists()) return null;
    try {
      final text = await file.readAsString();
      return jsonDecode(text);
    } catch (_) {
      return null;
    }
  }

  Future<void> setWorkflowRunHistory(
    String workflowId,
    List<Map<String, dynamic>>? runsJson,
  ) async {
    final file = _file(FsLayout.workflowRunsFile(workflowId));
    if (runsJson == null) {
      if (await file.exists()) await file.delete();
      return;
    }
    await file.parent.create(recursive: true);
    await writeAtomicString(file, jsonEncode(runsJson));
  }

  Future<void> deleteWorkflow(String workflowId) async {
    final wf = _file(FsLayout.workflowFile(workflowId));
    final runs = _file(FsLayout.workflowRunsFile(workflowId));
    if (await wf.exists()) await wf.delete();
    if (await runs.exists()) await runs.delete();
  }

  Future<void> deleteCollection(String collectionId) async {
    final dir = Directory(p.join(root.path, FsLayout.collectionsDir, collectionId));
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
    _collectionIds.remove(collectionId);
    await _persistManifest();
  }

  Future<void> delete(String key) async {
    debugPrint('FileSystemHandler.delete($key) — no-op');
  }

  dynamic getEnvironmentIds() =>
      _environmentIds.isEmpty ? null : [..._environmentIds];

  Future<void> setEnvironmentIds(List<String>? ids) async {
    _environmentIds = ids == null ? [] : [...ids];
    await _persistManifest();
  }

  dynamic getEnvironment(String id) {
    final file = _file(FsLayout.environmentFile(id));
    if (!file.existsSync()) return null;
    try {
      final text = file.readAsStringSync();
      final json = jsonDecode(text);
      if (json is Map<String, dynamic>) return json;
      if (json is Map) {
        return json.map((k, v) => MapEntry(k.toString(), v));
      }
    } catch (_) {}
    return null;
  }

  Future<void> setEnvironment(
    String id,
    Map<String, dynamic>? environmentJson,
  ) async {
    final file = _file(FsLayout.environmentFile(id));
    if (environmentJson == null) {
      if (await file.exists()) await file.delete();
      return;
    }
    await file.parent.create(recursive: true);
    await _writeJsonFile(file, environmentJson);
  }

  Future<void> deleteEnvironment(String id) async {
    final file = _file(FsLayout.environmentFile(id));
    if (await file.exists()) await file.delete();
  }

  dynamic getHistoryIds() =>
      _historyIds.isEmpty ? null : [..._historyIds];

  Future<void> setHistoryIds(List<String>? ids) async {
    _historyIds = ids == null ? [] : [...ids];
    await _persistManifest();
  }

  dynamic getHistoryMeta(String id) {
    final file = _file(FsLayout.historyFile(id));
    if (!file.existsSync()) return null;
    try {
      final text = file.readAsStringSync();
      final json = jsonDecode(text);
      if (json is! Map) return null;
      final model = HistoryRequestModel.fromJson(
        Map<String, dynamic>.from(json),
      );
      return model.metaData.toJson();
    } catch (_) {
      return null;
    }
  }

  Future<void> setHistoryMeta(
    String id,
    Map<String, dynamic>? historyMetaJson,
  ) async {
    if (historyMetaJson == null) return;
    final existing = await getHistoryRequest(id);
    if (existing is! Map) return;
    final full = Map<String, dynamic>.from(
      existing.map((k, v) => MapEntry(k.toString(), v)),
    );
    full['metaData'] = historyMetaJson;
    await setHistoryRequest(id, full);
  }

  Future<dynamic> getHistoryRequest(String id) async {
    final file = _file(FsLayout.historyFile(id));
    if (!await file.exists()) return null;
    try {
      final text = await file.readAsString();
      final json = jsonDecode(text);
      if (json is Map<String, dynamic>) return json;
      if (json is Map) {
        return json.map((k, v) => MapEntry(k.toString(), v));
      }
    } catch (_) {}
    return null;
  }

  Future<void> setHistoryRequest(
    String id,
    Map<String, dynamic>? historyRequestJson,
  ) async {
    final file = _file(FsLayout.historyFile(id));
    if (historyRequestJson == null) {
      if (await file.exists()) await file.delete();
      return;
    }
    await file.parent.create(recursive: true);
    await _writeJsonFile(file, historyRequestJson);
  }

  Future<void> deleteHistoryRequest(String id) async {
    final file = _file(FsLayout.historyFile(id));
    if (await file.exists()) await file.delete();
  }

  Future<void> deleteHistoryMeta(String id) async {
    await deleteHistoryRequest(id);
  }

  Future<dynamic> getDashbotMessages() async {
    if (_dashbotMessages != null) return _dashbotMessages;
    final file = _file(FsLayout.dashbotMessages);
    if (!await file.exists()) return null;
    try {
      final text = await file.readAsString();
      final json = jsonDecode(text);
      if (json is Map && json['messages'] is String) {
        return json['messages'];
      }
      return text;
    } catch (_) {
      return null;
    }
  }

  Future<void> saveDashbotMessages(String messages) async {
    _dashbotMessages = messages;
    await _persistManifest();
    final file = _file(FsLayout.dashbotMessages);
    await file.parent.create(recursive: true);
    await _writeJsonFile(file, {'messages': messages});
  }

  Future<void> clearAllHistory() async {
    final dir = Directory(p.join(root.path, FsLayout.historyDir));
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
    await Directory(p.join(root.path, FsLayout.historyDir)).create(recursive: true);
    _historyIds = [];
    await _persistManifest();
  }

  Future<void> clear() async {
    if (await root.exists()) {
      await root.delete(recursive: true);
    }
    await root.create(recursive: true);
    _resetCaches();
    await _persistManifest();
    await _ensureGlobalEnvironment();
  }

  Future<void> removeUnused() async {
    final activeIds = <String>{};
    for (final cId in _collectionIds) {
      final raw = await getCollectionRequestIds(cId);
      final ids = (raw as List?)?.whereType<String>() ?? [];
      activeIds.addAll(ids);
    }

    for (final cId in _collectionIds) {
      final raw = await getCollectionRequestIds(cId);
      final valid = (raw as List?)?.whereType<String>().toSet() ?? {};
      final reqDir = Directory(
        p.join(root.path, FsLayout.collectionRequestsDir(cId)),
      );
      if (await reqDir.exists()) {
        await for (final e in reqDir.list()) {
          if (e is! File || !e.path.endsWith('.json')) continue;
          final rid = p.basenameWithoutExtension(e.path);
          if (!valid.contains(rid)) {
            await e.delete();
          }
        }
      }
    }

    for (final key in _requestMetaById.keys.toList()) {
      if (!activeIds.contains(key)) {
        _requestMetaById.remove(key);
      }
    }

    if (_environmentIds.isNotEmpty) {
      final envDir = Directory(p.join(root.path, FsLayout.environmentsDir));
      if (await envDir.exists()) {
        await for (final e in envDir.list()) {
          if (e is! File || !e.path.endsWith('.json')) continue;
          final eid = p.basenameWithoutExtension(e.path);
          if (!_environmentIds.contains(eid)) {
            await e.delete();
          }
        }
      }
    }

    final wfDir = Directory(p.join(root.path, FsLayout.workflowsDir));
    if (await wfDir.exists()) {
      await for (final e in wfDir.list()) {
        if (e is! File) continue;
        final base = p.basename(e.path);
        if (base.startsWith('runs_')) {
          final wid = base.replaceFirst('runs_', '').replaceAll('.json', '');
          if (!_workflowIds.contains(wid)) {
            await e.delete();
          }
        } else if (base.endsWith('.json')) {
          final wid = p.basenameWithoutExtension(base);
          if (!_workflowIds.contains(wid)) {
            await e.delete();
          }
        }
      }
    }
  }

  /// One-time migration: `collections/<uuid>/` → `collections/<slug-from-name>/`.
  Future<void> _migrateUuidCollectionFoldersToSlugIds() async {
    var ids = [..._collectionIds];
    final used = ids.toSet();
    var changed = false;
    for (var i = 0; i < ids.length; i++) {
      final oldId = ids[i];
      if (!collectionIdLooksLikeUuid(oldId)) continue;
      final raw = await getCollectionMeta(oldId);
      if (raw is! Map) continue;
      final name = raw['name'] as String? ?? 'Collection';
      final others = used.difference({oldId});
      final newId = uniqueCollectionFolderId(name, others);
      if (newId == oldId) continue;
      final ok = await _renameCollectionRootOnDisk(oldId, newId);
      if (!ok) continue;
      ids[i] = newId;
      used.remove(oldId);
      used.add(newId);
      if (_activeCollectionId == oldId) {
        _activeCollectionId = newId;
      }
      final meta = Map<String, dynamic>.from(
        raw.map((k, v) => MapEntry(k.toString(), v)),
      );
      meta['id'] = newId;
      await setCollectionMeta(newId, meta);
      changed = true;
    }
    if (changed) {
      _collectionIds = ids;
      await _persistManifest();
      await _loadRequestMetaFromDisk();
    }
  }

  Future<bool> _renameCollectionRootOnDisk(String oldId, String newId) async {
    final oldDir = Directory(p.join(root.path, FsLayout.collectionsDir, oldId));
    final newDir = Directory(p.join(root.path, FsLayout.collectionsDir, newId));
    if (!await oldDir.exists()) return false;
    if (await newDir.exists()) return false;
    try {
      await oldDir.rename(newDir.path);
      return true;
    } catch (e, st) {
      debugPrint('Could not rename collection folder $oldId → $newId: $e\n$st');
      return false;
    }
  }
}

Future<void> writeAtomicString(File target, String content) async {
  await target.parent.create(recursive: true);
  final tmp = File('${target.path}.${getNewUuid()}.tmp');
  await tmp.writeAsString(content);
  try {
    if (await target.exists()) {
      await target.delete();
    }
  } catch (_) {}
  try {
    await tmp.rename(target.path);
  } catch (e) {
    try {
      await target.writeAsString(content);
    } catch (_) {}
    try {
      if (await tmp.exists()) {
        await tmp.delete();
      }
    } catch (_) {}
  }
}
