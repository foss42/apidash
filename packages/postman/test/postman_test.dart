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

    test('Postman Body parses urlencoded params', () {
      final collection = PostmanCollection.fromJson({
        'item': [
          {
            'request': {
              'body': {
                'mode': 'urlencoded',
                'urlencoded': [
                  {'key': 'username', 'value': 'admin', 'type': 'text'},
                  {'key': 'password', 'value': 'secret123', 'type': 'text'},
                ],
              },
            },
          },
        ],
      });

      final body = collection.item!.single.request!.body!;
      expect(body.mode, 'urlencoded');
      expect(body.urlencoded, hasLength(2));
      expect(body.urlencoded!.first.key, 'username');
      expect(body.urlencoded!.first.value, 'admin');
      expect(body.urlencoded!.last.key, 'password');
      expect(body.urlencoded!.last.value, 'secret123');
    });
  });
}
