import 'dart:async';
import 'dart:isolate';
import 'package:api_testing_suite/src/common/utils/logger.dart';
import '../models/api_request_result.dart';
import '../models/stress_test_config.dart';
import '../models/stress_test_summary.dart';
import '../models/isolate_message.dart';
import 'stress_test_constants.dart';
import 'request_executor.dart';
import 'isolate_worker.dart';

/// Service responsible for executing stress tests on API endpoints
class StressTestService {
  /// Run a stress test according to the provided configuration
  /// 
  /// This method will execute concurrent API requests according to the configuration
  /// and return a summary of the results.
  static Future<StressTestSummary> runTest(StressTestConfig config) async {
    final totalStopwatch = Stopwatch()..start();
    final List<ApiRequestResult> results = [];

    ApiTestLogger.info('Starting stress test with ${config.concurrentRequests} concurrent requests');
    ApiTestLogger.debug('Using isolates: ${config.useIsolates}');

    if (config.useIsolates) {
      await _runIsolateTest(config, results);
    } else {
      await _runDirectTest(config, results);
    }

    totalStopwatch.stop();
    
    final successCount = _calculateSuccessCount(results);
    final failureCount = results.length - successCount;
    final avgResponseTime = _calculateAverageResponseTime(results);

    ApiTestLogger.info('Stress test completed in ${totalStopwatch.elapsed.inMilliseconds}ms');
    ApiTestLogger.info('Success: $successCount, Failures: $failureCount');

    return StressTestSummary(
      results: results,
      totalDuration: totalStopwatch.elapsed,
      avgResponseTime: avgResponseTime,
      successCount: successCount,
      failureCount: failureCount,
    );
  }

  static Future<void> _runIsolateTest(StressTestConfig config, List<ApiRequestResult> results) async {
    final isolates = <Isolate>[];
    final sendPorts = <SendPort>[];
    final completers = <Completer<ApiRequestResult>>[];
    final mainReceivePort = ReceivePort();
    int sendPortCount = 0;
    int resultCount = 0;
    
    try {
      for (var i = 0; i < config.concurrentRequests; i++) {
        final completer = Completer<ApiRequestResult>();
        completers.add(completer);
        
        final isolate = await Isolate.spawn(
          IsolateWorker.worker,
          mainReceivePort.sendPort,
          errorsAreFatal: false,
        );
        
        isolates.add(isolate);
      }

      mainReceivePort.listen((message) {
        if (message is SendPort) {
          sendPorts.add(message);
          sendPortCount++;
          
          if (sendPortCount == config.concurrentRequests) {
            _dispatchIsolateRequests(config, sendPorts);
          }
        } else if (message is ApiRequestResult) {
          if (resultCount < completers.length && !completers[resultCount].isCompleted) {
            completers[resultCount].complete(message);
            resultCount++;
          }
        } else if (message is List && message.length >= 2) {
          if (resultCount < completers.length && !completers[resultCount].isCompleted) {
            completers[resultCount].complete(_createErrorResult(
              '${StressTestConstants.isolateErrorMessage}: ${message[0]}'
            ));
            resultCount++;
          }
        }
      });

      for (var completer in completers) {
        try {
          final timeout = (config.timeout ?? StressTestConstants.defaultTimeout) + 
                          StressTestConstants.isolateCommunicationTimeout;
          
          final result = await completer.future.timeout(timeout);
          results.add(result);
        } on TimeoutException {
          results.add(_createErrorResult(StressTestConstants.isolateTimeoutErrorMessage));
        }
      }
    } finally {
      _cleanupIsolates(isolates, sendPorts);
      mainReceivePort.close();
    }
  }

  static void _dispatchIsolateRequests(
    StressTestConfig config, 
    List<SendPort> sendPorts
  ) {
    for (var j = 0; j < config.concurrentRequests; j++) {
      sendPorts[j].send(IsolateMessage(
        url: config.resolvedUrl,
        method: config.resolvedMethod,
        headers: config.resolvedHeaders,
        body: config.resolvedBody,
        timeout: config.timeout,
      ));
    }
  }

  static void _cleanupIsolates(List<Isolate> isolates, List<SendPort> sendPorts) {
    for (var i = 0; i < isolates.length; i++) {
      try {
        if (sendPorts.length > i) {
          sendPorts[i].send('close');
        }
        isolates[i].kill(priority: Isolate.immediate);
      } catch (e) {
        ApiTestLogger.debug('Error during isolate cleanup: $e');
      }
    }
  }

  static Future<void> _runDirectTest(StressTestConfig config, List<ApiRequestResult> results) async {
    final futures = <Future<ApiRequestResult>>[];
    
    for (int i = 0; i < config.concurrentRequests; i++) {
      futures.add(RequestExecutor.execute(
        url: config.resolvedUrl,
        method: config.resolvedMethod,
        headers: config.resolvedHeaders,
        body: config.resolvedBody,
        timeout: config.timeout,
      ));
    }
    
    try {
      final overallTimeout = (config.timeout ?? StressTestConstants.defaultTimeout) + 
                             StressTestConstants.gracePeriodTimeout;
      
      final futureResults = await Future.wait(futures).timeout(overallTimeout);
      results.addAll(futureResults);
    } on TimeoutException {
      final completedResults = results.length;
      final remainingCount = config.concurrentRequests - completedResults;
      
      ApiTestLogger.warning('Timeout occurred while waiting for results. ' +
                      'Completed: $completedResults, Remaining: $remainingCount');
      
      for (int i = 0; i < remainingCount; i++) {
        results.add(_createErrorResult(StressTestConstants.timeoutErrorMessage));
      }
    }
  }

  static int _calculateSuccessCount(List<ApiRequestResult> results) {
    return results.where((r) => 
      r.statusCode >= StressTestConstants.successMinStatusCode && 
      r.statusCode <= StressTestConstants.successMaxStatusCode && 
      r.error == null
    ).length;
  }

  static double _calculateAverageResponseTime(List<ApiRequestResult> results) {
    final validResults = results.where((r) => r.error == null);
    
    if (validResults.isEmpty) {
      return 0.0;
    }
    
    final totalResponseTime = validResults.fold<int>(
      0, 
      (prev, result) => prev + result.duration.inMicroseconds
    );
    
    return totalResponseTime / validResults.length / StressTestConstants.microsToMillisConversion;
  }

  static ApiRequestResult _createErrorResult(String error) {
    return ApiRequestResult(
      statusCode: StressTestConstants.errorStatusCode,
      body: '',
      duration: Duration.zero,
      error: error,
    );
  }
}
