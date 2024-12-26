// test/hurl_parser_rust_test.dart

import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:hurl_parser_rust/src/rust/frb_generated.dart';
import 'package:hurl_parser_rust/src/rust/api/simple.dart';

void main() {
  setUpAll(() async {
    await RustLib.init();
  });

  group('Hurl Parser', () {
    test('should parse simple GET request', () {
      final result = parseHurlToJson(content: '''
GET http://example.com/api
HTTP/1.1 200
''');

      final json = jsonDecode(result);
      expect(json['entries'][0]['request']['method'], 'GET');
      expect(json['entries'][0]['request']['url'], 'http://example.com/api');
    });

    test('should parse POST request with headers and body', () {
      final result = parseHurlToJson(content: '''
POST http://example.com/api
Content-Type: application/json
{
    "name": "test"
}
HTTP/1.1 200
''');

      final json = jsonDecode(result);
      expect(json['entries'][0]['request']['method'], 'POST');
      expect(
          json['entries'][0]['request']['headers'][0]['name'], 'Content-Type');
      expect(json['entries'][0]['request']['headers'][0]['value'],
          'application/json');
    });

    test('should parse response asserts', () {
      final result = parseHurlToJson(content: '''
GET http://example.com/api
HTTP/1.1 200
[Asserts]
header "content-type" == "application/json"
jsonpath "\$.status" == "success"
''');

      final json = jsonDecode(result);
      final response = json['entries'][0]['response'];
      expect(response['asserts'], isNotEmpty);
    });

    test('should handle invalid Hurl syntax', () {
      expect(
        () => parseHurlToJson(
            content:
                'INVALID SYNTAX AINT NO WAY THIS IS WORKING \n  [Invalid] INVALID'),
        throwsA(isA<String>()),
      );
    });

    test('should parse multiple entries', () {
      final result = parseHurlToJson(content: '''
GET http://example.com/first
HTTP/1.1 200

GET http://example.com/second
HTTP/1.1 404
''');

      final json = jsonDecode(result);
      expect(json['entries'], hasLength(2));
      expect(json['entries'][0]['request']['url'], 'http://example.com/first');
      expect(json['entries'][1]['request']['url'], 'http://example.com/second');
    });
  });
}
