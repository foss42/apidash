import 'dart:developer';

import 'package:apidash_core/services/clientWrapper.dart' as http;
import 'package:apidash_core/services/websocket_service.dart';
import 'package:http/http.dart' as http;

abstract class clientWrapper {
  void close() {}
}

class HttpClientWrapper extends clientWrapper {
  final http.Client client;
  HttpClientWrapper(this.client);
   @override
  void close() {
    log("cancelling under rest");
    client.close(); 
  }
}

class WebSocketClientWrapper extends clientWrapper {
  final WebSocketClient client;
  WebSocketClientWrapper(this.client);
  @override
  void close() {
    log("cancelling under websocket");
    client.disconnect(); 
  }
  
}
