// test/models/history_meta_model_test.dart
import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';
import 'package:apidash/models/models.dart';
import 'history_meta_models.dart';

void main() {
  group("Testing HistoryMetaModel", () {
    test('Testing toJson', () {
      expect(testHistoryMetaModel.toJson(), historyMetaModelJson);
    });

    test('Testing fromJson', () {
      final modelFromJson = HistoryMetaModel.fromJson(historyMetaModelJson);
      expect(modelFromJson, testHistoryMetaModel);
    });

    test('Testing round-trip fromJson(toJson())', () {
      final json = testHistoryMetaModel.toJson();
      final roundTripped = HistoryMetaModel.fromJson(json);
      expect(roundTripped, testHistoryMetaModel);
    });

    test('Testing copyWith', () {
      final copy = testHistoryMetaModel.copyWith(name: 'Updated Name');
      expect(copy.name, 'Updated Name');
      // Original is unchanged (immutability)
      expect(testHistoryMetaModel.name, 'Test Request');
    });

    test('Testing copyWith preserves other fields', () {
      final copy = testHistoryMetaModel.copyWith(responseStatus: 404);
      expect(copy.responseStatus, 404);
      expect(copy.historyId, 'hist-1');
      expect(copy.requestId, 'req-1');
      expect(copy.url, 'https://api.apidash.dev');
      expect(copy.method, HTTPVerb.get);
    });

    test('Testing default empty name', () {
      expect(testHistoryMetaModelNoName.name, '');
    });
  });
}
