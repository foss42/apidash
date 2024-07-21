// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_meta_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HistoryMetaModelImpl _$$HistoryMetaModelImplFromJson(
        Map<String, dynamic> json) =>
    _$HistoryMetaModelImpl(
      historyId: json['historyId'] as String,
      requestId: json['requestId'] as String,
      name: json['name'] as String? ?? "",
      url: json['url'] as String,
      method: $enumDecode(_$HTTPVerbEnumMap, json['method']),
      responseStatus: (json['responseStatus'] as num).toInt(),
      timeStamp: DateTime.parse(json['timeStamp'] as String),
    );

Map<String, dynamic> _$$HistoryMetaModelImplToJson(
        _$HistoryMetaModelImpl instance) =>
    <String, dynamic>{
      'historyId': instance.historyId,
      'requestId': instance.requestId,
      'name': instance.name,
      'url': instance.url,
      'method': _$HTTPVerbEnumMap[instance.method]!,
      'responseStatus': instance.responseStatus,
      'timeStamp': instance.timeStamp.toIso8601String(),
    };

const _$HTTPVerbEnumMap = {
  HTTPVerb.get: 'get',
  HTTPVerb.head: 'head',
  HTTPVerb.post: 'post',
  HTTPVerb.put: 'put',
  HTTPVerb.patch: 'patch',
  HTTPVerb.delete: 'delete',
};
