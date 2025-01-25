// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'capture.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CaptureImpl _$$CaptureImplFromJson(Map<String, dynamic> json) =>
    _$CaptureImpl(
      name: json['name'] as String,
      query: Query.fromJson(json['query'] as Map<String, dynamic>),
      filters: (json['filters'] as List<dynamic>?)
          ?.map((e) => Filter.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CaptureImplToJson(_$CaptureImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'query': instance.query,
      'filters': instance.filters,
    };
