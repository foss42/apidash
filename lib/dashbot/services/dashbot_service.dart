import 'package:apidash/dashbot/features/debug.dart';
import 'package:apidash/dashbot/features/documentation.dart';
import 'package:ollama_dart/ollama_dart.dart';
import 'package:apidash/dashbot/features/explain.dart';
import 'package:apidash/dashbot/features/test_generator.dart'; // New import
import 'package:apidash/models/request_model.dart';
import 'package:apidash/dashbot/features/general_query.dart';

class DashBotService {
  final OllamaClient _client;
  late final ExplainFeature _explainFeature;
  late final DebugFeature _debugFeature;
  late final DocumentationFeature _documentationFeature;
  late final TestGeneratorFeature _testGeneratorFeature; // New feature
  final GeneralQueryFeature _generalQueryFeature;

  DashBotService()
      : _client = OllamaClient(baseUrl: 'http://127.0.0.1:11434/api'),
        _generalQueryFeature = GeneralQueryFeature(OllamaClient(baseUrl: 'http://127.0.0.1:11434/api')) {
    _explainFeature = ExplainFeature(this);
    _debugFeature = DebugFeature(this);
    _documentationFeature = DocumentationFeature(this);
    _testGeneratorFeature = TestGeneratorFeature(this); // Initialize new feature
  }

  Future<String> generateResponse(String prompt) async {
    return _generalQueryFeature.generateResponse(prompt);
  }

  Future<String> handleRequest(
      String input, RequestModel? requestModel, dynamic responseModel) async {
    if (input == "Explain API") {
      return _explainFeature.explainLatestApi(
          requestModel: requestModel, responseModel: responseModel);
    } else if (input == "Debug API") {
      return _debugFeature.debugApi(
          requestModel: requestModel, responseModel: responseModel);
    } else if (input == "Document API") {
      return _documentationFeature.generateApiDocumentation(
          requestModel: requestModel, responseModel: responseModel);
    } else if (input == "Test API") { // New condition
      return _testGeneratorFeature.generateApiTests(
          requestModel: requestModel, responseModel: responseModel);
    }

    return _generalQueryFeature.generateResponse(input, requestModel: requestModel, responseModel: responseModel);
  }
}
