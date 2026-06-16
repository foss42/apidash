import 'package:apidash/models/models.dart';
import 'package:apidash_core/apidash_core.dart';

final wsMessage1 = WebSocketMessage(
  payload: 'Hello',
  timestamp: DateTime.parse('2023-01-01T00:00:00.000'),
  outgoing: true,
  messageType: WebSocketMessageType.sent,
);

const wsMessage1Json = {
  'payload': 'Hello',
  'timestamp': '2023-01-01T00:00:00.000',
  'outgoing': true,
  'messageType': 'sent',
};

final wsMessage2 = WebSocketMessage(
  payload: 'Hi',
  timestamp: DateTime.parse('2023-01-01T00:00:00.000'),
  outgoing: false,
  messageType: WebSocketMessageType.received,
);

const wsMessage2Json = {
  'payload': 'Hi',
  'timestamp': '2023-01-01T00:00:00.000',
  'outgoing': false,
  'messageType': 'received',
};

const wsMessage3 = WebSocketMessage(payload: 'Test');

final wsRequestModel1 = WebSocketRequestModel(
  url: 'wss://echo.websocket.org',
  messageHistory: [
    WebSocketMessage(
      payload: 'Ping',
      timestamp: DateTime.parse('2023-01-01T00:00:00.000'),
      outgoing: true,
      messageType: WebSocketMessageType.sent,
    ),
  ],
  headers: const [NameValueModel(name: 'Auth', value: 'Bearer 123')],
  isHeaderEnabledList: const [true],
  params: const [NameValueModel(name: 'id', value: '1')],
  isParamEnabledList: const [true],
  autoReconnect: true,
  enableHeartbeat: true,
  heartbeatInterval: 15,
);

const wsRequestModel1Json = {
  'url': 'wss://echo.websocket.org',
  'messageHistory': [
    {
      'payload': 'Ping',
      'timestamp': '2023-01-01T00:00:00.000',
      'outgoing': true,
      'messageType': 'sent',
    }
  ],
  'headers': [
    {'name': 'Auth', 'value': 'Bearer 123'}
  ],
  'isHeaderEnabledList': [true],
  'params': [
    {'name': 'id', 'value': '1'}
  ],
  'isParamEnabledList': [true],
  'autoReconnect': true,
  'enableHeartbeat': true,
  'heartbeatInterval': 15,
};

const wsRequestModel2Json = {
  'url': 'wss://echo.websocket.org',
  'messageHistory': [],
  'headers': null,
  'isHeaderEnabledList': null,
  'params': null,
  'isParamEnabledList': null,
  'autoReconnect': false,
  'enableHeartbeat': false,
  'heartbeatInterval': 30,
};

const wsRequestModel2 = WebSocketRequestModel(
  url: 'wss://echo.websocket.org',
  messageHistory: [],
  autoReconnect: false,
  enableHeartbeat: false,
  heartbeatInterval: 30,
);

const wsRequestModel3 = WebSocketRequestModel();

// A message with a null timestamp (timestamp omitted).
const wsMessageNullTimestamp = WebSocketMessage(
  payload: 'NoTime',
  outgoing: false,
  messageType: WebSocketMessageType.error,
);

const wsMessageNullTimestampJson = {
  'payload': 'NoTime',
  'timestamp': null,
  'outgoing': false,
  'messageType': 'error',
};

// One message fixture per WebSocketMessageType enum value, with matching JSON.
const wsMessageConnected = WebSocketMessage(
  payload: 'conn',
  messageType: WebSocketMessageType.connected,
);
const wsMessageConnectedJson = {
  'payload': 'conn',
  'timestamp': null,
  'outgoing': true,
  'messageType': 'connected',
};

const wsMessageSent = WebSocketMessage(
  payload: 'snt',
  messageType: WebSocketMessageType.sent,
);
const wsMessageSentJson = {
  'payload': 'snt',
  'timestamp': null,
  'outgoing': true,
  'messageType': 'sent',
};

const wsMessageReceived = WebSocketMessage(
  payload: 'rcv',
  messageType: WebSocketMessageType.received,
);
const wsMessageReceivedJson = {
  'payload': 'rcv',
  'timestamp': null,
  'outgoing': true,
  'messageType': 'received',
};

const wsMessageError = WebSocketMessage(
  payload: 'err',
  messageType: WebSocketMessageType.error,
);
const wsMessageErrorJson = {
  'payload': 'err',
  'timestamp': null,
  'outgoing': true,
  'messageType': 'error',
};

const wsMessageDisconnected = WebSocketMessage(
  payload: 'disc',
  messageType: WebSocketMessageType.disconnected,
);
const wsMessageDisconnectedJson = {
  'payload': 'disc',
  'timestamp': null,
  'outgoing': true,
  'messageType': 'disconnected',
};

// A model whose messageHistory holds multiple messages (covers list round-trip).
final wsRequestModelMultiHistory = WebSocketRequestModel(
  url: 'wss://multi.websocket.org',
  messageHistory: [
    WebSocketMessage(
      payload: 'first',
      timestamp: DateTime.parse('2023-01-01T00:00:00.000'),
      outgoing: true,
      messageType: WebSocketMessageType.sent,
    ),
    WebSocketMessage(
      payload: 'second',
      timestamp: DateTime.parse('2023-01-02T00:00:00.000'),
      outgoing: false,
      messageType: WebSocketMessageType.received,
    ),
    const WebSocketMessage(
      payload: 'third',
      messageType: WebSocketMessageType.error,
    ),
  ],
);

const wsRequestModelMultiHistoryJson = {
  'url': 'wss://multi.websocket.org',
  'messageHistory': [
    {
      'payload': 'first',
      'timestamp': '2023-01-01T00:00:00.000',
      'outgoing': true,
      'messageType': 'sent',
    },
    {
      'payload': 'second',
      'timestamp': '2023-01-02T00:00:00.000',
      'outgoing': false,
      'messageType': 'received',
    },
    {
      'payload': 'third',
      'timestamp': null,
      'outgoing': true,
      'messageType': 'error',
    },
  ],
  'headers': null,
  'isHeaderEnabledList': null,
  'params': null,
  'isParamEnabledList': null,
  'autoReconnect': false,
  'enableHeartbeat': false,
  'heartbeatInterval': 30,
};
