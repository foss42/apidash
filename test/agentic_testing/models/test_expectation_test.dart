import 'package:apidash/agentic_testing/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TestExpectation', () {
    test('constructs with defaults', () {
      const expectation = TestExpectation();
      expect(expectation.expectedStatus, isNull);
      expect(expectation.maxLatencyMs, isNull);
      expect(expectation.mustContainBodyTexts, isEmpty);
      expect(expectation.requiredHeaders, isEmpty);
    });

    test('copyWith updates selected fields', () {
      const base = TestExpectation(
        expectedStatus: 200,
        maxLatencyMs: 500,
        mustContainBodyTexts: ['ok'],
        requiredHeaders: ['content-type'],
      );

      final updated = base.copyWith(maxLatencyMs: 300);

      expect(updated.expectedStatus, 200);
      expect(updated.maxLatencyMs, 300);
      expect(updated.mustContainBodyTexts, ['ok']);
      expect(updated.requiredHeaders, ['content-type']);
    });

    test('toJson and fromJson roundtrip', () {
      const expectation = TestExpectation(
        expectedStatus: 201,
        maxLatencyMs: 800,
        mustContainBodyTexts: ['created', 'id'],
        requiredHeaders: ['location'],
      );

      final json = expectation.toJson();
      final decoded = TestExpectation.fromJson(json);

      expect(decoded, expectation);
    });

    test('fromJson handles missing list fields', () {
      final decoded = TestExpectation.fromJson(const {
        'expectedStatus': 400,
      });

      expect(decoded.expectedStatus, 400);
      expect(decoded.mustContainBodyTexts, isEmpty);
      expect(decoded.requiredHeaders, isEmpty);
    });
  });
}