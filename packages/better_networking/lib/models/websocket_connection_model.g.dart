// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_connection_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WebSocketConnectionModel _$WebSocketConnectionModelFromJson(Map json) =>
    _WebSocketConnectionModel(
      isConnecting: json['isConnecting'] as bool? ?? false,
      isConnected: json['isConnected'] as bool? ?? false,
      isClosed: json['isClosed'] as bool? ?? false,
      connectedAt: json['connectedAt'] == null
          ? null
          : DateTime.parse(json['connectedAt'] as String),
      disconnectedAt: json['disconnectedAt'] == null
          ? null
          : DateTime.parse(json['disconnectedAt'] as String),
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => WebSocketMessageModel.fromJson(
                  Map<String, Object?>.from(e as Map)))
              .toList() ??
          const <WebSocketMessageModel>[],
    );

Map<String, dynamic> _$WebSocketConnectionModelToJson(
        _WebSocketConnectionModel instance) =>
    <String, dynamic>{
      'isConnecting': instance.isConnecting,
      'isConnected': instance.isConnected,
      'isClosed': instance.isClosed,
      'connectedAt': instance.connectedAt?.toIso8601String(),
      'disconnectedAt': instance.disconnectedAt?.toIso8601String(),
      'messages': instance.messages.map((e) => e.toJson()).toList(),
    };
