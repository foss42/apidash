// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
    );

Map<String, dynamic> _$WebSocketMessageToJson(_WebSocketMessage instance) =>
    <String, dynamic>{
      'payload': instance.payload,
      'timestamp': instance.timestamp?.toIso8601String(),
      'outgoing': instance.outgoing,
      'messageType': _$WebSocketMessageTypeEnumMap[instance.messageType]!,
    };

const _$WebSocketMessageTypeEnumMap = {
  WebSocketMessageType.connected: 'connected',
  WebSocketMessageType.sent: 'sent',
  WebSocketMessageType.received: 'received',
  WebSocketMessageType.error: 'error',
  WebSocketMessageType.disconnected: 'disconnected',
};

_WebSocketRequestModel _$WebSocketRequestModelFromJson(Map json) =>
    _WebSocketRequestModel(
      url: json['url'] as String? ?? "",
      messageHistory:
          (json['messageHistory'] as List<dynamic>?)
              ?.map(
                (e) => WebSocketMessage.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ),
              )
              .toList() ??
          const [],
      customHeaders:
          (json['customHeaders'] as Map?)?.map(
            (k, e) => MapEntry(k as String, e as String),
          ) ??
          const {},
      autoReconnect: json['autoReconnect'] as bool? ?? false,
      enableHeartbeat: json['enableHeartbeat'] as bool? ?? false,
    );

Map<String, dynamic> _$WebSocketRequestModelToJson(
  _WebSocketRequestModel instance,
) => <String, dynamic>{
  'url': instance.url,
  'customHeaders': instance.customHeaders,
  'autoReconnect': instance.autoReconnect,
  'enableHeartbeat': instance.enableHeartbeat,
};
