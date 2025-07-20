import 'dart:async';
import 'dart:developer' show log;
import 'dart:io';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

import '../../models/models.dart';

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

Future<oauth2.Client> oAuth2ClientCredentialsGrantHandler({
  required AuthOAuth2Model oauth2Model,
  required File credentialsFile,
}) async {
  // Try to use saved credentials
  if (await credentialsFile.exists()) {
    try {
      final json = await credentialsFile.readAsString();
      final credentials = oauth2.Credentials.fromJson(json);

      if (credentials.accessToken.isNotEmpty && !credentials.isExpired) {
        log('Using existing valid credentials');
        return oauth2.Client(
          credentials,
          identifier: oauth2Model.clientId,
          secret: oauth2Model.clientSecret,
        );
      }
    } catch (e) {
      log('Error reading existing credentials: $e');
    }
  }
  log("Creating Client with id: ${oauth2Model.clientId}");
  log("Creating Client with sec: ${oauth2Model.clientSecret}");

  // Otherwise, perform the client credentials grant
  final client = await oauth2.clientCredentialsGrant(
    Uri.parse(oauth2Model.authorizationUrl),
    oauth2Model.clientId,
    oauth2Model.clientSecret,
    scopes: oauth2Model.scope != null ? [oauth2Model.scope!] : null,
    basicAuth: false,
  );
  log("Created Client with id: ${client.identifier}");
  log("Created Client with sec: ${client.secret}");
  log("Created Client with sec: ${client.credentials.toJson()}");

  log('Successfully authenticated via client credentials grant');

  try {
    await credentialsFile.writeAsString(client.credentials.toJson());
    log('Saved credentials to file');
  } catch (e) {
    log('Failed to save credentials: $e');
  }

  return client;
}

Future<oauth2.Client> oAuth2ResourceOwnerPasswordGrantHandler({
  required AuthOAuth2Model oauth2Model,
  required File credentialsFile,
}) async {
  // Try to use saved credentials
  if (await credentialsFile.exists()) {
    try {
      final json = await credentialsFile.readAsString();
      final credentials = oauth2.Credentials.fromJson(json);

      if (credentials.accessToken.isNotEmpty && !credentials.isExpired) {
        log('Using existing valid credentials');
        return oauth2.Client(
          credentials,
          identifier: oauth2Model.clientId,
          secret: oauth2Model.clientSecret,
        );
      }
    } catch (e) {
      log('Error reading existing credentials: $e');
    }
  }
  if ((oauth2Model.username == null || oauth2Model.username!.isEmpty) ||
      (oauth2Model.password == null || oauth2Model.password!.isEmpty)) {
    throw Exception("Username or Password cannot be empty");
  }
  log("Creating Client with id: ${oauth2Model.clientId}");
  log("Creating Client with sec: ${oauth2Model.clientSecret}");

  // Otherwise, perform the owner password grant
  final client = await oauth2.resourceOwnerPasswordGrant(
    Uri.parse(oauth2Model.authorizationUrl),
    oauth2Model.username!,
    oauth2Model.password!,
    identifier: oauth2Model.clientId,
    secret: oauth2Model.clientSecret,
    scopes: oauth2Model.scope != null ? [oauth2Model.scope!] : null,
    basicAuth: false,
  );
  log("Created Client with id: ${client.identifier}");
  log("Created Client with sec: ${client.secret}");
  log("Created Client with sec: ${client.credentials.toJson()}");

  log('Successfully authenticated via client credentials grant');

  try {
    await credentialsFile.writeAsString(client.credentials.toJson());
    log('Saved credentials to file');
  } catch (e) {
    log('Failed to save credentials: $e');
  }

  return client;
}
