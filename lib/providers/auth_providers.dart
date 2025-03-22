import 'dart:convert';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_core/consts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for selected auth type
final authTypeProvider = StateProvider<AuthType>((ref) => AuthType.none);

// Provider for auth data (e.g., username/password for Basic Auth)
final authDataProvider = StateProvider<Map<String, String>?>((ref) => null);

// Provider to compute the Authorization header
final authHeaderProvider = Provider<String?>(
  (ref) {
    final authType = ref.watch(authTypeProvider);
    final authData = ref.watch(authDataProvider);
    if (authType == AuthType.none || authData == null || authData.isEmpty) {
      return null;
    }

    String? authHeader;
    
    switch (authType) {
      case AuthType.oAuth2:
        return null;
      case AuthType.oAuth1:
        return null;
      case AuthType.digest:
        return null;
      case AuthType.jwtBearer:
        return null;
      case AuthType.bearer:
        final token = authData['token'] ?? '';
        if (token.isEmpty) return null;
        authHeader = 'Bearer $token';
        break;
      case AuthType.apiKey:
        final key = authData['key'] ?? '';
        if (key.isEmpty) return null;
        authHeader = key;
        break;
      case AuthType.basic:
        final username = authData['username'] ?? '';
        final password = authData['password'] ?? '';
        if (username.isEmpty && password.isEmpty) return null;
        authHeader =
            'Basic ${base64Encode(utf8.encode('$username:$password'))}';
        break;
      case AuthType.none:
        return null;
    }
    return authHeader;
  },
);
