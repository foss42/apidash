// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'environment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EnvironmentModel _$EnvironmentModelFromJson(Map json) => _EnvironmentModel(
  id: json['id'] as String,
  name: json['name'] as String? ?? "",
  values:
      (json['values'] as List<dynamic>?)
          ?.map(
            (e) => EnvironmentVariableModel.fromJson(
              Map<String, Object?>.from(e as Map),
            ),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$EnvironmentModelToJson(_EnvironmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'values': instance.values.map((e) => e.toJson()).toList(),
    };

_EnvironmentVariableModel _$EnvironmentVariableModelFromJson(Map json) =>
    _EnvironmentVariableModel(
      key: json['key'] as String,
      value: json['value'] as String,
      type:
          $enumDecodeNullable(_$EnvironmentVariableTypeEnumMap, json['type']) ??
          EnvironmentVariableType.variable,
      enabled: json['enabled'] as bool? ?? false,
    );

Map<String, dynamic> _$EnvironmentVariableModelToJson(
  _EnvironmentVariableModel instance,
) => <String, dynamic>{
  'key': instance.key,
  'value': instance.value,
  'type': _$EnvironmentVariableTypeEnumMap[instance.type]!,
  'enabled': instance.enabled,
};

const _$EnvironmentVariableTypeEnumMap = {
  EnvironmentVariableType.variable: 'variable',
  EnvironmentVariableType.secret: 'secret',
};
