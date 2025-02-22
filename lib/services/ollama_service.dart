import 'dart:convert';
import 'package:ollama_dart/ollama_dart.dart';

class OllamaService {
  final OllamaClient _client;

  OllamaService() : _client = OllamaClient(baseUrl: 'http://127.0.0.1:11434/api');

  // Generate response
  Future<String> generateResponse(String prompt) async {
    final response = await _client.generateCompletion(
      request: GenerateCompletionRequest(
          model: 'llama3.2:3b',
          prompt: prompt
      ),
    );
    return response.response.toString();
  }

  // Explain latest API request & response
  Future<String> explainLatestApi({required dynamic requestModel, required dynamic responseModel}) async {
    if (requestModel == null || responseModel == null) {
      return "There are no recent API Requests.";
    }

    final requestJson = jsonEncode(requestModel.toJson());
    final responseJson = jsonEncode(responseModel.toJson());

    final prompt = '''
    Explain the API request and response in a simple way:
    
    **Request Details:**
    $requestJson
    
    **Response Details:**
    $responseJson
    
    Please provide a brief and clear explanation with key insights.
    ''';
    return generateResponse(prompt);
  }
}
