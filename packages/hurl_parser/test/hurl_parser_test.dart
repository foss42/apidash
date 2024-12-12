// test/hurl_parser_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:hurl_parser/src/parser.dart';

void main() {
  late HurlParser parser;

  setUp(() {
    parser = HurlParser();
  });

  group('Request Parsing', () {
    test('parses simple GET request', () {
      const input = '''
GET http://api.example.com/users
User-Agent: curl/7.68.0
Accept: application/json
''';
      final result = parser.parseRequest(input);
      expect(result.isSuccess, true);
      expect(result.value?.method, equals('GET'));
      expect(result.value?.url, equals('http://api.example.com/users'));
      expect(result.value?.headers.length, equals(2));
    });

    test('parses request with query parameters', () {
      const input = '''
GET http://api.example.com/users
[QueryStringParams]
page: 1
limit: 10
''';
      final result = parser.parseRequest(input);
      expect(result.isSuccess, true);

      final querySection = result.value?.sections
          .firstWhere((section) => section.type == 'QueryStringParams');
      expect(querySection?.content.params.length, equals(2));
    });

    test('parses request with body', () {
      const input = '''
POST http://api.example.com/users
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com"
}
''';
      final result = parser.parseRequest(input);
      expect(result.isSuccess, true);
      expect(result.value?.body, isNotNull);
    });
  });

  group('Response Parsing', () {
    test('parses simple response', () {
      const input = '''
HTTP/1.1 200
Content-Type: application/json
Cache-Control: no-cache

{
  "id": 123,
  "status": "success"
}
''';
      final result = parser.parseResponse(input);
      expect(result.isSuccess, true);
      expect(result.value?.version, equals('HTTP/1.1'));
      expect(result.value?.status, equals(200));
      expect(result.value?.headers.length, equals(2));
    });

    test('parses response with captures', () {
      const input = '''
HTTP/1.1 200
Content-Type: application/json

{
  "token": "abc123"
}

[Captures]
auth_token: jsonpath "\$.token"
''';
      final result = parser.parseResponse(input);
      expect(result.isSuccess, true);

      final capturesSection = result.value?.sections
          .firstWhere((section) => section.type == 'Captures');
      expect(capturesSection?.content.captures.length, equals(1));
    });

    test('parses response with assertions', () {
      const input = '''
HTTP/1.1 200
Content-Type: application/json

[Asserts]
status == 200
header "Content-Type" == "application/json"
jsonpath "\$.status" == "success"
''';
      final result = parser.parseResponse(input);
      expect(result.isSuccess, true);

      final assertsSection = result.value?.sections
          .firstWhere((section) => section.type == 'Asserts');
      expect(assertsSection?.content.asserts.length, equals(3));
    });
  });

  group('Complete Entry Parsing', () {
    test('parses complete request-response entry', () {
      const input = '''
GET http://api.example.com/status
Accept: application/json

HTTP/1.1 200
Content-Type: application/json

{
  "status": "operational"
}
''';
      final result = parser.parseEntry(input);
      expect(result.isSuccess, true);
      expect(result.value?.request, isNotNull);
      expect(result.value?.response, isNotNull);
    });
  });

  group('Full Hurl File Parsing', () {
    test('parses multiple entries', () {
      const input = '''
# First request
GET http://api.example.com/status
Accept: application/json

HTTP/1.1 200
Content-Type: application/json

{
  "status": "operational"
}

# Second request
POST http://api.example.com/users
Content-Type: application/json

{
  "name": "John Doe"
}

HTTP/1.1 201
Content-Type: application/json

{
  "id": 123,
  "name": "John Doe"
}
''';
      final result = parser.parseHurlFile(input);
      expect(result.isSuccess, true);
      expect(result.value?.entries.length, equals(2));
    });
  });

  group('Error Handling', () {
    test('handles invalid request method', () {
      const input = 'INVALID http://api.example.com';
      final result = parser.parseRequest(input);
      expect(result.isSuccess, false);
      expect(result.error, isNotNull);
    });

    test('handles malformed JSON body', () {
      const input = '''
POST http://api.example.com
Content-Type: application/json

{
  "invalid json
}
''';
      final result = parser.parseRequest(input);
      expect(result.isSuccess, false);
      expect(result.error, isNotNull);
    });

    test('handles invalid status code', () {
      const input = '''
HTTP/1.1 999999
Content-Type: application/json
''';
      final result = parser.parseResponse(input);
      expect(result.isSuccess, false);
      expect(result.error, isNotNull);
    });
  });

  group('Special Features', () {
    test('parses multipart form data', () {
      const input = '''
POST http://api.example.com/upload
[MultipartFormData]
file1: file,example.txt; text/plain
field1: value1
''';
      final result = parser.parseRequest(input);
      expect(result.isSuccess, true);

      final multipartSection = result.value?.sections
          .firstWhere((section) => section.type == 'MultipartFormData');
      expect(multipartSection?.content.params.length, equals(2));
    });

    test('parses custom options', () {
      const input = '''
GET http://api.example.com
[Options]
insecure: true
retry: 3
connect-timeout: 30
''';
      final result = parser.parseRequest(input);
      expect(result.isSuccess, true);

      final optionsSection = result.value?.sections
          .firstWhere((section) => section.type == 'Options');
      expect(optionsSection?.content.options.length, equals(3));
    });

    test('parses template variables', () {
      const input = '''
GET http://api.example.com/users/{{userId}}
[Asserts]
// jsonpath "\$.id" == {{expectedId}}
''';
      final result = parser.parseRequest(input);
      expect(result.isSuccess, true);
    });
  });
}
