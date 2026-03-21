import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PostmanIO parser', () {
    test('imports x-www-form-urlencoded bodies as form data', () {
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
      expect(request.bodyContentType, ContentType.formdata);
      expect(
        request.formData,
        const [
          FormDataModel(
            name: 'username',
            value: 'admin',
            type: FormDataType.text,
          ),
          FormDataModel(
            name: 'password',
            value: 'secret123',
            type: FormDataType.text,
          ),
        ],
      );
    });
  });
}
