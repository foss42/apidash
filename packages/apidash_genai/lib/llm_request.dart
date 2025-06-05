import 'package:apidash_genai/llm_config.dart';

class LLMRequestDetails {
  final String endpoint;
  final Map<String, String> headers;
  final String method;
  final Map<String, dynamic> body;

  LLMRequestDetails({
    required this.endpoint,
    required this.headers,
    required this.method,
    required this.body,
  });
}
