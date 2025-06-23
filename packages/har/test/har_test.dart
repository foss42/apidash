import 'package:har/har.dart';
import 'package:test/test.dart';

import 'collection_examples/collection_apidash.dart';
import 'models/collection_apidash_model.dart';

void main() {
  group('Har tests', () {
    test('API Dash Har Requests from Json String', () {
      expect(harLogFromJsonStr(collectionJsonStr), collectionApiDashModel);
    });

    test('API Dash Har Requests from Json', () {
      expect(HarLog.fromJson(collectionJson), collectionApiDashModel);
    });

    test('API Dash Har Requests to Json String', () {
      expect(harLogToJsonStr(collectionApiDashModel), collectionJsonStr);
    });

    test('API Dash Har Requests to Json', () {
      expect(collectionApiDashModel.toJson(), collectionJson);
    });
  });
}
