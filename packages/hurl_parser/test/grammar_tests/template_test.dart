import 'package:flutter_test/flutter_test.dart';
import 'package:hurl_parser/src/grammar/base_grammar.dart';
import 'package:petitparser/petitparser.dart';

void main() {
  final hurl = HurlGrammar();

  group('Template Parser', () {
    test('Simple Template', () {
      final templateParser = hurl.buildFrom(hurl.template()).end();
      final result = templateParser.parse('{{host}}');
      print('Template result: $result');
      expect(result is Success, isTrue);
    });

    test('Template Variable Name', () {
      final variableParser = hurl.buildFrom(hurl.variableName()).end();
      final result = variableParser.parse('host');
      print('Variable result: $result');
      expect(result is Success, isTrue);
    });
  });

  group('Value String Components', () {
    test('Text Before Template', () {
      final parser = hurl.buildFrom(hurl.valueString()).end();
      final result = parser.parse('http://');
      expect(result is Success, isTrue);
    });

    test('Text After Template', () {
      final parser = hurl.buildFrom(hurl.valueString()).end();
      final result = parser.parse('.com/path');
      expect(result is Success, isTrue);
    });

    test('Escaped Characters', () {
      final parser = hurl.buildFrom(hurl.valueStringEscapedChar()).end();
      final result = parser.parse('\\n');
      expect(result is Success, isTrue);
    });
  });

  group('Progressive Complex String Tests', () {
    final parser = hurl.buildFrom(hurl.valueString()).end();

    test('URL with Template', () {
      final result = parser.parse('http://{{host}}');
      print('URL with template result: $result');
      expect(result is Success, isTrue);
    });

    test('URL with Template and Domain', () {
      final result = parser.parse('http://{{host}}.com');
      print('URL with template and domain result: $result');
      expect(result is Success, isTrue);
    });

    test('URL with Template and Path', () {
      final result = parser.parse('http://{{host}}.com/path');
      print('URL with template and path result: $result');
      expect(result is Success, isTrue);
    });

    test('URL with Template and Escaped Chars', () {
      final result = parser.parse('http://{{host}}.com/path\\n');
      print('URL with template and escaped chars result: $result');
      expect(result is Success, isTrue);
    });

    test('Complete Complex String', () {
      final result = parser.parse('http://{{host}}.com/path\\nwith');

      print('Complete complex string result: $result');
      expect(result is Success, isTrue);
    });
  });
}
