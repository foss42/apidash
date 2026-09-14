import 'package:better_networking/utils/response_evaluator.dart';
import 'package:better_networking/models/http_response_model.dart';
import 'package:test/test.dart';

void main() {
  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  HttpResponseModel makeResponse({
    int? statusCode = 200,
    Duration? time = const Duration(milliseconds: 150),
    String? body = '{"status":"ok","data":{"id":1}}',
    Map<String, String>? headers = const {
      'content-type': 'application/json',
    },
  }) {
    return HttpResponseModel(
      statusCode: statusCode,
      time: time,
      body: body,
      headers: headers,
    );
  }

  // ---------------------------------------------------------------------------
  // evaluateResponse — no assertions
  // ---------------------------------------------------------------------------

  group('evaluateResponse - empty expectation', () {
    test('returns empty list when no assertions are configured', () {
      final results = evaluateResponse(
        makeResponse(),
        const ResponseExpectation(),
      );
      expect(results, isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  // Status code
  // ---------------------------------------------------------------------------

  group('EvalField.statusCode', () {
    test('passes when status code matches', () {
      final results = evaluateResponse(
        makeResponse(statusCode: 200),
        const ResponseExpectation(statusCode: 200),
      );
      expect(results, hasLength(1));
      expect(results[0].field, EvalField.statusCode);
      expect(results[0].passed, isTrue);
      expect(results[0].expected, 200);
      expect(results[0].actual, 200);
    });

    test('fails when status code does not match', () {
      final results = evaluateResponse(
        makeResponse(statusCode: 404),
        const ResponseExpectation(statusCode: 200),
      );
      expect(results[0].passed, isFalse);
      expect(results[0].expected, 200);
      expect(results[0].actual, 404);
    });

    test('fails when response status code is null', () {
      final results = evaluateResponse(
        makeResponse(statusCode: null),
        const ResponseExpectation(statusCode: 200),
      );
      expect(results[0].passed, isFalse);
      expect(results[0].actual, isNull);
    });

    test('passes for 4xx expected status', () {
      final results = evaluateResponse(
        makeResponse(statusCode: 422),
        const ResponseExpectation(statusCode: 422),
      );
      expect(results[0].passed, isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // Latency
  // ---------------------------------------------------------------------------

  group('EvalField.latency', () {
    test('passes when response time is within limit', () {
      final results = evaluateResponse(
        makeResponse(time: const Duration(milliseconds: 80)),
        const ResponseExpectation(maxLatency: Duration(milliseconds: 200)),
      );
      expect(results[0].field, EvalField.latency);
      expect(results[0].passed, isTrue);
    });

    test('passes when response time equals limit exactly', () {
      final results = evaluateResponse(
        makeResponse(time: const Duration(milliseconds: 200)),
        const ResponseExpectation(maxLatency: Duration(milliseconds: 200)),
      );
      expect(results[0].passed, isTrue);
    });

    test('fails when response time exceeds limit', () {
      final results = evaluateResponse(
        makeResponse(time: const Duration(milliseconds: 500)),
        const ResponseExpectation(maxLatency: Duration(milliseconds: 200)),
      );
      expect(results[0].passed, isFalse);
      expect(results[0].actual, '500ms');
      expect(results[0].expected, '≤ 200ms');
    });

    test('fails when response time is null', () {
      final results = evaluateResponse(
        makeResponse(time: null),
        const ResponseExpectation(maxLatency: Duration(milliseconds: 200)),
      );
      expect(results[0].passed, isFalse);
      expect(results[0].actual, isNull);
      expect(results[0].message, contains('unavailable'));
    });
  });

  // ---------------------------------------------------------------------------
  // JSON key presence
  // ---------------------------------------------------------------------------

  group('EvalField.jsonKeyPresence', () {
    test('passes when all required keys are present', () {
      final results = evaluateResponse(
        makeResponse(body: '{"status":"ok","data":{"id":1}}'),
        const ResponseExpectation(requiredJsonKeys: ['status', 'data']),
      );
      expect(results[0].field, EvalField.jsonKeyPresence);
      expect(results[0].passed, isTrue);
      expect(results[0].message, contains('All required keys present'));
    });

    test('fails when a required key is missing', () {
      final results = evaluateResponse(
        makeResponse(body: '{"status":"ok"}'),
        const ResponseExpectation(requiredJsonKeys: ['status', 'data']),
      );
      expect(results[0].passed, isFalse);
      expect(results[0].message, contains('data'));
    });

    test('fails when body is not valid JSON', () {
      final results = evaluateResponse(
        makeResponse(body: 'not json'),
        const ResponseExpectation(requiredJsonKeys: ['key']),
      );
      expect(results[0].passed, isFalse);
      expect(results[0].message, contains('not valid JSON'));
    });

    test('fails when body is null', () {
      final results = evaluateResponse(
        makeResponse(body: null),
        const ResponseExpectation(requiredJsonKeys: ['key']),
      );
      expect(results[0].passed, isFalse);
    });

    test('skips evaluation when requiredJsonKeys is empty list', () {
      final results = evaluateResponse(
        makeResponse(),
        const ResponseExpectation(requiredJsonKeys: []),
      );
      expect(results, isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  // Body contains
  // ---------------------------------------------------------------------------

  group('EvalField.bodyContains', () {
    test('passes when body contains expected string', () {
      final results = evaluateResponse(
        makeResponse(body: '{"message":"success","token":"abc123"}'),
        const ResponseExpectation(bodyContains: 'success'),
      );
      expect(results[0].field, EvalField.bodyContains);
      expect(results[0].passed, isTrue);
    });

    test('fails when body does not contain expected string', () {
      final results = evaluateResponse(
        makeResponse(body: '{"message":"error"}'),
        const ResponseExpectation(bodyContains: 'success'),
      );
      expect(results[0].passed, isFalse);
    });

    test('passes when body is empty string and needle is also empty', () {
      final results = evaluateResponse(
        makeResponse(body: ''),
        const ResponseExpectation(bodyContains: ''),
      );
      expect(results[0].passed, isTrue);
    });

    test('treats null body as empty string', () {
      final results = evaluateResponse(
        makeResponse(body: null),
        const ResponseExpectation(bodyContains: 'data'),
      );
      expect(results[0].passed, isFalse);
    });

    test('truncates long body in actual field', () {
      final longBody = 'x' * 200;
      final results = evaluateResponse(
        makeResponse(body: longBody),
        const ResponseExpectation(bodyContains: 'y'),
      );
      final actual = results[0].actual as String;
      expect(actual, endsWith('…'));
      expect(actual.length, lessThan(200));
    });
  });

  // ---------------------------------------------------------------------------
  // Content type
  // ---------------------------------------------------------------------------

  group('EvalField.contentType', () {
    test('passes when content-type contains expected substring', () {
      final results = evaluateResponse(
        makeResponse(headers: {'content-type': 'application/json; charset=utf-8'}),
        const ResponseExpectation(contentType: 'application/json'),
      );
      expect(results[0].field, EvalField.contentType);
      expect(results[0].passed, isTrue);
    });

    test('fails when content-type does not match', () {
      final results = evaluateResponse(
        makeResponse(headers: {'content-type': 'text/html'}),
        const ResponseExpectation(contentType: 'application/json'),
      );
      expect(results[0].passed, isFalse);
      expect(results[0].actual, 'text/html');
    });

    test('fails when headers are null', () {
      final results = evaluateResponse(
        makeResponse(headers: null),
        const ResponseExpectation(contentType: 'application/json'),
      );
      expect(results[0].passed, isFalse);
      expect(results[0].actual, isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // Multiple assertions combined
  // ---------------------------------------------------------------------------

  group('evaluateResponse - multiple assertions', () {
    test('returns one result per configured assertion', () {
      final results = evaluateResponse(
        makeResponse(
          statusCode: 200,
          time: const Duration(milliseconds: 100),
          body: '{"id":1,"name":"test"}',
          headers: {'content-type': 'application/json'},
        ),
        const ResponseExpectation(
          statusCode: 200,
          maxLatency: Duration(milliseconds: 500),
          requiredJsonKeys: ['id', 'name'],
          bodyContains: 'test',
          contentType: 'application/json',
        ),
      );

      expect(results, hasLength(5));
      expect(results.every((r) => r.passed), isTrue);
    });

    test('correctly reports mix of pass and fail', () {
      final results = evaluateResponse(
        makeResponse(
          statusCode: 500,
          time: const Duration(milliseconds: 800),
        ),
        const ResponseExpectation(
          statusCode: 200,
          maxLatency: Duration(milliseconds: 500),
        ),
      );

      expect(results, hasLength(2));
      expect(results[0].field, EvalField.statusCode);
      expect(results[0].passed, isFalse);
      expect(results[1].field, EvalField.latency);
      expect(results[1].passed, isFalse);
    });

    test('result order matches ResponseExpectation field order', () {
      final results = evaluateResponse(
        makeResponse(),
        const ResponseExpectation(
          statusCode: 200,
          maxLatency: Duration(seconds: 1),
          requiredJsonKeys: ['status'],
          bodyContains: 'ok',
          contentType: 'json',
        ),
      );

      expect(results[0].field, EvalField.statusCode);
      expect(results[1].field, EvalField.latency);
      expect(results[2].field, EvalField.jsonKeyPresence);
      expect(results[3].field, EvalField.bodyContains);
      expect(results[4].field, EvalField.contentType);
    });
  });
}
