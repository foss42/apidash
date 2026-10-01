import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/utils/file_utils.dart';

const kAIProviderDisplayNames = <ModelAPIProvider, String>{
  ModelAPIProvider.openai: 'OpenAI',
  ModelAPIProvider.anthropic: 'Anthropic',
  ModelAPIProvider.gemini: 'Gemini',
  ModelAPIProvider.azureopenai: 'Azure OpenAI',
  ModelAPIProvider.ollama: 'Ollama',
};

const kCustomProviderPrefix = 'custom_';
const kCompatOpenAI = 'openai';

class ConfiguredLLM {
  const ConfiguredLLM({
    required this.id,
    required this.displayName,
    required this.compat,
    this.apiKey,
    this.url,
    this.models = const [],
    this.lastModel,
    this.isCustom = false,
  });

  final String id;
  final String displayName;
  final ModelAPIProvider compat;
  final String? apiKey;
  final String? url;
  final List<String> models;
  final String? lastModel;
  final bool isCustom;

  bool get requiresApiKey => compat != ModelAPIProvider.ollama;

  bool get isReady {
    if (!requiresApiKey) return true;
    return apiKey != null && apiKey!.isNotEmpty;
  }
}

bool isCustomProviderId(String id) => id.startsWith(kCustomProviderPrefix);

String newCustomProviderId() => '$kCustomProviderPrefix${getNewUuid()}';

bool providerRequiresApiKey(ModelAPIProvider provider) =>
    provider != ModelAPIProvider.ollama;

String providerDisplayName(ModelAPIProvider provider) =>
    kAIProviderDisplayNames[provider] ?? provider.name;

ModelAPIProvider? tryParseBuiltinProvider(String id) {
  try {
    return ModelAPIProvider.values.byName(id);
  } catch (_) {
    return null;
  }
}

ModelAPIProvider compatFromEntry(Map<String, Object?> entry, String id) {
  final builtin = tryParseBuiltinProvider(id);
  if (builtin != null) return builtin;
  final raw = entry['compat'];
  if (raw is String) {
    final parsed = tryParseBuiltinProvider(raw);
    if (parsed != null) return parsed;
  }
  return ModelAPIProvider.openai;
}

ConfiguredLLM? configuredLLMFromEntry(String id, Map<String, Object?> entry) {
  final compat = compatFromEntry(entry, id);
  final apiKey = entry['apiKey'] is String ? entry['apiKey'] as String : null;
  final url = entry['url'] is String ? entry['url'] as String : null;
  final lastModel =
      entry['lastModel'] is String ? entry['lastModel'] as String : null;

  final models = entry['models'] is List
      ? (entry['models'] as List)
          .whereType<String>()
          .where((e) => e.isNotEmpty)
          .toList()
      : const <String>[];

  final modelId = (lastModel != null && lastModel.isNotEmpty)
      ? lastModel
      : (models.isNotEmpty ? models.first : null);
  final displayName = (modelId != null && modelId.isNotEmpty)
      ? modelId
      : (isCustomProviderId(id) ? 'Custom' : providerDisplayName(compat));

  final llm = ConfiguredLLM(
    id: id,
    displayName: displayName,
    compat: compat,
    apiKey: apiKey,
    url: url,
    models: models,
    lastModel: lastModel,
    isCustom: isCustomProviderId(id),
  );
  return llm.isReady ? llm : null;
}

List<ConfiguredLLM> listConfiguredLLMs(
  Map<String, Map<String, Object?>>? aiProviders,
) {
  if (aiProviders == null || aiProviders.isEmpty) return const [];
  final result = <ConfiguredLLM>[];
  for (final entry in aiProviders.entries) {
    final llm = configuredLLMFromEntry(entry.key, entry.value);
    if (llm != null) result.add(llm);
  }
  result.sort((a, b) => a.displayName.compareTo(b.displayName));
  return result;
}

String? defaultEndpointFor(ModelAPIProvider provider) {
  final url =
      kModelProvidersMap[provider]?.defaultAIRequestModel.url ?? '';
  return url.isEmpty ? null : url;
}

AIRequestModel resolveAIRequestFromLLM(
  ConfiguredLLM llm, {
  String? model,
}) {
  final selectedModel = model?.isNotEmpty == true
      ? model
      : (llm.lastModel?.isNotEmpty == true
          ? llm.lastModel
          : (llm.models.isNotEmpty ? llm.models.first : null));
  final base = kModelProvidersMap[llm.compat]?.defaultAIRequestModel ??
      kDefaultAiRequestModel;
  final endpoint =
      (llm.url != null && llm.url!.isNotEmpty) ? llm.url! : base.url;
  return base.copyWith(
    modelApiProvider: llm.compat,
    model: selectedModel ?? base.model,
    apiKey: llm.apiKey ?? base.apiKey,
    url: endpoint,
  );
}

Map<String, Object?> defaultAIModelToJson(AIRequestModel model) {
  return model
      .copyWith(
        modelConfigs: const [],
        stream: null,
        systemPrompt: '',
        userPrompt: '',
      )
      .toJson();
}

AIRequestModel withProviderDefaultConfigs(AIRequestModel model) {
  if (model.modelConfigs.isNotEmpty) return model;
  final provider = model.modelApiProvider;
  final defaults =
      kModelProvidersMap[provider]?.defaultAIRequestModel.modelConfigs ??
          kDefaultAiRequestModel.modelConfigs;
  if (defaults.isEmpty) return model;
  return model.copyWith(modelConfigs: List<ModelConfig>.from(defaults));
}

AIRequestModel safeAIRequestModelFromJson(Map<String, Object?>? json) {
  if (json == null || json.isEmpty) return const AIRequestModel();
  final sanitized = Map<String, Object?>.from(json);
  final rawProvider = sanitized['modelApiProvider'];
  if (rawProvider is String &&
      rawProvider.isNotEmpty &&
      !ModelAPIProvider.values.any((e) => e.name == rawProvider)) {
    sanitized['modelApiProvider'] = null;
  }
  try {
    return AIRequestModel.fromJson(sanitized);
  } catch (_) {
    return AIRequestModel(
      url: sanitized['url'] is String ? sanitized['url'] as String : '',
      model: sanitized['model'] is String ? sanitized['model'] as String : null,
      apiKey:
          sanitized['apiKey'] is String ? sanitized['apiKey'] as String : null,
    );
  }
}

Map<String, Object?>? _credentialEntryFor(
  AIRequestModel model,
  Map<String, Map<String, Object?>>? aiProviders,
) {
  if (aiProviders == null || aiProviders.isEmpty) return null;
  final provider = model.modelApiProvider;
  if (provider == null) return null;

  if (model.url.isNotEmpty) {
    for (final entry in aiProviders.entries) {
      if (!isCustomProviderId(entry.key)) continue;
      final u = entry.value['url'];
      if (u is String && u.isNotEmpty && u == model.url) {
        return entry.value;
      }
    }
  }

  final builtin = aiProviders[provider.name];
  if (builtin == null) return null;

  final defaultUrl = defaultEndpointFor(provider) ?? '';
  final storedUrl = builtin['url'];
  final stored = storedUrl is String && storedUrl.isNotEmpty ? storedUrl : null;

  if (model.url.isNotEmpty &&
      model.url != defaultUrl &&
      (stored == null || model.url != stored)) {
    return null;
  }
  return builtin;
}

AIRequestModel applyProviderCredentials(
  AIRequestModel model,
  Map<String, Map<String, Object?>>? aiProviders, {
  bool preferStored = true,
}) {
  var next = model;

  final cred = _credentialEntryFor(model, aiProviders);
  if (cred != null) {
    final storedKey = cred['apiKey'];
    final storedUrl = cred['url'];
    final key = storedKey is String && storedKey.isNotEmpty ? storedKey : null;
    final url = storedUrl is String && storedUrl.isNotEmpty ? storedUrl : null;

    final nextKey = preferStored
        ? (key ?? model.apiKey)
        : ((model.apiKey?.isNotEmpty ?? false) ? model.apiKey : key);
    final nextUrl = preferStored
        ? (url ?? model.url)
        : (model.url.isNotEmpty ? model.url : (url ?? model.url));

    if (nextKey != model.apiKey || nextUrl != model.url) {
      next = model.copyWith(apiKey: nextKey, url: nextUrl);
    }
  }

  return withProviderDefaultConfigs(next);
}

Map<String, Map<String, Object?>> upsertBuiltinProvider(
  Map<String, Map<String, Object?>>? existing,
  ModelAPIProvider provider, {
  String? apiKey,
  String? url,
  String? lastModel,
}) {
  final next = Map<String, Map<String, Object?>>.from(existing ?? {});
  final key = apiKey?.trim() ?? '';
  final endpoint = url?.trim() ?? '';
  final model = lastModel?.trim() ?? '';

  if (providerRequiresApiKey(provider) && key.isEmpty) {
    next.remove(provider.name);
    return next;
  }
  if (key.isEmpty && endpoint.isEmpty && model.isEmpty) {
    next.remove(provider.name);
    return next;
  }

  final prev = Map<String, Object?>.from(next[provider.name] ?? {});
  next[provider.name] = {
    ...prev,
    if (key.isNotEmpty)
      'apiKey': key
    else if (prev['apiKey'] != null)
      'apiKey': prev['apiKey'],
    if (endpoint.isNotEmpty)
      'url': endpoint
    else if (prev['url'] != null)
      'url': prev['url'],
    if (model.isNotEmpty)
      'lastModel': model
    else if (prev['lastModel'] != null)
      'lastModel': prev['lastModel'],
  };
  return next;
}

Map<String, Map<String, Object?>> upsertCustomProvider(
  Map<String, Map<String, Object?>>? existing, {
  String? id,
  String? displayName,
  required String apiKey,
  required String url,
  required List<String> models,
  String? lastModel,
  String compat = kCompatOpenAI,
}) {
  final next = Map<String, Map<String, Object?>>.from(existing ?? {});
  final entryId = (id != null && id.isNotEmpty) ? id : newCustomProviderId();
  final key = apiKey.trim();
  final endpoint = url.trim();
  final modelList =
      models.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  final active = lastModel?.trim().isNotEmpty == true
      ? lastModel!.trim()
      : (modelList.isNotEmpty ? modelList.first : null);
  final name = (displayName != null && displayName.trim().isNotEmpty)
      ? displayName.trim()
      : (active ?? '');

  if (name.isEmpty || key.isEmpty || endpoint.isEmpty || active == null) {
    return next;
  }

  next[entryId] = {
    'compat': compat,
    'displayName': name,
    'apiKey': key,
    'url': endpoint,
    'models': modelList.isNotEmpty ? modelList : [active],
    'lastModel': active,
  };
  return next;
}

Map<String, Map<String, Object?>> removeProviderCredential(
  Map<String, Map<String, Object?>>? existing,
  String id,
) {
  final next = Map<String, Map<String, Object?>>.from(existing ?? {});
  next.remove(id);
  return next;
}

Map<String, Map<String, Object?>> setProviderLastModel(
  Map<String, Map<String, Object?>>? existing,
  String providerId,
  String model,
) {
  final next = Map<String, Map<String, Object?>>.from(existing ?? {});
  final prev = Map<String, Object?>.from(next[providerId] ?? {});
  if (prev.isEmpty) return next;
  prev['lastModel'] = model;
  next[providerId] = prev;
  return next;
}
