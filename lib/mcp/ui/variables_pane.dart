class VariablesPane {
  static String get html => r'''
  <!-- Pane 2: Variables -->
  <div id="pane-vars" class="ad-pane" style="flex-direction: row; padding: 0; gap: 0; border-top: 1px solid var(--border-divider); height: 100%; box-sizing: border-box; position: relative;">
    
    <!-- OVERLAY LEFT SIDEBAR -->
    <div id="vars-sidebar" style="display: none; position: absolute; z-index: 1000; left: 0; top: 0; bottom: 0; width: 280px; background-color: var(--bg-surface) !important; border-right: 1px solid var(--border-color); box-shadow: 8px 0 30px rgba(0, 0, 0, 0.5); flex-direction: column; height: 100%; flex-shrink: 0;">
      
      <!-- Row 1: Header & Exit Button -->
      <div style="padding: 16px 16px 8px 16px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border-color);">
        <span style="font-size: 12px; font-weight: 700; color: var(--text-label); text-transform: uppercase; letter-spacing: 0.5px;">Environments</span>
        <button onclick="document.getElementById('vars-sidebar').style.display = 'none';" style="background: transparent; border: none; color: var(--text-muted); cursor: pointer; display: grid; place-items: center; padding: 4px; border-radius: 4px; transition: all 0.2s;" title="Close Panel">
          <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
        </button>
      </div>

      <!-- Row 2: Action Buttons -->
      <div style="padding: 12px 16px; display: flex; justify-content: space-between; align-items: center;">
        <button id="btnSaveEnv" onclick="console.log('Hook: Save triggered')" style="background: transparent; border: 1px solid var(--border-color); color: var(--text-main); padding: 6px 12px; border-radius: 4px; display: flex; align-items: center; gap: 6px; font-size: 12px; cursor: pointer; font-family: inherit;">
          <svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor"><path d="M17 3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V7l-4-4zm-5 16c-1.66 0-3-1.34-3-3s1.34-3 3-3 3 1.34 3 3-1.34 3-3 3zm3-10H5V5h10v4z"/></svg>
          Save
        </button>
        <button id="btnNewEnv" onclick="console.log('Hook: New Env triggered')" style="background: var(--btn-send-bg); border: none; color: var(--btn-send-text); padding: 6px 14px; border-radius: 4px; font-size: 12px; cursor: pointer; display: flex; align-items: center; font-weight: 600; font-family: inherit;">
          + New
        </button>
      </div>

      <!-- Filter Input -->
      <div style="padding: 0 16px 12px 16px;">
        <div style="position: relative; width: 100%;">
          <svg viewBox="0 0 24 24" width="14" height="14" fill="var(--text-muted)" style="position: absolute; left: 10px; top: 50%; transform: translateY(-50%);"><path d="M10 18h4v-2h-4v2zM3 6v2h18V6H3zm3 7h12v-2H6v2z"/></svg>
          <input type="text" id="envFilterInput" placeholder="Filter by name" style="width: 100%; background: var(--bg-input); border: 1px solid var(--border-color); border-radius: 4px; padding: 7px 8px 7px 30px; color: var(--text-main); font-size: 13px; outline: none; box-sizing: border-box; font-family: inherit;">
        </div>
      </div>

      <!-- Environment List Container -->
      <div id="envListContainer" style="flex: 1; overflow-y: auto; padding: 0 16px; display: flex; flex-direction: column; gap: 4px;">
        <div class="env-item active" data-env-id="global" style="background: var(--bg-surface-hover); border-left: 2px solid var(--border-hover); color: var(--text-tab-active); padding: 8px 12px; border-radius: 0 4px 4px 0; font-size: 13px; font-weight: 500; cursor: pointer; display: flex; justify-content: space-between; align-items: center;">
          <span>Global</span>
          <span style="font-size: 10px; background: var(--bg-input); border: 1px solid var(--border-color); color: var(--text-label); padding: 2px 6px; border-radius: 4px;">Default</span>
        </div>
      </div>
    </div>

    <!-- RIGHT MAIN CANVAS: Key-Value Editor -->
    <div style="flex: 1; background: var(--bg-canvas); display: flex; flex-direction: column; height: 100%; width: 100%; overflow: hidden;">
      
      <!-- Top Action Bar -->
      <div style="display: flex; justify-content: space-between; align-items: center; padding: 16px 24px; border-bottom: 1px solid var(--border-divider);">
        <div style="display: flex; align-items: center; gap: 12px;">
          <button id="btnToggleEnvSidebar" onclick="const sb = document.getElementById('vars-sidebar'); sb.style.display = sb.style.display === 'none' ? 'flex' : 'none';" style="background: var(--bg-surface); border: 1px solid var(--border-color); color: var(--text-muted); cursor: pointer; display: flex; align-items: center; justify-content: center; padding: 6px 10px; border-radius: 4px; font-size: 12px; gap: 6px; font-family: inherit;">
            <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"></rect><line x1="9" y1="3" x2="9" y2="21"></line></svg>
            <span>Environments</span>
          </button>
          <h2 id="activeEnvNameDisplay" style="font-size: 15px; font-weight: 500; color: var(--text-main); margin: 0; font-family: inherit;">Global</h2>
        </div>
        
        <div class="ad-icon-bar" style="background: var(--bg-surface); border: 1px solid var(--border-color);">
          <button id="btnRenameEnv" title="Rename Environment"><svg viewBox="0 0 24 24"><path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/></svg></button>
          <button id="btnDeleteEnv" title="Delete Environment"><svg viewBox="0 0 24 24"><path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/></svg></button>
          <button id="btnDuplicateEnv" title="Duplicate Environment"><svg viewBox="0 0 24 24"><path d="M16 1H4c-1.1 0-2 .9-2 2v14h2V3h12V1zm3 4H8c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h11c1.1 0 2-.9 2-2V7c0-1.1-.9-2-2-2zm0 16H8V7h11v14z"/></svg></button>
        </div>
      </div>

      <!-- Variables Table Area -->
      <div style="flex: 1; padding: 24px; overflow-y: auto;">
        <div style="border: 1px solid var(--border-color); border-radius: 4px; display: flex; flex-direction: column; min-height: 400px; background: var(--bg-surface);">
          
          <div style="display: flex; border-bottom: 1px solid var(--border-color); padding: 12px 16px; font-size: 12px; font-weight: 600; color: var(--text-label); text-transform: uppercase; background: var(--bg-header);">
            <div style="width: 24px;"></div>
            <div style="flex: 1; text-align: center;">Variable Name</div>
            <div style="width: 20px;"></div>
            <div style="flex: 1.5; text-align: center;">Value</div>
            <div style="width: 24px;"></div>
          </div>

          <div class="kv-rows" id="globalVarsList" style="padding: 16px; gap: 12px;">
            <div class="kv-row">
              <input type="checkbox" class="kv-chk" checked>
              <input type="text" class="kv-box k" placeholder="e.g. BASE_URL" style="background: var(--bg-input); border: 1px solid var(--border-color); color: var(--text-main); font-family: var(--font-mono); padding: 8px 12px; border-radius: 4px; font-size: 13px; outline: none;">
              <span class="kv-sep" style="font-weight: bold; margin: 0 8px; color: var(--text-muted); font-size: 14px;">=</span>
              <input type="text" class="kv-box v" placeholder="e.g. https://api.example.com" style="background: var(--bg-input); border: 1px solid var(--border-color); color: var(--text-main); font-family: var(--font-mono); padding: 8px 12px; border-radius: 4px; font-size: 13px; outline: none;">
              <button class="kv-del" title="Delete"><svg viewBox="0 0 24 24"><path d="M15 12H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z" stroke="currentColor" stroke-width="2" fill="none"/></svg></button>
            </div>
          </div>

          <div style="display: flex; justify-content: center; margin-top: auto; padding: 20px 0;">
            <button class="btn-add-row" onclick="addVarRow('globalVarsList', 'Variable Name', 'Value')" style="background: transparent; border: 1px solid var(--border-color); color: var(--text-main); padding: 6px 16px; font-size: 12px; border-radius: 4px; cursor: pointer; font-family: inherit;">
              + Add Variable
            </button>
          </div>
        </div>
      </div>

    </div>
  </div>
  ''';
}