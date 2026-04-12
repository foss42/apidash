import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'mcp_resources.dart';

const _baseUri = 'ui://apidash-mcp';

class McpTools {
  // ── tools/list manifest ──────────────────────────────────────────────────

  static List<Map<String, dynamic>> manifest() => [
        {
          'name': 'generate_unit_tests',
          'description':
              'Generate AI-powered test cases for an API endpoint. '
              'Opens an interactive checklist UI inside the chat.',
          'inputSchema': {
            'type': 'object',
            'properties': {
              'url': {'type': 'string', 'description': 'Full endpoint URL'},
              'method': {
                'type': 'string',
                'description': 'HTTP method: GET/POST/PUT/DELETE/PATCH'
              },
              'headers': {
                'type': 'object',
                'description': 'Request headers (optional)'
              },
              'body': {
                'type': 'string',
                'description': 'Request body (optional)'
              },
            },
            'required': ['url', 'method'],
          },
          '_meta': {
            'ui': {
              'resourceUri': '$_baseUri/test-checklist-ui',
              'visibility': ['model', 'app'],
            }
          },
        },
        {
          'name': 'run_selected_tests',
          'description':
              'Execute the user-selected test cases against the real API. '
              'Call this after the user has confirmed their selection in the checklist UI. '
              'If test_cases is omitted, uses the last submitted selection.',
          'inputSchema': {
            'type': 'object',
            'properties': {
              'test_cases': {
                'type': 'array',
                'description':
                    'Array of test case objects from the chat context',
                'items': {'type': 'object'}
              },
            },
            'required': [],
          },
          '_meta': {
            'ui': {
              'resourceUri': '$_baseUri/test-results-ui',
              'visibility': ['model', 'app'],
            }
          },
        },
        {
          'name': 'generate_workflow_plan',
          'description':
              'Generate a multi-step API workflow test plan. '
              'Opens an interactive step selector UI inside the chat.',
          'inputSchema': {
            'type': 'object',
            'properties': {
              'description': {
                'type': 'string',
                'description':
                    'Natural language description of the workflow '
                    '(e.g. "create a user then fetch it then delete it")'
              },
              'base_url': {
                'type': 'string',
                'description': 'Base API URL (e.g. https://api.example.com)'
              },
              'headers': {
                'type': 'object',
                'description': 'Common request headers (optional)'
              },
            },
            'required': ['description', 'base_url'],
          },
          '_meta': {
            'ui': {
              'resourceUri': '$_baseUri/workflow-plan-ui',
              'visibility': ['model', 'app'],
            }
          },
        },
        {
          'name': 'execute_workflow',
          'description':
              'Execute a multi-step API workflow sequentially, passing data between steps. '
              'Call this after the user confirms workflow steps in the plan UI.',
          'inputSchema': {
            'type': 'object',
            'properties': {
              'steps': {
                'type': 'array',
                'description': 'Array of workflow step objects from chat context',
                'items': {'type': 'object'}
              },
            },
            'required': ['steps'],
          },
          '_meta': {
            'ui': {
              'resourceUri': '$_baseUri/workflow-results-ui',
              'visibility': ['model', 'app'],
            }
          },
        },
        // App-only tool: called by the HTML UI, not exposed to the model
        // Mirrors get-sales-data in the TypeScript reference
        {
          'name': 'get_selected_cases',
          'description':
              'App-only: validate and echo selected test cases back to the UI.',
          'inputSchema': {
            'type': 'object',
            'properties': {
              'selected_cases': {
                'type': 'array',
                'items': {'type': 'object'}
              }
            },
            'required': ['selected_cases'],
          },
          '_meta': {
            'ui': {
              'resourceUri': '$_baseUri/test-checklist-ui',
              'visibility': ['app'], // app-only, not shown to model
            }
          },
        },
      ];

  // ── tools/call dispatcher ────────────────────────────────────────────────

  static Future<Map<String, dynamic>> call(
      String name, Map<String, dynamic> args) async {
    return switch (name) {
      'generate_unit_tests' => await _generateUnitTests(args),
      'run_selected_tests' => await _runSelectedTests(args),
      'generate_workflow_plan' => await _generateWorkflowPlan(args),
      'execute_workflow' => await _executeWorkflow(args),
      'get_selected_cases' => _getSelectedCases(args),
      _ => _err('Unknown tool: $name'),
    };
  }

  // ── generate_unit_tests ──────────────────────────────────────────────────

  static Future<Map<String, dynamic>> _generateUnitTests(
      Map<String, dynamic> args) async {
    try {
      final url = args['url'] as String;
      final method = args['method'] as String;
      final headers = (args['headers'] as Map?)?.cast<String, dynamic>() ?? {};
      final body = args['body'] as String? ?? '';

      final testCases = await _callGemini(
        prompt: _testCasePrompt(url, method, headers, body),
      );

      McpResources.setTestCases(testCases);
      final html = McpResources.readHtml('$_baseUri/test-checklist-ui');

      return {
        'content': [
          {
            'type': 'text',
            'text': 'Generated ${testCases.length} test cases for $method $url. '
                'Select the cases you want to run in the checklist below.',
          },
          {
            'type': 'text',
            'text': html,
            'mimeType': 'text/html;profile=mcp-app',
          },
        ],
        // structuredContent → VSCode sends this as ui/notifications/tool-input
        // to the embedded iframe so the checklist populates automatically
        'structuredContent': {
          'testCases': testCases,
          'url': url,
          'method': method,
        },
        '_meta': {
          'ui': {
            'resourceUri': '$_baseUri/test-checklist-ui',
            'visibility': ['model', 'app'],
          }
        },
      };
    } catch (e) {
      return _err('generate_unit_tests failed: $e');
    }
  }

  // ── run_selected_tests ───────────────────────────────────────────────────

  static Future<Map<String, dynamic>> _runSelectedTests(
      Map<String, dynamic> args) async {
    try {
      final rawList = args['test_cases'] as List? ?? McpResources.getSelectedTestCases();
      final testCases =
          rawList.map((e) => (e as Map).cast<String, dynamic>()).toList();

      if (testCases.isEmpty) {
        return _err(
            'No test cases provided. Submit your selection in the checklist first.');
      }

      final results = <Map<String, dynamic>>[];
      for (final tc in testCases) {
        results.add(await _runSingleTest(tc));
      }

      McpResources.setTestResults(results);
      final html = McpResources.readHtml('$_baseUri/test-results-ui');

      final passed = results.where((r) => r['overallStatus'] == 'passed').length;
      final failed = results.where((r) => r['overallStatus'] == 'failed').length;

      return {
        'content': [
          {
            'type': 'text',
            'text': 'Test run complete: $passed passed, $failed failed '
                'out of ${testCases.length} selected.',
          },
          {
            'type': 'text',
            'text': html,
            'mimeType': 'text/html;profile=mcp-app',
          },
        ],
        'structuredContent': {'results': results},
        '_meta': {
          'ui': {
            'resourceUri': '$_baseUri/test-results-ui',
            'visibility': ['model', 'app'],
          }
        },
      };
    } catch (e) {
      return _err('run_selected_tests failed: $e');
    }
  }

  // ── generate_workflow_plan ───────────────────────────────────────────────

  static Future<Map<String, dynamic>> _generateWorkflowPlan(
      Map<String, dynamic> args) async {
    try {
      final description = args['description'] as String;
      final baseUrl = args['base_url'] as String;
      final headers = (args['headers'] as Map?)?.cast<String, dynamic>() ?? {};

      final steps = await _callGemini(
        prompt: _workflowPrompt(description, baseUrl, headers),
      );

      McpResources.setWorkflowSteps(steps);
      final html = McpResources.readHtml('$_baseUri/workflow-plan-ui');

      return {
        'content': [
          {
            'type': 'text',
            'text': 'Generated workflow with ${steps.length} steps. '
                'Review assertions in the checklist below.',
          },
          {
            'type': 'text',
            'text': html,
            'mimeType': 'text/html;profile=mcp-app',
          },
        ],
        'structuredContent': {'steps': steps},
        '_meta': {
          'ui': {
            'resourceUri': '$_baseUri/workflow-plan-ui',
            'visibility': ['model', 'app'],
          }
        },
      };
    } catch (e) {
      return _err('generate_workflow_plan failed: $e');
    }
  }

  // ── execute_workflow ─────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> _executeWorkflow(
      Map<String, dynamic> args) async {
    try {
      final rawList = args['steps'] as List? ?? [];
      final steps =
          rawList.map((e) => (e as Map).cast<String, dynamic>()).toList();

      if (steps.isEmpty) {
        return _err(
            'No workflow steps provided. Submit your selection in the plan UI first.');
      }

      final results = <Map<String, dynamic>>[];
      final ctx = <String, dynamic>{}; // shared variable context between steps

      for (final step in steps) {
        final result = await _runWorkflowStep(step, ctx);
        results.add(result);
        _extractVariables(result, step, ctx);
      }

      McpResources.setWorkflowResults(results);
      final html = McpResources.readHtml('$_baseUri/workflow-results-ui');

      final passed = results.where((r) => r['overallStatus'] == 'passed').length;
      final failed = results.where((r) => r['overallStatus'] == 'failed').length;

      return {
        'content': [
          {
            'type': 'text',
            'text': 'Workflow complete: $passed steps passed, $failed failed.',
          },
          {
            'type': 'text',
            'text': html,
            'mimeType': 'text/html;profile=mcp-app',
          },
        ],
        'structuredContent': {'results': results},
        '_meta': {
          'ui': {
            'resourceUri': '$_baseUri/workflow-results-ui',
            'visibility': ['model', 'app'],
          }
        },
      };
    } catch (e) {
      return _err('execute_workflow failed: $e');
    }
  }

  // ── get_selected_cases (app-only) ────────────────────────────────────────

  static Map<String, dynamic> _getSelectedCases(Map<String, dynamic> args) {
    final rawList = args['selected_cases'] as List? ?? [];
    final cases =
        rawList.map((e) => (e as Map).cast<String, dynamic>()).toList();
    McpResources.setSelectedTestCases(cases);
    return {
      'content': [
        {'type': 'text', 'text': 'Validated ${cases.length} selected cases.'}
      ],
      // structuredContent echoed back to the iframe
      'structuredContent': {'selectedCases': cases},
    };
  }

  // ── Gemini prompts ────────────────────────────────────────────────────────

  static String _testCasePrompt(String url, String method,
      Map<String, dynamic> headers, String body) =>
      '''
You are an API testing expert. Generate comprehensive test cases for this endpoint.

ENDPOINT:
  Method:  $method
  URL:     $url
  Headers: ${jsonEncode(headers)}
  Body:    ${body.isEmpty ? '(none)' : body}

Return ONLY a JSON array. Each element must have exactly these fields:
{
  "description": "short human-readable label",
  "category":    "happy_path" | "edge_case" | "security" | "performance",
  "method":      "GET" | "POST" | ...,
  "url":         "full URL",
  "headers":     {},
  "body":        null or "string",
  "assertions": [
    {
      "type":     "status_code" | "response_time" | "body_contains" | "json_schema",
      "expected": <value>,
      "message":  "human description"
    }
  ],
  "isSelected": true
}

Generate 5-8 test cases. Return ONLY the JSON array, no markdown fences.
''';

  static String _workflowPrompt(String description, String baseUrl,
      Map<String, dynamic> headers) =>
      r'''
You are an API workflow expert. Generate a multi-step API workflow test plan.

DESCRIPTION: $description
BASE URL:    $baseUrl
HEADERS:     ${jsonEncode(headers)}

Return ONLY a JSON array of steps. Each step:
{
  "stepName":    "short label",
  "method":      "GET" | "POST" | ...,
  "url":         "full URL (use {{varName}} for extracted values from prev steps)",
  "headers":     {},
  "body":        null or "string body (use {{varName}} for extracted values)",
  "extractVars": { "varName": "$.jsonPath" },
  "assertions": [
    {
      "type":       "status_code" | "body_contains" | "json_schema",
      "expected":   <value>,
      "message":    "human description",
      "isSelected": true
    }
  ]
}

Generate 2-5 sequential steps. Return ONLY the JSON array.
''';

  // ── Gemini caller ─────────────────────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> _callGemini(
      {required String prompt}) async {
    final apiKey = Platform.environment['GEMINI_API_KEY'] ?? '';
    if (apiKey.isEmpty) throw Exception('GEMINI_API_KEY env var not set');

    final response = await http
        .post(
          Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/'
              'gemini-2.5-flash-lite:generateContent?key=$apiKey'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'contents': [
              {
                'parts': [
                  {'text': prompt}
                ]
              }
            ],
            'generationConfig': {
              'temperature': 0.3,
              'maxOutputTokens': 8192,
            }
          }),
        )
        .timeout(const Duration(seconds: 60));

    if (response.statusCode != 200) {
      throw Exception(
          'Gemini API error ${response.statusCode}: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    var text =
        (data['candidates'] as List).first['content']['parts'].first['text']
            as String;

    // Strip markdown fences that Gemini often wraps around JSON
    text = text
        .replaceAll(RegExp(r'```json\s*'), '')
        .replaceAll(RegExp(r'```\s*'), '')
        .trim();

    // Sanitize common Gemini JSON issues (trailing commas etc.)
    text = text.replaceAll(RegExp(r',\s*([}\]])'), r'\1').trim();

    // Handle both bare [] array and {"steps":[...]} wrapper object
    final startArr = text.indexOf('[');
    final startObj = text.indexOf('{');

    if (startObj != -1 && (startArr == -1 || startObj < startArr)) {
      // Object wrapper — extract the first list value
      final end = text.lastIndexOf('}');
      final obj = jsonDecode(text.substring(startObj, end + 1))
          as Map<String, dynamic>;
      for (final key in ['steps', 'testCases', 'test_cases', 'data']) {
        if (obj.containsKey(key) && obj[key] is List) {
          return (obj[key] as List).cast<Map<String, dynamic>>();
        }
      }
    }

    // Bare array
    final end = text.lastIndexOf(']');
    final arr = jsonDecode(text.substring(startArr, end + 1)) as List;
    return arr.cast<Map<String, dynamic>>();
  }

  // ── HTTP test runner ──────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> _runSingleTest(
      Map<String, dynamic> tc) async {
    final sw = Stopwatch()..start();
    http.Response? response;
    String? errorMessage;

    try {
      final uri = Uri.parse(tc['url'] as String? ?? '');
      final method = (tc['method'] as String? ?? 'GET').toUpperCase();
      final hdrs = ((tc['headers'] as Map?) ?? {})
          .map((k, v) => MapEntry(k.toString(), v.toString()));
      final bodyStr = tc['body'] as String?;
      final client = http.Client();

      response = await (switch (method) {
        'GET' => client.get(uri, headers: hdrs),
        'POST' => client.post(uri, headers: hdrs, body: bodyStr),
        'PUT' => client.put(uri, headers: hdrs, body: bodyStr),
        'PATCH' => client.patch(uri, headers: hdrs, body: bodyStr),
        'DELETE' => client.delete(uri, headers: hdrs),
        _ => client.get(uri, headers: hdrs),
      })
          .timeout(const Duration(seconds: 30));
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      sw.stop();
    }

    final durationMs = sw.elapsedMilliseconds;
    final actualStatus = response?.statusCode ?? 0;
    final bodyText = response?.body ?? '';

    final assertions = (tc['assertions'] as List? ?? [])
        .map((a) => (a as Map).cast<String, dynamic>())
        .toList();

    final assertionResults = assertions
        .map((a) => _evalAssertion(a, actualStatus, durationMs, bodyText))
        .toList();

    final overallStatus = errorMessage != null
        ? 'failed'
        : assertionResults.every(
                (r) => r['passed'] == true || r['skipped'] == true)
            ? 'passed'
            : 'failed';

    return {
      'testCase': tc,
      'actualStatusCode': actualStatus,
      'durationMs': durationMs,
      'overallStatus': overallStatus,
      'errorMessage': errorMessage,
      'assertionResults': assertionResults,
    };
  }

  static Map<String, dynamic> _evalAssertion(
      Map<String, dynamic> a, int status, int durationMs, String body) {
    final type = a['type'] as String? ?? '';
    final expected = a['expected'];
    final message = a['message'] as String? ?? type;

    try {
      return switch (type) {
        'status_code' => _assertBool(
            status == (expected as num).toInt(),
            message,
            'Expected $expected, got $status',
          ),
        'response_time' => _assertBool(
            durationMs <= (expected as num).toInt(),
            message,
            '${durationMs}ms exceeded ${expected}ms limit',
          ),
        'body_contains' => _assertBool(
            body.contains(expected.toString()),
            message,
            'Body does not contain "$expected"',
          ),
        'json_schema' => _assertSchema(body, expected, message),
        _ => {'passed': false, 'skipped': true, 'message': 'Unknown type: $type'},
      };
    } catch (e) {
      return {'passed': false, 'skipped': false, 'message': '$message: $e'};
    }
  }

  static Map<String, dynamic> _assertBool(bool ok, String msg, String fail) =>
      {'passed': ok, 'skipped': false, 'message': ok ? msg : fail};

  static Map<String, dynamic> _assertSchema(
      String body, dynamic schema, String message) {
    try {
      final parsed = jsonDecode(body);
      if (schema is Map) {
        final required = schema['required'] as List? ?? [];
        if (parsed is Map) {
          final missing = required.where((k) => !parsed.containsKey(k)).toList();
          return missing.isEmpty
              ? {'passed': true, 'skipped': false, 'message': message}
              : {
                  'passed': false,
                  'skipped': false,
                  'message': 'Missing fields: $missing'
                };
        }
      }
      return {'passed': true, 'skipped': false, 'message': message};
    } catch (e) {
      return {'passed': false, 'skipped': false, 'message': 'JSON error: $e'};
    }
  }

  // ── Workflow runner ───────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> _runWorkflowStep(
      Map<String, dynamic> step, Map<String, dynamic> ctx) async {
    var url = step['url'] as String? ?? '';
    var body = step['body'] as String?;

    // Replace {{varName}} placeholders from previous step extractions
    ctx.forEach((k, v) {
      url = url.replaceAll('{{$k}}', v.toString());
      if (body != null) body = body!.replaceAll('{{$k}}', v.toString());
    });

    final updatedStep = Map<String, dynamic>.from(step)
      ..['url'] = url
      ..['body'] = body;

    final result = await _runSingleTest(updatedStep);
    return {'step': step, ...result};
  }

  static void _extractVariables(Map<String, dynamic> result,
      Map<String, dynamic> step, Map<String, dynamic> ctx) {
    final extractVars =
        (step['extractVars'] as Map?)?.cast<String, String>() ?? {};
    if (extractVars.isEmpty) return;

    try {
      final parsed = jsonDecode(result['body'] as String? ?? '');
      extractVars.forEach((varName, jsonPath) {
        final value = _extractPath(parsed, jsonPath);
        if (value != null) ctx[varName] = value;
      });
    } catch (_) {}
  }

  // Minimal $.field.nested JSONPath extractor
  static dynamic _extractPath(dynamic data, String path) {
    if (!path.startsWith(r'$.')) return null;
    final parts = path.substring(2).split('.');
    dynamic cur = data;
    for (final p in parts) {
      if (cur is Map && cur.containsKey(p)) {
        cur = cur[p];
      } else {
        return null;
      }
    }
    return cur;
  }

  static Map<String, dynamic> _err(String msg) => {
        'isError': true,
        'content': [
          {'type': 'text', 'text': msg}
        ],
      };
}