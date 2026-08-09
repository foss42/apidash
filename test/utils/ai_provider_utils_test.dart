import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';
import 'package:apidash/utils/ai_provider_utils.dart';

void main() {
  group('safeAIRequestModelFromJson', () {
    test('drops unknown provider without crashing', () {
      final model = safeAIRequestModelFromJson({
        'modelApiProvider': 'totally-unknown',
        'model': 'foo',
      });
      expect(model.modelApiProvider, isNull);
      expect(model.model, 'foo');
    });
  });

  group('listConfiguredLLMs', () {
    test('returns only ready providers', () {
      final list = listConfiguredLLMs({
        'openai': {'apiKey': 'sk'},
        'anthropic': {'apiKey': ''},
        'custom_1': {
          'compat': 'openai',
          'displayName': 'Custom',
          'apiKey': 'custom-key',
          'url': 'https://llm.example.com/v1/chat/completions',
          'models': ['x'],
          'lastModel': 'x',
        },
      });
      expect(list.map((e) => e.id).toSet(), {'openai', 'custom_1'});
    });
  });

  group('resolveAIRequestFromLLM', () {
    test('uses genai defaults for custom openai-compat', () {
      const llm = ConfiguredLLM(
        id: 'custom_1',
        displayName: 'Custom',
        compat: ModelAPIProvider.openai,
        apiKey: 'k',
        url: 'https://example.com/v1/chat/completions',
        models: ['m1'],
        lastModel: 'm1',
        isCustom: true,
      );
      final req = resolveAIRequestFromLLM(llm);
      expect(req.modelApiProvider, ModelAPIProvider.openai);
      expect(req.model, 'm1');
      expect(req.url, 'https://example.com/v1/chat/completions');
      expect(req.modelConfigs, isNotEmpty);
    });
  });

  group('applyProviderCredentials', () {
    test('fills apiKey from store', () {
      final model = AIRequestModel(
        modelApiProvider: ModelAPIProvider.openai,
        model: 'gpt-4o',
        url: kOpenAIUrl,
        apiKey: '',
      );
      final result = applyProviderCredentials(model, {
        'openai': {'apiKey': 'sk-test'},
      });
      expect(result.apiKey, 'sk-test');
    });

    test('custom endpoint uses custom_ entry not builtin', () {
      final model = AIRequestModel(
        modelApiProvider: ModelAPIProvider.openai,
        model: 'my-model',
        apiKey: 'custom-key',
        url: 'https://llm.example.com/v1/chat/completions',
      );
      final result = applyProviderCredentials(model, {
        'openai': {'apiKey': 'openai-key', 'url': kOpenAIUrl},
        'custom_1': {
          'compat': 'openai',
          'apiKey': 'custom-key-updated',
          'url': 'https://llm.example.com/v1/chat/completions',
          'models': ['my-model'],
          'lastModel': 'my-model',
        },
      });
      expect(result.apiKey, 'custom-key-updated');
    });
  });

  group('migrateAiProvidersFromDefault', () {
    test('seeds from defaultAIModel when empty', () {
      final migrated = migrateAiProvidersFromDefault(null, {
        'modelApiProvider': 'gemini',
        'apiKey': 'g-key',
        'url': kGeminiUrl,
      });
      expect(migrated?['gemini']?['apiKey'], 'g-key');
    });
  });
}
