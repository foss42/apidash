// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthModelImpl _$$AuthModelImplFromJson(Map json) => _$AuthModelImpl(
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
);

Map<String, dynamic> _$$AuthModelImplToJson(_$AuthModelImpl instance) =>
    <String, dynamic>{
      'type': _$APIAuthTypeEnumMap[instance.type]!,
      'apikey': instance.apikey?.toJson(),
      'bearer': instance.bearer?.toJson(),
      'basic': instance.basic?.toJson(),
      'jwt': instance.jwt?.toJson(),
      'digest': instance.digest?.toJson(),
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
