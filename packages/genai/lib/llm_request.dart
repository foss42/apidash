class LLMRequestDetails {
  String endpoint;
  Map<String, String> headers;
  String method;
  Map<String, dynamic> body;

  LLMRequestDetails({
    required this.endpoint,
    required this.headers,
    required this.method,
    required this.body,
  });
}
