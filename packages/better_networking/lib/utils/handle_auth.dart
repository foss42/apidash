import 'dart:convert';
import 'package:better_networking/utils/auth_utils.dart';
import 'package:better_networking/better_networking.dart';

import '../models/auth/api_auth_model.dart';

HttpRequestModel handleAuth(HttpRequestModel httpRequestModel,AuthModel? authData) {
  if (authData == null || authData.type == APIAuthType.none) {
    return httpRequestModel;
  }

  List<NameValueModel> updatedHeaders =
      List.from(httpRequestModel.headers ?? []);
  List<NameValueModel> updatedParams = List.from(httpRequestModel.params ?? []);
  List<bool> updatedHeaderEnabledList =
      List.from(httpRequestModel.isHeaderEnabledList ?? []);
  List<bool> updatedParamEnabledList =
      List.from(httpRequestModel.isParamEnabledList ?? []);

  switch (authData.type) {
    case APIAuthType.basic:
      if (authData.basic != null) {
        final basicAuth = authData.basic!;
        final encoded = base64Encode(
            utf8.encode('${basicAuth.username}:${basicAuth.password}'));
        updatedHeaders.add(
            NameValueModel(name: 'Authorization', value: 'Basic $encoded'));
        updatedHeaderEnabledList.add(true);
      }
      break;

    case APIAuthType.bearer:
      if (authData.bearer != null) {
        final bearerAuth = authData.bearer!;
        updatedHeaders.add(NameValueModel(
            name: 'Authorization', value: 'Bearer ${bearerAuth.token}'));
        updatedHeaderEnabledList.add(true);
      }
      break;

    case APIAuthType.jwt:
      if (authData.jwt != null) {
        final jwtAuth = authData.jwt!;

        // Generate JWT token
        final jwtToken = generateJWT(jwtAuth);

        if (jwtAuth.addTokenTo == 'header') {
          // Add to request header with prefix
          final headerValue = jwtAuth.headerPrefix.isNotEmpty
              ? '${jwtAuth.headerPrefix} $jwtToken'
              : jwtToken;
          updatedHeaders
              .add(NameValueModel(name: 'Authorization', value: headerValue));
          updatedHeaderEnabledList.add(true);
        } else if (jwtAuth.addTokenTo == 'query') {
          // Add to query parameters(if selected)
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
              NameValueModel(name: apiKeyAuth.name, value: apiKeyAuth.key));
          updatedHeaderEnabledList.add(true);
        } else if (apiKeyAuth.location == 'query') {
          updatedParams.add(
              NameValueModel(name: apiKeyAuth.name, value: apiKeyAuth.key));
          updatedParamEnabledList.add(true);
        }
      }
      break;

    case APIAuthType.none:
      break;
    case APIAuthType.digest:
      // TODO: Handle this case.
      throw UnimplementedError();
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
