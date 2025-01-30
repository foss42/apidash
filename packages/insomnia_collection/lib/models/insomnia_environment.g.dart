// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insomnia_environment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InsomniaEnvironmentImpl _$$InsomniaEnvironmentImplFromJson(Map json) =>
    _$InsomniaEnvironmentImpl(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      resources: (json['kvPairData'] as List<dynamic>?)
          ?.map((e) =>
              EnvironmentVariable.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      type: json['_type'] as String?,
    );

Map<String, dynamic> _$$InsomniaEnvironmentImplToJson(
        _$InsomniaEnvironmentImpl instance) =>
    <String, dynamic>{
      if (instance.id case final value?) '_id': value,
      if (instance.name case final value?) 'name': value,
      if (instance.resources?.map((e) => e.toJson()).toList() case final value?)
        'kvPairData': value,
      if (instance.type case final value?) '_type': value,
    };

_$EnvironmentVariableImpl _$$EnvironmentVariableImplFromJson(Map json) =>
    _$EnvironmentVariableImpl(
      id: json['id'] as String?,
      key: json['name'] as String,
      value: json['value'] as String,
      type: json['type'] as String?,
      enabled: json['enabled'] as bool?,
    );

Map<String, dynamic> _$$EnvironmentVariableImplToJson(
        _$EnvironmentVariableImpl instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      'name': instance.key,
      'value': instance.value,
      if (instance.type case final value?) 'type': value,
      if (instance.enabled case final value?) 'enabled': value,
    };
