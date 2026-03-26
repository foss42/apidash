// test/models/history_request_model_test.dart
import 'package:test/test.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash_core/apidash_core.dart';
import 'history_meta_models.dart';
import 'http_response_models.dart';

void main() {
  group("Testing HistoryRequestModel", () {
    test('Testing toJson', () {
      expect(testHistoryRequestModel.toJson(), historyRequestModelJson);
    });

    test('Testing fromJson', () {
      final modelFromJson =
          HistoryRequestModel.fromJson(historyRequestModelJson);
      expect(modelFromJson, testHistoryRequestModel);
    });

    test('Testing round-trip fromJson(toJson())', () {
      final json = testHistoryRequestModel.toJson();
      final roundTripped = HistoryRequestModel.fromJson(json);
      expect(roundTripped, testHistoryRequestModel);
    });

    test('Testing copyWith on historyId', () {
      final copy = testHistoryRequestModel.copyWith(historyId: 'hist-new');
      expect(copy.historyId, 'hist-new');
      // Original unchanged
      expect(testHistoryRequestModel.historyId, 'hist-1');
    });

    test('Testing copyWith on metaData', () {
      final newMeta = testHistoryMetaModel.copyWith(name: 'New Name');
      final copy = testHistoryRequestModel.copyWith(metaData: newMeta);
      expect(copy.metaData.name, 'New Name');
      expect(testHistoryRequestModel.metaData.name, 'Test Request');
    });

    test('Testing optional fields default to null', () {
      expect(testHistoryRequestModel.preRequestScript, isNull);
      expect(testHistoryRequestModel.postRequestScript, isNull);
      expect(testHistoryRequestModel.aiRequestModel, isNull);
      expect(testHistoryRequestModel.authModel, isNull);
    });
  });
}
