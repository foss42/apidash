import 'package:flutter_test/flutter_test.dart';
import 'package:hurl_parser/hurl_parser.dart';
import 'package:hurl_parser/src/models/common/body_types_enums.dart';
import 'package:hurl_parser/src/models/misc_model.dart';
import 'package:hurl_parser/src/models/multipart_form_params.dart';
import 'package:hurl_parser/src/models/query_string_params.dart';
import 'package:petitparser/petitparser.dart';

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
      expect(
        result.value,
        Request(method: "GET", url: "http://api.example.com/users", headers: [
          Header(key: "User-Agent", value: "curl/7.68.0"),
          Header(key: "Accept", value: "application/json")
        ]),
      );
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
      expect(querySection, isNotNull);

      final params = (querySection?.content as QueryStringParams).params;
      expect(params.length, equals(2));
      expect(params[0].key, equals('page'));
      expect(params[0].value, equals('1'));
      expect(params[1].key, equals('limit'));
      expect(params[1].value, equals('10'));
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
      expect(
        result.value,
        Request(
          method: "POST",
          url: "http://api.example.com/users",
          headers: [
            Header(key: "Content-Type", value: "application/json"),
          ],
          body: Body(
              type: BodyType.json,
              content: {'name': 'John Doe', 'email': 'john@example.com'}),
        ),
      );
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
      expect(result.value?.body?.type, equals(BodyType.json));
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
      expect(capturesSection, isNotNull);

      final captures = (capturesSection?.content as Captures).captures;
      expect(captures.length, equals(1));
      expect(captures[0].name, equals('auth_token'));
      expect(captures[0].query.type, equals('jsonpath'));
      expect(captures[0].query.value, equals('\$.token'));
    });

    test('parses response with assertions', () {
      const input = '''
HTTP/1.1 200
Content-Type: application/json

[Asserts]
status equals 200
header "Content-Type" equals "application/json"
jsonpath "\$.status" equals "success"
''';
      final result = parser.parseResponse(input);
      expect(result.isSuccess, true);

      final assertsSection = result.value?.sections
          .firstWhere((section) => section.type == 'Asserts');
      expect(assertsSection, isNotNull);

      final asserts = (assertsSection?.content as Asserts).asserts;
      expect(asserts.length, equals(3));

      // Check first assert
      expect(asserts[0].query.type, equals('status'));
      expect(asserts[0].predicate.type, equals('equals'));
      expect(asserts[0].predicate.value, equals('200'));
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
      expect(multipartSection, isNotNull);

      final params = (multipartSection?.content as MultipartFormData).params;
      expect(params.length, equals(2));
      expect(params[0].name, equals('file1'));
      expect(params[0].filename, equals('example.txt'));
      expect(params[0].contentType, equals('text/plain'));
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
      expect(optionsSection, isNotNull);

      final options = (optionsSection?.content as Options).options;
      expect(options.length, equals(3));
      expect(options[0].type, equals('insecure'));
      expect(options[0].value, equals('true'));
    });
  });
}
