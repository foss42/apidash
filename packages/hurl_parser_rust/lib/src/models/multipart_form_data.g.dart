// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multipart_form_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MultipartFormDataImpl _$$MultipartFormDataImplFromJson(
        Map<String, dynamic> json) =>
    _$MultipartFormDataImpl(
      name: json['name'] as String,
      value: json['value'] as String,
      filename: json['filename'] as String?,
      contentType: json['contentType'] as String?,
    );

Map<String, dynamic> _$$MultipartFormDataImplToJson(
        _$MultipartFormDataImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
      'filename': instance.filename,
      'contentType': instance.contentType,
    };
