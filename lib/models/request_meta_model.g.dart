// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_meta_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RequestMetaModelImpl _$$RequestMetaModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RequestMetaModelImpl(
      id: json['id'] as String,
      apiType: $enumDecodeNullable(_$APITypeEnumMap, json['apiType']) ??
          APIType.rest,
      name: json['name'] as String? ?? "",
      description: json['description'] as String? ?? "",
      method: $enumDecodeNullable(_$HTTPVerbEnumMap, json['method']) ??
          HTTPVerb.get,
      url: json['url'] as String? ?? "",
      responseStatus: (json['responseStatus'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$RequestMetaModelImplToJson(
        _$RequestMetaModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'apiType': _$APITypeEnumMap[instance.apiType]!,
      'name': instance.name,
      'description': instance.description,
      'method': _$HTTPVerbEnumMap[instance.method]!,
      'url': instance.url,
      'responseStatus': instance.responseStatus,
    };

const _$APITypeEnumMap = {
  APIType.rest: 'rest',
  APIType.ai: 'ai',
  APIType.graphql: 'graphql',
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
