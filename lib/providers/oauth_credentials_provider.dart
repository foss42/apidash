import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../models/oauth_config_model.dart';
import '../models/oauth_credentials_model.dart';
import '../services/oauth_service.dart';

class OAuthCredentialsNotifier extends StateNotifier<AsyncValue<OAuthCredentials>> {
  final _storage = const FlutterSecureStorage();
  final _service = OAuthService();
  
  OAuthCredentialsNotifier() : super(const AsyncValue.data(OAuthCredentials()));

  Future<OAuthCredentials> acquireCredentials(OAuthConfig config) async {
    try {
      state = const AsyncValue.loading();
      print('[OAuth Provider] Acquiring credentials...');
      final credentials = await _service.acquireAuthorizationCodeToken(config);
      print('[OAuth Provider] Got credentials: ${credentials.accessToken}');
      await _saveCredentials(config.id, credentials);
      print('[OAuth Provider] Updating state with new credentials');
      state = AsyncValue.data(credentials);
      return credentials;
    } catch (e, st) {
      print('[OAuth Provider] Error acquiring credentials: $e');
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> _saveCredentials(String configId, OAuthCredentials credentials) async {
    print('[OAuth Provider] Saving credentials for config: $configId');
    final credentialsJson = jsonEncode(credentials.toJson());
    await _storage.write(key: 'oauth_credentials_$configId', value: credentialsJson);
    // Force a state update
    state = AsyncValue.data(credentials);
    print('[OAuth Provider] Credentials saved and state updated');
  }

  Future<OAuthCredentials?> getCredentials(String configId) async {
    print('[OAuth Provider] Getting credentials for config: $configId');
    final credentialsJson = await _storage.read(key: 'oauth_credentials_$configId');
    if (credentialsJson == null) {
      print('[OAuth Provider] No credentials found');
      return null;
    }
    
    final data = jsonDecode(credentialsJson);
    final credentials = OAuthCredentials.fromJson(data);
    // Update state with retrieved credentials
    state = AsyncValue.data(credentials);
    print('[OAuth Provider] Retrieved and updated credentials');
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
