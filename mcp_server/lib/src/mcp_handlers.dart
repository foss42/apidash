import 'dart:convert';
import 'package:http/http.dart' as http;

// ─── Tool Manifest ────────────────────────────────────────────────────────────

Map<String, dynamic> mcpManifest() => {
      'schema_version': '1.0',
      'name': 'apidash',
      'description': 'Agentic API testing tools powered by API Dash',
      'tools': [
        {
          'name': 'generate_unit_tests',
          'description':
              'Generate AI-powered test cases for an API endpoint and return an interactive HTML checklist.',
          'parameters': {
            'type': 'object',
            'properties': {
              'url': {'type': 'string', 'description': 'Full endpoint URL'},
              'method': {
                'type': 'string',
                'description': 'HTTP method: GET/POST/PUT/DELETE/PATCH'
              },
              'headers': {
                'type': 'object',
                'description': 'Request headers as key-value pairs'
              },
              'body': {
                'type': 'string',
                'description': 'Request body (optional)'
              },
              'gemini_api_key': {'type': 'string', 'description': 'Gemini API key'},
            },
            'required': ['url', 'method', 'gemini_api_key'],
          },
        },
        {
          'name': 'run_selected_tests',
          'description':
              'Execute selected test cases against live endpoints and return an HTML results dashboard.',
          'parameters': {
            'type': 'object',
            'properties': {
              'test_cases': {
                'type': 'array',
                'description': 'Array of test case objects with isSelected flags',
                'items': {'type': 'object'},
              },
            },
            'required': ['test_cases'],
          },
        },
        {
          'name': 'generate_workflow_plan',
          'description':
              'Generate a multi-step API workflow plan as an interactive HTML checklist.',
          'parameters': {
            'type': 'object',
            'properties': {
              'requests': {
                'type': 'array',
                'description': 'Array of request objects with url, method, headers, body',
                'items': {'type': 'object'},
              },
              'gemini_api_key': {'type': 'string'},
            },
            'required': ['requests', 'gemini_api_key'],
          },
        },
        {
          'name': 'execute_workflow',
          'description': 'Execute workflow steps sequentially and return HTML results.',
          'parameters': {
            'type': 'object',
            'properties': {
              'steps': {
                'type': 'array',
                'description': 'Array of workflow step objects',
                'items': {'type': 'object'},
              },
            },
            'required': ['steps'],
          },
        },
      ],
    };

// ─── Dispatcher ───────────────────────────────────────────────────────────────

Future<Map<String, dynamic>> dispatchTool(
  String toolName,
  Map<String, dynamic> args,
) async {
  switch (toolName) {
    case 'generate_unit_tests':
      return _generateUnitTests(args);
    case 'run_selected_tests':
      return _runSelectedTests(args);
    case 'generate_workflow_plan':
      return _generateWorkflowPlan(args);
    case 'execute_workflow':
      return _executeWorkflow(args);
    default:
      throw ArgumentError('Unknown tool: $toolName');
  }
}

// ─── Tool Handlers ────────────────────────────────────────────────────────────

Future<Map<String, dynamic>> _generateUnitTests(
    Map<String, dynamic> args) async {
  final url = args['url'] as String;
  final method = (args['method'] as String).toUpperCase();
  final headers = (args['headers'] as Map<String, dynamic>? ?? {})
      .map((k, v) => MapEntry(k, v.toString()));
  final body = args['body'] as String?;
  final apiKey = args['gemini_api_key'] as String;

  final prompt = '''
You are an expert API test engineer. Generate comprehensive test cases for this API endpoint.

Endpoint: $method $url
Headers: ${jsonEncode(headers)}
${body != null ? 'Body: $body' : ''}

Generate exactly 6 test cases covering:
1. Happy path (successful response)
2. Missing required fields
3. Invalid data types
4. Boundary values  
5. Authentication/authorization
6. Performance/timeout

Return ONLY valid JSON array, no markdown, no explanation:
[
  {
    "id": "tc_1",
    "description": "...",
    "category": "happy_path",
    "method": "$method",
    "url": "$url",
    "headers": {},
    "body": null,
    "assertions": [
      {"type": "status_code", "expected": "200"},
      {"type": "response_time_ms", "expected": "2000"}
    ]
  }
]

Categories must be one of: happy_path, edge_case, security, performance
Assertion types: status_code, response_time_ms, body_contains, body_not_contains, header_exists
''';

  final testCases = await _callGemini(apiKey, prompt);
  final html = _buildTestChecklistHtml(testCases, url, method);

  return {
    'content_type': 'text/html',
    'html': html,
    'test_cases_json': jsonEncode(testCases),
  };
}

Future<Map<String, dynamic>> _runSelectedTests(
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

  // Include skipped ones too
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

  final html = _buildTestResultsHtml(results);
  return {
    'content_type': 'text/html',
    'html': html,
    'results_json': jsonEncode(results),
  };
}

Future<Map<String, dynamic>> _generateWorkflowPlan(
    Map<String, dynamic> args) async {
  final requests = (args['requests'] as List<dynamic>)
      .map((r) => r as Map<String, dynamic>)
      .toList();
  final apiKey = args['gemini_api_key'] as String;

  final requestsSummary = requests.asMap().entries.map((e) {
    final r = e.value;
    return 'Step ${e.key + 1}: ${r['method']} ${r['url']}';
  }).join('\n');

  final prompt = '''
You are an API workflow expert. Create a sequential workflow plan for these API calls:

$requestsSummary

For each step generate assertions and data extractions (variables from response to pass to next step).
Return ONLY valid JSON array:
[
  {
    "stepId": "step_1",
    "name": "...",
    "method": "GET",
    "url": "...",
    "headers": {},
    "body": null,
    "assertions": [
      {"type": "status_code", "expected": "200"}
    ],
    "dataExtractions": [
      {"variableName": "userId", "jsonPath": "\$.id", "description": "Extract user ID"}
    ],
    "dependsOn": []
  }
]
Return ONLY JSON, no markdown.
''';

  final steps = await _callGemini(apiKey, prompt);
  final html = _buildWorkflowPlanHtml(steps);

  return {
    'content_type': 'text/html',
    'html': html,
    'steps_json': jsonEncode(steps),
  };
}

Future<Map<String, dynamic>> _executeWorkflow(
    Map<String, dynamic> args) async {
  final steps = (args['steps'] as List<dynamic>)
      .map((s) => s as Map<String, dynamic>)
      .toList();

  final results = <Map<String, dynamic>>[];
  final extractedVars = <String, dynamic>{};

  for (final step in steps) {
    final result = await _executeWorkflowStep(step, extractedVars);
    results.add(result);

    // Extract variables for next steps
    final extractions =
        (step['dataExtractions'] as List<dynamic>? ?? []);
    if (result['overallStatus'] == 'passed') {
      try {
        final body = jsonDecode(result['actualBody'] as String? ?? '{}');
        for (final ex in extractions) {
          final varName = ex['variableName'] as String;
          final path = ex['jsonPath'] as String;
          extractedVars[varName] = _extractJsonPath(body, path);
        }
      } catch (_) {}
    }
  }

  final html = _buildWorkflowResultsHtml(results);
  return {'content_type': 'text/html', 'html': html};
}

// ─── Gemini Caller ────────────────────────────────────────────────────────────

Future<List<dynamic>> _callGemini(String apiKey, String prompt) async {
  final uri = Uri.parse(
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent?key=$apiKey',
  );

  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ],
      'generationConfig': {'temperature': 0.3},
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Gemini error ${response.statusCode}: ${response.body}');
  }

  final data = jsonDecode(response.body) as Map<String, dynamic>;
  final text = data['candidates'][0]['content']['parts'][0]['text'] as String;

  // Strip markdown code fences if present
  final cleaned = text
      .replaceAll(RegExp(r'```json\s*'), '')
      .replaceAll(RegExp(r'```\s*'), '')
      .trim();

  return jsonDecode(cleaned) as List<dynamic>;
}

// ─── HTTP Test Executor ───────────────────────────────────────────────────────

Future<Map<String, dynamic>> _executeTestCase(
    Map<String, dynamic> tc) async {
  final url = tc['url'] as String;
  final method = (tc['method'] as String).toUpperCase();
  final headers = (tc['headers'] as Map<String, dynamic>? ?? {})
      .map((k, v) => MapEntry(k, v.toString()));
  final body = tc['body'];
  final assertions =
      (tc['assertions'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();

  final stopwatch = Stopwatch()..start();
  int statusCode = 0;
  String responseBody = '';
  Map<String, String> responseHeaders = {};
  String? errorMessage;

  try {
    final uri = Uri.parse(url);
    http.Response response;

    final reqHeaders = <String, String>{
      'Content-Type': 'application/json',
      ...headers,
    };

    switch (method) {
      case 'GET':
        response = await http.get(uri, headers: reqHeaders);
      case 'POST':
        response = await http.post(uri,
            headers: reqHeaders,
            body: body != null ? jsonEncode(body) : null);
      case 'PUT':
        response = await http.put(uri,
            headers: reqHeaders,
            body: body != null ? jsonEncode(body) : null);
      case 'PATCH':
        response = await http.patch(uri,
            headers: reqHeaders,
            body: body != null ? jsonEncode(body) : null);
      case 'DELETE':
        response = await http.delete(uri, headers: reqHeaders);
      default:
        response = await http.get(uri, headers: reqHeaders);
    }

    statusCode = response.statusCode;
    responseBody = response.body;
    responseHeaders = response.headers;
  } catch (e) {
    errorMessage = e.toString();
  } finally {
    stopwatch.stop();
  }

  final durationMs = stopwatch.elapsedMilliseconds;

  // Evaluate assertions
  final assertionResults = <Map<String, dynamic>>[];
  var allPassed = true;

  for (final assertion in assertions) {
    final type = assertion['type'] as String;
    final expected = assertion['expected']?.toString() ?? '';
    bool passed = false;
    String message = '';

    switch (type) {
      case 'status_code':
        passed = statusCode == int.tryParse(expected);
        message = passed
            ? 'Status code is $statusCode ✓'
            : 'Expected status $expected, got $statusCode';
      case 'response_time_ms':
        final maxMs = int.tryParse(expected) ?? 5000;
        passed = durationMs <= maxMs;
        message = passed
            ? 'Response time ${durationMs}ms ≤ ${maxMs}ms ✓'
            : 'Response time ${durationMs}ms > ${maxMs}ms (too slow)';
      case 'body_contains':
        passed = responseBody.contains(expected);
        message = passed
            ? 'Body contains "$expected" ✓'
            : 'Body does not contain "$expected"';
      case 'body_not_contains':
        passed = !responseBody.contains(expected);
        message = passed
            ? 'Body does not contain "$expected" ✓'
            : 'Body unexpectedly contains "$expected"';
      case 'header_exists':
        passed = responseHeaders.containsKey(expected.toLowerCase());
        message = passed
            ? 'Header "$expected" exists ✓'
            : 'Header "$expected" not found';
      default:
        passed = true;
        message = 'Unknown assertion type: $type (skipped)';
    }

    if (!passed) allPassed = false;
    assertionResults.add({
      'type': type,
      'passed': passed,
      'message': message,
      'skipped': false,
    });
  }

  if (errorMessage != null) allPassed = false;

  return {
    'testCase': tc,
    'overallStatus': errorMessage != null
        ? 'failed'
        : (allPassed ? 'passed' : 'failed'),
    'actualStatusCode': statusCode,
    'actualBody': responseBody,
    'durationMs': durationMs,
    'assertionResults': assertionResults,
    if (errorMessage != null) 'errorMessage': errorMessage,
  };
}

Future<Map<String, dynamic>> _executeWorkflowStep(
    Map<String, dynamic> step,
    Map<String, dynamic> extractedVars) async {
  // Substitute variables like ${userId} in url and body
  var url = step['url'] as String;
  var body = step['body']?.toString();

  for (final entry in extractedVars.entries) {
    url = url.replaceAll('\${${entry.key}}', entry.value.toString());
    body = body?.replaceAll('\${${entry.key}}', entry.value.toString());
  }

  final modified = Map<String, dynamic>.from(step)
    ..['url'] = url
    ..['body'] = body;

  return _executeTestCase(modified);
}

// ─── JSON Path Extractor ──────────────────────────────────────────────────────

dynamic _extractJsonPath(dynamic data, String path) {
  // Simple dot-notation extractor: $.key.nested
  final parts = path.replaceFirst(r'$.', '').split('.');
  dynamic current = data;
  for (final part in parts) {
    if (current is Map) {
      current = current[part];
    } else if (current is List) {
      final idx = int.tryParse(part);
      if (idx != null && idx < current.length) {
        current = current[idx];
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
  return current;
}

// ─── HTML Builders ────────────────────────────────────────────────────────────

String _esc(String s) => s
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');

String _escJson(dynamic obj) =>
    jsonEncode(obj).replaceAll('</script>', '<\\/script>');

const _baseStyle = '''
<style>
:root{--bg:#f7f6f2;--surface:#fff;--border:#dcd9d5;--text:#28251d;
--muted:#7a7974;--primary:#01696f;--primary-h:#0c4e54;
--success:#437a22;--error:#a12c7b;--skip:#7a7974;--r:8px;
--font:'Inter',system-ui,sans-serif}
*{box-sizing:border-box;margin:0;padding:0}
body{font-family:var(--font);background:var(--bg);color:var(--text);
font-size:14px;padding:20px}
table{width:100%;border-collapse:collapse;background:var(--surface);
border-radius:var(--r);overflow:hidden;box-shadow:0 1px 4px rgba(0,0,0,.06)}
th{text-align:left;padding:10px 12px;font-size:11px;font-weight:600;
text-transform:uppercase;letter-spacing:.05em;color:var(--muted);
background:var(--bg);border-bottom:1px solid var(--border)}
td{padding:10px 12px;border-bottom:1px solid var(--border);vertical-align:middle}
tr:last-child td{border-bottom:none}
tr:not(.dr):hover td{background:#f9f8f5}
button{padding:8px 16px;border-radius:var(--r);border:none;cursor:pointer;
font-size:13px;font-weight:500;transition:background 150ms}
.btn-p{background:var(--primary);color:#fff}
.btn-p:hover{background:var(--primary-h)}
.btn-s{background:var(--surface);color:var(--text);border:1px solid var(--border)}
.bar{display:flex;gap:8px;align-items:center;margin-bottom:12px;flex-wrap:wrap}
.cnt{font-size:13px;color:var(--muted);margin-left:auto}
.badge{display:inline-flex;padding:2px 8px;border-radius:99px;font-size:11px;font-weight:500}
.badge-happy_path{background:#d4dfcc;color:#1e3f0a}
.badge-edge_case{background:#e9e0c6;color:#8a5b00}
.badge-security{background:#e0ced7;color:#561740}
.badge-performance{background:#c6d8e4;color:#0b3751}
.stat{padding:12px 20px;border-radius:var(--r);background:var(--surface);
border:1px solid var(--border);font-weight:600;font-size:15px;min-width:80px}
.sl{font-size:11px;font-weight:400;color:var(--muted);display:block}
.sp{color:var(--success)}.sf{color:var(--error)}.sk{color:var(--skip)}
.ap{color:var(--success)}.af{color:var(--error)}.ask{color:var(--skip)}
.db{padding:8px 0}
.ar{font-size:12px;padding:3px 8px}
.em{color:var(--error);font-size:12px;padding:3px 8px}
.msg{padding:12px 16px;border-radius:var(--r);font-size:13px;
margin-top:16px;display:none}
.ml{background:#cedcd8;color:var(--primary);border:1px solid var(--primary)}
.me{background:#f9e8f1;color:var(--error);border:1px solid #e0ced7}
h1{font-size:18px;margin-bottom:6px}
.sub{color:var(--muted);font-size:13px;margin-bottom:20px}
.sum{display:flex;gap:12px;margin-bottom:20px;flex-wrap:wrap}
.sc{padding:10px 12px;border-bottom:1px solid var(--border)}
.mon{font-family:monospace;font-size:12px}
</style>''';

String _buildTestChecklistHtml(
    List<dynamic> cases, String url, String method) {
  final casesJson = _escJson(cases);
  final rows = cases.asMap().entries.map((e) {
    final i = e.key;
    final tc = e.value as Map<String, dynamic>;
    final cat = tc['category']?.toString() ?? 'edge_case';
    final desc = _esc(tc['description']?.toString() ?? '');
    final m = _esc(tc['method']?.toString() ?? method);
    final u = _esc(tc['url']?.toString() ?? url);
    final assertions = (tc['assertions'] as List<dynamic>? ?? [])
        .map((a) => '${a['type']}: ${a['expected']}')
        .join(', ');
    return '''<tr>
<td><input type="checkbox" id="c$i" checked onchange="upd()"></td>
<td><label for="c$i">$desc</label></td>
<td><span class="badge badge-$cat">$cat</span></td>
<td class="mon" style="color:var(--primary);font-weight:700">$m</td>
<td class="mon" style="max-width:180px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">$u</td>
<td style="font-size:11px;color:var(--muted);max-width:160px">${_esc(assertions)}</td>
</tr>''';
  }).join('\n');

  return '''<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>API Dash — Test Cases</title>$_baseStyle</head><body>
<h1>🧪 API Dash — Generated Test Cases</h1>
<div class="sub">Review and select which tests to run</div>
<div class="bar">
<button class="btn-s" onclick="sel(true)">☑ All</button>
<button class="btn-s" onclick="sel(false)">□ None</button>
<button class="btn-p" onclick="run()">⚡ Run Selected</button>
<span class="cnt" id="cl">${cases.length} of ${cases.length} selected</span>
</div>
<table>
<thead><tr><th></th><th>Description</th><th>Category</th><th>Method</th><th>URL</th><th>Assertions</th></tr></thead>
<tbody>$rows</tbody>
</table>
<div id="msg" class="msg"></div>
<script>
const D=$casesJson;
function upd(){const b=document.querySelectorAll('input[type=checkbox]');
document.getElementById('cl').textContent=[...b].filter(x=>x.checked).length+' of '+b.length+' selected'}
function sel(v){document.querySelectorAll('input[type=checkbox]').forEach(b=>b.checked=v);upd()}
async function run(){
const b=document.querySelectorAll('input[type=checkbox]');
const sel=D.map((tc,i)=>({...tc,isSelected:b[i]?.checked??false}));
const m=document.getElementById('msg');
m.className='msg ml';m.style.display='block';m.textContent='⏳ Running selected tests...';
try{const r=await fetch('http://localhost:3000/mcp/call',{method:'POST',
headers:{'Content-Type':'application/json'},
body:JSON.stringify({tool:'run_selected_tests',arguments:{test_cases:sel}})});
const d=await r.json();
if(d.result?.html){document.open();document.write(d.result.html);document.close();}
else throw new Error(d.error??'No HTML in response');}
catch(e){m.className='msg me';m.textContent='❌ '+e.message;}}
</script></body></html>''';
}

String _buildTestResultsHtml(List<Map<String, dynamic>> results) {
  final passed = results.where((r) => r['overallStatus'] == 'passed').length;
  final failed = results.where((r) => r['overallStatus'] == 'failed').length;
  final skipped = results.where((r) => r['overallStatus'] == 'skipped').length;
  final totalMs =
      results.fold<int>(0, (s, r) => s + (r['durationMs'] as int? ?? 0));

  final rows = results.map((r) {
    final status = r['overallStatus'] as String;
    final icon = status == 'passed' ? '✅' : status == 'failed' ? '❌' : '⏭️';
    final sc = r['actualStatusCode'] as int? ?? 0;
    final ms = r['durationMs'] as int? ?? 0;
    final tc = r['testCase'] as Map<String, dynamic>;
    final desc = _esc(tc['description']?.toString() ?? '');
    final ars = (r['assertionResults'] as List<dynamic>? ?? []);
    final errMsg = r['errorMessage'] as String?;

    final arRows = ars.map((ar) {
      final a = ar as Map<String, dynamic>;
      final aIcon = a['skipped'] == true ? '⏭️' : (a['passed'] == true ? '✓' : '✗');
      final cls = a['skipped'] == true ? 'ask' : (a['passed'] == true ? 'ap' : 'af');
      return '<div class="ar $cls">$aIcon ${_esc(a['message']?.toString() ?? '')}</div>';
    }).join('');

    return '''<tr onclick="tog(this)" style="cursor:pointer">
<td>$icon</td>
<td>$desc</td>
<td class="mon" style="color:${status == 'passed' ? 'var(--success)' : status == 'failed' ? 'var(--error)' : 'var(--muted)'};font-weight:600">${sc > 0 ? sc : '—'}</td>
<td>${ms > 0 ? '${ms}ms' : '—'}</td>
</tr>
<tr class="dr" style="display:none"><td colspan="4"><div class="db">
$arRows
${errMsg != null ? '<div class="em">⚠️ ${_esc(errMsg)}</div>' : ''}
${ars.isEmpty && errMsg == null ? '<span style="color:var(--muted);font-size:12px">No assertions</span>' : ''}
</div></td></tr>''';
  }).join('\n');

  return '''<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>API Dash — Results</title>$_baseStyle</head><body>
<h1>🧪 API Dash — Test Results</h1>
<div class="sub">Click any row to expand assertion details</div>
<div class="sum">
<div class="stat"><span class="sp">$passed</span><span class="sl">Passed</span></div>
<div class="stat"><span class="sf">$failed</span><span class="sl">Failed</span></div>
<div class="stat"><span class="sk">$skipped</span><span class="sl">Skipped</span></div>
<div class="stat">${totalMs}ms<span class="sl">Total</span></div>
</div>
<table><thead><tr><th></th><th>Test Case</th><th>Status</th><th>Duration</th></tr></thead>
<tbody>$rows</tbody></table>
<script>function tog(r){const n=r.nextElementSibling;if(n?.classList.contains('dr'))n.style.display=n.style.display==='none'?'table-row':'none'}</script>
</body></html>''';
}

String _buildWorkflowPlanHtml(List<dynamic> steps) {
  final stepsJson = _escJson(steps);
  final totalA = steps.fold<int>(
      0,
      (s, step) =>
          s + ((step['assertions'] as List<dynamic>? ?? []).length));

  final cards = steps.asMap().entries.map((e) {
    final si = e.key;
    final step = e.value as Map<String, dynamic>;
    final assertions = (step['assertions'] as List<dynamic>? ?? []);
    final extractions = (step['dataExtractions'] as List<dynamic>? ?? []);

    final aRows = assertions.asMap().entries.map((ae) {
      final ai = ae.key;
      final a = ae.value as Map<String, dynamic>;
      return '''<div style="display:flex;align-items:center;gap:8px;font-size:13px;padding:2px 0">
<input type="checkbox" id="a${si}_$ai" checked onchange="upd()">
<label for="a${si}_$ai">${_esc(a['type']?.toString() ?? '')}: ${_esc(a['expected']?.toString() ?? '')}</label>
</div>''';
    }).join('');

    final exRows = extractions.map((ex) {
      final x = ex as Map<String, dynamic>;
      return '<div style="font-size:12px;color:var(--muted);padding:2px 0">📤 ${_esc(x['variableName']?.toString() ?? '')} = ${_esc(x['jsonPath']?.toString() ?? '')}</div>';
    }).join('');

    return '''<div style="background:var(--surface);border:1px solid var(--border);border-radius:var(--r);margin-bottom:12px;overflow:hidden">
<div style="display:flex;align-items:center;gap:10px;padding:10px 14px;background:var(--bg);border-bottom:1px solid var(--border)">
<span style="font-size:11px;font-weight:700;color:var(--muted)">STEP ${si + 1}</span>
<span class="mon" style="font-weight:700;color:var(--primary)">${_esc(step['method']?.toString() ?? '')}</span>
<span class="mon" style="color:var(--muted)">${_esc(step['url']?.toString() ?? '')}</span>
</div>
<div style="padding:10px 14px">$aRows$exRows</div>
</div>''';
  }).join('\n');

  return '''<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><title>API Dash — Workflow Plan</title>$_baseStyle</head><body>
<h1>🔗 API Dash — Workflow Plan</h1>
<div class="sub">Review assertions, then execute</div>
<div class="bar">
<button class="btn-p" onclick="exec()">⚡ Execute Workflow</button>
<span class="cnt" id="cl">$totalA of $totalA assertions selected</span>
</div>
$cards
<div id="msg" class="msg"></div>
<script>
const D=$stepsJson;
function upd(){const b=document.querySelectorAll('input[type=checkbox]');
document.getElementById('cl').textContent=[...b].filter(x=>x.checked).length+' of '+b.length+' assertions selected'}
async function exec(){
const steps=D.map((s,si)=>({...s,assertions:(s.assertions||[]).map((a,ai)=>({...a,isSelected:document.getElementById('a'+si+'_'+ai)?.checked??false}))}));
const m=document.getElementById('msg');
m.className='msg ml';m.style.display='block';m.textContent='⏳ Executing workflow...';
try{const r=await fetch('http://localhost:3000/mcp/call',{method:'POST',
headers:{'Content-Type':'application/json'},
body:JSON.stringify({tool:'execute_workflow',arguments:{steps}})});
const d=await r.json();
if(d.result?.html){document.open();document.write(d.result.html);document.close();}
else throw new Error(d.error??'No HTML');}
catch(e){m.className='msg me';m.textContent='❌ '+e.message;}}
</script></body></html>''';
}

String _buildWorkflowResultsHtml(List<Map<String, dynamic>> results) {
  final passed = results.where((r) => r['overallStatus'] == 'passed').length;
  final failed = results.where((r) => r['overallStatus'] == 'failed').length;
  final totalMs =
      results.fold<int>(0, (s, r) => s + (r['durationMs'] as int? ?? 0));

  final cards = results.asMap().entries.map((e) {
    final i = e.key;
    final r = e.value;
    final status = r['overallStatus'] as String;
    final icon = status == 'passed' ? '✅' : '❌';
    final step = r['testCase'] as Map<String, dynamic>;
    final ars = (r['assertionResults'] as List<dynamic>? ?? []);
    final errMsg = r['errorMessage'] as String?;

    final arRows = ars.map((ar) {
      final a = ar as Map<String, dynamic>;
      final aIcon = a['passed'] == true ? '✓' : '✗';
      final cls = a['passed'] == true ? 'ap' : 'af';
      return '<div class="ar $cls">$aIcon ${_esc(a['message']?.toString() ?? '')}</div>';
    }).join('');

    return '''<div style="background:var(--surface);border:1px solid var(--border);border-radius:var(--r);margin-bottom:12px;overflow:hidden">
<div style="display:flex;justify-content:space-between;align-items:center;padding:10px 14px;background:var(--bg);border-bottom:1px solid var(--border);font-weight:500">
<span>$icon Step ${i + 1} — ${_esc(step['method']?.toString() ?? '')} ${_esc(step['url']?.toString() ?? '')}</span>
<span class="mon" style="color:var(--muted)">${r['actualStatusCode']} • ${r['durationMs']}ms</span>
</div>
<div style="padding:10px 14px">$arRows
${errMsg != null ? '<div class="em">⚠️ ${_esc(errMsg)}</div>' : ''}</div>
</div>''';
  }).join('\n');

  return '''<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><title>API Dash — Workflow Results</title>$_baseStyle</head><body>
<h1>🔗 API Dash — Workflow Results</h1>
<div class="sub">Sequential execution results</div>
<div class="sum">
<div class="stat"><span class="sp">$passed</span><span class="sl">Passed</span></div>
<div class="stat"><span class="sf">$failed</span><span class="sl">Failed</span></div>
<div class="stat">${totalMs}ms<span class="sl">Total</span></div>
</div>
$cards
</body></html>''';
}