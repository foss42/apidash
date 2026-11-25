import 'dart:convert';

import 'package:better_networking/better_networking.dart';
import '../../models/models.dart';
import '../consts.dart';

class GeminiModel extends ModelProvider {
  static final instance = GeminiModel();

  @override
  AIRequestModel get defaultAIRequestModel => kDefaultAiRequestModel.copyWith(
    modelApiProvider: ModelAPIProvider.gemini,
    url: kGeminiUrl,
    modelConfigs: [
      kDefaultModelConfigTemperature,
      kDefaultGeminiModelConfigTopP,
      kDefaultGeminiModelConfigMaxTokens,
    ],
  );

  @override
  HttpRequestModel? createRequest(AIRequestModel? aiRequestModel) {
    if (aiRequestModel == null) {
      return null;
    }
    List<NameValueModel> params = [];
    String endpoint = "${aiRequestModel.url}/${aiRequestModel.model}:";
    if (aiRequestModel.stream ?? false) {
      endpoint += 'streamGenerateContent';
      params.add(const NameValueModel(name: "alt", value: "sse"));
    } else {
      endpoint += 'generateContent';
    }

    return HttpRequestModel(
      method: HTTPVerb.post,
      url: endpoint,
      authModel: aiRequestModel.apiKey == null
          ? null
          : AuthModel(
              type: APIAuthType.apiKey,
              apikey: AuthApiKeyModel(
                key: aiRequestModel.apiKey!,
                location: 'query',
                name: 'key',
              ),
            ),
      body: kJsonEncoder.convert({
        "contents": [
          {
            "role": "user",
            "parts": [
              {"text": aiRequestModel.userPrompt},
            ],
          },
        ],
        "systemInstruction": {
          "role": "system",
          "parts": [
            {"text": aiRequestModel.systemPrompt},
          ],
        },
        "generationConfig": aiRequestModel.getModelConfigMap(),
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

  @override
  HttpRequestModel? createListModelsRequest(AIRequestModel? aiRequestModel) {
    final apiKey = aiRequestModel?.apiKey;
    if (apiKey == null || apiKey.isEmpty) {
      return null;
    }
    final url =
        (aiRequestModel?.url.isNotEmpty ?? false)
            ? aiRequestModel!.url
            : kGeminiUrl;
    return HttpRequestModel(
      method: HTTPVerb.get,
      url: url,
      authModel: AuthModel(
        type: APIAuthType.apiKey,
        apikey: AuthApiKeyModel(
          key: apiKey,
          location: 'query',
          name: 'key',
        ),
      ),
    );
  }

  @override
  List<Model>? parseListModelsResponse(String body) {
    try {
      final models = jsonDecode(body)['models'];
      if (models is! List) return null;
      return [
        for (final m in models)
          if (m is Map && m['name'] is String)
            Model(
              id: (m['name'] as String).replaceFirst('models/', ''),
              name:
                  (m['displayName'] as String?) ??
                  (m['name'] as String).replaceFirst('models/', ''),
            ),
      ];
    } catch (_) {
      return null;
    }
  }
}
