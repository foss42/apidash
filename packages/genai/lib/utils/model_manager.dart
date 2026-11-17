import 'dart:convert';
import 'package:better_networking/better_networking.dart';
import 'package:flutter/foundation.dart';
import '../consts.dart';
import '../interface/interface.dart';
import '../models/models.dart';

class ModelManager {
  static Future<AvailableModels?> fetchModelsFromRemote({
    String? remoteURL,
  }) async {
    try {
      final (resp, _, _) = await sendHttpRequest(
        'FETCH_MODELS',
        APIType.rest,
        HttpRequestModel(
          url: remoteURL ?? kModelRemoteUrl,
          method: HTTPVerb.get,
        ),
      );
      if (resp == null) {
        debugPrint('fetchModelsFromRemote -> resp == null');
      } else {
        var remoteModels = availableModelsFromJson(resp.body);
        return remoteModels;
      }
    } catch (e) {
      debugPrint('fetchModelsFromRemote -> ${e.toString()}');
    }
    return null;
  }

  static Future<AvailableModels> fetchAvailableModels({
    String? ollamaUrl,
  }) async {
    try {
      final oM = await fetchInstalledOllamaModels(ollamaUrl: ollamaUrl);
      if (oM != null) {
        List<AIModelProvider> l = [];
        for (var prov in kAvailableModels.modelProviders) {
          if (prov.providerId == ModelAPIProvider.ollama) {
            l.add(
              prov.copyWith(
                providerId: prov.providerId,
                providerName: prov.providerName,
                sourceUrl: prov.sourceUrl,
                models: oM,
              ),
            );
          } else {
            l.add(prov);
          }
        }
        return kAvailableModels.copyWith(
          version: kAvailableModels.version,
          modelProviders: l,
        );
      }
    } catch (e) {
      debugPrint('fetchAvailableModels -> ${e.toString()}');
    }
    return kAvailableModels;
  }

  static List<Model> knownModelsFor(ModelAPIProvider provider) {
    return (kAvailableModels.map[provider]?.models ?? const [])
        .where((m) => m.id != null && m.id!.isNotEmpty)
        .toList(growable: false);
  }

  static Future<List<Model>?> fetchProviderModels({
    required ModelAPIProvider provider,
    String? apiKey,
    String? url,
  }) async {
    final key = apiKey?.trim() ?? '';
    switch (provider) {
      case ModelAPIProvider.ollama:
        return fetchInstalledOllamaModels(
          ollamaUrl: ollamaHostFromEndpoint(url),
        );
      case ModelAPIProvider.openai:
        if (key.isEmpty) return null;
        return _fetchDataIdModels(
          modelsUrl: _modelsUrlFromChatUrl(url ?? kOpenAIUrl),
          apiKey: key,
        );
      case ModelAPIProvider.anthropic:
        if (key.isEmpty) return null;
        return _fetchDataIdModels(
          modelsUrl: 'https://api.anthropic.com/v1/models',
          apiKey: key,
          headers: const [
            NameValueModel(name: 'anthropic-version', value: '2023-06-01'),
          ],
          auth: AuthModel(
            type: APIAuthType.apiKey,
            apikey: AuthApiKeyModel(key: key),
          ),
          nameKey: 'display_name',
        );
      case ModelAPIProvider.gemini:
        if (key.isEmpty) return null;
        return _fetchGeminiModels(apiKey: key, modelsBaseUrl: url);
      case ModelAPIProvider.azureopenai:
        return null;
    }
  }

  static String ollamaHostFromEndpoint(String? url) {
    final uri = Uri.tryParse(url?.trim() ?? '');
    if (uri == null || uri.host.isEmpty) return kBaseOllamaUrl;
    final port = uri.hasPort ? ':${uri.port}' : '';
    return '${uri.scheme}://${uri.host}$port';
  }

  static String _modelsUrlFromChatUrl(String chatUrl) {
    if (chatUrl.contains('/chat/completions')) {
      return chatUrl.replaceFirst('/chat/completions', '/models');
    }
    return 'https://api.openai.com/v1/models';
  }

  static Future<List<Model>?> fetchInstalledOllamaModels({
    String? ollamaUrl,
  }) async {
    final url = "${ollamaUrl ?? kBaseOllamaUrl}/api/tags";
    try {
      final (resp, _, msg) = await sendHttpRequest(
        'OLLAMA_FETCH',
        APIType.rest,
        HttpRequestModel(url: url, method: HTTPVerb.get),
        noSSL: true,
      );
      if (resp == null) {
        return null;
      }
      final output = jsonDecode(resp.body);
      final models = output['models'];
      if (models == null) return [];
      List<Model> ollamaModels = [];
      for (final m in models) {
        ollamaModels.add(Model(id: m['model'], name: m['name']));
      }
      return ollamaModels;
    } catch (e) {
      debugPrint('fetchInstalledOllamaModels -> ${e.toString()}');
      return null;
    }
  }

  static Future<List<Model>?> _fetchDataIdModels({
    required String modelsUrl,
    required String apiKey,
    List<NameValueModel>? headers,
    AuthModel? auth,
    String nameKey = 'id',
  }) async {
    try {
      final (resp, _, _) = await sendHttpRequest(
        'PROVIDER_MODELS_FETCH',
        APIType.rest,
        HttpRequestModel(
          url: modelsUrl,
          method: HTTPVerb.get,
          headers: headers,
          authModel: auth ??
              AuthModel(
                type: APIAuthType.bearer,
                bearer: AuthBearerModel(token: apiKey),
              ),
        ),
      );
      if (resp == null || resp.statusCode != 200) return null;
      final data = jsonDecode(resp.body)['data'];
      if (data is! List) return null;
      final models = <Model>[
        for (final m in data)
          if (m is Map && m['id'] != null)
            Model(
              id: m['id'].toString(),
              name: (m[nameKey] ?? m['id']).toString(),
            ),
      ];
      models.sort((a, b) => (a.id ?? '').compareTo(b.id ?? ''));
      return models;
    } catch (e) {
      debugPrint('_fetchDataIdModels -> $e');
      return null;
    }
  }

  static Future<List<Model>?> _fetchGeminiModels({
    required String apiKey,
    String? modelsBaseUrl,
  }) async {
    final base = (modelsBaseUrl != null && modelsBaseUrl.trim().isNotEmpty)
        ? modelsBaseUrl.trim().replaceAll(RegExp(r'/$'), '')
        : kGeminiUrl;
    try {
      final (resp, _, _) = await sendHttpRequest(
        'GEMINI_MODELS_FETCH',
        APIType.rest,
        HttpRequestModel(
          url: '$base?key=${Uri.encodeQueryComponent(apiKey)}',
          method: HTTPVerb.get,
        ),
      );
      if (resp == null || resp.statusCode != 200) return null;
      final arr = jsonDecode(resp.body)['models'];
      if (arr is! List) return null;
      final models = <Model>[
        for (final m in arr)
          if (m is Map && m['name'] != null)
            Model(
              id: m['name'].toString().split('/').last,
              name: (m['displayName'] ?? m['name']).toString(),
            ),
      ];
      models.sort((a, b) => (a.id ?? '').compareTo(b.id ?? ''));
      return models;
    } catch (e) {
      debugPrint('_fetchGeminiModels -> $e');
      return null;
    }
  }
}
