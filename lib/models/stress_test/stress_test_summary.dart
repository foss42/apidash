import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:apidash/models/stress_test/api_request_result.dart';

part 'stress_test_summary.freezed.dart';
part 'stress_test_summary.g.dart';

@freezed
class StressTestSummary with _$StressTestSummary {
  const StressTestSummary._();

  const factory StressTestSummary({
    required List<ApiRequestResult> results,
    required Duration totalDuration,
    required double avgResponseTime,
    required int successCount,
    required int failureCount,
  }) = _StressTestSummary;

  factory StressTestSummary.fromJson(Map<String, Object?> json) => _$StressTestSummaryFromJson(json);

  double get successRate => results.isEmpty ? 0 : (successCount / results.length) * 100;

  double get failureRate => results.isEmpty ? 0 : (failureCount / results.length) * 100;

  Duration get minResponseTime {
    if (results.isEmpty) return Duration.zero;
    return results.map((r) => r.duration).reduce((a, b) => a < b ? a : b);
  }

  Duration get maxResponseTime {
    if (results.isEmpty) return Duration.zero;
    return results.map((r) => r.duration).reduce((a, b) => a > b ? a : b);
  }

  Duration get medianResponseTime {
    if (results.isEmpty) return Duration.zero;
    final sortedDurations = results.map((r) => r.duration).toList()..sort();
    final middle = sortedDurations.length ~/ 2;
    if (sortedDurations.length.isOdd) {
      return sortedDurations[middle];
    }
    return Duration(microseconds: (
      sortedDurations[middle - 1].inMicroseconds + 
      sortedDurations[middle].inMicroseconds
    ) ~/ 2);
  }
}
