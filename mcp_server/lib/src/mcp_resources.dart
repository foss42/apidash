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

  /// Returns the raw HTML for a given resource URI.
  /// Used by tools to embed HTML directly in content responses.
  static String readHtml(String uri) {
    return switch (uri) {
      '$_baseUri/test-checklist-ui' => _testChecklistHtml(_testCases),
      '$_baseUri/test-results-ui' => _testResultsHtml(_testResults),
      '$_baseUri/workflow-plan-ui' => _workflowPlanHtml(_workflowSteps),
      '$_baseUri/workflow-results-ui' => _workflowResultsHtml(_workflowResults),
      _ => throw ArgumentError('Unknown resource URI: $uri'),
    };
  }

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

    return _page('🧪 Test Cases — API Dash', '''
<div class="bar">
  <button class="btn-s" onclick="sel(true)">☑ All</button>
  <button class="btn-s" onclick="sel(false)">□ None</button>
  <button class="btn-p" onclick="run()">⚡ Run Selected</button>
  <span class="count" id="cl">Loading...</span>
</div>
<table><thead><tr><th></th><th>Description</th><th>Category</th><th>Method</th><th>URL</th></tr></thead>
<tbody id="tbody"></tbody></table>
<div id="msg" class="msg"></div>
<script>
let D = $casesJson;
function esc(s){return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;')}
function renderTable(data){
  const tbody=document.getElementById("tbody");
  tbody.innerHTML=data.map((tc,i)=>`<tr>
    <td><input type="checkbox" id="c\${i}" checked onchange="upd()"></td>
    <td><label for="c\${i}">\${esc(tc.description||'')}</label></td>
    <td><span class="badge badge-\${tc.category||''}">\${tc.category||''}</span></td>
    <td class="mono primary">\${esc(tc.method||'')}</td>
    <td class="mono url">\${esc(tc.url||'')}</td>
  </tr>`).join('');
  upd();
}
function upd(){const b=document.querySelectorAll("input[type=checkbox]");document.getElementById("cl").textContent=[...b].filter(x=>x.checked).length+" of "+b.length+" selected"}
function sel(v){document.querySelectorAll("input[type=checkbox]").forEach(b=>b.checked=v);upd()}
async function run(){
  const b=document.querySelectorAll("input[type=checkbox]");
  const selected=D.map((tc,i)=>({...tc,isSelected:b[i]?.checked??false}));
  const m=document.getElementById("msg");
  m.className="msg ml";m.style.display="block";m.textContent="⏳ Running...";
  try{
    // MCP Apps: call tool via postMessage to host
    await sendMcpToolCall("run_selected_tests",{test_cases:selected});
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
window.addEventListener("message",e=>{
  const d=e.data;
  if(d?.method==="ui/notifications/tool-input"){
    const sc=d?.params?.structuredContent;
    if(Array.isArray(sc?.testCases)){
      D=sc.testCases;
      renderTable(D);
    }
  }
});
if(D.length>0) renderTable(D);
else document.getElementById("cl").textContent="Waiting for test cases...";
</script>''');
  }

  static String _testResultsHtml(List<Map<String, dynamic>> results) {
    final resultsJson = _safeJson(results);

    return _page('🧪 Test Results — API Dash', '''
<div class="sum">
  <div class="stat"><span class="sp" id="passed">0</span><span class="sl">Passed</span></div>
  <div class="stat"><span class="sf" id="failed">0</span><span class="sl">Failed</span></div>
  <div class="stat"><span class="sk" id="skipped">0</span><span class="sl">Skipped</span></div>
</div>
<p class="sub">Click any row for assertion details</p>
<table><thead><tr><th></th><th>Test</th><th>Status</th><th>Time</th></tr></thead>
<tbody id="tbody"></tbody></table>
<script>
let D = $resultsJson;
function esc(s){return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;')}
function tog(r){const n=r.nextElementSibling;if(n?.classList.contains("dr"))n.style.display=n.style.display==="none"?"table-row":"none";}
function renderResults(data){
  document.getElementById("passed").textContent=String(data.filter(r=>r.overallStatus==="passed").length);
  document.getElementById("failed").textContent=String(data.filter(r=>r.overallStatus==="failed").length);
  document.getElementById("skipped").textContent=String(data.filter(r=>r.overallStatus==="skipped").length);
  const tbody=document.getElementById("tbody");
  tbody.innerHTML=data.map(r=>{
    const status=r.overallStatus||"skipped";
    const icon=status==="passed"?"✅":status==="failed"?"❌":"⏭️";
    const code=r.actualStatusCode||0;
    const ms=r.durationMs||0;
    const tc=r.testCase||{};
    const assertionRows=(r.assertionResults||[]).map(ar=>{
      const pass=ar.passed===true;
      const skip=ar.skipped===true;
      const klass=skip?"as":pass?"ap":"af";
      const prefix=skip?"⏭":pass?"✓":"✗";
      return `<div class="\${klass}">\${prefix} \${esc(ar.message||"")}</div>`;
    }).join("");
    const err=r.errorMessage?`<div class="em">⚠️ \${esc(r.errorMessage)}</div>`:"";
    const statusClass=status==="passed"?"sp":status==="failed"?"sf":"sk";
    return `<tr onclick="tog(this)">
      <td>\${icon}</td>
      <td>\${esc(tc.description||"")}</td>
      <td class="\${statusClass}">\${code>0?code:"—"}</td>
      <td>\${ms>0?String(ms)+"ms":"—"}</td>
    </tr>
    <tr class="dr" style="display:none"><td colspan="4"><div class="db">\${assertionRows}\${err}</div></td></tr>`;
  }).join('');
}
window.addEventListener("message",e=>{
  const d=e.data;
  if(d?.method==="ui/notifications/tool-input"){
    const sc=d?.params?.structuredContent;
    if(Array.isArray(sc?.results)){
      D=sc.results;
      renderResults(D);
    }
  }
});
renderResults(D);
</script>''');
  }

  static String _workflowPlanHtml(List<Map<String, dynamic>> steps) {
    final stepsJson = _safeJson(steps);

    return _page('🔗 Workflow Plan — API Dash', '''
<div class="bar">
  <button class="btn-p" onclick="exec()">⚡ Execute Workflow</button>
  <span class="count" id="cl">Loading...</span>
</div>
<div id="cards"></div>
<div id="msg" class="msg"></div>
<script>
let S = $stepsJson;
function esc(s){return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;')}
function renderSteps(data){
  const cards=document.getElementById("cards");
  cards.innerHTML=data.map((step,si)=>{
    const assertions=(step.assertions||[]).map((a,ai)=>`<div class="ar"><input type="checkbox" id="a\${si}_\${ai}" checked onchange="upd()"> <label for="a\${si}_\${ai}">\${esc(a.type||'')}: \${esc(String(a.expected||''))}</label></div>`).join('');
    return `<div class="card"><div class="ch"><span class="sn">STEP \${si+1}</span><span class="sm">\${esc(step.method||'')}</span><span class="su">\${esc(step.url||'')}</span></div><div class="cb">\${assertions}</div></div>`;
  }).join('');
  upd();
}
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
window.addEventListener("message",e=>{
  const d=e.data;
  if(d?.method==="ui/notifications/tool-input"){
    const sc=d?.params?.structuredContent;
    if(Array.isArray(sc?.steps)){
      S=sc.steps;
      renderSteps(S);
    }
  }
});
if(S.length>0) renderSteps(S);
else document.getElementById("cl").textContent="Waiting for workflow steps...";
</script>''');
  }

  static String _workflowResultsHtml(List<Map<String, dynamic>> results) {
    final resultsJson = _safeJson(results);

    return _page('🔗 Workflow Results — API Dash', '''
<div class="sum">
  <div class="stat"><span class="sp" id="passed">0</span><span class="sl">Steps OK</span></div>
  <div class="stat"><span class="sf" id="failed">0</span><span class="sl">Failed</span></div>
</div>
<div id="cards"></div>
<script>
let D = $resultsJson;
function esc(s){return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;')}
function renderResults(data){
  document.getElementById("passed").textContent=String(data.filter(r=>r.overallStatus==="passed").length);
  document.getElementById("failed").textContent=String(data.filter(r=>r.overallStatus==="failed").length);
  const cards=document.getElementById("cards");
  cards.innerHTML=data.map((r,i)=>{
    const icon=r.overallStatus==="passed"?"✅":"❌";
    const step=r.step||r.testCase||{};
    const assertionRows=(r.assertionResults||[]).map(ar=>{
      const pass=ar.passed===true;
      const skip=ar.skipped===true;
      const klass=skip?"as":pass?"ap":"af";
      const prefix=skip?"⏭":pass?"✓":"✗";
      return `<div class="\${klass}">\${prefix} \${esc(ar.message||"")}</div>`;
    }).join("");
    const err=r.errorMessage?`<div class="em">⚠️ \${esc(r.errorMessage)}</div>`:"";
    return `<div class="card"><div class="ch">\${icon} Step \${i+1} - \${esc(step.method||'')} \${esc(step.url||'')}<span class="sm">\${r.actualStatusCode||0} • \${r.durationMs||0}ms</span></div><div class="cb">\${assertionRows}\${err}</div></div>`;
  }).join('');
}
window.addEventListener("message",e=>{
  const d=e.data;
  if(d?.method==="ui/notifications/tool-input"){
    const sc=d?.params?.structuredContent;
    if(Array.isArray(sc?.results)){
      D=sc.results;
      renderResults(D);
    }
  }
});
renderResults(D);
</script>''');
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