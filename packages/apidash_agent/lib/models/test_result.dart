import 'test_case.dart';

class AssertionResult {
  final String assertionId;
  final bool passed;
  final String message; // e.g. "Expected 401, got 200"
  final bool skipped;

  AssertionResult({
    required this.assertionId,
    required this.passed,
    required this.message,
    this.skipped = false,
  });

  Map<String, dynamic> toJson() => {
        'assertionId': assertionId,
        'passed': passed,
        'message': message,
        'skipped': skipped,
      };
}

class TestResult {
  final TestCase testCase;
  final int? actualStatusCode;
  final String? actualBody;
  final int durationMs;
  final List<AssertionResult> assertionResults;
  final TestStatus overallStatus;
  final String? errorMessage;

  TestResult({
    required this.testCase,
    this.actualStatusCode,
    this.actualBody,
    required this.durationMs,
    required this.assertionResults,
    required this.overallStatus,
    this.errorMessage,
  });

  Map<String, dynamic> toJson() => {
        'testCase': testCase.toJson(),
        'actualStatusCode': actualStatusCode ?? 0,
        'actualBody': actualBody ?? '',
        'durationMs': durationMs,
        'assertionResults': assertionResults.map((r) => r.toJson()).toList(),
        'overallStatus': overallStatus.name,
        if (errorMessage != null) 'errorMessage': errorMessage,
      };
}

