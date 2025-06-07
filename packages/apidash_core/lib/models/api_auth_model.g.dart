// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NoneImpl _$$NoneImplFromJson(Map<String, dynamic> json) => _$NoneImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$NoneImplToJson(_$NoneImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$BasicAuthImpl _$$BasicAuthImplFromJson(Map<String, dynamic> json) =>
    _$BasicAuthImpl(
      username: json['username'] as String,
      password: json['password'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$BasicAuthImplToJson(_$BasicAuthImpl instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'runtimeType': instance.$type,
    };

_$BearerTokenAuthImpl _$$BearerTokenAuthImplFromJson(
        Map<String, dynamic> json) =>
    _$BearerTokenAuthImpl(
      token: json['token'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$BearerTokenAuthImplToJson(
        _$BearerTokenAuthImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'runtimeType': instance.$type,
    };

_$APIKeyAuthImpl _$$APIKeyAuthImplFromJson(Map<String, dynamic> json) =>
    _$APIKeyAuthImpl(
      key: json['key'] as String,
      location: json['location'] as String? ?? 'header',
      name: json['name'] as String? ?? 'x-api-key',
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$APIKeyAuthImplToJson(_$APIKeyAuthImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'location': instance.location,
      'name': instance.name,
      'runtimeType': instance.$type,
    };

_$JWTBearerAuthImpl _$$JWTBearerAuthImplFromJson(Map<String, dynamic> json) =>
    _$JWTBearerAuthImpl(
      jwt: json['jwt'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$JWTBearerAuthImplToJson(_$JWTBearerAuthImpl instance) =>
    <String, dynamic>{
      'jwt': instance.jwt,
      'runtimeType': instance.$type,
    };
