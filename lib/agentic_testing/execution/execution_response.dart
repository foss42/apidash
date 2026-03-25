class ExecutionResponse {
  final int? statusCode;
  final Map<String, String>? headers;
  final String? body;
  final Duration? time;
  final String? error;

  const ExecutionResponse({
    this.statusCode,
    this.headers,
    this.body,
    this.time,
    this.error,
  });

  bool get isSuccess => statusCode != null && statusCode! >= 200 && statusCode! < 300;
}