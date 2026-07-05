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
      expect(
        historyMetaModelcopyWith.url,
        'https://api.apidash.dev/humanize/social',
      );
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
      final modelFromJson = HistoryRequestModel.fromJson(
        historyRequestModelJson1,
      );
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

  group('Testing History Meta Models (WebSocket)', () {
    test("Testing HistoryMetaModel copyWith", () {
      var historyMetaModel = historyMetaModelWs;
      final historyMetaModelcopyWith = historyMetaModel.copyWith(
        url: 'wss://changed.websocket.org',
      );
      expect(historyMetaModelcopyWith.url, 'wss://changed.websocket.org');
      // other fields preserved
      expect(historyMetaModelcopyWith.apiType, APIType.websocket);
      expect(historyMetaModelcopyWith.method, HTTPVerb.get);
      expect(historyMetaModelcopyWith.responseStatus, 0);
      // original model unchanged
      expect(historyMetaModel.url, 'wss://echo.websocket.org');
    });

    test("Testing HistoryMetaModel toJson", () {
      var historyMetaModel = historyMetaModelWs;
      expect(historyMetaModel.toJson(), historyMetaModelWsJson);
    });

    test("Testing HistoryMetaModel fromJson", () {
      var historyMetaModel = historyMetaModelWs;
      final modelFromJson = HistoryMetaModel.fromJson(historyMetaModelWsJson);
      expect(modelFromJson, historyMetaModel);
      expect(modelFromJson.apiType, APIType.websocket);
      expect(modelFromJson.timeStamp, DateTime(2024, 1, 1));
      expect(modelFromJson.responseStatus, 0);
    });

    test("Testing HistoryMetaModel getters", () {
      var historyMetaModel = historyMetaModelWs;
      expect(historyMetaModel.historyId, 'historyIdWs');
      expect(historyMetaModel.requestId, 'requestIdWs');
      expect(historyMetaModel.apiType, APIType.websocket);
      expect(historyMetaModel.url, 'wss://echo.websocket.org');
      expect(historyMetaModel.method, HTTPVerb.get);
      expect(historyMetaModel.timeStamp, DateTime(2024, 1, 1));
      expect(historyMetaModel.responseStatus, 0);
    });
  });

  group('Testing History Request Models (WebSocket)', () {
    test("Testing HistoryRequestModel copyWith", () {
      var historyRequestModel = historyRequestModelWs;
      final historyRequestModelcopyWith = historyRequestModel.copyWith(
        historyId: 'historyIdWsChanged',
      );
      expect(historyRequestModelcopyWith.historyId, 'historyIdWsChanged');
      // other fields preserved
      expect(historyRequestModelcopyWith.metaData, historyMetaModelWs);
      expect(
          historyRequestModelcopyWith.wsRequestModel, historyWsRequestModel);
      expect(historyRequestModelcopyWith.httpRequestModel, isNull);
      // original model unchanged
      expect(historyRequestModel.historyId, 'historyIdWs');
    });

    test("Testing HistoryRequestModel toJson", () {
      var historyRequestModel = historyRequestModelWs;
      final json = historyRequestModel.toJson();
      expect(json, historyRequestModelWsJson);
      // wsRequestModel is serialized; httpRequestModel is null.
      expect(json['wsRequestModel'], historyWsRequestModelJson);
      expect(json['httpRequestModel'], isNull);
    });

    test("Testing HistoryRequestModel fromJson", () {
      var historyRequestModel = historyRequestModelWs;
      final modelFromJson =
          HistoryRequestModel.fromJson(historyRequestModelWsJson);
      expect(modelFromJson, historyRequestModel);
      expect(modelFromJson.metaData, historyMetaModelWs);
      expect(modelFromJson.metaData.apiType, APIType.websocket);
      expect(modelFromJson.httpRequestModel, isNull);
      // wsRequestModel persisted fields survive the round-trip.
      final ws = modelFromJson.wsRequestModel!;
      expect(ws.url, 'wss://echo.websocket.org');
      expect(ws.headers, [const NameValueModel(name: 'Auth', value: 'Bearer 123')]);
      expect(ws.isHeaderEnabledList, [true]);
      expect(ws.params, [const NameValueModel(name: 'id', value: '1')]);
      expect(ws.isParamEnabledList, [true]);
      expect(ws.autoReconnect, true);
      expect(ws.enableHeartbeat, true);
      expect(ws.heartbeatInterval, 15);
      // messageHistory is round-tripped via JSON; default fixture is empty.
      expect(ws.messageHistory, isEmpty);
    });

    test("Testing HistoryRequestModel getters", () {
      var historyRequestModel = historyRequestModelWs;
      expect(historyRequestModel.historyId, 'historyIdWs');
      expect(historyRequestModel.metaData, historyMetaModelWs);
      expect(historyRequestModel.wsRequestModel, historyWsRequestModel);
      expect(historyRequestModel.httpRequestModel, isNull);
      expect(historyRequestModel.httpResponseModel, isNull);
    });
  });
}
