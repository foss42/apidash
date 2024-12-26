import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show HttpServer, ContentType;

import '../models/oauth_config_model.dart';
import '../models/oauth_credentials_model.dart';

class OAuthService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static const _credentialsStorageKey = 'oauth_credentials_';
  Completer<String>? _completer;
  HttpServer? _server;

  Future<String> _startLocalServer() async {
    print('[OAuth Service] Starting local server...');
    // Use a fixed port that matches the registered callback URL
    _server = await HttpServer.bind('127.0.0.1', 3000);
    print('[OAuth Service] Local server started on port 3000');

    _server!.listen((request) async {
      print('[OAuth Service] Received request: ${request.uri}');
      final code = request.uri.queryParameters['code'];
      if (code != null && _completer != null && !_completer!.isCompleted) {
        print('[OAuth Service] Found authorization code in request');
        request.response
          ..statusCode = 200
          ..headers.contentType = ContentType.html
          ..write('<html><body><h1>Authorization Successful!</h1><p>You can close this window now.</p></body></html>');
        await request.response.close();
        _completer!.complete(code);
        await _server!.close();
        _server = null;
      }
    });

    return 'http://localhost:3000/callback';
  }

  /// Parse OAuth token response and convert to expected format
  Map<String, dynamic> _parseTokenResponse(http.Response response) {
    print('[OAuth Service] Parsing token response...');
    
    Map<String, dynamic> responseJson = {};
    
    if (response.headers['content-type']?.contains('json') == true) {
      // Handle JSON response (GitHub's case)
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      responseJson = {
        'accessToken': jsonResponse['access_token'],
        'tokenType': jsonResponse['token_type'],
        'scopes': jsonResponse['scope']?.split(',') ?? [],
        if (jsonResponse['refresh_token'] != null)
          'refreshToken': jsonResponse['refresh_token'],
        if (jsonResponse['expires_in'] != null)
          'expiresIn': jsonResponse['expires_in'].toString(),
      };
    } else {
      // Handle form-urlencoded response
      final params = Uri.splitQueryString(response.body);
      responseJson = {
        'accessToken': params['access_token'],
        'tokenType': params['token_type'],
        'scopes': params['scope']?.split(',') ?? [],
        if (params['refresh_token'] != null)
          'refreshToken': params['refresh_token'],
        if (params['expires_in'] != null)
          'expiresIn': params['expires_in'],
      };
    }
    
    print('[OAuth Service] Transformed response: $responseJson');
    return responseJson;
  }

  /// Acquire token using Client Credentials flow
  Future<OAuthCredentials> acquireClientCredentialsToken(OAuthConfig config) async {
    print('\n[OAuth Service] Starting Client Credentials flow...');
    print('[OAuth Service] Config ID: ${config.id}');
    print('[OAuth Service] Token Endpoint: ${config.tokenEndpoint}');
    print('[OAuth Service] Scopes: ${config.scope}');

    // if (config.flow != OAuthFlow.clientCredentials) {
    //   print('[OAuth Service] Error: Invalid flow type ${config.flow}');
    //   throw ArgumentError('Invalid flow for client credentials');
    // }

    try {
      print('[OAuth Service] Creating HTTP client for token request');
      final client = http.Client();

      final requestBody = {
        'grant_type': 'client_credentials',
        'client_id': config.clientId,
        'client_secret': config.clientSecret ?? '',
        if (config.scope.isNotEmpty) 'scope': config.scope,
      };
      print('[OAuth Service] Preparing token request with body: $requestBody');

      // Perform token request manually
      print('[OAuth Service] Sending token request...');
      final response = await client.post(
        Uri.parse(config.tokenEndpoint),
        body: requestBody,
      );

      print('[OAuth Service] Token response status: ${response.statusCode}');
      print('[OAuth Service] Token response body: ${response.body}');

      // Check response status
      if (response.statusCode != 200) {
        print('[OAuth Service] Token request failed');
        throw Exception('Failed to acquire token: ${response.body}');
      }

      // Parse token response
      final responseJson = _parseTokenResponse(response);
      final tokenResponse = oauth2.Credentials.fromJson(jsonEncode(responseJson));
      print('[OAuth Service] Token response parsed successfully');

      final oauthCredentials = OAuthCredentials.fromOAuth2Credentials(tokenResponse);
      print('[OAuth Service] Saving credentials for config ID: ${config.id}');
      await _saveCredentials(config.id!, oauthCredentials);
      print('[OAuth Service] Client Credentials flow completed successfully');
      
      return oauthCredentials;
    } catch (e, stack) {
      print('[OAuth Service] Error in Client Credentials flow:');
      print('[OAuth Service] Error: $e');
      print('[OAuth Service] Stack trace:\n$stack');
      throw Exception('Failed to acquire client credentials token: $e');
    }
  }

  /// Acquire token using Authorization Code flow
  Future<OAuthCredentials> acquireAuthorizationCodeToken(OAuthConfig config) async {
    print('[OAuth Service] Starting Authorization Code flow...');
    print('[OAuth Service] Auth URL: ${config.authUrl}');
    print('[OAuth Service] Token Endpoint: ${config.tokenEndpoint}');

    _completer = Completer<String>();
    final callbackUrl = await _startLocalServer();
    print('[OAuth Service] Callback URL: $callbackUrl');
    
    final authUrl = Uri.parse(config.authUrl).replace(queryParameters: {
      'client_id': config.clientId,
      'response_type': 'code',
      'redirect_uri': callbackUrl,
      if (config.scope.isNotEmpty) 'scope': config.scope,
      if (config.state.isNotEmpty) 'state': config.state,
    });

    print('[OAuth Service] Full authorization URL: $authUrl');

    if (await canLaunchUrl(authUrl)) {
      await launchUrl(authUrl, mode: LaunchMode.externalApplication);
      print('[OAuth Service] Launched authorization URL');
    } else {
      print('[OAuth Service] Failed to launch authorization URL');
      throw Exception('Could not launch authorization URL');
    }

    try {
      print('[OAuth Service] Waiting for callback with authorization code...');
      final code = await _completer!.future.timeout(
        const Duration(minutes: 5),
        onTimeout: () {
          _server?.close();
          _server = null;
          throw Exception('Authorization timeout');
        },
      );
      
      print('[OAuth Service] Received authorization code: ${code.substring(0, 4)}...'); // Only show first 4 chars for security

      print('[OAuth Service] Requesting access token...');
      final response = await http.post(
        Uri.parse(config.tokenEndpoint),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {
          'grant_type': 'authorization_code',
          'code': code,
          'client_id': config.clientId,
          'client_secret': config.clientSecret,
          'redirect_uri': callbackUrl,
        },
      );

      print('[OAuth Service] Token response status: ${response.statusCode}');
      print('[OAuth Service] Token response headers: ${response.headers}');
      print('[OAuth Service] Token response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('[OAuth Service] Successfully received access token');
        final credentials = OAuthCredentials(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
          tokenType: data['token_type'] ?? 'Bearer',
          configId: config.id,
        );
        
        // Save the credentials
        await _saveCredentials(config.id, credentials);
        print('[OAuth Service] Credentials saved successfully');
        
        return credentials;
      } else {
        print('[OAuth Service] Failed to get access token. Status: ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to get access token: ${response.body}');
      }
    } catch (e, stackTrace) {
      print('[OAuth Service] Error in Authorization Code flow:');
      print('[OAuth Service] Error: $e');
      print('[OAuth Service] Stack trace: $stackTrace');
      throw Exception('Failed to acquire authorization code token: $e');
    }
  }

  /// Handle OAuth callback URL
  void handleCallback(Uri uri) {
    print('[OAuth Service] Received callback URL: $uri');
    final code = uri.queryParameters['code'];
    if (code != null && _completer != null && !_completer!.isCompleted) {
      print('[OAuth Service] Found authorization code in callback');
      _completer!.complete(code);
    } else {
      print('[OAuth Service] No code found in callback or completer already completed');
      print('[OAuth Service] Query parameters: ${uri.queryParameters}');
    }
  }

  /// Save credentials to secure storage
  Future<void> _saveCredentials(String configId, OAuthCredentials credentials) async {
    print('[OAuth Service] Saving credentials to secure storage...');
    try {
      await _secureStorage.write(
        key: _credentialsStorageKey + configId,
        value: credentials.accessToken,
      );
      print('[OAuth Service] Credentials saved successfully');
    } catch (e) {
      print('[OAuth Service] Error saving credentials: $e');
      throw Exception('Failed to save credentials: $e');
    }
  }

  /// Retrieve saved credentials
  Future<OAuthCredentials?> getCredentials(String configId) async {
    print('[OAuth Service] Getting credentials for config ID: $configId');
    try {
      final storedToken = await _secureStorage.read(key: _credentialsStorageKey + configId);
      if (storedToken == null) {
        print('[OAuth Service] No credentials found');
        return null;
      }
      print('[OAuth Service] Credentials found and loaded');
      // TODO: Implement proper credentials retrieval
      return null;
    } catch (e) {
      print('[OAuth Service] Error getting credentials: $e');
      return null;
    }
  }

  /// Refresh an existing token
  Future<OAuthCredentials> refreshToken(OAuthCredentials credentials) async {
    if (credentials.refreshToken == null) {
      print('[OAuth Service] Error: No refresh token available');
      throw StateError('No refresh token available');
    }

    try {
      print('[OAuth Service] Refreshing token...');
      final oauth2Credentials = credentials.toOAuth2Credentials();
      final refreshedCredentials = await oauth2Credentials.refresh(
        identifier: null, // Use existing client ID
        secret: null,     // Use existing client secret
      );

      print('[OAuth Service] Token refreshed successfully');
      final updatedCredentials = OAuthCredentials.fromOAuth2Credentials(refreshedCredentials);
      return updatedCredentials;
    } catch (e, stack) {
      print('[OAuth Service] Error refreshing token:');
      print('[OAuth Service] Error: $e');
      print('[OAuth Service] Stack trace: $stack');
      throw Exception('Failed to refresh token: $e');
    }
  }
}
