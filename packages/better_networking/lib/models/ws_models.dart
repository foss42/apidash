/// Represents who sent a WebSocket message.
enum WsMessageType { sent, received, error, connected, disconnected }

/// A single message in a WebSocket conversation.
class WsMessage {
  final String content;
  final WsMessageType type;
  final DateTime timestamp;

  const WsMessage({
    required this.content,
    required this.type,
    required this.timestamp,
  });

  bool get isSent => type == WsMessageType.sent;
  bool get isReceived => type == WsMessageType.received;
  bool get isError => type == WsMessageType.error;
  bool get isStatus =>
      type == WsMessageType.connected || type == WsMessageType.disconnected;
}
