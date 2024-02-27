import 'dart:async';

import 'package:web_socket_channel/io.dart';

enum WebSocketMessageType { server, client, info, error }

class WebSocketMessage {
  WebSocketMessage(this.message, this.timestamp, this.type);
  final String message;
  final DateTime timestamp;
  final WebSocketMessageType type;

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "timestamp": timestamp.toIso8601String(),
      "type": type.name,
    };
  }

  factory WebSocketMessage.fromJson(Map<String, dynamic> data) {
    final message = data["message"] as String;
    final timestamp = DateTime.parse(data["timestamp"] as String);
    final type = WebSocketMessageType.values.byName(data["type"] as String);

    return WebSocketMessage(message, timestamp, type);
  }
}

class WebSocketManager {
  WebSocketManager({required this.addMessage, required this.uri});
  IOWebSocketChannel? channel;
  Uri uri;
  final void Function(String, WebSocketMessageType) addMessage;

  Future<void> connect() async {
    addMessage("WebSocket channel connecting: $uri", WebSocketMessageType.info);
    channel = IOWebSocketChannel.connect(uri);

    await channel?.ready.then((value) {
      addMessage(
          "WebSocket channel connected: $uri", WebSocketMessageType.info);
    });

    channel?.stream.listen(
      (message) {
        addMessage(message, WebSocketMessageType.server);
      },
      onError: (error) {
        addMessage("WebSocket channel error: $uri", WebSocketMessageType.error);
      },
      onDone: () {
        addMessage("WebSocket channel closed: $uri", WebSocketMessageType.info);
      },
    );
  }

  void sendMessage(String message) {
    if (channel != null) {
      channel!.sink.add(message);
    } else {}
  }

  void disconnect() {
    if (channel != null) {
      addMessage(
          "WebSocket channel disconnecting: $uri", WebSocketMessageType.info);
      channel!.sink.close();
      channel = null;
    }
  }
}
