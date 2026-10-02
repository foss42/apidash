// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_meta_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RequestMetaModel _$RequestMetaModelFromJson(Map<String, dynamic> json) =>
    _RequestMetaModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      apiType:
          $enumDecodeNullable(_$APITypeEnumMap, json['apiType']) ??
          APIType.rest,
      method: $enumDecodeNullable(_$HTTPVerbEnumMap, json['method']) ?? null,
      url: json['url'] as String? ?? '',
    );

Map<String, dynamic> _$RequestMetaModelToJson(_RequestMetaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'apiType': _$APITypeEnumMap[instance.apiType]!,
      'method': _$HTTPVerbEnumMap[instance.method],
      'url': instance.url,
    };

const _$APITypeEnumMap = {
  APIType.rest: 'rest',
  APIType.ai: 'ai',
  APIType.graphql: 'graphql',
  APIType.websocket: 'websocket',
  APIType.mqtt: 'mqtt',
  APIType.grpc: 'grpc',
};

const _$HTTPVerbEnumMap = {
  HTTPVerb.get: 'get',
  HTTPVerb.head: 'head',
  HTTPVerb.post: 'post',
  HTTPVerb.put: 'put',
  HTTPVerb.patch: 'patch',
  HTTPVerb.delete: 'delete',
  HTTPVerb.options: 'options',
};
