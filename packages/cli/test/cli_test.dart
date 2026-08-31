import 'dart:convert';
import 'package:better_networking/better_networking.dart';
import 'package:test/test.dart';

// Ponytail: one runnable check on the load-bearing logic — that a saved
// request's stored JSON round-trips back into a real HttpRequestModel the
// engine can send, and that HTTP-verb parsing matches the enum.
void main() {
  test('stored request JSON rebuilds an HttpRequestModel', () {
    final stored = {
      'method': 'post',
      'url': 'https://api.apidash.dev/case/lower',
      'headers': [
        {'name': 'Content-Type', 'value': 'application/json'}
      ],
      'body': '{"text":"HELLO"}',
      'bodyContentType': 'json',
    };
    // The CLI cleans Hive maps via a JSON round-trip before fromJson.
    final clean = jsonDecode(jsonEncode(stored)) as Map<String, Object?>;
    final model = HttpRequestModel.fromJson(clean);

    expect(model.method, HTTPVerb.post);
    expect(model.url, 'https://api.apidash.dev/case/lower');
    expect(model.enabledHeadersMap['Content-Type'], 'application/json');
    expect(model.body, '{"text":"HELLO"}');
  });

  test('every HTTP method name maps to an HTTPVerb', () {
    for (final m in ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'HEAD', 'OPTIONS']) {
      final verb = HTTPVerb.values
          .firstWhere((v) => v.name.toUpperCase() == m);
      expect(verb.name.toUpperCase(), m);
    }
  });
}
