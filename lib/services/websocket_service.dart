import 'dart:async';

import 'package:web_socket_channel/io.dart';

class WebSocketManager {
  IOWebSocketChannel? channel;
  final Function()? onConnecting;
  final Function()? onConnected;
  final Function()? onDisconnected;
  final Function(String)? onMessageReceived;

  WebSocketManager(
      {this.onConnecting,
      this.onConnected,
      this.onDisconnected,
      this.onMessageReceived});

  Future<void> connect(String url) async {
    // TODO does interfere with the onConnected callback
    // onConnecting?.call();
    channel = IOWebSocketChannel.connect(url);

    channel?.ready.then((value) {
      onConnected?.call();
    });

    channel?.stream.listen((message) {
      onMessageReceived?.call(message);
    }, onError: (error) {
      print("Error on WebSocket channel: $error");
      // Handle error or close the connection as needed
    });
  }

  void sendMessage(String message) {
    if (channel != null) {
      channel!.sink.add(message);
    } else {}
  }

  void disconnect() {
    if (channel != null) {
      onDisconnected?.call();
      channel!.sink.close();
      channel = null;
    }
  }
}
