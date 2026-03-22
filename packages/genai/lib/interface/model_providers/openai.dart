import 'package:better_networking/better_networking.dart';
import '../../models/models.dart';
import '../consts.dart';

class OpenAIModel extends ModelProvider {
  static final instance = OpenAIModel();

  @override
  AIRequestModel get defaultAIRequestModel => kDefaultAiRequestModel.copyWith(
    modelApiProvider: ModelAPIProvider.openai,
    url: kOpenAIUrl,
  );

  @override
  HttpRequestModel? createRequest(AIRequestModel? aiRequestModel) {
    if (aiRequestModel == null) {
      return null;
    }
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
        "model": aiRequestModel.model,
        "messages": [
          {"role": "system", "content": aiRequestModel.systemPrompt},
          if (aiRequestModel.userPrompt.isNotEmpty) ...{
            {"role": "user", "content": aiRequestModel.userPrompt},
          } else ...{
            {"role": "user", "content": "Generate"},
          },
        ],
        ...aiRequestModel.getModelConfigMap(),
        if (aiRequestModel.stream ?? false) ...{'stream': true},
      }),
    );
  }

  @override
  String? outputFormatter(Map x) {
    return x["choices"]?[0]["message"]?["content"]?.trim();
  }

  @override
  String? streamOutputFormatter(Map x) {
    return x["choices"]?[0]["delta"]?["content"];
  }
}
