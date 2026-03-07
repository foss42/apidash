import 'dart:convert';
import 'package:apidash_core/apidash_core.dart';

/// NOTE: Unsupported cURL flags and rationale for current models
///
/// The `Curl` parser recognizes several flags that are not represented in
/// our `HttpRequestModel` / `RequestModel`. Those models intentionally focus on
/// the request description (method, URL, headers, params, body, form-data),
/// not transport/runtime behavior or output concerns. As a result, these flags
/// are currently ignored by `CurlImportService` and cannot be applied to the
/// request model:
///
/// - `-k`, `--insecure`: TLS validation behavior (transport concern). No field
///   exists to control certificate verification in `HttpRequestModel`.
/// - `-L`, `--location`: redirect-following behavior (transport concern). Not
///   a property of a single request; our model describes one request only.
/// - `--compressed`: response compression negotiation/output. While this often
///   implies adding `Accept-Encoding`, the parser does not expose this flag on
///   `Curl`; and we avoid mutating headers implicitly without a model field.
/// - `-i`, `--include`: include response headers in output (output concern).
/// - `-o`, `--output`: write response body to a file (output concern).
/// - `-s`, `--silent`: suppress CLI progress/errors (CLI UX concern).
/// - `-v`, `--verbose`: verbose logging (CLI UX concern).
/// - `--connect-timeout`: connection timeout (transport concern). No timeout
///   fields exist on `HttpRequestModel`.
/// - `--retry`: retry policy (transport concern). No retry fields exist on
///   `HttpRequestModel`.
/// - `-c`, `--cookie-jar`: persist response cookies to a file (output/state
///   concern). Not part of request description.
/// - `--globoff`: parsing behavior for the curl CLI; irrelevant post-parse.

/// Service to parse cURL commands and produce
/// a standard action message map understood by Dashbot.
class CurlImportService {
  /// Build the message object with two actions: apply to selected or new.
  static Map<String, dynamic> buildActionMessageFromPayload(
    Map<String, dynamic> actionPayload, {
    String? note,
    Map<String, dynamic>? current,
    String? insights,
  }) {
    final buf = StringBuffer();
    if (insights != null && insights.isNotEmpty) {
      buf.writeln(insights.trim());
    }
    buf
      ..writeln()
      ..writeln(
          'Where do you want to apply the changes? Choose one of the options below.');
    final explanation = buf.toString();
    final map = {
      'explanation': explanation,
      'actions': [
        {
          'action': 'apply_curl',
          'target': 'httpRequestModel',
          'field': 'apply_to_new',
          'path': null,
          'value': actionPayload,
        },
        {
          'action': 'apply_curl',
          'target': 'httpRequestModel',
          'field': 'apply_to_selected',
          'path': null,
          'value': actionPayload,
        }
      ]
    };
    if (note != null && note.isNotEmpty) {
      map['note'] = note;
    }
    map['meta'] = {
      'diff': diffWithCurrent(actionPayload, current),
    };
    return map;
  }

  /// Convenience: from parsed [Curl] to (json, actions list).
  static ({String jsonMessage, List<Map<String, dynamic>> actions})
      buildResponseFromParsed(Map<String, dynamic> payload,
          {Map<String, dynamic>? currentJson}) {
    // Build a small note for flags that are not represented in the request model
    final notes = <String>[];
    // if (curl.insecure) notes.add('insecure (-k) is not applied automatically');
    // if (curl.location) {
    //   notes.add('follow redirects (-L) is not applied automatically');
    // }
    final msg = buildActionMessageFromPayload(
      payload,
      note: notes.isEmpty ? null : notes.join('; '),
      current: currentJson,
    );
    final actions =
        (msg['actions'] as List).whereType<Map<String, dynamic>>().toList();
    return (jsonMessage: jsonEncode(msg), actions: actions);
  }

  /// High-level helper to process a pasted cURL string.
  /// Returns either a built (json, actions) tuple or an error message.
  static ({
    String? error,
    String? jsonMessage,
    List<Map<String, dynamic>>? actions
  }) processPastedCurl(String input, {Map<String, dynamic>? current}) {
    try {
      final curl = Curl.tryParse(input);
      if (curl == null) {
        return (
          error:
              'Sorry, I could not parse that cURL. Ensure it starts with `curl ` and is complete.',
          jsonMessage: null,
          actions: null
        );
      }
      final payload = convertCurlToHttpRequestModel(curl).toJson();
      final built = buildResponseFromParsed(payload, currentJson: current);
      return (
        error: null,
        jsonMessage: built.jsonMessage,
        actions: built.actions
      );
    } catch (e) {
      final safe = e.toString().replaceAll('"', "'");
      return (error: 'Parsing failed: $safe', jsonMessage: null, actions: null);
    }
  }

  static String diffWithCurrent(
      Map<String, dynamic> p, Map<String, dynamic>? current) {
    if (current == null) return '';

    final changes = <String>[];
    final allKeys = {...p.keys, ...current.keys};

    for (final key in allKeys) {
      final newVal = p[key];
      final oldVal = current[key];

      if (!current.containsKey(key)) {
        changes.add('+ $key: ${_formatValue(newVal)}');
      } else if (!p.containsKey(key)) {
        changes.add('- $key: ${_formatValue(oldVal)}');
      } else if (jsonEncode(newVal) != jsonEncode(oldVal)) {
        changes
            .add('~ $key: ${_formatValue(oldVal)} → ${_formatValue(newVal)}');
      }
    }

    return changes.isEmpty ? 'No changes' : changes.join('\n');
  }

  static String _formatValue(dynamic value) {
    if (value == null) return 'null';
    if (value is String) return '"$value"';
    if (value is Map || value is List) {
      final encoded = jsonEncode(value);
      return encoded;
    }
    return value.toString();
  }

  static bool _looksLikeJson(String s) {
    final t = s.trim();
    if (t.isEmpty) return false;
    if (!(t.startsWith('{') || t.startsWith('['))) return false;
    try {
      jsonDecode(t);
      return true;
    } catch (_) {
      return false;
    }
  }
}
