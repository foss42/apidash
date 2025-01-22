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

http.Client createHttpClientWithProxy(
  String proxyHost, 
  String proxyPort, 
  {String? proxyUsername, 
  String? proxyPassword, 
  bool noSSL = false}
) {
  var ioClient = HttpClient();
  
  // Configure proxy settings
  ioClient.findProxy = (uri) {
    return 'PROXY $proxyHost:$proxyPort';
  };

  // Configure proxy authentication if credentials are provided
  if (proxyUsername != null && proxyPassword != null) {
    ioClient.authenticate = (Uri url, String scheme, String? realm) async {
      return true;
    };
  }

  // Disable SSL verification if required
  if (noSSL) {
    ioClient.badCertificateCallback = 
        (X509Certificate cert, String host, int port) => true;
  }

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
    String? proxyHost,
    String? proxyPort,
    String? proxyUsername,
    String? proxyPassword,
  }) {
    final client = proxyHost != null && proxyPort != null
        ? createHttpClientWithProxy(
            proxyHost, 
            proxyPort, 
            proxyUsername: proxyUsername,
            proxyPassword: proxyPassword,
            noSSL: noSSL
          )
        : (noSSL && !kIsWeb) 
            ? createHttpClientWithNoSSL() 
            : http.Client();
    
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
