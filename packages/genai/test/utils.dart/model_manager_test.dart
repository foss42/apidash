import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:genai/models/available_models.dart';
import 'package:genai/utils/model_manager.dart';

void main() {
  group('ModelManager', () {
    test('fetchModelsFromRemote returns parsed models', () async {
      final result = await ModelManager.fetchModelsFromRemote();
      expect(result, isA<AvailableModels>());
    });

    test('fetchInstalledOllamaModels parses response', () async {
      final body = jsonEncode({
        "models": [
          {"model": "mistral", "name": "Mistral"},
          {"model": "llama2", "name": "LLaMA 2"},
        ],
      });
      final result = await ModelManager.fetchInstalledOllamaModels();
      expect(result, isNotNull);
    });
  });
}
