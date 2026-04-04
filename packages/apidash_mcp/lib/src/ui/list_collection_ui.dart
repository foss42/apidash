import 'dart:convert';

String buildListCollectionsHtml({
  required List<Map<String, String>> collections,
}) {
  final collectionsJson = jsonEncode(collections);

  return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }

    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
      background: #f0f2f5;
      padding: 20px;
    }

    @keyframes slideUp {
      from { opacity: 0; transform: translateY(8px); }
      to   { opacity: 1; transform: none; }
    }

    .outer-card {
      background: #ffffff;
      border-radius: 16px;
      border: 1px solid #e8eaed;
      box-shadow:
        0 1px 3px rgba(0,0,0,0.06),
        0 4px 16px rgba(0,0,0,0.04);
      overflow: hidden;
      animation: slideUp 0.3s ease both;
    }

    .outer-header {
      padding: 18px 20px;
      border-bottom: 1px solid #f0f2f5;
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .outer-header-icon {
      width: 36px;
      height: 36px;
      background: linear-gradient(135deg, #4f7ef8, #7c5cfc);
      border-radius: 10px;
    }

    .outer-header-text { flex: 1; }

    .outer-header-title {
      font-size: 14px;
      font-weight: 600;
      color: #111827;
    }

    .outer-header-sub {
      font-size: 11px;
      color: #9ca3af;
      margin-top: 2px;
    }

    .count-pill {
      background: #f3f4f6;
      border: 1px solid #e5e7eb;
      color: #6b7280;
      font-family: monospace;
      font-size: 11px;
      padding: 4px 10px;
      border-radius: 20px;
    }

    .search-wrap {
      padding: 14px 16px 10px;
      border-bottom: 1px solid #f0f2f5;
    }

    .search-inner {
      display: flex;
      align-items: center;
      background: #f9fafb;
      border: 1px solid #e5e7eb;
      border-radius: 10px;
      padding: 8px 12px;
    }

    .search-inner input {
      border: none;
      background: transparent;
      outline: none;
      font-size: 13px;
      width: 100%;
    }

    .list-area {
      padding: 12px 16px 16px;
      display: flex;
      flex-direction: column;
      gap: 8px;
    }

    .collection-card {
      background: #ffffff;
      border: 1px solid #e8eaed;
      border-radius: 12px;
      padding: 13px 15px;
      display: flex;
      align-items: center;
      gap: 12px;
      animation: slideUp 0.25s ease both;
    }

    .card-icon-wrap {
      width: 38px;
      height: 38px;
      background: linear-gradient(135deg, #eef2ff, #f5f3ff);
      border-radius: 10px;
    }

    .card-body { flex: 1; }

    .card-name {
      font-size: 13px;
      font-weight: 500;
      color: #111827;
    }

    .card-id {
      font-family: monospace;
      font-size: 10px;
      color: #c4c9d4;
      margin-top: 3px;
    }

    .empty {
      text-align: center;
      padding: 40px 20px;
      color: #c4c9d4;
      font-size: 13px;
    }
  </style>
</head>
<body>

  <div class="outer-card">

    <div class="outer-header">
      <div class="outer-header-text">
        <div class="outer-header-title">Collections</div>
        <div class="outer-header-sub">API Dash Workspace</div>
      </div>
      <span class="count-pill" id="countPill"></span>
    </div>

    <div class="search-wrap">
      <div class="search-inner">
        <input id="searchInput" type="text" placeholder="Search..." oninput="filterList()">
      </div>
    </div>

    <div class="list-area" id="listArea"></div>

  </div>

  <script>
    const collections = $collectionsJson;

    const listArea = document.getElementById("listArea");
    const countPill = document.getElementById("countPill");

    countPill.textContent = collections.length + " total";

    function renderList(items) {
      if (!items.length) {
        listArea.innerHTML = '<div class="empty">No collections found</div>';
        return;
      }

      listArea.innerHTML = items.map((c, i) => \`
        <div class="collection-card">
          <div class="card-body">
            <div class="card-name">\${c.name}</div>
            <div class="card-id">\${c.id}</div>
          </div>
        </div>
      \`).join("");
    }

    function filterList() {
      const q = document.getElementById("searchInput").value.toLowerCase();
      renderList(collections.filter(c =>
        c.name.toLowerCase().includes(q) ||
        c.id.toLowerCase().includes(q)
      ));
    }

    renderList(collections);
  </script>

</body>
</html>
''';
}