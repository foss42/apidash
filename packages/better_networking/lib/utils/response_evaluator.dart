import 'dart:convert';

import '../models/http_response_model.dart';

/// Identifies which aspect of the response was evaluated.
enum EvalField {
  statusCode,
  latency,
  jsonKeyPresence,
  bodyContains,
  contentType,
}

/// The result of a single evaluation check against an [HttpResponseModel].
class EvalResult {
  const EvalResult({
    required this.field,
    required this.passed,
    this.expected,
    this.actual,
    this.message,
  });

  /// The response field that was evaluated.
  final EvalField field;

  /// Whether the assertion passed.
  final bool passed;

  /// The expected value for this assertion.
  final Object? expected;

  /// The actual value observed in the response.
  final Object? actual;

  /// A human-readable summary of the result.
  final String? message;

  @override
  String toString() =>
      'EvalResult(field: $field, passed: $passed, '
      'expected: $expected, actual: $actual)';
}

/// Defines the set of assertions to run against an [HttpResponseModel].
/// Only fields with non-null values produce an [EvalResult].
class ResponseExpectation {
  const ResponseExpectation({
    this.statusCode,
    this.maxLatency,
    this.requiredJsonKeys,
    this.bodyContains,
    this.contentType,
  });

  /// Expected HTTP status code (exact match).
  final int? statusCode;

  /// Maximum acceptable response time.
  final Duration? maxLatency;

  /// Top-level JSON keys that must be present in the response body.
  final List<String>? requiredJsonKeys;

  /// A string that must appear anywhere in the response body.
  final String? bodyContains;

  /// A substring that must appear in the Content-Type header.
  final String? contentType;
}

/// Evaluates [response] against [expectation] and returns a list of
/// [EvalResult] — one entry per configured assertion.
///
/// Only assertions with non-null values in [expectation] are evaluated.
/// The order of results matches the order of fields in [ResponseExpectation].
List<EvalResult> evaluateResponse(
  HttpResponseModel response,
  ResponseExpectation expectation,
) {
  final results = <EvalResult>[];

  if (expectation.statusCode != null) {
    results.add(_evalStatusCode(response, expectation.statusCode!));
  }

  if (expectation.maxLatency != null) {
    results.add(_evalLatency(response, expectation.maxLatency!));
  }

  if (expectation.requiredJsonKeys != null &&
      expectation.requiredJsonKeys!.isNotEmpty) {
    results.add(_evalJsonKeys(response, expectation.requiredJsonKeys!));
  }

  if (expectation.bodyContains != null) {
    results.add(_evalBodyContains(response, expectation.bodyContains!));
  }

  if (expectation.contentType != null) {
    results.add(_evalContentType(response, expectation.contentType!));
  }

  return results;
}

// ---------------------------------------------------------------------------
// Private helpers
// ---------------------------------------------------------------------------

EvalResult _evalStatusCode(HttpResponseModel response, int expected) {
  final actual = response.statusCode;
  final passed = actual == expected;
  return EvalResult(
    field: EvalField.statusCode,
    passed: passed,
    expected: expected,
    actual: actual,
    message: passed
        ? 'Status code matched: $actual'
        : 'Expected status $expected, got $actual',
  );
}

EvalResult _evalLatency(HttpResponseModel response, Duration max) {
  final actual = response.time;
  if (actual == null) {
    return EvalResult(
      field: EvalField.latency,
      passed: false,
      expected: '≤ ${max.inMilliseconds}ms',
      actual: null,
      message: 'Latency data unavailable',
    );
  }
  final passed = actual <= max;
  return EvalResult(
    field: EvalField.latency,
    passed: passed,
    expected: '≤ ${max.inMilliseconds}ms',
    actual: '${actual.inMilliseconds}ms',
    message: passed
        ? 'Latency ${actual.inMilliseconds}ms within limit'
        : 'Latency ${actual.inMilliseconds}ms exceeded ${max.inMilliseconds}ms',
  );
}

EvalResult _evalJsonKeys(
  HttpResponseModel response,
  List<String> requiredKeys,
) {
  final body = response.body;
  try {
    final decoded = jsonDecode(body ?? '') as Map<String, dynamic>;
    final missing = requiredKeys.where((k) => !decoded.containsKey(k)).toList();
    return EvalResult(
      field: EvalField.jsonKeyPresence,
      passed: missing.isEmpty,
      expected: requiredKeys,
      actual: decoded.keys.toList(),
      message: missing.isEmpty
          ? 'All required keys present'
          : 'Missing keys: $missing',
    );
  } catch (_) {
    return EvalResult(
      field: EvalField.jsonKeyPresence,
      passed: false,
      expected: requiredKeys,
      actual: null,
      message: 'Response body is not valid JSON',
    );
  }
}

EvalResult _evalBodyContains(HttpResponseModel response, String needle) {
  final body = response.body ?? '';
  final passed = body.contains(needle);
  final preview = body.length > 120 ? '${body.substring(0, 120)}…' : body;
  return EvalResult(
    field: EvalField.bodyContains,
    passed: passed,
    expected: needle,
    actual: preview,
    message: passed
        ? 'Body contains "$needle"'
        : 'Body does not contain "$needle"',
  );
}

EvalResult _evalContentType(HttpResponseModel response, String expected) {
  final actual = response.contentType ?? '';
  final passed = actual.contains(expected);
  return EvalResult(
    field: EvalField.contentType,
    passed: passed,
    expected: expected,
    actual: actual.isEmpty ? null : actual,
    message: passed
        ? 'Content-Type contains "$expected"'
        : 'Content-Type "$actual" does not contain "$expected"',
  );
}
