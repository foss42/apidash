import 'package:apidash/models/models.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';

import 'mqtt_request_models.dart';

void main() {
  group('MQTTRequestModel defaults', () {
    test('Only brokerUrl is required; all other fields take defaults', () {
      const model = MQTTRequestModel(brokerUrl: 'mqtt://broker.hivemq.com');
      expect(model.brokerUrl, 'mqtt://broker.hivemq.com');
      expect(model.port, 1883);
      expect(model.clientId, isNull);
      expect(model.username, isNull);
      expect(model.password, isNull);
      expect(model.version, MQTTVersion.v5);
      expect(model.subscribedTopics, isEmpty);
      expect(model.isTopicEnabledList, isEmpty);
      expect(model.useTLS, false);
      expect(model.useWebSocket, false);
      expect(model.qos, 0);
      expect(model.messageHistory, isEmpty);
      expect(model.message, '');
      expect(model.publishTopic, '');
      // v5 additions
      expect(model.allowInvalidCertificates, false);
      expect(model.userProperties, isEmpty);
      expect(model.isUserPropertyEnabledList, isEmpty);
      expect(model.responseTopic, '');
      expect(model.correlationData, '');
      expect(model.sessionExpiryInterval, 0);
      expect(model.messageExpiryInterval, 0);
      expect(model.keepAlivePeriod, 60);
      expect(model.willTopic, '');
      expect(model.willMessage, '');
      expect(model.willRetain, false);
      expect(model.willQos, 0);
    });
  });

  group('MQTTRequestModel copyWith', () {
    final base = mqttRequestModelDefaults;

    test('copyWith brokerUrl changes only brokerUrl', () {
      final c = base.copyWith(brokerUrl: 'mqtt://changed');
      expect(c.brokerUrl, 'mqtt://changed');
      expect(c.port, base.port);
      expect(c.version, base.version);
      expect(base.brokerUrl, 'mqtt://broker.hivemq.com');
    });

    test('copyWith port changes only port', () {
      final c = base.copyWith(port: 8883);
      expect(c.port, 8883);
      expect(c.brokerUrl, base.brokerUrl);
      expect(c.useTLS, base.useTLS);
      expect(base.port, 1883);
    });

    test('copyWith version changes only version', () {
      final c = base.copyWith(version: MQTTVersion.v3_1_1);
      expect(c.version, MQTTVersion.v3_1_1);
      expect(c.brokerUrl, base.brokerUrl);
      expect(c.port, base.port);
      expect(base.version, MQTTVersion.v5);
    });

    test('copyWith useTLS changes only useTLS', () {
      final c = base.copyWith(useTLS: true);
      expect(c.useTLS, true);
      expect(c.useWebSocket, base.useWebSocket);
      expect(c.brokerUrl, base.brokerUrl);
      expect(base.useTLS, false);
    });

    test('copyWith useWebSocket changes only useWebSocket', () {
      final c = base.copyWith(useWebSocket: true);
      expect(c.useWebSocket, true);
      expect(c.useTLS, base.useTLS);
      expect(base.useWebSocket, false);
    });

    test('copyWith qos changes only qos', () {
      final c = base.copyWith(qos: 2);
      expect(c.qos, 2);
      expect(c.port, base.port);
      expect(base.qos, 0);
    });

    test('copyWith subscribedTopics/isTopicEnabledList', () {
      const topics = [NameValueModel(name: 't', value: 'q0')];
      final c = base.copyWith(
        subscribedTopics: topics,
        isTopicEnabledList: const [true],
      );
      expect(c.subscribedTopics, topics);
      expect(c.isTopicEnabledList, const [true]);
      expect(c.brokerUrl, base.brokerUrl);
      expect(base.subscribedTopics, isEmpty);
    });

    test('copyWith userProperties/isUserPropertyEnabledList', () {
      const props = [NameValueModel(name: 'app', value: 'apidash')];
      final c = base.copyWith(
        userProperties: props,
        isUserPropertyEnabledList: const [true],
      );
      expect(c.userProperties, props);
      expect(c.isUserPropertyEnabledList, const [true]);
      expect(c.version, base.version);
      expect(base.userProperties, isEmpty);
    });

    test('copyWith responseTopic/correlationData', () {
      final c = base.copyWith(responseTopic: 'r/topic', correlationData: 'cid');
      expect(c.responseTopic, 'r/topic');
      expect(c.correlationData, 'cid');
      expect(c.brokerUrl, base.brokerUrl);
      expect(base.responseTopic, '');
      expect(base.correlationData, '');
    });

    test('copyWith sessionExpiryInterval/messageExpiryInterval', () {
      final c = base.copyWith(
        sessionExpiryInterval: 3600,
        messageExpiryInterval: 60,
      );
      expect(c.sessionExpiryInterval, 3600);
      expect(c.messageExpiryInterval, 60);
      expect(c.brokerUrl, base.brokerUrl);
      expect(base.sessionExpiryInterval, 0);
      expect(base.messageExpiryInterval, 0);
    });

    test('copyWith keepAlivePeriod', () {
      final c = base.copyWith(keepAlivePeriod: 120);
      expect(c.keepAlivePeriod, 120);
      expect(c.brokerUrl, base.brokerUrl);
      expect(base.keepAlivePeriod, 60);
    });

    test('copyWith retainMessage', () {
      final c = base.copyWith(retainMessage: true);
      expect(c.retainMessage, true);
      expect(c.brokerUrl, base.brokerUrl);
      expect(base.retainMessage, false);
    });

    test('copyWith willTopic, willMessage, willRetain, willQos', () {
      final c = base.copyWith(
        willTopic: 'lwt/1',
        willMessage: 'dead',
        willRetain: true,
        willQos: 2,
      );
      expect(c.willTopic, 'lwt/1');
      expect(c.willMessage, 'dead');
      expect(c.willRetain, true);
      expect(c.willQos, 2);
      expect(c.brokerUrl, base.brokerUrl);
      expect(base.willTopic, '');
      expect(base.willMessage, '');
      expect(base.willRetain, false);
      expect(base.willQos, 0);
    });

    test('copyWith allowInvalidCertificates changes only that field', () {
      final c = base.copyWith(allowInvalidCertificates: true);
      expect(c.allowInvalidCertificates, true);
      expect(c.useTLS, base.useTLS);
      expect(base.allowInvalidCertificates, false);
    });
  });

  group('MQTTRequestModel toJson', () {
    test('Defaults model serializes with all default keys', () {
      expect(mqttRequestModelDefaults.toJson(), mqttRequestModelDefaultsJson);
    });

    test('Fully-populated v5 model serializes correctly', () {
      expect(mqttRequestModelFull.toJson(), mqttRequestModelFullJson);
    });
  });

  group('MQTTRequestModel fromJson', () {
    test('Defaults JSON round-trips to an equal model', () {
      final model = MQTTRequestModel.fromJson(mqttRequestModelDefaultsJson);
      expect(model, mqttRequestModelDefaults);
    });

    test('Fully-populated v5 JSON round-trips to an equal model', () {
      final model = MQTTRequestModel.fromJson(mqttRequestModelFullJson);
      expect(model, mqttRequestModelFull);
      // Spot-check the populated collections survived the round-trip.
      expect(model.subscribedTopics.length, 2);
      expect(model.subscribedTopics[0].name, 'sensors/temp');
      expect(model.isTopicEnabledList, [true, false]);
      expect(model.userProperties.length, 2);
      expect(model.userProperties[1].value, 'test');
      expect(model.isUserPropertyEnabledList, [true, true]);
      // messageHistory IS serialized to JSON (like WebSocketRequestModel) and
      // therefore survives the round-trip.
      expect(model.messageHistory.length, 2);
      expect(model.messageHistory[0].payload, 'hello');
      expect(model.messageHistory[0].metadata, 'sensors/temp');
      expect(model.messageHistory[1].outgoing, false);
      expect(model.messageHistory[1].timestamp, isNull);
      // v5 fields
      expect(model.responseTopic, 'devices/resp');
      expect(model.correlationData, 'corr-123');
      expect(model.sessionExpiryInterval, 3600);
      expect(model.messageExpiryInterval, 60);
      expect(model.allowInvalidCertificates, true);
      expect(model.keepAlivePeriod, 120);
      expect(model.retainMessage, true);
      expect(model.willTopic, 'lwt/topic');
      expect(model.willMessage, 'lwt-msg');
      expect(model.willRetain, true);
      expect(model.willQos, 1);
    });

    test('Full toJson -> fromJson is lossless', () {
      final json = mqttRequestModelFull.toJson();
      final back = MQTTRequestModel.fromJson(json);
      expect(back, mqttRequestModelFull);
    });

    test('fromJson with only brokerUrl yields all defaults', () {
      final model = MQTTRequestModel.fromJson({
        'brokerUrl': 'mqtt://only.broker',
      });
      expect(model.brokerUrl, 'mqtt://only.broker');
      expect(model.port, 1883);
      expect(model.clientId, isNull);
      expect(model.version, MQTTVersion.v5);
      expect(model.subscribedTopics, isEmpty);
      expect(model.isTopicEnabledList, isEmpty);
      expect(model.useTLS, false);
      expect(model.useWebSocket, false);
      expect(model.qos, 0);
      expect(model.messageHistory, isEmpty);
      expect(model.message, '');
      expect(model.publishTopic, '');
      expect(model.allowInvalidCertificates, false);
      expect(model.userProperties, isEmpty);
      expect(model.isUserPropertyEnabledList, isEmpty);
      expect(model.responseTopic, '');
      expect(model.correlationData, '');
      expect(model.sessionExpiryInterval, 0);
      expect(model.messageExpiryInterval, 0);
      expect(model.keepAlivePeriod, 60);
      expect(model.willTopic, '');
      expect(model.willMessage, '');
      expect(model.willRetain, false);
      expect(model.willQos, 0);
    });

    test(
      'per-topic int QoS in subscribedTopics survives toJson -> fromJson',
      () {
        // Per-topic QoS is stored in NameValueModel.value as an int (0/1/2).
        // It must round-trip as an int (not a String) through JSON.
        const model = MQTTRequestModel(
          brokerUrl: 'mqtt://broker',
          subscribedTopics: [NameValueModel(name: 't', value: 2)],
          isTopicEnabledList: [true],
        );
        final back = MQTTRequestModel.fromJson(model.toJson());
        expect(back.subscribedTopics.length, 1);
        expect(back.subscribedTopics[0].name, 't');
        expect(back.subscribedTopics[0].value, 2);
        expect(
          back.subscribedTopics[0].value,
          isA<int>(),
          reason: 'int QoS must not degrade to a String on round-trip',
        );
        expect(back, model);
      },
    );

    test('fromJson with explicit null optionals yields defaults', () {
      final model = MQTTRequestModel.fromJson(const {
        'brokerUrl': 'mqtt://broker',
        'clientId': null,
        'username': null,
        'password': null,
        'subscribedTopics': null,
        'isTopicEnabledList': null,
        'messageHistory': null,
        'userProperties': null,
      });
      expect(model.brokerUrl, 'mqtt://broker');
      expect(model.clientId, isNull);
      expect(model.subscribedTopics, isEmpty);
      expect(model.isTopicEnabledList, isEmpty);
      expect(model.messageHistory, isEmpty);
      expect(model.userProperties, isEmpty);
      expect(model.version, MQTTVersion.v5);
    });
  });

  group('MQTTVersion enum', () {
    test('v5 maps to "v5" in JSON and round-trips', () {
      final json = mqttRequestModelDefaults.toJson();
      expect(json['version'], 'v5');
      expect(MQTTRequestModel.fromJson(json).version, MQTTVersion.v5);
    });

    test('v3_1_1 maps to "v3_1_1" in JSON and round-trips', () {
      final json = mqttRequestModelV311.toJson();
      expect(json['version'], 'v3_1_1');
      final back = MQTTRequestModel.fromJson(json);
      expect(back.version, MQTTVersion.v3_1_1);
      expect(back, mqttRequestModelV311);
    });

    test('v3 maps to "v3" in JSON and round-trips', () {
      const model = MQTTRequestModel(
        brokerUrl: 'mqtt://broker',
        version: MQTTVersion.v3,
      );
      final json = model.toJson();
      expect(json['version'], 'v3');
      expect(MQTTRequestModel.fromJson(json).version, MQTTVersion.v3);
    });

    test('Every MQTTVersion value round-trips through JSON', () {
      for (final v in MQTTVersion.values) {
        final original = MQTTRequestModel(brokerUrl: 'mqtt://b', version: v);
        final back = MQTTRequestModel.fromJson(original.toJson());
        expect(back.version, v, reason: 'round-trip failed for $v');
      }
    });
  });

  group('MQTTRequestModel equality and hashCode', () {
    test('Identical models are equal and share a hashCode', () {
      const a = MQTTRequestModel(
        brokerUrl: 'mqtt://x',
        port: 8883,
        version: MQTTVersion.v5,
        useTLS: true,
        qos: 1,
        sessionExpiryInterval: 120,
      );
      const b = MQTTRequestModel(
        brokerUrl: 'mqtt://x',
        port: 8883,
        version: MQTTVersion.v5,
        useTLS: true,
        qos: 1,
        sessionExpiryInterval: 120,
      );
      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('Differing on any single field breaks equality', () {
      const a = MQTTRequestModel(brokerUrl: 'mqtt://x');
      expect(a == a.copyWith(brokerUrl: 'mqtt://y'), false);
      expect(a == a.copyWith(port: 8883), false);
      expect(a == a.copyWith(clientId: 'c'), false);
      expect(a == a.copyWith(username: 'u'), false);
      expect(a == a.copyWith(password: 'p'), false);
      expect(a == a.copyWith(version: MQTTVersion.v3_1_1), false);
      expect(
        a ==
            a.copyWith(
              subscribedTopics: const [NameValueModel(name: 't', value: 'q')],
            ),
        false,
      );
      expect(a == a.copyWith(isTopicEnabledList: const [true]), false);
      expect(a == a.copyWith(useTLS: true), false);
      expect(a == a.copyWith(useWebSocket: true), false);
      expect(a == a.copyWith(qos: 2), false);
      expect(a == a.copyWith(message: 'm'), false);
      expect(a == a.copyWith(publishTopic: 'p/t'), false);
      expect(a == a.copyWith(allowInvalidCertificates: true), false);
      expect(
        a ==
            a.copyWith(
              userProperties: const [NameValueModel(name: 'k', value: 'v')],
            ),
        false,
      );
      expect(a == a.copyWith(isUserPropertyEnabledList: const [true]), false);
      expect(a == a.copyWith(responseTopic: 'r'), false);
      expect(a == a.copyWith(correlationData: 'cd'), false);
      expect(a == a.copyWith(sessionExpiryInterval: 1), false);
      expect(a == a.copyWith(messageExpiryInterval: 1), false);
      expect(a == a.copyWith(keepAlivePeriod: 1), false);
      expect(a == a.copyWith(retainMessage: true), false);
      expect(a == a.copyWith(willTopic: 'wt'), false);
      expect(a == a.copyWith(willMessage: 'wm'), false);
      expect(a == a.copyWith(willRetain: true), false);
      expect(a == a.copyWith(willQos: 1), false);
      expect(
        a == a.copyWith(messageHistory: const [WebSocketMessage(payload: 'm')]),
        false,
      );
    });
  });
}
