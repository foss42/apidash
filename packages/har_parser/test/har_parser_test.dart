import 'package:har_parser/har_parser.dart';
import 'package:test/test.dart';

import 'collection_examples/collection_apidash.dart';
import 'models/collection_apidash_model.dart';

void main() {
  group('Postman tests', () {
    test('API Dash Postman collection from Json String', () {
      expect(harLogFromJsonStr(collectionJsonStr), collectionApiDashModel);
    });

    test('API Dash Postman collection from Json', () {
      expect(HarLog.fromJson(collectionJson), collectionApiDashModel);
    });

    test('API Dash Postman collection to Json String', () {
      expect(harLogToJsonStr(collectionApiDashModel), collectionJsonStr);
    });

    test('API Dash Postman collection to Json', () {
      expect(collectionApiDashModel.toJson(), collectionJson);
    });
  });
}
