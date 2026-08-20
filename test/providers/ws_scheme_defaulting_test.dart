import 'dart:io';

import 'package:apidash/models/models.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/services/services.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

/// End-to-end coverage for defaulting the ws/wss scheme (#1747).
///
/// Uses a scoped loopback echo server rather than the deployed endpoint, so
/// these stay offline and deterministic. A local server is also the only way
/// to exercise the case the issue is about: `localhost:<port>` typed without a
/// scheme, which must resolve to `ws://` rather than `wss://`.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late HttpServer server;
  late int port;

  setUp(() async {
    await testSetUpTempDirForHive();
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    port = server.port;
    server.listen((req) async {
      final socket = await WebSocketTransformer.upgrade(req);
      socket.listen(socket.add, onError: (_) {});
    });
  });

  tearDown(() async {
    ConnectionManager.instance.disconnectAll();
    await server.close(force: true);
  });

  /// Points the selected request at [url] as a websocket request and connects.
  Future<RequestModel> connectTo(
    ProviderContainer container,
    CollectionStateNotifier notifier,
    String url,
  ) async {
    final id = notifier.state!.entries.first.key;
    notifier.update(id: id, apiType: APIType.websocket);
    notifier.update(id: id, wsRequestModel: WebSocketRequestModel(url: url));
    container.read(selectedIdStateProvider.notifier).state = id;
    await notifier.sendRequest();
    await Future.delayed(const Duration(milliseconds: 500));
    return notifier.getRequestModel(id)!;
  }

  bool isConnected(RequestModel model) =>
      model.wsRequestModel!.messageHistory.any(
        (m) => m.messageType == WebSocketMessageType.connected,
      );

  test('connects when the ws:// scheme is omitted from a localhost URL',
      () async {
    final container = createContainer();
    final notifier = container.read(collectionStateNotifierProvider.notifier);

    // The URL the issue is about: no scheme at all.
    final model = await connectTo(container, notifier, 'localhost:$port');

    expect(isConnected(model), true,
        reason: 'a schemeless localhost URL should default to ws:// and '
            'connect, rather than failing to parse');
    expect(model.isStreaming, true);
  });

  test('connects when the ws:// scheme is omitted from a bare IP URL',
      () async {
    final container = createContainer();
    final notifier = container.read(collectionStateNotifierProvider.notifier);

    // Uri.parse throws on this input, so it has to be handled before parsing.
    final model = await connectTo(container, notifier, '127.0.0.1:$port');

    expect(isConnected(model), true);
    expect(model.isStreaming, true);
  });

  test('still connects when the ws:// scheme is given explicitly', () async {
    final container = createContainer();
    final notifier = container.read(collectionStateNotifierProvider.notifier);

    final model = await connectTo(container, notifier, 'ws://localhost:$port');

    expect(isConnected(model), true);
    expect(model.isStreaming, true);
  });
}
