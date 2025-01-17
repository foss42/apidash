import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:apidash_core/models/models.dart';
import 'package:apidash_core/models/websocket_request_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketClient {
  late WebSocketChannel _channel;
  StreamSubscription? _subscription;

  WebSocketClient();

  
  Future<(String?,DateTime?)> connect(HttpRequestModel websocketRequestModel) async {
    print("inside client connect");
    try {
      _channel = WebSocketChannel.connect(Uri.parse("ws://localhost:3000"));
      await _channel.ready;
      print('Connected to WebSocket server: ${"ws://localhost:3000"}');
      return ("Connected",DateTime.now());
      } catch (e) {
      print('Failed to connect to WebSocket server: $e');
      return (e.toString(),DateTime.now());
    }
  }

  
  // Future<(String?,DateTime?)> sendText(WebSocketRequestModel websocketRequestModel) {
  //   if (_channel != null) {
  //     _channel.sink.add(websocketRequestModel.message);
  //     log('Sent text message: ${websocketRequestModel.message}');
  //   } else {
  //     log('WebSocket connection is not open. Unable to send text message.');
  //   }
  // }

  
  // Future<(String?,DateTime?)> sendBinary(Uint8List data) {
  //   if (_channel != null) {
  //     _channel.sink.add(data);
  //     log('Sent binary message: $data');
  //   } else {
  //     log('WebSocket connection is not open. Unable to send binary message.');
  //   }
  // }

  
  Future<void> listen(Future<void> Function(dynamic message) onMessage,
      {Future<void> Function(dynamic error)? onError, Future<void> Function()? onDone}) async{
    _subscription = _channel.stream.listen(
      (message) {
        log('Received message: $message');
        onMessage(message);
      },
      onError: (error) {
        log('Error: $error');
        if (onError != null) onError(error);
      },
      onDone: () {
        log('Connection closed.');
        if (onDone != null) onDone();
      },
      cancelOnError: true,
    );
  }

  
  Future<void> disconnect({int closeCode = status.normalClosure, String? reason})async {
    _subscription?.cancel();
    _channel.sink.close(closeCode, reason);
    log('Disconnected from WebSocket server');
  }
}


// Future<(String?,DateTime?)> main() async {
//   const wsUrl = '"ws://localhost:3000"';

//   final wsClient = WebSocketClient(wsUrl);

//   try {
//     await wsClient.connect();

//     wsClient.listen(
//       (message) {
//         // Handle incoming messages
//         if (message is String) {
//           log('Text message received: $message');
//         } else if (message is List<int>) {
//           log('Binary message received: $message');
//         }
//       },
//       onError: (error) {
//         log('Error occurred: $error');
//       },
//       onDone: () {
//         log('WebSocket connection closed.');
//       },
//     );

    
//     wsClient.sendText('Hello, WebSocket!');

    
//     final binaryData = Uint8List.fromList([0x68, 0x69]); // "hi" in binary
//     wsClient.sendBinary(binaryData);

    
//     await Future.delayed(Duration(seconds: 5));
//     while(True){

//     }
//     wsClient.disconnect(reason: 'Closing connection after demo.');
//   } catch (e) {
//     log('Error: $e');
//   }
// }
