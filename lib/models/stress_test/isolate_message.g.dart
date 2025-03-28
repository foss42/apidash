// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isolate_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IsolateMessageImpl _$$IsolateMessageImplFromJson(Map<String, dynamic> json) =>
    _$IsolateMessageImpl(
      url: json['url'] as String,
      method: json['method'] as String,
      headers: (json['headers'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      body: json['body'],
      timeout: json['timeout'] == null
          ? null
          : Duration(microseconds: (json['timeout'] as num).toInt()),
    );

Map<String, dynamic> _$$IsolateMessageImplToJson(
        _$IsolateMessageImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'method': instance.method,
      'headers': instance.headers,
      'body': instance.body,
      'timeout': instance.timeout?.inMicroseconds,
    };
