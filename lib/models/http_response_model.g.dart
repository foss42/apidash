// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'http_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HttpResponseModelImpl _$$HttpResponseModelImplFromJson(Map json) =>
    _$HttpResponseModelImpl(
      statusCode: json['statusCode'] as int?,
      headers: (json['headers'] as Map?)?.map(
        (k, e) => MapEntry(k as String, e as String),
      ),
      requestHeaders: (json['requestHeaders'] as Map?)?.map(
        (k, e) => MapEntry(k as String, e as String),
      ),
      body: json['body'] as String?,
      formattedBody: json['formattedBody'] as String?,
      bodyBytes:
          const Uint8ListConverter().fromJson(json['bodyBytes'] as List<int>?),
      time: const DurationConverter().fromJson(json['time'] as int?),
    );

Map<String, dynamic> _$$HttpResponseModelImplToJson(
        _$HttpResponseModelImpl instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'headers': instance.headers,
      'requestHeaders': instance.requestHeaders,
      'body': instance.body,
      'formattedBody': instance.formattedBody,
      'bodyBytes': const Uint8ListConverter().toJson(instance.bodyBytes),
      'time': const DurationConverter().toJson(instance.time),
    };
