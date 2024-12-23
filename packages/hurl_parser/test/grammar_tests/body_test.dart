import 'package:flutter_test/flutter_test.dart';
import 'package:hurl_parser/src/grammar/base_grammar.dart';
import 'package:petitparser/petitparser.dart';

void main() {
  group('Body Parser Tests', () {
    late HurlGrammar grammar;
    late Parser bodyParser;

    setUp(() {
      grammar = HurlGrammar();
      bodyParser = trace(grammar.buildFrom(grammar.body()).end());
    });

    test('parses simple JSON object body', () {
      const input = '''{
  "name": "John Doe"
}''';
      final result = bodyParser.parse(input);
      expect(result is Success, true);
      expect(result.value, {
        'type': 'json',
        'content': {'name': 'John Doe'}
      });
    });

    test('parses JSON object body with multiple fields', () {
      const input = '''{
  "name": "John Doe",
  "email": "john@example.com",
  "age": 30
}''';
      final result = bodyParser.parse(input);
      expect(result is Success, true);
      expect(result.value, {
        'type': 'json',
        'content': {'name': 'John Doe', 'email': 'john@example.com', 'age': 30}
      });
    });

    test('handles whitespace in JSON body', () {
      const input = '''  {
        "name":    "John Doe"   ,
        "email": "john@example.com"
    }  ''';
      final result = bodyParser.parse(input);
      expect(result is Success, true);
      expect(result.value, {
        'type': 'json',
        'content': {'name': 'John Doe', 'email': 'john@example.com'}
      });
    });

    test('fails gracefully on invalid JSON', () {
      const input = '''{
  "name": "John Doe"
  invalid
}''';
      final result = bodyParser.parse(input);
      expect(result is Success, false);
    });
  });
}
