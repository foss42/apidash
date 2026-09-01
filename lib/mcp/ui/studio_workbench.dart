import '../utils/host_style_variables.dart';
import '../utils/shared_styles.dart';
import '../utils/rpc_client.dart';
import '../utils/message_handler.dart';

import 'requests_pane.dart';
import 'variables_pane.dart';
import 'history_pane.dart';

class StudioWorkbench {
  static String buildHtml(String activeTab) {
    return '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="color-scheme" content="dark light">
  <title>API Dash Studio SPA</title>
  <style>
    ${HostStyleVariables.css}${SharedStyles.css}

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
    .ad-tab.active { background-color: var(--bg-tab-active); color: var(--text-tab-active); border-bottom-color: var(--border-active-tab); font-weight: 600; }
    .ad-tab svg { width: 16px; height: 16px; fill: currentColor; flex-shrink: 0; }
    .ad-tab.active svg { fill: var(--border-active-tab); }

    .ad-workbench-viewport {
      container-type: inline-size; container-name: reqbar;
      width: 100%; flex: 1;
      display: flex; flex-direction: column; overflow-y: auto; overflow-x: hidden;
    }
    .ad-pane { display: none; width: 100%; flex-direction: column; gap: 10px; flex: 1; height: auto; overflow: visible; }
    .ad-pane.active { display: flex; }

    .ad-row-meta { display: flex; justify-content: space-between; align-items: center; gap: 12px; width: 100%; flex-shrink: 0; }
    .ad-meta-cluster { display: flex; align-items: center; gap: 8px; }
    .ad-pill { display: flex; align-items: center; gap: 6px; background: var(--bg-surface); border: 1px solid var(--border-color); padding: 4px 10px; border-radius: 6px; font-size: 12px; font-weight: 500; cursor: pointer; user-select: none; color: var(--text-main); }
    .ad-pill:hover { border-color: var(--border-hover); }
    .ad-carets { display: inline-flex; flex-direction: column; font-size: 8px; line-height: 0.8; color: var(--text-muted); }
    .ad-req-title { font-size: 13px; color: var(--text-label); white-space: nowrap; }

    .ad-icon-bar { display: flex; background: var(--bg-surface); border: 1px solid var(--border-color); border-radius: 6px; }
    .ad-icon-bar button { background: transparent; border: none; border-right: 1px solid var(--border-color); padding: 4px 10px; cursor: pointer; display: grid; place-items: center; color: var(--text-muted); }
    .ad-icon-bar button:last-child { border-right: none; }
    .ad-icon-bar button:hover { background: var(--bg-surface-hover); color: var(--text-main); }
    .ad-icon-bar button svg { width: 14px; height: 14px; fill: currentColor; }

    .ad-row-url { position: relative; display: flex; align-items: center; width: 100%; flex-shrink: 0; background: var(--bg-input); border: 1px solid var(--border-color); border-radius: 8px; padding: 4px 5px 4px 12px; box-sizing: border-box; }
    .ad-row-url:focus-within { border-color: var(--border-hover); box-shadow: 0 0 0 1px var(--border-hover); }

    .ad-method-box { position: relative; user-select: none; flex-shrink: 0; }
    .ad-method-display { display: flex; align-items: center; gap: 6px; font-family: var(--font-mono); font-weight: 700; font-size: 13px; cursor: pointer; padding-right: 6px; margin: 0; }
    .ad-dropdown-menu { position: absolute; top: 100%; left: -12px; margin-top: 8px; background: var(--bg-surface); border: 1px solid var(--border-color); border-radius: 8px; box-shadow: 0 12px 28px rgba(0,0,0,0.6); z-index: 9999; min-width: 140px; padding: 6px 0; display: none; flex-direction: column; font-family: var(--font-mono); }
    .ad-method-box.open .ad-dropdown-menu { display: flex; }
    .ad-drop-option { padding: 8px 16px; font-size: 12px; font-weight: 700; color: var(--clr); cursor: pointer; text-align: left; }
    .ad-drop-option:hover { background: var(--bg-surface-hover); }
    .ad-drop-option.active { background: var(--bg-surface-hover); border-left: 2px solid var(--clr); padding-left: 14px; }

    .ad-endpoint-input { flex: 1 1 120px; min-width: 120px; width: 100%; background: transparent; border: none; color: var(--text-main); font-family: var(--font-mono); font-size: 13px; padding: 6px 10px; outline: none; }
    .ad-endpoint-input::placeholder { color: var(--text-muted); font-family: sans-serif; }
    .ad-send-btn { flex-shrink: 0; display: flex; align-items: center; gap: 6px; background: var(--btn-send-bg); color: var(--btn-send-text); border: none; font-weight: 600; font-size: 13px; padding: 7px 18px; border-radius: 20px; cursor: pointer; }
    .ad-send-btn:hover { background: var(--btn-send-hover); }
    .ad-send-btn svg { width: 12px; height: 12px; fill: currentColor; }

    .req-builder-card, .res-analyzer-card { display: flex; flex-direction: column; width: 100%; margin-top: 4px; background: var(--bg-surface); border: 1px solid var(--border-color); border-radius: 8px; overflow: visible; height: auto; flex: 1; }
    .req-subnav { display: flex; align-items: center; justify-content: space-between; flex-shrink: 0; border-bottom: 1px solid var(--border-color); padding: 0 12px; height: 36px; background: var(--bg-header); border-top-left-radius: 8px; border-top-right-radius: 8px; }
    .req-sub-tabs { display: flex; align-items: center; gap: 4px; height: 100%; }
    .req-sub-tab { height: 100%; background: transparent; border: none; padding: 0 10px; color: var(--text-tab-inactive); font-size: 12px; font-weight: 600; cursor: pointer; border-bottom: 2px solid transparent; transition: all 0.1s; }
    .req-sub-tab:hover { color: var(--text-main); }
    .req-sub-tab.active { color: var(--text-tab-active); border-bottom-color: var(--border-active-tab); }

    .btn-view-code-sub { display: flex; align-items: center; gap: 6px; background: #223044; color: #93c5fd; border: 1px solid #2e415c; padding: 3px 8px; border-radius: 14px; font-size: 11px; font-weight: 600; cursor: pointer; }
    .btn-view-code-sub:hover { background: #2c3e58; color: #fff; }
    .btn-view-code-sub svg { width: 12px; height: 12px; fill: currentColor; }

    .req-sub-viewport { padding: 14px; background: var(--bg-input); height: auto; flex: 1; display: flex; flex-direction: column; border-bottom-left-radius: 8px; border-bottom-right-radius: 8px; }
    .req-sub-pane { display: none; flex-direction: column; gap: 10px; flex: 1; }
    .req-sub-pane.active { display: flex; }

    .kv-rows { display: flex; flex-direction: column; gap: 8px; }
    .kv-row { display: flex; align-items: center; gap: 8px; width: 100%; }
    .kv-chk { accent-color: var(--border-hover); width: 15px; height: 15px; cursor: pointer; flex-shrink: 0; }
    .kv-box { background: #090c10; border: 1px solid var(--border-color); border-radius: 6px; padding: 5px 10px; color: var(--text-main); font-family: var(--font-mono); font-size: 12px; outline: none; }
    .kv-box.k { flex: 1; } .kv-box.v { flex: 1.5; }
    .kv-box:focus { border-color: var(--border-hover); }
    .kv-sep { color: var(--text-muted); font-family: var(--font-mono); font-size: 13px; font-weight: bold; }
    .kv-del { background: transparent; border: none; color: #f43f5e; cursor: pointer; opacity: 0.6; padding: 2px; }
    .kv-del:hover { opacity: 1; } .kv-del svg { width: 16px; height: 16px; fill: currentColor; }

    .btn-add-row { align-self: flex-start; background: #181f2c; border: 1px solid #283348; margin-top: 2px; color: #94a3b8; padding: 5px 12px; border-radius: 16px; font-size: 11px; font-weight: 600; cursor: pointer; }
    .btn-add-row:hover { background: #222c3e; color: #fff; border-color: #3b82f6; }

    .sub-label { font-size: 11px; font-weight: 700; color: var(--text-label); text-transform: uppercase; letter-spacing: 0.5px; }
    .sub-select { background: var(--bg-surface); border: 1px solid var(--border-color); color: var(--text-main); padding: 5px 10px; border-radius: 6px; font-size: 12px; font-weight: 500; outline: none; cursor: pointer; }
    .sub-select:focus { border-color: var(--border-hover); }
    .auth-notice { font-size: 13px; color: var(--text-muted); margin-top: 4px; }
    .sub-toolbar { display: flex; align-items: center; justify-content: space-between; }
    .sub-select.sm { padding: 3px 8px; font-size: 11px; font-family: var(--font-mono); font-weight: 600; }
    
    .btn-learn-sub { display: flex; align-items: center; gap: 5px; background: #1b273b; color: #93c5fd; border: 1px solid #2d4160; padding: 3px 8px; border-radius: 14px; font-size: 11px; font-weight: 600; cursor: pointer; }
    .editor-wrap { position: relative; width: 100%; margin-top: 2px; display: flex; flex: 1; }
    .code-surface { width: 100%; min-height: 200px; height: auto; background: #07090e; border: 1px solid var(--border-color); border-radius: 8px; padding: 12px; color: #e2e8f0; font-family: var(--font-mono); font-size: 12px; line-height: 1.5; resize: vertical; outline: none; box-sizing: border-box; }
    .code-surface:focus { border-color: var(--border-hover); }

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
  </nav>
</div>

<main class="ad-workbench-viewport" id="workbenchCanvas" style="padding: 0; max-width: none;">
  ${RequestsPane.html}
  ${VariablesPane.html}
  ${HistoryPane.html}
</main>

<script>
  ${MessageHandler.js}
  ${RpcClient.js}

  const tabs = document.querySelectorAll('.ad-tab');
  const panes = document.querySelectorAll('.ad-pane');
  
  // Custom Toast Notification System (Bypasses Sandbox Blocks)
  function showToast(msg, isError = false) {
    const toast = document.createElement('div');
    toast.textContent = msg;
    toast.style.cssText = `position:fixed; bottom:20px; right:20px; background:\${isError ? '#ef4444' : '#3b82f6'}; color:white; padding:10px 16px; border-radius:6px; z-index:9999; font-size:13px; font-weight:600; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); transition: opacity 0.3s ease-in-out; opacity: 1;`;
    document.body.appendChild(toast);
    setTimeout(() => { 
      toast.style.opacity = '0'; 
      setTimeout(() => toast.remove(), 300); 
    }, 2500);
  }
  
  // --- Requests Pane Actions ---
  document.querySelector('.btn-view-code-sub')?.addEventListener('click', () => {
    const url = document.getElementById('reqUrlInput').value || 'http://localhost';
    const method = document.getElementById('methodText').innerText;
    let curl = `curl -X \${method} "\${url}"`;
    
    document.querySelectorAll('#headersList .kv-row').forEach(row => {
      const isChecked = row.querySelector('.kv-chk')?.checked;
      const key = row.querySelector('.kv-box.k')?.value.trim();
      const val = row.querySelector('.kv-box.v')?.value.trim();
      if (isChecked && key) curl += ` \\\n  -H "\${key}: \${val}"`;
    });
    
    const body = document.getElementById('reqBodyTextarea').value;
    if(body && method !== 'GET') {
      curl += ` \\\n  -d '\${body.replace(/'/g, "'\\''")}'`;
    }
    
    try {
      navigator.clipboard.writeText(curl);
      showToast('cURL command copied to clipboard!');
    } catch(e) {
      showToast('Failed to copy. Clipboard access denied.', true);
    }
  });

  // --- ENVIRONMENT ACTIONS ---
  // Duplicate Environment Button
  document.getElementById('btnDuplicateEnv')?.addEventListener('click', async () => {
    const res = await executeDartTool("apidash_duplicate_environment", { id: editingEnvId });
    const newId = res?.structuredContent?.id || res?.id;
    if (newId) editingEnvId = newId;
    await loadVariablesFromHive();
    showToast("Environment duplicated!");
  });

  // Delete Environment Button
  document.getElementById('btnDeleteEnv')?.addEventListener('click', async () => {
    if (editingEnvId === 'global') return showToast("Cannot delete Global environment.", true);
    await executeDartTool("apidash_delete_environment", { id: editingEnvId });
    editingEnvId = 'global';
    await loadVariablesFromHive();
    showToast("Environment deleted!");
  });

  // Rename Environment Button (In-Place Edit)
  document.getElementById('btnRenameEnv')?.addEventListener('click', () => {
    const nameEl = document.getElementById('activeEnvNameDisplay');
    if (!nameEl || editingEnvId === 'global') return showToast("Cannot rename Global environment.", true);
    
    nameEl.contentEditable = 'true';
    nameEl.style.borderBottom = '1px dashed #3b82f6';
    nameEl.focus();

    const saveName = async () => {
      nameEl.contentEditable = 'false';
      nameEl.style.borderBottom = 'none';
      const newName = nameEl.innerText.trim() || 'Untitled Environment';
      nameEl.innerText = newName;
      await executeDartTool("apidash_rename_environment", { id: editingEnvId, name: newName });
      await loadVariablesFromHive();
      showToast("Environment renamed!");
      nameEl.removeEventListener('blur', saveName);
    };

    nameEl.addEventListener('blur', saveName);
    nameEl.addEventListener('keydown', (e) => {
      if (e.key === 'Enter') { e.preventDefault(); nameEl.blur(); }
    });
  });

  // Ensure New Environment gets a timestamped unique name to avoid duplicates
  document.getElementById('btnNewEnv')?.addEventListener('click', async () => {
    const all = Object.keys(allEnvironments);
    const newId = 'env_' + Date.now();
    const newName = "Environment " + (all.length);
    await executeDartTool("apidash_save_variables", { id: newId, name: newName, values: [] });
    editingEnvId = newId;
    await loadVariablesFromHive();
    showToast("New environment created!");
  });

  // --- STATE TRACKING FIX ---
  let trackedExecutionId = null; // The request you are currently looking at/editing
  let latestKnownExecutionId = null; // The absolute newest request in the database
  
  // Edit Request Name (In-Place DOM Edit, No Prompt)
  document.getElementById('btnReqEdit')?.addEventListener('click', () => {
    const titleEl = document.querySelector('.ad-req-title');
    if (!titleEl) return;
    
    titleEl.contentEditable = 'true';
    titleEl.style.borderBottom = '1px dashed #3b82f6';
    titleEl.style.outline = 'none';
    titleEl.focus();
    
    // Select the existing text for easy replacement
    const selection = window.getSelection();
    const range = document.createRange();
    range.selectNodeContents(titleEl);
    selection.removeAllRanges();
    selection.addRange(range);

    const finishEditing = async () => {
      titleEl.contentEditable = 'false';
      titleEl.style.borderBottom = 'none';
      const newName = titleEl.innerText.trim() || 'untitled';
      titleEl.innerText = newName;
      titleEl.setAttribute('title', newName);
      
      // NEW: Automatically save the renamed title to the database
      if (trackedExecutionId) {
        try {
          await executeDartTool("apidash_update_history_title", { 
            execution_id: trackedExecutionId, 
            title: newName 
          });
          // Refresh the ledger behind the scenes so the History tab reflects the change immediately
          fetchHistoryLedger();
        } catch(e) {}
      }

      showToast('Request name updated!');
      titleEl.removeEventListener('blur', finishEditing);
    };

    titleEl.addEventListener('blur', finishEditing);
    titleEl.addEventListener('keydown', (e) => {
      if (e.key === 'Enter') {
        e.preventDefault();
        titleEl.blur(); // Trigger blur to save
      }
    });
  });

  // Delete/Clear Button (No Confirm Dialog)
  document.getElementById('btnReqDelete')?.addEventListener('click', () => {
    // NEW: Unlink from the history record so we don't accidentally rename it later
    trackedExecutionId = null; 

    document.getElementById('reqUrlInput').value = '';
    document.getElementById('reqBodyTextarea').value = '';
    document.getElementById('paramsList').innerHTML = '';
    document.getElementById('headersList').innerHTML = '';
    
    const titleEl = document.querySelector('.ad-req-title');
    if (titleEl) {
      titleEl.innerText = 'untitled';
      titleEl.setAttribute('title', 'untitled');
    }
    
    addKvRow('paramsList', 'Add URL Parameter...');
    addKvRow('headersList', 'Add Name');
    showToast('Request cleared!'); 
  });

  // Duplicate/Copy Button
  document.getElementById('btnReqDuplicate')?.addEventListener('click', () => {
    const titleEl = document.querySelector('.ad-req-title');
    const payload = {
      title: titleEl ? titleEl.innerText : 'untitled',
      url: document.getElementById('reqUrlInput').value,
      method: document.getElementById('methodText').innerText,
      body: document.getElementById('reqBodyTextarea').value
    };
    try {
      navigator.clipboard.writeText(JSON.stringify(payload, null, 2));
      showToast('json is copied!'); 
    } catch(e) {
      showToast('Failed to copy. Clipboard access denied.', true);
    }
  });

  function openNamedRoofTab(targetId) {
    tabs.forEach(t => t.classList.remove('active'));
    panes.forEach(p => p.classList.remove('active'));
    document.querySelector(`[data-pane="\${targetId}"]`)?.classList.add('active');
    document.getElementById(targetId)?.classList.add('active');

    // Trigger data fetching based on the active tab
    if (targetId === 'pane-vars') loadVariablesFromHive();
    if (targetId === 'pane-history') fetchHistoryLedger();

    setTimeout(sendResizeNotification, 50);
  }


  window.addEventListener('DOMContentLoaded', async () => {
    const target = '$activeTab';

    if (target === 'pane-history') {
      openNamedRoofTab('pane-history');
    } else if (target === 'pane-vars') {
      openNamedRoofTab('pane-vars');
    } else {
      openNamedRoofTab('pane-studio');
    }

    try {
      const res = await executeDartTool("apidash_get_results", { _cache_buster: Date.now().toString() });
      const payload = res?.structuredContent || res?.result?.structuredContent || res?.meta?.structuredContent || res;
      if (payload && payload.execution_id) {
        trackedExecutionId = payload.execution_id;
        latestKnownExecutionId = payload.execution_id;
      }
    } catch(e) {}
    
    loadVariablesFromHive();
  });

  tabs.forEach(tab => {
    tab.addEventListener('click', () => {
      const target = tab.getAttribute('data-pane');
      openNamedRoofTab(target);
    });
  });

  const subTabs = document.querySelectorAll('.req-sub-tab');
  const subPanes = document.querySelectorAll('.req-sub-pane');
  subTabs.forEach(tab => {
    tab.addEventListener('click', () => {
      const target = tab.getAttribute('data-sub');
      subTabs.forEach(t => t.classList.remove('active'));
      subPanes.forEach(p => p.classList.remove('active'));
      tab.classList.add('active');
      document.getElementById(target).classList.add('active');
      setTimeout(sendResizeNotification, 50);
    });
  });

  function addKvRow(listId, phText) {
    const cont = document.getElementById(listId);
    const div = document.createElement('div');
    div.className = 'kv-row';
    div.innerHTML = `
      <input type="checkbox" class="kv-chk" checked>
      <input type="text" class="kv-box k" placeholder="\${phText}">
      <span class="kv-sep">=</span>
      <input type="text" class="kv-box v" placeholder="Add Value">
      <button class="kv-del" title="Delete"><svg viewBox="0 0 24 24"><path d="M15 12H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z" stroke="currentColor" stroke-width="2" fill="none"/></svg></button>
    `;
    cont.appendChild(div);
    setTimeout(sendResizeNotification, 50);
  }

  function addVarRow(listId, phKey, phVal) {
    const cont = document.getElementById(listId);
    const div = document.createElement('div');
    div.className = 'kv-row';
    div.innerHTML = `
      <input type="checkbox" class="kv-chk" style="width:14px; height:14px;" checked>
      <input type="text" class="kv-box k" placeholder="\${phKey}" style="background: transparent; padding: 8px 12px; border-color: var(--border-divider);">
      <span class="kv-sep" style="font-weight: normal; margin: 0 4px;">=</span>
      <input type="text" class="kv-box v" placeholder="\${phVal}" style="background: transparent; padding: 8px 12px; border-color: var(--border-divider);">
      <button class="kv-del" title="Delete" style="color: #f43f5e;"><svg viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm5 11H7v-2h10v2z" stroke="currentColor" stroke-width="0" fill="currentColor"/></svg></button>
    `;
    cont.appendChild(div);
    setTimeout(sendResizeNotification, 50);
  }

  document.addEventListener('click', (e) => {
    const delBtn = e.target.closest('.kv-del');
    if (delBtn) {
      delBtn.closest('.kv-row').remove();
      setTimeout(sendResizeNotification, 50);
    }
  });

  document.getElementById('authSelectProxy')?.addEventListener('change', (e) => {
    const label = document.getElementById('authHelperText');
    if (!label) return;
    if (e.target.value === 'None') label.textContent = "No authentication selected.";
    else label.textContent = `Configure \${e.target.value} credentials below...`;
  });

  const mBox = document.getElementById('methodBox');
  const mDisp = document.getElementById('methodDisplay');
  const mText = document.getElementById('methodText');
  const mOpts = document.querySelectorAll('.ad-drop-option');
  mDisp.addEventListener('click', (e) => { e.stopPropagation(); mBox.classList.toggle('open'); });
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
  document.addEventListener('click', (e) => { if (!mBox.contains(e.target)) mBox.classList.remove('open'); });

  // --- STATE MANAGEMENT ---
  let allEnvironments = {};
  let editingEnvId = 'global';

  async function loadVariablesFromHive() {
    try {
      const res = await executeDartTool("apidash_get_variables", {});
      allEnvironments = res?.structuredContent?.environments || res?.environments || {};
      
      renderEnvironmentSidebar();
      renderActiveEnvironmentEditor();
      
      const selector = document.getElementById('activeEnvSelector');
      if (selector) {
        const currentVal = selector.value;
        selector.innerHTML = '';
        Object.keys(allEnvironments).forEach(id => {
          const opt = document.createElement('option');
          opt.value = id;
          opt.innerText = allEnvironments[id].name || 'Unknown';
          selector.appendChild(opt);
        });
        if (allEnvironments[currentVal]) selector.value = currentVal;
      }
    } catch(e) {}
  }

  function renderEnvironmentSidebar() {
    const list = document.getElementById('envListContainer');
    if (!list) return;
    list.innerHTML = '';

    Object.keys(allEnvironments).forEach(id => {
      const env = allEnvironments[id];
      const isGlobal = id === 'global';
      const isActive = id === editingEnvId;
      
      const div = document.createElement('div');
      div.className = `env-item \${isActive ? 'active' : ''}`;
      div.style.cssText = `background: \${isActive ? 'var(--bg-surface-hover)' : 'transparent'}; border-left: 2px solid \${isActive ? 'var(--border-hover)' : 'transparent'}; color: \${isActive ? 'var(--text-tab-active)' : 'var(--text-main)'}; padding: 8px 12px; border-radius: 0 4px 4px 0; font-size: 13px; font-weight: 500; cursor: pointer; display: flex; justify-content: space-between; align-items: center;`;
      
      div.innerHTML = `<span>\${env.name}</span>\${isGlobal ? '<span style="font-size: 10px; background: var(--bg-input); border: 1px solid var(--border-color); color: var(--text-label); padding: 2px 6px; border-radius: 4px;">Default</span>' : ''}`;
      
      div.onclick = () => {
        editingEnvId = id;
        renderEnvironmentSidebar();
        renderActiveEnvironmentEditor();
      };
      list.appendChild(div);
    });
  }

  function renderActiveEnvironmentEditor() {
    const env = allEnvironments[editingEnvId] || { name: 'Unknown', values: [] };
    document.getElementById('activeEnvNameDisplay').innerText = env.name;
    
    const list = document.getElementById('globalVarsList');
    if (!list) return;
    list.innerHTML = '';

    if (!env.values || env.values.length === 0) {
      addVarRow('globalVarsList', 'Variable Name', 'Value');
      return;
    }

    env.values.forEach(item => {
      const div = document.createElement('div');
      div.className = 'kv-row';
      div.innerHTML = `
        <input type="checkbox" class="kv-chk" style="width:14px; height:14px;" \${item.enabled !== false ? 'checked' : ''}>
        <input type="text" class="kv-box k" value="\${item.key || ''}" placeholder="Variable Name" style="background: transparent; padding: 8px 12px; border-color: var(--border-divider);">
        <span class="kv-sep" style="font-weight: normal; margin: 0 4px;">=</span>
        <input type="text" class="kv-box v" value="\${item.value || ''}" placeholder="Value" style="background: transparent; padding: 8px 12px; border-color: var(--border-divider);">
        <button class="kv-del" title="Delete" style="color: #f43f5e;"><svg viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm5 11H7v-2h10v2z" stroke="currentColor" stroke-width="0" fill="currentColor"/></svg></button>
      `;
      list.appendChild(div);
    });
  }

  document.getElementById('btnSaveEnv')?.addEventListener('click', async () => {
    const values = [];
    document.querySelectorAll('#globalVarsList .kv-row').forEach(row => {
      const key = row.querySelector('.kv-box.k')?.value.trim();
      if (key) {
        values.push({
          key: key, 
          value: row.querySelector('.kv-box.v')?.value.trim(), 
          enabled: row.querySelector('.kv-chk')?.checked
        });
      }
    });

    const envName = document.getElementById('activeEnvNameDisplay').innerText;
    await executeDartTool("apidash_save_variables", { id: editingEnvId, name: envName, values: values });
    loadVariablesFromHive();
    showToast("Environment Saved!");
  });

  // --- REQUEST DISPATCHER ---
  document.getElementById('btnFireRequest')?.addEventListener('click', async () => {
    const url = document.getElementById('reqUrlInput').value.trim();
    if (!url) return showToast("Please specify a target URL endpoint.", true);
    
    const method = document.getElementById('methodText').innerText;
    const body = document.getElementById('reqBodyTextarea').value;
    
    // Fallback in case title element is not found
    const titleEl = document.querySelector('.ad-req-title');
    const reqTitle = titleEl ? titleEl.innerText : 'untitled';
    
    const envSelector = document.getElementById('activeEnvSelector');
    const selectedEnvId = envSelector ? envSelector.value : 'global';
    
    let headers = {};
    document.querySelectorAll('#headersList .kv-row').forEach(row => {
      const isChecked = row.querySelector('.kv-chk')?.checked;
      const key = row.querySelector('.kv-box.k')?.value.trim();
      const val = row.querySelector('.kv-box.v')?.value.trim();
      if (isChecked && key) headers[key] = val;
    });

    renderHydratedResults({ status_code: 0, time_ms: 0, response_body: "Dispatching request over MCP pipe..." });
    const res = await executeDartTool("apidash_execute_request", {
      title: reqTitle,
      url, method,
      headers: Object.keys(headers).length > 0 ? headers : undefined,
      body: body ? body : undefined,
      active_environment_id: selectedEnvId
    });
    const payload = res?.structuredContent || res?.result?.structuredContent || res?.meta?.structuredContent || res;
    if (payload && payload.execution_id) {
      trackedExecutionId = payload.execution_id;
      latestKnownExecutionId = payload.execution_id;
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
      lblCode.textContent = "⚡ FETCHING..."; lblCode.className = "res-status-code"; lblCode.style.color = "#fbbf24";
    } else {
      lblCode.textContent = `\${code}: \${isOk ? 'OK' : 'ERROR'}`; lblCode.className = `res-status-code \${isOk ? 'ok' : 'err'}`; lblCode.style.color = isOk ? "#4ade80" : "#f87171";
    }
    document.getElementById('resTimeLabel').textContent = (data.time_ms || 0) + ' ms';
    let rawBody = data.response_body || 'No response body loaded.';
    let cleanBody = rawBody;
    try { cleanBody = JSON.stringify(JSON.parse(rawBody), null, 2); } catch(e) {}
    document.getElementById('resPayloadPre').textContent = cleanBody;
    const sizeB = new Blob([cleanBody]).size;
    document.getElementById('resSizeLabel').textContent = sizeB < 1024 ? `\${sizeB} B` : `\${(sizeB / 1024).toFixed(2)} KB`;
    setTimeout(sendResizeNotification, 50);
  }

  window.exitResultsView = function() {
    document.getElementById('resultsCardCanvas').style.display = 'none';
    document.getElementById('builderCardCanvas').style.display = 'flex';
    setTimeout(sendResizeNotification, 50);
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
    setTimeout(sendResizeNotification, 50);
  };

  window.addEventListener('message', async (event) => {
    const msg = event.data;
    if (msg && msg.type === 'HYDRATE_HISTORIC_RUN') {
      openNamedRoofTab('pane-studio');
      renderHydratedResults({ status_code: 0, time_ms: 0, response_body: "Querying Hive DB for historical run..." });
      const res = await executeDartTool("apidash_get_results", { execution_id: msg.id });
      const payload = res?.structuredContent || res?.result?.structuredContent || res?.meta?.structuredContent || res;
      if (payload) {
        trackedExecutionId = payload.execution_id || msg.id;
        // Hydrate Title
        const titleEl = document.querySelector('.ad-req-title');
        if (titleEl) {
          titleEl.innerText = payload.title || 'untitled';
          titleEl.setAttribute('title', payload.title || 'untitled');
        }
        if (payload.url) document.getElementById('reqUrlInput').value = payload.url;
        if (payload.method) {
          document.getElementById('methodText').innerText = payload.method.toUpperCase();
          document.getElementById('methodDisplay').style.color = `var(--http-\${payload.method.toLowerCase()}, var(--http-get))`;
        }
        renderHydratedResults(payload);
      }
    }
  });

  window.openHistoryResult = async function(id) {
    openNamedRoofTab('pane-studio');
    renderHydratedResults({ status_code: 0, time_ms: 0, response_body: "Loading execution record from Hive..." });
    try {
      const res = await executeDartTool("apidash_get_results", { execution_id: id });
      const payload = res?.structuredContent || res?.result?.structuredContent || res?.meta?.structuredContent || res;
      if (payload) {
        trackedExecutionId = payload.execution_id || id;
        // Hydrate Title
        const titleEl = document.querySelector('.ad-req-title');
        if (titleEl) {
          titleEl.innerText = payload.title || 'untitled';
          titleEl.setAttribute('title', payload.title || 'untitled');
        }
        if (payload.url) document.getElementById('reqUrlInput').value = payload.url;
        if (payload.method) {
          document.getElementById('methodText').innerText = payload.method.toUpperCase();
          document.getElementById('methodDisplay').style.color = `var(--http-\${payload.method.toLowerCase()}, var(--http-get))`;
        }
        renderHydratedResults(payload);
      }
    } catch(e) {}
  };

  let isPolling = false;
  setInterval(async () => {
    if (isPolling) return;
    isPolling = true;
    try {
      const res = await executeDartTool("apidash_get_results", { _cache_buster: Date.now().toString() });
      const payload = res?.structuredContent || res?.result?.structuredContent || res?.meta?.structuredContent || res;
      if (payload && payload.execution_id && payload.execution_id !== latestKnownExecutionId) {
        latestKnownExecutionId = payload.execution_id;
        trackedExecutionId = payload.execution_id;
        // Hydrate Title
        const titleEl = document.querySelector('.ad-req-title');
        if (titleEl) {
          titleEl.innerText = payload.title || 'untitled';
          titleEl.setAttribute('title', payload.title || 'untitled');
        }
        if (payload.url) document.getElementById('reqUrlInput').value = payload.url;
        if (payload.method) {
          document.getElementById('methodText').innerText = payload.method.toUpperCase();
          document.getElementById('methodDisplay').style.color = `var(--http-\${payload.method.toLowerCase()}, var(--http-get))`;
        }
        renderHydratedResults(payload);
      }
    } catch(e) {} finally { isPolling = false; }
  }, 1500);

  async function fetchHistoryLedger() {
    const feed = document.getElementById('history-feed');
    const spinner = document.getElementById('history-spinner');
    if(!feed || !spinner) return;
    feed.innerHTML = ''; spinner.style.display = 'block';
    try {
      const payload = await executeDartTool("apidash_list_history", { _cache_buster: Date.now().toString() });
      spinner.style.display = 'none';
      let data = [];
      const raw = payload?.structuredContent || payload?.result?.structuredContent || payload?.meta?.structuredContent || payload;
      if (Array.isArray(raw)) data = raw;
      else if (raw && Array.isArray(raw.history)) data = raw.history;
      else if (raw && raw.result && Array.isArray(raw.result)) data = raw.result;

      if (data.length === 0) { 
        feed.innerHTML = '<div class="ad-empty-notice">No requests executed yet.</div>'; 
        setTimeout(sendResizeNotification, 50); return; 
      }

      data.forEach(req => {
        const isOk = req.status >= 200 && req.status < 300;
        const verbClr = `var(--http-\${req.method.toLowerCase()}, var(--http-get))`;
        
        const displayTitle = req.title && req.title.trim() !== '' ? req.title : 'untitled';

        const item = document.createElement('div');
        item.className = 'ad-hist-card';
        item.innerHTML = `
          <div class="ad-hist-left" onclick="openHistoryResult('\${req.execution_id}')" title="Click to load into Studio">
            <span class="ad-hist-method" style="color:\${verbClr}; align-self: center;">\${req.method}</span>
            <div style="display:flex; flex-direction:column; min-width:0; overflow:hidden; justify-content: center; gap: 2px;">
              <span style="font-size: 13px; font-weight: 600; color: var(--text-main); white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">\${displayTitle}</span>
              <span class="ad-hist-url" style="color: var(--text-muted); font-size: 11px;">\${req.url}</span>
            </div>
          </div>
          <div class="ad-hist-right">
            <span style="color:\${isOk ? 'var(--http-get)' : 'var(--http-delete)'}; font-weight:700">\${req.status}</span>
            <span style="color:var(--text-muted)">\${req.time_ms || 0}ms</span>
            <button class="ad-hist-delete" onclick="triggerDelete('\${req.execution_id}', event)">Delete</button>
          </div>
        `;
        feed.appendChild(item);
      });
      setTimeout(sendResizeNotification, 100);
    } catch(e) { 
      spinner.textContent = "❌ RPC Bridge Error."; 
      setTimeout(sendResizeNotification, 50);
    }
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
}