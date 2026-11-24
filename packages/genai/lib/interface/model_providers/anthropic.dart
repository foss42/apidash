import 'dart:convert';

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
        if (aiRequestModel.systemPrompt.isNotEmpty)
          "system": aiRequestModel.systemPrompt,
        "messages": [
          {
            "role": "user",
            "content": aiRequestModel.userPrompt.isNotEmpty
                ? aiRequestModel.userPrompt
                : "Generate",
          },
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

  @override
  HttpRequestModel? createListModelsRequest(AIRequestModel? aiRequestModel) {
    final apiKey = aiRequestModel?.apiKey;
    if (apiKey == null || apiKey.isEmpty) {
      return null;
    }
    return HttpRequestModel(
      method: HTTPVerb.get,
      url: kAnthropicModelsUrl,
      headers: const [
        NameValueModel(name: "anthropic-version", value: "2023-06-01"),
      ],
      authModel: AuthModel(
        type: APIAuthType.apiKey,
        apikey: AuthApiKeyModel(key: apiKey),
      ),
    );
  }

  @override
  List<Model>? parseListModelsResponse(String body) {
    try {
      final data = jsonDecode(body)['data'];
      if (data is! List) return null;
      return [
        for (final m in data)
          if (m is Map && m['id'] is String)
            Model(
              id: m['id'] as String,
              name: (m['display_name'] as String?) ?? m['id'] as String,
            ),
      ];
    } catch (_) {
      return null;
    }
  }
}
