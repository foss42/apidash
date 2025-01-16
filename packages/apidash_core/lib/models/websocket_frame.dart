import 'dart:typed_data';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'websocket_frame_model.freezed.dart';
part 'websocket_frame_model.g.dart';

/// WebSocket Frame Model
@freezed
class WebSocketFrameModel with _$WebSocketFrameModel {
  const WebSocketFrameModel._();

  @JsonSerializable(explicitToJson: true, anyMap: true)
  const factory WebSocketFrameModel({
    @Default("") String frameType, // Type of frame (e.g., "text", "binary", "ping", "pong", "close")
    @Default("") String message, // Text message (if frameType is "text")
    Uint8List? binaryData, // Binary payload (if frameType is "binary")
    Map<String, String>? metadata, // Additional metadata for the frame
    @Default(false) bool isFinalFrame, // Is this the final frame in a fragmented message?
    DateTime? timestamp, // Timestamp of when the frame was sent/received
  }) = _WebSocketFrameModel;

  /// Factory method to create a frame from JSON
  factory WebSocketFrameModel.fromJson(Map<String, Object?> json) =>
      _$WebSocketFrameModelFromJson(json);

  /// Utility method to check if the frame is text
  bool get isTextFrame => frameType.toLowerCase() == "text";

  /// Utility method to check if the frame is binary
  bool get isBinaryFrame => frameType.toLowerCase() == "binary";

  /// Utility to check if the frame is a control frame (e.g., "ping", "pong", "close")
  bool get isControlFrame =>
      frameType.toLowerCase() == "ping" ||
      frameType.toLowerCase() == "pong" ||
      frameType.toLowerCase() == "close";

  /// Serialize frame as a string for logging/debugging
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
