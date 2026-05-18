import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/models/models.dart';
import 'http_request_models.dart';
import 'http_response_models.dart';

/// Test fixture for HistoryMetaModel
final testHistoryMetaModel = HistoryMetaModel(
  historyId: 'hist-1',
  requestId: 'req-1',
  apiType: APIType.rest,
  name: 'Test Request',
  url: 'https://api.apidash.dev',
  method: HTTPVerb.get,
  responseStatus: 200,
  timeStamp: DateTime(2026, 3, 26, 12, 0, 0),
);

/// Expected JSON output for testHistoryMetaModel
final Map<String, dynamic> historyMetaModelJson = {
  'historyId': 'hist-1',
  'requestId': 'req-1',
  'apiType': 'rest',
  'name': 'Test Request',
  'url': 'https://api.apidash.dev',
  'method': 'get',
  'responseStatus': 200,
  'timeStamp': '2026-03-26T12:00:00.000',
};

/// HistoryMetaModel with empty name (uses default)
final testHistoryMetaModelNoName = HistoryMetaModel(
  historyId: 'hist-2',
  requestId: 'req-2',
  apiType: APIType.rest,
  url: 'https://api.apidash.dev/case/lower',
  method: HTTPVerb.post,
  responseStatus: 201,
  timeStamp: DateTime(2026, 3, 26, 14, 30, 0),
);

/// Test fixture for HistoryRequestModel
final testHistoryRequestModel = HistoryRequestModel(
  historyId: 'hist-1',
  metaData: testHistoryMetaModel,
  httpRequestModel: httpRequestModelGet1,
  httpResponseModel: responseModel,
);

/// Expected JSON output for testHistoryRequestModel
final Map<String, dynamic> historyRequestModelJson = {
  'historyId': 'hist-1',
  'metaData': historyMetaModelJson,
  'httpRequestModel': const HttpRequestModel(
    method: HTTPVerb.get,
    url: 'https://api.apidash.dev',
  ).toJson(),
  'aiRequestModel': null,
  'httpResponseModel': responseModelJson,
  'preRequestScript': null,
  'postRequestScript': null,
  'authModel': null,
};
