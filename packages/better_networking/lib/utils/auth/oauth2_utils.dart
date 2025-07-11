import 'dart:async';
import 'dart:io';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:url_launcher/url_launcher.dart';

class OAuth2Util {
  final File credentialsFile = File(
    '${Directory.systemTemp.path}/oauth2_credentials.json',
  );

  Future<void> clearCredentials() async {
    try {
      if (await credentialsFile.exists()) {
        await credentialsFile.delete();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<oauth2.Client?> refreshToken({
    required String identifier,
    String? secret,
  }) async {
    try {
      if (!await credentialsFile.exists()) {
        return null;
      }

      final json = await credentialsFile.readAsString();
      final credentials = oauth2.Credentials.fromJson(json);

      if (credentials.refreshToken == null) {
        return null;
      }

      final client = oauth2.Client(
        credentials,
        identifier: identifier,
        secret: secret,
      );

      // The oauth2 library automatically handles token refresh when needed
      // We just need to save the updated credentials
      await credentialsFile.writeAsString(client.credentials.toJson());
      return client;
    } catch (e) {
      return null;
    }
  }

  Future<oauth2.Client> oAuth2AuthorizationCodeGrantHandler({
    required String identifier,
    required String secret,
    required Uri authorizationEndpoint,
    required Uri tokenEndpoint,
    required Uri redirectUrl,
    String? state,
    String? scope,
  }) async {
    final appLinks = AppLinks();

    if (await credentialsFile.exists()) {
      try {
        final json = await credentialsFile.readAsString();
        final credentials = oauth2.Credentials.fromJson(json);
        if (credentials.accessToken.isNotEmpty && !credentials.isExpired) {
          return oauth2.Client(
            credentials,
            identifier: identifier,
            secret: secret,
          );
        }
      } catch (e) {
        debugPrint('Error reading existing credentials: $e');
      }
    }

    final grant = oauth2.AuthorizationCodeGrant(
      identifier,
      authorizationEndpoint,
      tokenEndpoint,
      secret: secret,
    );

    final authorizationUrl = grant.getAuthorizationUrl(
      redirectUrl,
      scopes: scope != null ? [scope] : null,
      state: state,
    );

    if (await canLaunchUrl(authorizationUrl)) {
      await launchUrl(authorizationUrl, mode: LaunchMode.inAppWebView);
    } else {
      throw Exception(
        "Cannot launch authorization URL: ${authorizationUrl.toString()}",
      );
    }

    final completer = Completer<Uri>();
    final sub = appLinks.uriLinkStream.listen((uri) {
      if (uri.toString().startsWith(redirectUrl.toString())) {
        completer.complete(uri);
      }
    });

    final initialUri = await appLinks.getInitialLink();

    if (initialUri != null &&
        initialUri.toString().startsWith(redirectUrl.toString())) {
      completer.complete(initialUri);
    }

    final uri = await completer.future.timeout(
      const Duration(seconds: 40),
      onTimeout: () {
        sub.cancel();
        throw Exception("Timed out waiting for OAuth2 redirect");
      },
    );

    sub.cancel();

    try {
      final client = await grant.handleAuthorizationResponse(
        uri.queryParameters,
      );

      await credentialsFile.writeAsString(client.credentials.toJson());

      return client;
    } catch (e) {
      rethrow;
    }
  }

  Future<oauth2.Client> oAuth2ClientCredentialsGrantHandler({
    required String identifier,
    required String secret,
    required Uri authorizationEndpoint,
    List<String>? scopes,
  }) async {
    if (await credentialsFile.exists()) {
      try {
        final json = await credentialsFile.readAsString();
        final credentials = oauth2.Credentials.fromJson(json);
        if (credentials.accessToken.isNotEmpty && !credentials.isExpired) {
          return oauth2.Client(
            credentials,
            identifier: identifier,
            secret: secret,
          );
        }
      } catch (e) {
        debugPrint('Error reading existing credentials: $e');
        // Continue with new authorization
      }
    }

    try {
      final client = await oauth2.clientCredentialsGrant(
        authorizationEndpoint,
        identifier,
        secret,
        scopes: scopes,
      );

      await credentialsFile.writeAsString(client.credentials.toJson());

      return client;
    } catch (e) {
      rethrow;
    }
  }

  Future<oauth2.Client> oAuth2ResourceOwnerPasswordGrantHandler({
    required String username,
    required String password,
    required Uri authorizationEndpoint,
    String? identifier,
    String? secret,
    List<String>? scopes,
  }) async {
    if (await credentialsFile.exists()) {
      try {
        final json = await credentialsFile.readAsString();
        final credentials = oauth2.Credentials.fromJson(json);
        if (credentials.accessToken.isNotEmpty && !credentials.isExpired) {
          return oauth2.Client(
            credentials,
            identifier: identifier,
            secret: secret,
          );
        }
      } catch (e) {
        debugPrint('Error reading existing credentials: $e');
        // Continue with new authorization
      }
    }

    try {
      final client = await oauth2.resourceOwnerPasswordGrant(
        authorizationEndpoint,
        username,
        password,
        identifier: identifier,
        secret: secret,
        scopes: scopes,
      );
      await credentialsFile.writeAsString(client.credentials.toJson());

      return client;
    } catch (e) {
      rethrow;
    }
  }
}
