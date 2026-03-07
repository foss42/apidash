import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Modern unified secure storage for API Dash (2025 best practices)
/// Handles OAuth2 credentials, environment secrets, and rate limiting
class SecureStorage {
  // Platform-specific secure storage
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // OAuth2 Rate limiting state
  static final _rateLimits = <String, _RateLimit>{};
  static const _maxAttempts = 5;
  static const _resetMinutes = 30;

  /// Generate secure key using SHA-256
  static String _hashKey(String input) {
    return sha256.convert(utf8.encode(input)).toString().substring(0, 16);
  }

  // ==================== OAuth2 Methods ====================
  
  /// Check rate limit for OAuth2
  static String? checkRateLimit(String clientId, String tokenUrl) {
    final key = _hashKey('$clientId:$tokenUrl');
    final limit = _rateLimits[key];
    
    if (limit == null) return null;
    
    final now = DateTime.now();
    if (now.difference(limit.firstAttempt).inMinutes >= _resetMinutes) {
      _rateLimits.remove(key);
      return null;
    }
    
    if (limit.cooldownUntil != null && now.isBefore(limit.cooldownUntil!)) {
      final seconds = limit.cooldownUntil!.difference(now).inSeconds;
      return 'Rate limit exceeded. Try again in $seconds seconds.';
    }
    
    return null;
  }

  /// Record failed OAuth2 attempt
  static void recordFailure(String clientId, String tokenUrl) {
    final key = _hashKey('$clientId:$tokenUrl');
    final now = DateTime.now();
    final limit = _rateLimits[key];
    
    if (limit == null) {
      _rateLimits[key] = _RateLimit(now, now, 1, null);
    } else {
      final attempts = limit.attempts + 1;
      final delay = attempts >= _maxAttempts 
        ? (2 << (attempts - _maxAttempts)).clamp(2, 300)
        : 0;
      
      _rateLimits[key] = _RateLimit(
        limit.firstAttempt,
        now,
        attempts,
        delay > 0 ? now.add(Duration(seconds: delay)) : null,
      );
    }
  }

  /// Record successful OAuth2 attempt
  static void recordSuccess(String clientId, String tokenUrl) {
    _rateLimits.remove(_hashKey('$clientId:$tokenUrl'));
  }

  /// Store OAuth2 credentials
  static Future<void> storeOAuth2({
    required String clientId,
    required String tokenUrl,
    required String credentialsJson,
  }) async {
    try {
      await _storage.write(
        key: 'oauth2_${_hashKey('$clientId:$tokenUrl')}',
        value: credentialsJson,
      );
    } catch (_) {}
  }

  /// Retrieve OAuth2 credentials
  static Future<String?> retrieveOAuth2({
    required String clientId,
    required String tokenUrl,
  }) async {
    try {
      return await _storage.read(
        key: 'oauth2_${_hashKey('$clientId:$tokenUrl')}',
      );
    } catch (_) {
      return null;
    }
  }

  // ==================== Environment Secret Methods ====================
  
  /// Store environment secret
  static Future<void> storeSecret({
    required String environmentId,
    required String key,
    required String value,
  }) async {
    try {
      await _storage.write(key: 'env_${environmentId}_$key', value: value);
    } catch (_) {}
  }

  /// Retrieve environment secret
  static Future<String?> retrieveSecret({
    required String environmentId,
    required String key,
  }) async {
    try {
      return await _storage.read(key: 'env_${environmentId}_$key');
    } catch (_) {
      return null;
    }
  }

  /// Delete all secrets for an environment
  static Future<void> deleteEnvironmentSecrets(String environmentId) async {
    try {
      final all = await _storage.readAll();
      final prefix = 'env_${environmentId}_';
      for (final key in all.keys.where((k) => k.startsWith(prefix))) {
        await _storage.delete(key: key);
      }
    } catch (_) {}
  }
}

// Internal rate limit state
class _RateLimit {
  final DateTime firstAttempt;
  final DateTime lastAttempt;
  final int attempts;
  final DateTime? cooldownUntil;
  
  _RateLimit(this.firstAttempt, this.lastAttempt, this.attempts, this.cooldownUntil);
}
