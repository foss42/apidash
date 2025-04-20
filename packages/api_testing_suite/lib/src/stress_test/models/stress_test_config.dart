import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:apidash_core/apidash_core.dart';

part 'stress_test_config.freezed.dart';
part 'stress_test_config.g.dart';

@freezed
class StressTestConfig with _$StressTestConfig {

  const factory StressTestConfig({
    @JsonKey(name: 'url') String? url,
    @JsonKey(name: 'method') String? method,
    @JsonKey(name: 'headers') Map<String, String>? headers,
    @JsonKey(name: 'body') dynamic body,
    @JsonKey(name: 'requestUrl') String? requestUrl,
    @JsonKey(name: 'requestMethod') String? requestMethod,
    @JsonKey(name: 'requestHeaders') Map<String, String>? requestHeaders,
    @JsonKey(name: 'requestBody') dynamic requestBody,
    required int concurrentRequests,
    Duration? timeout,
    @Default(false) bool useIsolates,
  }) = _StressTestConfig;






  factory StressTestConfig.fromJson(Map<String, Object?> json) => _$StressTestConfigFromJson(json);
}

extension StressTestConfigCompat on StressTestConfig {
  String? get requestUrl => (this as dynamic).requestUrl ?? (this as dynamic).url;
  String? get requestMethod => (this as dynamic).requestMethod ?? (this as dynamic).method;
  Map<String, String>? get requestHeaders => (this as dynamic).requestHeaders ?? (this as dynamic).headers;
  dynamic get requestBody => (this as dynamic).requestBody ?? (this as dynamic).body;

  String get resolvedUrl => requestUrl ?? '';
  String get resolvedMethod => requestMethod ?? '';
  Map<String, String>? get resolvedHeaders => requestHeaders;
  dynamic get resolvedBody => requestBody;
}


