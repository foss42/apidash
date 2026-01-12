// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WebSocketMessageModel _$WebSocketMessageModelFromJson(Map json) =>
    _WebSocketMessageModel(
      id: json['id'] as String,
      type: $enumDecodeNullable(_$WebSocketMessageTypeEnumMap, json['type']) ??
          WebSocketMessageType.info,
      payload: json['payload'] as String?,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      message: json['message'] as String?,
      sizeBytes: (json['sizeBytes'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WebSocketMessageModelToJson(
        _WebSocketMessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$WebSocketMessageTypeEnumMap[instance.type]!,
      'payload': instance.payload,
      'timestamp': instance.timestamp?.toIso8601String(),
      'message': instance.message,
      'sizeBytes': instance.sizeBytes,
    };

const _$WebSocketMessageTypeEnumMap = {
  WebSocketMessageType.connect: 'connect',
  WebSocketMessageType.disconnect: 'disconnect',
  WebSocketMessageType.sent: 'sent',
  WebSocketMessageType.received: 'received',
  WebSocketMessageType.error: 'error',
  WebSocketMessageType.info: 'info',
};
