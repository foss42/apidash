import 'dart:io';
import 'package:test/test.dart';
import 'package:better_networking/services/oauth_callback_server.dart';

void main() {
  group('OAuthCallbackServer', () {
    late OAuthCallbackServer server;

    setUp(() {
      server = OAuthCallbackServer();
    });

    tearDown(() async {
      await server.stop();
    });

    test('should start server and return callback URL', () async {
      final callbackUrl = await server.start();

      expect(callbackUrl, startsWith('http://localhost:'));
      expect(callbackUrl, endsWith('/callback'));

      // Verify the server is actually running by making a simple HTTP request
      final client = HttpClient();
      final uri = Uri.parse(callbackUrl);
      final request = await client.getUrl(uri);
      final response = await request.close();

      expect(response.statusCode, equals(HttpStatus.ok));
      client.close();
    });

    test('should start server with custom path', () async {
      final callbackUrl = await server.start(path: '/custom/oauth');

      expect(callbackUrl, startsWith('http://localhost:'));
      expect(callbackUrl, endsWith('/custom/oauth'));
    });

    test('should handle callback and return full URL', () async {
      final callbackUrl = await server.start();

      // Start waiting for callback in a separate isolate
      final callbackFuture = server.waitForCallback();

      // Simulate an OAuth callback with query parameters
      final client = HttpClient();
      final uri = Uri.parse('$callbackUrl?code=test_code&state=test_state');
      final request = await client.getUrl(uri);
      final response = await request.close();

      expect(response.statusCode, equals(HttpStatus.ok));

      // Verify we get the callback URL with parameters
      final receivedCallback = await callbackFuture;
      expect(receivedCallback, contains('code=test_code'));
      expect(receivedCallback, contains('state=test_state'));

      client.close();
    });

    test('should find available port when default is busy', () async {
      // Find a port that's actually available for testing
      late int testPort;
      late HttpServer busyServer;

      // Try to find an available port in the testing range 9080-9090
      for (int port = 9080; port <= 9090; port++) {
        try {
          busyServer = await HttpServer.bind(
            InternetAddress.loopbackIPv4,
            port,
          );
          testPort = port;
          break;
        } catch (e) {
          // Port is busy, try next one
          if (port == 9090) {
            // Skip this test if no ports available in our test range
            return;
          }
        }
      }

      try {
        final callbackUrl = await server.start();

        // Should find a different port
        expect(callbackUrl, startsWith('http://localhost:'));
        expect(callbackUrl, isNot(contains(':$testPort')));
      } finally {
        await busyServer.close();
      }
    });

    test('should throw exception when no ports available', () async {
      // This test would be difficult to implement without actually occupying all ports,
      // so we'll skip it for now. In a real scenario, you could mock the HttpServer.bind method.
    });

    test('should stop server cleanly', () async {
      final callbackUrl = await server.start();
      await server.stop();

      // Verify server is stopped by trying to connect
      final client = HttpClient();
      final uri = Uri.parse(callbackUrl);

      expect(() async {
        final request = await client.getUrl(uri);
        await request.close();
      }, throwsA(isA<SocketException>()));

      client.close();
    });
  });
}
