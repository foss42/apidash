import 'dart:io';

import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/services/services.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'helpers.dart';

/// A loopback WebSocket server that accepts every connection and closes it
/// immediately: the server behaviour that used to drive the reconnect storm.
///
/// It binds to port 0 on the loopback interface, so the tests below stay on the
/// local machine and never touch the network.
class _FlappyWsServer {
  _FlappyWsServer(this._server);

  final HttpServer _server;

  /// How many connections the server has accepted. This is the storm counter:
  /// before the backoff existed it climbed without bound.
  int acceptedConnections = 0;

  static Future<_FlappyWsServer> start() async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final flappy = _FlappyWsServer(server);
    server.listen((request) async {
      flappy.acceptedConnections++;
      final socket = await WebSocketTransformer.upgrade(request);
      // Accept, then drop straight away.
      await socket.close();
    });
    return flappy;
  }

  String get url => 'ws://${_server.address.address}:${_server.port}';

  Future<void> stop() => _server.close(force: true);
}

/// Offline coverage for the WebSocket message-retention cap and the
/// auto-reconnect backoff, both as applied by the provider itself.
///
/// The retention tests use `cancelRequest()` as their entry point because it is
/// a real append site that needs no socket: no connection is ever opened for the
/// request id, so `ConnectionManager.disconnect` is a no-op.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await testSetUpTempDirForHive();
  });

  group('messageHistory retention', () {
    late ProviderContainer container;
    late CollectionStateNotifier notifier;
    late String id;

    setUp(() {
      container = createContainer();
      notifier = container.read(collectionStateNotifierProvider.notifier);
      id = notifier.state!.entries.first.key;
      // Switching apiType installs a fresh const WebSocketRequestModel(), so
      // any url/history has to be set in a follow-up update() call.
      notifier.update(id: id, apiType: APIType.websocket);
      container.read(selectedIdStateProvider.notifier).state = id;
    });

    test('cancelRequest() evicts the oldest message when history is full', () {
      final full = List.generate(
        kMaxWebSocketMessages,
        (i) => WebSocketMessage(payload: 'msg-$i'),
      );
      notifier.update(
        id: id,
        wsRequestModel: WebSocketRequestModel(
          url: 'wss://example.invalid/ws',
          messageHistory: full,
        ),
        isStreaming: true,
      );
      expect(
        notifier.getRequestModel(id)!.wsRequestModel!.messageHistory,
        hasLength(kMaxWebSocketMessages),
      );
      // Nothing was ever connected, so this stays entirely offline.
      expect(ConnectionManager.instance.hasConnection(id), isFalse);

      notifier.cancelRequest();

      final model = notifier.getRequestModel(id)!;
      final history = model.wsRequestModel!.messageHistory;
      // The append did not grow the list past the cap...
      expect(history, hasLength(kMaxWebSocketMessages));
      // ...the new message is still the most recent entry...
      expect(history.last.payload, 'Disconnected by user');
      expect(history.last.messageType, WebSocketMessageType.disconnected);
      // ...and it was the oldest message that made room, not the newest.
      expect(history.first.payload, 'msg-1');
      expect(model.isStreaming, isFalse);
      expect(model.isWorking, isFalse);
    });

    test('cancelRequest() appends normally when below the cap', () {
      notifier.update(
        id: id,
        wsRequestModel: const WebSocketRequestModel(
          url: 'wss://example.invalid/ws',
        ),
        isStreaming: true,
      );

      notifier.cancelRequest();

      final history = notifier
          .getRequestModel(id)!
          .wsRequestModel!
          .messageHistory;
      expect(history, hasLength(1));
      expect(history.single.payload, 'Disconnected by user');
    });

    test('repeated connect/disconnect cycles cannot grow history without '
        'bound', () {
      notifier.update(
        id: id,
        wsRequestModel: WebSocketRequestModel(
          url: 'wss://example.invalid/ws',
          messageHistory: List.generate(
            kMaxWebSocketMessages - 1,
            (i) => WebSocketMessage(payload: 'msg-$i'),
          ),
        ),
        isStreaming: true,
      );

      for (var i = 0; i < 5; i++) {
        notifier.cancelRequest();
        expect(
          notifier.getRequestModel(id)!.wsRequestModel!.messageHistory.length,
          lessThanOrEqualTo(kMaxWebSocketMessages),
        );
      }

      final history = notifier
          .getRequestModel(id)!
          .wsRequestModel!
          .messageHistory;
      expect(history, hasLength(kMaxWebSocketMessages));
      expect(history.last.payload, 'Disconnected by user');
    });
  });

  group('auto-reconnect backoff', () {
    late ProviderContainer container;
    late CollectionStateNotifier notifier;
    late String id;
    late _FlappyWsServer server;

    setUp(() async {
      container = createContainer();
      notifier = container.read(collectionStateNotifierProvider.notifier);
      id = notifier.state!.entries.first.key;
      notifier.update(id: id, apiType: APIType.websocket);
      container.read(selectedIdStateProvider.notifier).state = id;

      server = await _FlappyWsServer.start();
      addTearDown(() async {
        // Stop the ladder before the server goes away, so a queued retry cannot
        // fire against a dead port during another test.
        notifier.cancelRequest();
        ConnectionManager.instance.disconnect(id);
        await server.stop();
      });
    });

    /// Connect to the flapping server with auto-reconnect enabled.
    Future<void> connectWithAutoReconnect() async {
      notifier.update(
        id: id,
        wsRequestModel: WebSocketRequestModel(
          url: server.url,
          autoReconnect: true,
        ),
      );
      await notifier.sendRequest();
    }

    List<String> payloads() => notifier
        .getRequestModel(id)!
        .wsRequestModel!
        .messageHistory
        .map((m) => m.payload)
        .toList();

    test('a server that drops every connection gets one queued retry, '
        'not a storm', () async {
      await connectWithAutoReconnect();
      // Long enough for the close to be observed and the retry to be queued,
      // but shorter than the ~0.5-1.0s first backoff delay.
      await Future.delayed(const Duration(milliseconds: 400));

      // Pre-fix this reconnected immediately and unboundedly; now the only
      // connection made so far is the original one.
      expect(server.acceptedConnections, 1);
      expect(
        payloads(),
        contains(
          allOf(
            contains('Reconnecting in'),
            contains('attempt 1 of $kWsMaxReconnectAttempts'),
          ),
        ),
      );
      // The request keeps streaming across the gap: the retry is pending, so the
      // session is recovering rather than finished.
      expect(notifier.getRequestModel(id)!.isStreaming, isTrue);
    });

    test('the delay escalates on each successive failure', () async {
      await connectWithAutoReconnect();
      // Covers the first retry (~0.5-1.0s) and the scheduling of the second
      // (~1.0-2.0s), which is appended as soon as the retry's close is seen.
      await Future.delayed(const Duration(milliseconds: 2500));

      final attemptMsgs = payloads()
          .where((p) => p.contains('Reconnecting in'))
          .toList();
      expect(attemptMsgs.length, greaterThanOrEqualTo(2));
      expect(attemptMsgs[0], contains('attempt 1 of'));
      expect(attemptMsgs[1], contains('attempt 2 of'));
      // Growing delays mean only a couple of connections land in 2.5s. The
      // immediate-reconnect loop this replaces made hundreds.
      expect(server.acceptedConnections, lessThanOrEqualTo(3));
    });

    test('a user disconnect cancels the queued retry', () async {
      await connectWithAutoReconnect();
      await Future.delayed(const Duration(milliseconds: 400));
      expect(server.acceptedConnections, 1);

      notifier.cancelRequest();

      // Well past the first backoff delay: the cancelled timer must not fire.
      await Future.delayed(const Duration(milliseconds: 1500));
      expect(server.acceptedConnections, 1);
      final model = notifier.getRequestModel(id)!;
      expect(model.isStreaming, isFalse);
      expect(model.isWorking, isFalse);
      expect(payloads().last, 'Disconnected by user');
    });

    test('turning auto-reconnect off mid-backoff stops the retry', () async {
      await connectWithAutoReconnect();
      await Future.delayed(const Duration(milliseconds: 400));
      expect(server.acceptedConnections, 1);

      final ws = notifier.getRequestModel(id)!.wsRequestModel!;
      notifier.update(
        id: id,
        wsRequestModel: ws.copyWith(autoReconnect: false),
      );

      await Future.delayed(const Duration(milliseconds: 1500));
      // The timer still fires, but re-checks intent and gives up instead of
      // reconnecting.
      expect(server.acceptedConnections, 1);
    });

    test('history stays capped even while reconnects churn', () async {
      notifier.update(
        id: id,
        wsRequestModel: WebSocketRequestModel(
          url: server.url,
          autoReconnect: true,
          messageHistory: List.generate(
            kMaxWebSocketMessages - 1,
            (i) => WebSocketMessage(payload: 'msg-$i'),
          ),
        ),
      );
      await notifier.sendRequest();
      await Future.delayed(const Duration(milliseconds: 2500));

      expect(
        notifier.getRequestModel(id)!.wsRequestModel!.messageHistory,
        hasLength(kMaxWebSocketMessages),
      );
    });
  });
}
