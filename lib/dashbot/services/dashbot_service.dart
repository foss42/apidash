import 'package:apidash/dashbot/features/debug.dart';
import 'package:ollama_dart/ollama_dart.dart';
import '../features/explain.dart';
import 'package:apidash/models/request_model.dart';

class DashBotService {
  final OllamaClient _client;
  late final ExplainFeature _explainFeature;
  late final DebugFeature _debugFeature;

  DashBotService()
      : _client = OllamaClient(baseUrl: 'http://127.0.0.1:11434/api') {
    _explainFeature = ExplainFeature(this);
    _debugFeature = DebugFeature(this);
  }

  Future<String> generateResponse(String prompt) async {
    final response = await _client.generateCompletion(
      request: GenerateCompletionRequest(model: 'llama3.2:3b', prompt: prompt),
    );
    return response.response.toString();
  }

  Future<String> handleRequest(
      String input, RequestModel? requestModel, dynamic responseModel) async {
    if (input == "Explain API") {
      return _explainFeature.explainLatestApi(
          requestModel: requestModel, responseModel: responseModel);
    } else if (input == "Debug API") {
      return _debugFeature.debugApi(
          requestModel: requestModel, responseModel: responseModel);
    }

    return generateResponse(input);
  }
}
