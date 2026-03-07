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
  HttpRequestModel? createRequest(AIRequestModel? aiRequestModel) {
    if (aiRequestModel == null) return null;

    if (aiRequestModel.url.endsWith('/api/generate')) {
      return HttpRequestModel(
        method: HTTPVerb.post,
        url: aiRequestModel.url,
        authModel: aiRequestModel.apiKey == null
            ? null
            : AuthModel(
                type: APIAuthType.bearer,
                bearer: AuthBearerModel(token: aiRequestModel.apiKey!),
              ),
        body: kJsonEncoder.convert({
          "model": aiRequestModel.model ?? "",
          "prompt": aiRequestModel.userPrompt.isNotEmpty ? aiRequestModel.userPrompt : "Generate",
          if (aiRequestModel.systemPrompt.isNotEmpty) "system": aiRequestModel.systemPrompt,
          ...aiRequestModel.getModelConfigMap(),
          if (aiRequestModel.stream != null) "stream": aiRequestModel.stream,
        }),
      );
    }

    return super.createRequest(aiRequestModel);
  }

  @override
  String? outputFormatter(Map x) {
    if (x.containsKey("response")) {
      return x["response"];
    }
    if (x.containsKey("message") && x["message"] is Map) {
      return x["message"]["content"];
    }
    return super.outputFormatter(x);
  }

  @override
  String? streamOutputFormatter(Map x) {
    if (x.containsKey("response")) {
      return x["response"];
    }
    if (x.containsKey("message") && x["message"] is Map) {
      return x["message"]["content"];
    }
    return super.streamOutputFormatter(x);
  }
}
