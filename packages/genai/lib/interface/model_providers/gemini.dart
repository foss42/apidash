import 'package:better_networking/better_networking.dart';
import '../../models/models.dart';
import '../consts.dart';

class GeminiModel extends ModelProvider {
  static final instance = GeminiModel();

  @override
  ModelRequestData get defaultRequestData => kDefaultModelRequestData.copyWith(
    url: kGeminiUrl,
    modelConfigs: [
      kDefaultModelConfigTemperature,
      kDefaultGeminiModelConfigTopP,
      kDefaultGeminiModelConfigMaxTokens,
    ],
  );

  @override
  HttpRequestModel? createRequest(ModelRequestData? requestData) {
    if (requestData == null) {
      return null;
    }
    List<NameValueModel> params = [];
    String endpoint = "${requestData.url}/${requestData.model}:";
    if (requestData.stream ?? false) {
      endpoint += 'streamGenerateContent';
      params.add(const NameValueModel(name: "alt", value: "sse"));
    } else {
      endpoint += 'generateContent';
    }

    return HttpRequestModel(
      method: HTTPVerb.post,
      url: endpoint,
      authModel: AuthModel(
        type: APIAuthType.apiKey,
        apikey: AuthApiKeyModel(
          key: requestData.apiKey,
          location: 'query',
          name: 'key',
        ),
      ),
      body: kJsonEncoder.convert({
        "contents": [
          {
            "role": "user",
            "parts": [
              {"text": requestData.userPrompt},
            ],
          },
        ],
        "systemInstruction": {
          "role": "system",
          "parts": [
            {"text": requestData.systemPrompt},
          ],
        },
        "generationConfig": requestData.getModelConfigMap(),
      }),
    );
  }

  @override
  String? outputFormatter(Map x) {
    return x['candidates']?[0]?['content']?['parts']?[0]?['text'];
  }

  @override
  String? streamOutputFormatter(Map x) {
    return x['candidates']?[0]?['content']?['parts']?[0]?['text'];
  }
}
