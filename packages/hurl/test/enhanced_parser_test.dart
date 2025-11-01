import 'package:flutter_test/flutter_test.dart';
import 'package:hurl/hurl.dart';

void main() {
  setUpAll(() async {
    await RustLib.init();
  });

  group('Enhanced Hurl Parser Tests', () {
    test('parse request with query params section', () {
      const hurlContent = '''
GET https://api.example.com/search
[QueryStringParams]
q: flutter
limit: 10
page: 1
''';

      final result = parseHurlToJson(content: hurlContent);
      print('Query params result: $result');
      
      expect(result, contains('"queryParams"'));
      expect(result, contains('"name":"q"'));
      expect(result, contains('"value":"flutter"'));
    });

    test('parse POST with JSON body', () {
      const hurlContent = '''
POST https://api.example.com/users
Content-Type: application/json
{
  "name": "John Doe",
  "email": "john@example.com"
}
''';

      final result = parseHurlToJson(content: hurlContent);
      print('JSON body result: $result');
      
      expect(result, contains('"body"'));
      expect(result, contains('\\"name\\":\\"John Doe\\"'));
      expect(result, contains('\\"email\\":\\"john@example.com\\"'));
    });

    test('parse POST with form data', () {
      const hurlContent = '''
POST https://api.example.com/login
[FormParams]
username: john
password: secret123
''';

      final result = parseHurlToJson(content: hurlContent);
      print('Form data result: $result');
      
      expect(result, contains('"formParams"'));
      expect(result, contains('"name":"username"'));
      expect(result, contains('"value":"john"'));
    });

    test('parse request with basic auth', () {
      const hurlContent = '''
GET https://api.example.com/private
[BasicAuth]
admin: secret
''';

      final result = parseHurlToJson(content: hurlContent);
      print('Basic auth result: $result');
      
      expect(result, contains('"basicAuth"'));
      expect(result, contains('"username":"admin"'));
      expect(result, contains('"password":"secret"'));
    });

    test('parse comprehensive request', () {
      const hurlContent = '''
POST https://api.example.com/users
Authorization: Bearer token123
Content-Type: application/json
[QueryStringParams]
utm_source: test
utm_campaign: demo
{
  "name": "Jane Doe",
  "email": "jane@example.com",
  "age": 30
}
''';

      final result = parseHurlToJson(content: hurlContent);
      print('Comprehensive result: $result');
      
      expect(result, contains('"method":"POST"'));
      expect(result, contains('"queryParams"'));
      expect(result, contains('"body"'));
      expect(result, contains('"headers"'));
    });
  });
}
