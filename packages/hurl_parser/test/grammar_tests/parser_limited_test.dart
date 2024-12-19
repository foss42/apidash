import 'package:flutter_test/flutter_test.dart';
import 'package:hurl_parser/src/grammar/base_grammar.dart';
import 'package:petitparser/petitparser.dart';

void main() {
  final hurl = HurlGrammar();

  group('Basic Parsers', () {
    test('HTTP Method', () {
      final methodParser = hurl.buildFrom(hurl.method()).end();
      final result = methodParser.parse('GET');
      expect(result is Success, isTrue);
    });

    test('URL String', () {
      final valueStringParser = hurl.buildFrom(hurl.valueString()).end();
      final result = valueStringParser.parse('http://example.com');
      expect(result is Success, isTrue);
    });

    test('Key String', () {
      final keyStringParser = hurl.buildFrom(hurl.keyString()).end();
      final result = keyStringParser.parse('Content-Type');
      expect(result is Success, isTrue);
    });
  });

  group('Header Parsing', () {
    test('Simple Header', () {
      final headerParser = hurl.buildFrom(hurl.header()).end();
      final result = headerParser.parse('Content-Type: application/json\n');
      expect(result is Success, isTrue);
      if (result is Success) {
        final Map<String, dynamic> header = result.value;
        expect(header['key'], 'Content-Type');
        expect(header['value'], 'application/json');
      }
    });
  });

  test('Basic GET Request', () {
    final requestParser = hurl.buildFrom(hurl.request()).end();

    // Add debug tracing
    // trace(requestParser).parse('GET http://example.com\n');

    final result = requestParser.parse('GET http://example.com\n');
    expect(result is Success, isTrue);

    if (result is Success) {
      final request = result.value;
      expect(request['method'], 'GET');
      expect(request['url'], 'http://example.com');
    }
  });
}
