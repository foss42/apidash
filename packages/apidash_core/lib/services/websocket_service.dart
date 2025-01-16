import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketClient {
  final String url;
  late WebSocketChannel _channel;
  StreamSubscription? _subscription;

  WebSocketClient(this.url);

  
  Future<void> connect() async {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      print('Connected to WebSocket server: $url');
    } catch (e) {
      print('Failed to connect to WebSocket server: $e');
      rethrow;
    }
  }

  
  void sendText(String message) {
    if (_channel != null) {
      _channel.sink.add(message);
      print('Sent text message: $message');
    } else {
      print('WebSocket connection is not open. Unable to send text message.');
    }
  }

  
  void sendBinary(Uint8List data) {
    if (_channel != null) {
      _channel.sink.add(data);
      print('Sent binary message: $data');
    } else {
      print('WebSocket connection is not open. Unable to send binary message.');
    }
  }

  
  void listen(void Function(dynamic message) onMessage,
      {void Function(dynamic error)? onError, void Function()? onDone}) {
    _subscription = _channel.stream.listen(
      (message) {
        print('Received message: $message');
        onMessage(message);
      },
      onError: (error) {
        print('Error: $error');
        if (onError != null) onError(error);
      },
      onDone: () {
        print('Connection closed.');
        if (onDone != null) onDone();
      },
      cancelOnError: true,
    );
  }

  
  void disconnect({int closeCode = status.normalClosure, String? reason}) {
    _subscription?.cancel();
    _channel.sink.close(closeCode, reason);
    print('Disconnected from WebSocket server');
  }
}


void main() async {
  const wsUrl = 'ws://localhost:3000';

  final wsClient = WebSocketClient(wsUrl);

  try {
    await wsClient.connect();

    wsClient.listen(
      (message) {
        // Handle incoming messages
        if (message is String) {
          print('Text message received: $message');
        } else if (message is List<int>) {
          print('Binary message received: $message');
        }
      },
      onError: (error) {
        print('Error occurred: $error');
      },
      onDone: () {
        print('WebSocket connection closed.');
      },
    );

    
    wsClient.sendText('Hello, WebSocket!');

    
    final binaryData = Uint8List.fromList([0x68, 0x69]); // "hi" in binary
    wsClient.sendBinary(binaryData);

    
    await Future.delayed(Duration(seconds: 5));
    while(True){

    }
    wsClient.disconnect(reason: 'Closing connection after demo.');
  } catch (e) {
    print('Error: $e');
  }
}
