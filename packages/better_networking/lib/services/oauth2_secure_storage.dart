import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Modern OAuth2 secure storage with built-in rate limiting (2025 best practices)
/// Note: This is a package-local wrapper. The main app uses lib/services/secure_storage.dart
class OAuth2SecureStorage {
  // Secure storage with platform-specific encryption
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // Rate limiting state
  static final _rateLimits = <String, _RateLimit>{};
  static const _maxAttempts = 5;
  static const _resetMinutes = 30;

  /// Generate secure storage key using SHA-256
  static String _key(String clientId, String tokenUrl) {
    final hash = sha256.convert(utf8.encode('$clientId:$tokenUrl'));
    return 'oauth2_${hash.toString().substring(0, 16)}';
  }

  /// Check if authentication can proceed (rate limiting)
  static String? checkRateLimit(String clientId, String tokenUrl) {
    final key = _key(clientId, tokenUrl);
    final limit = _rateLimits[key];
    
    if (limit == null) return null;
    
    final now = DateTime.now();
    
    // Auto-reset after 30 minutes
    if (now.difference(limit.firstAttempt).inMinutes >= _resetMinutes) {
      _rateLimits.remove(key);
      return null;
    }
    
    // Check cooldown
    if (limit.cooldownUntil != null && now.isBefore(limit.cooldownUntil!)) {
      final seconds = limit.cooldownUntil!.difference(now).inSeconds;
      return 'Rate limit exceeded. Try again in $seconds seconds.';
    }
    
    return null;
  }

  /// Record failed authentication attempt
  static void recordFailure(String clientId, String tokenUrl) {
    final key = _key(clientId, tokenUrl);
    final now = DateTime.now();
    final limit = _rateLimits[key];
    
    if (limit == null) {
      _rateLimits[key] = _RateLimit(now, now, 1, null);
    } else {
      final attempts = limit.attempts + 1;
      // Exponential backoff: 2, 4, 8, 16... max 300s (5 minutes)
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

  /// Record successful authentication (clears rate limit)
  static void recordSuccess(String clientId, String tokenUrl) {
    _rateLimits.remove(_key(clientId, tokenUrl));
  }

  /// Store credentials securely
  static Future<void> store({
    required String clientId,
    required String tokenUrl,
    required String credentialsJson,
  }) async {
    try {
      await _storage.write(key: _key(clientId, tokenUrl), value: credentialsJson);
    } catch (_) {
      // Graceful degradation
    }
  }

  /// Retrieve credentials
  static Future<String?> retrieve({
    required String clientId,
    required String tokenUrl,
  }) async {
    try {
      return await _storage.read(key: _key(clientId, tokenUrl));
    } catch (_) {
      return null;
    }
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
