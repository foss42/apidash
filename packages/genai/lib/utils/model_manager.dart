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

  static Future<List<Model>?> fetchInstalledOllamaModels({
    String? ollamaUrl,
  }) async {
    final url = "${ollamaUrl ?? kBaseOllamaUrl}/api/tags";
    List<Model> ollamaModels = [const Model(id: '', name: 'Custom')];

    try {
      final (resp, _, _) = await sendHttpRequest(
        'OLLAMA_FETCH',
        APIType.rest,
        HttpRequestModel(url: url, method: HTTPVerb.get),
        noSSL: true,
      );
      if (resp != null) {
        final output = jsonDecode(resp.body);
        final models = output['models'];
        if (models is List) {
          for (final m in models) {
            if (m is Map) {
              final mModel = m['model']?.toString() ?? "";
              final mName = m['name']?.toString() ?? "";
              final modelId = mModel.isNotEmpty ? mModel : mName;
              final modelName = mName.isNotEmpty ? mName : mModel;
              if (modelId.isNotEmpty || modelName.isNotEmpty) {
                ollamaModels.add(Model(id: modelId, name: modelName));
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint('fetchInstalledOllamaModels -> ${e.toString()}');
    }
    return ollamaModels;
  }
}
