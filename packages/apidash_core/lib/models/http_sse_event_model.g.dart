// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'http_sse_event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SSEEventModelImpl _$$SSEEventModelImplFromJson(Map json) =>
    _$SSEEventModelImpl(
      event: json['event'] as String? ?? "",
      data: json['data'] as String? ?? "",
      id: json['id'] as String?,
      retry: (json['retry'] as num?)?.toInt(),
      customFields: (json['customFields'] as Map?)?.map(
        (k, e) => MapEntry(k as String, e as String),
      ),
    );

Map<String, dynamic> _$$SSEEventModelImplToJson(_$SSEEventModelImpl instance) =>
    <String, dynamic>{
      'event': instance.event,
      'data': instance.data,
      'id': instance.id,
      'retry': instance.retry,
      'customFields': instance.customFields,
    };
