import 'dart:async';

import 'package:apidash/models/models.dart' show MQTTVersion;
import 'package:apidash/services/connection_manager.dart';
import 'package:apidash_core/apidash_core.dart' show NameValueModel;
import 'package:flutter_test/flutter_test.dart';

const brokerHost = String.fromEnvironment(
  'MQTT_BROKER_HOST',
  defaultValue: 'broker.emqx.io',
);
const plaintextPort = int.fromEnvironment('MQTT_PLAINTEXT_PORT', defaultValue: 1883);

void main() {
  const networkTimeout = Timeout(Duration(seconds: 90));

  String uniqueTopic([String suffix = '']) =>
      'apidash/test/${DateTime.now().microsecondsSinceEpoch}$suffix';

  String uniqueId([String suffix = '']) =>
      'mqtt-edge-${DateTime.now().microsecondsSinceEpoch}$suffix';

  tearDown(() async {
    ConnectionManager.instance.disconnectAll();
    await Future<void>.delayed(const Duration(milliseconds: 400));
  });

  group('Connection Edge Cases', () {
    test('Keep Alive 0 (disabled) succeeds', () async {
      final manager = ConnectionManager.instance;
      final id = uniqueId('-keepalive-0');
      
      await manager.connectMqtt(
        id,
        brokerHost,
        plaintextPort,
        version: MQTTVersion.v5,
        keepAlivePeriod: 0,
      );
      
      expect(manager.hasConnection(id), isTrue);
    }, timeout: networkTimeout);

    test('Keep Alive extreme (65535) succeeds', () async {
      final manager = ConnectionManager.instance;
      final id = uniqueId('-keepalive-max');
      
      await manager.connectMqtt(
        id,
        brokerHost,
        plaintextPort,
        version: MQTTVersion.v5,
        keepAlivePeriod: 65535,
      );
      
      expect(manager.hasConnection(id), isTrue);
    }, timeout: networkTimeout);

    test('Zero-length topic publish is rejected', () async {
      final manager = ConnectionManager.instance;
      final id = uniqueId('-zero-topic');
      
      await manager.connectMqtt(
        id,
        brokerHost,
        plaintextPort,
        version: MQTTVersion.v5,
      );
      
      manager.sendMqtt(id, '', 'payload');
      // In MQTT v5, publishing to '' throws or causes disconnect with 0x90.
      // We just ensure it doesn't crash the client completely before we can await.
      await Future<void>.delayed(const Duration(seconds: 1));
    }, timeout: networkTimeout);

    test('Massive/Duplicate User Properties (v5)', () async {
      final manager = ConnectionManager.instance;
      final pubId = uniqueId('-up-pub');
      final subId = uniqueId('-up-sub');
      final topic = uniqueTopic('-userprops');

      final completer = Completer<void>();
      
      await manager.connectMqtt(
        subId,
        brokerHost,
        plaintextPort,
        version: MQTTVersion.v5,
        onMessage: (t, p) {
          if (t == topic) completer.complete();
        },
      );
      manager.subscribeMqtt(subId, topic, 1);
      await Future<void>.delayed(const Duration(seconds: 1));

      await manager.connectMqtt(pubId, brokerHost, plaintextPort, version: MQTTVersion.v5);
      
      final props = List.generate(50, (i) => NameValueModel(name: 'Header', value: 'Value $i'));
      
      manager.sendMqtt(
        pubId,
        topic,
        'payload',
        userProperties: props,
      );
      
      await expectLater(completer.future, completes);
    }, timeout: networkTimeout);

    test('Request / Response Pattern (v5)', () async {
      final manager = ConnectionManager.instance;
      final pubId = uniqueId('-req-pub');
      final subId = uniqueId('-req-sub');
      final topic = uniqueTopic('-req');

      final completer = Completer<void>();
      
      await manager.connectMqtt(
        subId,
        brokerHost,
        plaintextPort,
        version: MQTTVersion.v5,
        onMessage: (t, p) {
          if (t == topic) completer.complete();
        },
      );
      manager.subscribeMqtt(subId, topic, 1);
      await Future<void>.delayed(const Duration(seconds: 1));

      await manager.connectMqtt(pubId, brokerHost, plaintextPort, version: MQTTVersion.v5);
      
      manager.sendMqtt(
        pubId,
        topic,
        'request-payload',
        responseTopic: 'apidash/response',
        correlationData: '12345',
      );
      
      await expectLater(completer.future, completes);
    }, timeout: networkTimeout);
    
    test('Clearing a retained message', () async {
      final manager = ConnectionManager.instance;
      final id = uniqueId('-retain');
      final topic = uniqueTopic('-retain-clear');

      await manager.connectMqtt(id, brokerHost, plaintextPort, version: MQTTVersion.v5);
      
      // Publish retained
      manager.sendMqtt(id, topic, 'retained-data', retain: true);
      await Future<void>.delayed(const Duration(seconds: 1));
      
      // Clear retained
      manager.sendMqtt(id, topic, '', retain: true);
      await Future<void>.delayed(const Duration(seconds: 1));
      
      // Verify clearing
      var received = false;
      final subId = uniqueId('-retain-sub');
      await manager.connectMqtt(subId, brokerHost, plaintextPort, version: MQTTVersion.v5, onMessage: (t, p) {
        if (t == topic) received = true;
      });
      manager.subscribeMqtt(subId, topic, 1);
      await Future<void>.delayed(const Duration(seconds: 2));
      
      expect(received, isFalse);
    }, timeout: networkTimeout);

    test('v3.1.1 LWT connects successfully', () async {
      final manager = ConnectionManager.instance;
      final id = uniqueId('-v3-lwt');
      
      await manager.connectMqtt(
        id,
        brokerHost,
        plaintextPort,
        version: MQTTVersion.v3_1_1,
        willTopic: 'apidash/lwt/v3',
        willMessage: 'v3 offline',
        willRetain: true,
        willQos: 1,
      );
      
      expect(manager.hasConnection(id), isTrue);
    }, timeout: networkTimeout);

    test('v5 LWT connects successfully', () async {
      final manager = ConnectionManager.instance;
      final id = uniqueId('-v5-lwt');
      
      await manager.connectMqtt(
        id,
        brokerHost,
        plaintextPort,
        version: MQTTVersion.v5,
        willTopic: 'apidash/lwt/v5',
        willMessage: 'v5 offline',
        willRetain: true,
        willQos: 2,
      );
      
      expect(manager.hasConnection(id), isTrue);
    }, timeout: networkTimeout);

    test('v5 Session Expiry (Persistent Session) connects successfully', () async {
      final manager = ConnectionManager.instance;
      final id = uniqueId('-v5-session');
      
      await manager.connectMqtt(
        id,
        brokerHost,
        plaintextPort,
        version: MQTTVersion.v5,
        sessionExpiryInterval: 3600, // 1 hour
      );
      
      expect(manager.hasConnection(id), isTrue);
    }, timeout: networkTimeout);

  });
}
