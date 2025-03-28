// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_request_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiRequestResultImpl _$$ApiRequestResultImplFromJson(
        Map<String, dynamic> json) =>
    _$ApiRequestResultImpl(
      statusCode: (json['statusCode'] as num).toInt(),
      body: json['body'] as String,
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      error: json['error'] as String?,
    );

Map<String, dynamic> _$$ApiRequestResultImplToJson(
        _$ApiRequestResultImpl instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'body': instance.body,
      'duration': instance.duration.inMicroseconds,
      'error': instance.error,
    };
