// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'environment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EnvironmentModelImpl _$$EnvironmentModelImplFromJson(
        Map<String, dynamic> json) =>
    _$EnvironmentModelImpl(
      id: json['id'] as String,
      name: json['name'] as String? ?? "",
      values: (json['values'] as List<dynamic>?)
              ?.map((e) =>
                  EnvironmentVariableModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$EnvironmentModelImplToJson(
        _$EnvironmentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'values': instance.values,
    };

_$EnvironmentVariableModelImpl _$$EnvironmentVariableModelImplFromJson(
        Map<String, dynamic> json) =>
    _$EnvironmentVariableModelImpl(
      key: json['key'] as String,
      value: json['value'] as String,
      type:
          $enumDecodeNullable(_$EnvironmentVariableTypeEnumMap, json['type']) ??
              EnvironmentVariableType.variable,
      enabled: json['enabled'] as bool? ?? true,
    );

Map<String, dynamic> _$$EnvironmentVariableModelImplToJson(
        _$EnvironmentVariableModelImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
      'type': _$EnvironmentVariableTypeEnumMap[instance.type]!,
      'enabled': instance.enabled,
    };

const _$EnvironmentVariableTypeEnumMap = {
  EnvironmentVariableType.variable: 'variable',
  EnvironmentVariableType.secret: 'secret',
};
