import 'dart:async';
import 'dart:developer' show log;
import 'dart:io';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

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

  final uri = await FlutterWebAuth2.authenticate(
    url: authorizationUrl.toString(),
    callbackUrlScheme: redirectUrl.scheme,
    options: const FlutterWebAuth2Options(useWebview: true),
  );

  try {
    final client = await grant.handleAuthorizationResponse(
      Uri.parse(uri).queryParameters,
    );

    log('OAuth2 authorization successful, saving credentials');

    await credentialsFile.writeAsString(client.credentials.toJson());

    return client;
  } catch (e) {
    log('Error handling authorization response: $e');

    log('URI query parameters: ${Uri.parse(uri).queryParameters}');

    rethrow;
  }
}
