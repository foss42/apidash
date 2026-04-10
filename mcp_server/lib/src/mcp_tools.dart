import 'dart:convert';
import 'package:http/http.dart' as http;
import 'mcp_resources.dart';

const _baseUri = 'ui://apidash-mcp';

class McpTools {
  // ── Manifest (tools/list) ────────────────────────────────────────────────

  static List<Map<String, dynamic>> manifest() => [
        {
          'name': 'generate_unit_tests',
          'description': 'Generate AI-powered test cases for an API endpoint. '
              'Opens an interactive checklist UI inside the chat.',
          'inputSchema': {
            'type': 'object',
            'properties': {
              'url': {'type': 'string', 'description': 'Full endpoint URL'},
              'method': {
                'type': 'string',
                'description': 'HTTP method: GET/POST/PUT/DELETE/PATCH'
              },
              'headers': {'type': 'object', 'description': 'Request headers'},
              'body': {
                'type': 'string',
                'description': 'Request body (optional)'
              },
              'gemini_api_key': {
                'type': 'string',
                'description': 'Gemini API key'
              },
            },
            'required': ['url', 'method', 'gemini_api_key'],
          },
          '_meta': {
            'ui': {
              'resourceUri': '$_baseUri/test-checklist-ui',
              'visibility': ['model', 'app'],
            },
          },
        },
        {
          'name': 'run_selected_tests',
          'description':
              'Run selected test cases and display results dashboard.',
          'inputSchema': {
            'type': 'object',
            'properties': {
              'test_cases': {
                'type': 'array',
                'items': {'type': 'object'},
                'description': 'Test cases with isSelected flags',
              },
            },
            'required': ['test_cases'],
          },
          '_meta': {
            'ui': {
              'resourceUri': '$_baseUri/test-results-ui',
              'visibility': ['model', 'app'],
            },
          },
        },
        {
          'name': 'generate_workflow_plan',
          'description':
              'Generate a multi-step API workflow plan as an interactive checklist.',
          'inputSchema': {
            'type': 'object',
            'properties': {
              'requests': {
                'type': 'array',
                'items': {'type': 'object'},
                'description': 'Array of API requests',
              },
              'gemini_api_key': {'type': 'string'},
            },
            'required': ['requests', 'gemini_api_key'],
          },
          '_meta': {
            'ui': {
              'resourceUri': '$_baseUri/workflow-plan-ui',
              'visibility': ['model', 'app'],
            },
          },
        },
        {
          'name': 'execute_workflow',
          'description': 'Execute workflow steps and display live results.',
          'inputSchema': {
            'type': 'object',
            'properties': {
              'steps': {
                'type': 'array',
                'items': {'type': 'object'},
              },
            },
            'required': ['steps'],
          },
          '_meta': {
            'ui': {
              'resourceUri': '$_baseUri/workflow-results-ui',
              'visibility': ['model', 'app'],
            },
          },
        },
      ];

  // ── Dispatcher (tools/call) ───────────────────────────────────────────────

  static Future<Map<String, dynamic>> call(
      String name, Map<String, dynamic> args) async {
    switch (name) {
      case 'generate_unit_tests':
        return _generateUnitTests(args);
      case 'run_selected_tests':
        return _runSelectedTests(args);
      case 'generate_workflow_plan':
        return _generateWorkflowPlan(args);
      case 'execute_workflow':
        return _executeWorkflow(args);
      default:
        throw ArgumentError('Unknown tool: $name');
    }
  }

  // ── Handlers ─────────────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> _generateUnitTests(
      Map<String, dynamic> args) async {
    final url = args['url'] as String;
    final method = (args['method'] as String).toUpperCase();
    final headers = (args['headers'] as Map<String, dynamic>? ?? {})
        .map((k, v) => MapEntry(k, v.toString()));
    final body = args['body'] as String?;
    final apiKey = args['gemini_api_key'] as String;

    final testCases = await _callGemini(
      apiKey,
      _unitTestPrompt(method: method, url: url, headers: headers, body: body),
    );

    McpResources.setTestCases(testCases);

    return {
      'content': [
        {
          'type': 'text',
          'text': 'Generated ${testCases.length} test cases for $method $url. '
              'Review and select in the checklist below.',
        }
      ],
      'structuredContent': {
        'testCases': testCases,
        'endpoint': '$method $url',
      },
    };
  }

  static Future<Map<String, dynamic>> _runSelectedTests(
      Map<String, dynamic> args) async {
    final rawList = args['test_cases'] as List<dynamic>;
    final selected = rawList
        .where((tc) => tc['isSelected'] == true)
        .map((tc) => tc as Map<String, dynamic>)
        .toList();

    final results = <Map<String, dynamic>>[];
    for (final tc in selected) {
      results.add(await _executeTestCase(tc));
    }
    for (final tc in rawList) {
      if (tc['isSelected'] != true) {
        results.add({
          'testCase': tc,
          'overallStatus': 'skipped',
          'actualStatusCode': 0,
          'durationMs': 0,
          'assertionResults': [],
        });
      }
    }

    McpResources.setTestResults(results);

    final passed = results.where((r) => r['overallStatus'] == 'passed').length;
    final failed = results.where((r) => r['overallStatus'] == 'failed').length;

    return {
      'content': [
        {
          'type': 'text',
          'text':
              'Test run complete: $passed passed, $failed failed out of ${selected.length} selected.',
        }
      ],
      'structuredContent': {'results': results},
    };
  }

  static Future<Map<String, dynamic>> _generateWorkflowPlan(
      Map<String, dynamic> args) async {
    final requests = (args['requests'] as List<dynamic>)
        .map((r) => r as Map<String, dynamic>)
        .toList();
    final apiKey = args['gemini_api_key'] as String;

    final steps = await _callGemini(apiKey, _workflowPrompt(requests));
    McpResources.setWorkflowSteps(steps);

    return {
      'content': [
        {
          'type': 'text',
          'text':
              'Generated workflow with ${steps.length} steps. Review assertions in the checklist below.'
        },
      ],
      'structuredContent': {'steps': steps},
    };
  }

  static Future<Map<String, dynamic>> _executeWorkflow(
      Map<String, dynamic> args) async {
    final steps = (args['steps'] as List<dynamic>)
        .map((s) => s as Map<String, dynamic>)
        .toList();

    final results = <Map<String, dynamic>>[];
    final context = <String, dynamic>{};

    for (final step in steps) {
      final result = await _executeWorkflowStep(step, context);
      final extractions = step['dataExtractions'] as List<dynamic>? ?? [];
      for (final ex in extractions) {
        final varName = ex['variableName'] as String? ?? '';
        final path = ex['jsonPath'] as String? ?? '';
        if (varName.isNotEmpty && path.isNotEmpty) {
          context[varName] =
              _extractJsonPath(result['responseBody'] as String? ?? '{}', path);
        }
      }
      results.add(result);
      if (result['overallStatus'] == 'failed') break;
    }

    McpResources.setWorkflowResults(results);

    return {
      'content': [
        {
          'type': 'text',
          'text': 'Workflow executed: ${results.length} steps completed.'
        },
      ],
      'structuredContent': {'results': results},
    };
  }

  // ── HTTP Test Execution ───────────────────────────────────────────────────

  static Future<Map<String, dynamic>> _executeTestCase(
      Map<String, dynamic> tc) async {
    final url = tc['url'] as String;
    final method = (tc['method'] as String).toUpperCase();
    final headers = (tc['headers'] as Map<String, dynamic>? ?? {})
        .map((k, v) => MapEntry(k, v.toString()));

    // body can be String or Map (if Gemini put a raw object) — normalise to String
    final rawBody = tc['body'];
    final String? body = rawBody == null
        ? null
        : rawBody is String
            ? rawBody
            : jsonEncode(rawBody); // ← handles Map body from Gemini

    final sw = Stopwatch()..start();
    try {
      final uri = Uri.parse(url);
      final req = http.Request(method, uri);
      headers.forEach((k, v) => req.headers[k] = v);
      if (body != null && body.isNotEmpty) req.body = body;

      final streamed = await req.send();
      final resp = await http.Response.fromStream(streamed);
      sw.stop();

      final assertions = tc['assertions'] as List<dynamic>? ?? [];
      final assertionResults = <Map<String, dynamic>>[];
      var overallPass = true;

      for (final a in assertions) {
        final type = a['type'] as String;
        final expected = a['expected'].toString(); // safe toString
        final result = _checkAssertion(
            type, expected, resp.statusCode, resp.body, sw.elapsedMilliseconds);
        if (!result['passed']) overallPass = false;
        assertionResults.add(result);
      }

      return {
        'testCase': tc,
        'actualStatusCode': resp.statusCode,
        'durationMs': sw.elapsedMilliseconds,
        'assertionResults': assertionResults,
        'overallStatus': overallPass ? 'passed' : 'failed',
      };
    } catch (e) {
      sw.stop();
      return {
        'testCase': tc,
        'actualStatusCode': 0,
        'durationMs': sw.elapsedMilliseconds,
        'assertionResults': [],
        'overallStatus': 'failed',
        'errorMessage': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> _executeWorkflowStep(
      Map<String, dynamic> step, Map<String, dynamic> context) async {
    var url = step['url'] as String;
    var body = step['body'] as String?;
    context.forEach((k, v) {
      url = url.replaceAll('{{$k}}', v.toString());
      if (body != null) body = body!.replaceAll('{{$k}}', v.toString());
    });

    final tc = {...step, 'url': url, 'body': body, 'isSelected': true};
    final result = await _executeTestCase(tc);
    return {...result, 'step': step};
  }

  static Map<String, dynamic> _checkAssertion(String type, String expected,
      int statusCode, String body, int durationMs) {
    switch (type) {
      case 'status_code':
        final pass = statusCode == int.tryParse(expected);
        return {
          'type': type,
          'passed': pass,
          'skipped': false,
          'message': pass
              ? 'Status $statusCode == $expected ✓'
              : 'Expected $expected, got $statusCode',
        };
      case 'body_contains':
        final pass = body.contains(expected);
        return {
          'type': type,
          'passed': pass,
          'skipped': false,
          'message': pass
              ? 'Body contains "$expected" ✓'
              : 'Body does not contain "$expected"',
        };
      case 'body_does_not_contain':
      case 'body_not_contains':
        final pass = !body.contains(expected);
        return {
          'type': type,
          'passed': pass,
          'skipped': false,
          'message': pass
              ? 'Body does not contain "$expected" ✓'
              : 'Body unexpectedly contains "$expected"',
        };
      case 'response_time_ms':
        final limit = int.tryParse(expected) ?? 2000;
        final pass = durationMs <= limit;
        return {
          'type': type,
          'passed': pass,
          'skipped': false,
          'message': pass
              ? 'Response time ${durationMs}ms <= ${limit}ms ✓'
              : 'Response time ${durationMs}ms exceeded ${limit}ms',
        };
      case 'body_schema':
        try {
          final bodyJson = jsonDecode(body) as Map<String, dynamic>;
          final schema = jsonDecode(expected) as Map<String, dynamic>;
          final props =
              (schema['properties'] as Map<String, dynamic>?)?.keys.toList() ??
                  [];
          final missing = props.where((k) => !bodyJson.containsKey(k)).toList();
          final pass = missing.isEmpty;
          return {
            'type': type,
            'passed': pass,
            'skipped': false,
            'message': pass
                ? 'Schema valid — all keys present ✓'
                : 'Missing keys: ${missing.join(', ')}',
          };
        } catch (_) {
          return {
            'type': type,
            'passed': false,
            'skipped': false,
            'message': 'Schema check failed — invalid JSON'
          };
        }
      case 'body_value':
        try {
          final bodyJson = jsonDecode(body) as Map<String, dynamic>;
          final parts = expected.split('==').map((s) => s.trim()).toList();
          final key = parts[0];
          final expectedVal = parts.length > 1 ? parts[1] : '';
          final actualVal = bodyJson[key];
          final pass = actualVal.toString() == expectedVal;
          return {
            'type': type,
            'passed': pass,
            'skipped': false,
            'message': pass
                ? 'body["$key"] == $expectedVal ✓'
                : 'Expected body["$key"] == $expectedVal, got $actualVal',
          };
        } catch (_) {
          return {
            'type': type,
            'passed': false,
            'skipped': false,
            'message': 'body_value check failed'
          };
        }
      case 'body_type':
        try {
          final bodyJson = jsonDecode(body) as Map<String, dynamic>;
          final parts = expected.split(':').map((s) => s.trim()).toList();
          final key = parts[0];
          final expectedType = parts.length > 1 ? parts[1] : '';
          final val = bodyJson[key];
          final actualType = val is int
              ? 'integer'
              : val is double
                  ? 'number'
                  : val is bool
                      ? 'boolean'
                      : val is String
                          ? 'string'
                          : val is List
                              ? 'array'
                              : val is Map
                                  ? 'object'
                                  : 'null';
          final pass = actualType == expectedType ||
              (expectedType == 'integer' && val is num);
          return {
            'type': type,
            'passed': pass,
            'skipped': false,
            'message': pass
                ? 'body["$key"] is $expectedType ✓'
                : 'Expected $expectedType, got $actualType',
          };
        } catch (_) {
          return {
            'type': type,
            'passed': false,
            'skipped': false,
            'message': 'body_type check failed'
          };
        }
      default:
        return {
          'type': type,
          'passed': false,
          'skipped': true,
          'message': 'Unknown assertion type: $type'
        };
    }
  }

  // ── Gemini Client ─────────────────────────────────────────────────────────

  /// Sanitizes JS expressions that Gemini sometimes emits inside JSON strings.
  /// Must run BEFORE jsonDecode.
  static String _sanitizeGeminiJson(String raw) {
    // Pass 1: "string".repeat(N) → repeated plain string (capped at 80 chars)
    raw = raw.replaceAllMapped(
      RegExp(r'"([^"\\]*)"\s*\.\s*repeat\s*\(\s*(\d+)\s*\)'),
      (m) {
        final base = m.group(1)!;
        final count = int.tryParse(m.group(2)!) ?? 1;
        final full = base * count;
        return '"${full.length > 80 ? full.substring(0, 80) : full}"';
      },
    );

    // Pass 2: "a" + "b" chains → "ab" (repeat until no matches)
    final concat = RegExp(r'"([^"\\]*)"\s*\+\s*"([^"\\]*)"');
    var prev = '';
    while (prev != raw) {
      prev = raw;
      raw =
          raw.replaceAllMapped(concat, (m) => '"${m.group(1)!}${m.group(2)!}"');
    }

    // Pass 3: any remaining value like identifier.method(...) outside quotes → "value"
    // e.g.  "body": null.toString()  or  "body": someVar.trim()
    raw = raw.replaceAllMapped(
      RegExp(r':\s*([a-zA-Z_\$][a-zA-Z0-9_\$]*)\s*\.\s*\w+\s*\([^)]*\)'),
      (_) => ': "invalid"',
    );

    // Pass 4: body field that is a raw JSON object → stringify it
    // Gemini sometimes writes: "body": {"key": "value"}  instead of "body": "{...}"
    // We leave this as-is since _executeTestCase now handles Map body natively.

    return raw;
  }

  static Future<List<Map<String, dynamic>>> _callGemini(
      String apiKey, String prompt) async {
    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent?key=$apiKey',
    );
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'role': 'user',
            'parts': [
              {'text': prompt}
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.1,
          'maxOutputTokens': 4096,
          'responseMimeType': 'application/json', // Force JSON output mode
        },
      }),
    );

    if (resp.statusCode != 200) {
      throw Exception('Gemini error ${resp.statusCode}: ${resp.body}');
    }

    final decoded = jsonDecode(resp.body) as Map<String, dynamic>;
    final text =
        decoded['candidates'][0]['content']['parts'][0]['text'] as String;

    // Step 1: strip markdown fences
    var cleaned = text
        .replaceAll(RegExp(r'```json\s*'), '')
        .replaceAll(RegExp(r'```\s*'), '')
        .trim();

    // Step 2: extract only the JSON array
    final start = cleaned.indexOf('[');
    final end = cleaned.lastIndexOf(']');
    if (start == -1 || end == -1 || end <= start) {
      throw Exception(
          'Gemini did not return a JSON array. Preview: ${cleaned.substring(0, cleaned.length.clamp(0, 200))}');
    }
    cleaned = cleaned.substring(start, end + 1);

    // Step 3: sanitize JS expressions BEFORE parsing
    cleaned = _sanitizeGeminiJson(cleaned);

    // Step 4: parse
    try {
      final parsed = jsonDecode(cleaned);
      if (parsed is List) return parsed.cast<Map<String, dynamic>>();
      if (parsed is Map && parsed.containsKey('steps')) {
        return (parsed['steps'] as List).cast<Map<String, dynamic>>();
      }
      return [parsed as Map<String, dynamic>];
    } catch (e) {
      throw Exception(
          'Failed to parse Gemini JSON: $e\nPreview: ${cleaned.substring(0, cleaned.length.clamp(0, 400))}');
    }
  }

  // ── Prompts ───────────────────────────────────────────────────────────────

  static String _unitTestPrompt({
    required String method,
    required String url,
    required Map<String, String> headers,
    String? body,
  }) =>
      '''You are an API testing expert. Output a JSON array of exactly 5 test cases. No explanation, no markdown.

Endpoint: $method $url
Headers: ${headers.isEmpty ? '{}' : jsonEncode(headers)}
Body: ${body ?? 'null'}

RULES:
- Output ONLY a JSON array. Start with [ end with ]. Nothing else.
- "body" field: null OR a plain JSON string like "{\\"k\\": \\"v\\"}" — never a raw object.
- "expected" in assertions: plain string only — "200", "3000", "keyword".
- No JavaScript. No .repeat(). No + operator. Short plain strings only.

Use compact JSON (no extra whitespace). Schema:
[{"id":"tc_1","description":"...","category":"happy_path","method":"$method","url":"$url","headers":{},"body":null,"assertions":[{"type":"status_code","expected":"200"},{"type":"response_time_ms","expected":"3000"}],"isSelected":true}]

Generate exactly 5 test cases covering: happy_path(x2), edge_case, security, performance.''';

  static String _workflowPrompt(List<Map<String, dynamic>> requests) => '''
Design a multi-step API workflow for these requests: ${jsonEncode(requests)}

STRICT OUTPUT RULES:
1. Output a JSON array ONLY. Nothing before [ or after ].
2. All values must be valid JSON — no JavaScript expressions.
3. The "body" field must be null or a JSON-encoded string.

Return this exact shape:
[
  {
    "id": "step_1",
    "name": "Step description",
    "method": "GET",
    "url": "https://...",
    "headers": {},
    "body": null,
    "assertions": [{"type": "status_code", "expected": "200"}],
    "dataExtractions": [{"variableName": "userId", "jsonPath": "\$.id"}]
  }
]
''';

  static dynamic _extractJsonPath(String jsonBody, String path) {
    try {
      final data = jsonDecode(jsonBody);
      final field = path.replaceAll(r'$.', '').split('.').first;
      if (data is Map) return data[field];
    } catch (_) {}
    return null;
  }
}
