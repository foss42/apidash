import 'package:apidash_mcp/src/ui/css/basestyle.dart';

String buildBrowseCollectionsUi({String? initialTreeJson}) {
  final initialJson =
      (initialTreeJson == null || initialTreeJson.trim().isEmpty)
      ? '{}'
      : initialTreeJson.replaceAll('</', '<\\/');

  return r'''
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>APIDash Collections</title>
<style>__BASE_STYLE__</style>
</head>
<body>
<script id="apidashCollectionTreeData" type="application/json">__INITIAL_TREE_JSON__</script>

<div class="app">
  <aside class="sidebar">
    <div class="sidebar-header">
      <div class="logo-text">Apidash</div>
      <select class="collection-select" id="collectionSelect">
        <option value="__all__">All Collections</option>
      </select>
      <div class="search-wrap">
        <svg class="search-icon" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>
        </svg>
        <input class="search-input" id="searchInput" placeholder="Search requests..." />
      </div>
    </div>
    <div class="request-list" id="requestList"></div>
    <div class="sidebar-footer">
      <button class="add-btn" id="addBtn" disabled>
        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
          <path d="M12 5v14M5 12h14"/>
        </svg>
        Add to Chat
      </button>
    </div>
  </aside>

  <main class="preview" id="preview">
    <div class="preview-empty" id="emptyState">
      <div class="preview-empty-icon">📂</div>
      <div class="preview-empty-text">No request is selected in preview</div>
    </div>
    <div id="filledState" class="hidden" style="display:flex;flex-direction:column;flex:1;overflow:hidden;">
      <div class="preview-header">
        <div class="preview-title" id="previewTitle">—</div>
        <div class="url-row">
          <span class="url-method-badge method-badge" id="previewMethodBadge"></span>
          <span class="url-text" id="previewUrl"></span>
        </div>
      </div>
      <div class="tab-navigation">
        <button class="tab-button active" data-tab="headers">Headers</button>
        <button class="tab-button" data-tab="body">Body</button>
        <button class="tab-button" data-tab="params">Params</button>
        <button class="tab-button" data-tab="auth">Auth</button>
      </div>
      <div class="tab-sections">
        <div class="tab-section active" id="tab-headers">
          <table class="key-value-table" id="headersTable">
            <thead><tr><th>KEY</th><th>VALUE</th></tr></thead>
            <tbody id="headersTbody"></tbody>
          </table>
          <p class="no-data hidden" id="noHeaders">No headers</p>
        </div>
        <div class="tab-section" id="tab-body">
          <p class="no-data" id="noBody">No body</p>
          <pre class="body-block hidden" id="bodyBlock"></pre>
        </div>
        <div class="tab-section" id="tab-params">
          <table class="key-value-table" id="paramsTable">
            <thead><tr><th>KEY</th><th>VALUE</th></tr></thead>
            <tbody id="paramsTbody"></tbody>
          </table>
          <p class="no-data hidden" id="noParams">No query parameters</p>
        </div>
        <div class="tab-section" id="tab-auth">
          <p class="no-data" id="noAuth">No auth configured</p>
          <div class="auth-block hidden" id="authBlock">
            <div class="auth-type" id="authType"></div>
            <table class="key-value-table" id="authTable">
              <tbody id="authTbody"></tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </main>
</div>

<script>
function encodeHtmlEntities(str) {
  return String(str ?? '').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}

// function document.getElementById(id) { return document.getElementById(id); }

function rowsToObject(rows, enabledList) {
  if (Array.isArray(rows)) {
    const out = {};
    rows.forEach((entry, index) => {
      if (!entry || typeof entry !== 'object') return;
      if (Array.isArray(enabledList) && enabledList[index] === false) return;
      const k = String(entry.name ?? '').trim();
      if (!k) return;
      out[k] = String(entry.value ?? '');
    });
    return out;
  }
  if (rows && typeof rows === 'object') {
    return rows;
  }
  return {};
}

function normalizeBody(rawBody) {
  if (rawBody == null) return null;
  if (typeof rawBody === 'string') return rawBody;
  try {
    return JSON.stringify(rawBody, null, 2);
  } catch (_) {
    return String(rawBody);
  }
}

function valueToDisplay(v) {
  if (v == null) return '';
  if (typeof v === 'string') return v;
  if (typeof v === 'number' || typeof v === 'boolean') return String(v);
  try {
    return JSON.stringify(v);
  } catch (_) {
    return String(v);
  }
}

function normalizeReq(req) {
  const source = req?.data && typeof req.data === 'object' ? req.data : req;
  const id = req?.id || source?.id || req?.file || 'request';
  const collectionId = req?.collectionId || req?.collection_id || null;
  const folderId = req?.folderId || req?.folder_id || null;

  return {
    id,
    collectionId,
    folderId,
    name: req?.name || id || req?.file || source?.url || 'Untitled request',
    method: String(req?.method || source?.method || 'GET').toUpperCase(),
    url: req?.url || source?.url || '',
    headers: rowsToObject(source?.headers || req?.headers, source?.isHeaderEnabledList),
    params: rowsToObject(source?.params || source?.query || req?.params, source?.isParamEnabledList),
    body: normalizeBody(source?.body ?? req?.body),
    auth: source?.authModel || req?.auth || { type: 'none' },
    data: source,
  };
}

function pickTreePayload(c) {
  if (!c || typeof c !== 'object') return null;
  if (Array.isArray(c.collections)) return c;
  return pickTreePayload(c.data || c.tree);
}

function transformCollectionTree(tree) {
  if (!tree || !Array.isArray(tree.collections)) return null;
  return {
    collections: tree.collections.map(col => ({
      id:       col?.id   || 'collection',
      name:     col?.name || col?.id || 'Collection',
      requests: (col?.requests || []).map(req => normalizeReq({ ...req, collectionId: col?.id })),
      folders:  (col?.folders  || []).map(folder => ({
        id:       folder?.id   || 'folder',
        name:     folder?.name || folder?.id || 'Folder',
        requests: (folder?.requests || []).map(req =>
          normalizeReq({ ...req, collectionId: col?.id, folderId: folder?.id }),
        ),
      })),
    })),
  };
}

function getInitialTree() {
  const elem = document.getElementById('apidashCollectionTreeData');

  if (elem?.textContent?.trim()) {
    try {
      return pickTreePayload(JSON.parse(elem.textContent));
    } catch (_) {
      return null;
    }
  }

  return null;
}

let DATA = transformCollectionTree(getInitialTree()) || { collections: [] };
let selected = null;
let activeCol = '__all__';
const pendingHostCalls = new Map();
let nextHostCallId = 1;

window.addEventListener('message', event => {
  const d = event?.data;
  if (!d) return;

  // Handle RPC response
  if (d.jsonrpc === '2.0' && 'id' in d) {
    const p = pendingHostCalls.get(d.id);
    if (p) {
      clearTimeout(p.timeout);
      pendingHostCalls.delete(d.id);
      d.error ? p.reject(new Error(d.error.message)) : p.resolve(d.result);
    }
    return;
  }

  // Handle data update
  updateDataFromPayload(d.params || d.result || d.payload || d.content || d);
});

function updateDataFromPayload(payload) {
  const transformed = transformCollectionTree(pickTreePayload(payload));
  if (!transformed) return;
  DATA = transformed;
  activeCol = document.getElementById('collectionSelect')?.value || '__all__';
  selected = null;
  const sel = document.getElementById('collectionSelect');
  if (sel) sel.innerHTML = '<option value="__all__">All Collections</option>';
  buildCollectionSelect();
  renderList(document.getElementById('searchInput')?.value || '');
  resetPreview();
}

// UI builders
function buildCollectionSelect() {
  const sel = document.getElementById('collectionSelect');
  if (!sel) return;
  DATA.collections.forEach(c => {
    const opt = document.createElement('option');
    opt.value = c.id; opt.textContent = c.name;
    sel.appendChild(opt);
  });
}

function renderList(query = '') {
  const q = query.toLowerCase().trim();
  const list = document.getElementById('requestList');
  if (!list) return;
  list.innerHTML = '';

  const cols = activeCol === '__all__'
    ? DATA.collections
    : DATA.collections.filter(c => c.id === activeCol);

  cols.forEach(col => {
    if (activeCol === '__all__') {
      const label = document.createElement('div');
      label.className = 'folder-header';
      label.style.cssText = 'font-size:10px;color:var(--text-muted);padding:8px 14px 4px;cursor:default';
      label.textContent = String(col.name || col.id || 'Collection').toUpperCase();
      list.appendChild(label);
    }

    const looseReqs = (col.requests || []).filter(r => matchesQuery(r, q));
    if (looseReqs.length) {
      const wrap = document.createElement('div');
      wrap.className = 'folder';
      const items = document.createElement('div');
      items.className = 'folder-items';
      looseReqs.forEach(r => items.appendChild(makeReqCard(r)));
      wrap.appendChild(items);
      list.appendChild(wrap);
    }

    (col.folders || []).forEach(folder => {
      const folderReqs = (folder.requests || []).filter(r => matchesQuery(r, q));
      if (q && !folderReqs.length) return;

      const wrap = document.createElement('div');
      wrap.className = 'folder';

      const hdr = document.createElement('div');
      hdr.className = 'folder-header';
      hdr.innerHTML =
        '<svg class="folder-chevron" width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="m6 9 6 6 6-6"/></svg>' +
        '<span class="folder-icon">📁</span>' +
        '<span style="flex:1;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">' + encodeHtmlEntities(folder.name) + '</span>' +
        '<span class="count-badge folder-count">' + folderReqs.length + '</span>';
      hdr.addEventListener('click', () => wrap.classList.toggle('collapsed'));

      const items = document.createElement('div');
      items.className = 'folder-items';
      folderReqs.forEach(r => items.appendChild(makeReqCard(r)));
      wrap.appendChild(hdr);
      wrap.appendChild(items);
      list.appendChild(wrap);
    });
  });
}

function matchesQuery(r, q) {
  if (!q) return true;
  return [r?.name, r?.url, r?.method].some(v => String(v || '').toLowerCase().includes(q));
}

function makeReqCard(req) {
  const card = document.createElement('div');
  card.className = 'request-card' + (selected?.id === req.id ? ' active' : '');
  card.dataset.id = req.id;
  card.innerHTML =
    '<span class="method-badge m-' + req.method.toLowerCase() + '">' + encodeHtmlEntities(req.method) + '</span>' +
    '<div class="request-info">' +
      '<div class="request-name">' + encodeHtmlEntities(req.name) + '</div>' +
      '<div class="request-id">'   + encodeHtmlEntities(req.id)   + '</div>' +
      '<div class="request-url">'  + encodeHtmlEntities(req.url)  + '</div>' +
    '</div>';
  card.addEventListener('click', () => selectRequest(req));
  return card;
}

// Preview
function resetPreview() {
  document.getElementById('emptyState')?.classList.remove('hidden');
  const filled = document.getElementById('filledState');
  if (filled) { filled.classList.add('hidden'); filled.style.display = 'none'; }
  document.getElementById('addBtn').disabled = true;
}

function setKvTable(tbodyId, tableId, noDataId, entries) {
  const tbody = document.getElementById(tbodyId);
  if (!tbody) return;
  tbody.innerHTML = '';
  if (entries.length) {
    document.getElementById(tableId)?.classList.remove('hidden');
    if (noDataId) document.getElementById(noDataId)?.classList.add('hidden');
    entries.forEach(([k, v]) => {
      const tr = document.createElement('tr');
      tr.innerHTML = '<td class="key-cell">' + encodeHtmlEntities(k) + '</td><td class="value-cell">' + encodeHtmlEntities(valueToDisplay(v)) + '</td>';
      tbody.appendChild(tr);
    });
  } else {
    document.getElementById(tableId)?.classList.add('hidden');
    if (noDataId) document.getElementById(noDataId)?.classList.remove('hidden');
  }
}

function selectRequest(req) {
  selected = req;
  document.querySelectorAll('.request-card').forEach(c => c.classList.toggle('active', c.dataset.id === req.id));
  document.getElementById('addBtn').disabled = false;

  document.getElementById('emptyState').classList.add('hidden');
  const filled = document.getElementById('filledState');
  filled.classList.remove('hidden');
  filled.style.display = 'flex';

  document.getElementById('previewTitle').textContent = req.name;
  const mb = document.getElementById('previewMethodBadge');
  mb.textContent = req.method;
  mb.className = 'url-method-badge method-badge m-' + req.method.toLowerCase();
  document.getElementById('previewUrl').textContent = req.url;

  setKvTable('headersTbody', 'headersTable', 'noHeaders', Object.entries(req.headers || {}));
  setKvTable('paramsTbody',  'paramsTable',  'noParams',  Object.entries(req.params  || {}));

  const bodyBlock = document.getElementById('bodyBlock');
  if (req.body) {
    document.getElementById('noBody').classList.add('hidden');
    bodyBlock.classList.remove('hidden');
    try { bodyBlock.textContent = JSON.stringify(JSON.parse(req.body), null, 2); }
    catch (_) { bodyBlock.textContent = req.body; }
  } else {
    document.getElementById('noBody').classList.remove('hidden');
    bodyBlock.classList.add('hidden');
  }

  const auth = req.auth || {};
  if (auth.type && auth.type !== 'none') {
    document.getElementById('noAuth').classList.add('hidden');
    document.getElementById('authBlock').classList.remove('hidden');
    document.getElementById('authType').textContent = String(auth.type).replace('_', ' ').toUpperCase();
    setKvTable('authTbody', 'authTable', null, Object.entries(auth).filter(([k]) => k !== 'type'));
  } else {
    document.getElementById('authBlock').classList.add('hidden');
    document.getElementById('noAuth').classList.remove('hidden');
  }

  switchTab('headers');
}

function switchTab(name) {
  document.querySelectorAll('.tab-button').forEach(b => b.classList.toggle('active', b.dataset.tab === name));
  document.querySelectorAll('.tab-section').forEach(p => p.classList.toggle('active', p.id === 'tab-' + name));
}


// Events
function bindEvents() {
  document.getElementById('searchInput')?.addEventListener('input', e => renderList(e.target.value));
  document.getElementById('collectionSelect')?.addEventListener('change', e => {
    activeCol = e.target.value;
    renderList(document.getElementById('searchInput')?.value || '');
  });
  document.querySelectorAll('.tab-button').forEach(b => b.addEventListener('click', () => switchTab(b.dataset.tab)));

  function callHost(method, params) {
    const id = nextHostCallId++;
    return new Promise((resolve, reject) => {
      const timeout = setTimeout(() => {
        pendingHostCalls.delete(id);
        reject(new Error('Host call timeout: ' + method));
      }, 8000);
      pendingHostCalls.set(id, { resolve, reject, timeout });
      window.parent.postMessage({ jsonrpc: '2.0', id, method, params }, '*');
    });
  }

  document.getElementById('addBtn')?.addEventListener('click', async () => {
    if (!selected) return;
    const btn = document.getElementById('addBtn');
    const orig = btn.innerHTML;
    const payload = {
      content: [{ type: 'text', text:
        'Saved API request selected:\nID: ' + selected.id +
        '\nName: ' + selected.name +
        '\nMethod: ' + selected.method +
        '\nURL: ' + selected.url +
        '\nCollection: ' + (selected.collectionId || 'unknown') +
        '\n\nRequest JSON:\n' + JSON.stringify(selected, null, 2),
      }],
      request_id: selected.id,
      request: selected,
    };
    try {
      await callHost('ui/update-model-context', payload).catch(() => callHost('ui/updateModelContext', payload));
      btn.innerHTML = 'Added';
    } catch (e) {
      console.error(e);
      btn.innerHTML = 'Failed';
    }
    setTimeout(() => { btn.innerHTML = orig; }, 1300);
  });
}

// Initialization
function init() {
  buildCollectionSelect();
  renderList();
  bindEvents();
  resetPreview();
}

init();
</script>
</body>
</html>
'''
      .replaceFirst('__BASE_STYLE__', baseStyle)
      .replaceFirst('__INITIAL_TREE_JSON__', initialJson);
}
