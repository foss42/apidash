import 'package:flutter_test/flutter_test.dart';
import 'package:hurl_parser/src/grammar/base_grammar.dart';
import 'package:petitparser/petitparser.dart';

void main() {
  final hurl = HurlGrammar();

  group('Value String Components', () {
    test('Plain Text', () {
      final parser = hurl.buildFrom(hurl.valueStringText()).end();
      final result = parser.parse('simple text');
      expect(result is Success, isTrue);
    });

    test('URL', () {
      final parser = hurl.buildFrom(hurl.valueStringText()).end();
      final result = parser.parse('http://example.com');
      expect(result is Success, isTrue);
    });
  });

  group('Complete Value String', () {
    final parser = hurl.buildFrom(hurl.valueString()).end();

    test('Simple String', () {
      final result = parser.parse('hello world');
      expect(result is Success, isTrue);
    });

    test('URL String', () {
      final result = parser.parse('http://example.com');
      expect(result is Success, isTrue);
    });

    test('String with Template', () {
      final result = parser.parse('prefix{{variable}}suffix');
      expect(result is Success, isTrue);
    });

    test('String with Escaped Characters', () {
      final result = parser.parse('hello\\nworld');
      expect(result is Success, isTrue);
    });

  });
}
