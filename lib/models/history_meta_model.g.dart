// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_meta_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HistoryMetaModelImpl _$$HistoryMetaModelImplFromJson(
        Map<String, dynamic> json) =>
    _$HistoryMetaModelImpl(
      historyId: json['historyId'] as String? ?? "",
      requestId: json['requestId'] as String? ?? "",
      apiType: $enumDecodeNullable(_$APITypeEnumMap, json['apiType']) ??
          APIType.rest,
      name: json['name'] as String? ?? "",
      url: json['url'] as String? ?? "",
      method: $enumDecodeNullable(_$HTTPVerbEnumMap, json['method']) ??
          HTTPVerb.get,
      responseStatus: (json['responseStatus'] as num?)?.toInt() ?? 200,
      timeStamp: json['timeStamp'] == null
          ? null
          : DateTime.parse(json['timeStamp'] as String),
    );

Map<String, dynamic> _$$HistoryMetaModelImplToJson(
        _$HistoryMetaModelImpl instance) =>
    <String, dynamic>{
      'historyId': instance.historyId,
      'requestId': instance.requestId,
      'apiType': _$APITypeEnumMap[instance.apiType]!,
      'name': instance.name,
      'url': instance.url,
      'method': _$HTTPVerbEnumMap[instance.method]!,
      'responseStatus': instance.responseStatus,
      'timeStamp': instance.timeStamp?.toIso8601String(),
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
