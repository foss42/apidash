import 'package:flutter_test/flutter_test.dart';
import 'package:hurl_parser/src/grammar/base_grammar.dart';
import 'package:petitparser/petitparser.dart';

void main() {
  final hurl = HurlGrammar();

  group('Header Parsing', () {
    test('Standard Headers', () {
      final headerParser = hurl.buildFrom(hurl.header()).end();

      // Common Headers
      var result = headerParser.parse('Content-Type: application/json\n');
      expect(result is Success, isTrue);
      if (result is Success) {
        final header = result.value as Map;
        expect(header['key'], equals('Content-Type'));
        expect(header['value'], equals('application/json'));
      }

      result = headerParser.parse('Accept: text/html\n');
      expect(result is Success, isTrue);
      if (result is Success) {
        final header = result.value as Map;
        expect(header['key'], equals('Accept'));
        expect(header['value'], equals('text/html'));
      }

      result = headerParser.parse('Authorization: Bearer token123\n');
      expect(result is Success, isTrue);
      if (result is Success) {
        final header = result.value as Map;
        expect(header['key'], equals('Authorization'));
        expect(header['value'], equals('Bearer token123'));
      }
    });

    test('Headers with Special Characters', () {
      final headerParser = hurl.buildFrom(hurl.header()).end();

      // Headers with hyphens
      var result = headerParser.parse('X-Custom-Header: value123\n');
      expect(result is Success, isTrue);

      // Headers with underscores
      result = headerParser.parse('X_Custom_Header: value123\n');
      trace(headerParser).parse('X_Custom_Header: value123\n');
      expect(result is Success, isTrue);

      // Headers with dots
      result = headerParser.parse('X.Custom.Header: value123\n');
      print("Custom Header 2");
      trace(headerParser).parse('X.Custom.Header: value123\n');
      expect(result is Success, isTrue);
    });

    test('Headers with Various Value Types', () {
      final headerParser = hurl.buildFrom(hurl.header()).end();

      // Date header
      var result = headerParser.parse('Date: Tue, 15 Nov 2024 08:12:31 GMT\n');
      expect(result is Success, isTrue);

      // Numeric value
      result = headerParser.parse('Content-Length: 1234\n');
      expect(result is Success, isTrue);

      // Comma-separated values
      result = headerParser.parse('Accept: text/html, application/json, */*\n');
      expect(result is Success, isTrue);

      // Values with semicolons
      result = headerParser.parse('Content-Type: text/html; charset=utf-8\n');
      expect(result is Success, isTrue);
    });

    test('Headers with Templates', () {
      final headerParser = hurl.buildFrom(hurl.header()).end();

      // Template in value
      var result = headerParser.parse('Authorization: Bearer {{token}}\n');
      expect(result is Success, isTrue);

      // Template in both key and value
      result = headerParser.parse('{{headerName}}: {{headerValue}}\n');
      expect(result is Success, isTrue);

      // Mixed static and template content
      result = headerParser.parse('X-Api-Version: v{{version}}\n');
      expect(result is Success, isTrue);
    });

    test('Header Whitespace Handling', () {
      final headerParser = hurl.buildFrom(hurl.header()).end();

      // Extra spaces after key
      var result = headerParser.parse('Content-Type:    application/json\n');
      expect(result is Success, isTrue);
      if (result is Success) {
        final header = result.value as Map;
        expect(header['value'], equals('application/json'));
      }

      // Extra spaces before value
      result = headerParser.parse('Content-Type:    application/json\n');
      expect(result is Success, isTrue);
      if (result is Success) {
        final header = result.value as Map;
        expect(header['value'], equals('application/json'));
      }

      // Spaces in value
      result =
          headerParser.parse('User-Agent: Mozilla/5.0 (Windows NT 10.0)\n');
      expect(result is Success, isTrue);
    });

    test('Invalid Headers', () {
      final headerParser = hurl.buildFrom(hurl.header()).end();

      // Missing colon
      var result = headerParser.parse('Content-Type application/json\n');
      expect(result is Success, isFalse);

      // Missing value
      result = headerParser.parse('Content-Type:\n');
      expect(result is Success, isFalse);

      // Missing key
      result = headerParser.parse(': application/json\n');
      expect(result is Success, isFalse);
    });

    // test('Headers with Comments', () {
    //   final headerParser = hurl.buildFrom(hurl.header()).end();

    //   // TODO:
    //   // FIX: Comment handling in the grammar
    //   // Inline comment
    //   var result = headerParser
    //       .parse('Content-Type: application/json # API content type\n');
    //   expect(result is Success, isTrue);
    //   if (result is Success) {
    //     final header = result.value as Map;
    //     expect(header['key'], equals('Content-Type'));
    //     expect(header['value'], equals('application/json'));
    //   }

    //   // Comment with multiple spaces
    //   result = headerParser.parse('Accept: text/html    # Browser request\n');
    //   expect(result is Success, isTrue);
    // });

    test('Multiple Headers Combination', () {
      final multipleHeadersParser = hurl.buildFrom(hurl.header().star()).end();
      const input =
          '''User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:70.0) Gecko/20100101 Firefox/70.0\n
    Accept: */*\n
    Accept-Language: en-US,en;q=0.5\n
    Accept-Encoding: gzip, deflate, br\n
    Connection: keep-alive\n''';

      final result = multipleHeadersParser.parse(input);
      expect(result is Success, isTrue);
      if (result is Success) {
        final headers = result.value as List;
        expect(headers.length, equals(5));
        expect(headers[0]['key'], equals('User-Agent'));
        expect(
            headers[0]['value'],
            equals(
                'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:70.0) Gecko/20100101 Firefox/70.0'));
        expect(headers[1]['key'], equals('Accept'));
        expect(headers[1]['value'], equals('*/*'));
        expect(headers[2]['key'], equals('Accept-Language'));
        expect(headers[2]['value'], equals('en-US,en;q=0.5'));
        expect(headers[3]['key'], equals('Accept-Encoding'));
        expect(headers[3]['value'], equals('gzip, deflate, br'));
        expect(headers[4]['key'], equals('Connection'));
        expect(headers[4]['value'], equals('keep-alive'));
      }
    });
  });
}
