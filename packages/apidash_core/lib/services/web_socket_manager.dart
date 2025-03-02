import 'package:seed/seed.dart';
import './websocket_service.dart';
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
  
Future<(String?,DateTime?)> connect(String requestId,String url,List<NameValueModel>? headers,List<NameValueModel>? params) async {
    if (_clients.containsKey(requestId)) {
      return _clients[requestId]!.connect(url,headers,params);
    }
    return (null,null);

  }

  Future<(String?,DateTime?,String?)> sendText(String requestId,String message) async {
    if (_clients.containsKey(requestId)) {
      return _clients[requestId]!.sendText(message);
    }
    return (null,null,null);
  }

  Future<(String?,DateTime?,String?)> sendBinary(String requestId,String message) async {
    if (_clients.containsKey(requestId)) {
      return _clients[requestId]!.sendBinary(message);
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
  Future<void> setPingInterval(String requestId,Duration? interval) async {
    if (_clients.containsKey(requestId)) {
       _clients[requestId]!.pingInterval = interval;
    }
  }
}
