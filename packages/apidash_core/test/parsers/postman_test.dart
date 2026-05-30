import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';

void main() {
  group('PostmanIO parser tests', () {
    late PostmanIO postmanIO;

    setUp(() {
      postmanIO = PostmanIO();
    });

    test('maps bearer auth and collection variables', () {
      const content = r'''
{
  "info": {
    "name": "Auth and Vars",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "variable": [
    {
      "key": "base_url",
      "value": "https://api.example.com"
    },
    {
      "key": "token",
      "value": "abc123"
    }
  ],
  "item": [
    {
      "name": "Get Users",
      "request": {
        "method": "GET",
        "auth": {
          "type": "bearer",
          "bearer": [
            {
              "key": "token",
              "value": "{{token}}",
              "type": "string"
            }
          ]
        },
        "header": [],
        "url": {
          "raw": "{{base_url}}/users?limit=10",
          "query": [
            {
              "key": "limit",
              "value": "10"
            }
          ]
        }
      },
      "response": []
    }
  ]
}
''';

      final result = postmanIO.getHttpRequestModelList(content);

      expect(result, isNotNull);
      expect(result!.length, 1);
      expect(result.first.$1, 'Get Users');

      final request = result.first.$2;
      expect(request.url, 'https://api.example.com/users');
      expect(
        request.params,
        [const NameValueModel(name: 'limit', value: '10')],
      );
      expect(
        request.authModel,
        const AuthModel(
          type: APIAuthType.bearer,
          bearer: AuthBearerModel(token: 'abc123'),
        ),
      );
    });

    test('maps urlencoded body as text form rows', () {
      const content = r'''
{
  "info": {
    "name": "Urlencoded Body",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Token Request",
      "request": {
        "method": "POST",
        "header": [],
        "body": {
          "mode": "urlencoded",
          "urlencoded": [
            {
              "key": "grant_type",
              "value": "client_credentials",
              "type": "text"
            },
            {
              "key": "scope",
              "value": "read write",
              "type": "text"
            }
          ]
        },
        "url": {
          "raw": "https://auth.example.com/oauth/token"
        }
      },
      "response": []
    }
  ]
}
''';

      final result = postmanIO.getHttpRequestModelList(content);

      expect(result, isNotNull);
      final request = result!.first.$2;

      expect(request.bodyContentType, ContentType.formdata);
      expect(
        request.formData,
        const [
          FormDataModel(
            name: 'grant_type',
            value: 'client_credentials',
            type: FormDataType.text,
          ),
          FormDataModel(
            name: 'scope',
            value: 'read write',
            type: FormDataType.text,
          ),
        ],
      );
    });

    test('keeps unresolved placeholders unchanged', () {
      const content = r'''
{
  "info": {
    "name": "Missing Variable",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "variable": [
    {
      "key": "base_url",
      "value": "https://api.example.com"
    }
  ],
  "item": [
    {
      "name": "Get One User",
      "request": {
        "method": "GET",
        "header": [
          {
            "key": "X-Trace",
            "value": "{{trace_id}}"
          }
        ],
        "url": {
          "raw": "{{base_url}}/users/{{user_id}}"
        }
      },
      "response": []
    }
  ]
}
''';

      final result = postmanIO.getHttpRequestModelList(content);

      expect(result, isNotNull);
      final request = result!.first.$2;

      expect(request.url, 'https://api.example.com/users/{{user_id}}');
      expect(
        request.headers,
        [const NameValueModel(name: 'X-Trace', value: '{{trace_id}}')],
      );
    });
  });
}
