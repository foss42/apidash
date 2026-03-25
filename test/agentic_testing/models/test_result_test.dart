import 'package:apidash/agentic_testing/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TestResult', () {
    final baseTime = DateTime.utc(2026, 1, 1, 10, 0, 0);

    test('constructs required fields', () {
      final result = TestResult(
        testCaseId: 'tc-1',
        status: TestStatus.pass,
        executedAt: baseTime,
      );

      expect(result.testCaseId, 'tc-1');
      expect(result.status, TestStatus.pass);
      expect(result.actualStatus, isNull);
      expect(result.trace, isEmpty);
    });

    test('copyWith updates selected fields', () {
      final result = TestResult(
        testCaseId: 'tc-1',
        status: TestStatus.pending,
        executedAt: baseTime,
      );

      final updated = result.copyWith(
        status: TestStatus.fail,
        actualStatus: 500,
        error: 'Internal Server Error',
        durationMs: 220,
        trace: const ['sent request', 'received response'],
      );

      expect(updated.status, TestStatus.fail);
      expect(updated.actualStatus, 500);
      expect(updated.error, 'Internal Server Error');
      expect(updated.durationMs, 220);
      expect(updated.trace.length, 2);
    });

    test('toJson and fromJson roundtrip', () {
      final result = TestResult(
        testCaseId: 'tc-2',
        status: TestStatus.fail,
        actualStatus: 401,
        durationMs: 120,
        error: 'Unauthorized',
        trace: const ['start', 'auth missing'],
        executedAt: baseTime,
      );

      final json = result.toJson();
      final decoded = TestResult.fromJson(json);

      expect(decoded, result);
    });

    test('fromJson falls back status to pending when unknown', () {
      final decoded = TestResult.fromJson({
        'testCaseId': 'tc-3',
        'status': 'unknown-status',
        'executedAt': DateTime.utc(2026, 1, 1).toIso8601String(),
      });

      expect(decoded.status, TestStatus.pending);
    });
  });
}