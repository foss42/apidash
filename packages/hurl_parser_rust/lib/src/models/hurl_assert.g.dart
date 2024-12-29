// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hurl_assert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HurlAssertImpl _$$HurlAssertImplFromJson(Map json) => _$HurlAssertImpl(
      query: Query.fromJson(Map<String, dynamic>.from(json['query'] as Map)),
      filters: (json['filters'] as List<dynamic>?)
          ?.map((e) => Filter.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      predicate: Predicate.fromJson(
          Map<String, dynamic>.from(json['predicate'] as Map)),
    );

Map<String, dynamic> _$$HurlAssertImplToJson(_$HurlAssertImpl instance) =>
    <String, dynamic>{
      'query': instance.query.toJson(),
      'filters': instance.filters?.map((e) => e.toJson()).toList(),
      'predicate': instance.predicate.toJson(),
    };
