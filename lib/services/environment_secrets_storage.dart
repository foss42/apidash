import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
    final prefix = '$_storageKeyPrefix/${_workspaceId(workspacePath)}/';
    final all = await _storage.readAll();
    for (final key in all.keys) {
      if (key.startsWith(prefix)) {
        await _storage.delete(key: key);
      }
    }
  }
}

final environmentSecretsStorage = EnvironmentSecretsStorage();
