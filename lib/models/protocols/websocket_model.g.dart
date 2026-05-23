// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WebSocketRequestModel _$WebSocketRequestModelFromJson(
  Map<String, dynamic> json,
) => _WebSocketRequestModel(
  url: json['url'] as String,
  messageHistory:
      (json['messageHistory'] as List<dynamic>?)
          ?.map((e) => WebSocketMessage.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  customHeaders:
      (json['customHeaders'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
  autoReconnect: json['autoReconnect'] as bool? ?? false,
);

Map<String, dynamic> _$WebSocketRequestModelToJson(
  _WebSocketRequestModel instance,
) => <String, dynamic>{
  'url': instance.url,
  'messageHistory': instance.messageHistory,
  'customHeaders': instance.customHeaders,
  'autoReconnect': instance.autoReconnect,
};

_WebSocketMessage _$WebSocketMessageFromJson(Map<String, dynamic> json) =>
    _WebSocketMessage(
      payload: json['payload'] as String,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      outgoing: json['outgoing'] as bool? ?? true,
      messageType:
          $enumDecodeNullable(
            _$WebSocketMessageTypeEnumMap,
            json['messageType'],
          ) ??
          WebSocketMessageType.received,
      qos: (json['qos'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WebSocketMessageToJson(_WebSocketMessage instance) =>
    <String, dynamic>{
      'payload': instance.payload,
      'timestamp': instance.timestamp?.toIso8601String(),
      'outgoing': instance.outgoing,
      'messageType': _$WebSocketMessageTypeEnumMap[instance.messageType]!,
      'qos': instance.qos,
    };

const _$WebSocketMessageTypeEnumMap = {
  WebSocketMessageType.connected: 'connected',
  WebSocketMessageType.sent: 'sent',
  WebSocketMessageType.received: 'received',
  WebSocketMessageType.error: 'error',
};
