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
  });
}
