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
