import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'storage/workspace_storage.dart';

FlutterSecureStorage _createSecureStorage() => const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      mOptions: MacOsOptions(useDataProtectionKeyChain: false),
    );

String _workspaceId(String workspacePath) =>
    base64Url.encode(utf8.encode(workspacePath));

const _envStorageKeyPrefix = 'apidash_env_secret';
const _aiRequestStorageKeyPrefix = 'apidash_ai_secret';
const _aiHistoryStorageKeyPrefix = 'apidash_ai_history_secret';
const _defaultAiApiKeyStorageKey = 'apidash_default_ai_api_key';

class EnvironmentSecretsStorage {
  EnvironmentSecretsStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? _createSecureStorage();

  final FlutterSecureStorage _storage;

  String _key(String workspacePath, String environmentId, String variableKey) =>
      '$_envStorageKeyPrefix/${_workspaceId(workspacePath)}/$environmentId/$variableKey';

  Future<String?> readSecret(
    String workspacePath,
    String environmentId,
    String variableKey,
  ) {
    return _storage.read(
      key: _key(workspacePath, environmentId, variableKey),
    );
  }

  Future<void> writeSecret(
    String workspacePath,
    String environmentId,
    String variableKey,
    String value,
  ) {
    return _storage.write(
      key: _key(workspacePath, environmentId, variableKey),
      value: value,
    );
  }

  Future<void> deleteSecret(
    String workspacePath,
    String environmentId,
    String variableKey,
  ) {
    return _storage.delete(
      key: _key(workspacePath, environmentId, variableKey),
    );
  }

  Future<void> deleteAllForEnvironment(
    String workspacePath,
    String environmentId,
    Iterable<String> variableKeys,
  ) async {
    for (final key in variableKeys) {
      await deleteSecret(workspacePath, environmentId, key);
    }
  }

  Future<void> deleteAllForWorkspace(String workspacePath) async {
    try {
      final prefix = '$_envStorageKeyPrefix/${_workspaceId(workspacePath)}/';
      final all = await _storage.readAll();
      for (final key in all.keys) {
        if (key.startsWith(prefix)) {
          await _storage.delete(key: key);
        }
      }
    } catch (_) {
      for (final entry in _secretKeysByEnvironmentFromWorkspace().entries) {
        await deleteAllForEnvironment(
          workspacePath,
          entry.key,
          entry.value,
        );
      }
    }
  }

  Map<String, List<String>> _secretKeysByEnvironmentFromWorkspace() {
    final byEnvironment = <String, List<String>>{};
    for (final environmentId
        in workspaceStorage.getEnvironmentIds() ?? const []) {
      final json = workspaceStorage.getEnvironment(environmentId);
      if (json == null) {
        continue;
      }
      final values = json['values'];
      if (values is! List) {
        continue;
      }
      for (final value in values) {
        if (value is! Map) {
          continue;
        }
        if (value['type'] != 'secret') {
          continue;
        }
        final variableKey = value['key'] as String?;
        if (variableKey == null || variableKey.isEmpty) {
          continue;
        }
        byEnvironment.putIfAbsent(environmentId, () => []).add(variableKey);
      }
    }
    return byEnvironment;
  }
}

class AiRequestSecretsStorage {
  AiRequestSecretsStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? _createSecureStorage();

  final FlutterSecureStorage _storage;

  String _requestKey(
    String workspacePath,
    String collectionId,
    String requestId,
  ) =>
      '$_aiRequestStorageKeyPrefix/${_workspaceId(workspacePath)}/$collectionId/$requestId';

  String _historyKey(String workspacePath, String historyId) =>
      '$_aiHistoryStorageKeyPrefix/${_workspaceId(workspacePath)}/$historyId';

  Future<String?> readApiKey(
    String workspacePath,
    String collectionId,
    String requestId,
  ) {
    return _storage.read(
      key: _requestKey(workspacePath, collectionId, requestId),
    );
  }

  Future<void> writeApiKey(
    String workspacePath,
    String collectionId,
    String requestId,
    String value,
  ) {
    return _storage.write(
      key: _requestKey(workspacePath, collectionId, requestId),
      value: value,
    );
  }

  Future<void> deleteApiKey(
    String workspacePath,
    String collectionId,
    String requestId,
  ) {
    return _storage.delete(
      key: _requestKey(workspacePath, collectionId, requestId),
    );
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
  ) async {
    try {
      final prefix =
          '$_aiRequestStorageKeyPrefix/${_workspaceId(workspacePath)}/$collectionId/';
      final all = await _storage.readAll();
      for (final key in all.keys) {
        if (!key.startsWith(prefix)) {
          continue;
        }
        final requestId = key.substring(prefix.length);
        if (!activeRequestIds.contains(requestId)) {
          await _storage.delete(key: key);
        }
      }
    } catch (_) {
      // Best-effort cleanup.
    }
  }

  Future<String?> readHistoryApiKey(String workspacePath, String historyId) {
    return _storage.read(key: _historyKey(workspacePath, historyId));
  }

  Future<void> writeHistoryApiKey(
    String workspacePath,
    String historyId,
    String value,
  ) {
    return _storage.write(key: _historyKey(workspacePath, historyId), value: value);
  }

  Future<void> deleteHistoryApiKey(String workspacePath, String historyId) {
    return _storage.delete(key: _historyKey(workspacePath, historyId));
  }

  Future<String?> readDefaultApiKey() {
    return _storage.read(key: _defaultAiApiKeyStorageKey);
  }

  Future<void> writeDefaultApiKey(String value) {
    return _storage.write(key: _defaultAiApiKeyStorageKey, value: value);
  }

  Future<void> deleteDefaultApiKey() {
    return _storage.delete(key: _defaultAiApiKeyStorageKey);
  }

  Future<void> deleteAllForWorkspace(String workspacePath) async {
    final workspaceToken = _workspaceId(workspacePath);
    final requestPrefix = '$_aiRequestStorageKeyPrefix/$workspaceToken/';
    final historyPrefix = '$_aiHistoryStorageKeyPrefix/$workspaceToken/';
    try {
      final all = await _storage.readAll();
      for (final key in all.keys) {
        if (key.startsWith(requestPrefix) || key.startsWith(historyPrefix)) {
          await _storage.delete(key: key);
        }
      }
    } catch (_) {
      // Best-effort cleanup.
    }
  }

  Future<void> deleteAllHistoryForWorkspace(String workspacePath) async {
    final prefix = '$_aiHistoryStorageKeyPrefix/${_workspaceId(workspacePath)}/';
    try {
      final all = await _storage.readAll();
      for (final key in all.keys) {
        if (key.startsWith(prefix)) {
          await _storage.delete(key: key);
        }
      }
    } catch (_) {
      // Best-effort cleanup.
    }
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
