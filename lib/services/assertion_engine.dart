// DashAssert – Assertion Engine
// Part of the AI-Powered Response Assertion Engine for API Dash
// Relates to GSoC 2026 Idea #4: Agentic API Testing

import 'dart:convert';
import 'package:apidash_core/apidash_core.dart';
import '../models/assertion_model.dart';

/// Executes [AssertionSuite] rules against an [HttpResponseModel].
///
/// Supports 8 assertion types including full JSON Schema validation,
/// with dot-notation navigation for nested JSON structures.
class AssertionEngine {
  const AssertionEngine();

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Execute all rules in [suite] against [response].
  ///
  /// Returns a new [AssertionSuite] with updated rule statuses and [lastRunAt].
  AssertionSuite executeAll(
    AssertionSuite suite,
    HttpResponseModel response,
  ) {
    final updatedRules =
        suite.rules.map((rule) => executeRule(rule, response)).toList();
    return suite.copyWith(rules: updatedRules, lastRunAt: DateTime.now());
  }

  /// Execute a single [rule] against [response].
  AssertionRule executeRule(
    AssertionRule rule,
    HttpResponseModel response,
  ) {
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
        case AssertionType.jsonSchemaValid:
          return _checkJsonSchemaValid(rule, response);
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
        '**Run at:** ${suite.lastRunAt?.toLocal().toString() ?? 'Not run yet'}');
    sb.writeln(
        '**Results:** ${suite.passCount} passed · ${suite.failCount} failed · ${suite.errorCount} errors');
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
          .map((r) => {
                'id': r.id,
                'type': r.type.name,
                'description': r.description,
                'status': r.status.name,
                'expected': r.expectedValue?.toString(),
                'actual': r.actualValue,
                'jsonPath': r.jsonPath,
                'errorMessage': r.errorMessage,
              })
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

  /// Validates the entire JSON response body against a JSON Schema definition.
  ///
  /// The schema is stored as a JSON-encoded string in [AssertionRule.expectedValue].
  AssertionRule _checkJsonSchemaValid(
    AssertionRule rule,
    HttpResponseModel response,
  ) {
    try {
      final schemaStr = rule.expectedValue?.toString() ?? '';
      if (schemaStr.isEmpty) {
        return rule.copyWith(
          status: AssertionStatus.error,
          errorMessage: 'Expected value must contain a JSON Schema definition',
        );
      }
      Map<String, dynamic> schema;
      try {
        schema = json.decode(schemaStr) as Map<String, dynamic>;
      } on FormatException {
        return rule.copyWith(
          status: AssertionStatus.error,
          errorMessage: 'The schema definition is not valid JSON',
        );
      }
      final bodyStr = response.body;
      if (bodyStr == null || bodyStr.isEmpty) {
        return rule.copyWith(
          status: AssertionStatus.fail,
          actualValue: 'Response body is empty',
        );
      }
      dynamic body;
      try {
        body = json.decode(bodyStr);
      } on FormatException {
        return rule.copyWith(
          status: AssertionStatus.fail,
          actualValue: 'Response body is not valid JSON',
        );
      }
      final error = _validateSchema(body, schema);
      if (error == null) {
        return rule.copyWith(
          status: AssertionStatus.pass,
          actualValue: 'Schema valid',
        );
      } else {
        return rule.copyWith(status: AssertionStatus.fail, actualValue: error);
      }
    } catch (e) {
      return rule.copyWith(
        status: AssertionStatus.error,
        errorMessage: 'Schema validation error: $e',
      );
    }
  }

  // ---------------------------------------------------------------------------
  // JSON Schema validator (zero external dependencies)
  // ---------------------------------------------------------------------------

  /// Validates [data] against [schema].
  ///
  /// Supported keywords: `type`, `required`, `properties`, `items`,
  /// `minimum`, `maximum`, `minLength`, `maxLength`, `enum`.
  ///
  /// Returns `null` if valid, or a human-readable error string if invalid.
  String? _validateSchema(dynamic data, Map<String, dynamic> schema) {
    // 1. type check
    final type = schema['type'] as String?;
    if (type != null) {
      final valid = switch (type) {
        'string' => data is String,
        'number' => data is num,
        'integer' => data is int,
        'boolean' => data is bool,
        'array' => data is List,
        'object' => data is Map,
        'null' => data == null,
        _ => true,
      };
      if (!valid) {
        return 'Expected type $type but got ${data.runtimeType}';
      }
    }

    // 2. required fields (only for objects)
    if (data is Map && schema.containsKey('required')) {
      final required = (schema['required'] as List).cast<String>();
      for (final key in required) {
        if (!data.containsKey(key)) {
          return 'Required field "$key" is missing';
        }
      }
    }

    // 3. properties (recurse for each declared property)
    if (data is Map && schema.containsKey('properties')) {
      final props = schema['properties'] as Map<String, dynamic>;
      for (final entry in props.entries) {
        if (data.containsKey(entry.key)) {
          final err = _validateSchema(
            data[entry.key],
            entry.value as Map<String, dynamic>,
          );
          if (err != null) return '${entry.key}: $err';
        }
      }
    }

    // 4. items (recurse for each array element)
    if (data is List && schema.containsKey('items')) {
      final itemSchema = schema['items'] as Map<String, dynamic>;
      for (int i = 0; i < data.length; i++) {
        final err = _validateSchema(data[i], itemSchema);
        if (err != null) return 'items[$i]: $err';
      }
    }

    // 5. numeric constraints
    if (data is num) {
      if (schema.containsKey('minimum') &&
          data < (schema['minimum'] as num)) {
        return 'Value $data is less than minimum ${schema['minimum']}';
      }
      if (schema.containsKey('maximum') &&
          data > (schema['maximum'] as num)) {
        return 'Value $data exceeds maximum ${schema['maximum']}';
      }
    }

    // 6. string constraints
    if (data is String) {
      if (schema.containsKey('minLength') &&
          data.length < (schema['minLength'] as int)) {
        return 'String length ${data.length} < minLength ${schema['minLength']}';
      }
      if (schema.containsKey('maxLength') &&
          data.length > (schema['maxLength'] as int)) {
        return 'String length ${data.length} > maxLength ${schema['maxLength']}';
      }
    }

    // 7. enum constraint
    if (schema.containsKey('enum')) {
      final allowed = schema['enum'] as List;
      if (!allowed.contains(data)) {
        return 'Value "$data" not in enum $allowed';
      }
    }

    return null; // valid ✅
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
