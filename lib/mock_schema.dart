const Map<String, dynamic> mockSchema = {
  "layout": "table",
  "columns": [
    { "field": "name", "type": "text" },
    { "field": "age", "type": "chart" },
    { "field": "active", "type": "toggle" },
    { "field": "status", "type": "dropdown" }
  ]
};

const List<Map<String, dynamic>> mockData = [
  { "name": "Alice", "age": 30, "active": true, "status": "pending" },
  { "name": "Bob", "age": 28, "active": false, "status": "approved" },
  { "name": "Charlie", "age": 35, "active": true, "status": "pending" }
];
