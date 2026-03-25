import 'models.dart';

class TestResult {
  final String testCaseId;
  final TestStatus status;
  final int? actualStatus;
  final int? durationMs;
  final String? error;
  final List<String> trace;
  final DateTime executedAt;

  const TestResult({
    required this.testCaseId,
    required this.status,
    this.actualStatus,
    this.durationMs,
    this.error,
    this.trace = const [],
    required this.executedAt,
  });

  TestResult copyWith({
    String? testCaseId,
    TestStatus? status,
    int? actualStatus,
    int? durationMs,
    String? error,
    List<String>? trace,
    DateTime? executedAt,
  }) {
    return TestResult(
      testCaseId: testCaseId ?? this.testCaseId,
      status: status ?? this.status,
      actualStatus: actualStatus ?? this.actualStatus,
      durationMs: durationMs ?? this.durationMs,
      error: error ?? this.error,
      trace: trace ?? this.trace,
      executedAt: executedAt ?? this.executedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'testCaseId': testCaseId,
      'status': status.name,
      'actualStatus': actualStatus,
      'durationMs': durationMs,
      'error': error,
      'trace': trace,
      'executedAt': executedAt.toUtc().toIso8601String(),
    };
  }

  factory TestResult.fromJson(Map<String, dynamic> json) {
    return TestResult(
      testCaseId: json['testCaseId'] as String,
      status: _statusFromString(json['status'] as String?),
      actualStatus: json['actualStatus'] as int?,
      durationMs: json['durationMs'] as int?,
      error: json['error'] as String?,
      trace: (json['trace'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      executedAt: DateTime.parse(
        (json['executedAt'] as String?) ??
            DateTime.fromMillisecondsSinceEpoch(0, isUtc: true)
                .toIso8601String(),
      ).toUtc(),
    );
  }

  static TestStatus _statusFromString(String? value) {
    return TestStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TestStatus.pending,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TestResult &&
        other.testCaseId == testCaseId &&
        other.status == status &&
        other.actualStatus == actualStatus &&
        other.durationMs == durationMs &&
        other.error == error &&
        _listEquals(other.trace, trace) &&
        other.executedAt.toUtc() == executedAt.toUtc();
  }

  @override
  int get hashCode {
    return Object.hash(
      testCaseId,
      status,
      actualStatus,
      durationMs,
      error,
      Object.hashAll(trace),
      executedAt.toUtc(),
    );
  }

  static bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}