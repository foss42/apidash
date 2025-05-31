import 'dart:convert';

class LLMModelConfiguration {
  final String configName;
  final String configDescription;
  final LLMModelConfigurationType configType;
  final LLMModelConfigValue configValue;

  LLMModelConfiguration({
    required this.configName,
    required this.configDescription,
    required this.configType,
    required this.configValue,
  }) {
    // Assert that the configuration type and value matches
    assert(configType == LLMModelConfigurationType.boolean
        ? configValue is LLMConfigBooleanValue
        : configType == LLMModelConfigurationType.numeric
            ? configValue is LLMConfigNumericValue
            : configValue is LLMConfigSliderValue);
  }

  factory LLMModelConfiguration.fromJson(Map x) {
    final cT = x['configType'] == 'boolean'
        ? LLMModelConfigurationType.boolean
        : x['configType'] == 'slider'
            ? LLMModelConfigurationType.slider
            : LLMModelConfigurationType.numeric;

    final cV = cT == LLMModelConfigurationType.boolean
        ? LLMConfigBooleanValue.deserialize(x['configValue'])
        : cT == LLMModelConfigurationType.slider
            ? LLMConfigSliderValue.deserialize(x['configValue'])
            : LLMConfigNumericValue.deserialize(x['configValue']);

    return LLMModelConfiguration(
      configName: x['configName'],
      configDescription: x['configDescription'],
      configType: cT,
      configValue: cV,
    );
  }

  Map toJson() {
    return {
      'configName': configName,
      'configDescription': configDescription,
      'configType': configType.name.toString(),
      'configValue': configValue.serialize(),
    };
  }
}

enum LLMModelConfigurationType { boolean, slider, numeric }

//----------------LLMConfigValues ------------

abstract class LLMModelConfigValue {
  dynamic _value;

  // ignore: unnecessary_getters_setters
  dynamic get value => _value;

  set value(dynamic newValue) => _value = newValue;

  String serialize();

  LLMModelConfigValue(this._value);
}

class LLMConfigBooleanValue extends LLMModelConfigValue {
  LLMConfigBooleanValue({required bool value}) : super(value);

  @override
  String serialize() {
    return value.toString();
  }

  static LLMConfigBooleanValue deserialize(String x) {
    return LLMConfigBooleanValue(value: x == 'true');
  }
}

class LLMConfigNumericValue extends LLMModelConfigValue {
  LLMConfigNumericValue({required num value}) : super(value);

  @override
  String serialize() {
    return value.toString();
  }

  static LLMConfigNumericValue deserialize(String x) {
    return LLMConfigNumericValue(value: num.parse(x));
  }
}

class LLMConfigSliderValue extends LLMModelConfigValue {
  LLMConfigSliderValue({required (double, double, double) value})
      : super(value);

  @override
  String serialize() {
    final v = value as (double, double, double);
    return jsonEncode([v.$1, v.$2, v.$3]);
  }

  static LLMConfigSliderValue deserialize(String x) {
    final z = jsonDecode(x) as List;
    final val = (
      double.parse(z[0].toString()),
      double.parse(z[1].toString()),
      double.parse(z[2].toString())
    );
    return LLMConfigSliderValue(value: val);
  }
}
