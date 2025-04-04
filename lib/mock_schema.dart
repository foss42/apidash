const Map<String, dynamic> mockSchema = {
  "layout": "",
  "columns": [
    { "field": "name", "type": "text" },
    { "field": "age", "type": "chart" },
    { "field": "active", "type": "toggle" },
    { "field": "status", "type": "dropdown" },
    { "field": "joinedAt", "type": "date" },
    { "field": "score", "type": "slider" }
  ]
};

const List<Map<String, dynamic>> mockData = [
  {
    "name": "Alice",
    "age": 30,
    "active": true,
    "status": "pending",
    "joinedAt": "2023-01-01",
    "score": 60
  },
  {
    "name": "Bob",
    "age": 28,
    "active": false,
    "status": "approved",
    "joinedAt": "2022-12-15",
    "score": 80
  },
  {
    "name": "Charlie",
    "age": 35,
    "active": true,
    "status": "rejected",
    "joinedAt": "2023-02-10",
    "score": 90
  },
  {
    "name": "Dave",
    "age": 32,
    "active": false,
    "status": "approved",
    "joinedAt": "2023-03-05",
    "score": 70
  }
];
