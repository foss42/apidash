import 'dart:io';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

http.Client createHttpClientWithNoSSL() {
  var ioClient = HttpClient()
    ..badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
  return IOClient(ioClient);
}

class HttpClientManager {
  static final HttpClientManager _instance = HttpClientManager._internal();
  static const int _maxCancelledRequests = 100;
  final Map<String, http.Client> _clients = {};
  final Queue<String> _cancelledRequests = Queue();

  factory HttpClientManager() {
    return _instance;
  }

  HttpClientManager._internal();

  http.Client createClient(
    String requestId, {
    bool noSSL = false,
  }) {
    final client =
        (noSSL && !kIsWeb) ? createHttpClientWithNoSSL() : http.Client();
    _clients[requestId] = client;
    return client;
  }

  void cancelRequest(String? requestId) {
    if (requestId != null && _clients.containsKey(requestId)) {
      _clients[requestId]?.close();
      _clients.remove(requestId);

      _cancelledRequests.addLast(requestId);
      while (_cancelledRequests.length > _maxCancelledRequests) {
        _cancelledRequests.removeFirst();
      }
    }
  }

  bool wasRequestCancelled(String requestId) {
    return _cancelledRequests.contains(requestId);
  }

  void closeClient(String requestId) {
    if (_clients.containsKey(requestId)) {
      _clients[requestId]?.close();
      _clients.remove(requestId);
    }
  }

  bool hasActiveClient(String requestId) {
    return _clients.containsKey(requestId);
  }
}
