// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_frame_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WebSocketFrameModelImpl _$$WebSocketFrameModelImplFromJson(Map json) =>
    _$WebSocketFrameModelImpl(
      id: json['id'] as String,
      frameType: json['frameType'] as String? ?? "",
      message: json['message'] as String? ?? "",
      binaryData:
          const Uint8ListConverter().fromJson(json['binaryData'] as List<int>?),
      metadata: (json['metadata'] as Map?)?.map(
        (k, e) => MapEntry(k as String, e as String),
      ),
      isSend: json['isSend'] as bool? ?? false,
      timeStamp: json['timeStamp'] == null
          ? null
          : DateTime.parse(json['timeStamp'] as String),
    );

Map<String, dynamic> _$$WebSocketFrameModelImplToJson(
        _$WebSocketFrameModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'frameType': instance.frameType,
      'message': instance.message,
      'binaryData': const Uint8ListConverter().toJson(instance.binaryData),
      'metadata': instance.metadata,
      'isSend': instance.isSend,
      'timeStamp': instance.timeStamp?.toIso8601String(),
    };
