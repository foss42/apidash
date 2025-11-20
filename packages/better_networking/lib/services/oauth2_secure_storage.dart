import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage service for OAuth2 credentials
/// Uses platform-specific secure storage (Keychain on iOS, EncryptedSharedPreferences on Android)
class OAuth2SecureStorage {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  /// Generate a unique storage key from client ID and token URL
  static String _generateKey(String clientId, String tokenUrl) {
    final combined = '$clientId:$tokenUrl';
    final bytes = utf8.encode(combined);
    final hash = sha256.convert(bytes);
    return 'oauth2_cred_${hash.toString().substring(0, 16)}';
  }

  /// Store OAuth2 credentials securely
  static Future<void> storeCredentials({
    required String clientId,
    required String tokenUrl,
    required String credentialsJson,
  }) async {
    try {
      final key = _generateKey(clientId, tokenUrl);
      await _secureStorage.write(key: key, value: credentialsJson);
    } catch (e) {
      // Log error but don't fail - fallback to no storage
      // In production, consider proper logging
    }
  }

  /// Retrieve OAuth2 credentials
  static Future<String?> retrieveCredentials({
    required String clientId,
    required String tokenUrl,
  }) async {
    try {
      final key = _generateKey(clientId, tokenUrl);
      return await _secureStorage.read(key: key);
    } catch (e) {
      // Log error but return null - will trigger fresh auth
      return null;
    }
  }

  /// Delete OAuth2 credentials
  static Future<void> deleteCredentials({
    required String clientId,
    required String tokenUrl,
  }) async {
    try {
      final key = _generateKey(clientId, tokenUrl);
      await _secureStorage.delete(key: key);
    } catch (e) {
      // Log error but don't fail
    }
  }

  /// Clear all OAuth2 credentials
  static Future<void> clearAllCredentials() async {
    try {
      final allKeys = await _secureStorage.readAll();
      for (final key in allKeys.keys) {
        if (key.startsWith('oauth2_cred_')) {
          await _secureStorage.delete(key: key);
        }
      }
    } catch (e) {
      // Log error but don't fail
    }
  }
}
