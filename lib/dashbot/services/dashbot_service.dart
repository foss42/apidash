import 'package:ollama_dart/ollama_dart.dart';
import 'package:apidash/models/request_model.dart';
import '../consts.dart';
import '../features/features.dart';

class DashBotService {
  final OllamaClient _client;
  late final ExplainFeature _explainFeature;
  late final DebugFeature _debugFeature;
  late final DocumentationFeature _documentationFeature;
  late final TestGeneratorFeature _testGeneratorFeature;
  final GeneralQueryFeature _generalQueryFeature;

  DashBotService()
      : _client = OllamaClient(baseUrl: kOllamaEndpoint),
        _generalQueryFeature =
            GeneralQueryFeature(OllamaClient(baseUrl: kOllamaEndpoint)) {
    _explainFeature = ExplainFeature(this);
    _debugFeature = DebugFeature(this);
    _documentationFeature = DocumentationFeature(this);
    _testGeneratorFeature = TestGeneratorFeature(this);
  }

  Future<String> generateResponse(String prompt) async {
    return _generalQueryFeature.generateResponse(prompt);
  }

  Future<String> handleRequest(
    String input,
    RequestModel? requestModel,
    dynamic responseModel,
  ) async {
    if (input == "Explain API") {
      return _explainFeature.explainLatestApi(
        requestModel: requestModel,
        responseModel: responseModel,
      );
    } else if (input == "Debug API") {
      return _debugFeature.debugApi(
        requestModel: requestModel,
        responseModel: responseModel,
      );
    } else if (input == "Document API") {
      return _documentationFeature.generateApiDocumentation(
        requestModel: requestModel,
        responseModel: responseModel,
      );
    } else if (input == "Test API") {
      return _testGeneratorFeature.generateApiTests(
        requestModel: requestModel,
        responseModel: responseModel,
      );
    }

    return _generalQueryFeature.generateResponse(
      input,
      requestModel: requestModel,
      responseModel: responseModel,
    );
  }
}
