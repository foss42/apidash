import 'dart:convert';

import 'package:better_networking/consts.dart';
import 'package:better_networking/models/http_request_model.dart';
import 'package:better_networking/services/http_service.dart';
import 'package:seed/models/name_value_model.dart';
import 'package:test/test.dart';

void main() {
  group('HttpService Streaming Tests', () {
    test('REST Test: GET Request (should return 200)', () async {
      const model = HttpRequestModel(
        url: 'https://jsonplaceholder.typicode.com/posts/1',
        method: HTTPVerb.get,
        headers: [
          NameValueModel(name: 'User-Agent', value: 'Dart/3.0 (dart:io)'),
          NameValueModel(name: 'Accept', value: 'application/json'),
        ],
      );
      final stream = await streamHttpRequest('get_test', APIType.rest, model);
      final output = await stream.first;
      expect(
        output?.$2?.statusCode == 200,
        true,
        reason: 'Response must be 200',
      );
      expect(output?.$2?.body, contains('userId'));
    });

    test('GraphQL Test (Should get the correct data)', () async {
      const rawQuery = r'''query {
      country(code: "IN") {
        name
        capital
        emoji
      }
    }
  ''';
      const model = HttpRequestModel(
        url: 'https://countries.trevorblades.com/',
        query: rawQuery,
      );

      final stream = await streamHttpRequest(
        'graphql_test',
        APIType.graphql,
        model,
      );

      final response = await stream.first;

      expect(response, isNotNull, reason: 'No response from GraphQL server');
      final body = response!.$2?.body ?? '{}';

      final decoded = jsonDecode(body);
      final errors = decoded['errors'];
      if (errors != null) {
        fail('GraphQL Error: ${jsonEncode(errors)}');
      }

      final country = decoded['data']?['country'];
      expect(country, isNotNull, reason: 'No country data found');
      expect(country['name'], equals('India'));
      expect(country['capital'], isNotEmpty);
      expect(country['emoji'], isNotEmpty);
    });
  });

  test(
    'SSE Stream - Should receive at least one event in 3 seconds',
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
        greaterThanOrEqualTo(1),
        reason: 'No SSE events received',
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
      expect(
        errMsg,
        'Request Cancelled',
        reason: 'Request Cancellation Failed',
      );
    },
    timeout: const Timeout(Duration(seconds: 12)),
  );
}
