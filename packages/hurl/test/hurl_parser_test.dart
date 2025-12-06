import 'package:flutter_test/flutter_test.dart';
import 'package:hurl/hurl.dart';

void main() {
  setUpAll(() async {
    await RustLib.init();
  });

  group('Basic Parsing', () {
    test('should parse simple GET request', () {
      const hurl = 'GET https://api.example.com/users';

      final result = parseHurlToJson(content: hurl);

      expect(result, contains('"method":"GET"'));
      expect(result, contains('"url":"https://api.example.com/users"'));
    });

    test('should parse request with headers', () {
      const hurl = '''
GET https://api.example.com/users
Authorization: Bearer token123
Content-Type: application/json
''';

      final result = parseHurlToJson(content: hurl);

      expect(result, contains('"name":"Authorization"'));
      expect(result, contains('"value":"Bearer token123"'));
      expect(result, contains('"name":"Content-Type"'));
      expect(result, contains('"value":"application/json"'));
    });

    test('should parse multiple requests', () {
      const hurl = '''
GET https://api.example.com/users

POST https://api.example.com/users
Content-Type: application/json
''';

      final result = parseHurlToJson(content: hurl);

      expect(result, contains('"method":"GET"'));
      expect(result, contains('"method":"POST"'));
    });

    test('should throw error for invalid syntax', () {
      const hurl = 'GET'; // Missing URL

      expect(
        () => parseHurlToJson(content: hurl),
        throwsA(isA<Object>()),
      );
    });
  });

  group('Query Parameters', () {
    test('should parse query parameters from QueryStringParams section', () {
      const hurl = '''
GET https://api.example.com/search
[QueryStringParams]
q: flutter
limit: 10
page: 1
''';

      final result = parseHurlToJson(content: hurl);

      expect(result, contains('"queryParams"'));
      expect(result, contains('"name":"q"'));
      expect(result, contains('"value":"flutter"'));
      expect(result, contains('"name":"limit"'));
      expect(result, contains('"value":"10"'));
    });
  });

  group('Request Body', () {
    test('should parse POST request with JSON body', () {
      const hurl = '''
POST https://api.example.com/users
Content-Type: application/json
{"name":"John Doe","email":"john@example.com"}
''';

      final result = parseHurlToJson(content: hurl);

      expect(result, contains('"body"'));
      expect(result, contains('\\"name\\":\\"John Doe\\"'));
      expect(result, contains('\\"email\\":\\"john@example.com\\"'));
    });

    test('should parse POST request with form data', () {
      const hurl = '''
POST https://api.example.com/login
[FormParams]
username: john
password: secret123
''';

      final result = parseHurlToJson(content: hurl);

      expect(result, contains('"formParams"'));
      expect(result, contains('"name":"username"'));
      expect(result, contains('"value":"john"'));
      expect(result, contains('"name":"password"'));
      expect(result, contains('"value":"secret123"'));
    });
  });

  group('Authentication', () {
    test('should parse request with BasicAuth', () {
      const hurl = '''
GET https://api.example.com/private
[BasicAuth]
admin: secret
''';

      final result = parseHurlToJson(content: hurl);

      expect(result, contains('"basicAuth"'));
      expect(result, contains('"username":"admin"'));
      expect(result, contains('"password":"secret"'));
    });
  });

  group('Cookies', () {
    test('should parse request with cookies section', () {
      const hurl = '''
GET https://api.example.com/dashboard
[Cookies]
session: abc123
preferences: dark_mode
token: xyz789
''';

      final result = parseHurlToJson(content: hurl);

      expect(result, contains('"cookies"'));
      expect(result, contains('"name":"session"'));
      expect(result, contains('"value":"abc123"'));
      expect(result, contains('"name":"preferences"'));
      expect(result, contains('"value":"dark_mode"'));
    });
  });

  group('Multipart Form Data', () {
    test('should parse request with multipart text fields', () {
      const hurl = '''
POST https://api.example.com/upload
[MultipartFormData]
description: A test file
author: John Doe
''';

      final result = parseHurlToJson(content: hurl);

      expect(result, contains('"multipartParams"'));
      expect(result, contains('"name":"description"'));
      expect(result, contains('"value":"A test file"'));
      expect(result, contains('"type":"text"'));
    });
  });

  group('Complex Scenarios', () {
    test('should parse request with multiple sections', () {
      const hurl = '''
POST https://api.example.com/users
Authorization: Bearer token123
Content-Type: application/json
[QueryStringParams]
utm_source: test
utm_campaign: demo
{"name":"Jane Doe","email":"jane@example.com","age":30}
''';

      final result = parseHurlToJson(content: hurl);

      expect(result, contains('"method":"POST"'));
      expect(result, contains('"queryParams"'));
      expect(result, contains('"body"'));
      expect(result, contains('"headers"'));
      expect(result, contains('Bearer token123'));
    });

    test('should parse request with authentication and cookies', () {
      const hurl = '''
GET https://api.example.com/profile
[BasicAuth]
admin: secret
[Cookies]
session: abc123
''';

      final result = parseHurlToJson(content: hurl);

      expect(result, contains('"basicAuth"'));
      expect(result, contains('"cookies"'));
      expect(result, contains('"username":"admin"'));
      expect(result, contains('"name":"session"'));
    });

    test('should parse multiple requests with different features', () {
      const hurl = '''
GET https://api.example.com/users

POST https://api.example.com/login
[FormParams]
username: john
password: secret

POST https://api.example.com/upload
[MultipartFormData]
description: Test document
''';

      final result = parseHurlToJson(content: hurl);

      expect(result, contains('"method":"GET"'));
      expect(result, contains('"formParams"'));
      expect(result, contains('"multipartParams"'));
    });
  });
}
