import 'models.dart';

class TestSuite {
  final String id;
  final String endpointHash;
  final String method;
  final String url;
  final List<TestCase> testCases;
  final List<TestResult> results;
  final DateTime createdAt;

  const TestSuite({
    required this.id,
    required this.endpointHash,
    required this.method,
    required this.url,
    this.testCases = const [],
    this.results = const [],
    required this.createdAt,
  });

  TestSuite copyWith({
    String? id,
    String? endpointHash,
    String? method,
    String? url,
    List<TestCase>? testCases,
    List<TestResult>? results,
    DateTime? createdAt,
  }) {
    return TestSuite(
      id: id ?? this.id,
      endpointHash: endpointHash ?? this.endpointHash,
      method: method ?? this.method,
      url: url ?? this.url,
      testCases: testCases ?? this.testCases,
      results: results ?? this.results,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'endpointHash': endpointHash,
      'method': method,
      'url': url,
      'testCases': testCases.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toUtc().toIso8601String(),
    };
  }

  factory TestSuite.fromJson(Map<String, dynamic> json) {
    return TestSuite(
      id: json['id'] as String,
      endpointHash: json['endpointHash'] as String,
      method: json['method'] as String,
      url: json['url'] as String,
      testCases: (json['testCases'] as List<dynamic>? ?? const [])
          .map((e) => TestCase.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String).toUtc(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TestSuite &&
        other.id == id &&
        other.endpointHash == endpointHash &&
        other.method == method &&
        other.url == url &&
        _listEquals(other.testCases, testCases) &&
        other.createdAt.toUtc() == createdAt.toUtc();
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      endpointHash,
      method,
      url,
      Object.hashAll(testCases),
      createdAt.toUtc(),
    );
  }

  static bool _listEquals(List<TestCase> a, List<TestCase> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}