// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_api_key_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthApiKeyModel _$AuthApiKeyModelFromJson(Map<String, dynamic> json) =>
    _AuthApiKeyModel(
      key: json['key'] as String,
      location: json['location'] as String? ?? 'header',
      name: json['name'] as String? ?? 'x-api-key',
    );

Map<String, dynamic> _$AuthApiKeyModelToJson(_AuthApiKeyModel instance) =>
    <String, dynamic>{
      'key': instance.key,
      'location': instance.location,
      'name': instance.name,
    };
