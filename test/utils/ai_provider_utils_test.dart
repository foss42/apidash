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

    test('keeps known provider', () {
      final model = safeAIRequestModelFromJson({
        'modelApiProvider': 'openai',
        'model': 'gpt-4o',
        'apiKey': 'sk-x',
      });
      expect(model.modelApiProvider, ModelAPIProvider.openai);
      expect(model.model, 'gpt-4o');
    });
  });

  group('listConfiguredLLMs', () {
    test('returns only ready providers', () {
      final list = listConfiguredLLMs({
        'openai': {'apiKey': 'sk'},
        'anthropic': {'apiKey': ''},
        'custom_1': {
          'compat': 'openai',
          'displayName': 'OpenRouter',
          'apiKey': 'or-key',
          'url': 'https://openrouter.ai/api/v1/chat/completions',
          'models': ['x'],
          'lastModel': 'x',
        },
      });
      expect(list.map((e) => e.id).toSet(), {'openai', 'custom_1'});
      expect(listConfiguredLLMs({'anthropic': {}}), isEmpty);
    });

    test('ollama only when explicitly added', () {
      expect(listConfiguredLLMs(null), isEmpty);
      expect(
        listConfiguredLLMs({
          'ollama': {'url': 'http://localhost:11434/v1/chat/completions'},
        }).single.id,
        'ollama',
      );
    });
  });

  group('upsertCustomProvider', () {
    test('creates custom entry', () {
      final next = upsertCustomProvider(
        null,
        id: 'custom_abc',
        displayName: 'Groq',
        apiKey: 'g-key',
        url: 'https://api.groq.com/openai/v1/chat/completions',
        models: ['llama-3.1'],
      );
      expect(next['custom_abc']?['displayName'], 'Groq');
      expect(next['custom_abc']?['compat'], 'openai');
      expect(next['custom_abc']?['lastModel'], 'llama-3.1');
    });
  });

  group('resolveAIRequestFromLLM', () {
    test('uses openai compat for custom', () {
      const llm = ConfiguredLLM(
        id: 'custom_1',
        displayName: 'OR',
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
      expect(req.apiKey, 'k');
    });
  });

  group('applyProviderCredentials', () {
    test('fills apiKey and url from store', () {
      final model = AIRequestModel(
        modelApiProvider: ModelAPIProvider.openai,
        model: 'gpt-4o',
        url: kOpenAIUrl,
        apiKey: '',
      );
      final providers = {
        'openai': {'apiKey': 'sk-test', 'url': 'https://custom.example/v1'},
      };

      final result = applyProviderCredentials(model, providers);

      expect(result.apiKey, 'sk-test');
      expect(result.url, 'https://custom.example/v1');
      expect(result.model, 'gpt-4o');
    });

    test('preferStored false keeps request key', () {
      final model = AIRequestModel(
        modelApiProvider: ModelAPIProvider.openai,
        model: 'gpt-4o',
        apiKey: 'request-key',
      );
      final providers = {
        'openai': {'apiKey': 'settings-key'},
      };

      final result = applyProviderCredentials(
        model,
        providers,
        preferStored: false,
      );

      expect(result.apiKey, 'request-key');
    });
  });

  group('upsertBuiltinProvider', () {
    test('adds and removes provider entries', () {
      final added = upsertBuiltinProvider(
        null,
        ModelAPIProvider.anthropic,
        apiKey: ' ant-key ',
        url: '',
      );
      expect(added['anthropic']?['apiKey'], 'ant-key');

      final removed = upsertBuiltinProvider(
        added,
        ModelAPIProvider.anthropic,
        apiKey: '',
        url: '',
      );
      expect(removed.containsKey('anthropic'), isFalse);
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
      expect(migrated?['gemini']?['url'], kGeminiUrl);
    });

    test('ignores unknown provider ids', () {
      final migrated = migrateAiProvidersFromDefault(null, {
        'modelApiProvider': 'customopenai',
        'apiKey': 'k',
        'url': kOpenAIUrl,
      });
      expect(migrated, isNull);
    });

    test('does not overwrite existing store', () {
      final existing = {
        'openai': {'apiKey': 'keep'},
      };
      final migrated = migrateAiProvidersFromDefault(existing, {
        'modelApiProvider': 'gemini',
        'apiKey': 'g-key',
      });

      expect(migrated, same(existing));
    });
  });
}
