import 'package:better_networking/better_networking.dart';
import 'package:flutter/foundation.dart';
import 'package:test/test.dart';
import 'package:http/io_client.dart';

void main() {
  group('HttpClientManager', () {
    late HttpClientManager manager;

    setUp(() {
      manager = HttpClientManager();
    });

    test('createHttpClientWithNoSSL: returns an IOClient when not on web', () {
      if (!kIsWeb) {
        final client = manager.createClient('req2', noSSL: true);
        expect(client, isA<IOClient>());
      }
    });

    test('should track active client correctly', () {
      const requestId = 'req1';
      manager.createClient(requestId);
      expect(manager.hasActiveClient(requestId), isTrue);

      manager.closeClient(requestId);
      expect(manager.hasActiveClient(requestId), isFalse);
    });

    test('should limit _cancelledRequests and remove oldest', () {
      // Inject 101 cancelled request IDs
      for (int i = 0; i < 101; i++) {
        final requestId = 'cancel_$i';
        manager.createClient(requestId);
        manager.cancelRequest(requestId);
      }

      // Oldest should be 'cancel_0' and should have been removed
      expect(manager.wasRequestCancelled('cancel_0'), isFalse);

      // The newest should still be in the cancelled set
      expect(manager.wasRequestCancelled('cancel_100'), isTrue);
    });
  });
}
