// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stress_test_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StressTestSummaryImpl _$$StressTestSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$StressTestSummaryImpl(
      results: (json['results'] as List<dynamic>)
          .map((e) => ApiRequestResult.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalDuration:
          Duration(microseconds: (json['totalDuration'] as num).toInt()),
      avgResponseTime: (json['avgResponseTime'] as num).toDouble(),
      successCount: (json['successCount'] as num).toInt(),
      failureCount: (json['failureCount'] as num).toInt(),
    );

Map<String, dynamic> _$$StressTestSummaryImplToJson(
        _$StressTestSummaryImpl instance) =>
    <String, dynamic>{
      'results': instance.results,
      'totalDuration': instance.totalDuration.inMicroseconds,
      'avgResponseTime': instance.avgResponseTime,
      'successCount': instance.successCount,
      'failureCount': instance.failureCount,
    };
