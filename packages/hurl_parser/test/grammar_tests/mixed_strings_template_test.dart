import 'package:flutter_test/flutter_test.dart';
import 'package:hurl_parser/src/grammar/base_grammar.dart';
import 'package:petitparser/petitparser.dart';

void main() {
  final hurl = HurlGrammar();

  group('Mixed Content Tests', () {
    final parser = hurl.buildFrom(hurl.valueString()).end();

    test('Text with single escape in middle', () {
      final result = parser.parse('hello\\nworld');
      print('Single escape result: $result');
      expect(result is Success, isTrue);
    });

    test('Text with multiple escapes', () {
      final result = parser.parse('hello\\nworld\\ttest');
      print('Multiple escape result: $result');
      expect(result is Success, isTrue);
    });

    test('Text with escape at end', () {
      final result = parser.parse('hello\\n');
      print('End escape result: $result');
      expect(result is Success, isTrue);
    });

    test('Template with following text', () {
      final result = parser.parse('{{host}}test');
      print('Template with text result: $result');
      expect(result is Success, isTrue);
    });

    // Flattened URL part tests
    test('URL protocol and template', () {
      final result = parser.parse('http://{{host}}');
      print('Protocol and template result: $result');
      expect(result is Success, isTrue);
    });

    test('URL template and domain', () {
      final result = parser.parse('{{host}}.com');
      print('Template and domain result: $result');
      expect(result is Success, isTrue);
    });

    test('URL domain and path', () {
      final result = parser.parse('.com/path');
      print('Domain and path result: $result');
      expect(result is Success, isTrue);
    });

    test('URL path with escape', () {
      final result = parser.parse('/path\\nmore');
      print('Path with escape result: $result');
      expect(result is Success, isTrue);
    });

    test('Complete URL with mixed content', () {
      final result = (parser).parse('http://{{host}}.com/path\\nwith');
      print('Complete URL result: $result');
      expect(result is Success, isTrue);
    });
  });

  group('Component Tests', () {
    test('Escaped Character', () {
      final escapeParser = hurl.buildFrom(hurl.valueStringEscapedChar()).end();
      final result = escapeParser.parse('\\n');
      print('Escape char result: $result');
      expect(result is Success, isTrue);
    });

    test('Template', () {
      final templateParser = hurl.buildFrom(hurl.template()).end();
      final result = templateParser.parse('{{host}}');
      print('Template result: $result');
      expect(result is Success, isTrue);
    });
  });

  group('Mixed String and Template Tests', () {
    test('String with Template', () {
      final mixedParser = hurl.buildFrom(hurl.valueString()).end();

      expect(mixedParser.parse('value{{variable}}')is Success, isTrue);
      expect(mixedParser.parse('{{var1}}text{{var2}}')is Success, isTrue);
      expect(mixedParser.parse('prefix_{{var}}_suffix')is Success, isTrue);
    });

    test('Multiple Templates in String', () {
      final mixedParser = hurl.buildFrom(hurl.valueString()).end();

      final testCases = [
        'Hello {{name}}, your ID is {{id}}',
        '{{prefix}}-{{middle}}-{{suffix}}',
        'Path: {{basePath}}/{{version}}/{{endpoint}}'
      ];

      for (var testCase in testCases) {
        expect(mixedParser.parse(testCase)is Success, isTrue);
      }
    });

    test('Template with Special Characters', () {
      final mixedParser = hurl.buildFrom(hurl.valueString()).end();

      expect(mixedParser.parse('{{base_url}}/path')is Success, isTrue);
      expect(mixedParser.parse('{{url-param}}/test')is Success, isTrue);
      expect(mixedParser.parse('/api/{{resource_id}}/')is Success, isTrue);
    });
  });
}
