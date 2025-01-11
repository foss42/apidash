// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hurl_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HurlResponseImpl _$$HurlResponseImplFromJson(Map json) => _$HurlResponseImpl(
      status: (json['status'] as num).toInt(),
      version: json['version'] as String,
      headers: (json['headers'] as List<dynamic>?)
          ?.map((e) => Header.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      captures: (json['captures'] as List<dynamic>?)
          ?.map((e) => Capture.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      asserts: (json['asserts'] as List<dynamic>?)
          ?.map((e) => HurlAssert.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      body: json['body'],
      bodyType: json['body_type'] as String?,
    );

Map<String, dynamic> _$$HurlResponseImplToJson(_$HurlResponseImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'version': instance.version,
      'headers': instance.headers?.map((e) => e.toJson()).toList(),
      'captures': instance.captures?.map((e) => e.toJson()).toList(),
      'asserts': instance.asserts?.map((e) => e.toJson()).toList(),
      if (instance.body case final value?) 'body': value,
      'body_type': instance.bodyType,
    };
