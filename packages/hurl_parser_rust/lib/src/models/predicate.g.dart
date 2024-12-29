// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'predicate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PredicateImpl _$$PredicateImplFromJson(Map<String, dynamic> json) =>
    _$PredicateImpl(
      type: json['type'] as String,
      not: json['not'] as bool? ?? false,
      value: json['value'],
      encoding: json['encoding'] as String?,
    );

Map<String, dynamic> _$$PredicateImplToJson(_$PredicateImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'not': instance.not,
      'value': instance.value,
      'encoding': instance.encoding,
    };
