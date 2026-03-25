class TestExpectation {
  final int? expectedStatus;
  final int? maxLatencyMs;
  final List<String> mustContainBodyTexts;
  final List<String> requiredHeaders;

  const TestExpectation({
    this.expectedStatus,
    this.maxLatencyMs,
    this.mustContainBodyTexts = const [],
    this.requiredHeaders = const [],
  });

  TestExpectation copyWith({
    int? expectedStatus,
    int? maxLatencyMs,
    List<String>? mustContainBodyTexts,
    List<String>? requiredHeaders,
  }) {
    return TestExpectation(
      expectedStatus: expectedStatus ?? this.expectedStatus,
      maxLatencyMs: maxLatencyMs ?? this.maxLatencyMs,
      mustContainBodyTexts: mustContainBodyTexts ?? this.mustContainBodyTexts,
      requiredHeaders: requiredHeaders ?? this.requiredHeaders,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'expectedStatus': expectedStatus,
      'maxLatencyMs': maxLatencyMs,
      'mustContainBodyTexts': mustContainBodyTexts,
      'requiredHeaders': requiredHeaders,
    };
  }

  factory TestExpectation.fromJson(Map<String, dynamic> json) {
    return TestExpectation(
      expectedStatus: json['expectedStatus'] as int?,
      maxLatencyMs: json['maxLatencyMs'] as int?,
      mustContainBodyTexts:
          (json['mustContainBodyTexts'] as List<dynamic>? ?? const [])
              .map((e) => e.toString())
              .toList(),
      requiredHeaders: (json['requiredHeaders'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TestExpectation &&
        other.expectedStatus == expectedStatus &&
        other.maxLatencyMs == maxLatencyMs &&
        _listEquals(other.mustContainBodyTexts, mustContainBodyTexts) &&
        _listEquals(other.requiredHeaders, requiredHeaders);
  }

  @override
  int get hashCode {
    return Object.hash(
      expectedStatus,
      maxLatencyMs,
      Object.hashAll(mustContainBodyTexts),
      Object.hashAll(requiredHeaders),
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