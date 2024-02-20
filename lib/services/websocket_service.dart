import 'dart:async';

import 'package:web_socket_channel/io.dart';

class WebSocketManager {
  IOWebSocketChannel? channel;
  final Function(String)? onMessageReceived;

  WebSocketManager({this.onMessageReceived});

  Future<void> connect(String url) async {
    print("Connecting to $url");
    channel = IOWebSocketChannel.connect(url);

    channel!.stream.listen((message) {
      print("Received message: $message");
      // Trigger the callback when a new message is received
      onMessageReceived?.call(message);
    }, onError: (error) {
      print("Error on WebSocket channel: $error");
      // Handle error or close the connection as needed
    });

    channel!.sink.add("Hello from API Dash!");
  }

  // // Inside WebSocketManager
  // void onMessageReceived(String message, ProviderRef ref) {
  //   // Use the provider ref to read messagesProvider and add the new message
  //   ref.read(messagesProvider.notifier).addMessage(message);
  // }

  void sendMessage(String message) {
    if (channel != null) {
      print("Sending message: $message");
      channel!.sink.add(message);
    } else {
      print("WebSocket is not connected.");
    }
  }

  void disconnect() {
    if (channel != null) {
      channel!.sink.close();
      channel = null;
    }
  }
}
