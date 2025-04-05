// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authorization_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthorizationModelImpl _$$AuthorizationModelImplFromJson(Map json) =>
    _$AuthorizationModelImpl(
      authType: $enumDecodeNullable(_$AuthTypeEnumMap, json['authType']) ??
          AuthType.noauth,
      isEnabled: json['isEnabled'] as bool? ?? false,
      basicAuthModel: json['basicAuthModel'] == null
          ? const BasicAuthModel(username: '', password: '')
          : BasicAuthModel.fromJson(
              Map<String, Object?>.from(json['basicAuthModel'] as Map)),
      bearerAuthModel: json['bearerAuthModel'] == null
          ? const BearerAuthModel(token: '')
          : BearerAuthModel.fromJson(
              Map<String, Object?>.from(json['bearerAuthModel'] as Map)),
      apiKeyAuthModel: json['apiKeyAuthModel'] == null
          ? const ApiKeyAuthModel(key: '', value: '', addTo: AddTo.header)
          : ApiKeyAuthModel.fromJson(
              Map<String, Object?>.from(json['apiKeyAuthModel'] as Map)),
    );

Map<String, dynamic> _$$AuthorizationModelImplToJson(
        _$AuthorizationModelImpl instance) =>
    <String, dynamic>{
      'authType': _$AuthTypeEnumMap[instance.authType]!,
      'isEnabled': instance.isEnabled,
      'basicAuthModel': instance.basicAuthModel.toJson(),
      'bearerAuthModel': instance.bearerAuthModel.toJson(),
      'apiKeyAuthModel': instance.apiKeyAuthModel.toJson(),
    };

const _$AuthTypeEnumMap = {
  AuthType.noauth: 'noauth',
  AuthType.basic: 'basic',
  AuthType.bearer: 'bearer',
  AuthType.apikey: 'apikey',
  AuthType.digest: 'digest',
  AuthType.oauth1: 'oauth1',
  AuthType.oauth2: 'oauth2',
};

_$BasicAuthModelImpl _$$BasicAuthModelImplFromJson(Map json) =>
    _$BasicAuthModelImpl(
      username: json['username'] as String? ?? "",
      password: json['password'] as String? ?? "",
    );

Map<String, dynamic> _$$BasicAuthModelImplToJson(
        _$BasicAuthModelImpl instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
    };

_$BearerAuthModelImpl _$$BearerAuthModelImplFromJson(Map json) =>
    _$BearerAuthModelImpl(
      token: json['token'] as String? ?? "",
    );

Map<String, dynamic> _$$BearerAuthModelImplToJson(
        _$BearerAuthModelImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
    };

_$ApiKeyAuthModelImpl _$$ApiKeyAuthModelImplFromJson(Map json) =>
    _$ApiKeyAuthModelImpl(
      key: json['key'] as String? ?? "",
      value: json['value'] as String? ?? "",
      addTo: $enumDecodeNullable(_$AddToEnumMap, json['addTo']) ?? AddTo.header,
    );

Map<String, dynamic> _$$ApiKeyAuthModelImplToJson(
        _$ApiKeyAuthModelImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
      'addTo': _$AddToEnumMap[instance.addTo]!,
    };

const _$AddToEnumMap = {
  AddTo.header: 'header',
  AddTo.query: 'query',
};
