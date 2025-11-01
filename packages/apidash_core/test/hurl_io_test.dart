import 'package:flutter_test/flutter_test.dart';
import 'package:apidash_core/apidash_core.dart';

void main() {
  setUpAll(() async {
    await RustLib.init();
  });

  group('HurlIO Tests', () {
    test('parse simple GET request', () {
      const hurlContent = '''
GET https://api.example.com/users
''';

      final hurlIO = HurlIO();
      final result = hurlIO.getHttpRequestModelList(hurlContent);

      expect(result, isNotNull);
      expect(result!.length, 1);

      final (url, request) = result[0];
      expect(url, 'https://api.example.com/users');
      expect(request.method, HTTPVerb.get);
      expect(request.url, 'https://api.example.com/users');
      expect(request.headers, isEmpty);
      expect(request.params, isEmpty);
    });

    test('parse GET request with headers', () {
      const hurlContent = '''
GET https://api.example.com/users
Authorization: Bearer token123
Content-Type: application/json
User-Agent: API Dash
''';

      final hurlIO = HurlIO();
      final result = hurlIO.getHttpRequestModelList(hurlContent);

      expect(result, isNotNull);
      expect(result!.length, 1);

      final (url, request) = result[0];
      expect(request.method, HTTPVerb.get);
      expect(request.headers?.length, 3);
      
      expect(request.headers?[0].name, 'Authorization');
      expect(request.headers?[0].value, 'Bearer token123');
      
      expect(request.headers?[1].name, 'Content-Type');
      expect(request.headers?[1].value, 'application/json');
      
      expect(request.headers?[2].name, 'User-Agent');
      expect(request.headers?[2].value, 'API Dash');
    });

    test('parse GET request with query parameters', () {
      const hurlContent = '''
GET https://api.example.com/users?page=1&limit=10&sort=name
''';

      final hurlIO = HurlIO();
      final result = hurlIO.getHttpRequestModelList(hurlContent);

      expect(result, isNotNull);
      expect(result!.length, 1);

      final (url, request) = result[0];
      expect(request.method, HTTPVerb.get);
      expect(request.url, 'https://api.example.com/users');
      expect(request.params?.length, 3);
      
      // Query params order might vary, so check by name
      final paramMap = {for (var p in request.params ?? []) p.name: p.value};
      expect(paramMap['page'], '1');
      expect(paramMap['limit'], '10');
      expect(paramMap['sort'], 'name');
    });

    test('parse POST request', () {
      const hurlContent = '''
POST https://api.example.com/users
Content-Type: application/json
''';

      final hurlIO = HurlIO();
      final result = hurlIO.getHttpRequestModelList(hurlContent);

      expect(result, isNotNull);
      expect(result!.length, 1);

      final (url, request) = result[0];
      expect(request.method, HTTPVerb.post);
      expect(request.url, 'https://api.example.com/users');
    });

    test('parse multiple requests', () {
      const hurlContent = '''
GET https://api.example.com/users

POST https://api.example.com/users
Content-Type: application/json

DELETE https://api.example.com/users/123
Authorization: Bearer token
''';

      final hurlIO = HurlIO();
      final result = hurlIO.getHttpRequestModelList(hurlContent);

      expect(result, isNotNull);
      expect(result!.length, 3);

      // Check first request (GET)
      expect(result[0].$2.method, HTTPVerb.get);
      expect(result[0].$2.url, 'https://api.example.com/users');

      // Check second request (POST)
      expect(result[1].$2.method, HTTPVerb.post);
      expect(result[1].$2.url, 'https://api.example.com/users');
      expect(result[1].$2.headers?.length, 1);

      // Check third request (DELETE)
      expect(result[2].$2.method, HTTPVerb.delete);
      expect(result[2].$2.url, 'https://api.example.com/users/123');
      expect(result[2].$2.headers?.length, 1);
    });

    test('handle invalid Hurl content', () {
      const hurlContent = '''
INVALID SYNTAX HERE
''';

      final hurlIO = HurlIO();
      final result = hurlIO.getHttpRequestModelList(hurlContent);

      expect(result, isNull);
    });

    test('handle empty content', () {
      const hurlContent = '';

      final hurlIO = HurlIO();
      final result = hurlIO.getHttpRequestModelList(hurlContent);

      expect(result, isNull);
    });
  });
}
