import 'dart:io';
import 'package:better_networking/consts.dart';
import 'package:better_networking/models/http_request_model.dart';
import 'package:better_networking/services/http_service.dart';
import 'package:test/test.dart';

void main() {
  late HttpServer server;
  late String serverUrl;

  setUpAll(() async {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    serverUrl = 'http://${server.address.host}:${server.port}';

    server.listen((HttpRequest request) async {
      print('Received request: ${request.uri.path}');
      if (request.uri.path == '/test') {
        print('Returning test response');
        request.response
          ..statusCode = HttpStatus.ok
          ..headers.set('Content-Type', 'text/event-stream')
          ..headers.set('Cache-Control', 'no-cache')
          ..headers.set('Connection', 'keep-alive');
        
        request.response.write(': ' + ' ' * 10000 + '\n');
        request.response.write('data: msg1\n\n');
        await request.response.flush();
        await Future.delayed(const Duration(milliseconds: 500));
        
        request.response.write(': ' + ' ' * 10000 + '\n');
        request.response.write('data: msg2\n\n');
        await request.response.flush();
        
        // Wait so we don't close before client cancels
        await Future.delayed(const Duration(seconds: 10));
        await request.response.close();
      } else {
        request.response.statusCode = HttpStatus.notFound;
        await request.response.close();
      }
    });
  });

  tearDownAll(() async {
    await server.close(force: true);
  });

  group('streamHttpRequest: SSE Specific Tests', () {
    test(
      'SSE Stream - Should receive at least two events in 4 seconds',
      () async {
        final model = HttpRequestModel(
          url: '$serverUrl/test',
          method: HTTPVerb.get,
        );

        final stream = await streamHttpRequest('sse_test', APIType.rest, model);

        final outputs = <HttpStreamOutput?>[];
        final subscription = stream.listen(outputs.add);

        await Future.delayed(const Duration(seconds: 4));
        await subscription.cancel();

        final eventCount = outputs.where((e) => e?.$1 == true).length;
        expect(
          eventCount,
          greaterThanOrEqualTo(2),
          reason: 'Output -> $outputs',
        );
      },
      timeout: const Timeout(Duration(seconds: 12)),
    );

    test(
      'SSE Stream - Cancellation should work',
      () async {
        final model = HttpRequestModel(
          url: '$serverUrl/test',
          method: HTTPVerb.get,
        );

        final stream = await streamHttpRequest('sse_test', APIType.rest, model);
        final outputs = <HttpStreamOutput?>[];
        final subscription = stream.listen(outputs.add);

        await Future.delayed(const Duration(seconds: 1));
        httpClientManager.cancelRequest('sse_test');
        await Future.delayed(const Duration(milliseconds: 300));
        await subscription.cancel();

        final errMsg = outputs.lastOrNull?.$4;
        expect(errMsg, 'Request Cancelled');
      },
      timeout: const Timeout(Duration(seconds: 12)),
    );
  });
}
