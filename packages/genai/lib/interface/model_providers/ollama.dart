import 'package:better_networking/better_networking.dart';
import '../../models/models.dart';
import '../consts.dart';
import 'openai.dart';

class OllamaModel extends OpenAIModel {
  static final instance = OllamaModel();

  @override
  AIRequestModel get defaultAIRequestModel => kDefaultAiRequestModel.copyWith(
    modelApiProvider: ModelAPIProvider.ollama,
    url: kOllamaUrl,
    modelConfigs: [kDefaultModelConfigTemperature, kDefaultModelConfigTopP],
  );

  @override
  HttpRequestModel? createListModelsRequest(AIRequestModel? aiRequestModel) {
    // Ollama's OpenAI-compatible /v1/models endpoint needs no credentials.
    return HttpRequestModel(
      method: HTTPVerb.get,
      url: OpenAIModel.listModelsUrl(
        (aiRequestModel?.url.isNotEmpty ?? false)
            ? aiRequestModel!.url
            : kOllamaUrl,
      ),
    );
  }
}
