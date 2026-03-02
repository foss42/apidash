// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WebSocketRequestModel _$WebSocketRequestModelFromJson(Map json) =>
    _WebSocketRequestModel(
      url: json['url'] as String? ?? "",
      headers: (json['headers'] as List<dynamic>?)
              ?.map((e) =>
                  NameValueModel.fromJson(Map<String, Object?>.from(e as Map)))
              .toList() ??
          const [],
      params: (json['params'] as List<dynamic>?)
              ?.map((e) =>
                  NameValueModel.fromJson(Map<String, Object?>.from(e as Map)))
              .toList() ??
          const [],
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => WebSocketMessageModel.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$WebSocketRequestModelToJson(
        _WebSocketRequestModel instance) =>
    <String, dynamic>{
      'url': instance.url,
      'headers': instance.headers.map((e) => e.toJson()).toList(),
      'params': instance.params.map((e) => e.toJson()).toList(),
      'messages': instance.messages.map((e) => e.toJson()).toList(),
    };

_WebSocketMessageModel _$WebSocketMessageModelFromJson(
        Map<String, dynamic> json) =>
    _WebSocketMessageModel(
      message: json['message'] as String,
      time: DateTime.parse(json['time'] as String),
      isSent: json['isSent'] as bool,
    );

Map<String, dynamic> _$WebSocketMessageModelToJson(
        _WebSocketMessageModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'time': instance.time.toIso8601String(),
      'isSent': instance.isSent,
    };
