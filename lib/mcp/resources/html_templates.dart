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
        body { font-family: system-ui, -apple-system, sans-serif; background: var(--host-bg, #0f0f0f); color: var(--host-color, #e0e0e0); padding: 20px; overflow-y: auto; }
        .topbar { margin-bottom: 20px; border-bottom: 1px solid #2a2a2a; padding-bottom: 10px; }
        .topbar h1 { font-size: 16px; font-weight: 600; color: #a78bfa; }
        .history-list { display: flex; flex-direction: column; gap: 10px; }
        .history-card { background: #1a1a1a; border: 1px solid #2a2a2a; border-radius: 8px; padding: 12px; display: flex; align-items: center; justify-content: space-between; transition: background 0.2s; }
        .history-card:hover { background: #222; }
        .req-info { display: flex; align-items: center; gap: 12px; flex-grow: 1; overflow: hidden; cursor: pointer; }
        .req-info:hover .url { color: #60a5fa; text-decoration: underline; }
        .method { font-size: 11px; font-weight: 700; padding: 3px 8px; border-radius: 4px; background: #1e3a5f; color: #60a5fa; min-width: 45px; text-align: center; }
        .url { font-size: 13px; font-family: monospace; color: #d1d5db; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 300px; }
        .stats { display: flex; gap: 15px; font-size: 12px; color: #9ca3af; min-width: 150px; align-items: center; justify-content: flex-end; }
        .status.ok { color: #4ade80; font-weight: bold; }
        .status.err { color: #f87171; font-weight: bold; }
        .delete-btn { background: #450a0a; color: #fca5a5; border: 1px solid #7f1d1d; border-radius: 6px; padding: 5px 10px; font-size: 11px; font-weight: 600; cursor: pointer; transition: all 0.2s; }
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
            const rawRes = await executeMcpTool("apidash_list_history", { _cache_buster: Date.now().toString() });
            document.getElementById('loading').style.display = 'none';
            
            let historyArray = [];
            if (rawRes) {
                if (Array.isArray(rawRes)) {
                    historyArray = rawRes;
                } else if (Array.isArray(rawRes.structuredContent)) {
                    historyArray = rawRes.structuredContent;
                } else if (rawRes.result && Array.isArray(rawRes.result.structuredContent)) {
                    historyArray = rawRes.result.structuredContent;
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
                <div class="req-info" onclick="window.parent.postMessage({ type: 'HYDRATE_HISTORIC_RUN', id: '${req.execution_id}' }, '*')">
                    <span class="method">${req.method}</span>
                    <span class="url" title="${req.url}">${req.url}</span>
                </div>
                <div class="stats">
                    <span class="status ${isOk ? 'ok' : 'err'}">${req.status}</span>
                    <span>${req.time_ms || 0} ms</span>
                    <button class="delete-btn" onclick="deleteItem('${req.execution_id}', event)">Delete</button>
                </div>
            `;
            container.appendChild(card);
        });
    }

    window.deleteItem = async function(id, event) {
        event.stopPropagation();
        const btn = event.target;
        btn.textContent = "Deleting..."; btn.style.opacity = "0.5";
        await executeMcpTool("apidash_delete_request", { execution_id: id });
        await loadHistory(); 
    };

    window.onload = () => setTimeout(loadHistory, 250);
</script>
</body>
</html>
''';
}

String getApiDashWorkbenchHtml() {
  return r'''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>API Dash Studio SPA</title>
  <style>
    :root {
      --bg-canvas: var(--vscode-editor-background, #0e1117);
      --bg-input: var(--vscode-input-background, #141822);
      --bg-surface: var(--vscode-sideBar-background, #141822);
      --bg-surface-hover: var(--vscode-list-hoverBackground, #222938);

      --bg-header: var(--vscode-editorGroupHeader-tabsBackground, #0e1117);
      --bg-tab-active: var(--vscode-tab-activeBackground, #141822);
      --bg-tab-hover: var(--vscode-tab-hoverBackground, rgba(255, 255, 255, 0.05));
      
      --text-main: var(--vscode-editor-foreground, #f1f5f9);
      --text-muted: var(--vscode-input-placeholderForeground, #64748b);
      --text-label: var(--vscode-descriptionForeground, #94a3b8);
      --text-tab-active: var(--vscode-tab-activeForeground, #f1f5f9);
      --text-tab-inactive: var(--vscode-tab-inactiveForeground, #64748b);

      --border-color: var(--vscode-input-border, #242b3b);
      --border-hover: var(--vscode-focusBorder, #3b82f6);
      --border-divider: var(--vscode-editorGroupHeader-tabsBorder, #242b3b);
      --border-active-tab: var(--vscode-tab-activeBorder, var(--vscode-focusBorder, #93c5fd));

      --btn-send-bg: var(--vscode-button-background, #93c5fd);
      --btn-send-text: var(--vscode-button-foreground, #0f172a);
      --btn-send-hover: var(--vscode-button-hoverBackground, #bfdbfe);

      --http-get: var(--vscode-terminal-ansiBrightGreen, #4ade80);
      --http-head: var(--vscode-terminal-ansiGreen, #86efac);
      --http-post: var(--vscode-terminal-ansiBrightBlue, #60a5fa);
      --http-put: var(--vscode-terminal-ansiBrightYellow, #fbbf24);
      --http-patch: var(--vscode-terminal-ansiYellow, #fb923c);
      --http-delete: var(--vscode-terminal-ansiBrightRed, #f87171);
      --http-options: var(--vscode-terminal-ansiBrightMagenta, #c084fc);

      --font-mono: var(--vscode-editor-font-family, "JetBrains Mono", Consolas, monospace);
    }

    /* 1. SCROLL LIBERATOR: Unbounded downward flow */
    body, html {
      margin: 0; padding: 0; width: 100%; min-height: 100vh; height: auto;
      background-color: var(--bg-canvas);
      font-family: var(--vscode-font-family, -apple-system, sans-serif);
      color: var(--text-main); overflow-y: auto; overflow-x: hidden;
      display: flex; flex-direction: column; box-sizing: border-box;
    }

    /* Sticky Roof Tabs */
    .ad-nav-viewport {
      container-type: inline-size; container-name: topnav;
      width: 100%; border-bottom: 1px solid var(--border-divider);
      background-color: var(--bg-header); flex-shrink: 0;
      position: sticky; top: 0; z-index: 1000;
    }

    .ad-tab-strip { display: flex; width: 100%; max-width: 800px; margin: 0 auto; padding: 0 8px; box-sizing: border-box; }

    .ad-tab {
      flex: 1; display: flex; align-items: center; justify-content: center; gap: 8px;
      height: 42px; background: transparent; border: none; border-bottom: 2px solid transparent;
      color: var(--text-tab-inactive); font-size: 13px; font-weight: 500; cursor: pointer;
      transition: all 0.1s ease; box-sizing: border-box; user-select: none;
    }
    .ad-tab:hover:not(.active) { background-color: var(--bg-tab-hover); color: var(--text-tab-active); }
    .ad-tab.active {
      background-color: var(--bg-tab-active); color: var(--text-tab-active);
      border-bottom-color: var(--border-active-tab); font-weight: 600;
    }
    .ad-tab svg { width: 16px; height: 16px; fill: currentColor; flex-shrink: 0; }
    .ad-tab.active svg { fill: var(--border-active-tab); }

    /* Main SPA Canvas */
    .ad-workbench-viewport {
      container-type: inline-size; container-name: reqbar;
      width: 100%; max-width: 740px; margin: 12px auto 0 auto;
      padding: 0 14px 40px 14px; box-sizing: border-box; flex: 1;
      display: flex; flex-direction: column; height: auto; overflow: visible;
    }

    .ad-pane { display: none; width: 100%; flex-direction: column; gap: 10px; flex: 1; height: auto; overflow: visible; }
    .ad-pane.active { display: flex; }

    /* STUDIO CONTROLS */
    .ad-row-meta { display: flex; justify-content: space-between; align-items: center; gap: 12px; width: 100%; flex-shrink: 0; }
    .ad-meta-cluster { display: flex; align-items: center; gap: 8px; }

    .ad-pill {
      display: flex; align-items: center; gap: 6px;
      background: var(--bg-surface); border: 1px solid var(--border-color);
      padding: 4px 10px; border-radius: 6px; font-size: 12px; font-weight: 500;
      cursor: pointer; user-select: none; color: var(--text-main);
    }
    .ad-pill:hover { border-color: var(--border-hover); }
    .ad-carets { display: inline-flex; flex-direction: column; font-size: 8px; line-height: 0.8; color: var(--text-muted); }
    .ad-req-title { font-size: 13px; color: var(--text-label); white-space: nowrap; }

    .ad-icon-bar { display: flex; background: var(--bg-surface); border: 1px solid var(--border-color); border-radius: 6px; }
    .ad-icon-bar button { background: transparent; border: none; border-right: 1px solid var(--border-color); padding: 4px 10px; cursor: pointer; display: grid; place-items: center; color: var(--text-muted); }
    .ad-icon-bar button:last-child { border-right: none; }
    .ad-icon-bar button:hover { background: var(--bg-surface-hover); color: var(--text-main); }
    .ad-icon-bar button svg { width: 14px; height: 14px; fill: currentColor; }

    /* PINNED REQUEST BAR (Always Visible) */
    .ad-row-url {
      position: relative; display: flex; align-items: center; width: 100%; flex-shrink: 0;
      background: var(--bg-input); border: 1px solid var(--border-color);
      border-radius: 8px; padding: 4px 5px 4px 12px; box-sizing: border-box;
    }
    .ad-row-url:focus-within { border-color: var(--border-hover); box-shadow: 0 0 0 1px var(--border-hover); }

    .ad-method-box { position: relative; user-select: none; flex-shrink: 0; }
    .ad-method-display { display: flex; align-items: center; gap: 6px; font-family: var(--font-mono); font-weight: 700; font-size: 13px; cursor: pointer; padding-right: 6px; margin: 0; }

    .ad-dropdown-menu {
      position: absolute; top: 100%; left: -12px; margin-top: 8px;
      background: var(--bg-surface); border: 1px solid var(--border-color);
      border-radius: 8px; box-shadow: 0 12px 28px rgba(0,0,0,0.6); z-index: 9999; 
      min-width: 140px; padding: 6px 0; display: none; flex-direction: column; font-family: var(--font-mono);
    }
    .ad-method-box.open .ad-dropdown-menu { display: flex; }
    
    .ad-drop-option { padding: 8px 16px; font-size: 12px; font-weight: 700; color: var(--clr); cursor: pointer; text-align: left; }
    .ad-drop-option:hover { background: var(--bg-surface-hover); }
    .ad-drop-option.active { background: var(--bg-surface-hover); border-left: 2px solid var(--clr); padding-left: 14px; }

    .ad-endpoint-input { flex: 1 1 120px; min-width: 120px; width: 100%; background: transparent; border: none; color: var(--text-main); font-family: var(--font-mono); font-size: 13px; padding: 6px 10px; outline: none; }
    .ad-endpoint-input::placeholder { color: var(--text-muted); font-family: sans-serif; }

    .ad-send-btn { flex-shrink: 0; display: flex; align-items: center; gap: 6px; background: var(--btn-send-bg); color: var(--btn-send-text); border: none; font-weight: 600; font-size: 13px; padding: 7px 18px; border-radius: 20px; cursor: pointer; }
    .ad-send-btn:hover { background: var(--btn-send-hover); }
    .ad-send-btn svg { width: 12px; height: 12px; fill: currentColor; }

    /* --- SIBLING DYNAMIC CONTAINERS (Untrapped height) --- */
    .req-builder-card, .res-analyzer-card {
      display: flex; flex-direction: column; width: 100%; margin-top: 4px;
      background: var(--bg-surface); border: 1px solid var(--border-color);
      border-radius: 8px; overflow: visible; height: auto; flex: 1;
    }

    .req-subnav {
      display: flex; align-items: center; justify-content: space-between; flex-shrink: 0;
      border-bottom: 1px solid var(--border-color); padding: 0 12px; height: 36px;
      background: var(--bg-header); border-top-left-radius: 8px; border-top-right-radius: 8px;
    }
    .req-sub-tabs { display: flex; align-items: center; gap: 4px; height: 100%; }
    .req-sub-tab {
      height: 100%; background: transparent; border: none; padding: 0 10px;
      color: var(--text-tab-inactive); font-size: 12px; font-weight: 600;
      cursor: pointer; border-bottom: 2px solid transparent; transition: all 0.1s;
    }
    .req-sub-tab:hover { color: var(--text-main); }
    .req-sub-tab.active { color: var(--text-tab-active); border-bottom-color: var(--border-active-tab); }

    .btn-view-code-sub {
      display: flex; align-items: center; gap: 6px; background: #223044;
      color: #93c5fd; border: 1px solid #2e415c; padding: 3px 8px;
      border-radius: 14px; font-size: 11px; font-weight: 600; cursor: pointer;
    }
    .btn-view-code-sub:hover { background: #2c3e58; color: #fff; }
    .btn-view-code-sub svg { width: 12px; height: 12px; fill: currentColor; }

    .req-sub-viewport { 
      padding: 14px; background: var(--bg-input); 
      height: auto; flex: 1; display: flex; flex-direction: column;
      border-bottom-left-radius: 8px; border-bottom-right-radius: 8px;
    }
    
    .req-sub-pane { display: none; flex-direction: column; gap: 10px; flex: 1; }
    .req-sub-pane.active { display: flex; }

    /* Sub: KV Tables */
    .kv-rows { display: flex; flex-direction: column; gap: 8px; }
    .kv-row { display: flex; align-items: center; gap: 8px; width: 100%; }
    .kv-chk { accent-color: var(--border-hover); width: 15px; height: 15px; cursor: pointer; flex-shrink: 0; }
    .kv-box {
      background: #090c10; border: 1px solid var(--border-color); border-radius: 6px;
      padding: 5px 10px; color: var(--text-main); font-family: var(--font-mono); font-size: 12px; outline: none;
    }
    .kv-box.k { flex: 1; } .kv-box.v { flex: 1.5; }
    .kv-box:focus { border-color: var(--border-hover); }
    .kv-sep { color: var(--text-muted); font-family: var(--font-mono); font-size: 13px; font-weight: bold; }
    .kv-del { background: transparent; border: none; color: #f43f5e; cursor: pointer; opacity: 0.6; padding: 2px; }
    .kv-del:hover { opacity: 1; } .kv-del svg { width: 16px; height: 16px; fill: currentColor; }

    .btn-add-row {
      align-self: flex-start; background: #181f2c; border: 1px solid #283348; margin-top: 2px;
      color: #94a3b8; padding: 5px 12px; border-radius: 16px; font-size: 11px; font-weight: 600; cursor: pointer;
    }
    .btn-add-row:hover { background: #222c3e; color: #fff; border-color: #3b82f6; }

    /* Sub: Auth & Toolbars */
    .sub-label { font-size: 11px; font-weight: 700; color: var(--text-label); text-transform: uppercase; letter-spacing: 0.5px; }
    .sub-select {
      background: var(--bg-surface); border: 1px solid var(--border-color); color: var(--text-main);
      padding: 5px 10px; border-radius: 6px; font-size: 12px; font-weight: 500; outline: none; cursor: pointer;
    }
    .sub-select:focus { border-color: var(--border-hover); }
    .auth-notice { font-size: 13px; color: var(--text-muted); margin-top: 4px; }

    .sub-toolbar { display: flex; align-items: center; justify-content: space-between; }
    .sub-select.sm { padding: 3px 8px; font-size: 11px; font-family: var(--font-mono); font-weight: 600; }
    
    .btn-learn-sub {
      display: flex; align-items: center; gap: 5px; background: #1b273b; color: #93c5fd;
      border: 1px solid #2d4160; padding: 3px 8px; border-radius: 14px; font-size: 11px; font-weight: 600; cursor: pointer;
    }

    .editor-wrap { position: relative; width: 100%; margin-top: 2px; display: flex; flex: 1; }
    .code-surface {
      width: 100%; min-height: 200px; height: auto; background: #07090e; border: 1px solid var(--border-color);
      border-radius: 8px; padding: 12px; color: #e2e8f0; font-family: var(--font-mono);
      font-size: 12px; line-height: 1.5; resize: vertical; outline: none; box-sizing: border-box;
    }
    .code-surface:focus { border-color: var(--border-hover); }

    /* --- VIEW B: RESULTS FULL CARD (Replaces Builder Canvas) --- */
    .res-top-bar { display: flex; align-items: center; justify-content: space-between; background: #090d14; padding: 10px 14px; border-bottom: 1px solid var(--border-color); border-top-left-radius: 8px; border-top-right-radius: 8px; font-family: var(--font-mono); }
    .res-badge-cluster { display: flex; align-items: center; gap: 12px; }
    
    .btn-exit-results { background: #1e293b; color: #94a3b8; border: 1px solid #334155; padding: 5px 12px; border-radius: 16px; font-weight: 600; font-size: 12px; cursor: pointer; transition: all 0.15s ease; display: flex; align-items: center; gap: 6px; }
    .btn-exit-results:hover { background: #3b82f6; color: #fff; border-color: #60a5fa; }
    .btn-exit-results svg { width: 14px; height: 14px; stroke: currentColor; }

    .res-status-code { font-weight: 700; font-size: 13px; }
    .res-status-code.ok { color: #4ade80; } .res-status-code.err { color: #f87171; }
    .res-meta-stats { display: flex; gap: 16px; font-size: 12px; color: var(--text-label); }
    
    .res-subnav-strip { display: flex; gap: 16px; background: #0e121a; border-bottom: 1px solid var(--border-color); padding: 0 14px; height: 36px; align-items: center; }
    .res-sub-btn { background: transparent; border: none; border-bottom: 2px solid transparent; color: var(--text-muted); font-size: 12px; font-weight: 600; cursor: pointer; height: 100%; padding: 0 4px; }
    .res-sub-btn.active { color: #60a5fa; border-bottom-color: #60a5fa; }

    .res-content-box { background: #05070a; padding: 14px; color: #e2e8f0; font-family: var(--font-mono); font-size: 12px; flex: 1; min-height: 250px; height: auto; border-bottom-left-radius: 8px; border-bottom-right-radius: 8px; }
    .res-payload-pre { white-space: pre-wrap; word-break: break-all; margin: 0; font-family: inherit; }

    /* HISTORY LEDGER */
    .ad-hist-header { display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border-color); padding-bottom: 10px; margin-bottom: 4px; }
    .ad-hist-title { font-size: 14px; font-weight: 600; color: var(--text-label); }
    .ad-history-list { display: flex; flex-direction: column; gap: 8px; height: auto; overflow: visible; flex: 1; }
    .ad-hist-card { display: flex; align-items: center; justify-content: space-between; gap: 12px; background: var(--bg-input); border: 1px solid var(--border-color); border-radius: 8px; padding: 10px 12px; transition: border 0.15s; cursor: pointer; }
    .ad-hist-card:hover { border-color: var(--border-hover); }
    .ad-hist-left { display: flex; align-items: center; gap: 10px; min-width: 0; flex: 1; }
    .ad-hist-left:hover .ad-hist-url { color: #60a5fa; text-decoration: underline; }
    .ad-hist-method { font-family: var(--font-mono); font-size: 11px; font-weight: 700; padding: 2px 6px; border-radius: 4px; background: var(--bg-surface-hover); }
    .ad-hist-url { font-family: var(--font-mono); font-size: 12px; color: var(--text-main); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    .ad-hist-right { display: flex; align-items: center; gap: 14px; flex-shrink: 0; font-size: 12px; font-family: var(--font-mono); }
    .ad-hist-delete { background: #450a0a; color: #fca5a5; border: 1px solid #7f1d1d; border-radius: 6px; padding: 5px 10px; font-size: 11px; font-weight: 600; cursor: pointer; transition: all 0.2s; }
    .ad-hist-delete:hover { background: #7f1d1d; color: #fff; }
    .ad-empty-notice { text-align: center; padding: 40px 20px; color: var(--text-muted); font-size: 13px; }

    @container topnav (max-width: 460px) { .ad-tab { flex-direction: column; gap: 3px; height: 48px; font-size: 11px; padding: 4px 2px; } .ad-tab svg { width: 15px; height: 15px; } }
    @container reqbar (max-width: 480px) { .ad-req-title { max-width: 60px; overflow: hidden; text-overflow: ellipsis; } .ad-endpoint-input { font-size: 11px; } .ad-send-btn { padding: 6px 14px; font-size: 12px; } }
  </style>
</head>
<body>

<div class="ad-nav-viewport">
  <nav class="ad-tab-strip">
    <button class="ad-tab active" data-pane="pane-studio"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M3 5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5zm2 0v14h6V5H5zm8 0v6h6V5h-6zm0 8v6h6v-6h-6z"/></svg><span>Requests</span></button>
    <button class="ad-tab" data-pane="pane-vars"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M20 16V6H4v10h16zM4 4h16a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2zm-2 16h20v2H2v-2z"/></svg><span>Variables</span></button>
    <button class="ad-tab" data-pane="pane-history"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M13 3a9 9 0 0 0-9 9H1l3.89 3.89.07.14L9 12H6c0-3.87 3.13-7 7-7s7 3.13 7 7-3.13 7-7 7c-1.93 0-3.68-.79-4.94-2.06l-1.42 1.42A8.954 8.954 0 0 0 13 21a9 9 0 0 0 0-18zm-1 5v5l4.25 2.52.75-1.23-3.5-2.07V8h-1.5z"/></svg><span>History</span></button>
    <button class="ad-tab" data-pane="pane-logs"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M20 4H4c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 14H4V6h16v12zM7.5 15l-1.41-1.41L9.67 10 6.09 6.41 7.5 5l5 5-5 5zm6 0h5v-2h-5v2z"/></svg><span>Logs</span></button>
  </nav>
</div>

<main class="ad-workbench-viewport" id="workbenchCanvas">
  
  <div id="pane-studio" class="ad-pane active">
    <div class="ad-row-meta">
      <div class="ad-meta-cluster"><div class="ad-pill">HTTP <span class="ad-carets">▲<br>▼</span></div><span class="ad-req-title" title="untitled">untitled</span></div>
      <div class="ad-meta-cluster">
        <div class="ad-icon-bar">
          <button title="Edit"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/></svg></button>
          <button title="Delete"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/></svg></button>
          <button title="Duplicate"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M16 1H4c-1.1 0-2 .9-2 2v14h2V3h12V1zm3 4H8c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h11c1.1 0 2-.9 2-2V7c0-1.1-.9-2-2-2zm0 16H8V7h11v14z"/></svg></button>
        </div>
        <div class="ad-pill">Global <span class="ad-carets">▲<br>▼</span></div>
      </div>
    </div>
    
    <div class="ad-row-url">
      <div class="ad-method-box" id="methodBox">
        <div class="ad-method-display" id="methodDisplay" style="color: var(--http-get)"><span id="methodText">GET</span><span class="ad-carets" style="margin-left:2px">▲<br>▼</span></div>
        <div class="ad-dropdown-menu">
          <div class="ad-drop-option active" data-val="GET"     style="--clr: var(--http-get)">GET</div>
          <div class="ad-drop-option"        data-val="HEAD"    style="--clr: var(--http-head)">HEAD</div>
          <div class="ad-drop-option"        data-val="POST"    style="--clr: var(--http-post)">POST</div>
          <div class="ad-drop-option"        data-val="PUT"     style="--clr: var(--http-put)">PUT</div>
          <div class="ad-drop-option"        data-val="PATCH"   style="--clr: var(--http-patch)">PATCH</div>
          <div class="ad-drop-option"        data-val="DELETE"  style="--clr: var(--http-delete)">DELETE</div>
          <div class="ad-drop-option"        data-val="OPTIONS" style="--clr: var(--http-options)">OPTIONS</div>
        </div>
      </div>

      <input type="text" class="ad-endpoint-input" id="reqUrlInput" placeholder="Enter API endpoint..." spellcheck="false">
      <button class="ad-send-btn" id="btnFireRequest"><span>Send</span><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z"/></svg></button>
    </div>

    <div class="req-builder-card" id="builderCardCanvas">
      <div class="req-subnav">
        <div class="req-sub-tabs">
          <button class="req-sub-tab active" data-sub="sub-params">Params</button>
          <button class="req-sub-tab" data-sub="sub-auth">Auth</button>
          <button class="req-sub-tab" data-sub="sub-headers">Headers</button>
          <button class="req-sub-tab" data-sub="sub-body">Body</button>
          <button class="req-sub-tab" data-sub="sub-scripts">Scripts</button>
        </div>
        <button class="btn-view-code-sub">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M9.4 16.6L4.8 12l4.6-4.6L8 6l-6 6 6 6 1.4-1.4zm5.2 0l4.6-4.6-4.6-4.6L16 6l6 6-6 6-1.4-1.4z"/></svg>
          <span>View Code</span>
        </button>
      </div>

      <div class="req-sub-viewport">
        <div id="sub-params" class="req-sub-pane active">
          <div class="kv-rows" id="paramsList">
            <div class="kv-row">
              <input type="checkbox" class="kv-chk" checked>
              <input type="text" class="kv-box k" placeholder="Add URL Parameter...">
              <span class="kv-sep">=</span>
              <input type="text" class="kv-box v" placeholder="Add Value">
              <button class="kv-del" title="Delete"><svg viewBox="0 0 24 24"><path d="M15 12H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z" stroke="currentColor" stroke-width="2" fill="none"/></svg></button>
            </div>
          </div>
          <button class="btn-add-row" onclick="addKvRow('paramsList', 'Add URL Parameter...')">+ Add Param</button>
        </div>

        <div id="sub-auth" class="req-sub-pane">
          <div style="display:flex; flex-direction:column; gap:6px; max-width:220px;">
            <label class="sub-label">Authentication Type</label>
            <select class="sub-select" id="authSelectProxy">
              <option selected>None</option>
              <option>Basic Auth</option>
              <option>API Key</option>
              <option>Bearer Token</option>
              <option>JWT Bearer</option>
              <option>Digest Auth</option>
              <option>OAuth 1.0</option>
              <option>OAuth 2.0</option>
            </select>
          </div>
          <div class="auth-notice" id="authHelperText">No authentication selected.</div>
        </div>

        <div id="sub-headers" class="req-sub-pane">
          <div class="kv-rows" id="headersList">
            <div class="kv-row">
              <input type="checkbox" class="kv-chk" checked>
              <input type="text" class="kv-box k" placeholder="Add Name">
              <span class="kv-sep">=</span>
              <input type="text" class="kv-box v" placeholder="Add Value">
              <button class="kv-del" title="Delete"><svg viewBox="0 0 24 24"><path d="M15 12H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z" stroke="currentColor" stroke-width="2" fill="none"/></svg></button>
            </div>
          </div>
          <button class="btn-add-row" onclick="addKvRow('headersList', 'Add Name')">+ Add Header</button>
        </div>

        <div id="sub-body" class="req-sub-pane">
          <div class="sub-toolbar">
            <span class="sub-label" style="color:var(--text-muted); text-transform:none">Select Content Type:</span>
            <select class="sub-select sm">
              <option selected>json</option>
              <option>text</option>
              <option>formdata</option>
            </select>
          </div>
          <div class="editor-wrap">
            <textarea class="code-surface" id="reqBodyTextarea" placeholder="Enter JSON"></textarea>
          </div>
        </div>

        <div id="sub-scripts" class="req-sub-pane">
          <div class="sub-toolbar">
            <select class="sub-select sm" style="width:130px;">
              <option selected>Pre Request</option>
              <option>Post Response</option>
            </select>
            <button class="btn-learn-sub"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="12" height="12"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 16h-2v-2h2v2zm1.07-7.75l-.9.92C12.45 11.9 12 12.5 12 14h-2v-.5c0-1.1.45-2.1 1.17-2.83l1.24-1.26c.37-.36.59-.86.59-1.41 0-1.1-.9-2-2-2s-2 .9-2 2H7c0-2.76 2.24-5 5-5s5 2.24 5 5c0 1.04-.42 1.99-1.07 2.75z" fill="currentColor"/></svg><span>Learn</span></button>
          </div>
          <div class="editor-wrap">
            <textarea class="code-surface" placeholder="// Write execution hooks here..."></textarea>
          </div>
        </div>
      </div>
    </div>

    <div class="res-analyzer-card" id="resultsCardCanvas" style="display: none;">
      <div class="res-top-bar">
        <div class="res-badge-cluster">
          <button class="btn-exit-results" onclick="exitResultsView()">
            <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m12 19-7-7 7-7"/><path d="M19 12H5"/></svg>
            <span>Back to Builder</span>
          </button>
          <span class="res-status-code ok" id="resStatusCodeLabel">200: OK</span>
        </div>
        <div class="res-meta-stats">
          <span id="resTimeLabel">0 ms</span>
          <span id="resSizeLabel">0 B</span>
        </div>
      </div>

      <div class="res-subnav-strip">
        <button class="res-sub-btn active" onclick="switchResSub('body')">Response Body</button>
        <button class="res-sub-btn" onclick="switchResSub('headers')">Response Headers</button>
      </div>

      <div id="resViewBodyWrapper" class="res-content-box" style="display:flex;">
        <pre class="res-payload-pre" id="resPayloadPre">No response body loaded.</pre>
      </div>
      <div id="resViewHeadersWrapper" class="res-content-box" style="display:none; color:var(--text-label);">
        <div id="resHeadersContainer">No custom headers captured in this response.</div>
      </div>
    </div>

  </div>

  <div id="pane-vars" class="ad-pane"><div class="ad-empty-notice">Environment Variables view coming soon...</div></div>

  <div id="pane-history" class="ad-pane">
    <div class="ad-hist-header"><span class="ad-hist-title">Session Execution Ledger</span><button class="ad-pill" onclick="fetchHistoryLedger()">↻ Refresh</button></div>
    <div id="history-spinner" class="ad-empty-notice">Querying Hive local database...</div>
    <div id="history-feed" class="ad-history-list"></div>
  </div>

  <div id="pane-logs" class="ad-pane"><div class="ad-empty-notice">Agentic event stream coming soon...</div></div>

</main>

<script>
  // --- 1. NAMED ROOF ROUTER ---
  const tabs = document.querySelectorAll('.ad-tab');
  const panes = document.querySelectorAll('.ad-pane');

  function openNamedRoofTab(targetId) {
    tabs.forEach(t => t.classList.remove('active'));
    panes.forEach(p => p.classList.remove('active'));
    document.querySelector(`[data-pane="${targetId}"]`)?.classList.add('active');
    document.getElementById(targetId)?.classList.add('active');
  }

  tabs.forEach(tab => {
    tab.addEventListener('click', () => {
      const target = tab.getAttribute('data-pane');
      openNamedRoofTab(target);
      if (target === 'pane-history') fetchHistoryLedger();
    });
  });

  // --- 2. SUB-WORKBENCH BUILDER ROUTER ---
  const subTabs = document.querySelectorAll('.req-sub-tab');
  const subPanes = document.querySelectorAll('.req-sub-pane');

  subTabs.forEach(tab => {
    tab.addEventListener('click', () => {
      const target = tab.getAttribute('data-sub');
      subTabs.forEach(t => t.classList.remove('active'));
      subPanes.forEach(p => p.classList.remove('active'));
      tab.classList.add('active');
      document.getElementById(target).classList.add('active');
    });
  });

  function addKvRow(listId, phText) {
    const cont = document.getElementById(listId);
    const div = document.createElement('div');
    div.className = 'kv-row';
    div.innerHTML = `
      <input type="checkbox" class="kv-chk" checked>
      <input type="text" class="kv-box k" placeholder="${phText}">
      <span class="kv-sep">=</span>
      <input type="text" class="kv-box v" placeholder="Add Value">
      <button class="kv-del" title="Delete"><svg viewBox="0 0 24 24"><path d="M15 12H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z" stroke="currentColor" stroke-width="2" fill="none"/></svg></button>
    `;
    cont.appendChild(div);
  }

  document.addEventListener('click', (e) => {
    const delBtn = e.target.closest('.kv-del');
    if (delBtn) delBtn.closest('.kv-row').remove();
  });

  document.getElementById('authSelectProxy')?.addEventListener('change', (e) => {
    const label = document.getElementById('authHelperText');
    if (!label) return;
    if (e.target.value === 'None') label.textContent = "No authentication selected.";
    else label.textContent = `Configure ${e.target.value} credentials below...`;
  });

  // --- 3. METHOD PICKER ---
  const mBox = document.getElementById('methodBox');
  const mDisp = document.getElementById('methodDisplay');
  const mText = document.getElementById('methodText');
  const mOpts = document.querySelectorAll('.ad-drop-option');

  mDisp.addEventListener('click', (e) => {
    e.stopPropagation();
    mBox.classList.toggle('open');
  });

  mOpts.forEach(opt => {
    opt.addEventListener('click', (e) => {
      const val = e.target.getAttribute('data-val');
      const clr = getComputedStyle(e.target).getPropertyValue('--clr');
      mText.innerText = val;
      mDisp.style.color = clr;
      mOpts.forEach(o => o.classList.remove('active'));
      e.target.classList.add('active');
      mBox.classList.remove('open');
    });
  });

  document.addEventListener('click', (e) => {
    if (!mBox.contains(e.target)) mBox.classList.remove('open');
  });

  // --- 4. DART RPC BRIDGE ---
  async function executeDartTool(name, args) {
    if (typeof request === 'function') return await request("tools/call", { name, arguments: args });
    return new Promise((resolve) => {
      const id = Math.random().toString(36).substring(7);
      const handler = (e) => { if (e.data?.id === id) { window.removeEventListener('message', handler); resolve(e.data.result); } };
      window.addEventListener('message', handler);
      window.parent.postMessage({ jsonrpc: '2.0', id, method: 'tools/call', params: { name, arguments: args } }, '*');
    });
  }

  // --- 5. DIRECT-TO-METAL SEND & SIBLING VIEW TOGGLE ---
  let trackedExecutionId = null;

  document.getElementById('btnFireRequest').addEventListener('click', async () => {
    const url = document.getElementById('reqUrlInput').value.trim();
    if (!url) return alert("Please specify a target URL endpoint.");

    const method = document.getElementById('methodText').innerText;
    const body = document.getElementById('reqBodyTextarea').value;

    let headers = {};
    document.querySelectorAll('#headersList .kv-row').forEach(row => {
      const isChecked = row.querySelector('.kv-chk')?.checked;
      const key = row.querySelector('.kv-box.k')?.value.trim();
      const val = row.querySelector('.kv-box.v')?.value.trim();
      if (isChecked && key) headers[key] = val;
    });

    renderHydratedResults({ status_code: 0, time_ms: 0, response_body: "Executing HTTP request directly over socket..." });

    // ⚡ BYPASS AI PERMISSION SLIP. Hit the execution tool directly:
    const res = await executeDartTool("apidash_execute_request", {
      url, 
      method, 
      headers: Object.keys(headers).length > 0 ? headers : undefined,
      body: body ? body : undefined
    });

    const payload = res?.structuredContent || res?.result?.structuredContent;
    if (payload && payload.execution_id) {
      trackedExecutionId = payload.execution_id;
      renderHydratedResults(payload);
    }
  });

  function renderHydratedResults(data) {
    document.getElementById('builderCardCanvas').style.display = 'none';
    const resCard = document.getElementById('resultsCardCanvas');
    resCard.style.display = 'flex';

    const code = data.status_code || 0;
    const isOk = code >= 200 && code < 300;

    const lblCode = document.getElementById('resStatusCodeLabel');
    if (code === 0) {
      lblCode.textContent = "⚡ FETCHING...";
      lblCode.className = "res-status-code";
      lblCode.style.color = "#fbbf24";
    } else {
      lblCode.textContent = `${code}: ${isOk ? 'OK' : 'ERROR'}`;
      lblCode.className = `res-status-code ${isOk ? 'ok' : 'err'}`;
      lblCode.style.color = isOk ? "#4ade80" : "#f87171";
    }

    document.getElementById('resTimeLabel').textContent = (data.time_ms || 0) + ' ms';

    let rawBody = data.response_body || 'No response body loaded.';
    let cleanBody = rawBody;
    try { cleanBody = JSON.stringify(JSON.parse(rawBody), null, 2); } catch(e) {}
    document.getElementById('resPayloadPre').textContent = cleanBody;

    const sizeB = new Blob([cleanBody]).size;
    document.getElementById('resSizeLabel').textContent = sizeB < 1024 ? `${sizeB} B` : `${(sizeB / 1024).toFixed(2)} KB`;
  }

  window.exitResultsView = function() {
    document.getElementById('resultsCardCanvas').style.display = 'none';
    document.getElementById('builderCardCanvas').style.display = 'flex';
  };

  window.switchResSub = function(target) {
    const btns = document.querySelectorAll('.res-subnav-strip .res-sub-btn');
    if (target === 'body') {
      btns[0].classList.add('active'); btns[1].classList.remove('active');
      document.getElementById('resViewBodyWrapper').style.display = 'flex';
      document.getElementById('resViewHeadersWrapper').style.display = 'none';
    } else {
      btns[1].classList.add('active'); btns[0].classList.remove('active');
      document.getElementById('resViewBodyWrapper').style.display = 'none';
      document.getElementById('resViewHeadersWrapper').style.display = 'block';
    }
  };

  // --- 6. HISTORY TELEPORTER (Listens for clicks from the History iframe) ---
  window.addEventListener('message', async (event) => {
    const msg = event.data;
    if (msg && msg.type === 'HYDRATE_HISTORIC_RUN') {
      openNamedRoofTab('pane-studio');
      renderHydratedResults({ status_code: 0, time_ms: 0, response_body: "Querying Hive DB for historical run..." });

      const res = await executeDartTool("apidash_get_results", { execution_id: msg.id });
      const payload = res?.structuredContent || res?.result?.structuredContent;

      if (payload) {
        if (payload.url) document.getElementById('reqUrlInput').value = payload.url;
        if (payload.method) {
          document.getElementById('methodText').innerText = payload.method.toUpperCase();
          document.getElementById('methodDisplay').style.color = `var(--http-${payload.method.toLowerCase()}, var(--http-get))`;
        }
        renderHydratedResults(payload);
      }
    }
  });

  // Internal History clicker (for pane-history inside the studio itself)
  window.openHistoryResult = async function(id) {
    openNamedRoofTab('pane-studio');
    renderHydratedResults({ status_code: 0, time_ms: 0, response_body: "Loading execution record from Hive..." });
    
    try {
      const res = await executeDartTool("apidash_get_results", { execution_id: id });
      const payload = res?.structuredContent || res?.result?.structuredContent;
      if (payload) {
        if (payload.url) document.getElementById('reqUrlInput').value = payload.url;
        if (payload.method) {
          document.getElementById('methodText').innerText = payload.method.toUpperCase();
          document.getElementById('methodDisplay').style.color = `var(--http-${payload.method.toLowerCase()}, var(--http-get))`;
        }
        renderHydratedResults(payload);
      }
    } catch(e) {}
  };

  // Autonomous background poller protected by mutex
  let isPolling = false;
  setInterval(async () => {
    if (isPolling) return;
    isPolling = true;
    try {
      const res = await executeDartTool("apidash_get_results", { _cache_buster: Date.now().toString() });
      const payload = res?.structuredContent || res?.result?.structuredContent;
      if (payload && payload.execution_id && payload.execution_id !== trackedExecutionId) {
        trackedExecutionId = payload.execution_id;
        if (payload.url) document.getElementById('reqUrlInput').value = payload.url;
        if (payload.method) {
          document.getElementById('methodText').innerText = payload.method.toUpperCase();
          document.getElementById('methodDisplay').style.color = `var(--http-${payload.method.toLowerCase()}, var(--http-get))`;
        }
        renderHydratedResults(payload);
      }
    } catch(e) {} finally { isPolling = false; }
  }, 1500);

  // --- 7. HISTORY LEDGER ---
  async function fetchHistoryLedger() {
    const feed = document.getElementById('history-feed');
    const spinner = document.getElementById('history-spinner');
    feed.innerHTML = ''; spinner.style.display = 'block';

    try {
      const payload = await executeDartTool("apidash_list_history", { _cache_buster: Date.now().toString() });
      spinner.style.display = 'none';

      let data = [];
      if (payload) {
        if (Array.isArray(payload)) data = payload;
        else if (Array.isArray(payload.structuredContent)) data = payload.structuredContent;
        else if (Array.isArray(payload.result?.structuredContent)) data = payload.result.structuredContent;
      }

      if (data.length === 0) { feed.innerHTML = '<div class="ad-empty-notice">No requests executed yet.</div>'; return; }

      data.forEach(req => {
        const isOk = req.status >= 200 && req.status < 300;
        const verbClr = `var(--http-${req.method.toLowerCase()}, var(--http-get))`;
        const item = document.createElement('div');
        item.className = 'ad-hist-card';
        item.innerHTML = `
          <div class="ad-hist-left" onclick="openHistoryResult('${req.execution_id}')" title="Click to load into Studio">
            <span class="ad-hist-method" style="color:${verbClr}">${req.method}</span>
            <span class="ad-hist-url">${req.url}</span>
          </div>
          <div class="ad-hist-right">
            <span style="color:${isOk ? 'var(--http-get)' : 'var(--http-delete)'}; font-weight:700">${req.status}</span>
            <span style="color:var(--text-muted)">${req.time_ms || 0}ms</span>
            <button class="ad-hist-delete" onclick="triggerDelete('${req.execution_id}', event)">Delete</button>
          </div>
        `;
        feed.appendChild(item);
      });
    } catch(e) { spinner.textContent = "❌ RPC Bridge Error."; }
  }

  window.triggerDelete = async function(id, event) {
    event.stopPropagation();
    event.currentTarget.style.opacity = '0.3';
    await executeDartTool("apidash_delete_request", { execution_id: id });
    fetchHistoryLedger();
  };
</script>

</body>
</html>
''';
}