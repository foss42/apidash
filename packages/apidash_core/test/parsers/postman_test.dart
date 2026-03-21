import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PostmanIO parser', () {
    test('imports x-www-form-urlencoded bodies as encoded text bodies', () {
      const content = '''
{
  "info": {
    "name": "Test Collection",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Login",
      "request": {
        "method": "POST",
        "body": {
          "mode": "urlencoded",
          "urlencoded": [
            {"key": "username", "value": "admin", "type": "text"},
            {"key": "skip", "value": "me", "type": "text", "disabled": true},
            {"key": "password", "value": "secret123", "type": "text"}
          ]
        },
        "url": {
          "raw": "https://api.example.com/login"
        }
      }
    }
  ]
}
''';

      final requests = PostmanIO().getHttpRequestModelList(content);

      expect(requests, isNotNull);
      expect(requests, hasLength(1));
      final request = requests!.single.$2;
      expect(request.method, HTTPVerb.post);
      expect(request.url, 'https://api.example.com/login');
      expect(request.bodyContentType, ContentType.text);
      expect(request.body, 'username=admin&password=secret123');
      expect(
        request.headers,
        const [
          NameValueModel(
            name: 'Content-Type',
            value: 'application/x-www-form-urlencoded',
          ),
        ],
      );
      expect(request.formData, isNull);
    });
  });
}
