import 'dart:isolate';
import '../models/isolate_message.dart';

import 'request_executor.dart';

class IsolateWorker {
  static Future<void> worker(SendPort sendPort) async {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    await for (final message in receivePort) {
      if (message is IsolateMessage) {
        final result = await RequestExecutor.execute(
          url: message.url,
          method: message.method,
          headers: message.headers,
          body: message.body,
          timeout: message.timeout,
        );
        sendPort.send(result);
      } else if (message == 'close') {
        break;
      }
    }
    Isolate.exit();
  }
}
