import 'dart:convert';
import 'dart:math';

import 'package:seed/models/models.dart';

import '../../consts.dart';
import '../../models/models.dart';
import '../../services/http_service.dart';
import 'auth.dart';

Future<HttpRequestModel> handleAuth(
  HttpRequestModel httpRequestModel,
  AuthModel? authData,
) async {
  if (authData == null || authData.type == APIAuthType.none) {
    return httpRequestModel;
  }

  List<NameValueModel> updatedHeaders = List.from(
    httpRequestModel.headers ?? [],
  );
  List<NameValueModel> updatedParams = List.from(httpRequestModel.params ?? []);
  List<bool> updatedHeaderEnabledList = List.from(
    httpRequestModel.isHeaderEnabledList ?? [],
  );
  List<bool> updatedParamEnabledList = List.from(
    httpRequestModel.isParamEnabledList ?? [],
  );

  switch (authData.type) {
    case APIAuthType.basic:
      if (authData.basic != null) {
        final basicAuth = authData.basic!;
        final encoded = base64Encode(
          utf8.encode('${basicAuth.username}:${basicAuth.password}'),
        );
        updatedHeaders.add(
          NameValueModel(name: 'Authorization', value: 'Basic $encoded'),
        );
        updatedHeaderEnabledList.add(true);
      }
      break;

    case APIAuthType.bearer:
      if (authData.bearer != null) {
        final bearerAuth = authData.bearer!;
        updatedHeaders.add(
          NameValueModel(
            name: 'Authorization',
            value: 'Bearer ${bearerAuth.token}',
          ),
        );
        updatedHeaderEnabledList.add(true);
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
          updatedHeaders.add(
            NameValueModel(name: 'Authorization', value: headerValue),
          );
          updatedHeaderEnabledList.add(true);
        } else if (jwtAuth.addTokenTo == 'query') {
          final paramKey = jwtAuth.queryParamKey.isNotEmpty
              ? jwtAuth.queryParamKey
              : 'token';
          updatedParams.add(NameValueModel(name: paramKey, value: jwtToken));
          updatedParamEnabledList.add(true);
        }
      }
      break;

    case APIAuthType.apiKey:
      if (authData.apikey != null) {
        final apiKeyAuth = authData.apikey!;
        if (apiKeyAuth.location == 'header') {
          updatedHeaders.add(
            NameValueModel(name: apiKeyAuth.name, value: apiKeyAuth.key),
          );
          updatedHeaderEnabledList.add(true);
        } else if (apiKeyAuth.location == 'query') {
          updatedParams.add(
            NameValueModel(name: apiKeyAuth.name, value: apiKeyAuth.key),
          );
          updatedParamEnabledList.add(true);
        }
      }
      break;

    case APIAuthType.none:
      break;
    case APIAuthType.digest:
      if (authData.digest != null) {
        final digestAuthModel = authData.digest!;

        if (digestAuthModel.realm.isNotEmpty &&
            digestAuthModel.nonce.isNotEmpty) {
          final digestAuth = DigestAuth.fromModel(digestAuthModel);
          final authString = digestAuth.getAuthString(httpRequestModel);

          updatedHeaders.add(
            NameValueModel(name: 'Authorization', value: authString),
          );
          updatedHeaderEnabledList.add(true);
        } else {
          final httpResult = await sendHttpRequest(
            "digest-${Random.secure()}",
            APIType.rest,
            authData,
            httpRequestModel,
          );
          final httpResponse = httpResult.$1;

          if (httpResponse == null) {
            throw Exception("Initial Digest request failed: no response");
          }

          if (httpResponse.statusCode == 401) {
            final wwwAuthHeader = httpResponse.headers[kHeaderWwwAuthenticate];

            if (wwwAuthHeader == null) {
              throw Exception("401 response missing www-authenticate header");
            }

            final authParams = splitAuthenticateHeader(wwwAuthHeader);

            if (authParams == null) {
              throw Exception("Invalid Digest header format");
            }

            final updatedDigestModel = digestAuthModel.copyWith(
              realm: authParams['realm'] ?? '',
              nonce: authParams['nonce'] ?? '',
              algorithm: authParams['algorithm'] ?? 'MD5',
              qop: authParams['qop'] ?? 'auth',
              opaque: authParams['opaque'] ?? '',
            );

            final digestAuth = DigestAuth.fromModel(updatedDigestModel);
            final authString = digestAuth.getAuthString(httpRequestModel);
            updatedHeaders.add(
              NameValueModel(name: 'Authorization', value: authString),
            );
            updatedHeaderEnabledList.add(true);
          } else {
            throw Exception(
              "Initial Digest request failed due to unexpected status code: ${httpResponse.body}. Status Code: ${httpResponse.statusCode}",
            );
          }
        }
      }
      break;
    case APIAuthType.oauth1:
      // TODO: Handle this case.
      throw UnimplementedError();
    case APIAuthType.oauth2:
      final oauth2 = authData.oauth2;

      if (oauth2 == null) {
        throw Exception("No OAuth2 Data found");
      }
      if (oauth2.redirectUrl == null) {
        throw Exception("No Redirect URL found!");
      }

      final redirectUri = Uri.parse(
        oauth2.redirectUrl ?? "apidash://oauth/callback",
      );

      final oauth2Util = OAuth2Util();
      switch (oauth2.grantType) {
        case OAuth2GrantType.authorizationCode:
          final oauth2Client = await oauth2Util
              .oAuth2AuthorizationCodeGrantHandler(
                identifier: oauth2.clientId,
                secret: oauth2.clientSecret,
                authorizationEndpoint: Uri.parse(oauth2.authorizationUrl),
                tokenEndpoint: Uri.parse(oauth2.accessTokenUrl),
                redirectUrl: redirectUri,
                scope: oauth2.scope,
                state: oauth2.state,
              );

          updatedHeaders.add(
            NameValueModel(
              name: 'Authorization',
              value: 'Bearer ${oauth2Client.credentials.accessToken}',
            ),
          );
          updatedHeaderEnabledList.add(true);
        case OAuth2GrantType.clientCredentials:
          final oauth2Client = await oauth2Util
              .oAuth2ClientCredentialsGrantHandler(
                identifier: oauth2.clientId,
                secret: oauth2.clientSecret,
                authorizationEndpoint: Uri.parse(oauth2.authorizationUrl),
                scopes: oauth2.scope != null ? [oauth2.scope!] : null,
              );

          updatedHeaders.add(
            NameValueModel(
              name: 'Authorization',
              value: 'Bearer ${oauth2Client.credentials.accessToken}',
            ),
          );
          updatedHeaderEnabledList.add(true);
          throw UnimplementedError();
        case OAuth2GrantType.resourceOwnerPassword:
          if (oauth2.username == null || oauth2.password == null) {
            throw Exception("OAuth Credentials are missing");
          }
          final oauth2Client = await oauth2Util
              .oAuth2ResourceOwnerPasswordGrantHandler(
                identifier: oauth2.clientId,
                secret: oauth2.clientSecret,
                authorizationEndpoint: Uri.parse(oauth2.authorizationUrl),
                username: oauth2.username!,
                password: oauth2.password!,
                scopes: oauth2.scope != null ? [oauth2.scope!] : null,
              );

          updatedHeaders.add(
            NameValueModel(
              name: 'Authorization',
              value: 'Bearer ${oauth2Client.credentials.accessToken}',
            ),
          );
          updatedHeaderEnabledList.add(true);
      }

      break;
  }

  return httpRequestModel.copyWith(
    headers: updatedHeaders,
    params: updatedParams,
    isHeaderEnabledList: updatedHeaderEnabledList,
    isParamEnabledList: updatedParamEnabledList,
  );
}
