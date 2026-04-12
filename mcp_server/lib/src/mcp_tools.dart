import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'mcp_resources.dart';

const _baseUri = 'ui://apidash-mcp';
const _uiMeta = {'type': 'text', 'mimeType': 'text/html;profile=mcp-app'};

class McpTools {
  // ── tools/list ────────────────────────────────────────────────────────────

  static List<Map<String, dynamic>> manifest() => [
        {
          'name': 'generate_unit_tests',
          'description': 'Generate AI-powered test cases for an API endpoint '
              'and open an interactive checklist UI in chat.',
          'inputSchema': {
            'type': 'object',
            'required': ['url', 'method'],
            'properties': {
              'url':     {'type': 'string', 'description': 'Full endpoint URL'},
              'method':  {'type': 'string', 'description': 'HTTP method: GET/POST/PUT/DELETE/PATCH'},
              'headers': {'type': 'object', 'description': 'Request headers (optional)'},
              'body':    {'type': 'string', 'description': 'Request body (optional)'},
              'count':   {'type': 'integer', 'description': 'Number of test cases to generate (default: 5, max: 10)'},
            },
          },
          '_meta': {'ui': {'resourceUri': '$_baseUri/test-checklist-ui', 'visibility': ['model', 'app']}},
        },
        {
          'name': 'run_selected_tests',
          'description': 'Execute the test cases selected in the checklist UI '
              'against the real API and display results.',
          'inputSchema': {
            'type': 'object',
            'required': [],
            'properties': {
              'test_cases': {
                'type': 'array',
                'items': {'type': 'object'},
                'description': 'Selected test cases (with isSelected:true) from checklist context.',
              },
            },
          },
          '_meta': {'ui': {'resourceUri': '$_baseUri/test-results-ui', 'visibility': ['model', 'app']}},
        },
      ];

  // ── tools/call ────────────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> call(
      String name, Map<String, dynamic> args) async {
    return switch (name) {
      'generate_unit_tests' => await _generateUnitTests(args),
      'run_selected_tests'  => await _runSelectedTests(args),
      _ => throw ArgumentError('Unknown tool: $name'),
    };
  }

  // ── generate_unit_tests ───────────────────────────────────────────────────

  static Future<Map<String, dynamic>> _generateUnitTests(
      Map<String, dynamic> args) async {
    final url    = args['url'] as String;
    final method = (args['method'] as String).toUpperCase();
    final headers = ((args['headers'] as Map?) ?? {}).map((k, v) => MapEntry('$k', '$v'));
    final body   = args['body'] as String?;
    final count  = (args['count'] as int?)?.clamp(1, 10) ?? 5;
    final apiKey = _apiKey();

    final cases = await _callGemini(apiKey, _testPrompt(method, url, headers, body, count));
    McpResources.setTestCases(cases);

    return {
      'content': [
        {'type': 'text', 'text': 'Generated ${cases.length} test cases for $method $url. Select cases below, then ask Copilot to run them.'},
        {..._uiMeta, 'text': McpResources.readHtml('$_baseUri/test-checklist-ui')},
      ],
      'structuredContent': {'testCases': cases, 'url': url, 'method': method},
      '_meta': {'ui': {'resourceUri': '$_baseUri/test-checklist-ui'}},
    };
  }

  // ── run_selected_tests ────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> _runSelectedTests(
      Map<String, dynamic> args) async {
    final rawList = (args['test_cases'] as List?)?.cast<Map<String, dynamic>>()
        ?? McpResources.getSelectedTestCases();

    if (rawList.isEmpty) {
      return _errResponse('No test cases found. Submit a selection in the checklist first.');
    }

    final selected = rawList.where((tc) => tc['isSelected'] == true).toList();
    final skipped  = rawList.where((tc) => tc['isSelected'] != true).toList();

    final results = [
      ...await Future.wait(selected.map(_executeTestCase)),
      ...skipped.map((tc) => _skippedResult(tc)),
    ];

    McpResources.setTestResults(results);

    final passed = results.where((r) => r['overallStatus'] == 'passed').length;
    final failed = results.where((r) => r['overallStatus'] == 'failed').length;

    return {
      'content': [
        {'type': 'text', 'text': 'Run complete: $passed passed, $failed failed out of ${selected.length} selected.'},
        {..._uiMeta, 'text': McpResources.readHtml('$_baseUri/test-results-ui')},
      ],
      'structuredContent': {'results': results},
      '_meta': {'ui': {'resourceUri': '$_baseUri/test-results-ui'}},
    };
  }

  // ── HTTP runner ───────────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> _executeTestCase(
      Map<String, dynamic> tc) async {
    final uri     = Uri.parse(tc['url'] as String);
    final method  = (tc['method'] as String).toUpperCase();
    final headers = ((tc['headers'] as Map?) ?? {}).map((k, v) => MapEntry('$k', '$v'));
    final rawBody = tc['body'];
    final bodyStr = rawBody == null ? null : rawBody is String ? rawBody : jsonEncode(rawBody);

    final sw = Stopwatch()..start();
    try {
      final req = http.Request(method, uri)..headers.addAll(headers);
      if (bodyStr != null && bodyStr.isNotEmpty) req.body = bodyStr;
      final resp = await http.Response.fromStream(await req.send())
          .timeout(const Duration(seconds: 30));
      sw.stop();

      final assertions = (tc['assertions'] as List? ?? [])
          .map((a) => _evalAssertion(a as Map<String, dynamic>, resp.statusCode, resp.body, sw.elapsedMilliseconds))
          .toList();

      return {
        'testCase': tc,
        'actualStatusCode': resp.statusCode,
        'durationMs': sw.elapsedMilliseconds,
        'assertionResults': assertions,
        'overallStatus': assertions.every((r) => r['passed'] == true || r['skipped'] == true) ? 'passed' : 'failed',
      };
    } catch (e) {
      sw.stop();
      return {
        'testCase': tc,
        'actualStatusCode': 0,
        'durationMs': sw.elapsedMilliseconds,
        'assertionResults': <Map<String, dynamic>>[],
        'overallStatus': 'failed',
        'errorMessage': e.toString(),
      };
    }
  }

  static Map<String, dynamic> _skippedResult(Map<String, dynamic> tc) => {
        'testCase': tc, 'overallStatus': 'skipped',
        'actualStatusCode': 0, 'durationMs': 0, 'assertionResults': [],
      };

  static Map<String, dynamic> _evalAssertion(
      Map<String, dynamic> a, int status, String body, int ms) {
    final type     = a['type'] as String? ?? '';
    final expected = a['expected'].toString();
    return switch (type) {
      'status_code'     => _assert(status == int.tryParse(expected), type, 'Expected $expected, got $status'),
      'response_time_ms'=> _assert(ms <= (int.tryParse(expected) ?? 2000), type, '${ms}ms exceeded ${expected}ms'),
      'body_contains'   => _assert(body.contains(expected), type, 'Body missing "$expected"'),
      'body_not_contains' || 'body_does_not_contain'
                        => _assert(!body.contains(expected), type, 'Body unexpectedly contains "$expected"'),
      'body_schema'     => _evalSchema(body, expected, type),
      'body_value'      => _evalBodyValue(body, expected, type),
      'body_type'       => _evalBodyType(body, expected, type),
      _ => {'type': type, 'passed': false, 'skipped': true, 'message': 'Unknown assertion: $type'},
    };
  }

  static Map<String, dynamic> _assert(bool ok, String type, String failMsg) => {
        'type': type, 'passed': ok, 'skipped': false,
        'message': ok ? '$type ✓' : failMsg,
      };

  static Map<String, dynamic> _evalSchema(String body, String expected, String type) {
    try {
      final b = jsonDecode(body) as Map;
      final required = (jsonDecode(expected)['properties'] as Map?)?.keys.toList() ?? [];
      final missing = required.where((k) => !b.containsKey(k)).toList();
      return _assert(missing.isEmpty, type, 'Missing keys: $missing');
    } catch (_) {
      return _assert(false, type, 'Schema check failed — invalid JSON');
    }
  }

  static Map<String, dynamic> _evalBodyValue(String body, String expected, String type) {
    try {
      final b = jsonDecode(body) as Map;
      final parts = expected.split('==').map((s) => s.trim()).toList();
      final actual = b[parts[0]]?.toString();
      return _assert(actual == parts[1], type, 'Expected ${parts[0]}==${parts[1]}, got $actual');
    } catch (_) {
      return _assert(false, type, 'body_value check failed');
    }
  }

  static Map<String, dynamic> _evalBodyType(String body, String expected, String type) {
    try {
      final b = jsonDecode(body) as Map;
      final parts = expected.split(':').map((s) => s.trim()).toList();
      final val = b[parts[0]];
      final actual = val is int || val is double ? 'number' : val is bool ? 'boolean'
          : val is String ? 'string' : val is List ? 'array' : val is Map ? 'object' : 'null';
      return _assert(actual == parts[1] || (parts[1] == 'integer' && val is num),
          type, 'Expected ${parts[1]}, got $actual');
    } catch (_) {
      return _assert(false, type, 'body_type check failed');
    }
  }

  // ── Gemini client ─────────────────────────────────────────────────────────

  static String _apiKey() {
    final k = Platform.environment['GEMINI_API_KEY'] ?? '';
    if (k.isEmpty) throw Exception('GEMINI_API_KEY env var not set');
    return k;
  }

  static Future<List<Map<String, dynamic>>> _callGemini(
      String apiKey, String prompt) async {
    final resp = await http.post(
      Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/'
          'gemini-2.5-flash-lite:generateContent?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [{'role': 'user', 'parts': [{'text': prompt}]}],
        'generationConfig': {'temperature': 0.1, 'maxOutputTokens': 4096, 'responseMimeType': 'application/json'},
      }),
    ).timeout(const Duration(seconds: 60));

    if (resp.statusCode != 200) throw Exception('Gemini ${resp.statusCode}: ${resp.body}');

    var text = (jsonDecode(resp.body)['candidates'][0]['content']['parts'][0]['text'] as String)
        .replaceAll(RegExp(r'```json\s*'), '').replaceAll(RegExp(r'```\s*'), '').trim();

    text = _sanitize(text);

    final start = text.indexOf('['), end = text.lastIndexOf(']');
    if (start == -1 || end <= start) {
      throw Exception('Gemini did not return a JSON array: ${text.substring(0, text.length.clamp(0, 200))}');
    }

    try {
      return (jsonDecode(text.substring(start, end + 1)) as List).cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('JSON parse failed: $e\n${text.substring(0, text.length.clamp(0, 400))}');
    }
  }

  static String _sanitize(String raw) {
    // Remove "str".repeat(N) expressions
    raw = raw.replaceAllMapped(
      RegExp(r'"([^"\\]*)"\s*\.\s*repeat\s*\(\s*(\d+)\s*\)'),
      (m) { final s = m.group(1)! * (int.tryParse(m.group(2)!) ?? 1); return '"${s.length > 80 ? s.substring(0, 80) : s}"'; },
    );
    // Collapse "a"+"b" chains
    final concat = RegExp(r'"([^"\\]*)"\s*\+\s*"([^"\\]*)"');
    var prev = '';
    while (prev != raw) { prev = raw; raw = raw.replaceAllMapped(concat, (m) => '"${m.group(1)!}${m.group(2)!}"'); }
    // Remove bare method calls outside strings
    raw = raw.replaceAllMapped(RegExp(r':\s*([a-zA-Z_\$][a-zA-Z0-9_\$]*)\s*\.\s*\w+\s*\([^)]*\)'), (_) => ': "invalid"');
    // Remove trailing commas
    return raw.replaceAll(RegExp(r',\s*([}\]])'), r'\1');
  }

  // ── Prompt ────────────────────────────────────────────────────────────────

  static String _testPrompt(String method, String url,
      Map<String, String> headers, String? body, int count) =>
      '''You are an API testing expert. Output a JSON array of exactly $count test cases. No explanation, no markdown.

Endpoint: $method $url
Headers: ${headers.isEmpty ? '{}' : jsonEncode(headers)}
Body: ${body ?? 'null'}

RULES:
- Output ONLY a JSON array. Start with [ end with ]. Nothing else.
- Generate EXACTLY $count test case(s). No more, no less.
- "body" field: null OR a plain JSON string — never a raw object.
- "expected" in assertions: plain string only — "200", "3000", "keyword".
- No JavaScript. No .repeat(). No + operator.

Schema:
[{"id":"tc_1","description":"...","category":"happy_path","method":"$method","url":"$url","headers":{},"body":null,"assertions":[{"type":"status_code","expected":"200"},{"type":"response_time_ms","expected":"3000"}],"isSelected":true}]

${_categoryHint(count)}''';

  static String _categoryHint(int count) {
    if (count == 1) return 'Generate 1 test: happy_path.';
    if (count == 2) return 'Generate 2 tests: happy_path, edge_case.';
    if (count == 3) return 'Generate 3 tests: happy_path(x2), edge_case.';
    if (count == 4) return 'Generate 4 tests: happy_path(x2), edge_case, security.';
    return 'Generate $count tests spread across: happy_path, edge_case, security, performance.';
  }

  static Map<String, dynamic> _errResponse(String msg) => {
        'isError': true,
        'content': [{'type': 'text', 'text': msg}],
      };
}