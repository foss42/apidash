// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_basic_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthBasicAuthModelImpl _$$AuthBasicAuthModelImplFromJson(
  Map<String, dynamic> json,
) =>
    _$AuthBasicAuthModelImpl(
      username: json['username'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$$AuthBasicAuthModelImplToJson(
  _$AuthBasicAuthModelImpl instance,
) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
    };
