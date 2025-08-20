import 'package:ollama_dart/ollama_dart.dart';
import '../../models/models.dart';
import '../consts.dart';

class GeneralQueryFeature {
  final OllamaClient _client;

  GeneralQueryFeature(this._client);

  Future<String> generateResponse(String prompt,
      {RequestModel? requestModel, dynamic responseModel}) async {
    String enhancedPrompt = prompt;

    if (requestModel != null && responseModel != null) {
      final method = requestModel.httpRequestModel?.method
              .toString()
              .split('.')
              .last
              .toUpperCase() ??
          "GET";
      final endpoint = requestModel.httpRequestModel?.url ?? "Unknown Endpoint";
      final statusCode = responseModel.statusCode ?? 0;

      enhancedPrompt = '''
CONTEXT-AWARE RESPONSE

**User Question:**
$prompt

**Related API Context:**
- Endpoint: $endpoint
- Method: $method
- Status Code: $statusCode

**Instructions:**
1. Directly address the user's specific question
2. Provide relevant, concise information
3. Reference the API context when helpful
4. Focus on practical, actionable insights
5. Avoid generic explanations or documentation

Respond in a helpful, direct manner that specifically answers what was asked.
''';
    }

    final response = await _client.generateCompletion(
      request: GenerateCompletionRequest(
        model: kModel,
        prompt: enhancedPrompt,
      ),
    );
    return response.response.toString();
  }
}
