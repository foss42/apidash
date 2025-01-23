// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WebSocketResponseModelImpl _$$WebSocketResponseModelImplFromJson(Map json) =>
    _$WebSocketResponseModelImpl(
      statusCode: (json['statusCode'] as num?)?.toInt(),
      frames: (json['frames'] as List<dynamic>?)
              ?.map((e) => WebSocketFrameModel.fromJson(
                  Map<String, Object?>.from(e as Map)))
              .toList() ??
          const [],
      headers: (json['headers'] as Map?)?.map(
        (k, e) => MapEntry(k as String, e as String),
      ),
      requestHeaders: (json['requestHeaders'] as Map?)?.map(
        (k, e) => MapEntry(k as String, e as String),
      ),
    );

Map<String, dynamic> _$$WebSocketResponseModelImplToJson(
        _$WebSocketResponseModelImpl instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'frames': instance.frames.map((e) => e.toJson()).toList(),
      'headers': instance.headers,
      'requestHeaders': instance.requestHeaders,
    };
