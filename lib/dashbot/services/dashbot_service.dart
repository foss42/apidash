import 'package:ollama_dart/ollama_dart.dart';
import 'package:apidash/models/request_model.dart';
import 'package:apidash/dashbot/features/explain.dart';
import 'package:apidash/dashbot/features/debug.dart';
import 'package:apidash/dashbot/features/response_generator.dart';

class DashBotService {
  final OllamaClient _client;
  late final ExplainFeature _explainFeature;
  late final DebugFeature _debugFeature;
  final ResponseGenerator _responseGenerator;

  DashBotService()
      : _client = OllamaClient(baseUrl: 'http://127.0.0.1:11434/api'),
        _responseGenerator = ResponseGenerator(OllamaClient(baseUrl: 'http://127.0.0.1:11434/api')) {

    // Initialize features in the constructor body after all final fields are initialized
    _explainFeature = ExplainFeature(this);
    _debugFeature = DebugFeature(this);
  }

  Future<String> generateResponse(String prompt) async {
    return _responseGenerator.generateResponse(prompt);
  }

  Future<String> handleRequest(String input, RequestModel? requestModel, dynamic responseModel) async {
    if (input == "Explain API") {
      return _explainFeature.explainLatestApi(requestModel: requestModel, responseModel: responseModel);
    } else if(input == "Debug API") {
      return _debugFeature.debugApi(requestModel: requestModel, responseModel: responseModel);
    }

    // Pass request context to generate more relevant responses
    return _responseGenerator.generateResponse(input, requestModel: requestModel, responseModel: responseModel);
  }
}
