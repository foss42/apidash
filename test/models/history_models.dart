import 'package:apidash/models/models.dart'
    show HistoryMetaModel, HistoryRequestModel;
import 'package:apidash_core/apidash_core.dart';

import 'http_request_models.dart';
import 'http_response_models.dart';

/// Basic History Meta model 1
final historyMetaModel1 = HistoryMetaModel(
  historyId: 'historyId1',
  requestId: 'requestId1',
  apiType: APIType.rest,
  url: 'https://api.apidash.dev/humanize/social',
  method: HTTPVerb.get,
  timeStamp: DateTime(2024, 1, 1),
  responseStatus: 200,
);

/// Basic History Request model 1
final historyRequestModel1 = HistoryRequestModel(
    historyId: 'historyId1',
    metaData: historyMetaModel1,
    httpRequestModel: httpRequestModelGet4,
    httpResponseModel: responseModel,
    authModel: AuthModel(type: APIAuthType.none));

final historyMetaModel2 = HistoryMetaModel(
  historyId: 'historyId2',
  requestId: 'requestId2',
  apiType: APIType.rest,
  url: 'https://api.apidash.dev/case/lower',
  method: HTTPVerb.post,
  timeStamp: DateTime(2024, 1, 1),
  responseStatus: 200,
);

final historyRequestModel2 = HistoryRequestModel(
    historyId: 'historyId2',
    metaData: historyMetaModel2,
    httpRequestModel: httpRequestModelPost10,
    httpResponseModel: responseModel,
    authModel: AuthModel(type: APIAuthType.none));

/// JSONs
final Map<String, dynamic> historyMetaModelJson1 = {
  "historyId": "historyId1",
  "requestId": "requestId1",
  "apiType": "rest",
  "name": "",
  "url": "https://api.apidash.dev/humanize/social",
  "method": "get",
  "timeStamp": '2024-01-01T00:00:00.000',
  "responseStatus": 200,
};

final Map<String, dynamic> historyRequestModelJson1 = {
  "historyId": "historyId1",
  "metaData": historyMetaModelJson1,
  "httpRequestModel": httpRequestModelGet4Json,
  'aiRequestModel': null,
  "httpResponseModel": responseModelJson,
  'preRequestScript': null,
  'postRequestScript': null,
  'authModel': {
    'type': 'none',
    'apikey': null,
    'bearer': null,
    'basic': null,
    'jwt': null,
    'digest': null,
    'oauth1': null,
    'oauth2': null
  }
};

final Map<String, dynamic> historyMetaModelJson2 = {
  "historyId": "historyId2",
  "requestId": "requestId2",
  "apiType": "rest",
  "name": "",
  "url": "https://api.apidash.dev/case/lower",
  "method": "post",
  "timeStamp": '2024-01-01T00:00:00.000',
  "responseStatus": 200,
};

final Map<String, dynamic> historyRequestModelJson2 = {
  "historyId": "historyId2",
  "metaData": historyMetaModelJson2,
  "httpRequestModel": httpRequestModelPost10Json,
  "httpResponseModel": responseModelJson,
};
