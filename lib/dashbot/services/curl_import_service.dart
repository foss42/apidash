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
  /// Attempts to parse a cURL string.
  /// Returns null if parsing fails.
  static Curl? tryParseCurl(String input) {
    return Curl.tryParse(input);
  }

  /// Convert a parsed Curl into a payload used by Dashbot auto-fix action.
  static Map<String, dynamic> buildActionPayloadFromCurl(Curl curl) {
    final headers =
        Map<String, String>.from(curl.headers ?? <String, String>{});
    bool hasHeader(String key) =>
        headers.keys.any((k) => k.toLowerCase() == key.toLowerCase());
    void setIfMissing(String key, String? value) {
      if (value == null || value.isEmpty) return;
      if (!hasHeader(key)) headers[key] = value;
    }

    // Map cookie to Cookie header if not present
    setIfMissing('Cookie', curl.cookie);
    // Map user agent and referer to headers if not present
    setIfMissing('User-Agent', curl.userAgent);
    setIfMissing('Referer', curl.referer);
    // Map -u user:password to Authorization: Basic ... if not already present
    if (!hasHeader('Authorization') && (curl.user?.isNotEmpty ?? false)) {
      final basic = base64.encode(utf8.encode(curl.user!));
      headers['Authorization'] = 'Basic $basic';
    }

    final payload = <String, dynamic>{
      'method': curl.method,
      'url': curl.uri.toString(),
      'headers': headers,
      'body': curl.data,
      'form': curl.form,
      'formData': curl.formData
          ?.map((f) => {
                'name': f.name,
                'value': f.value,
                'type': f.type.name,
              })
          .toList(),
    };

    // Include query params for insights only
    try {
      final qp = curl.uri.queryParameters;
      if (qp.isNotEmpty) {
        payload['params'] = qp;
      }
    } catch (_) {}

    return payload;
  }

  /// Build the message object with two actions: apply to selected or new.
  static Map<String, dynamic> buildActionMessageFromPayload(
    Map<String, dynamic> actionPayload, {
    String? note,
    Map<String, dynamic>? current,
    String? insights,
  }) {
    final base = _insightsExplanation(
      actionPayload,
      current: current,
      header: 'cURL parsed. Here is a quick summary and diff:',
    );
    final buf = StringBuffer()..writeln(base);
    if (insights != null && insights.isNotEmpty) {
      buf
        ..writeln()
        ..writeln(insights.trim());
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
      'curl_summary': _summaryForCurlPayload(actionPayload),
      'diff': _diffWithCurrent(actionPayload, current),
    };
    return map;
  }

  /// Convenience: from parsed [Curl] to (json, actions list).
  static ({String jsonMessage, List<Map<String, dynamic>> actions})
      buildResponseFromParsed(Curl curl, {Map<String, dynamic>? current}) {
    final payload = buildActionPayloadFromCurl(curl);
    // Build a small note for flags that are not represented in the request model
    final notes = <String>[];
    // if (curl.insecure) notes.add('insecure (-k) is not applied automatically');
    // if (curl.location) {
    //   notes.add('follow redirects (-L) is not applied automatically');
    // }
    final msg = buildActionMessageFromPayload(
      payload,
      note: notes.isEmpty ? null : notes.join('; '),
      current: current,
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
      final curl = tryParseCurl(input);
      if (curl == null) {
        return (
          error:
              'Sorry, I could not parse that cURL. Ensure it starts with `curl ` and is complete.',
          jsonMessage: null,
          actions: null
        );
      }
      final built = buildResponseFromParsed(curl, current: current);
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

  // ----- Insights helpers -----

  static String _summaryForCurlPayload(Map<String, dynamic> p) {
    final method = (p['method'] as String? ?? 'GET').toUpperCase();
    final url = p['url'] as String? ?? '';
    final headers = (p['headers'] as Map?)?.cast<String, dynamic>() ?? {};
    final params = (p['params'] as Map?)?.cast<String, dynamic>() ?? {};
    final body = p['body'] as String?;
    final form = p['form'] == true;
    final formData =
        ((p['formData'] as List?) ?? const []).whereType<Map>().toList();
    final bodyType = form || formData.isNotEmpty
        ? 'form-data'
        : (body != null && body.trim().isNotEmpty
            ? (_looksLikeJson(body) ? 'json' : 'text')
            : 'none');
    final size = body?.length ?? 0;
    return [
      'Request Summary:',
      '- Method: $method',
      '- URL: $url',
      if (params.isNotEmpty) '- Query Params: ${params.length}',
      '- Headers: ${headers.length}',
      '- Body: $bodyType${size > 0 ? ' ($size chars)' : ''}',
    ].join('\n');
  }

  static Map<String, dynamic> _diffWithCurrent(
      Map<String, dynamic> p, Map<String, dynamic>? current) {
    if (current == null || current.isEmpty) return {};
    final diff = <String, dynamic>{};

    String up(String? s) => (s ?? '').toUpperCase();
    String curMethod = up(current['method'] as String?);
    String newMethod = up(p['method'] as String?);
    if (curMethod != newMethod) {
      diff['method'] = {'from': curMethod, 'to': newMethod};
    }

    final curUrl = (current['url'] as String?) ?? '';
    final newUrl = (p['url'] as String?) ?? '';
    if (curUrl != newUrl) {
      diff['url'] = {'from': curUrl, 'to': newUrl};
    }

    Map<String, String> normMap(dynamic m) {
      final map = (m as Map?)?.cast<String, dynamic>() ?? {};
      return Map.fromEntries(map.entries.map(
          (e) => MapEntry(e.key.toLowerCase(), (e.value ?? '').toString())));
    }

    final curHeaders = normMap(current['headers']);
    final newHeaders = normMap(p['headers']);
    final headerAdds = <String>[];
    final headerUpdates = <String>[];
    final headerRemoves = <String>[];
    for (final k in newHeaders.keys) {
      if (!curHeaders.containsKey(k)) {
        headerAdds.add(k);
      } else if (curHeaders[k] != newHeaders[k]) {
        headerUpdates.add(k);
      }
    }
    for (final k in curHeaders.keys) {
      if (!newHeaders.containsKey(k)) headerRemoves.add(k);
    }
    if (headerAdds.isNotEmpty ||
        headerUpdates.isNotEmpty ||
        headerRemoves.isNotEmpty) {
      diff['headers'] = {
        'add': headerAdds,
        'update': headerUpdates,
        'remove': headerRemoves,
      };
    }

    final curParams = normMap(current['params']);
    final newParams = normMap(p['params']);
    final paramAdds = <String>[];
    final paramUpdates = <String>[];
    final paramRemoves = <String>[];
    if (newParams.isNotEmpty || curParams.isNotEmpty) {
      for (final k in newParams.keys) {
        if (!curParams.containsKey(k)) {
          paramAdds.add(k);
        } else if (curParams[k] != newParams[k]) {
          paramUpdates.add(k);
        }
      }
      for (final k in curParams.keys) {
        if (!newParams.containsKey(k)) paramRemoves.add(k);
      }
      if (paramAdds.isNotEmpty ||
          paramUpdates.isNotEmpty ||
          paramRemoves.isNotEmpty) {
        diff['params'] = {
          'add': paramAdds,
          'update': paramUpdates,
          'remove': paramRemoves,
        };
      }
    }

    final curBody = (current['body'] as String?) ?? '';
    final newBody = (p['body'] as String?) ?? '';
    final curForm = current['form'] == true ||
        ((current['formData'] as List?)?.isNotEmpty ?? false);
    final newForm =
        p['form'] == true || ((p['formData'] as List?)?.isNotEmpty ?? false);
    final curType = curForm
        ? 'form-data'
        : (curBody.trim().isEmpty
            ? 'none'
            : (_looksLikeJson(curBody) ? 'json' : 'text'));
    final newType = newForm
        ? 'form-data'
        : (newBody.trim().isEmpty
            ? 'none'
            : (_looksLikeJson(newBody) ? 'json' : 'text'));
    if (curType != newType || curBody != newBody) {
      diff['body'] = {
        'type': {'from': curType, 'to': newType},
        'size': {'from': curBody.length, 'to': newBody.length},
      };
    }
    return diff;
  }

  static String _insightsExplanation(Map<String, dynamic> payload,
      {Map<String, dynamic>? current, String? header}) {
    final buf = StringBuffer();
    if (header != null && header.isNotEmpty) {
      buf.writeln(header);
    }
    buf.writeln();
    // High-level summary
    buf.writeln(_summaryForCurlPayload(payload));

    // Diff section
    final diff = _diffWithCurrent(payload, current);
    if (diff.isNotEmpty) {
      buf.writeln();
      buf.writeln('If applied to the selected request, changes:');
      if (diff.containsKey('method')) {
        final d = diff['method'] as Map<String, dynamic>;
        buf.writeln('- Method: ${d['from']} → ${d['to']}');
      }
      if (diff.containsKey('url')) {
        final d = diff['url'] as Map<String, dynamic>;
        buf.writeln('- URL: ${d['from']} → ${d['to']}');
      }
      if (diff.containsKey('headers')) {
        final d = (diff['headers'] as Map).cast<String, dynamic>();
        List<String> parts = [];
        if ((d['add'] as List).isNotEmpty) {
          parts.add('add ${(d['add'] as List).length}');
        }
        if ((d['update'] as List).isNotEmpty) {
          parts.add('update ${(d['update'] as List).length}');
        }
        if ((d['remove'] as List).isNotEmpty) {
          parts.add('remove ${(d['remove'] as List).length}');
        }
        if (parts.isNotEmpty) {
          buf.writeln('- Headers: ${parts.join(', ')}');
        }
      }
      if (diff.containsKey('params')) {
        final d = (diff['params'] as Map).cast<String, dynamic>();
        List<String> parts = [];
        if ((d['add'] as List).isNotEmpty) {
          parts.add('add ${(d['add'] as List).length}');
        }
        if ((d['update'] as List).isNotEmpty) {
          parts.add('update ${(d['update'] as List).length}');
        }
        if ((d['remove'] as List).isNotEmpty) {
          parts.add('remove ${(d['remove'] as List).length}');
        }
        if (parts.isNotEmpty) {
          buf.writeln('- Query Params: ${parts.join(', ')}');
        }
      }
      if (diff.containsKey('body')) {
        final d = (diff['body'] as Map).cast<String, dynamic>();
        final t = (d['type'] as Map).cast<String, dynamic>();
        final s = (d['size'] as Map).cast<String, dynamic>();
        buf.writeln(
            '- Body: ${t['from']} → ${t['to']} (${s['from']} → ${s['to']} chars)');
      }
    }
    return buf.toString();
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

  // Public helpers to reuse where needed
  static String summaryForPayload(Map<String, dynamic> p) =>
      _summaryForCurlPayload(p);
  static Map<String, dynamic> diffForPayload(
          Map<String, dynamic> p, Map<String, dynamic>? current) =>
      _diffWithCurrent(p, current);
}
