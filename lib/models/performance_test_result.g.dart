// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'performance_test_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PerformanceTestResult _$PerformanceTestResultFromJson(
        Map<String, dynamic> json) =>
    PerformanceTestResult(
      totalRequests: (json['totalRequests'] as num).toInt(),
      requestsPerSecond: (json['requestsPerSecond'] as num).toDouble(),
      avgResponseTime: (json['avgResponseTime'] as num).toDouble(),
      minResponseTime: (json['minResponseTime'] as num).toDouble(),
      maxResponseTime: (json['maxResponseTime'] as num).toDouble(),
      errorRate: (json['errorRate'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$PerformanceTestResultToJson(
        PerformanceTestResult instance) =>
    <String, dynamic>{
      'totalRequests': instance.totalRequests,
      'requestsPerSecond': instance.requestsPerSecond,
      'avgResponseTime': instance.avgResponseTime,
      'minResponseTime': instance.minResponseTime,
      'maxResponseTime': instance.maxResponseTime,
      'errorRate': instance.errorRate,
      'timestamp': instance.timestamp.toIso8601String(),
    };
