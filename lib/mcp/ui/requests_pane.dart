class RequestsPane {
  static String get html => r'''
  <!-- Pane 1: Request Studio -->
  <div id="pane-studio" class="ad-pane active" style="max-width: 740px; margin: 12px auto 0 auto; padding: 0 14px 40px 14px; width: 100%; box-sizing: border-box;">
    
    <!-- Top Meta Row -->
    <div class="ad-row-meta">
      <div class="ad-meta-cluster">
        <div class="ad-pill">HTTP <span class="ad-carets">▲<br>▼</span></div>
        <span class="ad-req-title" title="untitled">untitled</span>
      </div>
      <div class="ad-meta-cluster">
        <div class="ad-icon-bar">
          <button id="btnReqEdit" title="Edit Request Name"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/></svg></button>
          <button id="btnReqDelete" title="Clear/Delete Request"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/></svg></button>
          <button id="btnReqDuplicate" title="Copy Request JSON"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M16 1H4c-1.1 0-2 .9-2 2v14h2V3h12V1zm3 4H8c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h11c1.1 0 2-.9 2-2V7c0-1.1-.9-2-2-2zm0 16H8V7h11v14z"/></svg></button>
        </div>
        <select id="activeEnvSelector" class="sub-select sm" style="background: var(--bg-surface); border: 1px solid var(--border-color); color: var(--text-main); padding: 4px 10px; border-radius: 6px; font-size: 12px; font-weight: 500; cursor: pointer; outline: none;">
  <option value="global">Global</option>
</select>
      </div>
    </div>
    
    <!-- URL & Method Bar -->
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

    <!-- Request Builder Bottom Half -->
    <div class="req-builder-card" id="builderCardCanvas">
      <div class="req-subnav">
        <div class="req-sub-tabs">
          <button class="req-sub-tab active" data-sub="sub-params">Params</button>
          <button class="req-sub-tab" data-sub="sub-auth">Auth</button>
          <button class="req-sub-tab" data-sub="sub-headers">Headers</button>
          <button class="req-sub-tab" data-sub="sub-body">Body</button>
          <button class="req-sub-tab" data-sub="sub-scripts">Scripts</button>
        </div>
        <button class="btn-view-code-sub" id="btnReqViewCode"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M9.4 16.6L4.8 12l4.6-4.6L8 6l-6 6 6 6 1.4-1.4zm5.2 0l4.6-4.6-4.6-4.6L16 6l6 6-6 6-1.4-1.4z"/></svg><span>View Code</span></button>
      </div>

      <div class="req-sub-viewport">
        <!-- Params Tab -->
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

        <!-- Auth Tab -->
        <div id="sub-auth" class="req-sub-pane">
          <div style="display:flex; flex-direction:column; gap:6px; max-width:220px;">
            <label class="sub-label">Authentication Type</label>
            <select class="sub-select" id="authSelectProxy">
              <option selected>None</option>
              <option>Basic Auth</option><option>API Key</option><option>Bearer Token</option><option>JWT Bearer</option><option>Digest Auth</option><option>OAuth 1.0</option><option>OAuth 2.0</option>
            </select>
          </div>
          <div class="auth-notice" id="authHelperText">No authentication selected.</div>
        </div>

        <!-- Headers Tab -->
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

        <!-- Body Tab -->
        <div id="sub-body" class="req-sub-pane">
          <div class="sub-toolbar">
            <span class="sub-label" style="color:var(--text-muted); text-transform:none">Select Content Type:</span>
            <select class="sub-select sm"><option selected>json</option><option>text</option><option>formdata</option></select>
          </div>
          <div class="editor-wrap"><textarea class="code-surface" id="reqBodyTextarea" placeholder="Enter JSON"></textarea></div>
        </div>

        <!-- Scripts Tab -->
        <div id="sub-scripts" class="req-sub-pane">
          <div class="sub-toolbar">
            <select class="sub-select sm" style="width:130px;"><option selected>Pre Request</option><option>Post Response</option></select>
            <button class="btn-learn-sub"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="12" height="12"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 16h-2v-2h2v2zm1.07-7.75l-.9.92C12.45 11.9 12 12.5 12 14h-2v-.5c0-1.1.45-2.1 1.17-2.83l1.24-1.26c.37-.36.59-.86.59-1.41 0-1.1-.9-2-2-2s-2 .9-2 2H7c0-2.76 2.24-5 5-5s5 2.24 5 5c0 1.04-.42 1.99-1.07 2.75z" fill="currentColor"/></svg><span>Learn</span></button>
          </div>
          <div class="editor-wrap"><textarea class="code-surface" placeholder="// Write execution hooks here..."></textarea></div>
        </div>
      </div>
    </div>

    <!-- Results Analyzer View -->
    <div class="res-analyzer-card" id="resultsCardCanvas" style="display: none;">
      <div class="res-top-bar">
        <div class="res-badge-cluster">
          <button class="btn-exit-results" onclick="exitResultsView()"><svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m12 19-7-7 7-7"/><path d="M19 12H5"/></svg><span>Back to Builder</span></button>
          <span class="res-status-code ok" id="resStatusCodeLabel">200: OK</span>
        </div>
        <div class="res-meta-stats"><span id="resTimeLabel">0 ms</span><span id="resSizeLabel">0 B</span></div>
      </div>
      <div class="res-subnav-strip">
        <button class="res-sub-btn active" onclick="switchResSub('body')">Response Body</button>
        <button class="res-sub-btn" onclick="switchResSub('headers')">Response Headers</button>
      </div>
      <div id="resViewBodyWrapper" class="res-content-box" style="display:flex;"><pre class="res-payload-pre" id="resPayloadPre">No response body loaded.</pre></div>
      <div id="resViewHeadersWrapper" class="res-content-box" style="display:none; color:var(--text-label);"><div id="resHeadersContainer">No custom headers captured in this response.</div></div>
    </div>
  </div>
  ''';
}