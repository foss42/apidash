// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mqtt_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MQTTRequestModel _$MQTTRequestModelFromJson(Map<String, dynamic> json) =>
    _MQTTRequestModel(
      brokerUrl: json['brokerUrl'] as String,
      port: (json['port'] as num?)?.toInt() ?? 1883,
      clientId: json['clientId'] as String?,
      username: json['username'] as String?,
      password: json['password'] as String?,
      version:
          $enumDecodeNullable(_$MQTTVersionEnumMap, json['version']) ??
          MQTTVersion.v5,
      subscribedTopics:
          (json['subscribedTopics'] as List<dynamic>?)
              ?.map((e) => NameValueModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isTopicEnabledList:
          (json['isTopicEnabledList'] as List<dynamic>?)
              ?.map((e) => e as bool)
              .toList() ??
          const [],
      useTLS: json['useTLS'] as bool? ?? false,
      useWebSocket: json['useWebSocket'] as bool? ?? false,
      qos: (json['qos'] as num?)?.toInt() ?? 0,
      messageHistory:
          (json['messageHistory'] as List<dynamic>?)
              ?.map((e) => WebSocketMessage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      message: json['message'] as String? ?? "",
      publishTopic: json['publishTopic'] as String? ?? "",
    );

Map<String, dynamic> _$MQTTRequestModelToJson(_MQTTRequestModel instance) =>
    <String, dynamic>{
      'brokerUrl': instance.brokerUrl,
      'port': instance.port,
      'clientId': instance.clientId,
      'username': instance.username,
      'password': instance.password,
      'version': _$MQTTVersionEnumMap[instance.version]!,
      'subscribedTopics': instance.subscribedTopics,
      'isTopicEnabledList': instance.isTopicEnabledList,
      'useTLS': instance.useTLS,
      'useWebSocket': instance.useWebSocket,
      'qos': instance.qos,
      'messageHistory': instance.messageHistory,
      'message': instance.message,
      'publishTopic': instance.publishTopic,
    };

const _$MQTTVersionEnumMap = {
  MQTTVersion.v3: 'v3',
  MQTTVersion.v3_1_1: 'v3_1_1',
  MQTTVersion.v5: 'v5',
};
