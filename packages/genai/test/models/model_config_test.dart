import 'package:flutter_test/flutter_test.dart';
import 'package:genai/models/model_config.dart';
import 'package:genai/models/model_config_value.dart';

void main() {
  group('ModelConfig', () {
    test('constructor asserts correct type/value', () {
      expect(
        () => ModelConfig(
          id: '1',
          name: 'Temperature',
          description: 'test',
          type: ConfigType.boolean,
          value: ConfigBooleanValue(value: true),
        ),
        returnsNormally,
      );

      expect(
        () => ModelConfig(
          id: '2',
          name: 'Invalid',
          description: 'wrong',
          type: ConfigType.boolean,
          value: ConfigNumericValue(value: 5),
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('updateValue returns new instance with updated value', () {
      final config = ModelConfig(
        id: '1',
        name: 'Numeric',
        description: 'test',
        type: ConfigType.numeric,
        value: ConfigNumericValue(value: 10),
      );

      final updated = config.updateValue(ConfigNumericValue(value: 20));
      expect(updated.value.value, 20);
      expect(updated.id, config.id);
    });

    test('toJson and fromJson work correctly', () {
      final config = ModelConfig(
        id: 'temp',
        name: 'Temperature',
        description: 'test config',
        type: ConfigType.numeric,
        value: ConfigNumericValue(value: 5),
      );

      final json = config.toJson();
      expect(json['id'], 'temp');
      expect(json['type'], 'numeric');

      final from = ModelConfig.fromJson(json);
      expect(from.id, 'temp');
      expect(from.value is ConfigNumericValue, true);
      expect((from.value as ConfigNumericValue).value, 5);
    });

    test('copyWith creates modified copy', () {
      final config = ModelConfig(
        id: 'slider',
        name: 'Slider',
        description: 'range',
        type: ConfigType.slider,
        value: ConfigSliderValue(value: (0, 0.3, 1)),
      );

      final copy = config.copyWith(
        name: 'Updated Slider',
        value: ConfigSliderValue(value: (0, 0.7, 1)),
      );

      expect(copy.name, 'Updated Slider');
      expect(copy.value.getPayloadValue(), 0.7);
      expect(copy.id, 'slider'); // unchanged
    });
  });
}
