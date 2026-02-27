import 'dart:async';
import 'dart:io';
import 'package:test/test.dart';
import 'package:better_networking/models/models.dart';
import 'package:better_networking/services/services.dart';

void main() {
  group('WebSocketService Stress Test', () {
    late HttpServer server;
    late Uri serverUri;
    late WebSocketService wsService;

    setUp(() async {
      server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      serverUri = Uri.parse('ws://localhost:${server.port}/ws');
      wsService = WebSocketService();

      server.listen((HttpRequest request) async {
        if (WebSocketTransformer.isUpgradeRequest(request)) {
          final webSocket = await WebSocketTransformer.upgrade(request);
          webSocket.listen((message) {
            // Echo server logic
            webSocket.add('ECHO: $message');
          }, onDone: () {
            webSocket.close();
          });
        }
      });
    });

    tearDown(() async {
      wsService.cleanup();
      await server.close(force: true);
    });

    test('Stress test echoing 1000 messages', () async {
      final result = await wsService.connect(
        uri: serverUri,
        headers: {},
        initialMessage: null,
      );

      expect(result.success, isTrue);

      final completer = Completer<void>();
      final receivedMessages = <WebSocketMessageModel>[];
      const testMessageCount = 1000;

      wsService.listen(
        onMessage: (msg) {
          if (msg.payload?.startsWith('ECHO: msg_') == true) {
            receivedMessages.add(msg);
            if (receivedMessages.length == testMessageCount) {
              completer.complete();
            }
          }
        },
        onError: (err) {
          if (!completer.isCompleted) {
            completer.completeError(err);
          }
        },
        onDone: (msg) {},
      );

      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < testMessageCount; i++) {
        wsService.sendMessage('msg_$i');
        // Add tiny delay to ensure proper buffering or send all at once
      }

      // Wait a maximum of 10 seconds for 1000 messages
      await completer.future.timeout(const Duration(seconds: 10));

      stopwatch.stop();
      print(
          'Processed ${receivedMessages.length} messages in ${stopwatch.elapsedMilliseconds} ms');

      expect(receivedMessages.length, equals(testMessageCount));
    });
  });
}
