import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:http/http.dart' as http;

import 'package:apidash/models/stress_test/api_request_result.dart';
import 'package:apidash/models/stress_test/stress_test_config.dart';
import 'package:apidash/models/stress_test/stress_test_summary.dart';
import 'package:apidash/models/stress_test/isolate_message.dart';

// Stress Test Service Class 
class StressTestService {

  static Future<ApiRequestResult> _executeRequest({
    required String url,
    required String method,
    Map<String, String>? headers,
    dynamic body,
    Duration? timeout,
  }) async {
    final stopwatch = Stopwatch()..start();
    final client = http.Client();

    try {
      http.Response response;
      final defaultTimeout = const Duration(seconds: 30);
      
      try {
        switch (method.toUpperCase()) {
          case 'GET':
            response = await client.get(
              Uri.parse(url),
              headers: headers,
            ).timeout(timeout ?? defaultTimeout);
          case 'POST':
            response = await client.post(
              Uri.parse(url),
              headers: headers,
              body: body is String ? body : jsonEncode(body),
            ).timeout(timeout ?? defaultTimeout);
          case 'PUT':
            response = await client.put(
              Uri.parse(url),
              headers: headers,
              body: body is String ? body : jsonEncode(body),
            ).timeout(timeout ?? defaultTimeout);
          case 'DELETE':
            response = await client.delete(
              Uri.parse(url),
              headers: headers,
              body: body is String ? body : jsonEncode(body),
            ).timeout(timeout ?? defaultTimeout);
          case 'PATCH':
            response = await client.patch(
              Uri.parse(url),
              headers: headers,
              body: body is String ? body : jsonEncode(body),
            ).timeout(timeout ?? defaultTimeout);
          default:
            throw Exception('Unsupported HTTP method: $method');
        }

        stopwatch.stop();
        return ApiRequestResult(
          statusCode: response.statusCode,
          body: response.body,
          duration: stopwatch.elapsed,
          error: null,
        );
      } on TimeoutException {
        stopwatch.stop();
        return ApiRequestResult(
          statusCode: -1,
          body: '',
          duration: stopwatch.elapsed,
          error: 'Request timed out after ${(timeout ?? defaultTimeout).inSeconds} seconds',
        );
      } on http.ClientException catch (e) {
        stopwatch.stop();
        return ApiRequestResult(
          statusCode: -1,
          body: '',
          duration: stopwatch.elapsed,
          error: 'HTTP client error: ${e.message}',
        );
      } on FormatException catch (e) {
        stopwatch.stop();
        return ApiRequestResult(
          statusCode: -1,
          body: '',
          duration: stopwatch.elapsed,
          error: 'Format error: ${e.message}',
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
    } finally {
      client.close();
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

  /// Execute a parallel API test
  static Future<StressTestSummary> runTest(StressTestConfig config) async {
    final totalStopwatch = Stopwatch()..start();
    final List<ApiRequestResult> results = [];

    if (config.useIsolates) {
      final isolates = <Isolate>[];
      final receivePorts = <ReceivePort>[];
      final sendPorts = <SendPort>[];
      final completers = <Completer<ApiRequestResult>>[];

      try {
        for (var i = 0; i < config.concurrentRequests; i++) {
          final receivePort = ReceivePort();
          final completer = Completer<ApiRequestResult>();
          
          final isolate = await Isolate.spawn(
            _isolateWorker, 
            receivePort.sendPort,
            errorsAreFatal: false,
            onExit: receivePort.sendPort,
            onError: receivePort.sendPort,
          );
          
          isolates.add(isolate);
          receivePorts.add(receivePort);
          completers.add(completer);
          
          receivePort.listen((message) {
            if (message is SendPort) {
              sendPorts.add(message);
              if (sendPorts.length == config.concurrentRequests) {
                for (var j = 0; j < config.concurrentRequests; j++) {
                  sendPorts[j].send(IsolateMessage(
                    url: config.url,
                    method: config.method,
                    headers: config.headers,
                    body: config.body,
                    timeout: config.timeout,
                  ));
                }
              }
            } else if (message is ApiRequestResult) {
              if (!completer.isCompleted) {
                completer.complete(message);
              }
            } else if (message is List && message.length >= 2) {
              if (!completer.isCompleted) {
                completer.complete(ApiRequestResult(
                  statusCode: -1,
                  body: '',
                  duration: Duration.zero,
                  error: 'Isolate error: ${message[0]}',
                ));
              }
            }
          });
        }

        for (var completer in completers) {
          try {
            final result = await completer.future.timeout(
              (config.timeout ?? const Duration(seconds: 30)) + const Duration(seconds: 10)
            );
            results.add(result);
          } on TimeoutException {
            results.add(ApiRequestResult(
              statusCode: -1,
              body: '',
              duration: Duration.zero,
              error: 'Isolate communication timed out',
            ));
          }
        }
      } finally {
        for (var i = 0; i < isolates.length; i++) {
          try {
            if (sendPorts.length > i) {
              sendPorts[i].send('close');
            }
            isolates[i].kill(priority: Isolate.immediate);
          } catch (_) { /*We need to ignore once termination is done*/ }
        }
        
        for (var port in receivePorts) {
          port.close();
        }
      }
    } else {
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
      
      try {
        final overallTimeout = (config.timeout ?? const Duration(seconds: 30)) + const Duration(seconds: 10);
        final futureResults = await Future.wait(futures).timeout(overallTimeout);
        results.addAll(futureResults);
      } on TimeoutException {
        final completedResults = results.length;
        final remainingCount = config.concurrentRequests - completedResults;
        
        for (int i = 0; i < remainingCount; i++) {
          results.add(ApiRequestResult(
            statusCode: -1,
            body: '',
            duration: Duration.zero,
            error: 'Operation timed out',
          ));
        }
      }
    }

    totalStopwatch.stop();

    final successCount = results.where((r) => 
      r.statusCode >= 200 && r.statusCode < 300 && r.error == null
    ).length;
    
    final failureCount = results.length - successCount;
    
    final validResults = results.where((r) => r.error == null);
    final totalResponseTime = validResults.fold<int>(
      0, 
      (prev, result) => prev + result.duration.inMicroseconds
    );
    
    final avgResponseTime = validResults.isEmpty 
      ? 0.0 
      : totalResponseTime / validResults.length / 1000;

    return StressTestSummary(
      results: results,
      totalDuration: totalStopwatch.elapsed,
      avgResponseTime: avgResponseTime,
      successCount: successCount,
      failureCount: failureCount,
    );
  }
}
