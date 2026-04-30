import 'package:postman/postman.dart';
import 'package:test/test.dart';

import 'collection_examples/collection_apidash.dart';
import 'models/collection_apidash_model.dart';

void main() {
  group('Postman tests', () {
    test('API Dash Postman collection from Json String', () {
      expect(postmanCollectionFromJsonStr(collectionApiDashJsonStr),
          collectionApiDashModel);
    });

    test('API Dash Postman collection from Json', () {
      expect(PostmanCollection.fromJson(collectionApiDashJson),
          collectionApiDashModel);
    });

    test('API Dash Postman collection to Json String', () {
      expect(postmanCollectionToJsonStr(collectionApiDashModel),
          collectionApiDashJsonStr);
    });

    test('API Dash Postman collection to Json', () {
      expect(collectionApiDashModel.toJson(), collectionApiDashJson);
    });

    test('Postman collection parses variables, auth, and urlencoded body', () {
      const jsonStr = r'''
{
  "info": {
    "name": "Auth + Variables",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "variable": [
    {
      "key": "base_url",
      "value": "https://api.example.com",
      "type": "string"
    }
  ],
  "item": [
    {
      "name": "Token",
      "request": {
        "method": "POST",
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
        "body": {
          "mode": "urlencoded",
          "urlencoded": [
            {
              "key": "grant_type",
              "value": "client_credentials",
              "type": "text"
            }
          ]
        },
        "url": {
          "raw": "{{base_url}}/oauth/token"
        }
      }
    }
  ]
}
''';

      final collection = postmanCollectionFromJsonStr(jsonStr);
      final request = collection.item!.first.request!;

      expect(collection.variable, isNotNull);
      expect(collection.variable!.first.key, 'base_url');
      expect(request.auth, isNotNull);
      expect(request.auth!.type, 'bearer');
      expect(request.body?.mode, 'urlencoded');
      expect(request.body?.urlencoded, isNotNull);
      expect(request.body?.urlencoded?.first.key, 'grant_type');
    });

    test('Postman collection keeps new fields in round-trip serialization', () {
      final collection = PostmanCollection(
        info: const Info(name: 'Roundtrip'),
        variable: const [
          Variable(key: 'base_url', value: 'https://api.example.com')
        ],
        item: const [
          Item(
            name: 'With auth',
            request: Request(
              method: 'GET',
              auth: PostmanAuth(
                type: 'apikey',
                apikey: [
                  AuthKeyValue(key: 'key', value: 'x-api-key'),
                  AuthKeyValue(key: 'value', value: '{{api_key}}'),
                  AuthKeyValue(key: 'in', value: 'header'),
                ],
              ),
              body: Body(
                mode: 'urlencoded',
                urlencoded: [
                  Urlencoded(
                      key: 'client_id', value: '{{client_id}}', type: 'text'),
                ],
              ),
              url: Url(raw: '{{base_url}}/v1/items'),
            ),
          ),
        ],
      );

      final serialized = postmanCollectionToJsonStr(collection);
      final parsed = postmanCollectionFromJsonStr(serialized);

      expect(parsed, collection);
    });
  });
}
