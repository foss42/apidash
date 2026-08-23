import 'package:apidash/utils/json_watch_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('extractJsonWatchValue', () {
    test('recursively finds a plain key', () {
      final result = extractJsonWatchValue(
        '{"ticker":{"price":42.5}}',
        'price',
      );

      expect(result.found, isTrue);
      expect(result.value, 42.5);
      expect(result.error, isNull);
    });

    test('evaluates dot and array-index JSONPath selectors', () {
      final result = extractJsonWatchValue(
        '{"items":[{"price":10},{"price":20}]}',
        r'$.items[1].price',
      );

      expect(result.found, isTrue);
      expect(result.value, 20);
    });

    test('evaluates quoted bracket keys', () {
      final result = extractJsonWatchValue(
        '{"market data":{"last-price":99}}',
        r"$['market data']['last-price']",
      );

      expect(result.value, 99);
    });

    test('returns every wildcard match', () {
      final result = extractJsonWatchValue(
        '{"items":[{"price":10},{"price":20}]}',
        r'$.items[*].price',
      );

      expect(result.value, [10, 20]);
      expect(result.displayValue, '[10,20]');
    });

    test('evaluates recursive child selectors', () {
      final result = extractJsonWatchValue(
        '{"price":1,"nested":{"price":2}}',
        r'$..price',
      );

      expect(result.value, [1, 2]);
    });

    test('distinguishes JSON null from a missing match', () {
      final nullResult = extractJsonWatchValue('{"price":null}', 'price');
      final missingResult = extractJsonWatchValue('{"other":1}', 'price');

      expect(nullResult.found, isTrue);
      expect(nullResult.displayValue, 'null');
      expect(missingResult.found, isFalse);
      expect(missingResult.error, isNull);
    });

    test('reports invalid JSON without throwing', () {
      final result = extractJsonWatchValue('not-json', 'price');

      expect(result.found, isFalse);
      expect(result.error, 'Message is not valid JSON');
    });

    test('reports invalid JSONPath without throwing', () {
      final result = extractJsonWatchValue('{"price":1}', r'$.items[');

      expect(result.found, isFalse);
      expect(result.error, 'Missing closing "]"');
    });
  });

  group('validateJsonWatchExpression', () {
    test('accepts plain keys and supported JSONPath forms', () {
      expect(validateJsonWatchExpression('price'), isNull);
      expect(validateJsonWatchExpression(r'$.items[*].price'), isNull);
    });

    test('rejects empty expressions', () {
      expect(validateJsonWatchExpression('  '), 'Enter a key or JSONPath');
    });
  });
}
