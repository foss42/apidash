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
  group('JSONPath edge cases', () {
    test('root selector preserves objects, arrays and scalar values', () {
      for (final payload in [
        '{"price":1}',
        '[1,2]',
        'null',
        'false',
        '0',
        '"text"',
      ]) {
        final result = extractJsonWatchValue(payload, r'$');
        expect(result.found, isTrue);
        expect(result.error, isNull);
      }
    });

    test('wildcard searches object values as well as arrays', () {
      expect(
        extractJsonWatchValue(
          '{"a":{"price":1},"b":{"price":2}}',
          r'$[*].price',
        ).value,
        [1, 2],
      );
    });

    test('plain key searches nested arrays in document order', () {
      expect(
        extractJsonWatchValue(
          '{"price":0,"items":[{"price":1},{"nested":{"price":2}}]}',
          'price',
        ).value,
        [0, 1, 2],
      );
    });

    test('distinguishes missing, null, false, zero and empty string', () {
      final expression = JsonWatchExpression.parse('price');
      for (final value in ['null', 'false', '0', '""', '[]', '{}']) {
        expect(expression.extract('{"price":$value}').found, isTrue);
      }
      expect(expression.extract('{"other":1}').found, isFalse);
    });

    test('handles quoted keys with punctuation and escaped characters', () {
      expect(extractJsonWatchValue('{"a.b[0]":3}', r"$['a.b[0]']").value, 3);
      expect(extractJsonWatchValue("{\"it's\":4}", r"$['it\'s']").value, 4);
      expect(extractJsonWatchValue(r'{"a\\b":5}', r"$['a\\b']").value, 5);
      expect(extractJsonWatchValue('{"price":6}', r"$['\u0070rice']").value, 6);
      expect(extractJsonWatchValue(r'{"a\"b":7}', r'''$['a"b']''').value, 7);
    });

    test('out-of-range indexes and wrong container types are non-matches', () {
      expect(
        extractJsonWatchValue('{"items":[1]}', r'$.items[8]').found,
        isFalse,
      );
      expect(
        extractJsonWatchValue('{"items":null}', r'$.items[0]').found,
        isFalse,
      );
      expect(extractJsonWatchValue('[1,2]', r'$.price').found, isFalse);
    });

    test(
      'compiled expressions can be reused and trim surrounding whitespace',
      () {
        final expression = JsonWatchExpression.parse(r'  $.price  ');
        expect(expression.source, r'$.price');
        expect(expression.extract('{"price":1}').value, 1);
        expect(expression.extract('{"price":2}').value, 2);
      },
    );

    for (final path in [
      r'$.',
      r'$..',
      r'$...price',
      r'$price',
      r'$[0]price',
      r'$.a[0]b',
      r'$[01]',
      r'$[-1]',
      r'$[1:2]',
      r'$[0,1]',
      r'$[?(@.price)]',
      r'$["a" "b"]',
      r"$['a'b']",
      r"$['a\q']",
      r'$[999999999999999999999999999999]',
      'ticker.price',
    ]) {
      test('rejects unsupported or malformed path $path', () {
        expect(validateJsonWatchExpression(path), isNotNull);
        expect(extractJsonWatchValue('{"price":1}', path).found, isFalse);
      });
    }
  });
}
