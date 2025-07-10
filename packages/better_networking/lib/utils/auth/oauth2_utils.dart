import 'dart:async';

import 'dart:developer' show log;

import 'dart:io';

import 'package:app_links/app_links.dart';

import 'package:oauth2/oauth2.dart' as oauth2;

import 'package:url_launcher/url_launcher.dart';

Future<oauth2.Client> oAuth2AuthorizationCodeGrantHandler({
  required String identifier,

  required String secret,

  required Uri authorizationEndpoint,

  required Uri tokenEndpoint,

  required Uri redirectUrl,

  required File credentialsFile,

  String? state,

  String? scope,
}) async {
  final appLinks = AppLinks();

  if (await credentialsFile.exists()) {
    try {
      final json = await credentialsFile.readAsString();

      final credentials = oauth2.Credentials.fromJson(json);

      if (credentials.accessToken.isNotEmpty && !credentials.isExpired) {
        log('Using existing valid credentials');

        return oauth2.Client(
          credentials,

          identifier: identifier,

          secret: secret,
        );
      }
    } catch (e) {
      log('Error reading existing credentials: $e');

      // Continue with new authorization
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

  log('Generated authorization URL: ${authorizationUrl.toString()}');

  log('Expected redirect URL: ${redirectUrl.toString()}');

  if (await canLaunchUrl(authorizationUrl)) {
    log('Launching authorization URL: ${authorizationUrl.toString()}');

    await launchUrl(authorizationUrl, mode: LaunchMode.inAppWebView);
  } else {
    throw Exception(
      "Cannot launch authorization URL: ${authorizationUrl.toString()}",
    );
  }

  final completer = Completer<Uri>();

  final sub = appLinks.uriLinkStream.listen((uri) {
    log('Received URI: ${uri.toString()}');

    if (uri.toString().startsWith(redirectUrl.toString())) {
      log('Matching redirect URL found: ${uri.toString()}');

      completer.complete(uri);
    }
  });

  final initialUri = await appLinks.getInitialLink();

  if (initialUri != null &&
      initialUri.toString().startsWith(redirectUrl.toString())) {
    log('Initial URI matches redirect: ${initialUri.toString()}');

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

  log('Processing authorization response from: ${uri.toString()}');

  try {
    final client = await grant.handleAuthorizationResponse(uri.queryParameters);

    log('OAuth2 authorization successful, saving credentials');

    await credentialsFile.writeAsString(client.credentials.toJson());

    return client;
  } catch (e) {
    log('Error handling authorization response: $e');

    log('URI query parameters: ${uri.queryParameters}');

    rethrow;
  }
}
