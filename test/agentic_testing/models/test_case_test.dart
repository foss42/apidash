import 'package:apidash/agentic_testing/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TestCase', () {
    const expectation = TestExpectation(expectedStatus: 200);

    test('constructs with defaults', () {
      const tc = TestCase(
        id: 'tc-1',
        name: 'Valid Request',
        description: 'Baseline happy path',
        source: TestSource.rule,
        expectation: expectation,
      );

      expect(tc.enabled, isTrue);
      expect(tc.tags, isEmpty);
      expect(tc.requestPatch, isEmpty);
    });

    test('copyWith updates selected fields', () {
      const tc = TestCase(
        id: 'tc-1',
        name: 'Valid Request',
        description: 'Baseline happy path',
        source: TestSource.rule,
        expectation: expectation,
      );

      final updated = tc.copyWith(
        name: 'Missing Auth',
        enabled: false,
        tags: const ['security'],
      );

      expect(updated.name, 'Missing Auth');
      expect(updated.enabled, isFalse);
      expect(updated.tags, ['security']);
      expect(updated.source, TestSource.rule);
    });

    test('toJson and fromJson roundtrip', () {
      const tc = TestCase(
        id: 'tc-2',
        name: 'Malformed JSON',
        description: 'Invalid request body payload',
        source: TestSource.memory,
        expectation: TestExpectation(
          expectedStatus: 400,
          mustContainBodyTexts: ['error'],
        ),
        tags: ['negative', 'json'],
        requestPatch: {
          'body': '{"x":',
          'headers.content-type': 'application/json',
        },
      );

      final json = tc.toJson();
      final decoded = TestCase.fromJson(json);

      expect(decoded, tc);
    });

    test('fromJson falls back source to rule when unknown', () {
      final decoded = TestCase.fromJson({
        'id': 'tc-3',
        'name': 'Fallback Source',
        'description': 'Unknown source in payload',
        'source': 'unknown',
        'expectation': {'expectedStatus': 200},
      });

      expect(decoded.source, TestSource.rule);
    });
  });
}