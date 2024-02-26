import 'dart:async';

import 'package:web_socket_channel/io.dart';

enum WebsocketMessageType { server, client, info, error }

class WebsocketMessage {
  WebsocketMessage(this.message, this.timestamp, this.type);
  final String message;
  final DateTime timestamp;
  final WebsocketMessageType type;

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "timestamp": timestamp.toIso8601String(),
      "type": type.name,
    };
  }

  factory WebsocketMessage.fromJson(Map<String, dynamic> data) {
    final message = data["message"] as String;
    final timestamp = DateTime.parse(data["timestamp"] as String);
    final type = WebsocketMessageType.values.byName(data["type"] as String);

    return WebsocketMessage(message, timestamp, type);
  }
}

class WebSocketManager {
  IOWebSocketChannel? channel;
  final void Function(String, WebsocketMessageType) addMessage;

  WebSocketManager({required this.addMessage});

  Future<void> connect(String url) async {
    addMessage("WebSocket channel connecting: $url", WebsocketMessageType.info);
    channel = IOWebSocketChannel.connect(url);

    await channel?.ready.then((value) {
      addMessage(
          "WebSocket channel connected: $url", WebsocketMessageType.info);
    });

    channel?.stream.listen(
      (message) {
        addMessage(message, WebsocketMessageType.server);
      },
      onError: (error) {
        addMessage("WebSocket channel error: $url", WebsocketMessageType.error);
      },
      onDone: () {
        addMessage("WebSocket channel closed: $url", WebsocketMessageType.info);
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
          "WebSocket channel disconnecting: $url", WebsocketMessageType.info);
      channel!.sink.close();
      channel = null;
    }
  }
}