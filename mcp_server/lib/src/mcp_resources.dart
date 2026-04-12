import 'dart:convert';

const _mime = 'text/html;profile=mcp-app';
const _baseUri = 'ui://apidash-mcp';

class McpResources {
  static List<Map<String, dynamic>> _testCases = [];
  static List<Map<String, dynamic>> _selectedTestCases = [];
  static List<Map<String, dynamic>> _testResults = [];

  static void setTestCases(List<Map<String, dynamic>> v) => _testCases = v;
  static void setSelectedTestCases(List<Map<String, dynamic>> v) => _selectedTestCases = v;
  static List<Map<String, dynamic>> getSelectedTestCases() => _selectedTestCases;
  static void setTestResults(List<Map<String, dynamic>> v) => _testResults = v;

  static String readHtml(String uri) => switch (uri) {
        '$_baseUri/test-checklist-ui' => _checklistHtml(_testCases),
        '$_baseUri/test-results-ui'   => _resultsHtml(_testResults),
        _ => throw ArgumentError('Unknown resource URI: $uri'),
      };

  static List<Map<String, dynamic>> list() => [
        _res('test-checklist-ui', 'Test Checklist',  'Interactive test case selection UI'),
        _res('test-results-ui',   'Test Results',    'Test execution results dashboard'),
      ];

  static Map<String, dynamic> read(String uri) => {
        'contents': [{'uri': uri, 'mimeType': _mime, 'text': readHtml(uri)}],
      };

  // ── Checklist UI ──────────────────────────────────────────────────────────

  static String _checklistHtml(List<Map<String, dynamic>> cases) =>
      _page('API Test Cases', '''
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
let D=${_safe(cases)},nid=1;
const P=new Map();
function rpc(m,p){const id=nid++;return new Promise((res,rej)=>{P.set(id,{res,rej});window.parent.postMessage({jsonrpc:'2.0',id,method:m,params:p||{}},'*');});}
function notif(m,p){window.parent.postMessage({jsonrpc:'2.0',method:m,params:p||{}},'*');}
window.addEventListener('message',ev=>{
  const m=ev.data;if(!m||m.jsonrpc!=='2.0')return;
  if(m.id!==undefined&&P.has(m.id)){const {res,rej}=P.get(m.id);P.delete(m.id);m.error?rej(new Error(m.error.message)):res(m.result);return;}
  if(m.method==='ui/notifications/tool-input'){const sc=m.params?.structuredContent;if(sc?.testCases){D=sc.testCases;render(D);}}
});
const esc=s=>String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
const \$=id=>document.getElementById(id);
function status(t,c){\$('msg').textContent=t;\$('msg').style.display='block';\$('msg').className='msg '+(c||'mi');}
function render(data){
  \$('tb').innerHTML=data.map((t,i)=>
    '<tr><td><input type="checkbox" id="c'+i+'" '+(t.isSelected!==false?'checked':'')+' onchange="upd()"></td>'+
    '<td><label for="c'+i+'">'+esc(t.description||'')+'</label></td>'+
    '<td><span class="badge cat-'+esc(t.category||'')+'">'+esc(t.category||'')+'</span></td>'+
    '<td class="mono p">'+esc(t.method||'')+'</td>'+
    '<td class="mono url">'+esc(t.url||'')+'</td></tr>'
  ).join('');upd();
}
function upd(){
  const bs=[...document.querySelectorAll('input[type=checkbox]')];
  const n=bs.filter(x=>x.checked).length;
  \$('cl').textContent=n+' of '+bs.length+' selected';
  \$('sb').disabled=n===0;
}
function sel(v){document.querySelectorAll('input[type=checkbox]').forEach(b=>b.checked=v);upd();}
async function submit(){
  const bs=document.querySelectorAll('input[type=checkbox]');
  const selected=D.map((t,i)=>({...t,isSelected:bs[i]?.checked??false})).filter(t=>t.isSelected);
  if(!selected.length){status('Select at least one test case','me');return;}
  \$('sb').disabled=true;
  status('Updating chat context...','mi');
  try{
    await rpc('ui/update-model-context',{structuredContent:{selectedCases:selected}});
    status(selected.length+' test case(s) added to context. Ask Copilot to run the tests.','ms');
  }catch(err){status('Context update failed: '+err.message,'me');}
  finally{\$('sb').disabled=false;}
}
async function init(){
  try{await rpc('ui/initialize',{protocolVersion:'2025-11-21',capabilities:{},clientInfo:{name:'apidash-checklist',version:'1.0.0'}});notif('ui/notifications/initialized',{});}catch(_){}
  if(D.length>0)render(D);else \$('cl').textContent='Waiting for test cases...';
  notif('ui/notifications/size-changed',{width:document.body.scrollWidth,height:document.body.scrollHeight+40});
}
init();
</script>''');

  // ── Results UI ────────────────────────────────────────────────────────────

  static String _resultsHtml(List<Map<String, dynamic>> results) =>
      _page('Test Results', '''
<div class="sum">
  <div class="stat"><span class="sp" id="ps">0</span><span class="sl">Passed</span></div>
  <div class="stat"><span class="sf" id="fs">0</span><span class="sl">Failed</span></div>
  <div class="stat"><span class="sk" id="ss">0</span><span class="sl">Skipped</span></div>
</div>
<p class="sub">Click a row to expand assertions</p>
<table><thead><tr><th></th><th>Test</th><th>Status</th><th>Time</th></tr></thead>
<tbody id="tb"></tbody></table>
<script>
let D=${_safe(results)},nid=1;
const P=new Map();
function rpc(m,p){const id=nid++;return new Promise((res,rej)=>{P.set(id,{res,rej});window.parent.postMessage({jsonrpc:'2.0',id,method:m,params:p||{}},'*');});}
window.addEventListener('message',ev=>{
  const m=ev.data;if(!m||m.jsonrpc!=='2.0')return;
  if(m.id!==undefined&&P.has(m.id)){const {res,rej}=P.get(m.id);P.delete(m.id);m.error?rej(new Error(m.error.message)):res(m.result);return;}
  if(m.method==='ui/notifications/tool-input'){const sc=m.params?.structuredContent;if(sc?.results){D=sc.results;render(D);}}
});
const esc=s=>String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
const \$=id=>document.getElementById(id);
function tog(r){const n=r.nextElementSibling;if(n?.classList.contains('dr'))n.style.display=n.style.display==='none'?'table-row':'none';}
function render(data){
  \$('ps').textContent=data.filter(r=>r.overallStatus==='passed').length;
  \$('fs').textContent=data.filter(r=>r.overallStatus==='failed').length;
  \$('ss').textContent=data.filter(r=>r.overallStatus==='skipped').length;
  \$('tb').innerHTML=data.map(r=>{
    const st=r.overallStatus||'skipped';
    const sc=st==='passed'?'sp':st==='failed'?'sf':'sk';
    const ic=st==='passed'?'[OK]':st==='failed'?'[FAIL]':'[SKIP]';
    const tc=r.testCase||{};
    const ars=(r.assertionResults||[]).map(ar=>'<div class="'+(ar.skipped?'ask':ar.passed?'asp':'asf')+'">'+esc(ar.message||'')+'</div>').join('');
    const err=r.errorMessage?'<div class="em">'+esc(r.errorMessage)+'</div>':'';
    return '<tr onclick="tog(this)"><td>'+ic+'</td><td>'+esc(tc.description||'')+'</td><td class="'+sc+'">'+(r.actualStatusCode>0?r.actualStatusCode:'-')+'</td><td>'+(r.durationMs>0?r.durationMs+'ms':'-')+'</td></tr>'+
      '<tr class="dr" style="display:none"><td colspan="4"><div class="db">'+ars+err+'</div></td></tr>';
  }).join('');
}
async function init(){
  try{await rpc('ui/initialize',{protocolVersion:'2025-11-21',capabilities:{},clientInfo:{name:'apidash-results',version:'1.0.0'}});}catch(_){}
  render(D);
  window.parent.postMessage({jsonrpc:'2.0',method:'ui/notifications/size-changed',params:{width:document.body.scrollWidth,height:document.body.scrollHeight+40}},'*');
}
init();
</script>''');

  // ── Helpers ───────────────────────────────────────────────────────────────

  static Map<String, dynamic> _res(String id, String name, String desc) => {
        'uri': '$_baseUri/$id',
        'mimeType': _mime,
        'name': name,
        'description': desc,
      };

  static String _safe(dynamic obj) => jsonEncode(obj).replaceAll('</', '<\\/');

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
.stat{padding:10px 16px;border-radius:8px;background:var(--s);border:1px solid var(--b);font-size:18px;font-weight:600;min-width:70px}
.sl{font-size:10px;font-weight:400;color:var(--m);display:block}
.sp{color:var(--ok)}.sf{color:var(--er)}.sk{color:var(--sk)}
.db{padding:6px 0}.asp,.asf,.ask{font-size:11px;padding:2px 8px}
.asp{color:var(--ok)}.asf{color:var(--er)}.ask{color:var(--sk)}.em{color:var(--er);font-size:11px;padding:2px 8px}
.msg{padding:10px 14px;border-radius:6px;font-size:12px;margin-top:12px;display:none}
.mi{background:#cedcd8;color:var(--p);border:1px solid #b2ceca}
.ms{background:#d4dfcc;color:#1e3f0a;border:1px solid #b8cfb0}
.me{background:#f9e8f1;color:var(--er);border:1px solid #e0ced7}
</style></head><body>
<h1>$title</h1>
$body
</body></html>''';
}