import 'package:apidash_core/apidash_core.dart';

part 'ws_request_model.freezed.dart';
part 'ws_request_model.g.dart';

/// Describes the type/direction of a WebSocket message in the event stream.
enum WebSocketMessageType { connected, sent, received, error, disconnected }

/// A single message exchanged over a WebSocket connection.
///
/// Each message carries a [payload] (the raw text), a [timestamp], whether it
/// was [outgoing] (sent by the client) or incoming (received from the server),
/// and a [messageType] that categorises the event for display in the UI log.
@freezed
abstract class WebSocketMessage with _$WebSocketMessage {
  const factory WebSocketMessage({
    required String payload,
    DateTime? timestamp,
    @Default(true) bool outgoing,
    @Default(WebSocketMessageType.received) WebSocketMessageType messageType,
  }) = _WebSocketMessage;

  factory WebSocketMessage.fromJson(Map<String, dynamic> json) =>
      _$WebSocketMessageFromJson(json);
}

/// The request-level model that captures all WebSocket configuration for a
/// single tab in API Dash.
///
/// This is stored as `wsRequestModel` on [RequestModel], following the same
/// flat-field pattern as `httpRequestModel` and `aiRequestModel`.
@freezed
abstract class WebSocketRequestModel with _$WebSocketRequestModel {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
  )
  const factory WebSocketRequestModel({
    /// The WebSocket endpoint URL (e.g. `wss://echo.websocket.org`).
    @Default("") String url,

    /// Full message history for the event-stream view.
    @JsonKey(includeToJson: false) @Default([]) List<WebSocketMessage> messageHistory,

    /// Custom headers to send during the WebSocket handshake.
    @Default({}) Map<String, String> customHeaders,

    /// Whether to automatically re-establish the connection on close.
    @Default(false) bool autoReconnect,

    /// Whether to send periodic keep-alive pings.
    @Default(false) bool enableHeartbeat,
  }) = _WebSocketRequestModel;

  factory WebSocketRequestModel.fromJson(Map<String, dynamic> json) =>
      _$WebSocketRequestModelFromJson(json);
}
