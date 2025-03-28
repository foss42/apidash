import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:http/http.dart' as http;

import 'package:apidash/models/stress_test/isolate_message.dart';
import '../../models/stress_test/stress_models.dart';

/// Service for executing parallel API requests following the Single Responsibility Principle
class StressTestService {

  static Future<ApiRequestResult> _executeRequest({
    required String url,
    required String method,
    Map<String, String>? headers,
    dynamic body,
    Duration? timeout,
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      final http.Response response;
      final client = http.Client();
      
      try {
        switch (method.toUpperCase()) {
          case 'GET':
            response = await client.get(
              Uri.parse(url),
              headers: headers,
            ).timeout(timeout ?? const Duration(seconds: 30));
          case 'POST':
            response = await client.post(
              Uri.parse(url),
              headers: headers,
              body: body is String ? body : jsonEncode(body),
            ).timeout(timeout ?? const Duration(seconds: 30));
          case 'PUT':
            response = await client.put(
              Uri.parse(url),
              headers: headers,
              body: body is String ? body : jsonEncode(body),
            ).timeout(timeout ?? const Duration(seconds: 30));
          case 'DELETE':
            response = await client.delete(
              Uri.parse(url),
              headers: headers,
              body: body is String ? body : jsonEncode(body),
            ).timeout(timeout ?? const Duration(seconds: 30));
          case 'PATCH':
            response = await client.patch(
              Uri.parse(url),
              headers: headers,
              body: body is String ? body : jsonEncode(body),
            ).timeout(timeout ?? const Duration(seconds: 30));
          default:
            throw Exception('Unsupported HTTP method: $method');
        }
      } finally {
        client.close();
      }

      stopwatch.stop();
      return ApiRequestResult(
        statusCode: response.statusCode,
        body: response.body,
        duration: stopwatch.elapsed,
        error: null,
      );
    } catch (e) {
      stopwatch.stop();
      return ApiRequestResult(
        statusCode: -1,
        body: '',
        duration: stopwatch.elapsed,
        error: e.toString(),
      );
    }
  }

  /// Isolate worker function
  static Future<void> _isolateWorker(SendPort sendPort) async {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    await for (final message in receivePort) {
      if (message is IsolateMessage) {
        final result = await _executeRequest(
          url: message.url,
          method: message.method,
          headers: message.headers,
          body: message.body,
          timeout: message.timeout,
        );
        sendPort.send(result);
      } else if (message == 'close') {
        break;
      }
    }

    Isolate.exit();
  }

  /// Execute a parallel API test with the given configuration
  static Future<StressTestSummary> runTest(StressTestConfig config) async {
    final totalStopwatch = Stopwatch()..start();
    final List<ApiRequestResult> results = [];

    if (config.useIsolates) {
      final isolates = <Isolate>[];
      final receivePorts = <ReceivePort>[];
      final workerPorts = <SendPort>[];

      try {
        for (int i = 0; i < config.concurrentRequests; i++) {
          final receivePort = ReceivePort();
          receivePorts.add(receivePort);
          
          final isolate = await Isolate.spawn(_isolateWorker, receivePort.sendPort);
          isolates.add(isolate);
          
          final workerPort = await receivePort.first as SendPort;
          workerPorts.add(workerPort);
        }

        final responseReceivePorts = <ReceivePort>[];
        for (final workerPort in workerPorts) {
          final responsePort = ReceivePort();
          responseReceivePorts.add(responsePort);
          
          // Send the request to the isolate
          workerPort.send(IsolateMessage(
            url: config.url,
            method: config.method,
            headers: config.headers,
            body: config.body,
            timeout: config.timeout,
          ));
        }

        final futures = responseReceivePorts.map((port) => port.first);
        final responses = await Future.wait(futures);
        
        for (final response in responses) {
          if (response is ApiRequestResult) {
            results.add(response);
          }
        }

        for (final workerPort in workerPorts) {
          workerPort.send('close');
        }
      } finally {
        for (final isolate in isolates) {
          isolate.kill(priority: Isolate.immediate);
        }
        for (final port in receivePorts) {
          port.close();
        }
      }
    } else {
      // without isolates
      final futures = <Future<ApiRequestResult>>[];
      
      for (int i = 0; i < config.concurrentRequests; i++) {
        futures.add(_executeRequest(
          url: config.url,
          method: config.method,
          headers: config.headers,
          body: config.body,
          timeout: config.timeout,
        ));
      }
      
      results.addAll(await Future.wait(futures));
    }

    // Calculating statistics
    totalStopwatch.stop();
    final totalDuration = totalStopwatch.elapsed;
    
    final successCount = results.where((r) => r.error == null && r.statusCode >= 200 && r.statusCode < 300).length;
    final failureCount = results.length - successCount;
    
    final totalResponseTime = results.fold<Duration>(
      Duration.zero, 
      (prev, result) => prev + result.duration
    );
    final avgResponseTime = results.isEmpty 
        ? 0.0 
        : totalResponseTime.inMicroseconds / results.length / 1000; // in milliseconds

    return StressTestSummary(
      results: results,
      totalDuration: totalDuration,
      avgResponseTime: avgResponseTime,
      successCount: successCount,
      failureCount: failureCount,
    );
  }
}
