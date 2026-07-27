import 'package:apidash/models/models.dart'
    show
        HistoryMetaModel,
        HistoryRequestModel,
        WebSocketRequestModel,
        WebSocketMessage,
        WebSocketMessageType,
        GrpcRequestModel,
        GrpcStreamingType;
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
  authModel: AuthModel(type: APIAuthType.none),
);

final historyMetaModel2 = HistoryMetaModel(
  historyId: 'historyId2',
  requestId: 'requestId2',
  apiType: APIType.rest,
  url: 'https://api.apidash.dev/case/lower',
  method: HTTPVerb.post,
  timeStamp: DateTime(2024, 1, 1),
  responseStatus: 200,
);

/// WebSocket History Meta model
final historyMetaModelWs = HistoryMetaModel(
  historyId: 'historyIdWs',
  requestId: 'requestIdWs',
  apiType: APIType.websocket,
  url: 'wss://echo.websocket.org',
  method: HTTPVerb.get,
  timeStamp: DateTime(2024, 1, 1),
  responseStatus: 0,
);

/// WebSocket request model fixture for history (default/empty messageHistory so
/// the toJson -> fromJson round-trip is unambiguous).
const historyWsRequestModel = WebSocketRequestModel(
  url: 'wss://echo.websocket.org',
  headers: [NameValueModel(name: 'Auth', value: 'Bearer 123')],
  isHeaderEnabledList: [true],
  params: [NameValueModel(name: 'id', value: '1')],
  isParamEnabledList: [true],
  autoReconnect: true,
  enableHeartbeat: true,
  heartbeatInterval: 15,
);

/// WebSocket History Request model carrying a non-null wsRequestModel.
final historyRequestModelWs = HistoryRequestModel(
  historyId: 'historyIdWs',
  metaData: historyMetaModelWs,
  wsRequestModel: historyWsRequestModel,
  authModel: AuthModel(type: APIAuthType.none),
);

/// gRPC History Meta model
final historyMetaModelGrpc = HistoryMetaModel(
  historyId: 'historyIdGrpc',
  requestId: 'requestIdGrpc',
  apiType: APIType.grpc,
  url: 'localhost:50051',
  method: HTTPVerb.get, // gRPC has no HTTP verb; mirrors WebSocket default
  timeStamp: DateTime(2024, 1, 1),
  responseStatus: 0,
);

/// gRPC request model fixture for history. Carries service/method/streamingType,
/// a couple of messageHistory entries (WebSocketMessage) and some metadata
/// (NameValueModel) so the toJson -> fromJson round-trip is meaningful.
/// timestamps are left null so the whole fixture stays `const` and the
/// round-trip is unambiguous.
const historyGrpcRequestModel = GrpcRequestModel(
  url: 'localhost:50051',
  service: 'GreeterService',
  method: 'SayHello',
  streamingType: GrpcStreamingType.bidi,
  requestBody: '{"name":"Dash"}',
  useReflection: true,
  messageHistory: [
    WebSocketMessage(
      payload: 'Connected to gRPC host: localhost:50051',
      outgoing: false,
      messageType: WebSocketMessageType.connected,
    ),
    WebSocketMessage(
      payload: '{"name":"Dash"}',
      outgoing: true,
      messageType: WebSocketMessageType.sent,
    ),
  ],
  metadata: [
    NameValueModel(name: 'Authorization', value: 'Bearer token'),
    NameValueModel(name: 'x-trace-id', value: 'abc-123'),
  ],
  isMetadataEnabled: [true, false],
);

/// gRPC History Request model carrying a non-null grpcRequestModel.
final historyRequestModelGrpc = HistoryRequestModel(
  historyId: 'historyIdGrpc',
  metaData: historyMetaModelGrpc,
  grpcRequestModel: historyGrpcRequestModel,
  authModel: AuthModel(type: APIAuthType.none),
);

final historyRequestModel2 = HistoryRequestModel(
  historyId: 'historyId2',
  metaData: historyMetaModel2,
  httpRequestModel: httpRequestModelPost10,
  httpResponseModel: responseModel,
  authModel: AuthModel(type: APIAuthType.none),
);

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
  'wsRequestModel': null,
  'grpcRequestModel': null,
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
    'oauth2': null,
  },
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

/// WebSocket History Meta JSON
final Map<String, dynamic> historyMetaModelWsJson = {
  "historyId": "historyIdWs",
  "requestId": "requestIdWs",
  "apiType": "websocket",
  "name": "",
  "url": "wss://echo.websocket.org",
  "method": "get",
  "timeStamp": '2024-01-01T00:00:00.000',
  "responseStatus": 0,
};

/// Expected JSON for the WS wsRequestModel fixture.
/// Note: `messageHistory` IS persisted to JSON (serialized as a list), so the
/// default empty history shows up here as an empty list.
final Map<String, dynamic> historyWsRequestModelJson = {
  'url': 'wss://echo.websocket.org',
  'messageHistory': [],
  'headers': [
    {'name': 'Auth', 'value': 'Bearer 123'},
  ],
  'isHeaderEnabledList': [true],
  'params': [
    {'name': 'id', 'value': '1'},
  ],
  'isParamEnabledList': [true],
  'autoReconnect': true,
  'enableHeartbeat': true,
  'heartbeatInterval': 15,
};

/// Expected JSON for the WS HistoryRequestModel fixture.
final Map<String, dynamic> historyRequestModelWsJson = {
  "historyId": "historyIdWs",
  "metaData": historyMetaModelWsJson,
  'httpRequestModel': null,
  'aiRequestModel': null,
  'wsRequestModel': historyWsRequestModelJson,
  'grpcRequestModel': null,
  "httpResponseModel": null,
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
    'oauth2': null,
  },
};

final Map<String, dynamic> historyRequestModelJson2 = {
  "historyId": "historyId2",
  "metaData": historyMetaModelJson2,
  "httpRequestModel": httpRequestModelPost10Json,
  "httpResponseModel": responseModelJson,
};
