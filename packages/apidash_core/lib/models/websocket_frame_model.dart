import 'dart:typed_data';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
part 'websocket_frame_model.freezed.dart';
part 'websocket_frame_model.g.dart';

/// WebSocket Frame Model
@freezed
class WebSocketFrameModel with _$WebSocketFrameModel {
  const WebSocketFrameModel._();

  @JsonSerializable(explicitToJson: true, anyMap: true)
  const factory WebSocketFrameModel({
    required String id,
    @Default("") String frameType, 
    @Default("") String message, 
    Uint8List? binaryData, 
    Map<String, String>? metadata, 
    @Default(false) bool isFinalFrame, 
    DateTime? timeStamp, 
  }) = _WebSocketFrameModel;

  factory WebSocketFrameModel.fromJson(Map<String, Object?> json) =>
      _$WebSocketFrameModelFromJson(json);

  String formattedTime => DateFormat('HH:mm:ss').format(timeStamp);
  bool get isTextFrame => frameType.toLowerCase() == "text";

  
  bool get isBinaryFrame => frameType.toLowerCase() == "binary";

 
  @override
  String toString() {
    return 'WebSocketFrameModel('
        'frameType: $frameType, '
        'message: $message, '
        'binaryData: ${binaryData?.length ?? 0} bytes, '
        'metadata: $metadata, '
        'isFinalFrame: $isFinalFrame, '
        'timestamp: $timestamp)';
  }
}
