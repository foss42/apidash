import 'package:apidash/models/models.dart';
import 'package:apidash_core/apidash_core.dart';

/// A minimal MQTT model carrying only the required `brokerUrl`. Used to assert
/// that every other field falls back to its declared default.
const mqttRequestModelDefaults =
    MQTTRequestModel(brokerUrl: 'mqtt://broker.hivemq.com');

/// Expected JSON for [mqttRequestModelDefaults] — every default serialized.
const mqttRequestModelDefaultsJson = {
  'brokerUrl': 'mqtt://broker.hivemq.com',
  'port': 1883,
  'clientId': null,
  'username': null,
  'password': null,
  'version': 'v5',
  'subscribedTopics': <Map<String, dynamic>>[],
  'isTopicEnabledList': <bool>[],
  'useTLS': false,
  'useWebSocket': false,
  'qos': 0,
  'messageHistory': <Map<String, dynamic>>[],
  'message': '',
  'publishTopic': '',
  'allowInvalidCertificates': false,
  'userProperties': <Map<String, dynamic>>[],
  'isUserPropertyEnabledList': <bool>[],
  'responseTopic': '',
  'correlationData': '',
  'sessionExpiryInterval': 0,
  'messageExpiryInterval': 0,
  'keepAlivePeriod': 60,
  'retainMessage': false,
  'willTopic': '',
  'willMessage': '',
  'willRetain': false,
  'willQos': 0,
};

/// A fully-populated MQTT v5 model exercising subscribedTopics, userProperties,
/// messageHistory and all the v5-only fields.
final mqttRequestModelFull = MQTTRequestModel(
  brokerUrl: 'mqtts://broker.example.org',
  port: 8883,
  clientId: 'apidash-client-1',
  username: 'user',
  password: 'pass',
  version: MQTTVersion.v5,
  subscribedTopics: const [
    NameValueModel(name: 'sensors/temp', value: 'q0'),
    NameValueModel(name: 'sensors/humidity', value: 'q1'),
  ],
  isTopicEnabledList: const [true, false],
  useTLS: true,
  useWebSocket: true,
  qos: 2,
  messageHistory: [
    WebSocketMessage(
      payload: 'hello',
      timestamp: DateTime.parse('2023-01-01T00:00:00.000'),
      outgoing: true,
      messageType: WebSocketMessageType.sent,
      metadata: 'sensors/temp',
    ),
    const WebSocketMessage(
      payload: 'world',
      messageType: WebSocketMessageType.received,
      outgoing: false,
      metadata: 'sensors/humidity',
    ),
  ],
  message: 'payload-body',
  publishTopic: 'devices/cmd',
  allowInvalidCertificates: true,
  userProperties: const [
    NameValueModel(name: 'app', value: 'apidash'),
    NameValueModel(name: 'env', value: 'test'),
  ],
  isUserPropertyEnabledList: const [true, true],
  responseTopic: 'devices/resp',
  correlationData: 'corr-123',
  sessionExpiryInterval: 3600,
  messageExpiryInterval: 60,
  keepAlivePeriod: 120,
  retainMessage: true,
  willTopic: 'lwt/topic',
  willMessage: 'lwt-msg',
  willRetain: true,
  willQos: 1,
);

/// Expected JSON for [mqttRequestModelFull].
const mqttRequestModelFullJson = {
  'brokerUrl': 'mqtts://broker.example.org',
  'port': 8883,
  'clientId': 'apidash-client-1',
  'username': 'user',
  'password': 'pass',
  'version': 'v5',
  'subscribedTopics': [
    {'name': 'sensors/temp', 'value': 'q0'},
    {'name': 'sensors/humidity', 'value': 'q1'},
  ],
  'isTopicEnabledList': [true, false],
  'useTLS': true,
  'useWebSocket': true,
  'qos': 2,
  'messageHistory': [
    {
      'payload': 'hello',
      'timestamp': '2023-01-01T00:00:00.000',
      'outgoing': true,
      'messageType': 'sent',
      'metadata': 'sensors/temp',
    },
    {
      'payload': 'world',
      'timestamp': null,
      'outgoing': false,
      'messageType': 'received',
      'metadata': 'sensors/humidity',
    },
  ],
  'message': 'payload-body',
  'publishTopic': 'devices/cmd',
  'allowInvalidCertificates': true,
  'userProperties': [
    {'name': 'app', 'value': 'apidash'},
    {'name': 'env', 'value': 'test'},
  ],
  'isUserPropertyEnabledList': [true, true],
  'responseTopic': 'devices/resp',
  'correlationData': 'corr-123',
  'sessionExpiryInterval': 3600,
  'messageExpiryInterval': 60,
  'keepAlivePeriod': 120,
  'retainMessage': true,
  'willTopic': 'lwt/topic',
  'willMessage': 'lwt-msg',
  'willRetain': true,
  'willQos': 1,
};

/// A v3.1.1 model used to assert the enum string mapping round-trips.
const mqttRequestModelV311 = MQTTRequestModel(
  brokerUrl: 'mqtt://legacy.broker',
  version: MQTTVersion.v3_1_1,
);
