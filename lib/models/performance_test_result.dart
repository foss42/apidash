import 'package:json_annotation/json_annotation.dart';

part 'performance_test_result.g.dart';

@JsonSerializable()
class PerformanceTestResult {
  final int totalRequests;
  final double requestsPerSecond;
  final double avgResponseTime;
  final double minResponseTime;
  final double maxResponseTime;
  final double errorRate;
  final DateTime timestamp;

  PerformanceTestResult({
    required this.totalRequests,
    required this.requestsPerSecond,
    required this.avgResponseTime,
    required this.minResponseTime,
    required this.maxResponseTime,
    required this.errorRate,
    required this.timestamp,
  });

  factory PerformanceTestResult.fromJson(Map<String, dynamic> json) =>
      _$PerformanceTestResultFromJson(json);

  Map<String, dynamic> toJson() => _$PerformanceTestResultToJson(this);
}