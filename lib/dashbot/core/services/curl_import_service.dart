import 'dart:convert';
import 'package:curl_parser/curl_parser.dart';

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

    return {
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
  }

  /// Build the message object with two actions: apply to selected or new.
  static Map<String, dynamic> buildActionMessageFromPayload(
      Map<String, dynamic> actionPayload,
      {String? note}) {
    final explanation = StringBuffer(
        'Parsed the cURL command. Where do you want to apply the changes? Choose one of the options below.');
    if (note != null && note.isNotEmpty) {
      explanation.writeln('');
      explanation.write('Note: $note');
    }
    return {
      'explnation': explanation.toString(),
      'actions': [
        {
          'action': 'apply_curl',
          'target': 'httpRequestModel',
          'field': 'apply_to_selected',
          'path': null,
          'value': actionPayload,
        },
        {
          'action': 'apply_curl',
          'target': 'httpRequestModel',
          'field': 'apply_to_new',
          'path': null,
          'value': actionPayload,
        }
      ]
    };
  }

  /// Convenience: from parsed [Curl] to (json, actions list).
  static ({String jsonMessage, List<Map<String, dynamic>> actions})
      buildResponseFromParsed(Curl curl) {
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
  }) processPastedCurl(String input) {
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
      final built = buildResponseFromParsed(curl);
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
}
