enum TestReviewDecision { pending, approved, rejected }

extension TestReviewDecisionLabel on TestReviewDecision {
  String get label {
    switch (this) {
      case TestReviewDecision.pending:
        return 'Pending';
      case TestReviewDecision.approved:
        return 'Approved';
      case TestReviewDecision.rejected:
        return 'Rejected';
    }
  }
}

class AgenticTestCase {
  const AgenticTestCase({
    required this.id,
    required this.title,
    required this.description,
    required this.method,
    required this.endpoint,
    required this.expectedOutcome,
    required this.assertions,
    this.confidence,
    this.decision = TestReviewDecision.pending,
  });

  final String id;
  final String title;
  final String description;
  final String method;
  final String endpoint;
  final String expectedOutcome;
  final List<String> assertions;
  final double? confidence;
  final TestReviewDecision decision;

  AgenticTestCase copyWith({
    String? id,
    String? title,
    String? description,
    String? method,
    String? endpoint,
    String? expectedOutcome,
    List<String>? assertions,
    double? confidence,
    TestReviewDecision? decision,
  }) {
    return AgenticTestCase(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      method: method ?? this.method,
      endpoint: endpoint ?? this.endpoint,
      expectedOutcome: expectedOutcome ?? this.expectedOutcome,
      assertions: assertions ?? this.assertions,
      confidence: confidence ?? this.confidence,
      decision: decision ?? this.decision,
    );
  }

  factory AgenticTestCase.fromJson(
    Map<String, dynamic> json, {
    required String fallbackId,
    required String fallbackEndpoint,
    required String fallbackMethod,
  }) {
    final assertionsRaw = json['assertions'];
    final assertions = assertionsRaw is List
        ? assertionsRaw
              .map((item) => item.toString().trim())
              .where((item) => item.isNotEmpty)
              .toList()
        : const <String>[];

    return AgenticTestCase(
      id: (json['id'] as String?)?.trim().isNotEmpty == true
          ? (json['id'] as String).trim()
          : fallbackId,
      title: (json['title'] as String?)?.trim().isNotEmpty == true
          ? (json['title'] as String).trim()
          : 'Generated test case',
      description: (json['description'] as String?)?.trim().isNotEmpty == true
          ? (json['description'] as String).trim()
          : 'No description provided.',
      method: (json['method'] as String?)?.trim().isNotEmpty == true
          ? (json['method'] as String).trim().toUpperCase()
          : fallbackMethod.toUpperCase(),
      endpoint: (json['endpoint'] as String?)?.trim().isNotEmpty == true
          ? (json['endpoint'] as String).trim()
          : fallbackEndpoint,
      expectedOutcome:
          (json['expected_outcome'] as String?)?.trim().isNotEmpty == true
          ? (json['expected_outcome'] as String).trim()
          : (json['expectedOutcome'] as String?)?.trim().isNotEmpty == true
              ? (json['expectedOutcome'] as String).trim()
              : 'Request behaves as expected.',
      assertions: assertions,
      confidence: _parseConfidence(json['confidence']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'method': method,
      'endpoint': endpoint,
      'expected_outcome': expectedOutcome,
      'assertions': assertions,
      'confidence': confidence,
      'decision': decision.name,
    };
  }

  static double? _parseConfidence(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      final parsed = double.tryParse(value.trim());
      if (parsed != null) {
        return parsed;
      }
    }
    return null;
  }
}
