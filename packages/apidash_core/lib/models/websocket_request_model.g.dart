// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WebSocketRequestModelImpl _$$WebSocketRequestModelImplFromJson(Map json) =>
    _$WebSocketRequestModelImpl(
      url: json['url'] as String? ?? "",
      isConnected: json['isConnected'] as bool?,
      headers: (json['headers'] as List<dynamic>?)
          ?.map((e) =>
              NameValueModel.fromJson(Map<String, Object?>.from(e as Map)))
          .toList(),
      isHeaderEnabledList: (json['isHeaderEnabledList'] as List<dynamic>?)
          ?.map((e) => e as bool)
          .toList(),
      params: (json['params'] as List<dynamic>?)
          ?.map((e) =>
              NameValueModel.fromJson(Map<String, Object?>.from(e as Map)))
          .toList(),
      isParamEnabledList: (json['isParamEnabledList'] as List<dynamic>?)
          ?.map((e) => e as bool)
          .toList(),
      message: json['message'] as String?,
      frames: (json['frames'] as List<dynamic>?)
              ?.map((e) => WebSocketFrameModel.fromJson(
                  Map<String, Object?>.from(e as Map)))
              .toList() ??
          const [],
      receivedMessages: (json['receivedMessages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$WebSocketRequestModelImplToJson(
        _$WebSocketRequestModelImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'isConnected': instance.isConnected,
      'headers': instance.headers?.map((e) => e.toJson()).toList(),
      'isHeaderEnabledList': instance.isHeaderEnabledList,
      'params': instance.params?.map((e) => e.toJson()).toList(),
      'isParamEnabledList': instance.isParamEnabledList,
      'message': instance.message,
      'frames': instance.frames.map((e) => e.toJson()).toList(),
      'receivedMessages': instance.receivedMessages,
    };
