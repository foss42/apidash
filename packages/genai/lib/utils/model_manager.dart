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

  /// Fetches the models a provider makes available to the given credentials
  /// (e.g. `GET /models` for OpenAI-compatible providers).
  ///
  /// Returns `null` when the provider cannot list models, credentials are
  /// missing, or the request/response cannot be understood. The static
  /// bundled list remains the fallback in all of those cases.
  static Future<List<Model>?> fetchProviderModels(
    ModelAPIProvider provider, {
    required AIRequestModel aiRequestModel,
  }) async {
    try {
      final modelProvider = kModelProvidersMap[provider];
      final request = modelProvider?.createListModelsRequest(aiRequestModel);
      if (request == null) {
        return null;
      }
      final (resp, _, _) = await sendHttpRequest(
        'FETCH_PROVIDER_MODELS_${provider.name}',
        APIType.rest,
        request,
        noSSL: provider == ModelAPIProvider.ollama,
      );
      if (resp == null) {
        return null;
      }
      return modelProvider?.parseListModelsResponse(resp.body);
    } catch (e) {
      debugPrint('fetchProviderModels -> ${e.toString()}');
      return null;
    }
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

  static Future<List<Model>?> fetchInstalledOllamaModels({
    String? ollamaUrl,
  }) async {
    // All available models
    // final url = "${ollamaUrl ?? kBaseOllamaUrl}/api/tags";
    // All loaded models
    final url = "${ollamaUrl ?? kBaseOllamaUrl}/api/ps";

    try {
      final (resp, _, msg) = await sendHttpRequest(
        'OLLAMA_FETCH',
        APIType.rest,
        HttpRequestModel(url: url, method: HTTPVerb.get),
        noSSL: true,
      );
      // debugPrint("fetchInstalledOllamaModels -> $url -> ${resp?.body} -> $msg");
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
}
