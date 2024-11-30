// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FormDataModelImpl _$$FormDataModelImplFromJson(Map<String, dynamic> json) =>
    _$FormDataModelImpl(
      name: json['name'] as String,
      value: json['value'] as String,
      type: $enumDecode(_$FormDataTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$$FormDataModelImplToJson(_$FormDataModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
      'type': _$FormDataTypeEnumMap[instance.type]!,
    };

const _$FormDataTypeEnumMap = {
  FormDataType.text: 'text',
  FormDataType.file: 'file',
};
