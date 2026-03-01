// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthModel _$AuthModelFromJson(Map json) => _AuthModel(
  type: $enumDecode(_$APIAuthTypeEnumMap, json['type']),
  apikey: json['apikey'] == null
      ? null
      : AuthApiKeyModel.fromJson(
          Map<String, dynamic>.from(json['apikey'] as Map),
        ),
  bearer: json['bearer'] == null
      ? null
      : AuthBearerModel.fromJson(
          Map<String, dynamic>.from(json['bearer'] as Map),
        ),
  basic: json['basic'] == null
      ? null
      : AuthBasicAuthModel.fromJson(
          Map<String, dynamic>.from(json['basic'] as Map),
        ),
  jwt: json['jwt'] == null
      ? null
      : AuthJwtModel.fromJson(Map<String, dynamic>.from(json['jwt'] as Map)),
  digest: json['digest'] == null
      ? null
      : AuthDigestModel.fromJson(
          Map<String, dynamic>.from(json['digest'] as Map),
        ),
  oauth1: json['oauth1'] == null
      ? null
      : AuthOAuth1Model.fromJson(
          Map<String, dynamic>.from(json['oauth1'] as Map),
        ),
  oauth2: json['oauth2'] == null
      ? null
      : AuthOAuth2Model.fromJson(
          Map<String, dynamic>.from(json['oauth2'] as Map),
        ),
);

Map<String, dynamic> _$AuthModelToJson(_AuthModel instance) =>
    <String, dynamic>{
      'type': _$APIAuthTypeEnumMap[instance.type]!,
      'apikey': instance.apikey?.toJson(),
      'bearer': instance.bearer?.toJson(),
      'basic': instance.basic?.toJson(),
      'jwt': instance.jwt?.toJson(),
      'digest': instance.digest?.toJson(),
      'oauth1': instance.oauth1?.toJson(),
      'oauth2': instance.oauth2?.toJson(),
    };

const _$APIAuthTypeEnumMap = {
  APIAuthType.none: 'none',
  APIAuthType.basic: 'basic',
  APIAuthType.apiKey: 'apiKey',
  APIAuthType.bearer: 'bearer',
  APIAuthType.jwt: 'jwt',
  APIAuthType.digest: 'digest',
  APIAuthType.oauth1: 'oauth1',
  APIAuthType.oauth2: 'oauth2',
};
