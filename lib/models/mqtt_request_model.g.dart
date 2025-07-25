// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mqtt_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MQTTRequestModelImpl _$$MQTTRequestModelImplFromJson(
        Map<String, dynamic> json) =>
    _$MQTTRequestModelImpl(
      brokerUrl: json['brokerUrl'] as String? ?? "",
      port: (json['port'] as num?)?.toInt() ?? 1883,
      clientId: json['clientId'] as String? ?? "",
      username: json['username'] as String? ?? "",
      password: json['password'] as String? ?? "",
      keepAlive: (json['keepAlive'] as num?)?.toInt() ?? 60,
      cleanSession: json['cleanSession'] as bool? ?? false,
      connectTimeout: (json['connectTimeout'] as num?)?.toInt() ?? 3,
      topics: (json['topics'] as List<dynamic>?)
              ?.map((e) => MQTTTopicModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      publishTopic: json['publishTopic'] as String? ?? "",
      publishPayload: json['publishPayload'] as String? ?? "",
      publishQos: (json['publishQos'] as num?)?.toInt() ?? 0,
      publishRetain: json['publishRetain'] as bool? ?? false,
    );

Map<String, dynamic> _$$MQTTRequestModelImplToJson(
        _$MQTTRequestModelImpl instance) =>
    <String, dynamic>{
      'brokerUrl': instance.brokerUrl,
      'port': instance.port,
      'clientId': instance.clientId,
      'username': instance.username,
      'password': instance.password,
      'keepAlive': instance.keepAlive,
      'cleanSession': instance.cleanSession,
      'connectTimeout': instance.connectTimeout,
      'topics': instance.topics,
      'publishTopic': instance.publishTopic,
      'publishPayload': instance.publishPayload,
      'publishQos': instance.publishQos,
      'publishRetain': instance.publishRetain,
    };

_$MQTTTopicModelImpl _$$MQTTTopicModelImplFromJson(Map<String, dynamic> json) =>
    _$MQTTTopicModelImpl(
      topic: json['topic'] as String,
      qos: (json['qos'] as num?)?.toInt() ?? 0,
      subscribe: json['subscribe'] as bool? ?? false,
      description: json['description'] as String? ?? "",
    );

Map<String, dynamic> _$$MQTTTopicModelImplToJson(
        _$MQTTTopicModelImpl instance) =>
    <String, dynamic>{
      'topic': instance.topic,
      'qos': instance.qos,
      'subscribe': instance.subscribe,
      'description': instance.description,
    };
