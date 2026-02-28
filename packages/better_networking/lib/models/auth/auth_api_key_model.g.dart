// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_api_key_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthApiKeyModelImpl _$$AuthApiKeyModelImplFromJson(
  Map<String, dynamic> json,
) => _$AuthApiKeyModelImpl(
  key: json['key'] as String,
  location: json['location'] as String? ?? 'header',
  name: json['name'] as String? ?? 'x-api-key',
);

Map<String, dynamic> _$$AuthApiKeyModelImplToJson(
  _$AuthApiKeyModelImpl instance,
) => <String, dynamic>{
  'key': instance.key,
  'location': instance.location,
  'name': instance.name,
};
