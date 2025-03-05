import 'package:insomnia_collection/insomnia_collection.dart';
import 'collection_examples/collection_apidash.dart';
import 'models/collection_apidash_model.dart';
import 'package:test/test.dart';

void main() {
  group('Insomnia tests', () {
    test('Insomnia collection from Json String', () {
      expect(
        insomniaCollectionFromJsonStr(collectionApiDashJsonStr),
        collectionApiDashModel,
      );
    });

    test('Insomnia collection from Json', () {
      expect(
        InsomniaCollection.fromJson(collectionApiDashJson),
        collectionApiDashModel,
      );
    });

    test('Insomnia collection to Json String', () {
      expect(
        insomniaCollectionToJsonStr(collectionApiDashModel),
        collectionApiDashJsonStr,
      );
    });
  });
}
