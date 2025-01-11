// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'capture.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CaptureImpl _$$CaptureImplFromJson(Map json) => _$CaptureImpl(
      name: json['name'] as String,
      query: Query.fromJson(Map<String, dynamic>.from(json['query'] as Map)),
      filters: (json['filters'] as List<dynamic>?)
          ?.map((e) => Filter.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$$CaptureImplToJson(_$CaptureImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'query': instance.query.toJson(),
      'filters': instance.filters?.map((e) => e.toJson()).toList(),
    };
