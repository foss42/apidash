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

    test('Parse complex Hurl file', () {
      final hurlContent = '''# First request - Get users
GET http://api.example.com/users
Authorization: Bearer token123
Accept: application/json

HTTP/1.1 200
[Captures]
user_id: jsonpath "\$.users[0].id"

[Asserts]
header "Content-Type" == "application/json"

# Second request - Create user
POST http://api.example.com/users
Content-Type: application/json

{
    "name": "John Doe",
    "email": "john@example.com"
}

HTTP/1.1 201
[Asserts]
header "Location" exists
jsonpath "\$.id" exists

# Third request - Update user
PUT http://api.example.com/users/{{user_id}}
Content-Type: application/json

{
    "name": "John Updated"
}

HTTP/1.1 200
[Captures]
updated_at: jsonpath "\$.updated_at"

# Fourth request - Get user posts
GET http://api.example.com/users/{{user_id}}/posts
[Options]
insecure: true
retry: 3

HTTP/1.1 200
[Asserts]
jsonpath "\$.posts" isCollection

# Fifth request - Delete user
DELETE http://api.example.com/users/{{user_id}}

HTTP/1.1 204
''';

      final result = parseHurlToJson(content: hurlContent);
      final jsonResult = jsonDecode(result);

      // Pretty print the JSON
      print(JsonEncoder.withIndent('  ').convert(jsonResult));
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
