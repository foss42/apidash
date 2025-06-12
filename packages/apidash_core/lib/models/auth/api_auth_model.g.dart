// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthImpl _$$AuthImplFromJson(Map<String, dynamic> json) => _$AuthImpl(
      type: $enumDecode(_$APIAuthTypeEnumMap, json['type']),
      apikey: json['apikey'] == null
          ? null
          : AuthApiKeyModel.fromJson(json['apikey'] as Map<String, dynamic>),
      bearer: json['bearer'] == null
          ? null
          : AuthBearerModel.fromJson(json['bearer'] as Map<String, dynamic>),
      basic: json['basic'] == null
          ? null
          : AuthBasicAuthModel.fromJson(json['basic'] as Map<String, dynamic>),
      jwt: json['jwt'] == null
          ? null
          : AuthJwtModel.fromJson(json['jwt'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AuthImplToJson(_$AuthImpl instance) =>
    <String, dynamic>{
      'type': _$APIAuthTypeEnumMap[instance.type]!,
      'apikey': instance.apikey,
      'bearer': instance.bearer,
      'basic': instance.basic,
      'jwt': instance.jwt,
    };

const _$APIAuthTypeEnumMap = {
  APIAuthType.none: 'none',
  APIAuthType.basic: 'basic',
  APIAuthType.apiKey: 'apiKey',
  APIAuthType.bearerToken: 'bearerToken',
  APIAuthType.jwtBearer: 'jwtBearer',
  APIAuthType.digest: 'digest',
  APIAuthType.oauth1: 'oauth1',
  APIAuthType.oauth2: 'oauth2',
};
