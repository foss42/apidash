import 'package:flutter_test/flutter_test.dart';
import 'package:genai/models/ai_request_model.dart';
import 'package:genai/interface/consts.dart';
import 'package:genai/models/model_config_value.dart';

void main() {
  group('AIRequestModel', () {
    test('should serialize and deserialize from JSON', () {
      final model = AIRequestModel(
        modelApiProvider: ModelAPIProvider.gemini,
        model: 'gemini-pro',
        apiKey: '123',
        systemPrompt: 'system',
        userPrompt: 'user',
        modelConfigs: [kDefaultModelConfigTemperature],
        stream: true,
      );

      final json = model.toJson();
      final fromJson = AIRequestModel.fromJson(json);

      expect(fromJson.modelApiProvider, equals(ModelAPIProvider.gemini));
      expect(fromJson.model, equals('gemini-pro'));
      expect(fromJson.apiKey, equals('123'));
      expect(fromJson.systemPrompt, equals('system'));
      expect(fromJson.userPrompt, equals('user'));
      expect(fromJson.stream, isTrue);
    });

    test('should build config map correctly', () {
      final model = AIRequestModel(
        modelConfigs: [
          kDefaultModelConfigTemperature.copyWith(
            value: ConfigSliderValue(value: (0, 0.8, 1)),
          ),
          kDefaultModelConfigMaxTokens.copyWith(
            value: ConfigNumericValue(value: 200),
          ),
        ],
      );

      final configMap = model.getModelConfigMap();

      expect(configMap['temperature'], equals(0.8));
      expect(configMap['max_tokens'], equals(200));
    });

    test('should return correct config index', () {
      final model = AIRequestModel(
        modelConfigs: [
          kDefaultModelConfigTemperature,
          kDefaultModelConfigMaxTokens,
        ],
      );
      expect(model.getModelConfigIdx('max_tokens'), equals(1));
      expect(model.getModelConfigIdx('foo'), isNull);
    });
  });
}
