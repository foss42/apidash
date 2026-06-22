import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'storage/workspace_storage.dart';

const _storageKeyPrefix = 'apidash_env_secret';

class EnvironmentSecretsStorage {
  EnvironmentSecretsStorage({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
              mOptions: MacOsOptions(useDataProtectionKeyChain: false),
            );

  final FlutterSecureStorage _storage;

  String _workspaceId(String workspacePath) =>
      base64Url.encode(utf8.encode(workspacePath));

  String _key(String workspacePath, String environmentId, String variableKey) =>
      '$_storageKeyPrefix/${_workspaceId(workspacePath)}/$environmentId/$variableKey';

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
      final prefix = '$_storageKeyPrefix/${_workspaceId(workspacePath)}/';
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

final environmentSecretsStorage = EnvironmentSecretsStorage();
