
const baseStyle = r'''
     *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

  :root {
    --bg-base:       #1a1d23;
    --bg-sidebar:    #13151a;
    --bg-panel:      #1e2128;
    --bg-card:       #252931;
    --bg-card-hover: #2c3039;
    --bg-card-active:#2a3a52;
    --bg-input:      #1a1d23;
    --border:        #2e3340;
    --border-subtle: #252931;
    --accent:        #4f8ef7;
    --accent-dim:    rgba(79,142,247,0.15);
    --accent-glow:   rgba(79,142,247,0.08);
    --text-primary:  #e8eaf0;
    --text-secondary:#8b92a5;
    --text-muted:    #555d72;
    --text-url:      #6b7694;
    --get:           #22c55e;
    --post:          #f59e0b;
    --put:           #3b82f6;
    --patch:         #8b5cf6;
    --delete:        #ef4444;
    --head:          #06b6d4;
    --options:       #ec4899;
    --success-bg:    rgba(34,197,94,0.12);
    --success-border:rgba(34,197,94,0.3);
    --radius:        6px;
    --radius-lg:     10px;
  }

  html, body {
    height: 100%;
    min-height: 100%;
    background: var(--bg-base);
    color: var(--text-primary);
    font-family: 'DM Sans', sans-serif;
    font-size: 13px;
    overflow: auto;
  }

  .app {
    display: flex;
    height: 100%;
    min-height: 0;
    overflow: hidden;
  }

  /* Sidebar */
  .sidebar {
    width: 260px;
    min-width: 200px;
    max-width: 340px;
    flex-shrink: 0;
    background: var(--bg-sidebar);
    border-right: 1px solid var(--border);
    display: flex;
    flex-direction: column;
    overflow: hidden;
    position: relative;
  }

  .sidebar-header {
    padding: 14px 14px 10px;
    border-bottom: 1px solid var(--border-subtle);
    flex-shrink: 0;
  }

  .logo-text { font-weight: 600; margin-bottom: 10px; font-size: 13px; color: var(--text-primary); }

  /* Collection selector */
  .collection-select {
    width: 100%;
    background: var(--bg-card);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    color: var(--text-primary);
    font-family: inherit;
    font-size: 12.5px;
    padding: 7px 10px;
    outline: none;
    cursor: pointer;
    padding-right: 28px;
    transition: border-color .15s;
  }
  .collection-select:focus { border-color: var(--accent); }
  .collection-select option { background: var(--bg-card); }

  /* Search */
  .search-wrap {
    position: relative;
    margin-top: 8px;
  }
  .search-icon {
    position: absolute; left: 9px; top: 50%; transform: translateY(-50%);
    color: var(--text-muted); pointer-events: none;
  }
  .search-input {
    width: 100%;
    background: var(--bg-input);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    color: var(--text-primary);
    font-family: inherit;
    font-size: 12.5px;
    padding: 7px 10px 7px 30px;
    outline: none;
    transition: border-color .15s;
  }
  .search-input::placeholder { color: var(--text-muted); }
  .search-input:focus { border-color: var(--accent); }

  /* Count badge */
  .count-badge {
    display: inline-flex; align-items: center; justify-content: center;
    background: var(--accent-dim);
    color: var(--accent);
    border-radius: 10px;
    font-size: 10px; font-weight: 600;
    min-width: 18px; height: 18px;
    padding: 0 5px;
  }

  /* Request list */
  .request-list {
    flex: 1;
    min-height: 0;
    overflow-y: auto;
    padding: 8px 0 80px;
  }
  .request-list::-webkit-scrollbar { width: 3px; }
  .request-list::-webkit-scrollbar-track { background: transparent; }
  .request-list::-webkit-scrollbar-thumb { background: var(--border); border-radius: 2px; }

  /* Folder */
  .folder {
    margin-bottom: 2px;
  }

  .folder-header {
    display: flex; align-items: center; gap: 6px;
    padding: 6px 14px;
    cursor: pointer;
    color: var(--text-secondary);
    font-size: 11.5px; font-weight: 500;
    text-transform: uppercase; letter-spacing: .05em;
    user-select: none;
    transition: color .12s;
  }
  .folder-header:hover { color: var(--text-primary); }

  .folder-chevron {
    transition: transform .18s ease;
    flex-shrink: 0;
    color: var(--text-muted);
  }
  .folder.collapsed .folder-chevron { transform: rotate(-90deg); }
  .folder.collapsed .folder-items   { display: none; }

  .folder-icon { font-size: 12px; flex-shrink: 0; }

  .folder-count {
    margin-left: auto;
  }

  .folder-items {
    padding: 0 8px 4px;
  }

  /* Request card */
  .request-card {
    display: flex; align-items: flex-start; gap: 8px;
    padding: 8px 10px;
    border-radius: var(--radius);
    cursor: pointer;
    margin-bottom: 2px;
    border: 1px solid transparent;
    transition: background .12s, border-color .12s;
    position: relative;
    overflow: hidden;
  }
  .request-card:hover  { background: var(--bg-card-hover); }
  .request-card.active {
    background: var(--bg-card-active);
    border-color: rgba(79,142,247,0.3);
  }
  .request-card.active::before {
    content: '';
    position: absolute; left: 0; top: 0; bottom: 0;
    width: 2px;
    background: var(--accent);
  }

  /* Method badge */
  .method-badge {
    font-family: 'JetBrains Mono', monospace;
    font-size: 9.5px; font-weight: 600;
    padding: 2px 5px;
    border-radius: 3px;
    flex-shrink: 0;
    margin-top: 1px;
    letter-spacing: .03em;
  }
  .m-get     { color: var(--get);     background: rgba(34,197,94,0.12);  }
  .m-post    { color: var(--post);    background: rgba(245,158,11,0.12); }
  .m-put     { color: var(--put);     background: rgba(59,130,246,0.12); }
  .m-patch   { color: var(--patch);   background: rgba(139,92,246,0.12); }
  .m-delete  { color: var(--delete);  background: rgba(239,68,68,0.12);  }
  .m-head    { color: var(--head);    background: rgba(6,182,212,0.12);  }
  .m-options { color: var(--options); background: rgba(236,72,153,0.12); }

  .request-info { flex: 1; min-width: 0; }
  .request-name { font-weight: 500; font-size: 12.5px; color: var(--text-primary); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
  .request-id   { font-family: 'JetBrains Mono', monospace; font-size: 9px; color: var(--text-muted); margin: 1px 0 2px; }
  .request-url  { font-family: 'JetBrains Mono', monospace; font-size: 10px; color: var(--text-url); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }

  /* Add button */
  .sidebar-footer {
    position: absolute; bottom: 0; left: 0; right: 0;
    padding: 12px 14px;
    background: linear-gradient(to top, var(--bg-sidebar) 70%, transparent);
  }

  .add-btn {
    width: 100%;
    background: var(--accent);
    color: #fff;
    border: none;
    border-radius: var(--radius);
    padding: 9px 14px;
    font-family: inherit; font-size: 12.5px; font-weight: 600;
    cursor: pointer;
    display: flex; align-items: center; justify-content: center; gap: 6px;
    transition: background .15s, transform .1s;
  }
  .add-btn:hover  { background: #3d7de8; }
  .add-btn:active { transform: scale(.98); }
  .add-btn:disabled { background: var(--border); color: var(--text-muted); cursor: not-allowed; }

  /* Preview Panel */
  .preview {
    flex: 1;
    min-width: 0;
    min-height: 0;
    background: var(--bg-panel);
    display: flex;
    flex-direction: column;
    overflow: hidden;
  }

  .preview-header {
    padding: 16px 22px 14px;
    border-bottom: 1px solid var(--border);
    flex-shrink: 0;
  }

  .preview-empty {
    flex: 1;
    display: flex; flex-direction: column;
    align-items: center; justify-content: center;
    color: var(--text-muted);
    gap: 12px;
  }

  .preview-empty-icon { font-size: 36px; opacity: .4; }
  .preview-empty-text { font-size: 13px; }

  .preview-title { font-weight: 600; font-size: 17px; color: var(--text-primary); margin-bottom: 6px; }

  .url-row {
    display: flex; align-items: center; gap: 8px;
    font-family: 'JetBrains Mono', monospace;
    font-size: 12px; color: var(--text-url);
    overflow: hidden;
  }

  .url-method-badge {
    font-size: 10px; font-weight: 700; padding: 2px 7px; border-radius: 4px;
    flex-shrink: 0; letter-spacing: .04em;
  }

  .url-text {
    white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
    color: var(--text-secondary);
  }

  /* Tabs */
  .tab-navigation {
    display: flex; gap: 0;
    border-bottom: 1px solid var(--border);
    padding: 0 22px;
    flex-shrink: 0;
  }

  .tab-button {
    background: none; border: none;
    color: var(--text-muted);
    font-family: inherit; font-size: 12.5px; font-weight: 500;
    padding: 10px 14px;
    cursor: pointer;
    border-bottom: 2px solid transparent;
    margin-bottom: -1px;
    transition: color .12s, border-color .12s;
  }
  .tab-button:hover  { color: var(--text-secondary); }
  .tab-button.active { color: var(--accent); border-color: var(--accent); }

  /* Tab panels */
  .tab-sections {
    flex: 1; overflow-y: auto;
    padding: 18px 22px;
  }
  .tab-sections::-webkit-scrollbar { width: 4px; }
  .tab-sections::-webkit-scrollbar-thumb { background: var(--border); border-radius: 2px; }

  .tab-section { display: none; }
  .tab-section.active { display: block; }

  /* KV table */
  .key-value-table {
    width: 100%; border-collapse: collapse;
  }
  .key-value-table th {
    text-align: left; padding: 6px 10px;
    font-size: 10.5px; font-weight: 600; letter-spacing: .06em; text-transform: uppercase;
    color: var(--text-muted);
    border-bottom: 1px solid var(--border);
  }
  .key-value-table td {
    padding: 8px 10px;
    font-family: 'JetBrains Mono', monospace;
    font-size: 11.5px;
    border-bottom: 1px solid var(--border-subtle);
    vertical-align: top;
  }
  .key-cell   { color: var(--accent); width: 35%; }
  .value-cell { color: var(--text-secondary); word-break: break-all; }

  .no-data {
    color: var(--text-muted);
    font-size: 12.5px; padding: 10px 0;
  }

  /* Body block */
  .body-block {
    background: var(--bg-card);
    border: 1px solid var(--border);
    border-radius: var(--radius-lg);
    padding: 14px 16px;
    font-family: 'JetBrains Mono', monospace;
    font-size: 12px;
    color: var(--text-secondary);
    white-space: pre-wrap; word-break: break-all;
    line-height: 1.7;
  }

  /* Auth info */
  .auth-block {
    background: var(--bg-card);
    border: 1px solid var(--border);
    border-radius: var(--radius-lg);
    padding: 14px 16px;
  }
  .auth-type {
    font-size: 11px; font-weight: 600; text-transform: uppercase; letter-spacing: .08em;
    color: var(--accent); margin-bottom: 10px;
  }

  /* no-select helper */
  .hidden { display: none !important; }  
''';