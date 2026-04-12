import 'dart:convert';

const _mime = 'text/html;profile=mcp-app';
const _baseUri = 'ui://apidash-mcp';

class McpResources {
  static List<Map<String, dynamic>> _testCases = [];
  static List<Map<String, dynamic>> _selectedTestCases = [];
  static List<Map<String, dynamic>> _testResults = [];
  static List<Map<String, dynamic>> _workflowSteps = [];
  static List<Map<String, dynamic>> _workflowResults = [];

  static void setTestCases(List<Map<String, dynamic>> v) => _testCases = v;
  static void setSelectedTestCases(List<Map<String, dynamic>> v) =>
      _selectedTestCases = v;
  static List<Map<String, dynamic>> getSelectedTestCases() =>
      _selectedTestCases;
  static void setTestResults(List<Map<String, dynamic>> v) => _testResults = v;
  static void setWorkflowSteps(List<Map<String, dynamic>> v) =>
      _workflowSteps = v;
  static void setWorkflowResults(List<Map<String, dynamic>> v) =>
      _workflowResults = v;

  /// Returns raw HTML for a given MCP UI resource URI.
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
        {
          'uri': '$_baseUri/test-checklist-ui',
          'mimeType': _mime,
          'name': 'Test Checklist',
          'description': 'Interactive test case selection UI',
        },
        {
          'uri': '$_baseUri/test-results-ui',
          'mimeType': _mime,
          'name': 'Test Results',
          'description': 'Test execution results dashboard',
        },
        {
          'uri': '$_baseUri/workflow-plan-ui',
          'mimeType': _mime,
          'name': 'Workflow Plan',
          'description': 'Multi-step workflow assertion selector',
        },
        {
          'uri': '$_baseUri/workflow-results-ui',
          'mimeType': _mime,
          'name': 'Workflow Results',
          'description': 'Workflow execution results',
        },
      ];

  // ── resources/read ────────────────────────────────────────────────────────

  static Map<String, dynamic> read(String uri) {
    final html = switch (uri) {
      '$_baseUri/test-checklist-ui' => _testChecklistHtml(_testCases),
      '$_baseUri/test-results-ui' => _testResultsHtml(_testResults),
      '$_baseUri/workflow-plan-ui' => _workflowPlanHtml(_workflowSteps),
      '$_baseUri/workflow-results-ui' => _workflowResultsHtml(_workflowResults),
      _ => throw ArgumentError('Unknown resource URI: $uri'),
    };
    return {
      'contents': [
        {'uri': uri, 'mimeType': _mime, 'text': html}
      ],
    };
  }

  // ── Test Checklist HTML ──────────────────────────────────────────────────
  // Exact pattern from sales-form.ts:
  //   1. ui/initialize handshake
  //   2. sendNotification("ui/notifications/initialized")
  //   3. Listen for ui/notifications/tool-input to populate data
  //   4. Button click → tools/call get_selected_cases (app-only validation)
  //   5. ui/update-model-context → pushes selection into Claude/Copilot context
  //   6. User types "Run tests" → model calls run_selected_tests

  static String _testChecklistHtml(List<Map<String, dynamic>> cases) {
    final casesJson = _safe(cases);
    return _page('API Test Cases', '''
<div class="bar">
  <button class="bs" onclick="sel(true)">Select All</button>
  <button class="bs" onclick="sel(false)">Clear</button>
  <button class="bp" id="sb" onclick="submit()" disabled>Submit Selection</button>
  <span class="cnt" id="cl">Loading...</span>
</div>
<table>
  <thead><tr><th></th><th>Description</th><th>Category</th><th>Method</th><th>URL</th></tr></thead>
  <tbody id="tb"></tbody>
</table>
<div id="msg" class="msg"></div>
<script>
let D=$casesJson,nid=1;
const P=new Map();

// ── MCP comms (exact pattern from sales-form.ts) ──
function req(method,params){
  const id=nid++;
  return new Promise((res,rej)=>{
    P.set(id,{res,rej});
    window.parent.postMessage({jsonrpc:'2.0',id,method,params:params||{}},'*');
  });
}
function notif(method,params){
  window.parent.postMessage({jsonrpc:'2.0',method,params:params||{}},'*');
}
window.addEventListener('message',e=>{
  const m=e.data;
  if(!m||m.jsonrpc!=='2.0')return;
  if(m.id!==undefined&&P.has(m.id)){
    const {res,rej}=P.get(m.id);P.delete(m.id);
    m.error?rej(new Error(m.error.message)):res(m.result);return;
  }
  // VSCode sends tool-input notification with structuredContent from tool response
  if(m.method==='ui/notifications/tool-input'){
    const sc=m.params&&m.params.structuredContent;
    if(sc&&Array.isArray(sc.testCases)){D=sc.testCases;render(D);}
  }
});

function e(s){return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');}
function status(t,c){const m=document.getElementById('msg');m.textContent=t;m.style.display='block';m.className='msg '+(c||'mi');}

function render(data){
  document.getElementById('tb').innerHTML=data.map((t,i)=>
    '<tr><td><input type="checkbox" id="c'+i+'" '+(t.isSelected!==false?'checked':'')+' onchange="upd()"></td>'+
    '<td><label for="c'+i+'">'+e(t.description||'')+'</label></td>'+
    '<td><span class="badge cat-'+e(t.category||'')+'">'+e(t.category||'')+'</span></td>'+
    '<td class="mono p">'+e(t.method||'')+'</td>'+
    '<td class="mono url">'+e(t.url||'')+'</td></tr>'
  ).join('');
  upd();
}

function upd(){
  const b=document.querySelectorAll('input[type=checkbox]');
  const n=Array.from(b).filter(x=>x.checked).length;
  document.getElementById('cl').textContent=n+' of '+b.length+' selected';
  document.getElementById('sb').disabled=n===0;
}

function sel(v){document.querySelectorAll('input[type=checkbox]').forEach(b=>b.checked=v);upd();}

// ── Submit: validate → update-model-context ──
async function submit(){
  const b=document.querySelectorAll('input[type=checkbox]');
  const sel=D.map((t,i)=>({...t,isSelected:b[i]?b[i].checked:false})).filter(t=>t.isSelected);
  if(!sel.length){status('Select at least one test case','me');return;}
  document.getElementById('sb').disabled=true;
  status('Validating selection...','mi');
  // Step 1: call app-only tool to validate (mirrors get-sales-data call)
  let validated=sel;
  try{
    const r=await req('tools/call',{name:'get_selected_cases',arguments:{selected_cases:sel}});
    if(r&&r.structuredContent&&r.structuredContent.selectedCases)validated=r.structuredContent.selectedCases;
    status('Updating chat context...','mi');
  }catch(err){status('Validation skipped, pushing context...','mi');}
  // Step 2: push into model context (THE KEY STEP - mirrors sales-form.ts exactly)
  try{
    await req('ui/update-model-context',{structuredContent:{selectedCases:validated}});
    status('Done! '+validated.length+' test case(s) added to context. Now ask Copilot to run the tests.','ms');
  }catch(err){status('Context update failed: '+err.message,'me');}
  finally{document.getElementById('sb').disabled=false;}
}

// ── Initialize (mirrors sales-form.ts initialize()) ──
async function init(){
  try{
    await req('ui/initialize',{protocolVersion:'2025-11-21',capabilities:{},clientInfo:{name:'apidash-checklist',version:'1.0.0'}});
    notif('ui/notifications/initialized',{});
  }catch(e){/* standalone mode */}
  if(D.length>0)render(D);
  else document.getElementById('cl').textContent='Waiting for test cases...';
  notif('ui/notifications/size-changed',{width:document.body.scrollWidth,height:document.body.scrollHeight+40});
}
init();
</script>''');
  }

  // ── Test Results HTML ────────────────────────────────────────────────────

  static String _testResultsHtml(List<Map<String, dynamic>> results) {
    final data = _safe(results);
    return _page('Test Results', '''
<div class="sum">
  <div class="stat"><span class="sp" id="ps">0</span><span class="sl">Passed</span></div>
  <div class="stat"><span class="sf" id="fs">0</span><span class="sl">Failed</span></div>
  <div class="stat"><span class="sk" id="ss">0</span><span class="sl">Skipped</span></div>
</div>
<p class="sub">Click any row to expand assertions</p>
<table><thead><tr><th></th><th>Test</th><th>Status</th><th>Time</th></tr></thead>
<tbody id="tb"></tbody></table>
<script>
let D=$data,nid=1;
const P=new Map();
function req(method,params){const id=nid++;return new Promise((res,rej)=>{P.set(id,{res,rej});window.parent.postMessage({jsonrpc:'2.0',id,method,params:params||{}},'*');});}
window.addEventListener('message',e=>{
  const m=e.data;if(!m||m.jsonrpc!=='2.0')return;
  if(m.id!==undefined&&P.has(m.id)){const {res,rej}=P.get(m.id);P.delete(m.id);m.error?rej(new Error(m.error.message)):res(m.result);return;}
  if(m.method==='ui/notifications/tool-input'){const sc=m.params&&m.params.structuredContent;if(sc&&Array.isArray(sc.results)){D=sc.results;render(D);}}
});
function e(s){return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');}
function tog(r){const n=r.nextElementSibling;if(n&&n.classList.contains('dr'))n.style.display=n.style.display==='none'?'table-row':'none';}
function render(data){
  document.getElementById('ps').textContent=data.filter(r=>r.overallStatus==='passed').length;
  document.getElementById('fs').textContent=data.filter(r=>r.overallStatus==='failed').length;
  document.getElementById('ss').textContent=data.filter(r=>r.overallStatus==='skipped').length;
  document.getElementById('tb').innerHTML=data.map(r=>{
    const st=r.overallStatus||'skipped';
    const ic=st==='passed'?'[OK]':st==='failed'?'[FAIL]':'[SKIP]';
    const tc=r.testCase||{};
    const ars=(r.assertionResults||[]).map(ar=>'<div class="'+(ar.skipped?'ask':ar.passed?'asp':'asf')+'">'+(ar.skipped?'skip':ar.passed?'pass':'fail')+' '+e(ar.message||'')+'</div>').join('');
    const err=r.errorMessage?'<div class="em">Error: '+e(r.errorMessage)+'</div>':'';
    const sc=st==='passed'?'sp':st==='failed'?'sf':'sk';
    return '<tr onclick="tog(this)"><td>'+ic+'</td><td>'+e(tc.description||'')+'</td><td class="'+sc+'">'+(r.actualStatusCode>0?r.actualStatusCode:'-')+'</td><td>'+(r.durationMs>0?r.durationMs+'ms':'-')+'</td></tr>'+
      '<tr class="dr" style="display:none"><td colspan="4"><div class="db">'+ars+err+'</div></td></tr>';
  }).join('');
}
async function init(){
  try{await req('ui/initialize',{protocolVersion:'2025-11-21',capabilities:{},clientInfo:{name:'apidash-results',version:'1.0.0'}});}catch(e){}
  render(D);
  window.parent.postMessage({jsonrpc:'2.0',method:'ui/notifications/size-changed',params:{width:document.body.scrollWidth,height:document.body.scrollHeight+40}},'*');
}
init();
</script>''');
  }

  // ── Workflow Plan HTML ───────────────────────────────────────────────────

  static String _workflowPlanHtml(List<Map<String, dynamic>> steps) {
    final data = _safe(steps);
    return _page('Workflow Plan', '''
<div class="bar">
  <button class="bp" id="eb" onclick="submit()">Execute Workflow</button>
  <span class="cnt" id="cl">Loading...</span>
</div>
<div id="cards"></div>
<div id="msg" class="msg"></div>
<script>
let S=$data,nid=1;
const P=new Map();
function req(method,params){const id=nid++;return new Promise((res,rej)=>{P.set(id,{res,rej});window.parent.postMessage({jsonrpc:'2.0',id,method,params:params||{}},'*');});}
function notif(method,params){window.parent.postMessage({jsonrpc:'2.0',method,params:params||{}},'*');}
window.addEventListener('message',ev=>{
  const m=ev.data;if(!m||m.jsonrpc!=='2.0')return;
  if(m.id!==undefined&&P.has(m.id)){const {res,rej}=P.get(m.id);P.delete(m.id);m.error?rej(new Error(m.error.message)):res(m.result);return;}
  if(m.method==='ui/notifications/tool-input'){const sc=m.params&&m.params.structuredContent;if(sc&&Array.isArray(sc.steps)){S=sc.steps;render(S);}}
});
function e(s){return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');}
function status(t,c){const m=document.getElementById('msg');m.textContent=t;m.style.display='block';m.className='msg '+(c||'mi');}
function render(data){
  document.getElementById('cards').innerHTML=data.map((s,si)=>{
    const ars=(s.assertions||[]).map((a,ai)=>
      '<div class="ar"><input type="checkbox" id="a'+si+'_'+ai+'" '+(a.isSelected!==false?'checked':'')+' onchange="upd()"><label for="a'+si+'_'+ai+'"> '+e(a.type||'')+': '+e(String(a.expected||''))+'</label></div>'
    ).join('');
    return '<div class="card"><div class="ch"><span class="sn">STEP '+(si+1)+'</span><span class="sm">'+e(s.method||'')+'</span><span class="su">'+e(s.url||'')+'</span></div><div class="cb">'+ars+'</div></div>';
  }).join('');
  upd();
}
function upd(){
  const b=document.querySelectorAll('input[type=checkbox]');
  document.getElementById('cl').textContent=Array.from(b).filter(x=>x.checked).length+' of '+b.length+' assertions';
}
async function submit(){
  const steps=S.map((s,si)=>({...s,assertions:(s.assertions||[]).map((a,ai)=>({...a,isSelected:document.getElementById('a'+si+'_'+ai)?document.getElementById('a'+si+'_'+ai).checked:false}))}));
  document.getElementById('eb').disabled=true;
  status('Pushing workflow to chat context...','mi');
  try{
    await req('ui/update-model-context',{structuredContent:{workflowSteps:steps}});
    status('Done! Ask Copilot to execute the workflow.','ms');
  }catch(err){status('Failed: '+err.message,'me');}
  finally{document.getElementById('eb').disabled=false;}
}
async function init(){
  try{await req('ui/initialize',{protocolVersion:'2025-11-21',capabilities:{},clientInfo:{name:'apidash-workflow-plan',version:'1.0.0'}});notif('ui/notifications/initialized',{});}catch(e){}
  if(S.length>0)render(S);else document.getElementById('cl').textContent='Waiting for workflow steps...';
  notif('ui/notifications/size-changed',{width:document.body.scrollWidth,height:document.body.scrollHeight+40});
}
init();
</script>''');
  }

  // ── Workflow Results HTML ────────────────────────────────────────────────

  static String _workflowResultsHtml(List<Map<String, dynamic>> results) {
    final data = _safe(results);
    return _page('Workflow Results', '''
<div class="sum">
  <div class="stat"><span class="sp" id="ps">0</span><span class="sl">Steps OK</span></div>
  <div class="stat"><span class="sf" id="fs">0</span><span class="sl">Failed</span></div>
</div>
<div id="cards"></div>
<script>
let D=$data,nid=1;
const P=new Map();
function req(method,params){const id=nid++;return new Promise((res,rej)=>{P.set(id,{res,rej});window.parent.postMessage({jsonrpc:'2.0',id,method,params:params||{}},'*');});}
window.addEventListener('message',ev=>{
  const m=ev.data;if(!m||m.jsonrpc!=='2.0')return;
  if(m.id!==undefined&&P.has(m.id)){const {res,rej}=P.get(m.id);P.delete(m.id);m.error?rej(new Error(m.error.message)):res(m.result);return;}
  if(m.method==='ui/notifications/tool-input'){const sc=m.params&&m.params.structuredContent;if(sc&&Array.isArray(sc.results)){D=sc.results;render(D);}}
});
function e(s){return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');}
function render(data){
  document.getElementById('ps').textContent=data.filter(r=>r.overallStatus==='passed').length;
  document.getElementById('fs').textContent=data.filter(r=>r.overallStatus==='failed').length;
  document.getElementById('cards').innerHTML=data.map((r,i)=>{
    const ic=r.overallStatus==='passed'?'[OK]':'[FAIL]';
    const s=r.step||r.testCase||{};
    const ars=(r.assertionResults||[]).map(ar=>'<div class="'+(ar.skipped?'ask':ar.passed?'asp':'asf')+'">'+(ar.skipped?'skip':ar.passed?'pass':'fail')+' '+e(ar.message||'')+'</div>').join('');
    const err=r.errorMessage?'<div class="em">'+e(r.errorMessage)+'</div>':'';
    return '<div class="card"><div class="ch">'+ic+' Step '+(i+1)+' - '+e(s.method||'')+' '+e(s.url||'')+'<span class="sm">'+(r.actualStatusCode||0)+' - '+(r.durationMs||0)+'ms</span></div><div class="cb">'+ars+err+'</div></div>';
  }).join('');
}
async function init(){
  try{await req('ui/initialize',{protocolVersion:'2025-11-21',capabilities:{},clientInfo:{name:'apidash-workflow-results',version:'1.0.0'}});}catch(e){}
  render(D);
  window.parent.postMessage({jsonrpc:'2.0',method:'ui/notifications/size-changed',params:{width:document.body.scrollWidth,height:document.body.scrollHeight+40}},'*');
}
init();
</script>''');
  }

  // ── Shared page template ─────────────────────────────────────────────────

  static String _page(String title, String body) => '''<!DOCTYPE html>
<html lang="en"><head><meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>$title</title>
<style>
:root{--bg:#f7f6f2;--s:#fff;--b:#dcd9d5;--t:#28251d;--m:#7a7974;--p:#01696f;--ph:#0c4e54;--ok:#437a22;--er:#a12c7b;--sk:#7a7974}
*{box-sizing:border-box;margin:0;padding:0}
body{font-family:'Inter',system-ui,sans-serif;background:var(--bg);color:var(--t);font-size:13px;padding:16px}
h1{font-size:16px;margin-bottom:12px}
.bar{display:flex;gap:8px;align-items:center;margin-bottom:12px;flex-wrap:wrap}
.cnt{font-size:12px;color:var(--m);margin-left:auto}
.sub{color:var(--m);font-size:12px;margin-bottom:12px}
button{padding:6px 14px;border-radius:6px;border:none;cursor:pointer;font-size:12px;font-weight:500}
button:disabled{opacity:.5;cursor:not-allowed}
.bp{background:var(--p);color:#fff}.bp:hover:not(:disabled){background:var(--ph)}
.bs{background:var(--s);color:var(--t);border:1px solid var(--b)}
table{width:100%;border-collapse:collapse;background:var(--s);border-radius:8px;overflow:hidden;box-shadow:0 1px 4px rgba(0,0,0,.06)}
th{text-align:left;padding:8px 10px;font-size:10px;font-weight:600;text-transform:uppercase;letter-spacing:.05em;color:var(--m);background:var(--bg);border-bottom:1px solid var(--b)}
td{padding:8px 10px;border-bottom:1px solid var(--b);vertical-align:middle}
tr:last-child td{border-bottom:none}tr:not(.dr):hover td{background:#f9f8f5}
.mono{font-family:monospace;font-size:11px}.p{color:var(--p);font-weight:700}
.url{max-width:180px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.badge{display:inline-flex;padding:1px 6px;border-radius:99px;font-size:10px;font-weight:500}
.cat-happy_path{background:#d4dfcc;color:#1e3f0a}.cat-edge_case{background:#e9e0c6;color:#8a5b00}
.cat-security{background:#e0ced7;color:#561740}.cat-performance{background:#c6d8e4;color:#0b3751}
.sum{display:flex;gap:10px;margin-bottom:16px;flex-wrap:wrap}
.stat{padding:10px 16px;border-radius:8px;background:var(--s);border:1px solid var(--b);font-weight:600;font-size:18px;min-width:70px}
.sl{font-size:10px;font-weight:400;color:var(--m);display:block}
.sp{color:var(--ok)}.sf{color:var(--er)}.sk{color:var(--sk)}
.db{padding:6px 0}.asp,.asf,.ask{font-size:11px;padding:2px 8px}
.asp{color:var(--ok)}.asf{color:var(--er)}.ask{color:var(--sk)}.em{color:var(--er);font-size:11px;padding:2px 8px}
.msg{padding:10px 14px;border-radius:6px;font-size:12px;margin-top:12px;display:none}
.mi{background:#cedcd8;color:var(--p);border:1px solid #b2ceca}
.ms{background:#d4dfcc;color:#1e3f0a;border:1px solid #b8cfb0}
.me{background:#f9e8f1;color:var(--er);border:1px solid #e0ced7}
.card{background:var(--s);border:1px solid var(--b);border-radius:8px;margin-bottom:10px;overflow:hidden}
.ch{display:flex;align-items:center;gap:8px;padding:8px 12px;background:var(--bg);border-bottom:1px solid var(--b);font-weight:500;flex-wrap:wrap}
.cb{padding:8px 12px;display:flex;flex-direction:column;gap:4px}
.sn{font-size:10px;font-weight:700;color:var(--m);text-transform:uppercase}
.sm{font-family:monospace;font-weight:700;color:var(--p);font-size:12px}
.su{font-family:monospace;font-size:11px;color:var(--m)}
.ar{font-size:12px;margin:2px 0}
</style></head><body>
<h1>$title</h1>
$body
</body></html>''';

  static String _safe(dynamic obj) =>
      jsonEncode(obj).replaceAll('</', '<\\/');
}