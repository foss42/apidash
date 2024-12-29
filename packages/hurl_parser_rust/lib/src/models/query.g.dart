// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QueryImpl _$$QueryImplFromJson(Map<String, dynamic> json) => _$QueryImpl(
      type: json['type'] as String,
      expr: json['expr'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$$QueryImplToJson(_$QueryImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'expr': instance.expr,
      'name': instance.name,
    };
