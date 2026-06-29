import 'package:apidash/models/models.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/services/services.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'helpers.dart';

/// The `/ws/echo` route echoes every frame — both raw text and JSON —
/// straight back to the sender.
///
/// Defaults to the deployed staging endpoint. For local/offline verification
/// run the companion FastAPI server and override the URL without editing this
/// file, e.g.:
///
///   flutter test --dart-define=WS_ECHO_URL=ws://127.0.0.1:8000/ws/echo \
///       test/providers/ws_collection_providers_test.dart
const echoUrl = String.fromEnvironment(
  'WS_ECHO_URL',
  defaultValue: 'wss://api.apidash.dev/ws/echo',
);

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Connect the websocket tests to the live FastAPI echo server instead of
  // an in-process loopback server.
  const wsUrl = echoUrl;

  setUp(() async {
    await testSetUpTempDirForHive();
  });

  tearDown(() async {
    ConnectionManager.instance.disconnectAll();
  });

  group('apiType switching to websocket', () {
    late ProviderContainer container;
    late CollectionStateNotifier notifier;

    setUp(() {
      container = createContainer();
      notifier = container.read(collectionStateNotifierProvider.notifier);
    });

    test(
      'switching an existing request to APIType.websocket creates a non-null '
      'wsRequestModel and nulls out http/ai models',
      () {
        final id = notifier.state!.entries.first.key;

        // Initially a REST request: http model present, ws model absent.
        expect(notifier.getRequestModel(id)!.apiType, APIType.rest);
        expect(notifier.getRequestModel(id)!.httpRequestModel, isNotNull);
        expect(notifier.getRequestModel(id)!.wsRequestModel, isNull);

        notifier.update(id: id, apiType: APIType.websocket);

        final updated = notifier.getRequestModel(id)!;
        expect(updated.apiType, APIType.websocket);
        expect(updated.wsRequestModel, isNotNull);
        // Default websocket model created by the provider.
        expect(updated.wsRequestModel, const WebSocketRequestModel());
        expect(updated.wsRequestModel!.url, '');
        expect(updated.wsRequestModel!.messageHistory, isEmpty);
        // Sibling models are cleared on switch.
        expect(updated.httpRequestModel, isNull);
        expect(updated.aiRequestModel, isNull);
      },
    );

    test('adding a request then switching it to websocket yields ws model', () {
      notifier.add();
      // add() selects the newly added id.
      final id = container.read(selectedIdStateProvider)!;
      expect(notifier.getRequestModel(id)!.apiType, APIType.rest);

      notifier.update(id: id, apiType: APIType.websocket);

      final updated = notifier.getRequestModel(id)!;
      expect(updated.apiType, APIType.websocket);
      expect(updated.wsRequestModel, isNotNull);
    });

    test(
      'switching back from websocket to rest nulls wsRequestModel and '
      'restores an http model',
      () {
        final id = notifier.state!.entries.first.key;
        notifier.update(id: id, apiType: APIType.websocket);
        expect(notifier.getRequestModel(id)!.wsRequestModel, isNotNull);

        notifier.update(id: id, apiType: APIType.rest);
        final updated = notifier.getRequestModel(id)!;
        expect(updated.apiType, APIType.rest);
        expect(updated.wsRequestModel, isNull);
        expect(updated.httpRequestModel, isNotNull);
      },
    );

    test('switching to the same websocket apiType keeps the existing ws model',
        () {
      final id = notifier.state!.entries.first.key;
      notifier.update(id: id, apiType: APIType.websocket);

      // Give the ws model a custom url then "switch" to websocket again.
      notifier.update(
        id: id,
        wsRequestModel: const WebSocketRequestModel(url: 'wss://example.test'),
      );
      expect(
        notifier.getRequestModel(id)!.wsRequestModel!.url,
        'wss://example.test',
      );

      // apiType already websocket  so url survives.
      notifier.update(id: id, apiType: APIType.websocket);
      expect(
        notifier.getRequestModel(id)!.wsRequestModel!.url,
        'wss://example.test',
      );
    });

    tearDown(() {
      container.dispose();
    });
  });

  group('update() with websocket fields', () {
    late ProviderContainer container;
    late CollectionStateNotifier notifier;
    late String id;

    setUp(() {
      container = createContainer();
      notifier = container.read(collectionStateNotifierProvider.notifier);
      id = notifier.state!.entries.first.key;
      notifier.update(id: id, apiType: APIType.websocket);
    });

    test('update(wsRequestModel:) replaces the websocket model', () {
      const newWs = WebSocketRequestModel(
        url: 'wss://echo.websocket.org',
        autoReconnect: true,
        heartbeatInterval: 42,
      );

      notifier.update(id: id, wsRequestModel: newWs);

      final ws = notifier.getRequestModel(id)!.wsRequestModel!;
      expect(ws.url, 'wss://echo.websocket.org');
      expect(ws.autoReconnect, true);
      expect(ws.heartbeatInterval, 42);
    });

    test(
      'update(wsRequestModel:) on a websocket request merges headers/params '
      'passed alongside into the ws model (copyWith branch)',
      () {
        const headers = [NameValueModel(name: 'X-Token', value: 'abc')];
        const params = [NameValueModel(name: 'q', value: '1')];

        notifier.update(
          id: id,
          wsRequestModel: const WebSocketRequestModel(url: 'wss://h.test'),
          headers: headers,
          isHeaderEnabledList: const [true],
          params: params,
          isParamEnabledList: const [true],
        );

        final ws = notifier.getRequestModel(id)!.wsRequestModel!;
        expect(ws.url, 'wss://h.test');
        expect(ws.headers, headers);
        expect(ws.isHeaderEnabledList, const [true]);
        expect(ws.params, params);
        expect(ws.isParamEnabledList, const [true]);
      },
    );

    test('update(isStreaming:) flips the streaming flag', () {
      expect(notifier.getRequestModel(id)!.isStreaming, false);

      notifier.update(id: id, isStreaming: true);
      expect(notifier.getRequestModel(id)!.isStreaming, true);

      notifier.update(id: id, isStreaming: false);
      expect(notifier.getRequestModel(id)!.isStreaming, false);
    });

    test('update(isWorking:) flips the working flag', () {
      expect(notifier.getRequestModel(id)!.isWorking, false);

      notifier.update(id: id, isWorking: true);
      expect(notifier.getRequestModel(id)!.isWorking, true);

      notifier.update(id: id, isWorking: false);
      expect(notifier.getRequestModel(id)!.isWorking, false);
    });

    test('update(isStreaming:, isWorking:) can be set together', () {
      notifier.update(id: id, isStreaming: true, isWorking: true);
      final m = notifier.getRequestModel(id)!;
      expect(m.isStreaming, true);
      expect(m.isWorking, true);
    });

    test('omitting isStreaming/isWorking preserves their current values', () {
      notifier.update(id: id, isStreaming: true, isWorking: true);
      // Update something unrelated; flags should persist.
      notifier.update(id: id, name: 'My WS');
      final m = notifier.getRequestModel(id)!;
      expect(m.name, 'My WS');
      expect(m.isStreaming, true);
      expect(m.isWorking, true);
    });

    test('update with null id and no selected id is a no-op (no throw)', () {
      // Clear selection; update() reads selectedIdStateProvider when id is null.
      container.read(selectedIdStateProvider.notifier).state = null;
      // Should not throw and should not alter the existing request.
      final before = notifier.getRequestModel(id);
      notifier.update(isStreaming: true);
      expect(notifier.getRequestModel(id), before);
    });

    tearDown(() {
      container.dispose();
    });
  });

  group('sendWebSocketMessage', () {
    late ProviderContainer container;
    late CollectionStateNotifier notifier;
    late String id;

    setUp(() {
      container = createContainer();
      notifier = container.read(collectionStateNotifierProvider.notifier);
      id = notifier.state!.entries.first.key;
      // Switching apiType takes the reset branch in update() which installs a
      // fresh const WebSocketRequestModel(), so set the url in a second call.
      notifier.update(id: id, apiType: APIType.websocket);
      notifier.update(
        id: id,
        wsRequestModel: WebSocketRequestModel(url: wsUrl),
      );
    });

    test(
      'appends a sent WebSocketMessage to messageHistory when connected',
      () async {
        // Open a real connection via the ConnectionManager so send() succeeds.
        final channel = await ConnectionManager.instance.connect(id, wsUrl);
        await channel.ready;

        final before =
            notifier.getRequestModel(id)!.wsRequestModel!.messageHistory.length;

        notifier.sendWebSocketMessage(id, 'hi');

        final history =
            notifier.getRequestModel(id)!.wsRequestModel!.messageHistory;
        expect(history.length, before + 1);
        final sent = history.last;
        expect(sent.payload, 'hi');
        expect(sent.outgoing, true);
        expect(sent.messageType, WebSocketMessageType.sent);
      },
    );

    test(
      'still records the sent message even with no active channel '
      '(send() is a silent no-op, append still happens)',
      () {
        // No ConnectionManager.connect() called -> no channel for this id.
        expect(ConnectionManager.instance.hasConnection(id), false);

        notifier.sendWebSocketMessage(id, 'queued');

        final history =
            notifier.getRequestModel(id)!.wsRequestModel!.messageHistory;
        expect(history.last.payload, 'queued');
        expect(history.last.messageType, WebSocketMessageType.sent);
      },
    );

    test('does nothing when the request is not a websocket request', () {
      // Switch back to REST: wsRequestModel becomes null.
      notifier.update(id: id, apiType: APIType.rest);
      expect(notifier.getRequestModel(id)!.wsRequestModel, isNull);

      // Should early-return without throwing.
      notifier.sendWebSocketMessage(id, 'ignored');
      expect(notifier.getRequestModel(id)!.wsRequestModel, isNull);
    });

    test('does nothing for an unknown request id', () {
      // Should not throw for a non-existent id.
      notifier.sendWebSocketMessage('no-such-id', 'ignored');
      // State for the real request unchanged.
      expect(
        notifier.getRequestModel(id)!.wsRequestModel!.messageHistory,
        isEmpty,
      );
    });

    test(
      'echo server delivers a received message via the connect stream '
      '(sendRequest wires stream.listen)',
      () async {
        await driveSendRequestForWs(container, notifier, id);

        // After connecting, a "connected" message is appended, and isStreaming
        // becomes true.
        final afterConnect = notifier.getRequestModel(id)!;
        expect(
          afterConnect.wsRequestModel!.messageHistory.any(
            (m) => m.messageType == WebSocketMessageType.connected,
          ),
          true,
        );

        // Send a message and let the echo come back through the stream listener.
        // This is a REAL internet round-trip, so allow generous settle time.
        notifier.sendWebSocketMessage(id, 'echo-me');
        await Future.delayed(const Duration(seconds: 5));

        final history =
            notifier.getRequestModel(id)!.wsRequestModel!.messageHistory;
        // Sent message present.
        expect(
          history.any(
            (m) =>
                m.messageType == WebSocketMessageType.sent &&
                m.payload == 'echo-me',
          ),
          true,
        );
        // Received echo present (server echoes back the same payload).
        expect(
          history.any(
            (m) =>
                m.messageType == WebSocketMessageType.received &&
                m.payload == 'echo-me',
          ),
          true,
          reason: 'echoed message should be appended by the stream listener',
        );

        // Drain the connection while the notifier is still mounted so that the
        // stream's onDone callback (which touches state) runs before disposal.
        ConnectionManager.instance.disconnect(id);
        await Future.delayed(const Duration(seconds: 2));
        // After a clean close the provider flips isStreaming back to false and
        // records a disconnected message.
        final closed = notifier.getRequestModel(id)!;
        expect(closed.isStreaming, false);
        expect(
          closed.wsRequestModel!.messageHistory.any(
            (m) => m.messageType == WebSocketMessageType.disconnected,
          ),
          true,
        );
      },
    );

    tearDown(() {
      ConnectionManager.instance.disconnect(id);
      container.dispose();
    });
  });

  group('remove() disconnects websocket connections', () {
    late ProviderContainer container;
    late CollectionStateNotifier notifier;

    setUp(() {
      container = createContainer();
      notifier = container.read(collectionStateNotifierProvider.notifier);
    });

    test(
      'remove() on a websocket request tears down the active connection',
      () async {
        final id = notifier.state!.entries.first.key;
        notifier.update(id: id, apiType: APIType.websocket);
        notifier.update(
          id: id,
          wsRequestModel: WebSocketRequestModel(url: wsUrl),
        );

        // Establish a real connection through the manager.
        final channel = await ConnectionManager.instance.connect(id, wsUrl);
        await channel.ready;
        expect(ConnectionManager.instance.hasConnection(id), true);

        notifier.remove(id: id);

        // remove() calls ConnectionManager.instance.disconnect(id).
        expect(ConnectionManager.instance.hasConnection(id), false);
        // And the request is gone from the collection.
        expect(notifier.hasId(id), false);
      },
    );

    test(
      'remove() is safe when there is no active connection for the id',
      () {
        final id = notifier.state!.entries.first.key;
        notifier.update(id: id, apiType: APIType.websocket);
        expect(ConnectionManager.instance.hasConnection(id), false);

        // Should not throw.
        notifier.remove(id: id);
        expect(notifier.hasId(id), false);
        expect(ConnectionManager.instance.hasConnection(id), false);
      },
    );

    tearDown(() {
      container.dispose();
    });
  });
}

/// Helper that drives [sendRequest] for the currently-selected websocket
/// request. Selecting the id is required because sendRequest reads
/// selectedIdStateProvider.
Future<void> driveSendRequestForWs(
  ProviderContainer container,
  CollectionStateNotifier notifier,
  String id,
) async {
  container.read(selectedIdStateProvider.notifier).state = id;
  await notifier.sendRequest();
  // Allow channel.ready + connected message + listener wiring to settle.
  // Generous because this drives a REAL internet round-trip.
  await Future.delayed(const Duration(seconds: 5));
}
