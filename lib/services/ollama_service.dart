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

  Future<String> debugApi({required dynamic requestModel, required dynamic responseModel}) async {
    if (requestModel == null || responseModel == null) {
      return "There are no recent API Requests to debug.";
    }

    final requestJson = jsonEncode(requestModel.toJson());
    final responseJson = jsonEncode(responseModel.toJson());
    final statusCode = responseModel.statusCode;

    final prompt = '''
    Provide detailed debugging steps for this failed API request:
    
    **Status Code:** $statusCode
    **Request Details:**
    $requestJson
    
    **Response Details:**
    $responseJson
    
    Provide a step-by-step debugging guide including:
    1. Common causes for this status code
    2. Specific issues in the request
    3. Potential fixes
    4. Recommended next steps
    
    Format the response with clear headings and bullet points.
    ''';

    return generateResponse(prompt);
  }
}
