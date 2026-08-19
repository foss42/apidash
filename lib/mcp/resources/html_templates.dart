String getApiDashAppHtml() {
  return r'''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>API Dash Execution Dashboard</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: system-ui, -apple-system, sans-serif; background: var(--host-bg, #0f0f0f); color: var(--host-color, #e0e0e0); padding: 20px; min-height: 400px; }
        .topbar { display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px; }
        .topbar h1 { font-size: 15px; font-weight: 600; color: #a78bfa; display: flex; align-items: center; gap: 8px; }
        .badge { font-size: 11px; font-weight: 600; padding: 3px 9px; border-radius: 20px; }
        .badge.ok  { background: #14532d; color: #86efac; }
        .badge.err { background: #450a0a; color: #fca5a5; }
        .id-badge { font-size: 10px; background: #2a2a2a; color: #9ca3af; padding: 2px 6px; border-radius: 4px; font-family: monospace; font-weight: normal; margin-left: 8px; }
        .grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; margin-bottom: 16px; }
        .card { background: #1a1a1a; border: 1px solid #2a2a2a; border-radius: 10px; padding: 14px 16px; }
        .card .label { font-size: 11px; color: #6b7280; text-transform: uppercase; margin-bottom: 6px; }
        .card .value { font-size: 22px; font-weight: 600; color: #e5e7eb; }
        .section { background: #1a1a1a; border: 1px solid #2a2a2a; border-radius: 10px; padding: 16px; margin-bottom: 12px; }
        .section-title { font-size: 12px; font-weight: 600; color: #6b7280; text-transform: uppercase; margin-bottom: 12px; }
        .url-row { display: flex; align-items: center; gap: 10px; padding: 10px 12px; background: #111; border-radius: 8px; border: 1px solid #2a2a2a; }
        .method-pill { font-size: 11px; font-weight: 700; padding: 3px 8px; border-radius: 6px; background: #1e3a5f; color: #60a5fa; }
        .url-text { font-size: 13px; color: #9ca3af; font-family: monospace; word-break: break-all; }
        .body-pre { background: #111; border-radius: 8px; padding: 14px; font-size: 12px; font-family: monospace; color: #d1d5db; overflow-x: auto; white-space: pre-wrap; word-break: break-all; border: 1px solid #2a2a2a; max-height: 240px; overflow-y: auto;}
    </style>
</head>
<body>

<div class="topbar">
    <h1>⚡ API Dash <span class="id-badge" id="req-id">Loading...</span></h1>
    <span class="badge ok" id="status-badge" style="background:#374151; color:#9ca3af;">Loading Data...</span>
</div>

<div class="grid">
    <div class="card"><div class="label">Status</div><div class="value" id="stat-status">—</div></div>
    <div class="card"><div class="label">Time</div><div class="value" id="stat-time">—</div></div>
    <div class="card"><div class="label">Size</div><div class="value" id="stat-size">—</div></div>
</div>

<div class="section">
    <div class="section-title">🔗 Request</div>
    <div class="url-row">
        <span class="method-pill" id="req-method">—</span>
        <span class="url-text" id="req-url">—</span>
    </div>
</div>

<div class="section">
    <div class="section-title">📄 Response body</div>
    <pre class="body-pre" id="body-pre">Fetching from backend engine...</pre>
</div>

<script>
    let currentDisplayedId = null;

    function hydrate(data) {
        if (!data) return;
        // Skip updating the UI if the execution ID hasn't changed
        if (currentDisplayedId === data.execution_id) return;
        currentDisplayedId = data.execution_id;

        const code = data.status_code || 0;
        const ok = code >= 200 && code < 300;

        if (data.execution_id) {
            document.getElementById('req-id').textContent = data.execution_id;
        }

        document.getElementById('stat-status').textContent = code;
        document.getElementById('stat-status').style.color = ok ? '#4ade80' : '#f87171';
        document.getElementById('stat-time').textContent = (data.time_ms || 0) + ' ms';
        
        let bodyStr = data.response_body || 'No Body';
        try { bodyStr = JSON.stringify(JSON.parse(bodyStr), null, 2); } catch(e) {}
        document.getElementById('body-pre').textContent = bodyStr;

        const bytes = new Blob([bodyStr]).size;
        document.getElementById('stat-size').textContent = bytes < 1024 ? bytes + ' B' : (bytes / 1024).toFixed(1) + ' KB';

        const badge = document.getElementById('status-badge');
        badge.textContent = code + (ok ? ' OK' : ' Error');
        badge.className = 'badge ' + (ok ? 'ok' : 'err');
        badge.style = ''; 

        if (data.method) document.getElementById('req-method').textContent = data.method.toUpperCase();
        if (data.url) document.getElementById('req-url').textContent = data.url;
    }

    async function fetchResults() {
        try {
            // "Blind Args" trick: NO execution_id is passed, forcing the server to get the latest
            // We pass a Date.now() cache buster so VS Code actually makes the network request
            const blindArgs = { _cache_buster: Date.now().toString() };

            if (typeof request === 'function') {
                const res = await request("tools/call", {
                    name: "apidash_get_results",
                    arguments: blindArgs 
                });
                
                if (res && res.structuredContent) {
                    hydrate(res.structuredContent);
                } else if (res && res.result && res.result.structuredContent) {
                    hydrate(res.result.structuredContent);
                }
            } else {
                const id = Math.random().toString(36).substring(7);
                const handler = (event) => {
                    const msg = event.data;
                    if (msg && msg.jsonrpc === '2.0' && msg.id === id) {
                        window.removeEventListener('message', handler);
                        hydrate(msg.result?.structuredContent || msg.result);
                    }
                };
                
                window.addEventListener('message', handler);
                window.parent.postMessage({
                    jsonrpc: '2.0',
                    id: id,
                    method: 'tools/call',
                    params: { name: 'apidash_get_results', arguments: blindArgs }
                }, '*');
            }
        } catch (e) {
            // Silently fail on background polls to prevent flashing errors
        }
    }

    // Fetch immediately on load
    setTimeout(fetchResults, 100);
    
    // Poll the server every 1.5 seconds. 
    // This updates the panel automatically when Claude runs a new request!
    setInterval(fetchResults, 1500);
</script>
</body>
</html>
''';
}

String getHistoryAppHtml() {
  return r'''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>API Dash History</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: system-ui, -apple-system, sans-serif; background: var(--host-bg, #0f0f0f); color: var(--host-color, #e0e0e0); padding: 20px; }
        .topbar { margin-bottom: 20px; border-bottom: 1px solid #2a2a2a; padding-bottom: 10px; }
        .topbar h1 { font-size: 16px; font-weight: 600; color: #a78bfa; }
        .history-list { display: flex; flex-direction: column; gap: 10px; }
        .history-card { background: #1a1a1a; border: 1px solid #2a2a2a; border-radius: 8px; padding: 12px; display: flex; align-items: center; justify-content: space-between; transition: background 0.2s; }
        .history-card:hover { background: #222; }
        .req-info { display: flex; align-items: center; gap: 12px; flex-grow: 1; overflow: hidden; }
        .method { font-size: 11px; font-weight: 700; padding: 3px 8px; border-radius: 4px; background: #1e3a5f; color: #60a5fa; min-width: 45px; text-align: center; }
        .url { font-size: 13px; font-family: monospace; color: #d1d5db; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 300px; }
        .stats { display: flex; gap: 15px; font-size: 12px; color: #9ca3af; min-width: 150px; }
        .status.ok { color: #4ade80; }
        .status.err { color: #f87171; }
        .delete-btn { background: #450a0a; color: #fca5a5; border: 1px solid #7f1d1d; border-radius: 6px; padding: 6px 12px; font-size: 11px; font-weight: 600; cursor: pointer; transition: all 0.2s; }
        .delete-btn:hover { background: #7f1d1d; color: #fff; }
        .empty-state { text-align: center; color: #6b7280; font-size: 13px; padding: 30px; }
        .loading { font-size: 13px; color: #9ca3af; }
    </style>
</head>
<body>

<div class="topbar">
    <h1>Request History</h1>
</div>

<div id="loading" class="loading">Fetching history...</div>
<div id="history-container" class="history-list"></div>

<script>
    async function executeMcpTool(name, args) {
        if (typeof request === 'function') {
            return await request("tools/call", { name, arguments: args });
        } else {
            return new Promise((resolve) => {
                const id = Math.random().toString(36).substring(7);
                const handler = (event) => {
                    const msg = event.data;
                    if (msg && msg.jsonrpc === '2.0' && msg.id === id) {
                        window.removeEventListener('message', handler);
                        resolve(msg.result);
                    }
                };
                window.addEventListener('message', handler);
                window.parent.postMessage({ jsonrpc: '2.0', id: id, method: 'tools/call', params: { name, arguments: args } }, '*');
            });
        }
    }

    async function loadHistory() {
        document.getElementById('loading').style.display = 'block';
        document.getElementById('history-container').innerHTML = '';
        
        try {
            // 🔴 We pass Date.now() so VS Code never caches this request
            const rawRes = await executeMcpTool("apidash_list_history", { _cache_buster: Date.now().toString() });
            document.getElementById('loading').style.display = 'none';
            
            let historyArray = [];
            
            // 🔴 Bulletproof parsing tree
            if (rawRes) {
                if (Array.isArray(rawRes)) {
                    historyArray = rawRes;
                } else if (Array.isArray(rawRes.structuredContent)) {
                    historyArray = rawRes.structuredContent;
                } else if (rawRes.result && Array.isArray(rawRes.result.structuredContent)) {
                    historyArray = rawRes.result.structuredContent;
                } else {
                    // Fallback to strict string parsing without Regex
                    let textToParse = "";
                    if (typeof rawRes === 'string') textToParse = rawRes;
                    else if (rawRes.content && rawRes.content[0]) textToParse = rawRes.content[0].text;
                    else if (rawRes.result && rawRes.result.content && rawRes.result.content[0]) textToParse = rawRes.result.content[0].text;
                    
                    if (textToParse) {
                        const start = textToParse.indexOf('[');
                        const end = textToParse.lastIndexOf(']');
                        if (start !== -1 && end !== -1) {
                            try { historyArray = JSON.parse(textToParse.substring(start, end + 1)); } catch(e) {}
                        }
                    }
                }
            }

            renderHistory(historyArray);
        } catch (e) {
            document.getElementById('loading').textContent = "❌ Failed to load history.";
        }
    }

    function renderHistory(historyArray) {
        const container = document.getElementById('history-container');
        if (!historyArray || historyArray.length === 0) {
            container.innerHTML = '<div class="empty-state">No requests found in history.</div>';
            return;
        }

        historyArray.forEach(req => {
            const isOk = req.status >= 200 && req.status < 300;
            const card = document.createElement('div');
            card.className = 'history-card';
            card.innerHTML = `
                <div class="req-info">
                    <span class="method">${req.method}</span>
                    <span class="url" title="${req.url}">${req.url}</span>
                </div>
                <div class="stats">
                    <span class="status ${isOk ? 'ok' : 'err'}">${req.status}</span>
                    <span>${req.time_ms || 0} ms</span>
                </div>
                <button class="delete-btn" onclick="deleteItem('${req.execution_id}')">Delete</button>
            `;
            container.appendChild(card);
        });
    }

    window.deleteItem = async function(id) {
        const btn = event.target;
        btn.textContent = "Deleting...";
        btn.style.opacity = "0.5";
        await executeMcpTool("apidash_delete_request", { execution_id: id });
        await loadHistory(); 
    };

    window.onload = () => setTimeout(loadHistory, 250);
</script>
</body>
</html>
''';
}