import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:crypto/crypto.dart';

/// Service for securely storing and retrieving OAuth2 credentials
/// Uses flutter_secure_storage for encryption keys and encrypted values
class SecureCredentialStorage {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  /// Generates a storage key from client credentials for OAuth2
  static String _generateStorageKey(String clientId, String tokenUrl) {
    final combined = '$clientId:$tokenUrl';
    final bytes = utf8.encode(combined);
    final hash = sha256.convert(bytes);
    return 'oauth2_${hash.toString().substring(0, 16)}';
  }

  /// Store OAuth2 credentials securely
  static Future<void> storeOAuth2Credentials({
    required String clientId,
    required String tokenUrl,
    required String credentialsJson,
  }) async {
    final key = _generateStorageKey(clientId, tokenUrl);
    await _secureStorage.write(key: key, value: credentialsJson);
  }

  /// Retrieve OAuth2 credentials securely
  static Future<String?> retrieveOAuth2Credentials({
    required String clientId,
    required String tokenUrl,
  }) async {
    final key = _generateStorageKey(clientId, tokenUrl);
    return await _secureStorage.read(key: key);
  }

  /// Delete OAuth2 credentials
  static Future<void> deleteOAuth2Credentials({
    required String clientId,
    required String tokenUrl,
  }) async {
    final key = _generateStorageKey(clientId, tokenUrl);
    await _secureStorage.delete(key: key);
  }

  /// Clear all OAuth2 credentials
  static Future<void> clearAllOAuth2Credentials() async {
    final allKeys = await _secureStorage.readAll();
    for (final key in allKeys.keys) {
      if (key.startsWith('oauth2_')) {
        await _secureStorage.delete(key: key);
      }
    }
  }

  /// Store environment variable securely (for secrets)
  static Future<void> storeEnvironmentSecret({
    required String environmentId,
    required String variableKey,
    required String value,
  }) async {
    final key = 'env_${environmentId}_$variableKey';
    await _secureStorage.write(key: key, value: value);
  }

  /// Retrieve environment variable secret
  static Future<String?> retrieveEnvironmentSecret({
    required String environmentId,
    required String variableKey,
  }) async {
    final key = 'env_${environmentId}_$variableKey';
    return await _secureStorage.read(key: key);
  }

  /// Delete environment variable secret
  static Future<void> deleteEnvironmentSecret({
    required String environmentId,
    required String variableKey,
  }) async {
    final key = 'env_${environmentId}_$variableKey';
    await _secureStorage.delete(key: key);
  }

  /// Clear all environment secrets for a specific environment
  static Future<void> clearEnvironmentSecrets({
    required String environmentId,
  }) async {
    final allKeys = await _secureStorage.readAll();
    final prefix = 'env_${environmentId}_';
    for (final key in allKeys.keys) {
      if (key.startsWith(prefix)) {
        await _secureStorage.delete(key: key);
      }
    }
  }

  /// Check if secure storage is available
  static Future<bool> isSecureStorageAvailable() async {
    try {
      await _secureStorage.read(key: '__test__');
      return true;
    } catch (e) {
      return false;
    }
  }
}
