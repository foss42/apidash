// DashAssert – Assertion Model
// Part of the AI-Powered Response Assertion Engine for API Dash
// Relates to GSoC 2026 Idea #4: Agentic API Testing

/// The type of assertion to perform on an API response.
enum AssertionType {
  statusCode,
  jsonFieldExists,
  jsonFieldValue,
  responseTimeUnder,
  headerExists,
  headerValue,
  bodyContains;

  String get label {
    switch (this) {
      case AssertionType.statusCode:
        return 'Status Code';
      case AssertionType.jsonFieldExists:
        return 'JSON Field Exists';
      case AssertionType.jsonFieldValue:
        return 'JSON Field Value';
      case AssertionType.responseTimeUnder:
        return 'Response Time Under (ms)';
      case AssertionType.headerExists:
        return 'Header Exists';
      case AssertionType.headerValue:
        return 'Header Value';
      case AssertionType.bodyContains:
        return 'Body Contains';
    }
  }

  bool get requiresJsonPath =>
      this == AssertionType.jsonFieldExists ||
      this == AssertionType.jsonFieldValue;

  static AssertionType fromString(String value) {
    return AssertionType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AssertionType.statusCode,
    );
  }
}

/// Result of running an assertion.
enum AssertionStatus {
  pending,
  pass,
  fail,
  error;

  static AssertionStatus fromString(String value) {
    return AssertionStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AssertionStatus.pending,
    );
  }
}

/// A single assertion rule that can be evaluated against an API response.
class AssertionRule {
  final String id;
  final AssertionType type;
  final String description;

  /// The value to check against (status code, field value, header name, etc.)
  final dynamic expectedValue;

  /// Dot-notation JSON path for JSON field assertions, e.g. "user.address.city"
  final String? jsonPath;

  /// Result status after execution.
  final AssertionStatus status;

  /// The actual value found during execution (populated on failure or pass).
  final String? actualValue;

  /// Error message if status is [AssertionStatus.error].
  final String? errorMessage;

  const AssertionRule({
    required this.id,
    required this.type,
    required this.description,
    this.expectedValue,
    this.jsonPath,
    this.status = AssertionStatus.pending,
    this.actualValue,
    this.errorMessage,
  });

  AssertionRule copyWith({
    String? id,
    AssertionType? type,
    String? description,
    dynamic expectedValue,
    Object? jsonPath = _sentinel,
    AssertionStatus? status,
    Object? actualValue = _sentinel,
    Object? errorMessage = _sentinel,
  }) {
    return AssertionRule(
      id: id ?? this.id,
      type: type ?? this.type,
      description: description ?? this.description,
      expectedValue: expectedValue ?? this.expectedValue,
      jsonPath: jsonPath == _sentinel ? this.jsonPath : jsonPath as String?,
      status: status ?? this.status,
      actualValue: actualValue == _sentinel
          ? this.actualValue
          : actualValue as String?,
      errorMessage: errorMessage == _sentinel
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'description': description,
      'expectedValue': expectedValue,
      'jsonPath': jsonPath,
      'status': status.name,
      'actualValue': actualValue,
      'errorMessage': errorMessage,
    };
  }

  factory AssertionRule.fromJson(Map<String, dynamic> json) {
    return AssertionRule(
      id: json['id'] as String,
      type: AssertionType.fromString(json['type'] as String? ?? ''),
      description: json['description'] as String? ?? '',
      expectedValue: json['expectedValue'],
      jsonPath: json['jsonPath'] as String?,
      status: AssertionStatus.fromString(json['status'] as String? ?? ''),
      actualValue: json['actualValue'] as String?,
      errorMessage: json['errorMessage'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssertionRule &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// Sentinel for nullable copyWith parameters
const _sentinel = Object();

/// A collection of assertion rules for a single API request.
class AssertionSuite {
  final String id;

  /// Links to the [RequestModel] id.
  final String requestId;

  final String name;
  final List<AssertionRule> rules;
  final DateTime? lastRunAt;

  const AssertionSuite({
    required this.id,
    required this.requestId,
    this.name = 'Assertions',
    this.rules = const [],
    this.lastRunAt,
  });

  int get passCount =>
      rules.where((r) => r.status == AssertionStatus.pass).length;
  int get failCount =>
      rules.where((r) => r.status == AssertionStatus.fail).length;
  int get errorCount =>
      rules.where((r) => r.status == AssertionStatus.error).length;
  int get pendingCount =>
      rules.where((r) => r.status == AssertionStatus.pending).length;

  bool get hasBeenRun => lastRunAt != null;
  bool get allPassed => hasBeenRun && failCount == 0 && errorCount == 0;

  AssertionSuite copyWith({
    String? id,
    String? requestId,
    String? name,
    List<AssertionRule>? rules,
    Object? lastRunAt = _sentinel,
  }) {
    return AssertionSuite(
      id: id ?? this.id,
      requestId: requestId ?? this.requestId,
      name: name ?? this.name,
      rules: rules ?? this.rules,
      lastRunAt: lastRunAt == _sentinel
          ? this.lastRunAt
          : lastRunAt as DateTime?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'requestId': requestId,
      'name': name,
      'rules': rules.map((r) => r.toJson()).toList(),
      'lastRunAt': lastRunAt?.toIso8601String(),
    };
  }

  factory AssertionSuite.fromJson(Map<String, dynamic> json) {
    return AssertionSuite(
      id: json['id'] as String,
      requestId: json['requestId'] as String,
      name: json['name'] as String? ?? 'Assertions',
      rules: (json['rules'] as List<dynamic>? ?? [])
          .map((r) => AssertionRule.fromJson(r as Map<String, dynamic>))
          .toList(),
      lastRunAt: json['lastRunAt'] != null
          ? DateTime.tryParse(json['lastRunAt'] as String)
          : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssertionSuite &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
