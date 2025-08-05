import 'dart:convert';
import 'dart:math';
import 'package:better_networking/utils/auth/jwt_auth_utils.dart';
import 'package:better_networking/utils/auth/digest_auth_utils.dart';
import 'package:better_networking/better_networking.dart';

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
      // TODO: Handle this case.
      throw UnimplementedError();
  }

  return httpRequestModel.copyWith(
    headers: updatedHeaders,
    params: updatedParams,
    isHeaderEnabledList: updatedHeaderEnabledList,
    isParamEnabledList: updatedParamEnabledList,
  );
}
