// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'name_value_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NameValueModelImpl _$$NameValueModelImplFromJson(Map<String, dynamic> json) =>
    _$NameValueModelImpl(
      enabled: json['enabled'] as bool? ?? true,
      name: json['name'] as String,
      value: json['value'],
    );

Map<String, dynamic> _$$NameValueModelImplToJson(
        _$NameValueModelImpl instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'name': instance.name,
      'value': instance.value,
    };
