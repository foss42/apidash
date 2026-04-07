import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:better_networking/better_networking.dart';
import 'package:better_networking/utils/auth/digest_auth_utils.dart';
import 'package:better_networking/utils/auth/jwt_auth_utils.dart';

import '../../src/logging.dart';
import 'oauth1_utils.dart';

Future<HttpRequestModel> handleAuth(
  HttpRequestModel httpRequestModel,
  AuthModel? authData, {
  /// Overrides the registered default OAuth2 callback handler for
  /// authorization-code flows on platforms that do not support the localhost
  /// callback server.
  OAuth2CallbackHandler? customCallbackHandler,
}) async {
  if (authData == null || authData.type == APIAuthType.none) {
    return httpRequestModel;
  }

  final mutations = _AuthMutationBuffer.fromRequest(httpRequestModel);

  switch (authData.type) {
    case APIAuthType.basic:
      if (authData.basic != null) {
        final basicAuth = authData.basic!;
        final encoded = base64Encode(
          utf8.encode('${basicAuth.username}:${basicAuth.password}'),
        );
        mutations.addHeader('Authorization', 'Basic $encoded');
      }
      break;

    case APIAuthType.bearer:
      if (authData.bearer != null) {
        mutations.addBearerAuthorization(authData.bearer!.token);
      }
      break;

    case APIAuthType.jwt:
      if (authData.jwt != null) {
        final jwtAuth = authData.jwt!;
        final jwtToken = generateJWT(jwtAuth);

        if (jwtAuth.addTokenTo == 'header') {
          final headerValue = jwtAuth.headerPrefix.isNotEmpty
              ? '${jwtAuth.headerPrefix} $jwtToken'
              : jwtToken;
          mutations.addHeader('Authorization', headerValue);
        } else if (jwtAuth.addTokenTo == 'query') {
          final paramKey = jwtAuth.queryParamKey.isNotEmpty
              ? jwtAuth.queryParamKey
              : 'token';
          mutations.addParam(paramKey, jwtToken);
        }
      }
      break;

    case APIAuthType.apiKey:
      if (authData.apikey != null) {
        final apiKeyAuth = authData.apikey!;
        if (apiKeyAuth.location == 'header') {
          mutations.addHeader(apiKeyAuth.name, apiKeyAuth.key);
        } else if (apiKeyAuth.location == 'query') {
          mutations.addParam(apiKeyAuth.name, apiKeyAuth.key);
        }
      }
      break;

    case APIAuthType.none:
      break;

    case APIAuthType.digest:
      if (authData.digest != null) {
        await _applyDigestAuth(
          httpRequestModel,
          authData.digest!,
          mutations,
        );
      }
      break;

    case APIAuthType.oauth1:
      if (authData.oauth1 != null) {
        final oauth1Model = authData.oauth1!;

        try {
          final header = generateOAuth1AuthHeader(
            oauth1Model,
            httpRequestModel,
          );
          mutations.addHeader('Authorization', header);
        } catch (e) {
          throw AuthException('OAuth 1.0 authentication failed: $e');
        }
      }
      break;

    case APIAuthType.oauth2:
      await _applyOAuth2Auth(
        httpRequestModel,
        authData.oauth2,
        mutations,
        customCallbackHandler: customCallbackHandler,
      );
      break;
  }

  return mutations.build(httpRequestModel);
}

Future<void> _applyDigestAuth(
  HttpRequestModel httpRequestModel,
  AuthDigestModel digestAuthModel,
  _AuthMutationBuffer mutations,
) async {
  if (digestAuthModel.realm.isNotEmpty && digestAuthModel.nonce.isNotEmpty) {
    final digestAuth = DigestAuth.fromModel(digestAuthModel);
    final authString = digestAuth.getAuthString(httpRequestModel);
    mutations.addHeader('Authorization', authString);
    return;
  }

  final httpResult = await sendHttpRequestV1(
    'digest-${Random.secure()}',
    APIType.rest,
    httpRequestModel,
  );
  final httpResponse = httpResult.$1;

  if (httpResponse == null) {
    throw const AuthException('Initial Digest request failed: no response');
  }

  if (httpResponse.statusCode != 401) {
    throw AuthException(
      'Initial Digest request failed due to unexpected status code: '
      '${httpResponse.body}. Status Code: ${httpResponse.statusCode}',
    );
  }

  final wwwAuthHeader = httpResponse.headers[kHeaderWwwAuthenticate];
  if (wwwAuthHeader == null) {
    throw const AuthException('401 response missing www-authenticate header');
  }

  final authParams = splitAuthenticateHeader(wwwAuthHeader);
  if (authParams == null) {
    throw const AuthException('Invalid Digest header format');
  }

  final updatedDigestModel = digestAuthModel.copyWith(
    realm: authParams['realm'] ?? '',
    nonce: authParams['nonce'] ?? '',
    algorithm: authParams['algorithm'] ?? 'MD5',
    qop: authParams['qop'] ?? 'auth',
    opaque: authParams['opaque'] ?? '',
  );

  final digestAuth = DigestAuth.fromModel(updatedDigestModel);
  mutations.addHeader(
    'Authorization',
    digestAuth.getAuthString(httpRequestModel),
  );
}

Future<void> _applyOAuth2Auth(
  HttpRequestModel httpRequestModel,
  AuthOAuth2Model? oauth2,
  _AuthMutationBuffer mutations, {
  OAuth2CallbackHandler? customCallbackHandler,
}) async {
  if (oauth2 == null) {
    throw const OAuth2ConfigurationException('Failed to get OAuth2 data.');
  }

  logDebug('Starting OAuth2 ${oauth2.grantType.name} flow.');
  final accessToken = await _resolveOAuth2AccessToken(
    oauth2,
    customCallbackHandler: customCallbackHandler,
  );
  mutations.addBearerAuthorization(accessToken);
  logDebug('OAuth2 ${oauth2.grantType.name} flow completed successfully.');
}

Future<String> _resolveOAuth2AccessToken(
  AuthOAuth2Model oauth2, {
  OAuth2CallbackHandler? customCallbackHandler,
}) async {
  final credentialsFile = oauth2.credentialsFilePath != null
      ? File(oauth2.credentialsFilePath!)
      : null;

  switch (oauth2.grantType) {
    case OAuth2GrantType.authorizationCode:
      final result = await oAuth2AuthorizationCodeGrant(
        identifier: oauth2.clientId,
        secret: oauth2.clientSecret,
        authorizationEndpoint: Uri.parse(oauth2.authorizationUrl),
        redirectUrl: _resolveOAuth2RedirectUrl(oauth2),
        tokenEndpoint: Uri.parse(oauth2.accessTokenUrl),
        credentialsFile: credentialsFile,
        scope: oauth2.scope,
        customCallbackHandler: customCallbackHandler,
      );
      await _stopOAuth2CallbackServer(result.$2);
      return result.$1.credentials.accessToken;

    case OAuth2GrantType.clientCredentials:
      final client = await oAuth2ClientCredentialsGrantHandler(
        oauth2Model: oauth2,
        credentialsFile: credentialsFile,
      );
      return client.credentials.accessToken;

    case OAuth2GrantType.resourceOwnerPassword:
      final client = await oAuth2ResourceOwnerPasswordGrantHandler(
        oauth2Model: oauth2,
        credentialsFile: credentialsFile,
      );
      return client.credentials.accessToken;
  }
}

Uri _resolveOAuth2RedirectUrl(AuthOAuth2Model oauth2) {
  final redirectUrl = oauth2.redirectUrl;
  if (redirectUrl == null || redirectUrl.isEmpty) {
    return Uri.parse('apidash://oauth2/callback');
  }
  return Uri.parse(redirectUrl);
}

Future<void> _stopOAuth2CallbackServer(OAuthCallbackServer? server) async {
  if (server == null) {
    return;
  }

  try {
    await server.stop();
  } catch (e) {
    logDebug(
      'Error stopping OAuth callback server (might already be stopped): $e',
    );
  }
}

class _AuthMutationBuffer {
  _AuthMutationBuffer.fromRequest(HttpRequestModel requestModel)
      : headers = List.from(requestModel.headers ?? []),
        params = List.from(requestModel.params ?? []),
        headerEnabled = List.from(requestModel.isHeaderEnabledList ?? []),
        paramEnabled = List.from(requestModel.isParamEnabledList ?? []);

  final List<NameValueModel> headers;
  final List<NameValueModel> params;
  final List<bool> headerEnabled;
  final List<bool> paramEnabled;

  void addHeader(String name, String value) {
    headers.add(NameValueModel(name: name, value: value));
    headerEnabled.add(true);
  }

  void addParam(String name, String value) {
    params.add(NameValueModel(name: name, value: value));
    paramEnabled.add(true);
  }

  void addBearerAuthorization(String token) {
    addHeader('Authorization', 'Bearer $token');
  }

  HttpRequestModel build(HttpRequestModel requestModel) {
    return requestModel.copyWith(
      headers: headers,
      params: params,
      isHeaderEnabledList: headerEnabled,
      isParamEnabledList: paramEnabled,
    );
  }
}
