import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/models/protocols/base_protocol_model.dart';

part 'websocket_model.freezed.dart';
part 'websocket_model.g.dart';

enum WebSocketMessageType { connected, sent, received, error }

@freezed
abstract class WebSocketRequestModel
    with _$WebSocketRequestModel
    implements ProtocolModel {
  const factory WebSocketRequestModel({
    required String url,
    @Default([]) List<WebSocketMessage> messageHistory,
    @Default({}) Map<String, String> customHeaders,
    @Default(false) bool autoReconnect,
  }) = _WebSocketRequestModel;

  factory WebSocketRequestModel.fromJson(Map<String, dynamic> json) =>
      _$WebSocketRequestModelFromJson(json);
}

/// Simple message model for WebSocket communication.
@freezed
abstract class WebSocketMessage with _$WebSocketMessage {
  const factory WebSocketMessage({
    required String payload,
    DateTime? timestamp,
    @Default(true) bool outgoing,
    @Default(WebSocketMessageType.received) WebSocketMessageType messageType,
    int? qos,
  }) = _WebSocketMessage;

  factory WebSocketMessage.fromJson(Map<String, dynamic> json) =>
      _$WebSocketMessageFromJson(json);
}
