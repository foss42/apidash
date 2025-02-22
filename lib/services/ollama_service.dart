import 'package:ollama_dart/ollama_dart.dart';

class OllamaService {
  final OllamaClient _client;

  OllamaService() : _client = OllamaClient(baseUrl: 'http://127.0.0.1:11434');

  // Generate responses for general queries
  Future<String> generateResponse(String prompt) async {
    final response = await _client.generateCompletion(
      request: GenerateCompletionRequest(
          model: 'deepseek-r1:1.5b',
          prompt: prompt
      ),
    );
    return response.response.toString();
  }

  // Explain API responses
  Future<String> explainApiResponse(Map<String, dynamic> response) async {
    final prompt = '''
    Explain this API response in natural language with bullet points. Highlight discrepancies:
    $response
    ''';
    return generateResponse(prompt);
  }

  // Debug based on status code/error
  Future<String> debugRequest(int statusCode, String error) async {
    final prompt = '''
    Provide structured debugging steps for HTTP $statusCode. Error: $error.
    Format as bullet points.
    ''';
    return generateResponse(prompt);
  }

  // Generate test cases
  Future<String> generateTestCases(String endpoint, String language) async {
    final prompt = '''
    Generate $language test cases for API endpoint: $endpoint.
    Include edge cases and status code checks.
    ''';
    return generateResponse(prompt);
  }
}
