import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

http.Client createHttpClientWithNoSSL({Duration? timeout}) {
  final ioClient = HttpClient()
    ..badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;

  if (timeout != null) {
    ioClient.connectionTimeout = timeout;
  }

  return IOClient(ioClient);
}

HttpClient _createBaseHttpClient({Duration? timeout}) {
  final client = HttpClient();

  if (timeout != null) {
    client.connectionTimeout = timeout;
  }

  return client;
}

class _JsonAcceptClient extends http.BaseClient {
  final http.Client _inner;

  _JsonAcceptClient(this._inner);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Accept'] = 'application/json';
    return _inner.send(request);
  }

  @override
  void close() {
    _inner.close();
  }
}

class HttpClientManager {
  static final HttpClientManager _instance = HttpClientManager._internal();
  static const int _maxCancelledRequests = 100;
  final Map<String, http.Client> _clients = {};
  final Set<String> _cancelledRequests = {};

  factory HttpClientManager() {
    return _instance;
  }

  HttpClientManager._internal();

  http.Client createClient(
    String requestId, {
    bool noSSL = false,
    Duration? timeout,
  }) {
    final http.Client client;

    if (!kIsWeb) {
      if (noSSL) {
        client = createHttpClientWithNoSSL(timeout: timeout);
      } else {
        client = IOClient(_createBaseHttpClient(timeout: timeout));
      }
    } else {
      // Web does not support HttpClient.connectionTimeout
      client = http.Client();
    }

    _clients[requestId] = client;
    return client;
  }

  void cancelRequest(String? requestId) {
    if (requestId != null && _clients.containsKey(requestId)) {
      _clients[requestId]?.close();
      _clients.remove(requestId);

      _cancelledRequests.add(requestId);
      if (_cancelledRequests.length > _maxCancelledRequests) {
        _cancelledRequests.remove(_cancelledRequests.first);
      }
    }
  }

  bool wasRequestCancelled(String requestId) {
    return _cancelledRequests.contains(requestId);
  }

  void removeCancelledRequest(String requestId) {
    _cancelledRequests.remove(requestId);
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

  http.Client createClientWithJsonAccept(
    String requestId, {
    bool noSSL = false,
    Duration? timeout,
  }) {
    final http.Client baseClient;

    if (!kIsWeb) {
      if (noSSL) {
        baseClient = createHttpClientWithNoSSL(timeout: timeout);
      } else {
        baseClient = IOClient(_createBaseHttpClient(timeout: timeout));
      }
    } else {
      baseClient = http.Client();
    }

    final client = _JsonAcceptClient(baseClient);
    _clients[requestId] = client;
    return client;
  }
}
