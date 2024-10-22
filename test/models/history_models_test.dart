import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';
import 'package:apidash/models/models.dart';
import 'history_models.dart';
import 'http_request_models.dart';
import 'http_response_models.dart';

void main() {
  group('Testing History Meta Models', () {
    test("Testing HistoryMetaModel copyWith", () {
      var historyMetaModel = historyMetaModel1;
      final historyMetaModelcopyWith = historyMetaModel.copyWith(
        url: 'https://api.apidash.dev/humanize/social',
      );
      expect(historyMetaModelcopyWith.url,
          'https://api.apidash.dev/humanize/social');
      // original model unchanged
      expect(historyMetaModel.url, 'https://api.apidash.dev/humanize/social');
    });

    test("Testing HistoryMetaModel toJson", () {
      var historyMetaModel = historyMetaModel1;
      expect(historyMetaModel.toJson(), historyMetaModelJson1);
    });

    test("Testing HistoryMetaModel fromJson", () {
      var historyMetaModel = historyMetaModel1;
      final modelFromJson = HistoryMetaModel.fromJson(historyMetaModelJson1);
      expect(modelFromJson, historyMetaModel);
      expect(modelFromJson.timeStamp, DateTime(2024, 1, 1));
      expect(modelFromJson.responseStatus, 200);
    });

    test("Testing HistoryMetaModel getters", () {
      var historyMetaModel = historyMetaModel1;
      expect(historyMetaModel.historyId, 'historyId1');
      expect(historyMetaModel.requestId, 'requestId1');
      expect(historyMetaModel.url, 'https://api.apidash.dev/humanize/social');
      expect(historyMetaModel.method, HTTPVerb.get);
      expect(historyMetaModel.timeStamp, DateTime(2024, 1, 1));
      expect(historyMetaModel.responseStatus, 200);
    });
  });

  group('Testing History Request Models', () {
    test("Testing HistoryRequestModel copyWith", () {
      var historyRequestModel = historyRequestModel1;
      final historyRequestModelcopyWith = historyRequestModel.copyWith(
        metaData: historyMetaModel2,
      );
      expect(historyRequestModelcopyWith.metaData, historyMetaModel2);
      // original model unchanged
      expect(historyRequestModel.metaData, historyMetaModel1);
    });

    test("Testing HistoryRequestModel toJson", () {
      var historyRequestModel = historyRequestModel1;
      expect(historyRequestModel.toJson(), historyRequestModelJson1);
    });

    test("Testing HistoryRequestModel fromJson", () {
      var historyRequestModel = historyRequestModel1;
      final modelFromJson =
          HistoryRequestModel.fromJson(historyRequestModelJson1);
      expect(modelFromJson, historyRequestModel);
      expect(modelFromJson.metaData, historyMetaModel1);
      expect(modelFromJson.httpRequestModel, httpRequestModelGet4);
      expect(modelFromJson.httpResponseModel, responseModel);
    });

    test("Testing HistoryRequestModel getters", () {
      var historyRequestModel = historyRequestModel1;
      expect(historyRequestModel.historyId, 'historyId1');
      expect(historyRequestModel.metaData, historyMetaModel1);
      expect(historyRequestModel.httpRequestModel, httpRequestModelGet4);
      expect(historyRequestModel.httpResponseModel, responseModel);
    });
  });
}
