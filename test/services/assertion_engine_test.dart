// DashAssert – Unit Tests for AssertionEngine
// Tests all 7 assertion types, JSON path navigation, and report exporters.

import 'dart:convert';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/models/assertion_model.dart';
import 'package:apidash/services/assertion_engine.dart';
import 'package:test/test.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Build a minimal [HttpResponseModel] for testing.
HttpResponseModel _makeResponse({
  int? statusCode,
  String? body,
  Duration? time,
  Map<String, String>? headers,
}) {
  return const HttpResponseModel().copyWith(
    statusCode: statusCode,
    body: body ?? '',
    time: time,
    headers: headers ?? {},
    requestHeaders: {},
  );
}

AssertionRule _rule({
  required AssertionType type,
  dynamic expectedValue,
  String? jsonPath,
  String description = 'Test assertion',
}) {
  return AssertionRule(
    id: 'test_${type.name}',
    type: type,
    description: description,
    expectedValue: expectedValue,
    jsonPath: jsonPath,
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  const engine = AssertionEngine();

  // ── Status Code ──────────────────────────────────────────────────────────

  group('StatusCode assertion', () {
    test('passes when status codes match', () {
      final response = _makeResponse(statusCode: 200);
      final rule = _rule(type: AssertionType.statusCode, expectedValue: 200);
      final result = engine.executeRule(rule, response);
      expect(result.status, equals(AssertionStatus.pass));
      expect(result.actualValue, equals('200'));
    });

    test('fails when status codes differ', () {
      final response = _makeResponse(statusCode: 404);
      final rule = _rule(type: AssertionType.statusCode, expectedValue: 200);
      final result = engine.executeRule(rule, response);
      expect(result.status, equals(AssertionStatus.fail));
      expect(result.actualValue, equals('404'));
    });

    test('returns error when response has no status code', () {
      final response = _makeResponse(statusCode: null);
      final rule = _rule(type: AssertionType.statusCode, expectedValue: 200);
      final result = engine.executeRule(rule, response);
      expect(result.status, equals(AssertionStatus.error));
    });

    test('accepts status code as string expected value', () {
      final response = _makeResponse(statusCode: 201);
      final rule = _rule(type: AssertionType.statusCode, expectedValue: '201');
      final result = engine.executeRule(rule, response);
      expect(result.status, equals(AssertionStatus.pass));
    });
  });

  // ── JSON Field Exists ────────────────────────────────────────────────────

  group('JsonFieldExists assertion', () {
    test('passes when top-level field exists', () {
      final response = _makeResponse(
        statusCode: 200,
        body: json.encode({'id': 1, 'name': 'Alice'}),
      );
      final rule = _rule(type: AssertionType.jsonFieldExists, jsonPath: 'id');
      final result = engine.executeRule(rule, response);
      expect(result.status, equals(AssertionStatus.pass));
    });

    test('fails when top-level field is missing', () {
      final response = _makeResponse(
        statusCode: 200,
        body: json.encode({'id': 1}),
      );
      final rule = _rule(
        type: AssertionType.jsonFieldExists,
        jsonPath: 'email',
      );
      final result = engine.executeRule(rule, response);
      expect(result.status, equals(AssertionStatus.fail));
      expect(result.actualValue, equals('undefined'));
    });

    test('passes for nested field via dot notation', () {
      final response = _makeResponse(
        statusCode: 200,
        body: json.encode({
          'user': {
            'address': {'city': 'Hyderabad'},
          },
        }),
      );
      final rule = _rule(
        type: AssertionType.jsonFieldExists,
        jsonPath: 'user.address.city',
      );
      final result = engine.executeRule(rule, response);
      expect(result.status, equals(AssertionStatus.pass));
    });

    test('returns error for invalid JSON body', () {
      final response = _makeResponse(body: 'not json!');
      final rule = _rule(type: AssertionType.jsonFieldExists, jsonPath: 'id');
      final result = engine.executeRule(rule, response);
      expect(result.status, equals(AssertionStatus.error));
    });

    test('handles array index in dot notation path', () {
      final response = _makeResponse(
        statusCode: 200,
        body: json.encode({
          'items': [
            {'name': 'Widget'},
            {'name': 'Gadget'},
          ],
        }),
      );
      final rule = _rule(
        type: AssertionType.jsonFieldExists,
        jsonPath: 'items.0.name',
      );
      final result = engine.executeRule(rule, response);
      expect(result.status, equals(AssertionStatus.pass));
      expect(result.actualValue, equals('Widget'));
    });
  });

  // ── JSON Field Value ─────────────────────────────────────────────────────

  group('JsonFieldValue assertion', () {
    test('passes when value matches expected', () {
      final response = _makeResponse(
        statusCode: 200,
        body: json.encode({'status': 'success'}),
      );
      final rule = _rule(
        type: AssertionType.jsonFieldValue,
        expectedValue: 'success',
        jsonPath: 'status',
      );
      final result = engine.executeRule(rule, response);
      expect(result.status, equals(AssertionStatus.pass));
    });

    test('fails when value does not match expected', () {
      final response = _makeResponse(
        statusCode: 200,
        body: json.encode({'status': 'error'}),
      );
      final rule = _rule(
        type: AssertionType.jsonFieldValue,
        expectedValue: 'success',
        jsonPath: 'status',
      );
      final result = engine.executeRule(rule, response);
      expect(result.status, equals(AssertionStatus.fail));
      expect(result.actualValue, equals('error'));
    });

    test('fails when field is absent', () {
      final response = _makeResponse(body: json.encode({'other': 'value'}));
      final rule = _rule(
        type: AssertionType.jsonFieldValue,
        expectedValue: 'success',
        jsonPath: 'status',
      );
      final result = engine.executeRule(rule, response);
      expect(result.status, equals(AssertionStatus.fail));
      expect(result.actualValue, equals('undefined'));
    });
  });

  // ── Response Time Under ──────────────────────────────────────────────────

  group('ResponseTimeUnder assertion', () {
    test('passes when actual time is under threshold', () {
      final response = _makeResponse(time: const Duration(milliseconds: 120));
      final rule = _rule(
        type: AssertionType.responseTimeUnder,
        expectedValue: 500,
      );
      final result = engine.executeRule(rule, response);
      expect(result.status, equals(AssertionStatus.pass));
      expect(result.actualValue, equals('120ms'));
    });

    test('fails when actual time exceeds threshold', () {
      final response = _makeResponse(time: const Duration(milliseconds: 1500));
      final rule = _rule(
        type: AssertionType.responseTimeUnder,
        expectedValue: 500,
      );
      final result = engine.executeRule(rule, response);
      expect(result.status, equals(AssertionStatus.fail));
      expect(result.actualValue, equals('1500ms'));
    });

    test('returns error when time is null', () {
      final response = _makeResponse(time: null);
      final rule = _rule(
        type: AssertionType.responseTimeUnder,
        expectedValue: 500,
      );
      final result = engine.executeRule(rule, response);
      expect(result.status, equals(AssertionStatus.error));
    });
  });

  // ── Header Exists ────────────────────────────────────────────────────────

  group('HeaderExists assertion', () {
    test('passes when header is present', () {
      final response = _makeResponse(
        headers: {'content-type': 'application/json'},
      );
      final rule = _rule(
        type: AssertionType.headerExists,
        expectedValue: 'content-type',
      );
      final result = engine.executeRule(rule, response);
      expect(result.status, equals(AssertionStatus.pass));
    });

    test('passes with case-insensitive match', () {
      final response = _makeResponse(
        headers: {'Content-Type': 'application/json'},
      );
      final rule = _rule(
        type: AssertionType.headerExists,
        expectedValue: 'content-type',
      );
      final result = engine.executeRule(rule, response);
      expect(result.status, equals(AssertionStatus.pass));
    });

    test('fails when header is absent', () {
      final response = _makeResponse(headers: {'x-request-id': 'abc'});
      final rule = _rule(
        type: AssertionType.headerExists,
        expectedValue: 'content-type',
      );
      final result = engine.executeRule(rule, response);
      expect(result.status, equals(AssertionStatus.fail));
      expect(result.actualValue, equals('absent'));
    });
  });

  // ── Body Contains ────────────────────────────────────────────────────────

  group('BodyContains assertion', () {
    test('passes when body contains the substring', () {
      final response = _makeResponse(body: '{"message": "Hello, world!"}');
      final rule = _rule(
        type: AssertionType.bodyContains,
        expectedValue: 'Hello',
      );
      final result = engine.executeRule(rule, response);
      expect(result.status, equals(AssertionStatus.pass));
    });

    test('fails when body does not contain the substring', () {
      final response = _makeResponse(body: '{"message": "Goodbye"}');
      final rule = _rule(
        type: AssertionType.bodyContains,
        expectedValue: 'Hello',
      );
      final result = engine.executeRule(rule, response);
      expect(result.status, equals(AssertionStatus.fail));
      expect(result.actualValue, equals('not found'));
    });

    test('returns error when expected value is empty', () {
      final response = _makeResponse(body: 'anything');
      final rule = _rule(type: AssertionType.bodyContains, expectedValue: '');
      final result = engine.executeRule(rule, response);
      expect(result.status, equals(AssertionStatus.error));
    });
  });

  // ── executeAll ───────────────────────────────────────────────────────────

  group('executeAll', () {
    test('runs all rules and sets lastRunAt', () {
      final response = _makeResponse(
        statusCode: 200,
        body: '{"id": 1}',
        time: const Duration(milliseconds: 300),
        headers: {'content-type': 'application/json'},
      );
      final suite = AssertionSuite(
        id: 'suite_1',
        requestId: 'req_1',
        rules: [
          _rule(type: AssertionType.statusCode, expectedValue: 200),
          _rule(type: AssertionType.jsonFieldExists, jsonPath: 'id'),
          _rule(type: AssertionType.responseTimeUnder, expectedValue: 1000),
        ],
      );
      final result = engine.executeAll(suite, response);
      expect(result.lastRunAt, isNotNull);
      expect(result.passCount, equals(3));
      expect(result.failCount, equals(0));
    });

    test('correctly counts pass and fail results', () {
      final response = _makeResponse(statusCode: 404, body: '{}');
      final suite = AssertionSuite(
        id: 'suite_2',
        requestId: 'req_2',
        rules: [
          _rule(type: AssertionType.statusCode, expectedValue: 200),
          _rule(type: AssertionType.bodyContains, expectedValue: 'success'),
        ],
      );
      final result = engine.executeAll(suite, response);
      expect(result.passCount, equals(0));
      expect(result.failCount, equals(2));
    });
  });

  // ── Exporters ────────────────────────────────────────────────────────────

  group('exportMarkdownReport', () {
    test('returns valid Markdown with a results table', () {
      final response = _makeResponse(statusCode: 200);
      final suite = AssertionSuite(
        id: 'suite_md',
        requestId: 'req_md',
        rules: [_rule(type: AssertionType.statusCode, expectedValue: 200)],
      );
      final result = engine.executeAll(suite, response);
      final md = engine.exportMarkdownReport(
        result,
        requestUrl: 'https://api.example.com',
      );
      expect(md, contains('# DashAssert Report'));
      expect(md, contains('| Status |'));
      expect(md, contains('passed'));
    });

    test('exportJsonReport returns correct structure', () {
      final response = _makeResponse(statusCode: 200);
      final suite = AssertionSuite(
        id: 'suite_json',
        requestId: 'req_json',
        rules: [_rule(type: AssertionType.statusCode, expectedValue: 200)],
      );
      final result = engine.executeAll(suite, response);
      final report = engine.exportJsonReport(result);
      expect(report, containsKey('summary'));
      expect(report, containsKey('results'));
      expect(report['summary']['total'], equals(1));
      expect(report['results'], isList);
    });
  });
}
