import 'dart:convert';
import 'package:apidash_core/consts.dart';
import 'package:apidash_core/models/api_auth_model.dart';
import 'package:apidash_core/models/http_request_model.dart';
import 'package:seed/seed.dart';

HttpRequestModel handleAuth(HttpRequestModel httpRequestModel,
    APIAuthType apiAuthType, APIAuthModel? authData) {
  if (authData == null || apiAuthType == APIAuthType.none) {
    return httpRequestModel;
  }

  List<NameValueModel> updatedHeaders = List.from(httpRequestModel.headers ?? []);
  List<NameValueModel> updatedParams = List.from(httpRequestModel.params ?? []);
  List<bool> updatedHeaderEnabledList = List.from(httpRequestModel.isHeaderEnabledList ?? []);
  List<bool> updatedParamEnabledList = List.from(httpRequestModel.isParamEnabledList ?? []);

  switch (apiAuthType) {
    case APIAuthType.basic:
      final auth = authData as BasicAuth;
      final encoded =
          base64Encode(utf8.encode('${auth.username}:${auth.password}'));
      updatedHeaders.add(const NameValueModel(name: 'Authorization', value: ''));
      updatedHeaders[updatedHeaders.length - 1] = NameValueModel(
        name: 'Authorization', 
        value: 'Basic $encoded'
      );
      updatedHeaderEnabledList.add(true);
      break;

    case APIAuthType.bearerToken:
      final auth = authData as BearerTokenAuth;
      updatedHeaders.add(NameValueModel(
        name: 'Authorization', 
        value: 'Bearer ${auth.token}'
      ));
      updatedHeaderEnabledList.add(true);
      break;

    case APIAuthType.jwtBearer:
      final auth = authData as JWTBearerAuth;
      updatedHeaders.add(NameValueModel(
        name: 'Authorization', 
        value: 'Bearer ${auth.jwt}'
      ));
      updatedHeaderEnabledList.add(true);
      break;

    case APIAuthType.apiKey:
      final auth = authData as APIKeyAuth;
      if (auth.location == 'header') {
        updatedHeaders.add(NameValueModel(
          name: auth.name, 
          value: auth.key
        ));
        updatedHeaderEnabledList.add(true);
      } else if (auth.location == 'query') {
        updatedParams.add(NameValueModel(
          name: auth.name, 
          value: auth.key
        ));
        updatedParamEnabledList.add(true);
      }
      break;

    default:
      break;
  }

  return httpRequestModel.copyWith(
    headers: updatedHeaders,
    params: updatedParams,
    isHeaderEnabledList: updatedHeaderEnabledList,
    isParamEnabledList: updatedParamEnabledList,
  );
}
