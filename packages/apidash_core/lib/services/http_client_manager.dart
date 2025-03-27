import 'dart:io';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:apidash_core/models/models.dart';

http.Client createCustomHttpClient({
  bool noSSL = false,
  ProxySettings? proxySettings,
}) {
  if (kIsWeb) {
    return http.Client();
  }

  var ioClient = HttpClient();

  // Configure SSL
  if (noSSL) {
    ioClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }

  // Configure proxy if enabled
  if (proxySettings != null) {
    // Set proxy server
    ioClient.findProxy = (uri) {
      return 'PROXY ${proxySettings.host}:${proxySettings.port}';
    };

    // Configure proxy authentication if credentials are provided
    if (proxySettings.username != null && proxySettings.password != null) {
      ioClient.authenticate = (Uri url, String scheme, String? realm) async {
        return true;
      };
    }
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
    ProxySettings? proxySettings,
  }) {
    final client = createCustomHttpClient(
      noSSL: noSSL,
      proxySettings: proxySettings,
    );
    
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
