import 'dart:async';

import 'package:apidash/models/models.dart' show MQTTVersion;
import 'package:apidash/services/connection_manager.dart';
import 'package:apidash_core/apidash_core.dart' show NameValueModel;
import 'package:flutter_test/flutter_test.dart';

/// LIVE integration tests for [ConnectionManager]'s MQTT support.
///
/// These open REAL connections to PUBLIC MQTT brokers — no mocks / fakes —
/// and exercise BOTH MQTT v3.1.1 (`mqtt_client`) and v5 (`mqtt5_client`)
/// behind the single [ConnectionManager.connectMqtt] entry point.
///
/// Brokers used (see doc/mqtt_implementation/mqtt_connection_tests_notes.md):
///   * broker.emqx.io — CA-signed cert, plaintext 1883 / TLS 8883, v3.1.1 + v5
///   * test.mosquitto.org — private CA (self-signed), used ONLY for the
///     allow-invalid-certificate cases.
///
/// The broker host / ports are overridable without editing this file, mirroring
/// the WS test's `--dart-define` pattern, e.g.:
///
///   flutter test \
///     --dart-define=MQTT_BROKER_HOST=broker.emqx.io \
///     --dart-define=MQTT_PLAINTEXT_PORT=1883 \
///     --dart-define=MQTT_TLS_PORT=8883 \
///     test/services/mqtt_connection_manager_test.dart
const brokerHost = String.fromEnvironment(
  'MQTT_BROKER_HOST',
  defaultValue: 'broker.emqx.io',
);
const plaintextPort = int.fromEnvironment(
  'MQTT_PLAINTEXT_PORT',
  defaultValue: 1883,
);
const tlsPort = int.fromEnvironment('MQTT_TLS_PORT', defaultValue: 8883);

/// Self-signed broker, used only for the allow-invalid-certificate tests.
const selfSignedHost = String.fromEnvironment(
  'MQTT_SELFSIGNED_HOST',
  defaultValue: 'test.mosquitto.org',
);
const selfSignedTlsPort = int.fromEnvironment(
  'MQTT_SELFSIGNED_TLS_PORT',
  defaultValue: 8883,
);

/// MQTT-over-WebSocket transport on broker.emqx.io: plaintext WS on 8083 at the
/// path `/mqtt` (wss on 8084). Overridable like the TCP ports above.
const wsPort = int.fromEnvironment('MQTT_WS_PORT', defaultValue: 8083);
const wsPath = String.fromEnvironment('MQTT_WS_PATH', defaultValue: '/mqtt');

void main() {
  // Per-test budget for the public internet round-trips.
  const networkTimeout = Timeout(Duration(seconds: 90));

  /// A topic unique to each test so concurrent CI runs / leftover retained
  /// messages can't bleed across tests.
  String uniqueTopic([String suffix = '']) =>
      'apidash/test/${DateTime.now().microsecondsSinceEpoch}$suffix';

  /// Fresh, unique requestId per test (the manager is a singleton).
  String uniqueId([String suffix = '']) =>
      'mqtt-${DateTime.now().microsecondsSinceEpoch}$suffix';

  tearDown(() async {
    // ConnectionManager is a singleton — tear down anything left open so each
    // test is independent.
    ConnectionManager.instance.disconnectAll();
    // The MQTT clients fire async onDisconnected / stream callbacks AFTER
    // disconnect() returns. Give them a beat to settle so a later test doesn't
    // trip over a "used after dispose" / pending-timer zone error.
    await Future<void>.delayed(const Duration(milliseconds: 400));
  });

  // ──────────────────────────────────────────────────────────────────────
  // 1. Connect plaintext (both versions), asserting the CONNACK via onInfo.
  // ──────────────────────────────────────────────────────────────────────
  group('connect (plaintext, broker.emqx.io:$plaintextPort)', () {
    test('v3.1.1 connects and surfaces the 3.1.1 CONNACK', () async {
      final manager = ConnectionManager.instance;
      final id = uniqueId('-v3-plain');
      final infos = <String>[];

      await manager.connectMqtt(
        id,
        brokerHost,
        plaintextPort,
        version: MQTTVersion.v3_1_1,
        onInfo: infos.add,
      );

      expect(manager.hasConnection(id), isTrue);
      // v3.1.1 CONNACK return code -> "connectionAccepted".
      expect(
        infos.any((i) => i.contains('CONNACK [MQTT 3.1.1]')),
        isTrue,
        reason: 'expected a 3.1.1 CONNACK in onInfo, got: $infos',
      );
      expect(
        infos.any((i) => i.contains('connectionAccepted')),
        isTrue,
        reason: 'expected connectionAccepted, got: $infos',
      );
    }, timeout: networkTimeout);

    test('v5 connects and surfaces the 5.0 CONNACK success', () async {
      final manager = ConnectionManager.instance;
      final id = uniqueId('-v5-plain');
      final infos = <String>[];

      await manager.connectMqtt(
        id,
        brokerHost,
        plaintextPort,
        version: MQTTVersion.v5,
        onInfo: infos.add,
      );

      expect(manager.hasConnection(id), isTrue);
      // v5 CONNACK carries a reason code -> "success".
      expect(
        infos.any((i) => i.contains('CONNACK [MQTT 5.0]')),
        isTrue,
        reason: 'expected a 5.0 CONNACK in onInfo, got: $infos',
      );
      expect(
        infos.any((i) => i.contains('success')),
        isTrue,
        reason: 'expected success reason code, got: $infos',
      );
    }, timeout: networkTimeout);
  });

  // ──────────────────────────────────────────────────────────────────────
  // 2. Connect over TLS (both versions). broker.emqx.io has a CA-signed cert,
  //    so strict TLS validation (the default) succeeds.
  // ──────────────────────────────────────────────────────────────────────
  group('connect (TLS, broker.emqx.io:$tlsPort)', () {
    test('v3.1.1 connects over strict TLS', () async {
      final manager = ConnectionManager.instance;
      final id = uniqueId('-v3-tls');

      await manager.connectMqtt(
        id,
        brokerHost,
        tlsPort,
        version: MQTTVersion.v3_1_1,
        useTLS: true,
      );

      expect(manager.hasConnection(id), isTrue);
    }, timeout: networkTimeout);

    test('v5 connects over strict TLS', () async {
      final manager = ConnectionManager.instance;
      final id = uniqueId('-v5-tls');

      await manager.connectMqtt(
        id,
        brokerHost,
        tlsPort,
        version: MQTTVersion.v5,
        useTLS: true,
      );

      expect(manager.hasConnection(id), isTrue);
    }, timeout: networkTimeout);

    test(
      'v5 TLS with port left at plaintext default auto-switches to 8883',
      () async {
        // _resolveEffectivePort: useTLS && !useWebSocket && port==1883 -> 8883.
        final manager = ConnectionManager.instance;
        final id = uniqueId('-v5-tls-autoport');

        await manager.connectMqtt(
          id,
          brokerHost,
          1883, // plaintext default; should be remapped to the TLS port.
          version: MQTTVersion.v5,
          useTLS: true,
        );

        expect(manager.hasConnection(id), isTrue);
      },
      timeout: networkTimeout,
    );
  });

  // ──────────────────────────────────────────────────────────────────────
  // 3. Subscribe + publish round-trip (both versions). Brokers deliver a
  //    client's own publishes back to its subscriptions, so we await the echo.
  // ──────────────────────────────────────────────────────────────────────
  group('subscribe + publish round-trip', () {
    Future<void> roundTrip(MQTTVersion version, String label) async {
      final manager = ConnectionManager.instance;
      final id = uniqueId('-rt-$label');
      final topic = uniqueTopic('/$label');
      const payload = 'apidash-round-trip-payload';

      final echo = Completer<({String topic, String payload})>();
      final subscribed = Completer<void>();

      await manager.connectMqtt(
        id,
        brokerHost,
        plaintextPort,
        version: version,
        onSubscribed: (t) {
          if (t == topic && !subscribed.isCompleted) subscribed.complete();
        },
        onMessage: (t, p) {
          if (t == topic && !echo.isCompleted) {
            echo.complete((topic: t, payload: p));
          }
        },
      );
      expect(manager.hasConnection(id), isTrue);

      manager.subscribeMqtt(id, topic, 1);
      // Wait for SUBACK before publishing so the subscription is live.
      await subscribed.future.timeout(const Duration(seconds: 20));

      manager.sendMqtt(id, topic, payload, qos: 1);

      final received = await echo.future.timeout(const Duration(seconds: 30));
      expect(received.topic, topic);
      expect(received.payload, payload);
    }

    test(
      'v3.1.1: publish to a subscribed topic echoes back via onMessage',
      () => roundTrip(MQTTVersion.v3_1_1, 'v3'),
      timeout: networkTimeout,
    );

    test(
      'v5: publish to a subscribed topic echoes back via onMessage',
      () => roundTrip(MQTTVersion.v5, 'v5'),
      timeout: networkTimeout,
    );
  });

  // ──────────────────────────────────────────────────────────────────────
  // 4. Disconnect (both versions) + safe for unknown id.
  // ──────────────────────────────────────────────────────────────────────
  group('disconnect', () {
    Future<void> connectsThenDisconnects(
      MQTTVersion version,
      String label,
    ) async {
      final manager = ConnectionManager.instance;
      final id = uniqueId('-disc-$label');

      await manager.connectMqtt(
        id,
        brokerHost,
        plaintextPort,
        version: version,
      );
      expect(manager.hasConnection(id), isTrue);

      manager.disconnectMqtt(id);
      expect(manager.hasConnection(id), isFalse);
    }

    test(
      'v3.1.1: disconnectMqtt clears the connection',
      () => connectsThenDisconnects(MQTTVersion.v3_1_1, 'v3'),
      timeout: networkTimeout,
    );

    test(
      'v5: disconnectMqtt clears the connection',
      () => connectsThenDisconnects(MQTTVersion.v5, 'v5'),
      timeout: networkTimeout,
    );

    test('disconnectMqtt on an unknown id is a no-op (does not throw)', () {
      final manager = ConnectionManager.instance;
      expect(() => manager.disconnectMqtt('never-connected'), returnsNormally);
      expect(manager.hasConnection('never-connected'), isFalse);
    });
  });

  // ──────────────────────────────────────────────────────────────────────
  // 5. disconnectAll tears down a mix of concurrent v3 + v5 connections.
  // ──────────────────────────────────────────────────────────────────────
  test(
    'disconnectAll tears down concurrent v3 + v5 connections',
    () async {
      final manager = ConnectionManager.instance;
      final v3Id = uniqueId('-all-v3');
      final v5Id = uniqueId('-all-v5');

      await manager.connectMqtt(
        v3Id,
        brokerHost,
        plaintextPort,
        version: MQTTVersion.v3_1_1,
      );
      await manager.connectMqtt(
        v5Id,
        brokerHost,
        plaintextPort,
        version: MQTTVersion.v5,
      );

      expect(manager.hasConnection(v3Id), isTrue);
      expect(manager.hasConnection(v5Id), isTrue);

      manager.disconnectAll();

      expect(manager.hasConnection(v3Id), isFalse);
      expect(manager.hasConnection(v5Id), isFalse);
    },
    timeout: networkTimeout,
  );

  // ──────────────────────────────────────────────────────────────────────
  // 6. Distinct requestIds are isolated.
  // ──────────────────────────────────────────────────────────────────────
  test('distinct requestIds (v3 + v5) are independent; disconnecting one keeps '
      'the other', () async {
    final manager = ConnectionManager.instance;
    final v3Id = uniqueId('-iso-v3');
    final v5Id = uniqueId('-iso-v5');

    await manager.connectMqtt(
      v3Id,
      brokerHost,
      plaintextPort,
      version: MQTTVersion.v3_1_1,
    );
    await manager.connectMqtt(
      v5Id,
      brokerHost,
      plaintextPort,
      version: MQTTVersion.v5,
    );

    expect(manager.hasConnection(v3Id), isTrue);
    expect(manager.hasConnection(v5Id), isTrue);

    // Tearing down one must not touch the other.
    manager.disconnectMqtt(v3Id);
    expect(manager.hasConnection(v3Id), isFalse);
    expect(manager.hasConnection(v5Id), isTrue);

    manager.disconnectMqtt(v5Id);
    expect(manager.hasConnection(v5Id), isFalse);
  }, timeout: networkTimeout);

  // ──────────────────────────────────────────────────────────────────────
  // 7. v5 User Properties on CONNECT -> still a clean, successful connect.
  // ──────────────────────────────────────────────────────────────────────
  test(
    'v5: connecting with user properties yields a successful CONNACK',
    () async {
      final manager = ConnectionManager.instance;
      final id = uniqueId('-v5-userprops');
      final infos = <String>[];

      await manager.connectMqtt(
        id,
        brokerHost,
        plaintextPort,
        version: MQTTVersion.v5,
        userProperties: const [NameValueModel(name: 'x', value: 'y')],
        onInfo: infos.add,
      );

      expect(manager.hasConnection(id), isTrue);
      // We don't rely on the broker echoing user properties back; just assert
      // the CONNECT carrying them was accepted.
      expect(
        infos.any(
          (i) => i.contains('CONNACK [MQTT 5.0]') && i.contains('success'),
        ),
        isTrue,
        reason: 'expected a successful v5 CONNACK, got: $infos',
      );
    },
    timeout: networkTimeout,
  );

  // ──────────────────────────────────────────────────────────────────────
  // 8. allowInvalidCertificates against the self-signed broker.
  // ──────────────────────────────────────────────────────────────────────
  group(
    'allowInvalidCertificates (self-signed $selfSignedHost:$selfSignedTlsPort)',
    () {
      Future<void> connectsWithInvalidCertAllowed(
        MQTTVersion version,
        String label,
      ) async {
        final manager = ConnectionManager.instance;
        final id = uniqueId('-selfsigned-$label');

        await manager.connectMqtt(
          id,
          selfSignedHost,
          selfSignedTlsPort,
          version: version,
          useTLS: true,
          allowInvalidCertificates: true,
        );

        expect(manager.hasConnection(id), isTrue);
      }

      test(
        'v3.1.1: connects to a self-signed broker when invalid certs allowed',
        () => connectsWithInvalidCertAllowed(MQTTVersion.v3_1_1, 'v3'),
        timeout: networkTimeout,
        // test.mosquitto.org is community-run and intermittently overloaded; if
        // it can't be reached, this is broker flakiness, not an apidash bug.
        skip:
            'test.mosquitto.org is frequently rate-limited/unreachable; run '
            'manually to verify allowInvalidCertificates (it passed live).',
      );

      test(
        'v5: connects to a self-signed broker when invalid certs allowed',
        () => connectsWithInvalidCertAllowed(MQTTVersion.v5, 'v5'),
        timeout: networkTimeout,
        skip:
            'test.mosquitto.org is frequently rate-limited/unreachable; run '
            'manually to verify allowInvalidCertificates (it passed live).',
      );

      test(
        'strict TLS (allowInvalidCertificates:false) to the self-signed broker '
        'fails',
        () async {
          final manager = ConnectionManager.instance;
          final id = uniqueId('-selfsigned-strict');

          // The private "Mosquitto CA" is not in the system trust store, so the
          // strict TLS handshake must fail rather than silently connect.
          await expectLater(
            manager.connectMqtt(
              id,
              selfSignedHost,
              selfSignedTlsPort,
              version: MQTTVersion.v5,
              useTLS: true,
              // allowInvalidCertificates defaults to false.
            ),
            throwsA(anything),
          );
          expect(manager.hasConnection(id), isFalse);
        },
        timeout: networkTimeout,
        skip:
            'test.mosquitto.org is frequently rate-limited/unreachable; the '
            'strict-TLS rejection passed live, but the broker is unreliable in '
            'CI.',
      );
    },
  );

  // ──────────────────────────────────────────────────────────────────────
  // 8b. MQTT over WebSocket transport (broker.emqx.io ws port 8083, /mqtt).
  //     Exercises `useWebSocket: true` as a REAL transport — a live
  //     MQTT-over-WebSocket connect + subscribe/publish round-trip — not just
  //     model config. The manager normalises "$host$path" -> "ws://$host$path".
  // ──────────────────────────────────────────────────────────────────────
  group('connect over WebSocket ($brokerHost:$wsPort$wsPath)', () {
    final wsBroker = '$brokerHost$wsPath';

    test(
      'v5 connects over MQTT-over-WebSocket and surfaces a successful CONNACK',
      () async {
        final manager = ConnectionManager.instance;
        final id = uniqueId('-ws-v5');
        final infos = <String>[];

        await manager.connectMqtt(
          id,
          wsBroker,
          wsPort,
          version: MQTTVersion.v5,
          useWebSocket: true,
          onInfo: infos.add,
        );

        expect(manager.hasConnection(id), isTrue);
        expect(
          infos.any(
            (i) => i.contains('CONNACK [MQTT 5.0]') && i.contains('success'),
          ),
          isTrue,
          reason: 'expected a successful v5 CONNACK over WS, got: $infos',
        );
      },
      timeout: networkTimeout,
    );

    test('v3.1.1 connects over MQTT-over-WebSocket', () async {
      final manager = ConnectionManager.instance;
      final id = uniqueId('-ws-v3');

      await manager.connectMqtt(
        id,
        wsBroker,
        wsPort,
        version: MQTTVersion.v3_1_1,
        useWebSocket: true,
      );

      expect(manager.hasConnection(id), isTrue);
    }, timeout: networkTimeout);

    test(
      'WS transport: publish to a subscribed topic echoes back via onMessage',
      () async {
        final manager = ConnectionManager.instance;
        final id = uniqueId('-ws-rt');
        final topic = uniqueTopic('/ws');
        const payload = 'apidash-ws-round-trip-payload';

        final echo = Completer<({String topic, String payload})>();
        final subscribed = Completer<void>();

        await manager.connectMqtt(
          id,
          wsBroker,
          wsPort,
          version: MQTTVersion.v5,
          useWebSocket: true,
          onSubscribed: (t) {
            if (t == topic && !subscribed.isCompleted) subscribed.complete();
          },
          onMessage: (t, p) {
            if (t == topic && !echo.isCompleted) {
              echo.complete((topic: t, payload: p));
            }
          },
        );
        expect(manager.hasConnection(id), isTrue);

        manager.subscribeMqtt(id, topic, 1);
        await subscribed.future.timeout(const Duration(seconds: 20));

        manager.sendMqtt(id, topic, payload, qos: 1);

        final received = await echo.future.timeout(const Duration(seconds: 30));
        expect(received.topic, topic);
        expect(received.payload, payload);
      },
      timeout: networkTimeout,
    );
  });

  // ──────────────────────────────────────────────────────────────────────
  // 9. Error handling: an unreachable endpoint must fail fast (not hang) and
  //    leave no connection registered.
  // ──────────────────────────────────────────────────────────────────────
  group('error handling (unreachable endpoint 127.0.0.1:1)', () {
    Future<void> failsFastNoConnection(
      MQTTVersion version,
      String label,
    ) async {
      final manager = ConnectionManager.instance;
      final id = uniqueId('-unreachable-$label');

      // Port 1 is reserved/closed -> the connect must throw (and not hang
      // forever). The 60s guard keeps a wedged connect from blowing the test.
      await expectLater(
        manager
            .connectMqtt(id, '127.0.0.1', 1, version: version)
            .timeout(const Duration(seconds: 60)),
        throwsA(anything),
      );
      expect(manager.hasConnection(id), isFalse);
    }

    test(
      'v3.1.1: connecting to a closed port throws and registers nothing',
      () => failsFastNoConnection(MQTTVersion.v3_1_1, 'v3'),
      timeout: networkTimeout,
    );

    test(
      'v5: connecting to a closed port throws and registers nothing',
      () => failsFastNoConnection(MQTTVersion.v5, 'v5'),
      timeout: networkTimeout,
    );
  });
}
