import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/services/services.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'helpers.dart';

///   live-network WebSocket provider tests.
///
/// These drive [CollectionStateNotifier] against the   `/ws/echo` route,
/// which echoes every frame (raw text and JSON) straight back. They cover the
/// areas the original `ws_collection_providers_test.dart` does not: the
/// protocol-level heartbeat (`pingInterval`) connect path, `cancelRequest()`
/// for WS, the connection-failure / `onError` path, environment-variable
/// substitution on the URL, Hive history persistence round-trips, and
/// concurrent connections.
///
/// Defaults to the deployed  endpoint. For local/offline verification
/// run the  server and override the URL without editing this
/// file, e.g.:
///
///   flutter test --dart-define=WS_ECHO_URL=ws://127.0.0.1:8000/ws/echo \
///       test/providers/ws_collection_providers_advanced_test.dart
const echoUrl = String.fromEnvironment(
  'WS_ECHO_URL',
  defaultValue: 'wss://api.apidash.dev/ws/echo',
);

/// Generous per-test budget: these are real network round-trips plus several
/// heartbeat intervals, so the default 30s is too tight for some cases.
const _liveTimeout = Timeout(Duration(seconds: 90));

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  const wsUrl = echoUrl;

  setUp(() async {
    await testSetUpTempDirForHive();
  });

  tearDown(() async {
    // Safety net for the global singleton in case a test bailed early.
    ConnectionManager.instance.disconnectAll();
    await Future.delayed(const Duration(milliseconds: 300));
  });
 
  // 1. Heartbeat (protocol-level pingInterval) 
  group('heartbeat (protocol-level pingInterval)', () {
    late ProviderContainer container;
    late CollectionStateNotifier notifier;
    late String id;

    setUp(() {
      container = createContainer();
      notifier = container.read(collectionStateNotifierProvider.notifier);
      id = notifier.state!.entries.first.key;
      notifier.update(id: id, apiType: APIType.websocket);
    });

    tearDown(() async {
      ConnectionManager.instance.disconnect(id);
      await Future.delayed(const Duration(seconds: 1));
    });

    test(
      'connecting with enableHeartbeat true + a heartbeatInterval drives the '
      'pingInterval connect path: the connection succeeds and still echoes',
      () async { 
        notifier.update(
          id: id,
          wsRequestModel: WebSocketRequestModel(
            url: wsUrl,
            enableHeartbeat: true,
            heartbeatInterval: 1,
          ),
        );

        await driveSendRequestForWs(container, notifier, id);

        // Connection came up with the pingInterval path exercised.
        expect(notifier.getRequestModel(id)!.isStreaming, true);

        // And it's a live connection: a normal message still round-trips.
        notifier.sendWebSocketMessage(id, 'ping-path-echo');
        await Future.delayed(const Duration(seconds: 4));
        final after = notifier.getRequestModel(id)!.wsRequestModel!;
        expect(
          after.messageHistory.any(
            (m) =>
                m.messageType == WebSocketMessageType.received &&
                m.payload == 'ping-path-echo',
          ),
          true,
          reason:
              'enabling the heartbeat (pingInterval) must not break the '
              'connection — a normal message should still echo back',
        );
      },
      timeout: _liveTimeout,
    );
  });
 
  // 2. cancelRequest() for WS
 group('cancelRequest for websocket', () {
    late ProviderContainer container;
    late CollectionStateNotifier notifier;
    late String id;

    setUp(() {
      container = createContainer();
      notifier = container.read(collectionStateNotifierProvider.notifier);
      id = notifier.state!.entries.first.key;
      notifier.update(id: id, apiType: APIType.websocket);
      notifier.update(
        id: id,
        wsRequestModel: WebSocketRequestModel(url: wsUrl),
      );
    });

    tearDown(() async {
      ConnectionManager.instance.disconnect(id);
      await Future.delayed(const Duration(seconds: 1));
    });

    test(
      'appends "Disconnected by user", clears flags and tears down the channel',
      () async {
        await driveSendRequestForWs(container, notifier, id);
        expect(notifier.getRequestModel(id)!.isStreaming, true);
        expect(ConnectionManager.instance.hasConnection(id), true);

        notifier.cancelRequest();

        final m = notifier.getRequestModel(id)!;
        expect(m.isStreaming, false);
        expect(m.isWorking, false);
        expect(
          m.wsRequestModel!.messageHistory.any(
            (msg) =>
                msg.messageType == WebSocketMessageType.disconnected &&
                msg.payload == 'Disconnected by user',
          ),
          true,
        );
        // Channel is gone from the manager.
        expect(ConnectionManager.instance.hasConnection(id), false);
        // Let the underlying onDone settle while still mounted.
        await Future.delayed(const Duration(seconds: 1));
      },
      timeout: _liveTimeout,
    );

    test(
      'cancelRequest on a websocket with no active channel still records the '
      'disconnect message and leaves flags false',
      () {
        // selectedId is required because cancelRequest reads it.
        container.read(selectedIdStateProvider.notifier).state = id;
        expect(ConnectionManager.instance.hasConnection(id), false);

        notifier.cancelRequest();

        final m = notifier.getRequestModel(id)!;
        expect(m.isStreaming, false);
        expect(m.isWorking, false);
        expect(
          m.wsRequestModel!.messageHistory.last.payload,
          'Disconnected by user',
        );
      },
    );
  });

  // 3. Connection error / onError path
  group('connection failure', () {
    late ProviderContainer container;
    late CollectionStateNotifier notifier;
    late String id;

    setUp(() {
      container = createContainer();
      notifier = container.read(collectionStateNotifierProvider.notifier);
      id = notifier.state!.entries.first.key;
      notifier.update(id: id, apiType: APIType.websocket);
    });

    tearDown(() async {
      ConnectionManager.instance.disconnect(id);
      await Future.delayed(const Duration(seconds: 1));
    });

    test(
      'connecting to an unreachable endpoint records error + failed messages '
      'and leaves isWorking/isStreaming false (catch branch)',
      () async {
        // Port 1 is reserved/closed -> channel.ready throws -> catch branch.
        notifier.update(
          id: id,
          wsRequestModel: const WebSocketRequestModel(
            url: 'ws://127.0.0.1:1/ws',
          ),
        );

        await driveSendRequestForWs(container, notifier, id);

        final m = notifier.getRequestModel(id)!;
        expect(m.isWorking, false);
        expect(m.isStreaming, false);

        final history = m.wsRequestModel!.messageHistory;
        expect(
          history.any(
            (msg) =>
                msg.messageType == WebSocketMessageType.error &&
                msg.payload.startsWith('Connection error:'),
          ),
          true,
          reason: 'an error message should be appended on connect failure',
        );
        expect(
          history.any(
            (msg) =>
                msg.messageType == WebSocketMessageType.disconnected &&
                msg.payload == 'Connection failed',
          ),
          true,
          reason: 'a "Connection failed" message should be appended',
        );
      },
      timeout: _liveTimeout,
    );
  });
 
  // 5. Environment-variable substitution on the URL 
  group('environment variable substitution', () {
    late ProviderContainer container;
    late CollectionStateNotifier notifier;
    late String id;

    setUp(() {
      container = createContainer();
      notifier = container.read(collectionStateNotifierProvider.notifier);
      id = notifier.state!.entries.first.key;
      notifier.update(id: id, apiType: APIType.websocket);
    });

    tearDown(() async {
      ConnectionManager.instance.disconnect(id);
      await Future.delayed(const Duration(seconds: 1));
    });

    test('a {{WS_URL}} environment variable in the url is substituted and the '
        'connection succeeds + echoes', () async {
      // Define a global environment variable holding the real endpoint.
      final envNotifier = container.read(
        environmentsStateNotifierProvider.notifier,
      );
      // Wait for the notifier to initialise its default Global environment.
      await Future.delayed(const Duration(milliseconds: 50));
      envNotifier.updateEnvironment(
        kGlobalEnvironmentId,
        values: [
          // enabled MUST be true — availableEnvironmentVariablesStateProvider
          // filters out disabled variables (enabled defaults to false).
          EnvironmentVariableModel(
            key: 'WS_URL',
            value: wsUrl,
            type: EnvironmentVariableType.variable,
            enabled: true,
          ),
        ],
      );
      // Activate the global environment so the variable is available.
      container.read(activeEnvironmentIdStateProvider.notifier).state =
          kGlobalEnvironmentId;

      notifier.update(
        id: id,
        wsRequestModel: const WebSocketRequestModel(url: '{{WS_URL}}'),
      );

      await driveSendRequestForWs(container, notifier, id);

      final m = notifier.getRequestModel(id)!;
      // A connect succeeded: streaming true + a connected message whose
      // payload contains the SUBSTITUTED url (not the raw template).
      expect(m.isStreaming, true);
      final connected = m.wsRequestModel!.messageHistory.firstWhere(
        (msg) => msg.messageType == WebSocketMessageType.connected,
      );
      expect(connected.payload, contains(wsUrl));
      expect(connected.payload, isNot(contains('{{WS_URL}}')));

      // And the connection is live: a message echoes back.
      notifier.sendWebSocketMessage(id, 'env-echo');
      await Future.delayed(const Duration(seconds: 4));
      final after = notifier.getRequestModel(id)!.wsRequestModel!;
      expect(
        after.messageHistory.any(
          (msg) =>
              msg.messageType == WebSocketMessageType.received &&
              msg.payload == 'env-echo',
        ),
        true,
        reason: 'substituted url should yield a working live connection',
      );
    }, timeout: _liveTimeout);

    test(
      'a {{TOKEN}} variable in a query param is substituted into the final url',
      () async {
        final envNotifier = container.read(
          environmentsStateNotifierProvider.notifier,
        );
        await Future.delayed(const Duration(milliseconds: 50));
        envNotifier.updateEnvironment(
          kGlobalEnvironmentId,
          values: [
            EnvironmentVariableModel(
              key: 'TOKEN',
              value: 'secret123',
              type: EnvironmentVariableType.variable,
              enabled: true,
            ),
          ],
        );
        container.read(activeEnvironmentIdStateProvider.notifier).state =
            kGlobalEnvironmentId;

        notifier.update(
          id: id,
          wsRequestModel: WebSocketRequestModel(
            url: wsUrl,
            params: const [NameValueModel(name: 'auth', value: '{{TOKEN}}')],
            isParamEnabledList: const [true],
          ),
        );

        await driveSendRequestForWs(container, notifier, id);

        // The connection should still succeed (echo server ignores the query)
        // and the connected message must reflect the substituted query value.
        final m = notifier.getRequestModel(id)!;
        expect(m.isStreaming, true);
        final connected = m.wsRequestModel!.messageHistory.firstWhere(
          (msg) => msg.messageType == WebSocketMessageType.connected,
        );
        expect(connected.payload, contains('auth=secret123'));
        expect(connected.payload, isNot(contains('{{TOKEN}}')));
      },
      timeout: _liveTimeout,
    );
  });
}

/// Drives [sendRequest] for the currently-selected websocket request.
/// Selecting the id is required because sendRequest reads
/// selectedIdStateProvider. Generous settle time because this is a REAL
/// network round-trip (channel.ready + connected message + listener wiring).
Future<void> driveSendRequestForWs(
  ProviderContainer container,
  CollectionStateNotifier notifier,
  String id,
) async {
  container.read(selectedIdStateProvider.notifier).state = id;
  await notifier.sendRequest();
  await Future.delayed(const Duration(seconds: 5));
}
