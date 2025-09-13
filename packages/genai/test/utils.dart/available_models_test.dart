import 'package:flutter_test/flutter_test.dart';
import 'package:genai/models/available_models.dart';
import 'package:genai/interface/interface.dart';

void main() {
  group('AvailableModels', () {
    test('can parse from JSON and back', () {
      const jsonString = '''
      {
        "version": 1.0,
        "model_providers": [
          {
            "provider_id": "openai",
            "provider_name": "OpenAI",
            "source_url": "https://api.openai.com",
            "models": [
              {"id": "gpt-4", "name": "GPT-4"}
            ]
          }
        ]
      }
      ''';

      final models = availableModelsFromJson(jsonString);
      expect(models.version, 1.0);
      expect(models.modelProviders.length, 1);
      expect(models.modelProviders.first.providerName, "OpenAI");

      final backToJson = availableModelsToJson(models);
      expect(backToJson.contains("GPT-4"), true);
    });

    test('map getter returns map of providers', () {
      const provider = AIModelProvider(
        providerId: ModelAPIProvider.openai,
        providerName: "OpenAI",
        models: [Model(id: "gpt-4", name: "GPT-4")],
      );

      const available = AvailableModels(
        version: 1.0,
        modelProviders: [provider],
      );

      expect(available.map.containsKey(ModelAPIProvider.openai), true);
      expect(available.map[ModelAPIProvider.openai]?.providerName, "OpenAI");
    });
  });

  group('AIModelProvider', () {
    test(
      'toAiRequestModel returns default AIRequestModel with model override',
      () {
        const provider = AIModelProvider(
          providerId: ModelAPIProvider.openai,
          providerName: "OpenAI",
        );

        const model = Model(id: "gpt-4", name: "GPT-4");
        final req = provider.toAiRequestModel(model: model);

        expect(req?.model, "gpt-4");
      },
    );
  });

  group('Model', () {
    test('fromJson works', () {
      final model = Model.fromJson({"id": "mistral", "name": "Mistral"});
      expect(model.id, "mistral");
      expect(model.name, "Mistral");
    });
  });
}
