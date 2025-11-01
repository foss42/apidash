import 'package:flutter_test/flutter_test.dart';
import 'package:hurl/hurl.dart';

void main() {
  setUpAll(() async {
    await RustLib.init();
  });

  group('Advanced Hurl Features Tests', () {
    test('parse request with cookies', () {
      const hurlContent = '''
GET https://api.example.com/dashboard
[Cookies]
session: abc123
preferences: dark_mode
token: xyz789
''';

      final result = parseHurlToJson(content: hurlContent);
      print('Cookies result: $result');
      
      expect(result, contains('"cookies"'));
      expect(result, contains('"name":"session"'));
      expect(result, contains('"value":"abc123"'));
      expect(result, contains('"name":"preferences"'));
      expect(result, contains('"value":"dark_mode"'));
    });

    test('parse request with multipart text data', () {
      const hurlContent = '''
POST https://api.example.com/upload
[MultipartFormData]
description: A test file
author: John Doe
''';

      final result = parseHurlToJson(content: hurlContent);
      print('Multipart result: $result');
      
      expect(result, contains('"multipartParams"'));
      expect(result, contains('"name":"description"'));
      expect(result, contains('"value":"A test file"'));
      expect(result, contains('"type":"text"'));
    });

    test('parse comprehensive request with all features', () {
      const hurlContent = '''
POST https://api.example.com/users
Authorization: Bearer token123
Content-Type: application/json
[QueryStringParams]
utm_source: test
utm_campaign: demo
[Cookies]
session: abc123
[BasicAuth]
admin: secret
{
  "name": "Jane Doe",
  "email": "jane@example.com",
  "age": 30
}
''';

      final result = parseHurlToJson(content: hurlContent);
      print('Comprehensive with cookies result: $result');
      
      expect(result, contains('"method":"POST"'));
      expect(result, contains('"queryParams"'));
      expect(result, contains('"cookies"'));
      expect(result, contains('"basicAuth"'));
      expect(result, contains('"body"'));
    });

    test('parse multiple requests with mixed features', () {
      const hurlContent = '''
# Request 1: Simple GET
GET https://api.example.com/users

# Request 2: POST with cookies
POST https://api.example.com/login
[Cookies]
remember_me: true
[FormParams]
username: john
password: secret

# Request 3: Multipart upload
POST https://api.example.com/upload
[MultipartFormData]
description: Test document
''';

      final result = parseHurlToJson(content: hurlContent);
      print('Multiple requests result: $result');
      
      // Should have 3 requests
      final entriesMatch = RegExp(r'"entries":\[.*?\]').firstMatch(result);
      expect(entriesMatch, isNotNull);
      
      // Check for different request types
      expect(result, contains('"method":"GET"'));
      expect(result, contains('"method":"POST"'));
      expect(result, contains('"cookies"'));
      expect(result, contains('"formParams"'));
      expect(result, contains('"multipartParams"'));
    });
  });
}
