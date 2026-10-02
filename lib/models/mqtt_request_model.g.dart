// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mqtt_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MQTTRequestModel _$MQTTRequestModelFromJson(Map json) => _MQTTRequestModel(
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
          ?.map(
            (e) => NameValueModel.fromJson(Map<String, Object?>.from(e as Map)),
          )
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
          ?.map(
            (e) =>
                WebSocketMessage.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList() ??
      const [],
  message: json['message'] as String? ?? "",
  publishTopic: json['publishTopic'] as String? ?? "",
  allowInvalidCertificates: json['allowInvalidCertificates'] as bool? ?? false,
  userProperties:
      (json['userProperties'] as List<dynamic>?)
          ?.map(
            (e) => NameValueModel.fromJson(Map<String, Object?>.from(e as Map)),
          )
          .toList() ??
      const [],
  isUserPropertyEnabledList:
      (json['isUserPropertyEnabledList'] as List<dynamic>?)
          ?.map((e) => e as bool)
          .toList() ??
      const [],
  responseTopic: json['responseTopic'] as String? ?? "",
  correlationData: json['correlationData'] as String? ?? "",
  sessionExpiryInterval: (json['sessionExpiryInterval'] as num?)?.toInt() ?? 0,
  messageExpiryInterval: (json['messageExpiryInterval'] as num?)?.toInt() ?? 0,
  keepAlivePeriod: (json['keepAlivePeriod'] as num?)?.toInt() ?? 60,
  retainMessage: json['retainMessage'] as bool? ?? false,
  willTopic: json['willTopic'] as String? ?? "",
  willMessage: json['willMessage'] as String? ?? "",
  willRetain: json['willRetain'] as bool? ?? false,
  willQos: (json['willQos'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$MQTTRequestModelToJson(
  _MQTTRequestModel instance,
) => <String, dynamic>{
  'brokerUrl': instance.brokerUrl,
  'port': instance.port,
  'clientId': instance.clientId,
  'username': instance.username,
  'password': instance.password,
  'version': _$MQTTVersionEnumMap[instance.version]!,
  'subscribedTopics': instance.subscribedTopics.map((e) => e.toJson()).toList(),
  'isTopicEnabledList': instance.isTopicEnabledList,
  'useTLS': instance.useTLS,
  'useWebSocket': instance.useWebSocket,
  'qos': instance.qos,
  'messageHistory': instance.messageHistory.map((e) => e.toJson()).toList(),
  'message': instance.message,
  'publishTopic': instance.publishTopic,
  'allowInvalidCertificates': instance.allowInvalidCertificates,
  'userProperties': instance.userProperties.map((e) => e.toJson()).toList(),
  'isUserPropertyEnabledList': instance.isUserPropertyEnabledList,
  'responseTopic': instance.responseTopic,
  'correlationData': instance.correlationData,
  'sessionExpiryInterval': instance.sessionExpiryInterval,
  'messageExpiryInterval': instance.messageExpiryInterval,
  'keepAlivePeriod': instance.keepAlivePeriod,
  'retainMessage': instance.retainMessage,
  'willTopic': instance.willTopic,
  'willMessage': instance.willMessage,
  'willRetain': instance.willRetain,
  'willQos': instance.willQos,
};

const _$MQTTVersionEnumMap = {
  MQTTVersion.v3: 'v3',
  MQTTVersion.v3_1_1: 'v3_1_1',
  MQTTVersion.v5: 'v5',
};
