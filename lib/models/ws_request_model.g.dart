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

_WebSocketRequestModel _$WebSocketRequestModelFromJson(
  Map json,
) => _WebSocketRequestModel(
  url: json['url'] as String? ?? "",
  messageHistory:
      (json['messageHistory'] as List<dynamic>?)
          ?.map(
            (e) =>
                WebSocketMessage.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList() ??
      const [],
  headers: (json['headers'] as List<dynamic>?)
      ?.map((e) => NameValueModel.fromJson(Map<String, Object?>.from(e as Map)))
      .toList(),
  isHeaderEnabledList: (json['isHeaderEnabledList'] as List<dynamic>?)
      ?.map((e) => e as bool)
      .toList(),
  params: (json['params'] as List<dynamic>?)
      ?.map((e) => NameValueModel.fromJson(Map<String, Object?>.from(e as Map)))
      .toList(),
  isParamEnabledList: (json['isParamEnabledList'] as List<dynamic>?)
      ?.map((e) => e as bool)
      .toList(),
  autoReconnect: json['autoReconnect'] as bool? ?? false,
  enableHeartbeat: json['enableHeartbeat'] as bool? ?? false,
  heartbeatInterval: (json['heartbeatInterval'] as num?)?.toInt() ?? 30,
  enableMessageHeartbeat: json['enableMessageHeartbeat'] as bool? ?? false,
  messageHeartbeatInterval:
      (json['messageHeartbeatInterval'] as num?)?.toInt() ?? 30,
  messageHeartbeatPayload: json['messageHeartbeatPayload'] as String? ?? "ping",
);

Map<String, dynamic> _$WebSocketRequestModelToJson(
  _WebSocketRequestModel instance,
) => <String, dynamic>{
  'url': instance.url,
  'messageHistory': instance.messageHistory.map((e) => e.toJson()).toList(),
  'headers': instance.headers?.map((e) => e.toJson()).toList(),
  'isHeaderEnabledList': instance.isHeaderEnabledList,
  'params': instance.params?.map((e) => e.toJson()).toList(),
  'isParamEnabledList': instance.isParamEnabledList,
  'autoReconnect': instance.autoReconnect,
  'enableHeartbeat': instance.enableHeartbeat,
  'heartbeatInterval': instance.heartbeatInterval,
  'enableMessageHeartbeat': instance.enableMessageHeartbeat,
  'messageHeartbeatInterval': instance.messageHeartbeatInterval,
  'messageHeartbeatPayload': instance.messageHeartbeatPayload,
};
