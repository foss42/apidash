import 'package:better_networking/better_networking.dart';
import '../../models/models.dart';
import '../consts.dart';

class AnthropicModel extends ModelProvider {
  static final instance = AnthropicModel();

  @override
  ModelRequestData get defaultRequestData =>
      kDefaultModelRequestData.copyWith(url: kAnthropicUrl);

  @override
  HttpRequestModel? createRequest(ModelRequestData? requestData) {
    if (requestData == null) {
      return null;
    }
    return HttpRequestModel(
      method: HTTPVerb.post,
      url: requestData.url,
      headers: const [
        NameValueModel(name: "anthropic-version", value: "2023-06-01"),
      ],
      authModel: AuthModel(
        type: APIAuthType.apiKey,
        apikey: AuthApiKeyModel(key: requestData.apiKey),
      ),
      body: kJsonEncoder.convert({
        "model": requestData.model,
        "messages": [
          {"role": "system", "content": requestData.systemPrompt},
          {"role": "user", "content": requestData.userPrompt},
        ],
        ...requestData.getModelConfigMap(),
        if (requestData.stream ?? false) ...{'stream': true},
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
