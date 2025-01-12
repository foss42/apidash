import 'package:apidash/services/oauth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import '../../models/oauth_config_model.dart';
import '../../models/oauth_credentials_model.dart';

class OAuthCredentialsNotifier extends StateNotifier<AsyncValue<OAuthCredentials>> {
  final _storage = const FlutterSecureStorage();
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
    final credentialsJson = jsonEncode(credentials.toJson());
    await _storage.write(key: 'oauth_credentials_$configId', value: credentialsJson);
  }
  Future<OAuthCredentials?> getCredentials(String configId) async {
    final credentialsJson = await _storage.read(key: 'oauth_credentials_$configId');
    if (credentialsJson == null) {
      return null;
    }
    
    final data = jsonDecode(credentialsJson);
    final credentials = OAuthCredentials.fromJson(data);
    state = AsyncValue.data(credentials);
    return credentials;
  }
  Future<void> clearCredentials(String configId) async {
    await _storage.delete(key: 'oauth_credentials_$configId');
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