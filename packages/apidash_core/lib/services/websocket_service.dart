import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/io.dart';

class WebSocketClient {
  late WebSocketChannel _channel;
  StreamSubscription? _subscription;
  Duration? pingInterval;
 

  WebSocketClient();

  
  Future<(String?,DateTime?)> connect(Uri uri,List<NameValueModel>? headers,List<NameValueModel>? params) async {
    print("inside client connect");
    try {
      
      String urlWithParams = getValidRequestUri(uri.urlWithParams, requestParams);
      if(!kIsWeb){
        final WebSocket ioWebSocket = await WebSocket.connect(url);
        _channel = IOWebSocketChannel(ioWebSocket);
        
        ioWebSocket.pingInterval = pingInterval;
         
      }else{
        _channel = WebSocketChannel.connect(Uri.parse(url));
      }
      await _channel.ready;
      print('Connected to WebSocket server: ${url}');
      return (kMsgConnected,DateTime.now());
      } catch (e) {
      print('Failed to connect to WebSocket server: $e');
      return (e.toString(),DateTime.now());
    }
  }

  
  Future<(String?,DateTime?,String?)> sendText(String message)async {
    try{
      _channel.sink.add(message);
      // websocketRequestModel.frames.add(WebSocketFrameModel(
      //   id: '1',
      //   message: websocketRequestModel.message!,
      //   timeStamp: DateTime.now(),
      // ));
      log('Sent text message: $message}');
      return (message,DateTime.now(),null);

    }catch(e){
      return (null,DateTime.now(),e.toString());

    }
    
  }

   Future<(String?,DateTime?,String?)> sendBinary(String message)async {
    try{
      Uint8List binary = Uint8List.fromList(utf8.encode(message));

      _channel.sink.add(binary);
      // websocketRequestModel.frames.add(WebSocketFrameModel(
      //   id: '1',
      //   message: websocketRequestModel.message!,
      //   timeStamp: DateTime.now(),
      // ));
      log('Sent text message: $message}');
      return (message,DateTime.now(),null);

    }catch(e){
      return (null,DateTime.now(),e.toString());

    }
    
  }
  
  Future<void> listen(Future<void> Function(dynamic message) onMessage,
      {Future<void> Function(dynamic error)? onError, Future<void> Function()? onDone,bool? cancelOnError}) async{
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
        if (_channel.closeCode != null) {
      print('Close code: ${_channel.closeCode}');
    }
    if (_channel.closeReason != null) {
      print('Close reason: ${_channel.closeReason}');
    }
        if (onDone != null) onDone();
      },
      cancelOnError: cancelOnError ?? true,
    );
  }

  
  Future<void> disconnect({int closeCode = status.normalClosure, String? reason})async {
    _subscription?.cancel();
    _channel.sink.close(closeCode, reason);
    log('Disconnected from WebSocket server');
  }
}

