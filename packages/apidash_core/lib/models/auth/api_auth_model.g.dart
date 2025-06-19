// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthModelImpl _$$AuthModelImplFromJson(Map<String, dynamic> json) =>
    _$AuthModelImpl(
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

Map<String, dynamic> _$$AuthModelImplToJson(_$AuthModelImpl instance) =>
    <String, dynamic>{
      'type': _$APIAuthTypeEnumMap[instance.type]!,
      'apikey': instance.apikey?.toJson(),
      'bearer': instance.bearer?.toJson(),
      'basic': instance.basic?.toJson(),
      'jwt': instance.jwt?.toJson(),
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
