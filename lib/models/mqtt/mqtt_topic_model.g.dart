// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mqtt_topic_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MQTTTopicModelImpl _$$MQTTTopicModelImplFromJson(Map<String, dynamic> json) =>
    _$MQTTTopicModelImpl(
      name: json['name'] as String,
      qos: json['qos'] as int,
      subscribe: json['subscribe'] as bool,
      description: json['description'] as String,
    );

Map<String, dynamic> _$$MQTTTopicModelImplToJson(
        _$MQTTTopicModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'qos': instance.qos,
      'subscribe': instance.subscribe,
      'description': instance.description,
    };
