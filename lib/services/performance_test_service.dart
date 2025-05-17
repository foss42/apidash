import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/performance_test_result.dart';

class PerformanceTestService {
  Future<List<PerformanceTestResult>> runLoadTest({
    required String url,
    required String method,
    required Map<String, String> headers,
    String? body,
    required int virtualUsers,
    required int durationSeconds,
    required bool rampUp,
    required int rampUpDurationSeconds,
  }) async {
    List<PerformanceTestResult> results = [];
    int completedRequests = 0;
    int failedRequests = 0;
    List<double> responseTimes = [];
    
    DateTime startTime = DateTime.now();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timer.tick >= durationSeconds) {
        timer.cancel();
        return;
      }
      
      int currentUsers = rampUp 
          ? ((timer.tick / rampUpDurationSeconds) * virtualUsers).floor()
          : virtualUsers;
      
      for (int i = 0; i < currentUsers; i++) {
        _makeRequest(
          url: url,
          method: method,
          headers: headers,
          body: body,
        ).then((responseTime) {
          if (responseTime >= 0) {
            completedRequests++;
            responseTimes.add(responseTime);
          } else {
            failedRequests++;
          }
          
          results.add(PerformanceTestResult(
            totalRequests: completedRequests + failedRequests,
            requestsPerSecond: (completedRequests + failedRequests) / timer.tick,
            avgResponseTime: responseTimes.isEmpty 
                ? 0 
                : responseTimes.reduce((a, b) => a + b) / responseTimes.length,
            minResponseTime: responseTimes.isEmpty 
                ? 0 
                : responseTimes.reduce((a, b) => a < b ? a : b),
            maxResponseTime: responseTimes.isEmpty 
                ? 0 
                : responseTimes.reduce((a, b) => a > b ? a : b),
            errorRate: failedRequests / (completedRequests + failedRequests) * 100,
            timestamp: DateTime.now(),
          ));
        });
      }
    });
    
    return results;
  }
  
  Future<double> _makeRequest({
    required String url,
    required String method,
    required Map<String, String> headers,
    String? body,
  }) async {
    try {
      final stopwatch = Stopwatch()..start();
      
      final response = await http.Request(method, Uri.parse(url))
        ..headers.addAll(headers)
        ..body = body ?? '';
        
      await http.Client().send(response);
      
      stopwatch.stop();
      return stopwatch.elapsedMilliseconds.toDouble();
    } catch (e) {
      return -1; // Return negative value to indicate error
    }
  }
} 