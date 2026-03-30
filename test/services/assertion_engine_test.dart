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

  // ── JSON Schema Validation ────────────────────────────────────────────────

  group('JSON Schema Validation', () {
    test('passes when body matches schema with required fields', () {
      final schema = json.encode({
        'type': 'object',
        'required': ['id', 'name'],
        'properties': {
          'id': {'type': 'integer'},
          'name': {'type': 'string'},
        },
      });
      final response = _makeResponse(
        body: json.encode({'id': 1, 'name': 'Alice'}),
      );
      final rule = _rule(
        type: AssertionType.jsonSchemaValid,
        expectedValue: schema,
      );
      final result = engine.executeRule(rule, response);
      expect(result.status, equals(AssertionStatus.pass));
      expect(result.actualValue, equals('Schema valid'));
    });

    test('fails when required field is missing', () {
      final schema = json.encode({
        'type': 'object',
        'required': ['id', 'name'],
      });
      final response = _makeResponse(body: json.encode({'id': 1}));
      final rule = _rule(
        type: AssertionType.jsonSchemaValid,
        expectedValue: schema,
      );
      final result = engine.executeRule(rule, response);
      expect(result.status, equals(AssertionStatus.fail));
      expect(result.actualValue, contains('Required field "name" is missing'));
    });

    test('fails when field type is wrong', () {
      final schema = json.encode({
        'properties': {
          'id': {'type': 'integer'},
        },
      });
      final response =
          _makeResponse(body: json.encode({'id': 'not-a-number'}));
      final rule = _rule(
        type: AssertionType.jsonSchemaValid,
        expectedValue: schema,
      );
      final result = engine.executeRule(rule, response);
      expect(result.status, equals(AssertionStatus.fail));
      expect(result.actualValue, contains('Expected type integer'));
    });

    test('handles non-JSON body gracefully without crashing', () {
      final schema = json.encode({'type': 'object'});
      final response = _makeResponse(body: 'plain text response');
      final rule = _rule(
        type: AssertionType.jsonSchemaValid,
        expectedValue: schema,
      );
      final result = engine.executeRule(rule, response);
      // Should fail gracefully, not throw/crash
      expect(result.status, equals(AssertionStatus.fail));
    });

    test('validates enum constraint', () {
      final schema = json.encode({
        'properties': {
          'status': {
            'enum': ['active', 'inactive'],
          },
        },
      });
      final response = _makeResponse(body: json.encode({'status': 'invalid'}));
      final rule = _rule(
        type: AssertionType.jsonSchemaValid,
        expectedValue: schema,
      );
      final result = engine.executeRule(rule, response);
      expect(result.status, equals(AssertionStatus.fail));
      expect(result.actualValue, contains('not in enum'));
    });

    test('validates minimum/maximum on numbers', () {
      final schema = json.encode({
        'properties': {
          'age': {'type': 'integer', 'minimum': 0, 'maximum': 150},
        },
      });
      final response = _makeResponse(body: json.encode({'age': 200}));
      final rule = _rule(
        type: AssertionType.jsonSchemaValid,
        expectedValue: schema,
      );
      final result = engine.executeRule(rule, response);
      expect(result.status, equals(AssertionStatus.fail));
      expect(result.actualValue, contains('exceeds maximum'));
    });
  });

  // ── AssertionRun & Run History ────────────────────────────────────────────

  group('AssertionRun model', () {
    test('passRate calculates correctly', () {
      final run = AssertionRun(
        id: 'run_1',
        runAt: DateTime.utc(2025),
        passCount: 3,
        failCount: 1,
        totalCount: 4,
      );
      expect(run.passRate, equals(0.75));
    });

    test('passRate is 0 for an empty run', () {
      final run = AssertionRun(
        id: 'run_empty',
        runAt: DateTime.utc(2025),
        passCount: 0,
        failCount: 0,
        totalCount: 0,
      );
      expect(run.passRate, equals(0.0));
    });

    test('AssertionSuite runHistory serialises and deserialises correctly', () {
      final run = AssertionRun(
        id: 'run_ser',
        runAt: DateTime(2025, 1, 1),
        passCount: 2,
        failCount: 0,
        totalCount: 2,
        statusCode: 200,
        responseTime: const Duration(milliseconds: 300),
      );
      final suite = AssertionSuite(
        id: 'suite_hist',
        requestId: 'req_hist',
        runHistory: [run],
      );
      final json2 = suite.toJson();
      final restored = AssertionSuite.fromJson(json2);
      expect(restored.runHistory.length, equals(1));
      expect(restored.runHistory.first.passCount, equals(2));
      expect(restored.runHistory.first.statusCode, equals(200));
    });
  });

  // ── AssertionSuite serialisation ─────────────────────────────────────────

  group('AssertionSuite & AssertionRule serialisation', () {
    test('round-trips through toJson / fromJson', () {
      final rule = AssertionRule(
        id: 'r1',
        type: AssertionType.jsonSchemaValid,
        description: 'schema check',
        expectedValue: '{"type":"object"}',
      );
      final suite = AssertionSuite(
        id: 's1',
        requestId: 'req1',
        rules: [rule],
      );
      final json2 = suite.toJson();
      final restored = AssertionSuite.fromJson(json2);
      expect(restored.rules.first.type, equals(AssertionType.jsonSchemaValid));
      expect(restored.rules.first.id, equals('r1'));
    });
  });
}

