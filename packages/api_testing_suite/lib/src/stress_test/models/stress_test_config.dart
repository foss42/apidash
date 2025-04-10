import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:apidash_core/apidash_core.dart';

part 'stress_test_config.freezed.dart';
part 'stress_test_config.g.dart';

@freezed
class StressTestConfig with _$StressTestConfig {
  const factory StressTestConfig({
    required String url,
    required String method,
    Map<String, String>? headers,
    dynamic body,
    required int concurrentRequests,
    Duration? timeout,
    @Default(false) bool useIsolates,
  }) = _StressTestConfig;

  factory StressTestConfig.fromJson(Map<String, Object?> json) => _$StressTestConfigFromJson(json);
}
