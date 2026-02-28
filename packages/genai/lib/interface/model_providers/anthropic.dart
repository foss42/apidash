import 'package:better_networking/better_networking.dart';
import '../../models/models.dart';
import '../consts.dart';

class AnthropicModel extends ModelProvider {
  static final instance = AnthropicModel();

  @override
  AIRequestModel get defaultAIRequestModel => kDefaultAiRequestModel.copyWith(
    modelApiProvider: ModelAPIProvider.anthropic,
    url: kAnthropicUrl,
  );

  @override
  HttpRequestModel? createRequest(AIRequestModel? aiRequestModel) {
    if (aiRequestModel == null) {
      return null;
    }
    return HttpRequestModel(
      method: HTTPVerb.post,
      url: aiRequestModel.url,
      headers: const [
        NameValueModel(name: "anthropic-version", value: "2023-06-01"),
      ],
      authModel: aiRequestModel.apiKey == null
          ? null
          : AuthModel(
              type: APIAuthType.apiKey,
              apikey: AuthApiKeyModel(key: aiRequestModel.apiKey!),
            ),
      body: kJsonEncoder.convert({
        "model": aiRequestModel.model,
        "messages": [
          {"role": "system", "content": aiRequestModel.systemPrompt},
          {"role": "user", "content": aiRequestModel.userPrompt},
        ],
        ...aiRequestModel.getModelConfigMap(),
        if (aiRequestModel.stream ?? false) ...{'stream': true},
      }),
    );
  }

  @override
  String? outputFormatter(Map x) {
    return x['content']?[0]['text'];
  }

  @override
  String? streamOutputFormatter(Map x) {
    return x['text'];
  }
}
