import 'dart:collection';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

class DioClientManager {
  static final DioClientManager _instance = DioClientManager._internal();
  static const int _maxCancelledRequests = 100;

  final Map<String, CancelToken> _cancelTokens = {};
  final Queue<String> _cancelledRequests = Queue();

  factory DioClientManager() => _instance;

  DioClientManager._internal();

  Dio createDioClient(String requestId, {bool noSSL = false}) {
    final cancelToken = CancelToken();
    _cancelTokens[requestId] = cancelToken;

    final dio = Dio(
      // BaseOptions(
      //   connectTimeout: const Duration(seconds: 30),
      //   receiveTimeout: const Duration(seconds: 30),
      // ), Remove from comments if necessary
    );

    if (noSSL && !kIsWeb) {
      final adapter = IOHttpClientAdapter();
      adapter.createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
      dio.httpClientAdapter = adapter;
    }

    return dio;
  }

  CancelToken? getCancelToken(String requestId) => _cancelTokens[requestId];

  void cancelRequest(String? requestId) {
    if (requestId != null && _cancelTokens.containsKey(requestId)) {
      _cancelTokens[requestId]?.cancel("Cancelled by user");
      _cancelTokens.remove(requestId);

      _cancelledRequests.addLast(requestId);
      while (_cancelledRequests.length > _maxCancelledRequests) {
        _cancelledRequests.removeFirst();
      }
    }
  }

  bool wasRequestCancelled(String requestId) {
    return _cancelledRequests.contains(requestId);
  }

  bool hasActiveToken(String requestId) {
    return _cancelTokens.containsKey(requestId);
  }
}
