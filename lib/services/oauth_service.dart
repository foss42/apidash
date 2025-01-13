import 'dart:async';
import 'dart:convert';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show HttpServer, ContentType;
import '../models/oauth_config_model.dart';
import '../models/oauth_credentials_model.dart';

class OAuthService {
  static const _credentialsStorageKey = 'oauth_credentials_';
  Completer<String>? _completer;
  HttpServer? _server;

  Future<String> _startLocalServer() async {
    _server = await HttpServer.bind('127.0.0.1', 3000);
    _server!.listen((request) async {
      final code = request.uri.queryParameters['code'];
      if (code != null && _completer != null && !_completer!.isCompleted) {
        request.response
          ..statusCode = 200
          ..headers.contentType =  ContentType('text', 'html')
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
    Map<String, dynamic> responseJson = {};
    if (response.headers['content-type']?.contains('json') == true) {
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
    return responseJson;
  }

  /// Acquire token using Client Credentials flow
  Future<OAuthCredentials> acquireClientCredentialsToken(OAuthConfig config) async {
    try {
      final client = http.Client();
      final requestBody = {
        'grant_type': 'client_credentials',
        'client_id': config.clientId,
        'client_secret': config.clientSecret ?? '',
        if (config.scope.isNotEmpty) 'scope': config.scope,
      };
      final response = await client.post(
        Uri.parse(config.tokenEndpoint),
        body: requestBody,
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to acquire token: ${response.body}');
      }
      final responseJson = _parseTokenResponse(response);
      final tokenResponse = oauth2.Credentials.fromJson(jsonEncode(responseJson));
      return OAuthCredentials.fromOAuth2Credentials(tokenResponse);
    } catch (e, stack) {
      throw Exception('Failed to acquire client credentials token: $e');
    }
  }

  /// Acquire token using Authorization Code flow
  Future<OAuthCredentials> acquireAuthorizationCodeToken(OAuthConfig config) async {
    _completer = Completer<String>();
    final callbackUrl = await _startLocalServer();
    final authUrl = Uri.parse(config.authUrl).replace(queryParameters: {
      'client_id': config.clientId,
      'response_type': 'code',
      'redirect_uri': callbackUrl,
      if (config.scope.isNotEmpty) 'scope': config.scope,
      if (config.state.isNotEmpty) 'state': config.state,
    });
    if (await canLaunchUrl(authUrl)) {
      await launchUrl(authUrl, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch authorization URL');
    }
    try {
      final code = await _completer!.future.timeout(
        const Duration(minutes: 5),
        onTimeout: () {
          _server?.close();
          _server = null;
          throw Exception('Authorization timeout');
        },
      );
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
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return OAuthCredentials(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
          tokenType: data['token_type'] ?? 'Bearer',
          configId: config.id,
        );
      } else {
        throw Exception('Failed to get access token: ${response.body}');
      }
    } catch (e, stackTrace) {
      throw Exception('Failed to acquire authorization code token: $e');
    }
  }

  /// Handle OAuth callback URL
  void handleCallback(Uri uri) {
    final code = uri.queryParameters['code'];
    if (code != null && _completer != null && !_completer!.isCompleted) {
      _completer!.complete(code);
    }
  }

  /// Refresh an existing token
  Future<OAuthCredentials> refreshToken(OAuthCredentials credentials) async {
    if (credentials.refreshToken == null) {
      throw StateError('No refresh token available');
    }
    try {
      final oauth2Credentials = credentials.toOAuth2Credentials();
      final refreshedCredentials = await oauth2Credentials.refresh(
        identifier: null, // Use existing client ID
        secret: null, // Use existing client secret
      );
      return OAuthCredentials.fromOAuth2Credentials(refreshedCredentials);
    } catch (e, stack) {
      throw Exception('Failed to refresh token: $e');
    }
  }
}