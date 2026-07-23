import 'dart:convert';

class ExecutionRecord {
  final String executionId;
  final int statusCode;
  final String method;
  final String url;
  final int timeMs;
  final String responseBody;
  final DateTime timestamp;
  final Map<String, dynamic>? headers;

  const ExecutionRecord({
    required this.executionId,
    required this.statusCode,
    required this.method,
    required this.url,
    required this.timeMs,
    required this.responseBody,
    required this.timestamp,
    this.headers,
  });

  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  Map<String, dynamic> toMap() {
    return {
      'execution_id': executionId,
      'status_code': statusCode,
      'method': method.toUpperCase(),
      'url': url,
      'time_ms': timeMs,
      'response_body': responseBody,
      'timestamp': timestamp.toIso8601String(),
      if (headers != null) 'headers': headers,
    };
  }

  factory ExecutionRecord.fromMap(Map<dynamic, dynamic> map) {
    return ExecutionRecord(
      executionId: map['execution_id']?.toString() ?? 'unknown_id',
      statusCode: int.tryParse(map['status_code']?.toString() ?? '0') ?? 0,
      method: map['method']?.toString().toUpperCase() ?? 'GET',
      url: map['url']?.toString() ?? '',
      timeMs: int.tryParse(map['time_ms']?.toString() ?? '0') ?? 0,
      responseBody: map['response_body']?.toString() ?? 'No Body',
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
      headers: map['headers'] != null ? Map<String, dynamic>.from(map['headers'] as Map) : null,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory ExecutionRecord.fromJson(String source) =>
      ExecutionRecord.fromMap(jsonDecode(source) as Map<String, dynamic>);
}