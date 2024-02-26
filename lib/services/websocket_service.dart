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
  IOWebSocketChannel? channel;
  final void Function(String, WebSocketMessageType) addMessage;

  WebSocketManager({required this.addMessage});

  Future<void> connect(String url) async {
    addMessage("WebSocket channel connecting: $url", WebSocketMessageType.info);
    channel = IOWebSocketChannel.connect(url);

    await channel?.ready.then((value) {
      addMessage(
          "WebSocket channel connected: $url", WebSocketMessageType.info);
    });

    channel?.stream.listen(
      (message) {
        addMessage(message, WebSocketMessageType.server);
      },
      onError: (error) {
        addMessage("WebSocket channel error: $url", WebSocketMessageType.error);
      },
      onDone: () {
        addMessage("WebSocket channel closed: $url", WebSocketMessageType.info);
      },
    );
  }

  void sendMessage(String message) {
    if (channel != null) {
      channel!.sink.add(message);
    } else {}
  }

  void disconnect(String url) {
    if (channel != null) {
      addMessage(
          "WebSocket channel disconnecting: $url", WebSocketMessageType.info);
      channel!.sink.close();
      channel = null;
    }
  }
}
