// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_basic_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthBasicAuthModel _$AuthBasicAuthModelFromJson(Map<String, dynamic> json) =>
    _AuthBasicAuthModel(
      username: json['username'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$AuthBasicAuthModelToJson(_AuthBasicAuthModel instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
    };
