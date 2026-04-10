import 'dart:convert';

const _mime = 'text/html;profile=mcp-app';
const _baseUri = 'ui://apidash-mcp';

/// Stores live data between tool call and resources/read.
/// In a real deployment use session-scoped storage.
class McpResources {
  static List<Map<String, dynamic>> _testCases    = [];
  static List<Map<String, dynamic>> _testResults  = [];
  static List<Map<String, dynamic>> _workflowSteps = [];
  static List<Map<String, dynamic>> _workflowResults = [];

  static void setTestCases(List<Map<String, dynamic>> v)      => _testCases = v;
  static void setTestResults(List<Map<String, dynamic>> v)    => _testResults = v;
  static void setWorkflowSteps(List<Map<String, dynamic>> v)  => _workflowSteps = v;
  static void setWorkflowResults(List<Map<String, dynamic>> v) => _workflowResults = v;

  // ── resources/list ────────────────────────────────────────────────────────
  static List<Map<String, dynamic>> list() => [
    {'uri': '$_baseUri/test-checklist-ui',   'mimeType': _mime, 'name': 'Test Checklist',    'description': 'Interactive test case selection UI'},
    {'uri': '$_baseUri/test-results-ui',     'mimeType': _mime, 'name': 'Test Results',       'description': 'Test execution results dashboard'},
    {'uri': '$_baseUri/workflow-plan-ui',    'mimeType': _mime, 'name': 'Workflow Plan',       'description': 'Multi-step workflow assertion selector'},
    {'uri': '$_baseUri/workflow-results-ui', 'mimeType': _mime, 'name': 'Workflow Results',   'description': 'Workflow execution results'},
  ];

  // ── resources/read ────────────────────────────────────────────────────────
  static Map<String, dynamic> read(String uri) {
    final html = switch (uri) {
      '$_baseUri/test-checklist-ui'   => _testChecklistHtml(_testCases),
      '$_baseUri/test-results-ui'     => _testResultsHtml(_testResults),
      '$_baseUri/workflow-plan-ui'    => _workflowPlanHtml(_workflowSteps),
      '$_baseUri/workflow-results-ui' => _workflowResultsHtml(_workflowResults),
      _ => throw ArgumentError('Unknown resource URI: $uri'),
    };

    return {
      'contents': [
        {'uri': uri, 'mimeType': _mime, 'text': html},
      ],
    };
  }

  // ── HTML Builders ─────────────────────────────────────────────────────────

  static String _testChecklistHtml(List<Map<String, dynamic>> cases) {
    final casesJson = _safeJson(cases);
    final rows = cases.asMap().entries.map((e) {
      final i = e.key; final tc = e.value;
      return '''<tr>
        <td><input type="checkbox" id="c$i" checked onchange="upd()"></td>
        <td><label for="c$i">${_e(tc['description'] ?? '')}</label></td>
        <td><span class="badge badge-${tc['category']}">${tc['category']}</span></td>
        <td class="mono primary">${_e(tc['method'] ?? '')}</td>
        <td class="mono url">${_e(tc['url'] ?? '')}</td>
      </tr>''';
    }).join();

    return _page('🧪 Test Cases — API Dash', '''
<div class="bar">
  <button class="btn-s" onclick="sel(true)">☑ All</button>
  <button class="btn-s" onclick="sel(false)">□ None</button>
  <button class="btn-p" onclick="run()">⚡ Run Selected</button>
  <span class="count" id="cl">${cases.length} of ${cases.length} selected</span>
</div>
<table><thead><tr><th></th><th>Description</th><th>Category</th><th>Method</th><th>URL</th></tr></thead>
<tbody>$rows</tbody></table>
<div id="msg" class="msg"></div>
<script>
const D = $casesJson;
function upd(){const b=document.querySelectorAll("input[type=checkbox]");document.getElementById("cl").textContent=[...b].filter(x=>x.checked).length+" of "+b.length+" selected"}
function sel(v){document.querySelectorAll("input[type=checkbox]").forEach(b=>b.checked=v);upd()}
async function run(){
  const b=document.querySelectorAll("input[type=checkbox]");
  const sel=D.map((tc,i)=>({...tc,isSelected:b[i]?.checked??false}));
  const m=document.getElementById("msg");
  m.className="msg ml";m.style.display="block";m.textContent="⏳ Running...";
  try{
    // MCP Apps: call tool via postMessage to host
    const result = await sendMcpToolCall("run_selected_tests",{test_cases:sel});
    m.className="msg ms";m.textContent="✅ Done! Results loading...";
  }catch(e){m.className="msg me";m.textContent="❌ "+e.message;}
}
// MCP Apps postMessage bridge
function sendMcpToolCall(name,args){
  return new Promise((res,rej)=>{
    const id=Date.now();
    const handler=e=>{
      if(e.data?.id===id){window.removeEventListener("message",handler);
        if(e.data.error)rej(new Error(e.data.error.message));else res(e.data.result);}
    };
    window.addEventListener("message",handler);
    window.parent.postMessage({jsonrpc:"2.0",id,method:"tools/call",params:{name,arguments:args}},"*");
  });
}
</script>''');
  }

  static String _testResultsHtml(List<Map<String, dynamic>> results) {
    final passed  = results.where((r) => r['overallStatus'] == 'passed').length;
    final failed  = results.where((r) => r['overallStatus'] == 'failed').length;
    final skipped = results.where((r) => r['overallStatus'] == 'skipped').length;

    final rows = results.map((r) {
      final status = r['overallStatus'] as String;
      final icon   = status == 'passed' ? '✅' : status == 'failed' ? '❌' : '⏭️';
      final code   = r['actualStatusCode'] ?? 0;
      final ms     = r['durationMs'] ?? 0;
      final tc     = r['testCase'] as Map<String, dynamic>? ?? {};

      final arRows = (r['assertionResults'] as List<dynamic>? ?? []).map((ar) {
        final pass = ar['passed'] == true;
        final skip = ar['skipped'] == true;
        return '<div class="${skip ? "as" : pass ? "ap" : "af"}">'
               '${skip ? "⏭" : pass ? "✓" : "✗"} ${_e(ar["message"] ?? "")}</div>';
      }).join();

      return '''<tr onclick="tog(this)">
        <td>$icon</td>
        <td>${_e(tc['description'] ?? '')}</td>
        <td class="${status == 'passed' ? 'sp' : status == 'failed' ? 'sf' : 'sk'}">${code > 0 ? code : '—'}</td>
        <td>${ms > 0 ? '${ms}ms' : '—'}</td>
      </tr>
      <tr class="dr" style="display:none"><td colspan="4">
        <div class="db">$arRows${r['errorMessage'] != null ? '<div class="em">⚠️ ${_e(r['errorMessage']!)}</div>' : ''}</div>
      </td></tr>''';
    }).join();

    return _page('🧪 Test Results — API Dash', '''
<div class="sum">
  <div class="stat"><span class="sp">$passed</span><span class="sl">Passed</span></div>
  <div class="stat"><span class="sf">$failed</span><span class="sl">Failed</span></div>
  <div class="stat"><span class="sk">$skipped</span><span class="sl">Skipped</span></div>
</div>
<p class="sub">Click any row for assertion details</p>
<table><thead><tr><th></th><th>Test</th><th>Status</th><th>Time</th></tr></thead>
<tbody>$rows</tbody></table>
<script>function tog(r){const n=r.nextElementSibling;if(n?.classList.contains("dr"))n.style.display=n.style.display==="none"?"table-row":"none";}</script>''');
  }

  static String _workflowPlanHtml(List<Map<String, dynamic>> steps) {
    final stepsJson = _safeJson(steps);
    final cards = steps.asMap().entries.map((e) {
      final si = e.key; final step = e.value;
      final assertions = (step['assertions'] as List<dynamic>? ?? []).asMap().entries.map((ae) {
        final ai = ae.key; final a = ae.value;
        return '<div class="ar"><input type="checkbox" id="a${si}_$ai" checked onchange="upd()"> '
               '<label for="a${si}_$ai">${_e(a['type'] ?? '')}: ${_e(a['expected']?.toString() ?? '')}</label></div>';
      }).join();

      return '''<div class="card">
        <div class="ch"><span class="sn">STEP ${si+1}</span>
        <span class="sm">${_e(step['method'] ?? '')}</span>
        <span class="su">${_e(step['url'] ?? '')}</span></div>
        <div class="cb">$assertions</div>
      </div>''';
    }).join();

    return _page('🔗 Workflow Plan — API Dash', '''
<div class="bar">
  <button class="btn-p" onclick="exec()">⚡ Execute Workflow</button>
  <span class="count" id="cl">Assertions selected</span>
</div>
$cards
<div id="msg" class="msg"></div>
<script>
const S = $stepsJson;
function upd(){const b=document.querySelectorAll("input[type=checkbox]");document.getElementById("cl").textContent=[...b].filter(x=>x.checked).length+" of "+b.length+" assertions";}
async function exec(){
  const steps=S.map((step,si)=>({...step,assertions:step.assertions.map((a,ai)=>({...a,isSelected:document.getElementById("a"+si+"_"+ai)?.checked??false}))}));
  const m=document.getElementById("msg");m.className="msg ml";m.style.display="block";m.textContent="⏳ Executing...";
  try{
    const result=await sendMcpToolCall("execute_workflow",{steps});
    m.className="msg ms";m.textContent="✅ Done!";
  }catch(e){m.className="msg me";m.textContent="❌ "+e.message;}
}
function sendMcpToolCall(name,args){
  return new Promise((res,rej)=>{
    const id=Date.now();
    const handler=e=>{if(e.data?.id===id){window.removeEventListener("message",handler);if(e.data.error)rej(new Error(e.data.error.message));else res(e.data.result);}};
    window.addEventListener("message",handler);
    window.parent.postMessage({jsonrpc:"2.0",id,method:"tools/call",params:{name,arguments:args}},"*");
  });
}
window.addEventListener("message",e=>{if(e.data?.method==="ui/notifications/tool-input"){const d=e.data.params?.structuredContent;if(d?.steps)location.reload();}});
upd();
</script>''');
  }

  static String _workflowResultsHtml(List<Map<String, dynamic>> results) {
    final passed = results.where((r) => r['overallStatus'] == 'passed').length;
    final failed = results.where((r) => r['overallStatus'] == 'failed').length;

    final cards = results.asMap().entries.map((e) {
      final i = e.key; final r = e.value;
      final icon   = r['overallStatus'] == 'passed' ? '✅' : '❌';
      final step   = r['step'] as Map<String, dynamic>? ?? r['testCase'] as Map<String, dynamic>? ?? {};
      final arRows = (r['assertionResults'] as List<dynamic>? ?? []).map((ar) {
        final pass = ar['passed'] == true; final skip = ar['skipped'] == true;
        return '<div class="${skip ? "as" : pass ? "ap" : "af"}">${skip ? "⏭" : pass ? "✓" : "✗"} ${_e(ar["message"] ?? "")}</div>';
      }).join();

      return '''<div class="card">
        <div class="ch">$icon Step ${i+1} — ${_e(step['method'] ?? '')} ${_e(step['url'] ?? '')}
          <span class="sm">${r['actualStatusCode']} • ${r['durationMs']}ms</span></div>
        <div class="cb">$arRows${r['errorMessage'] != null ? '<div class="em">⚠️ ${_e(r['errorMessage']!)}</div>' : ''}</div>
      </div>''';
    }).join();

    return _page('🔗 Workflow Results — API Dash', '''
<div class="sum">
  <div class="stat"><span class="sp">$passed</span><span class="sl">Steps OK</span></div>
  <div class="stat"><span class="sf">$failed</span><span class="sl">Failed</span></div>
</div>
$cards''');
  }

  // ── Page Template ─────────────────────────────────────────────────────────

  static String _page(String title, String body) => '''<!DOCTYPE html>
<html lang="en"><head><meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>$title</title>
<style>
:root{--bg:#f7f6f2;--s:#fff;--b:#dcd9d5;--t:#28251d;--m:#7a7974;
--p:#01696f;--ph:#0c4e54;--ok:#437a22;--er:#a12c7b;--sk:#7a7974;--r:8px}
*{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Inter',system-ui,sans-serif;background:var(--bg);color:var(--t);font-size:14px;padding:20px}
h1{font-size:18px;margin-bottom:6px} .sub{color:var(--m);font-size:13px;margin-bottom:16px}
.bar{display:flex;gap:8px;align-items:center;margin-bottom:12px;flex-wrap:wrap}
.count{font-size:13px;color:var(--m);margin-left:auto}
button{padding:8px 16px;border-radius:var(--r);border:none;cursor:pointer;font-size:13px;font-weight:500}
.btn-p{background:var(--p);color:#fff}.btn-p:hover{background:var(--ph)}
.btn-s{background:var(--s);color:var(--t);border:1px solid var(--b)}
table{width:100%;border-collapse:collapse;background:var(--s);border-radius:var(--r);
overflow:hidden;box-shadow:0 1px 4px rgba(0,0,0,.06)}
th{text-align:left;padding:10px 12px;font-size:11px;font-weight:600;text-transform:uppercase;
letter-spacing:.05em;color:var(--m);background:var(--bg);border-bottom:1px solid var(--b)}
td{padding:10px 12px;border-bottom:1px solid var(--b);vertical-align:middle}
tr:last-child td{border-bottom:none} tr:not(.dr):hover td{background:#f9f8f5}
.mono{font-family:monospace;font-size:12px} .primary{color:var(--p);font-weight:700}
.url{max-width:200px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.badge{display:inline-flex;padding:2px 8px;border-radius:99px;font-size:11px;font-weight:500}
.badge-happy_path{background:#d4dfcc;color:#1e3f0a}
.badge-edge_case{background:#e9e0c6;color:#8a5b00}
.badge-security{background:#e0ced7;color:#561740}
.badge-performance{background:#c6d8e4;color:#0b3751}
.sum{display:flex;gap:12px;margin-bottom:20px;flex-wrap:wrap}
.stat{padding:12px 20px;border-radius:var(--r);background:var(--s);border:1px solid var(--b);
font-weight:600;font-size:15px;min-width:80px}
.sl{font-size:11px;font-weight:400;color:var(--m);display:block}
.sp{color:var(--ok)}.sf{color:var(--er)}.sk{color:var(--sk)}
.db{padding:8px 0} .ar{font-size:12px;padding:2px 8px}
.ap{color:var(--ok)}.af{color:var(--er)}.as{color:var(--sk)}
.em{color:var(--er);font-size:12px;padding:2px 8px}
.msg{padding:12px 16px;border-radius:var(--r);font-size:13px;margin-top:16px;display:none}
.ml{background:#cedcd8;color:var(--p);border:1px solid var(--p)}
.ms{background:#d4dfcc;color:#1e3f0a;border:1px solid #437a22}
.me{background:#f9e8f1;color:var(--er);border:1px solid #e0ced7}
.card{background:var(--s);border:1px solid var(--b);border-radius:var(--r);
margin-bottom:12px;overflow:hidden;box-shadow:0 1px 4px rgba(0,0,0,.04)}
.ch{display:flex;align-items:center;gap:10px;padding:10px 14px;
background:var(--bg);border-bottom:1px solid var(--b);font-weight:500}
.cb{padding:10px 14px;display:flex;flex-direction:column;gap:6px}
.sn{font-size:11px;font-weight:700;color:var(--m);text-transform:uppercase}
.sm{font-family:monospace;font-weight:700;color:var(--p);font-size:13px}
.su{font-family:monospace;font-size:12px;color:var(--m)}
</style></head><body>
<h1>$title</h1>
$body
</body></html>''';

  // ── Helpers ───────────────────────────────────────────────────────────────

  static String _e(String s) => s
      .replaceAll('&', '&amp;').replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;').replaceAll('"', '&quot;');

  static String _safeJson(dynamic obj) =>
      jsonEncode(obj).replaceAll('</', '<\\/');
}