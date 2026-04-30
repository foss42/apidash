import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PostmanIO import conversion', () {
    final postmanIO = PostmanIO();

    test('maps bearer auth from Postman auth block', () {
      const content = r'''
{
  "info": {
    "name": "Bearer",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Bearer Request",
      "request": {
        "method": "GET",
        "auth": {
          "type": "bearer",
          "bearer": [
            {
              "key": "token",
              "value": "my-bearer-token"
            }
          ]
        },
        "url": {
          "raw": "https://api.example.com/data"
        }
      }
    }
  ]
}
''';

      final requests = postmanIO.getHttpRequestModelList(content);
      final request = requests!.first.$2;

      expect(request.authModel?.type, APIAuthType.bearer);
      expect(request.authModel?.bearer?.token, 'my-bearer-token');
    });

    test('maps basic and apikey auth from Postman auth block', () {
      const content = r'''
{
  "info": {
    "name": "Basic + API Key",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Basic Request",
      "request": {
        "method": "GET",
        "auth": {
          "type": "basic",
          "basic": [
            {
              "key": "username",
              "value": "john"
            },
            {
              "key": "password",
              "value": "secret"
            }
          ]
        },
        "url": {
          "raw": "https://api.example.com/basic"
        }
      }
    },
    {
      "name": "ApiKey Request",
      "request": {
        "method": "GET",
        "auth": {
          "type": "apikey",
          "apikey": [
            {
              "key": "key",
              "value": "X-API-Key"
            },
            {
              "key": "value",
              "value": "abcdef"
            },
            {
              "key": "in",
              "value": "header"
            }
          ]
        },
        "url": {
          "raw": "https://api.example.com/apikey"
        }
      }
    }
  ]
}
''';

      final requests = postmanIO.getHttpRequestModelList(content)!;
      final basicRequest = requests[0].$2;
      final apiKeyRequest = requests[1].$2;

      expect(basicRequest.authModel?.type, APIAuthType.basic);
      expect(basicRequest.authModel?.basic?.username, 'john');
      expect(basicRequest.authModel?.basic?.password, 'secret');

      expect(apiKeyRequest.authModel?.type, APIAuthType.apiKey);
      expect(apiKeyRequest.authModel?.apikey?.name, 'X-API-Key');
      expect(apiKeyRequest.authModel?.apikey?.key, 'abcdef');
      expect(apiKeyRequest.authModel?.apikey?.location, 'header');
    });

    test('falls back to none for unsupported auth type', () {
      const content = r'''
{
  "info": {
    "name": "Unsupported Auth",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Digest Request",
      "request": {
        "method": "GET",
        "auth": {
          "type": "digest"
        },
        "url": {
          "raw": "https://api.example.com/digest"
        }
      }
    }
  ]
}
''';

      final requests = postmanIO.getHttpRequestModelList(content);
      final request = requests!.first.$2;

      expect(request.authModel?.type, APIAuthType.none);
    });

    test('maps urlencoded body entries into form data rows', () {
      const content = r'''
{
  "info": {
    "name": "urlencoded",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Token Request",
      "request": {
        "method": "POST",
        "body": {
          "mode": "urlencoded",
          "urlencoded": [
            {
              "key": "grant_type",
              "value": "client_credentials",
              "type": "text"
            },
            {
              "key": "disabled_field",
              "value": "ignore-me",
              "type": "text",
              "disabled": true
            }
          ]
        },
        "url": {
          "raw": "https://api.example.com/oauth/token"
        }
      }
    }
  ]
}
''';

      final requests = postmanIO.getHttpRequestModelList(content);
      final request = requests!.first.$2;

      expect(request.bodyContentType, ContentType.formdata);
      expect(request.formData, isNotNull);
      expect(request.formData!.length, 1);
      expect(request.formData!.first.name, 'grant_type');
      expect(request.formData!.first.value, 'client_credentials');
      expect(request.formData!.first.type, FormDataType.text);
    });

    test('resolves collection variables in url, headers and body', () {
      const content = r'''
{
  "info": {
    "name": "Variables",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "variable": [
    {
      "key": "base_url",
      "value": "https://api.example.com"
    },
    {
      "key": "api_key",
      "value": "top-secret"
    }
  ],
  "item": [
    {
      "name": "Variable Request",
      "request": {
        "method": "POST",
        "header": [
          {
            "key": "Authorization",
            "value": "Bearer {{api_key}}"
          }
        ],
        "body": {
          "mode": "raw",
          "raw": "{\"token\":\"{{api_key}}\"}",
          "options": {
            "raw": {
              "language": "json"
            }
          }
        },
        "url": {
          "raw": "{{base_url}}/v1/data"
        }
      }
    }
  ]
}
''';

      final requests = postmanIO.getHttpRequestModelList(content);
      final request = requests!.first.$2;

      expect(request.url, 'https://api.example.com/v1/data');
      expect(request.headers?.first.value, 'Bearer top-secret');
      expect(request.body, '{"token":"top-secret"}');
    });
  });
}
