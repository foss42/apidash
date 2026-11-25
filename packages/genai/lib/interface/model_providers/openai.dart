import 'dart:convert';

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

  @override
  HttpRequestModel? createListModelsRequest(AIRequestModel? aiRequestModel) {
    final apiKey = aiRequestModel?.apiKey;
    if (apiKey == null || apiKey.isEmpty) {
      return null;
    }
    return HttpRequestModel(
      method: HTTPVerb.get,
      url: listModelsUrl(aiRequestModel?.url),
      authModel: AuthModel(
        type: APIAuthType.bearer,
        bearer: AuthBearerModel(token: apiKey),
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
            Model(id: m['id'] as String, name: m['id'] as String),
      ];
    } catch (_) {
      return null;
    }
  }

  /// Derives the `GET /models` endpoint from a chat-completions URL so
  /// OpenAI-compatible providers (custom base URLs) work too.
  static String listModelsUrl(String? chatUrl) {
    var base =
        (chatUrl != null && chatUrl.isNotEmpty) ? chatUrl : kOpenAIUrl;
    base = base.replaceAll(RegExp(r'/chat/completions.*$'), '');
    if (base.endsWith('/models')) return base;
    return '$base/models';
  }
}
