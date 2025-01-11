// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FilterImpl _$$FilterImplFromJson(Map<String, dynamic> json) => _$FilterImpl(
      type: json['type'] as String,
      expr: json['expr'] as String?,
      encoding: json['encoding'] as String?,
      fmt: json['fmt'] as String?,
      n: (json['n'] as num?)?.toInt(),
      oldValue: json['oldValue'] as String?,
      newValue: json['newValue'] as String?,
      sep: json['sep'] as String?,
    );

Map<String, dynamic> _$$FilterImplToJson(_$FilterImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'expr': instance.expr,
      'encoding': instance.encoding,
      'fmt': instance.fmt,
      'n': instance.n,
      'oldValue': instance.oldValue,
      'newValue': instance.newValue,
      'sep': instance.sep,
    };
