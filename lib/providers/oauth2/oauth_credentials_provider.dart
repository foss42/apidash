import 'package:apidash/services/oauth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/oauth_config_model.dart';
import '../../models/oauth_credentials_model.dart';

class OAuthCredentialsNotifier extends StateNotifier<AsyncValue<OAuthCredentials>> {
  final _service = OAuthService();
  
  OAuthCredentialsNotifier() : super(const AsyncValue.data(OAuthCredentials()));

  Future<OAuthCredentials> acquireCredentials(OAuthConfig config) async {
    try {
      state = const AsyncValue.loading();
      final credentials = await _service.acquireAuthorizationCodeToken(config);
      await _saveCredentials(config.id, credentials);
      state = AsyncValue.data(credentials);
      return credentials;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> _saveCredentials(String configId, OAuthCredentials credentials) async {
    final prefs = await SharedPreferences.getInstance();
    final credentialsJson = jsonEncode(credentials.toJson());
    await prefs.setString('oauth_credentials_$configId', credentialsJson);
  }

  Future<OAuthCredentials?> getCredentials(String configId) async {
    final prefs = await SharedPreferences.getInstance();
    final credentialsJson = prefs.getString('oauth_credentials_$configId');
    if (credentialsJson == null) {
      return null;
    }
    
    final data = jsonDecode(credentialsJson);
    final credentials = OAuthCredentials.fromJson(data);
    state = AsyncValue.data(credentials);
    return credentials;
  }

  Future<void> clearCredentials(String configId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('oauth_credentials_$configId');
    state = const AsyncValue.data(OAuthCredentials());
  }
}

final oauthCredentialsProvider =
    StateNotifierProvider<OAuthCredentialsNotifier, AsyncValue<OAuthCredentials>>((ref) {
  return OAuthCredentialsNotifier();
});

final oauthServiceProvider = Provider<OAuthService>((ref) {
  return OAuthService();
});