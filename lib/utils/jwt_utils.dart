import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class JwtUtils {
  static const String _tokenKey = 'jwt_token';

  // Determine if the platform is mobile (Android/iOS)
  static bool _isMobile() {
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  // Save JWT token securely
  static Future<void> saveToken(String token) async {
    if (kIsWeb || !_isMobile()) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
    } else {
      const storage = FlutterSecureStorage();
      await storage.write(key: _tokenKey, value: token);
    }
  }

  // Retrieve stored token
  static Future<String?> getToken() async {
    if (kIsWeb || !_isMobile()) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } else {
      const storage = FlutterSecureStorage();
      return await storage.read(key: _tokenKey);
    }
  }

  // Delete token when logging out
  static Future<void> deleteToken() async {
    if (kIsWeb || !_isMobile()) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
    } else {
      const storage = FlutterSecureStorage();
      await storage.delete(key: _tokenKey);
    }
  }

  // Check if a stored token is valid (not expired)
  static Future<bool> isAuthenticated() async {
    final token = await getToken();
    if (token == null) return false;
    return !JwtDecoder.isExpired(token);
  }

  // Extract payload data from the token
  static Future<Map<String, dynamic>> getPayload() async {
    final token = await getToken();
    if (token == null) return {};
    return JwtDecoder.decode(token);
  }
}
