import 'dart:typed_data';
import 'package:apidash_core/models/http_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
part 'websocket_frame_model.freezed.dart';
part 'websocket_frame_model.g.dart';


@freezed
class WebSocketFrameModel with _$WebSocketFrameModel {
  const WebSocketFrameModel._();

  @JsonSerializable(explicitToJson: true, anyMap: true)
  const factory WebSocketFrameModel({
    required String id,
    @Default("") String frameType, 
    @Default("") String message, 
    @Uint8ListConverter() Uint8List? binaryData, 
    Map<String, String>? metadata, 
    @Default(false) bool isSend, 
    DateTime? timeStamp, 
  }) = _WebSocketFrameModel;

  factory WebSocketFrameModel.fromJson(Map<String, Object?> json) =>
      _$WebSocketFrameModelFromJson(json);

  String get formattedTime => DateFormat('HH:mm:ss.SSS').format(timeStamp ?? DateTime.now());
  bool get isTextFrame => frameType.toLowerCase() == "text";

  
  bool get isBinaryFrame => frameType.toLowerCase() == "binary";

}
