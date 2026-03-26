// DashAssert – Assertion Engine
// Part of the AI-Powered Response Assertion Engine for API Dash
// Relates to GSoC 2026 Idea #4: Agentic API Testing

import 'dart:convert';
import 'package:apidash_core/apidash_core.dart';
import '../models/assertion_model.dart';

/// Executes [AssertionSuite] rules against an [HttpResponseModel].
///
/// Supports 7 assertion types with dot-notation JSON path navigation.
class AssertionEngine {
  const AssertionEngine();

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Execute all rules in [suite] against [response].
  ///
  /// Returns a new [AssertionSuite] with updated rule statuses and [lastRunAt].
  AssertionSuite executeAll(AssertionSuite suite, HttpResponseModel response) {
    final updatedRules = suite.rules
        .map((rule) => executeRule(rule, response))
        .toList();
    return suite.copyWith(rules: updatedRules, lastRunAt: DateTime.now());
  }

  /// Execute a single [rule] against [response].
  AssertionRule executeRule(AssertionRule rule, HttpResponseModel response) {
    try {
      switch (rule.type) {
        case AssertionType.statusCode:
          return _checkStatusCode(rule, response);
        case AssertionType.jsonFieldExists:
          return _checkJsonFieldExists(rule, response);
        case AssertionType.jsonFieldValue:
          return _checkJsonFieldValue(rule, response);
        case AssertionType.responseTimeUnder:
          return _checkResponseTimeUnder(rule, response);
        case AssertionType.headerExists:
          return _checkHeaderExists(rule, response);
        case AssertionType.headerValue:
          return _checkHeaderValue(rule, response);
        case AssertionType.bodyContains:
          return _checkBodyContains(rule, response);
      }
    } catch (e) {
      return rule.copyWith(
        status: AssertionStatus.error,
        errorMessage: 'Unexpected error: $e',
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Exporters
  // ---------------------------------------------------------------------------

  /// Export assertion results as a Markdown report.
  String exportMarkdownReport(AssertionSuite suite, {String requestUrl = ''}) {
    final sb = StringBuffer();
    sb.writeln('# DashAssert Report — ${suite.name}');
    if (requestUrl.isNotEmpty) {
      sb.writeln('**Request:** `$requestUrl`');
    }
    sb.writeln(
      '**Run at:** ${suite.lastRunAt?.toLocal().toString() ?? 'Not run yet'}',
    );
    sb.writeln(
      '**Results:** ${suite.passCount} passed · ${suite.failCount} failed · ${suite.errorCount} errors',
    );
    sb.writeln();
    sb.writeln('| Status | Assertion | Expected | Actual |');
    sb.writeln('|--------|-----------|----------|--------|');
    for (final rule in suite.rules) {
      final icon = _statusIcon(rule.status);
      final expected = rule.expectedValue?.toString() ?? '—';
      final actual = rule.actualValue ?? '—';
      final desc = rule.description;
      sb.writeln('| $icon | $desc | `$expected` | `$actual` |');
    }
    if (suite.rules.isNotEmpty && suite.errorCount > 0) {
      sb.writeln();
      sb.writeln('## Errors');
      for (final rule in suite.rules.where(
        (r) => r.status == AssertionStatus.error && r.errorMessage != null,
      )) {
        sb.writeln('- **${rule.description}**: ${rule.errorMessage}');
      }
    }
    return sb.toString();
  }

  /// Export assertion results as a JSON map suitable for CI/CD integration.
  Map<String, dynamic> exportJsonReport(AssertionSuite suite) {
    return {
      'suite': suite.name,
      'requestId': suite.requestId,
      'runAt': suite.lastRunAt?.toIso8601String(),
      'summary': {
        'total': suite.rules.length,
        'passed': suite.passCount,
        'failed': suite.failCount,
        'errors': suite.errorCount,
        'pending': suite.pendingCount,
      },
      'results': suite.rules
          .map(
            (r) => {
              'id': r.id,
              'type': r.type.name,
              'description': r.description,
              'status': r.status.name,
              'expected': r.expectedValue?.toString(),
              'actual': r.actualValue,
              'jsonPath': r.jsonPath,
              'errorMessage': r.errorMessage,
            },
          )
          .toList(),
    };
  }

  // ---------------------------------------------------------------------------
  // Private checkers
  // ---------------------------------------------------------------------------

  AssertionRule _checkStatusCode(
    AssertionRule rule,
    HttpResponseModel response,
  ) {
    final statusCode = response.statusCode;
    if (statusCode == null) {
      return rule.copyWith(
        status: AssertionStatus.error,
        errorMessage: 'Response status code is null',
        actualValue: 'null',
      );
    }
    final expected = _toInt(rule.expectedValue);
    final passed = expected != null && statusCode == expected;
    return rule.copyWith(
      status: passed ? AssertionStatus.pass : AssertionStatus.fail,
      actualValue: statusCode.toString(),
    );
  }

  AssertionRule _checkJsonFieldExists(
    AssertionRule rule,
    HttpResponseModel response,
  ) {
    final body = response.body;
    if (body == null || body.isEmpty) {
      return rule.copyWith(
        status: AssertionStatus.error,
        errorMessage: 'Response body is empty',
        actualValue: 'null',
      );
    }
    final jsonPath = rule.jsonPath;
    if (jsonPath == null || jsonPath.isEmpty) {
      return rule.copyWith(
        status: AssertionStatus.error,
        errorMessage: 'jsonPath is required for JSON field assertions',
      );
    }
    try {
      final decoded = json.decode(body);
      final value = _getJsonValue(decoded, jsonPath);
      final exists = value != null;
      return rule.copyWith(
        status: exists ? AssertionStatus.pass : AssertionStatus.fail,
        actualValue: exists ? value.toString() : 'undefined',
      );
    } on FormatException {
      return rule.copyWith(
        status: AssertionStatus.error,
        errorMessage: 'Response body is not valid JSON',
        actualValue: 'invalid JSON',
      );
    }
  }

  AssertionRule _checkJsonFieldValue(
    AssertionRule rule,
    HttpResponseModel response,
  ) {
    final body = response.body;
    if (body == null || body.isEmpty) {
      return rule.copyWith(
        status: AssertionStatus.error,
        errorMessage: 'Response body is empty',
        actualValue: 'null',
      );
    }
    final jsonPath = rule.jsonPath;
    if (jsonPath == null || jsonPath.isEmpty) {
      return rule.copyWith(
        status: AssertionStatus.error,
        errorMessage: 'jsonPath is required for JSON field value assertions',
      );
    }
    try {
      final decoded = json.decode(body);
      final actual = _getJsonValue(decoded, jsonPath);
      if (actual == null) {
        return rule.copyWith(
          status: AssertionStatus.fail,
          actualValue: 'undefined',
        );
      }
      // Compare as strings for flexibility
      final passed = actual.toString() == rule.expectedValue?.toString();
      return rule.copyWith(
        status: passed ? AssertionStatus.pass : AssertionStatus.fail,
        actualValue: actual.toString(),
      );
    } on FormatException {
      return rule.copyWith(
        status: AssertionStatus.error,
        errorMessage: 'Response body is not valid JSON',
        actualValue: 'invalid JSON',
      );
    }
  }

  AssertionRule _checkResponseTimeUnder(
    AssertionRule rule,
    HttpResponseModel response,
  ) {
    final time = response.time;
    if (time == null) {
      return rule.copyWith(
        status: AssertionStatus.error,
        errorMessage: 'Response time is unavailable',
        actualValue: 'null',
      );
    }
    final thresholdMs = _toInt(rule.expectedValue);
    if (thresholdMs == null) {
      return rule.copyWith(
        status: AssertionStatus.error,
        errorMessage: 'Expected value must be a number (milliseconds)',
      );
    }
    final actualMs = time.inMilliseconds;
    final passed = actualMs < thresholdMs;
    return rule.copyWith(
      status: passed ? AssertionStatus.pass : AssertionStatus.fail,
      actualValue: '${actualMs}ms',
    );
  }

  AssertionRule _checkHeaderExists(
    AssertionRule rule,
    HttpResponseModel response,
  ) {
    final headers = response.headers;
    if (headers == null) {
      return rule.copyWith(
        status: AssertionStatus.error,
        errorMessage: 'Response headers are null',
        actualValue: 'null',
      );
    }
    final headerName = rule.expectedValue?.toString().toLowerCase() ?? '';
    final exists = headers.keys.any((k) => k.toLowerCase() == headerName);
    return rule.copyWith(
      status: exists ? AssertionStatus.pass : AssertionStatus.fail,
      actualValue: exists ? 'present' : 'absent',
    );
  }

  AssertionRule _checkHeaderValue(
    AssertionRule rule,
    HttpResponseModel response,
  ) {
    final headers = response.headers;
    if (headers == null) {
      return rule.copyWith(
        status: AssertionStatus.error,
        errorMessage: 'Response headers are null',
        actualValue: 'null',
      );
    }
    final headerName = rule.jsonPath?.toLowerCase() ?? '';
    if (headerName.isEmpty) {
      return rule.copyWith(
        status: AssertionStatus.error,
        errorMessage:
            'Use the jsonPath field to specify the header name for headerValue assertions',
      );
    }
    final actualEntry = headers.entries.firstWhere(
      (e) => e.key.toLowerCase() == headerName,
      orElse: () => const MapEntry('', ''),
    );
    if (actualEntry.key.isEmpty) {
      return rule.copyWith(
        status: AssertionStatus.fail,
        actualValue: 'header absent',
      );
    }
    final passed =
        actualEntry.value.toString() == rule.expectedValue?.toString();
    return rule.copyWith(
      status: passed ? AssertionStatus.pass : AssertionStatus.fail,
      actualValue: actualEntry.value.toString(),
    );
  }

  AssertionRule _checkBodyContains(
    AssertionRule rule,
    HttpResponseModel response,
  ) {
    final body = response.body ?? '';
    final needle = rule.expectedValue?.toString() ?? '';
    if (needle.isEmpty) {
      return rule.copyWith(
        status: AssertionStatus.error,
        errorMessage: 'Expected value (search string) cannot be empty',
      );
    }
    final passed = body.contains(needle);
    return rule.copyWith(
      status: passed ? AssertionStatus.pass : AssertionStatus.fail,
      actualValue: passed ? 'found' : 'not found',
    );
  }

  // ---------------------------------------------------------------------------
  // JSON path navigator
  // ---------------------------------------------------------------------------

  /// Navigate a nested JSON structure via dot-notation path.
  ///
  /// Supports:
  /// - Object keys: `user.name`
  /// - Array indices: `items.0.title`
  /// - Mixed: `results.0.address.city`
  dynamic _getJsonValue(dynamic json, String path) {
    final parts = path.split('.');
    dynamic current = json;
    for (final part in parts) {
      if (current is Map) {
        if (!current.containsKey(part)) return null;
        current = current[part];
      } else if (current is List) {
        final index = int.tryParse(part);
        if (index == null || index >= current.length || index < 0) return null;
        current = current[index];
      } else {
        return null;
      }
    }
    return current;
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString());
  }

  String _statusIcon(AssertionStatus status) {
    switch (status) {
      case AssertionStatus.pass:
        return '✅';
      case AssertionStatus.fail:
        return '❌';
      case AssertionStatus.error:
        return '⚠️';
      case AssertionStatus.pending:
        return '⏳';
    }
  }
}
