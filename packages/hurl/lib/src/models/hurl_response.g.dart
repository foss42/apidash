// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hurl_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HurlResponseImpl _$$HurlResponseImplFromJson(Map<String, dynamic> json) =>
    _$HurlResponseImpl(
      status: (json['status'] as num?)?.toInt(),
      version: json['version'] as String?,
      headers: (json['headers'] as List<dynamic>?)
          ?.map((e) => Header.fromJson(e as Map<String, dynamic>))
          .toList(),
      captures: (json['captures'] as List<dynamic>?)
          ?.map((e) => Capture.fromJson(e as Map<String, dynamic>))
          .toList(),
      asserts: (json['asserts'] as List<dynamic>?)
          ?.map((e) => HurlAssert.fromJson(e as Map<String, dynamic>))
          .toList(),
      body: json['body'],
      bodyType: json['body_type'] as String?,
    );

Map<String, dynamic> _$$HurlResponseImplToJson(_$HurlResponseImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'version': instance.version,
      'headers': instance.headers,
      'captures': instance.captures,
      'asserts': instance.asserts,
      if (instance.body case final value?) 'body': value,
      'body_type': instance.bodyType,
    };
