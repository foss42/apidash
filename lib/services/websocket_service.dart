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
      "type": type,
    };
  }
}

class WebSocketManager {
  IOWebSocketChannel? channel;
  final void Function(String, WebsocketMessageType) addMessage;
  final void Function() toggleConnect;

  WebSocketManager({required this.addMessage, required this.toggleConnect});

  Future<void> connect(String url) async {
    addMessage("WebSocket channel connecting: $url", WebsocketMessageType.info);
    channel = IOWebSocketChannel.connect(url);

    await channel?.ready.then((value) {
      toggleConnect();
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
      toggleConnect();
      addMessage(
          "WebSocket channel disconnecting: $url", WebsocketMessageType.info);
      channel!.sink.close();
      channel = null;
    }
  }
}
