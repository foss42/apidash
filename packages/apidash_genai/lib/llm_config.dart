import 'dart:convert';

typedef LLMOutputFormatter = String? Function(Map);

class LLMModelConfiguration {
  final String configId;
  final String configName;
  final String configDescription;
  final LLMModelConfigurationType configType;
  final LLMModelConfigValue configValue;

  LLMModelConfiguration updateValue(LLMModelConfigValue value) {
    return LLMModelConfiguration(
      configId: configId,
      configName: configName,
      configDescription: configDescription,
      configType: configType,
      configValue: value,
    );
  }

  LLMModelConfiguration({
    required this.configId,
    required this.configName,
    required this.configDescription,
    required this.configType,
    required this.configValue,
  }) {
    // Assert that the configuration type and value matches
    switch (configType) {
      case LLMModelConfigurationType.boolean:
        assert(configValue is LLMConfigBooleanValue);
      case LLMModelConfigurationType.slider:
        assert(configValue is LLMConfigSliderValue);
      case LLMModelConfigurationType.numeric:
        assert(configValue is LLMConfigNumericValue);
      case LLMModelConfigurationType.text:
        assert(configValue is LLMConfigTextValue);
    }
  }

  factory LLMModelConfiguration.fromJson(Map x) {
    LLMModelConfigurationType cT;
    LLMModelConfigValue cV;
    switch (x['configType']) {
      case 'boolean':
        cT = LLMModelConfigurationType.boolean;
        cV = LLMConfigBooleanValue.deserialize(x['configValue']);
        break;
      case 'slider':
        cT = LLMModelConfigurationType.slider;
        cV = LLMConfigSliderValue.deserialize(x['configValue']);
        break;
      case 'numeric':
        cT = LLMModelConfigurationType.numeric;
        cV = LLMConfigNumericValue.deserialize(x['configValue']);
        break;
      case 'text':
        cT = LLMModelConfigurationType.text;
        cV = LLMConfigTextValue.deserialize(x['configValue']);
        break;
      default:
        cT = LLMModelConfigurationType.text;
        cV = LLMConfigTextValue.deserialize(x['configValue']);
    }
    return LLMModelConfiguration(
      configId: x['config_id'],
      configName: x['configName'],
      configDescription: x['configDescription'],
      configType: cT,
      configValue: cV,
    );
  }

  Map toJson() {
    return {
      'configId': configId,
      'configName': configName,
      'configDescription': configDescription,
      'configType': configType.name.toString(),
      'configValue': configValue.serialize(),
    };
  }
}

enum LLMModelConfigurationType { boolean, slider, numeric, text }

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
      double.parse(z[2].toString()),
    );
    return LLMConfigSliderValue(value: val);
  }
}

class LLMConfigTextValue extends LLMModelConfigValue {
  LLMConfigTextValue({required String value}) : super(value);

  @override
  String serialize() {
    return value.toString();
  }

  static LLMConfigTextValue deserialize(String x) {
    return LLMConfigTextValue(value: x);
  }
}

enum LLMModelConfigurationName { temperature, top_p, max_tokens }

Map<LLMModelConfigurationName, LLMModelConfiguration> defaultLLMConfigurations =
    {
      LLMModelConfigurationName.temperature: LLMModelConfiguration(
        configId: 'temperature',
        configName: 'Temperature',
        configDescription: 'The Temperature of the Model',
        configType: LLMModelConfigurationType.slider,
        configValue: LLMConfigSliderValue(value: (0, 0.5, 1)),
      ),
      LLMModelConfigurationName.top_p: LLMModelConfiguration(
        configId: 'top_p',
        configName: 'Top P',
        configDescription: 'The Top P of the Model',
        configType: LLMModelConfigurationType.slider,
        configValue: LLMConfigSliderValue(value: (0, 0.95, 1)),
      ),
      LLMModelConfigurationName.max_tokens: LLMModelConfiguration(
        configId: 'max_tokens',
        configName: 'Maximum Tokens',
        configDescription: 'The maximum number of tokens allowed in the output',
        configType: LLMModelConfigurationType.numeric,
        configValue: LLMConfigNumericValue(value: -1),
      ),
    };
