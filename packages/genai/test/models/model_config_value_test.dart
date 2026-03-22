import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:genai/models/model_config_value.dart';

void main() {
  group('ConfigType Enum', () {
    test('getConfigTypeEnum returns correct enum', () {
      expect(getConfigTypeEnum('boolean'), ConfigType.boolean);
      expect(getConfigTypeEnum('slider'), ConfigType.slider);
      expect(getConfigTypeEnum('numeric'), ConfigType.numeric);
      expect(getConfigTypeEnum('text'), ConfigType.text);
    });

    test('getConfigTypeEnum falls back to text on invalid', () {
      expect(getConfigTypeEnum('does_not_exist'), ConfigType.text);
      expect(getConfigTypeEnum(null), ConfigType.text);
    });
  });

  group('ConfigBooleanValue', () {
    test('serialize and deserialize works', () {
      final value = ConfigBooleanValue(value: true);
      final serialized = value.serialize();
      expect(serialized, 'true');

      final deserialized = ConfigBooleanValue.deserialize(serialized);
      expect(deserialized.value, true);
    });
  });

  group('ConfigNumericValue', () {
    test('serialize and deserialize works', () {
      final value = ConfigNumericValue(value: 42);
      final serialized = value.serialize();
      expect(serialized, '42');

      final deserialized = ConfigNumericValue.deserialize('42');
      expect(deserialized.value, 42);

      final nullValue = ConfigNumericValue.deserialize('not_a_number');
      expect(nullValue.value, null);
    });
  });

  group('ConfigSliderValue', () {
    test('serialize and deserialize works', () {
      final value = ConfigSliderValue(value: (0.0, 0.5, 1.0));
      final serialized = value.serialize();
      expect(serialized, jsonEncode([0.0, 0.5, 1.0]));

      final deserialized = ConfigSliderValue.deserialize(serialized);
      expect(deserialized.value, (0.0, 0.5, 1.0));
    });

    test('getPayloadValue returns middle element', () {
      final slider = ConfigSliderValue(value: (0.0, 0.5, 1.0));
      expect(slider.getPayloadValue(), 0.5);
    });
  });

  group('ConfigTextValue', () {
    test('serialize and deserialize works', () {
      final value = ConfigTextValue(value: 'hello');
      final serialized = value.serialize();
      expect(serialized, 'hello');

      final deserialized = ConfigTextValue.deserialize('world');
      expect(deserialized.value, 'world');
    });
  });

  group('checkTypeValue', () {
    test('validates correct type/value matches', () {
      expect(
        checkTypeValue(ConfigType.boolean, ConfigBooleanValue(value: true)),
        true,
      );
      expect(
        checkTypeValue(ConfigType.numeric, ConfigNumericValue(value: 3)),
        true,
      );
      expect(
        checkTypeValue(
          ConfigType.slider,
          ConfigSliderValue(value: (0, 0.5, 1)),
        ),
        true,
      );
      expect(
        checkTypeValue(ConfigType.text, ConfigTextValue(value: 'hi')),
        true,
      );
    });

    test('returns false for mismatched type/value', () {
      expect(
        checkTypeValue(ConfigType.boolean, ConfigNumericValue(value: 1)),
        false,
      );
      expect(
        checkTypeValue(ConfigType.numeric, ConfigTextValue(value: 'x')),
        false,
      );
      expect(
        checkTypeValue(ConfigType.slider, ConfigBooleanValue(value: true)),
        false,
      );
    });
  });
}
