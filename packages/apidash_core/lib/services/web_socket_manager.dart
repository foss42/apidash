import 'dart:io';
import 'dart:collection';
import 'package:apidash_core/services/websocket_service.dart';
import 'package:flutter/foundation.dart';

class WebSocketManager {
  static final WebSocketManager _instance = WebSocketManager._internal();
  final Map<String, WebSocketClient> _clients = {};

  factory WebSocketManager() {
    return _instance;
  }

  WebSocketManager._internal();

  WebSocketClient createWebSocketClient(
    String requestId, {
    bool noSSL = false,
  }) {
    final client =  WebSocketClient();
    _clients[requestId] = client;
    return client;
  }
  
  WebSocketClient? getClient(String requestId) {
    return _clients[requestId];
  }

  Future<void> disconnect(String requestId) async{
    await _clients[requestId]?.disconnect();
  }
  
Future<(String?,DateTime?)> connect(String requestId,String url) async {
    if (_clients.containsKey(requestId)) {
      return _clients[requestId]!.connect(url);
    }
    return (null,null);

  }

  Future<(String?,DateTime?,String?)> sendText(String requestId,String message) async {
    if (_clients.containsKey(requestId)) {
      return _clients[requestId]!.sendText(message);
    }
    return (null,null,null);
  }

  Future<void> listen(String requestId,Future<void> Function(dynamic message) onMessage,{Future<void> Function(dynamic error)? onError, Future<void> Function()? onDone,bool? cancelOnError}) async {
    if (_clients.containsKey(requestId)) {
      return _clients[requestId]!.listen(
        onMessage,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError,
      );
    }
  }
}
