import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:apidash/models/stress_test/api_request_result.dart';

part 'stress_test_summary.freezed.dart';
part 'stress_test_summary.g.dart';

@freezed
class StressTestSummary with _$StressTestSummary {
  const factory StressTestSummary({
    required List<ApiRequestResult> results,
    required Duration totalDuration,
    required double avgResponseTime,
    required int successCount,
    required int failureCount,
  }) = _StressTestSummary;

  factory StressTestSummary.fromJson(Map<String, Object?> json) => _$StressTestSummaryFromJson(json);
}
