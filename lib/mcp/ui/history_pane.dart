class HistoryPane {
  static String get html => r'''
  <!-- Pane 3: History -->
  <div id="pane-history" class="ad-pane" style="max-width: 740px; margin: 12px auto 0 auto; padding: 0 14px 40px 14px; width: 100%; box-sizing: border-box;">
    <div class="ad-hist-header">
      <span class="ad-hist-title">Session Execution Ledger</span>
      <button class="ad-pill" onclick="fetchHistoryLedger()">↻ Refresh</button>
    </div>
    <div id="history-spinner" class="ad-empty-notice">Querying Hive local database...</div>
    <div id="history-feed" class="ad-history-list"></div>
  </div>
  ''';
}