import 'package:better_networking/services/websocket_service.dart';
import 'package:test/test.dart';

void main() {
  group('WebSocketService', () {
    late WebSocketService service;

    setUp(() {
      service = WebSocketService();
    });

    test('send throws exception when not connected', () {
      expect(
        () => service.send('req1', 'hello'),
        throwsA(isA<Exception>()),
      );
    });

    test('disconnect removes connection', () async {
      // safely calling disconnect on non-existent id should not throw
      await service.disconnect('req1');
    });

    test('dispose clears connections', () {
      // safely calling dispose should not throw
      service.dispose();
    });
  });
}
