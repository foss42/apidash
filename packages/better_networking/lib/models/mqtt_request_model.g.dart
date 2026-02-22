// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mqtt_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MqttTopicModel _$MqttTopicModelFromJson(Map json) => MqttTopicModel(
  topic: json['topic'] as String? ?? "",
  qos: $enumDecodeNullable(_$MqttQosEnumMap, json['qos']) ?? MqttQos.atMostOnce,
  description: json['description'] as String? ?? "",
);

Map<String, dynamic> _$MqttTopicModelToJson(MqttTopicModel instance) =>
    <String, dynamic>{
      'topic': instance.topic,
      'qos': _$MqttQosEnumMap[instance.qos]!,
      'description': instance.description,
    };

const _$MqttQosEnumMap = {
  MqttQos.atMostOnce: 'atMostOnce',
  MqttQos.atLeastOnce: 'atLeastOnce',
  MqttQos.exactlyOnce: 'exactlyOnce',
};

MqttRequestModel _$MqttRequestModelFromJson(Map json) => MqttRequestModel(
  url: json['url'] as String? ?? "",
  port: (json['port'] as num?)?.toInt() ?? 1883,
  clientId: json['clientId'] as String? ?? "",
  mqttVersion:
      $enumDecodeNullable(_$MqttVersionEnumMap, json['mqttVersion']) ??
      MqttVersion.v311,
  username: json['username'] as String?,
  password: json['password'] as String?,
  keepAlive: (json['keepAlive'] as num?)?.toInt() ?? 60,
  cleanSession: json['cleanSession'] as bool? ?? true,
  lastWillTopic: json['lastWillTopic'] as String?,
  lastWillMessage: json['lastWillMessage'] as String?,
  lastWillQos:
      $enumDecodeNullable(_$MqttQosEnumMap, json['lastWillQos']) ??
      MqttQos.atMostOnce,
  lastWillRetain: json['lastWillRetain'] as bool? ?? false,
  topics:
      (json['topics'] as List<dynamic>?)
          ?.map(
            (e) => MqttTopicModel.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList() ??
      const <MqttTopicModel>[],
);

Map<String, dynamic> _$MqttRequestModelToJson(MqttRequestModel instance) =>
    <String, dynamic>{
      'url': instance.url,
      'port': instance.port,
      'clientId': instance.clientId,
      'mqttVersion': _$MqttVersionEnumMap[instance.mqttVersion]!,
      'username': instance.username,
      'password': instance.password,
      'keepAlive': instance.keepAlive,
      'cleanSession': instance.cleanSession,
      'lastWillTopic': instance.lastWillTopic,
      'lastWillMessage': instance.lastWillMessage,
      'lastWillQos': _$MqttQosEnumMap[instance.lastWillQos]!,
      'lastWillRetain': instance.lastWillRetain,
      'topics': instance.topics.map((e) => e.toJson()).toList(),
    };

const _$MqttVersionEnumMap = {MqttVersion.v311: 'v311', MqttVersion.v5: 'v5'};
