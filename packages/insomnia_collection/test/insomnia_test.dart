import 'package:insomnia_collection/insomnia_collection.dart';
import 'collection_examples/collection_apidash.dart';
import 'models/collection_apidash_model.dart';
import 'package:test/test.dart';

void main() {
  group('Insomnia tests', () {
    test('API Dash Insomnia collection from Json String', () {
      expect(insomniaCollectionFromJsonStr(collectionApiDashJsonStr), collectionApiDashModel);
    });

    test('API Dash Insomnia collection from Json', () {
      expect(insomniaCollectionFromJson(collectionApiDashJson),
          collectionApiDashModel);
    });

  });
}
