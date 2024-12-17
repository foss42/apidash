import 'package:flutter_test/flutter_test.dart';
import 'package:petitparser/petitparser.dart';
import 'package:hurl_parser/src/grammar/base_grammar.dart';

void main() {
  late HurlGrammar grammar;
  late Parser assertParser;
  late Parser predicateParser;

  setUp(() {
    grammar = HurlGrammar();
    assertParser = trace(grammar.buildFrom(grammar.assert_()).end());
    predicateParser = trace(grammar.buildFrom(grammar.predicate()).end());
  });

  group('Predicate Value Tests', () {
    test('parses equality predicates', () {
      const input = '== "Felix"';
      final result = predicateParser.parse(input);

      expect(result is Success, isTrue);
      expect(result.value[1][0], equals('=='));
    });

    test('parses not equality predicates', () {
      const input = 'not == "Felix"';
      final result = predicateParser.parse(input);

      expect(result is Success, isTrue);
      expect(result.value[0][0], equals('not'));
    });

    test('parses comparison predicates', () {
      final tests = {
        'greater than': '> 400',
        'less than': '< 500',
        'greater equals': '>= 200',
        'less equals': '<= 299'
      };

      for (final test in tests.entries) {
        final result = predicateParser.parse(test.value);
        expect(result is Success, isTrue,
            reason: 'Failed to parse ${test.key}');
      }
    });
  });

  group('String Predicate Tests', () {
    test('parses string predicates', () {
      final tests = {
        'contains': 'contains "utf-8"',
        'startsWith': 'startsWith "application/"',
        'endsWith': 'endsWith "json"',
        'matches': 'matches "\\d+"'
      };

      for (final test in tests.entries) {
        final result = predicateParser.parse(test.value);
        expect(result is Success, isTrue,
            reason: 'Failed to parse ${test.key}');
      }
    });
  });

  group('Existence Predicate Tests', () {
    test('parses existence predicates', () {
      final tests = [
        'exists',
        'isEmpty',
        'isInteger',
        'isFloat',
        'isBoolean',
        'isString',
        'isCollection',
        'isDate',
        'isIsoDate'
      ];

      for (final test in tests) {
        final result = predicateParser.parse(test);
        expect(result is Success, isTrue, reason: 'Failed to parse $test');
      }
    });
  });

  group('Assert Query Tests', () {
    test('parses status assert', () {
      const input = 'status == 200\n';
      final result = assertParser.parse(input);

      expect(result is Success, isTrue);
      expect(result.value[1], equals('status'));
    });

    test('parses header assert', () {
      const input = 'header "Content-Type" contains "utf-8"\n';
      final result = assertParser.parse(input);

      expect(result is Success, isTrue);
      expect(result.value[1][0], equals('header'));
    });

    test('parses bytes assert', () {
      const input = 'bytes count == 120\n';
      final result = assertParser.parse(input);

      expect(result is Success, isTrue);
      expect(result.value[1], equals('bytes'));
    });

    test('parses jsonpath assert', () {
      const input = 'jsonpath "\$.cats" count == 49\n';
      final result = assertParser.parse(input);

      expect(result is Success, isTrue);
      expect(result.value[1][0], equals('jsonpath'));
    });
  });

  group('Asserts Section Tests', () {
    late Parser assertsSectionParser;

    setUp(() {
      assertsSectionParser =
          trace(grammar.buildFrom(grammar.assertsSection()).end());
    });

    test('parses complete asserts section', () {
      const input = '''[Asserts]
bytes count == 120
header "Content-Type" contains "utf-8"
jsonpath "\$.cats" count == 49
jsonpath "\$.cats[0].name" == "Felix"
jsonpath "\$.cats[0].lives" == 9
''';
      final result = assertsSectionParser.parse(input);

      expect(result is Success, isTrue);
      expect(result.value[1], equals('[Asserts]'));
    });

    test('parses asserts section with comments', () {
      const input = '''[Asserts]
# Check response size
bytes count == 120
# Verify content type
header "Content-Type" contains "utf-8"
''';
      final result = assertsSectionParser.parse(input);

      expect(result is Success, isTrue);
    });
  });

  group('Error Cases', () {
    test('rejects invalid predicate operators', () {
      const input = 'status INVALID 200\n';
      final result = assertParser.parse(input);
      expect(result is Success, isFalse);
    });

    test('rejects missing predicate values', () {
      const input = 'status ==\n';
      final result = assertParser.parse(input);
      expect(result is Success, isFalse);
    });

    test('rejects invalid query types', () {
      const input = 'invalidquery == "test"\n';
      final result = assertParser.parse(input);
      expect(result is Success, isFalse);
    });

    test('requires line terminator', () {
      const input = 'status == 200'; // missing \n
      final result = assertParser.parse(input);
      expect(result is Success, isFalse);
    });
  });
}
