import 'dart:async';
import 'dart:io';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

import '../../models/auth/auth_oauth2_model.dart';
import '../../services/http_client_manager.dart';
import '../../services/oauth_callback_server.dart';
import '../platform_utils.dart';

/// Advanced OAuth2 authorization code grant handler that returns both the client and server
/// for cases where you need manual control over the callback server lifecycle.
///
/// Returns a tuple of (oauth2.Client, OAuthCallbackServer?) where the server is null for mobile platforms.
/// The server should be stopped by the caller to clean up resources.
Future<(oauth2.Client, OAuthCallbackServer?)> oAuth2AuthorizationCodeGrant({
  required String identifier,
  required String secret,
  required Uri authorizationEndpoint,
  required Uri tokenEndpoint,
  required Uri redirectUrl,
  required File? credentialsFile,
  String? state,
  String? scope,
}) async {
  // Check for existing credentials first
  if (credentialsFile != null && await credentialsFile.exists()) {
    try {
      final json = await credentialsFile.readAsString();
      final credentials = oauth2.Credentials.fromJson(json);

      if (credentials.accessToken.isNotEmpty && !credentials.isExpired) {
        return (
          oauth2.Client(credentials, identifier: identifier, secret: secret),
          null,
        );
      }
    } catch (e) {
      // Ignore credential reading errors and continue with fresh authentication
    }
  }

  // Create a unique request ID for this OAuth flow
  final requestId = 'oauth2-${DateTime.now().millisecondsSinceEpoch}';
  final httpClientManager = HttpClientManager();
  final baseClient = httpClientManager.createClientWithJsonAccept(requestId);

  OAuthCallbackServer? callbackServer;
  Uri actualRedirectUrl = redirectUrl;

  try {
    // Use localhost callback server for desktop platforms
    if (PlatformUtils.shouldUseLocalhostCallback) {
      callbackServer = OAuthCallbackServer();
      final localhostUrl = await callbackServer.start();
      actualRedirectUrl = Uri.parse(localhostUrl);
    }

    final grant = oauth2.AuthorizationCodeGrant(
      identifier,
      authorizationEndpoint,
      tokenEndpoint,
      secret: secret,
      httpClient: baseClient,
    );

    final authorizationUrl = grant.getAuthorizationUrl(
      actualRedirectUrl,
      scopes: scope != null ? [scope] : null,
      state: state,
    );

    String callbackUri;

    if (PlatformUtils.shouldUseLocalhostCallback && callbackServer != null) {
      // For desktop: Open the authorization URL in the default browser
      // and wait for the callback on the localhost server with a 3-minute timeout
      await _openUrlInBrowser(authorizationUrl.toString());

      try {
        callbackUri = await callbackServer.waitForCallback(
          timeout: const Duration(minutes: 3),
        );
        // Convert the relative callback to full URL
        callbackUri =
            'http://localhost${Uri.parse(callbackUri).path}${Uri.parse(callbackUri).query.isNotEmpty ? '?${Uri.parse(callbackUri).query}' : ''}';
      } on TimeoutException {
        throw Exception(
          'OAuth authorization timed out after 3 minutes. '
          'Please try again and complete the authorization in your browser. '
          'If you closed the browser tab, please restart the OAuth flow.',
        );
      } catch (e) {
        // Handle custom exceptions like browser tab closure
        final errorMessage = e.toString();
        if (errorMessage.contains('Browser tab was closed')) {
          throw Exception(
            'OAuth authorization was cancelled because the browser tab was closed. '
            'Please try again and complete the authorization process without closing the browser tab.',
          );
        } else if (errorMessage.contains('OAuth callback cancelled')) {
          throw Exception(
            'OAuth authorization was cancelled. Please try again if you want to complete the authentication.',
          );
        } else {
          throw Exception('OAuth authorization failed: $errorMessage');
        }
      }
    } else {
      // For mobile: Use the standard flutter_web_auth_2 approach
      callbackUri = await FlutterWebAuth2.authenticate(
        url: authorizationUrl.toString(),
        callbackUrlScheme: actualRedirectUrl.scheme,
        options: const FlutterWebAuth2Options(
          useWebview: true,
          windowName: 'OAuth Authorization - API Dash',
        ),
      );
    }

    // Parse the callback URI and handle the authorization response
    final callbackUriParsed = Uri.parse(callbackUri);
    final client = await grant.handleAuthorizationResponse(
      callbackUriParsed.queryParameters,
    );

    if (credentialsFile != null) {
      await credentialsFile.writeAsString(client.credentials.toJson());
    }

    return (client, callbackServer);
  } catch (e) {
    // Clean up the callback server immediately on error
    if (callbackServer != null) {
      try {
        await callbackServer.stop();
      } catch (serverError) {
        // Ignore server cleanup errors
      }
    }
    // Re-throw the original error
    rethrow;
  } finally {
    // Clean up HTTP client
    httpClientManager.closeClient(requestId);
  }
}

Future<oauth2.Client> oAuth2ClientCredentialsGrantHandler({
  required AuthOAuth2Model oauth2Model,
  required File? credentialsFile,
}) async {
  // Try to use saved credentials
  if (credentialsFile != null && await credentialsFile.exists()) {
    try {
      final json = await credentialsFile.readAsString();
      final credentials = oauth2.Credentials.fromJson(json);

      if (credentials.accessToken.isNotEmpty && !credentials.isExpired) {
        return oauth2.Client(
          credentials,
          identifier: oauth2Model.clientId,
          secret: oauth2Model.clientSecret,
        );
      }
    } catch (e) {
      // Ignore credential reading errors and continue with fresh authentication
    }
  }

  // Create a unique request ID for this OAuth flow
  final requestId = 'oauth2-client-${DateTime.now().millisecondsSinceEpoch}';
  final httpClientManager = HttpClientManager();
  final baseClient = httpClientManager.createClientWithJsonAccept(requestId);

  try {
    // Otherwise, perform the client credentials grant
    final client = await oauth2.clientCredentialsGrant(
      Uri.parse(oauth2Model.accessTokenUrl),
      oauth2Model.clientId,
      oauth2Model.clientSecret,
      scopes: oauth2Model.scope != null ? [oauth2Model.scope!] : null,
      basicAuth: false,
      httpClient: baseClient,
    );

    try {
      if (credentialsFile != null) {
        await credentialsFile.writeAsString(client.credentials.toJson());
      }
    } catch (e) {
      // Ignore credential saving errors
    }

    // Clean up the HTTP client
    httpClientManager.closeClient(requestId);

    return client;
  } catch (e) {
    // Clean up the HTTP client on error
    httpClientManager.closeClient(requestId);
    rethrow;
  }
}

Future<oauth2.Client> oAuth2ResourceOwnerPasswordGrantHandler({
  required AuthOAuth2Model oauth2Model,
  required File? credentialsFile,
}) async {
  // Try to use saved credentials
  if (credentialsFile != null && await credentialsFile.exists()) {
    try {
      final json = await credentialsFile.readAsString();
      final credentials = oauth2.Credentials.fromJson(json);

      if (credentials.accessToken.isNotEmpty && !credentials.isExpired) {
        return oauth2.Client(
          credentials,
          identifier: oauth2Model.clientId,
          secret: oauth2Model.clientSecret,
        );
      }
    } catch (e) {
      // Ignore credential reading errors and continue with fresh authentication
    }
  }
  if ((oauth2Model.username == null || oauth2Model.username!.isEmpty) ||
      (oauth2Model.password == null || oauth2Model.password!.isEmpty)) {
    throw Exception("Username or Password cannot be empty");
  }

  // Create a unique request ID for this OAuth flow
  final requestId = 'oauth2-password-${DateTime.now().millisecondsSinceEpoch}';
  final httpClientManager = HttpClientManager();
  final baseClient = httpClientManager.createClientWithJsonAccept(requestId);

  try {
    // Otherwise, perform the owner password grant
    final client = await oauth2.resourceOwnerPasswordGrant(
      Uri.parse(oauth2Model.accessTokenUrl),
      oauth2Model.username!,
      oauth2Model.password!,
      identifier: oauth2Model.clientId,
      secret: oauth2Model.clientSecret,
      scopes: oauth2Model.scope != null ? [oauth2Model.scope!] : null,
      basicAuth: false,
      httpClient: baseClient,
    );

    try {
      if (credentialsFile != null) {
        await credentialsFile.writeAsString(client.credentials.toJson());
      }
    } catch (e) {
      // Ignore credential saving errors
    }

    // Clean up the HTTP client
    httpClientManager.closeClient(requestId);

    return client;
  } catch (e) {
    // Clean up the HTTP client on error
    httpClientManager.closeClient(requestId);
    rethrow;
  }
}

/// Opens a URL in the default system browser.
/// This is used for desktop platforms where we want to open the OAuth authorization URL
/// in the user's default browser and use localhost callback server to capture the response.
Future<void> _openUrlInBrowser(String url) async {
  try {
    if (PlatformUtils.isDesktop) {
      Process? process;
      if (Platform.isMacOS) {
        process = await Process.start('open', [url]);
      } else if (Platform.isWindows) {
        process = await Process.start('rundll32', [
          'url.dll,FileProtocolHandler',
          url,
        ]);
      } else if (Platform.isLinux) {
        process = await Process.start('xdg-open', [url]);
      }

      if (process != null) {
        await process.exitCode; // Wait for the process to complete
      }
    }
  } catch (e) {
    // Fallback: throw an exception so the calling code can handle it
    throw Exception('Failed to open authorization URL in browser: $e');
  }
}
