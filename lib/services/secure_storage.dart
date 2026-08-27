import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

FlutterSecureStorage _createSecureStorage() => const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      mOptions: MacOsOptions(useDataProtectionKeyChain: false),
    );

String _workspaceId(String workspacePath) =>
    base64Url.encode(utf8.encode(workspacePath));

const _secretsStorageKey = 'apidash_secrets';
const _defaultAiApiKeyField = 'defaultAiApiKey';

String _requestCompositeKey(String collectionId, String requestId) =>
    '$collectionId/$requestId';

String _workflowCompositeKey(String workflowId, String requestId) =>
    '$workflowId/$requestId';

Map<String, String> _stringMap(Object? value) {
  if (value is! Map) {
    return {};
  }
  return {
    for (final entry in value.entries)
      entry.key.toString(): entry.value?.toString() ?? '',
  };
}

Map<String, Map<String, String>> _envMap(Object? value) {
  if (value is! Map) {
    return {};
  }
  final result = <String, Map<String, String>>{};
  for (final entry in value.entries) {
    result[entry.key.toString()] = _stringMap(entry.value);
  }
  return result;
}

class _WorkspaceSlice {
  _WorkspaceSlice({
    Map<String, Map<String, String>>? env,
    Map<String, String>? requests,
    Map<String, String>? history,
    Map<String, String>? workflows,
  })  : env = env ?? {},
        requests = requests ?? {},
        history = history ?? {},
        workflows = workflows ?? {};

  final Map<String, Map<String, String>> env;
  final Map<String, String> requests;
  final Map<String, String> history;
  final Map<String, String> workflows;

  bool get isEmpty =>
      env.isEmpty && requests.isEmpty && history.isEmpty && workflows.isEmpty;

  Map<String, Object?> toJson() => {
        'env': env,
        'requests': requests,
        'history': history,
        'workflows': workflows,
      };

  factory _WorkspaceSlice.fromJson(Object? raw) {
    if (raw is! Map) {
      return _WorkspaceSlice();
    }
    return _WorkspaceSlice(
      env: _envMap(raw['env']),
      requests: _stringMap(raw['requests']),
      history: _stringMap(raw['history']),
      workflows: _stringMap(raw['workflows']),
    );
  }

  _WorkspaceSlice copy() => _WorkspaceSlice(
        env: {
          for (final entry in env.entries)
            entry.key: Map<String, String>.from(entry.value),
        },
        requests: Map<String, String>.from(requests),
        history: Map<String, String>.from(history),
        workflows: Map<String, String>.from(workflows),
      );
}

class _SecretsStore {
  _SecretsStore({FlutterSecureStorage? storage})
      : _storage = storage ?? _createSecureStorage();

  final FlutterSecureStorage _storage;
  Map<String, _WorkspaceSlice>? _workspaces;
  String? _defaultAiApiKey;
  Future<void>? _loadLock;

  Future<void> _ensureLoaded() async {
    if (_workspaces != null) {
      return;
    }
    final inflight = _loadLock;
    if (inflight != null) {
      await inflight;
      return;
    }
    final future = _load();
    _loadLock = future;
    try {
      await future;
    } finally {
      _loadLock = null;
    }
  }

  Future<void> _load() async {
    final raw = await _storage.read(key: _secretsStorageKey);
    if (raw == null || raw.isEmpty) {
      _workspaces = {};
      _defaultAiApiKey = null;
      return;
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) {
        _workspaces = {};
        _defaultAiApiKey = null;
        return;
      }
      final workspaces = <String, _WorkspaceSlice>{};
      final rawWorkspaces = decoded['workspaces'];
      if (rawWorkspaces is Map) {
        for (final entry in rawWorkspaces.entries) {
          workspaces[entry.key.toString()] =
              _WorkspaceSlice.fromJson(entry.value);
        }
      }
      _workspaces = workspaces;
      final defaultKey = decoded[_defaultAiApiKeyField];
      _defaultAiApiKey =
          defaultKey is String && defaultKey.isNotEmpty ? defaultKey : null;
    } catch (_) {
      _workspaces = {};
      _defaultAiApiKey = null;
    }
  }

  Future<void> _persist() async {
    final workspaces = _workspaces ?? {};
    final payload = <String, Object?>{
      'workspaces': {
        for (final entry in workspaces.entries)
          if (!entry.value.isEmpty) entry.key: entry.value.toJson(),
      },
      if (_defaultAiApiKey != null && _defaultAiApiKey!.isNotEmpty)
        _defaultAiApiKeyField: _defaultAiApiKey,
    };
    final workspacesJson = payload['workspaces'];
    final emptyWorkspaces =
        workspacesJson is Map && workspacesJson.isEmpty;
    if (emptyWorkspaces &&
        (_defaultAiApiKey == null || _defaultAiApiKey!.isEmpty)) {
      await _storage.delete(key: _secretsStorageKey);
      return;
    }
    await _storage.write(key: _secretsStorageKey, value: jsonEncode(payload));
  }

  Future<_WorkspaceSlice> workspace(String workspacePath) async {
    await _ensureLoaded();
    final id = _workspaceId(workspacePath);
    return (_workspaces![id] ??= _WorkspaceSlice()).copy();
  }

  Future<void> updateWorkspace(
    String workspacePath,
    _WorkspaceSlice Function(_WorkspaceSlice current) update,
  ) async {
    await _ensureLoaded();
    final id = _workspaceId(workspacePath);
    final current = (_workspaces![id] ?? _WorkspaceSlice()).copy();
    final next = update(current);
    if (next.isEmpty) {
      _workspaces!.remove(id);
    } else {
      _workspaces![id] = next;
    }
    await _persist();
  }

  Future<String?> readDefaultAiApiKey() async {
    await _ensureLoaded();
    return _defaultAiApiKey;
  }

  Future<void> writeDefaultAiApiKey(String value) async {
    await _ensureLoaded();
    _defaultAiApiKey = value;
    await _persist();
  }

  Future<void> deleteDefaultAiApiKey() async {
    await _ensureLoaded();
    _defaultAiApiKey = null;
    await _persist();
  }
}

final _secretsStore = _SecretsStore();

class EnvironmentSecretsStorage {
  EnvironmentSecretsStorage();

  final _SecretsStore _store = _secretsStore;

  Future<String?> readSecret(
    String workspacePath,
    String environmentId,
    String variableKey,
  ) async {
    final slice = await _store.workspace(workspacePath);
    return slice.env[environmentId]?[variableKey];
  }

  Future<void> writeSecret(
    String workspacePath,
    String environmentId,
    String variableKey,
    String value,
  ) {
    return _store.updateWorkspace(workspacePath, (slice) {
      slice.env.putIfAbsent(environmentId, () => {})[variableKey] = value;
      return slice;
    });
  }

  Future<void> deleteSecret(
    String workspacePath,
    String environmentId,
    String variableKey,
  ) {
    return _store.updateWorkspace(workspacePath, (slice) {
      final envSecrets = slice.env[environmentId];
      if (envSecrets == null) {
        return slice;
      }
      envSecrets.remove(variableKey);
      if (envSecrets.isEmpty) {
        slice.env.remove(environmentId);
      }
      return slice;
    });
  }

  Future<void> deleteAllForEnvironment(
    String workspacePath,
    String environmentId,
    Iterable<String> variableKeys,
  ) {
    return _store.updateWorkspace(workspacePath, (slice) {
      final envSecrets = slice.env[environmentId];
      if (envSecrets == null) {
        return slice;
      }
      for (final key in variableKeys) {
        envSecrets.remove(key);
      }
      if (envSecrets.isEmpty) {
        slice.env.remove(environmentId);
      }
      return slice;
    });
  }

  Future<void> deleteAllForWorkspace(String workspacePath) {
    return _store.updateWorkspace(workspacePath, (slice) {
      slice.env.clear();
      return slice;
    });
  }
}

class AiRequestSecretsStorage {
  AiRequestSecretsStorage();

  final _SecretsStore _store = _secretsStore;

  Future<String?> readApiKey(
    String workspacePath,
    String collectionId,
    String requestId,
  ) async {
    final slice = await _store.workspace(workspacePath);
    return slice.requests[_requestCompositeKey(collectionId, requestId)];
  }

  Future<void> writeApiKey(
    String workspacePath,
    String collectionId,
    String requestId,
    String value,
  ) {
    return _store.updateWorkspace(workspacePath, (slice) {
      slice.requests[_requestCompositeKey(collectionId, requestId)] = value;
      return slice;
    });
  }

  Future<void> deleteApiKey(
    String workspacePath,
    String collectionId,
    String requestId,
  ) {
    return _store.updateWorkspace(workspacePath, (slice) {
      slice.requests.remove(_requestCompositeKey(collectionId, requestId));
      return slice;
    });
  }

  Future<void> rekeyApiKey(
    String workspacePath,
    String collectionId,
    String oldRequestId,
    String newRequestId,
  ) async {
    if (oldRequestId == newRequestId) {
      return;
    }
    final value = await readApiKey(workspacePath, collectionId, oldRequestId);
    if (value == null) {
      return;
    }
    await writeApiKey(workspacePath, collectionId, newRequestId, value);
    await deleteApiKey(workspacePath, collectionId, oldRequestId);
  }

  Future<void> deleteOrphansForCollection(
    String workspacePath,
    String collectionId,
    Set<String> activeRequestIds,
  ) {
    final prefix = '$collectionId/';
    return _store.updateWorkspace(workspacePath, (slice) {
      for (final key in slice.requests.keys.toList()) {
        if (!key.startsWith(prefix)) {
          continue;
        }
        final requestId = key.substring(prefix.length);
        if (!activeRequestIds.contains(requestId)) {
          slice.requests.remove(key);
        }
      }
      return slice;
    });
  }

  Future<String?> readHistoryApiKey(
    String workspacePath,
    String historyId,
  ) async {
    final slice = await _store.workspace(workspacePath);
    return slice.history[historyId];
  }

  Future<void> writeHistoryApiKey(
    String workspacePath,
    String historyId,
    String value,
  ) {
    return _store.updateWorkspace(workspacePath, (slice) {
      slice.history[historyId] = value;
      return slice;
    });
  }

  Future<void> deleteHistoryApiKey(
    String workspacePath,
    String historyId,
  ) {
    return _store.updateWorkspace(workspacePath, (slice) {
      slice.history.remove(historyId);
      return slice;
    });
  }

  Future<String?> readWorkflowApiKey(
    String workspacePath,
    String workflowId,
    String requestId,
  ) async {
    final slice = await _store.workspace(workspacePath);
    return slice.workflows[_workflowCompositeKey(workflowId, requestId)];
  }

  Future<void> writeWorkflowApiKey(
    String workspacePath,
    String workflowId,
    String requestId,
    String value,
  ) {
    return _store.updateWorkspace(workspacePath, (slice) {
      slice.workflows[_workflowCompositeKey(workflowId, requestId)] = value;
      return slice;
    });
  }

  Future<void> deleteWorkflowApiKey(
    String workspacePath,
    String workflowId,
    String requestId,
  ) {
    return _store.updateWorkspace(workspacePath, (slice) {
      slice.workflows.remove(_workflowCompositeKey(workflowId, requestId));
      return slice;
    });
  }

  Future<void> rekeyWorkflowApiKeys(
    String workspacePath,
    String oldWorkflowId,
    String newWorkflowId,
  ) async {
    if (oldWorkflowId == newWorkflowId) {
      return;
    }
    final prefix = '$oldWorkflowId/';
    final newPrefix = '$newWorkflowId/';
    return _store.updateWorkspace(workspacePath, (slice) {
      for (final key in slice.workflows.keys.toList()) {
        if (!key.startsWith(prefix)) {
          continue;
        }
        final requestId = key.substring(prefix.length);
        final value = slice.workflows.remove(key);
        if (value != null) {
          slice.workflows['$newPrefix$requestId'] = value;
        }
      }
      return slice;
    });
  }

  Future<void> deleteOrphansForWorkflow(
    String workspacePath,
    String workflowId,
    Set<String> activeRequestIds,
  ) {
    final prefix = '$workflowId/';
    return _store.updateWorkspace(workspacePath, (slice) {
      for (final key in slice.workflows.keys.toList()) {
        if (!key.startsWith(prefix)) {
          continue;
        }
        final requestId = key.substring(prefix.length);
        if (!activeRequestIds.contains(requestId)) {
          slice.workflows.remove(key);
        }
      }
      return slice;
    });
  }

  Future<void> deleteAllForWorkflow(
    String workspacePath,
    String workflowId,
  ) {
    final prefix = '$workflowId/';
    return _store.updateWorkspace(workspacePath, (slice) {
      for (final key in slice.workflows.keys.toList()) {
        if (key.startsWith(prefix)) {
          slice.workflows.remove(key);
        }
      }
      return slice;
    });
  }

  Future<String?> readDefaultApiKey() => _store.readDefaultAiApiKey();

  Future<void> writeDefaultApiKey(String value) =>
      _store.writeDefaultAiApiKey(value);

  Future<void> deleteDefaultApiKey() => _store.deleteDefaultAiApiKey();

  Future<void> deleteAllForWorkspace(String workspacePath) {
    return _store.updateWorkspace(workspacePath, (slice) {
      slice.requests.clear();
      slice.history.clear();
      slice.workflows.clear();
      return slice;
    });
  }

  Future<void> deleteAllHistoryForWorkspace(String workspacePath) {
    return _store.updateWorkspace(workspacePath, (slice) {
      slice.history.clear();
      return slice;
    });
  }

  static String? apiKeyFromJson(Map<String, dynamic> json) {
    final ai = json['aiRequestModel'];
    if (ai is! Map) {
      return null;
    }
    return ai['apiKey'] as String?;
  }

  static Map<String, dynamic> stripApiKeyFromJson(Map<String, dynamic> json) {
    final ai = json['aiRequestModel'];
    if (ai is! Map) {
      return json;
    }
    final result = Map<String, dynamic>.from(json);
    final aiCopy = Map<String, Object?>.from(ai);
    aiCopy['apiKey'] = null;
    result['aiRequestModel'] = aiCopy;
    return result;
  }

  static Map<String, Object?>? stripApiKeyFromDefaultAiModel(
    Map<String, Object?>? model,
  ) {
    if (model == null) {
      return null;
    }
    final copy = Map<String, Object?>.from(model);
    copy['apiKey'] = null;
    return copy;
  }
}

final environmentSecretsStorage = EnvironmentSecretsStorage();
final aiRequestSecretsStorage = AiRequestSecretsStorage();
