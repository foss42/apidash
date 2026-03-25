import 'package:apidash/agentic_testing/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TestSuite', () {
    final baseTime = DateTime.utc(2026, 1, 1, 12, 0, 0);

    test('constructs with defaults', () {
      final suite = TestSuite(
        id: 'suite-1',
        endpointHash: 'hash-abc',
        method: 'POST',
        url: 'https://api.example.com/users',
        createdAt: baseTime,
      );

      expect(suite.testCases, isEmpty);
    });

    test('copyWith updates selected fields', () {
      final suite = TestSuite(
        id: 'suite-1',
        endpointHash: 'hash-abc',
        method: 'POST',
        url: 'https://api.example.com/users',
        createdAt: baseTime,
      );

      final updated = suite.copyWith(method: 'PUT');

      expect(updated.method, 'PUT');
      expect(updated.id, 'suite-1');
    });

    test('toJson and fromJson roundtrip', () {
      const testCase = TestCase(
        id: 'tc-1',
        name: 'Valid Request',
        description: 'Happy path',
        source: TestSource.rule,
        expectation: TestExpectation(expectedStatus: 200),
      );

      final suite = TestSuite(
        id: 'suite-2',
        endpointHash: 'hash-xyz',
        method: 'GET',
        url: 'https://api.example.com/health',
        testCases: const [testCase],
        createdAt: baseTime,
      );

      final json = suite.toJson();
      final decoded = TestSuite.fromJson(json);

      expect(decoded, suite);
    });
  });
}