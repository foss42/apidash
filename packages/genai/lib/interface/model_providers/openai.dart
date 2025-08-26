import 'package:better_networking/better_networking.dart';
import '../../models/models.dart';
import '../consts.dart';

class OpenAIModel extends ModelProvider {
  static final instance = OpenAIModel();

  @override
  ModelRequestData get defaultRequestData =>
      kDefaultModelRequestData.copyWith(url: kOpenAIUrl);

  @override
  HttpRequestModel? createRequest(ModelRequestData? requestData) {
    if (requestData == null) {
      return null;
    }
    return HttpRequestModel(
      method: HTTPVerb.post,
      url: requestData.url,
      authModel: AuthModel(
        type: APIAuthType.bearer,
        bearer: AuthBearerModel(token: requestData.apiKey),
      ),
      body: kJsonEncoder.convert({
        "model": requestData.model,
        "messages": [
          {"role": "system", "content": requestData.systemPrompt},
          if (requestData.userPrompt.isNotEmpty) ...{
            {"role": "user", "content": requestData.userPrompt},
          } else ...{
            {"role": "user", "content": "Generate"},
          },
        ],
        ...requestData.getModelConfigMap(),
        if (requestData.stream ?? false) ...{'stream': true},
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
