import 'package:better_networking/better_networking.dart';
import '../../models/models.dart';
import '../consts.dart';

class AzureOpenAIModel extends ModelProvider {
  static final instance = AzureOpenAIModel();
  @override
  ModelRequestData get defaultRequestData => kDefaultModelRequestData;

  @override
  HttpRequestModel? createRequest(ModelRequestData? requestData) {
    if (requestData == null) {
      return null;
    }
    if (requestData.url.isEmpty) {
      throw Exception('MODEL ENDPOINT IS EMPTY');
    }
    return HttpRequestModel(
      method: HTTPVerb.post,
      url: requestData.url,
      authModel: AuthModel(
        type: APIAuthType.apiKey,
        apikey: AuthApiKeyModel(key: requestData.apiKey, name: 'api-key'),
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
