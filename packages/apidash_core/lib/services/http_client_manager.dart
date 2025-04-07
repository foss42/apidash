import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

class HttpClientManager {
  static final HttpClientManager _instance = HttpClientManager._internal();
  static const int _maxCancelledRequests = 100;

  final Map<String, Dio> _clients = {};
  final Map<String, CancelToken> _cancelTokens = {};
  final Set<String> _cancelledRequests = {};

  factory HttpClientManager() => _instance;

  HttpClientManager._internal();

  Dio createClient(String requestId, {bool noSSL = false}) {
    final dio = Dio();

    if (noSSL && !kIsWeb) {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      };
    }

    final cancelToken = CancelToken();
    _clients[requestId] = dio;
    _cancelTokens[requestId] = cancelToken;

    return dio;
  }

  CancelToken? getCancelToken(String requestId) => _cancelTokens[requestId];

  void cancelRequest(String? requestId) {
    if (requestId != null) {
      _cancelTokens[requestId]?.cancel("Request cancelled");
      _clients.remove(requestId);
      _cancelTokens.remove(requestId);
      _cancelledRequests.add(requestId);

      if (_cancelledRequests.length > _maxCancelledRequests) {
        _cancelledRequests.remove(_cancelledRequests.first);
      }
    }
  }

  bool wasRequestCancelled(String requestId) =>
      _cancelledRequests.contains(requestId);

  void removeCancelledRequest(String requestId) {
    _cancelledRequests.remove(requestId);
  }

  void closeClient(String requestId) {
    _clients.remove(requestId);
    _cancelTokens.remove(requestId);
  }

  bool hasActiveClient(String requestId) =>
      _clients.containsKey(requestId);
}
