import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:better_networking/utils/auth/jwt_auth_utils.dart';
import 'package:better_networking/utils/auth/digest_auth_utils.dart';
import 'package:better_networking/better_networking.dart';
import 'package:better_networking/utils/auth/oauth2_utils.dart';
import 'package:flutter/foundation.dart';

import 'oauth1_utils.dart';

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
          final httpResult = await sendHttpRequestV1(
            "digest-${Random.secure()}",
            APIType.rest,
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
      if (authData.oauth1 != null) {
        final oauth1Model = authData.oauth1!;

        try {
          final client = generateOAuth1AuthHeader(
            oauth1Model,
            httpRequestModel,
          );

          updatedHeaders.add(
            NameValueModel(name: 'Authorization', value: client),
          );
          updatedHeaderEnabledList.add(true);
        } catch (e) {
          throw Exception('OAuth 1.0 authentication failed: $e');
        }
      }
      break;
    case APIAuthType.oauth2:
      final oauth2 = authData.oauth2;

      if (oauth2 == null) {
        throw Exception("Failed to get OAuth2 Data");
      }

      if (oauth2.redirectUrl == null) {
        throw Exception("No Redirect URL found!");
      }

      final credentialsFile = oauth2.credentialsFilePath != null
          ? File(oauth2.credentialsFilePath!)
          : null;

      switch (oauth2.grantType) {
        case OAuth2GrantType.authorizationCode:
          // Use localhost callback server for desktop platforms, fallback to custom scheme for mobile
          final res = await oAuth2AuthorizationCodeGrant(
            identifier: oauth2.clientId,
            secret: oauth2.clientSecret,
            authorizationEndpoint: Uri.parse(oauth2.authorizationUrl),
            redirectUrl: Uri.parse(
              oauth2.redirectUrl!.isEmpty
                  ? "apidash://oauth2/callback"
                  : oauth2.redirectUrl!,
            ),
            tokenEndpoint: Uri.parse(oauth2.accessTokenUrl),
            credentialsFile: credentialsFile,
            scope: oauth2.scope,
          );

          // Clean up the callback server if it exists and is still running
          // Note: The server might have already stopped itself due to timeout/error/completion
          final server = res.$2;
          if (server != null) {
            try {
              await server.stop();
            } catch (e) {
              debugPrint(
                'Error stopping OAuth callback server (might already be stopped): $e',
              );
            }
          }

          // Add the access token to the request headers
          updatedHeaders.add(
            NameValueModel(
              name: 'Authorization',
              value: 'Bearer ${res.$1.credentials.accessToken}',
            ),
          );
          updatedHeaderEnabledList.add(true);

          break;
        case OAuth2GrantType.clientCredentials:
          final client = await oAuth2ClientCredentialsGrantHandler(
            oauth2Model: oauth2,
            credentialsFile: credentialsFile,
          );

          // Add the access token to the request headers
          updatedHeaders.add(
            NameValueModel(
              name: 'Authorization',
              value: 'Bearer ${client.credentials.accessToken}',
            ),
          );
          updatedHeaderEnabledList.add(true);
          break;
        case OAuth2GrantType.resourceOwnerPassword:
          final client = await oAuth2ResourceOwnerPasswordGrantHandler(
            oauth2Model: oauth2,
            credentialsFile: credentialsFile,
          );

          // Add the access token to the request headers
          updatedHeaders.add(
            NameValueModel(
              name: 'Authorization',
              value: 'Bearer ${client.credentials.accessToken}',
            ),
          );
          updatedHeaderEnabledList.add(true);
          break;
      }
  }

  return httpRequestModel.copyWith(
    headers: updatedHeaders,
    params: updatedParams,
    isHeaderEnabledList: updatedHeaderEnabledList,
    isParamEnabledList: updatedParamEnabledList,
  );
}
