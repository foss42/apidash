import 'dart:async';

import 'package:apidash/services/connection_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Live FastAPI echo endpoint these tests connect to.
///
/// The `/ws/echo` route echoes every frame — both raw text and JSON — straight
/// back to the sender. These tests open REAL WebSocket connections through the
/// [ConnectionManager] singleton (no mocks / fakes).
///
/// Defaults to the deployed staging endpoint. For local/offline verification
/// run the companion FastAPI server and override the URL without editing this
/// file, e.g.:
///
///   flutter test --dart-define=WS_ECHO_URL=ws://127.0.0.1:8000/ws/echo \
///       test/services/connection_manager_test.dart
const echoUrl = String.fromEnvironment(
  'WS_ECHO_URL',
  defaultValue: 'wss://api.apidash.dev/ws/echo',
);

void main() {
  const wsUrl = echoUrl;
  const receiveTimeout = Duration(seconds: 10);

  tearDown(() {
    // ConnectionManager is a singleton — make every test independent by
    // tearing down any connections it still holds.
    ConnectionManager.instance.disconnectAll();
  });

  group('ConnectionManager — initial / empty state', () {
    test('is a singleton (instance always returns the same object)', () {
      expect(
        identical(ConnectionManager.instance, ConnectionManager.instance),
        isTrue,
      );
    });

    test('hasConnection returns false before connecting', () {
      expect(ConnectionManager.instance.hasConnection('unknown-id'), isFalse);
    });

    test('getChannel returns null before connecting', () {
      expect(ConnectionManager.instance.getChannel('unknown-id'), isNull);
    });
  });

  group('ConnectionManager.connect', () {
    test('opens a channel and stores it under the requestId', () async {
      final manager = ConnectionManager.instance;
      const id = 'req-1';

      expect(manager.hasConnection(id), isFalse);
      expect(manager.getChannel(id), isNull);

      final channel = await manager.connect(id, wsUrl);

      expect(channel, isA<WebSocketChannel>());
      expect(manager.hasConnection(id), isTrue);
      // getChannel returns the very same channel that connect produced.
      expect(identical(manager.getChannel(id), channel), isTrue);

      await channel.ready;
    });

    test('keeps separate channels for distinct requestIds', () async {
      final manager = ConnectionManager.instance;

      final c1 = await manager.connect('a', wsUrl);
      final c2 = await manager.connect('b', wsUrl);

      expect(manager.hasConnection('a'), isTrue);
      expect(manager.hasConnection('b'), isTrue);
      expect(identical(manager.getChannel('a'), c1), isTrue);
      expect(identical(manager.getChannel('b'), c2), isTrue);
      // Two different requestIds must not share the same channel object.
      expect(identical(c1, c2), isFalse);

      await c1.ready;
      await c2.ready;
    });

    test('passes through custom headers to the underlying channel', () async {
      final manager = ConnectionManager.instance;
      const id = 'req-headers';

      // Custom headers are part of the handshake; the echo server accepts them.
      final channel = await manager.connect(
        id,
        wsUrl,
        headers: {'x-custom-header': 'value'},
      );

      expect(manager.hasConnection(id), isTrue);
      await channel.ready;

      // The connection is fully usable with the headers applied.
      const probe = 'with-headers';
      final echoed = channel.stream.first.timeout(receiveTimeout);
      manager.send(id, probe);
      expect(await echoed, probe);
    });

    test('honors a pingInterval on the underlying channel', () async {
      final manager = ConnectionManager.instance;
      const id = 'req-ping';

      final channel = await manager.connect(
        id,
        wsUrl,
        pingInterval: const Duration(seconds: 1),
      );

      expect(manager.hasConnection(id), isTrue);
      await channel.ready;

      // The connection stays alive and echoes even with a ping interval set.
      const probe = 'ping-alive';
      final echoed = channel.stream.first.timeout(receiveTimeout);
      manager.send(id, probe);
      expect(await echoed, probe);
    });

    test('connecting twice for the SAME id replaces the prior channel',
        () async {
      final manager = ConnectionManager.instance;
      const id = 'req-replace';

      final first = await manager.connect(id, wsUrl);
      await first.ready;

      final second = await manager.connect(id, wsUrl);
      await second.ready;

      // A brand new channel object is stored under the same id.
      expect(identical(first, second), isFalse);
      expect(identical(manager.getChannel(id), second), isTrue);
      expect(manager.hasConnection(id), isTrue);

      // The prior channel was torn down: its stream should complete/close.
      await expectLater(
        first.stream.drain<void>().timeout(receiveTimeout),
        completes,
      );

      // The replacement channel is still usable as an echo connection.
      const probe = 'still-alive';
      final echoed = second.stream.first.timeout(receiveTimeout);
      manager.send(id, probe);
      expect(await echoed, probe);
    });
  });

  group('ConnectionManager.send', () {
    test('sends a message that the echo server returns on the stream',
        () async {
      final manager = ConnectionManager.instance;
      const id = 'req-send';

      final channel = await manager.connect(id, wsUrl);
      await channel.ready;

      const message = 'hello echo';
      final received = channel.stream.first.timeout(receiveTimeout);
      manager.send(id, message);

      expect(await received, message);
    });

    test('sends multiple messages and receives all echoes in order', () async {
      final manager = ConnectionManager.instance;
      const id = 'req-multi';

      final channel = await manager.connect(id, wsUrl);
      await channel.ready;

      final messages = ['one', 'two', 'three'];
      final received = <dynamic>[];
      final completer = Completer<void>();

      final sub = channel.stream.listen((data) {
        received.add(data);
        if (received.length == messages.length && !completer.isCompleted) {
          completer.complete();
        }
      });

      for (final m in messages) {
        manager.send(id, m);
      }

      await completer.future.timeout(receiveTimeout);
      await sub.cancel();

      expect(received, equals(messages));
    });

    test('send on an unknown requestId is a no-op (does not throw)', () {
      final manager = ConnectionManager.instance;
      expect(
        () => manager.send('does-not-exist', 'payload'),
        returnsNormally,
      );
      expect(manager.hasConnection('does-not-exist'), isFalse);
    });

    test('send after disconnect on the same id is a no-op (does not throw)',
        () async {
      final manager = ConnectionManager.instance;
      const id = 'req-send-after-disc';

      final channel = await manager.connect(id, wsUrl);
      await channel.ready;
      manager.disconnect(id);

      expect(() => manager.send(id, 'payload'), returnsNormally);
    });
  });

  group('ConnectionManager.disconnect', () {
    test('closes the channel and removes it from the manager', () async {
      final manager = ConnectionManager.instance;
      const id = 'req-disc';

      final channel = await manager.connect(id, wsUrl);
      await channel.ready;
      expect(manager.hasConnection(id), isTrue);

      manager.disconnect(id);

      expect(manager.hasConnection(id), isFalse);
      expect(manager.getChannel(id), isNull);

      // The underlying stream should complete (the sink was closed).
      await expectLater(
        channel.stream.drain<void>().timeout(receiveTimeout),
        completes,
      );
    });

    test('is safe to call for an unknown id (no-op, does not throw)', () {
      final manager = ConnectionManager.instance;
      expect(() => manager.disconnect('never-connected'), returnsNormally);
      expect(manager.hasConnection('never-connected'), isFalse);
    });

    test('disconnecting one id leaves other connections intact', () async {
      final manager = ConnectionManager.instance;

      final cA = await manager.connect('keep', wsUrl);
      final cB = await manager.connect('drop', wsUrl);
      await cA.ready;
      await cB.ready;

      manager.disconnect('drop');

      expect(manager.hasConnection('drop'), isFalse);
      expect(manager.hasConnection('keep'), isTrue);
      expect(identical(manager.getChannel('keep'), cA), isTrue);

      // The surviving connection still echoes.
      const probe = 'survivor';
      final echoed = cA.stream.first.timeout(receiveTimeout);
      manager.send('keep', probe);
      expect(await echoed, probe);
    });

    test('disconnect is idempotent — calling twice does not throw', () async {
      final manager = ConnectionManager.instance;
      const id = 'req-double-disc';

      final channel = await manager.connect(id, wsUrl);
      await channel.ready;

      manager.disconnect(id);
      expect(() => manager.disconnect(id), returnsNormally);
      expect(manager.hasConnection(id), isFalse);
    });
  });

  group('ConnectionManager.disconnectAll', () {
    test('closes and clears ALL connections for multiple requestIds',
        () async {
      final manager = ConnectionManager.instance;

      final c1 = await manager.connect('m1', wsUrl);
      final c2 = await manager.connect('m2', wsUrl);
      final c3 = await manager.connect('m3', wsUrl);
      await c1.ready;
      await c2.ready;
      await c3.ready;

      expect(manager.hasConnection('m1'), isTrue);
      expect(manager.hasConnection('m2'), isTrue);
      expect(manager.hasConnection('m3'), isTrue);

      manager.disconnectAll();

      expect(manager.hasConnection('m1'), isFalse);
      expect(manager.hasConnection('m2'), isFalse);
      expect(manager.hasConnection('m3'), isFalse);
      expect(manager.getChannel('m1'), isNull);
      expect(manager.getChannel('m2'), isNull);
      expect(manager.getChannel('m3'), isNull);

      // Every underlying stream should complete (all sinks closed).
      await expectLater(
        c1.stream.drain<void>().timeout(receiveTimeout),
        completes,
      );
      await expectLater(
        c2.stream.drain<void>().timeout(receiveTimeout),
        completes,
      );
      await expectLater(
        c3.stream.drain<void>().timeout(receiveTimeout),
        completes,
      );
    });

    test('is safe to call when there are no connections (does not throw)', () {
      final manager = ConnectionManager.instance;
      expect(() => manager.disconnectAll(), returnsNormally);
    });

    test('is idempotent — calling twice does not throw', () async {
      final manager = ConnectionManager.instance;
      final channel = await manager.connect('only', wsUrl);
      await channel.ready;

      manager.disconnectAll();
      expect(() => manager.disconnectAll(), returnsNormally);
      expect(manager.hasConnection('only'), isFalse);
    });
  });

  group('ConnectionManager — error / abnormal-close edges', () {
    test(
      'connecting to an unreachable endpoint: channel.ready rejects but the '
      'channel is still registered (connect itself does not throw)',
      () async {
        final manager = ConnectionManager.instance;
        const id = 'req-unreachable';

        // Port 1 is reserved/closed, so the handshake cannot complete.
        // IOWebSocketChannel.connect is lazy: connect() returns synchronously
        // and only channel.ready surfaces the failure.
        final channel = await manager.connect(id, 'ws://127.0.0.1:1/ws');
        expect(manager.hasConnection(id), isTrue);

        await expectLater(
          channel.ready.timeout(receiveTimeout),
          throwsA(anything),
        );
      },
    );

    test(
      'connect with an unsupported URI scheme throws synchronously and does '
      'NOT register a channel',
      () async {
        final manager = ConnectionManager.instance;
        const id = 'req-bad-scheme';

        // IOWebSocketChannel.connect validates the scheme eagerly: a non-ws
        // scheme throws from inside connect() (before the channel is stored),
        // rather than surfacing lazily via channel.ready.
        await expectLater(
          manager.connect(id, 'http://127.0.0.1:1/nope'),
          throwsA(
            predicate(
              (e) => e.toString().contains('Unsupported URL scheme'),
              'a WebSocketException about the unsupported scheme',
            ),
          ),
        );
        // Because connect() threw before `_channels[id] = channel`, nothing
        // was registered for this id.
        expect(manager.hasConnection(id), isFalse);
      },
    );

    test(
      'send() after the channel sink has been closed (but is still registered) '
      'surfaces the closed-sink StateError — send is NOT guarded',
      () async {
        final manager = ConnectionManager.instance;
        const id = 'req-send-after-close';

        final channel = await manager.connect(id, wsUrl);
        await channel.ready;

        // Close the sink directly WITHOUT going through manager.disconnect(),
        // so the (now-closed) channel is still in the manager's map.
        await channel.sink.close();
        await channel.stream.drain<void>().timeout(receiveTimeout);

        // send() looks up the still-registered channel and calls sink.add on a
        // closed sink, which throws. (manager.disconnect() removes the channel
        // from the map first, which is why the provider path is safe.)
        expect(
          () => manager.send(id, 'after-close'),
          throwsStateError,
        );
      },
    );
  });
}
