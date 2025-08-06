import 'package:better_networking/consts.dart';
import 'package:better_networking/models/http_request_model.dart';
import 'package:better_networking/services/http_service.dart';
import 'package:test/test.dart';

void main() {
  group('streamHttpRequest: SSE Specific Tests', () {
    test(
      'SSE Stream - Should receive at least two events in 4 seconds',
      () async {
        const model = HttpRequestModel(
          url: 'https://sse.dev/test',
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
        const model = HttpRequestModel(
          url: 'https://sse.dev/test',
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
