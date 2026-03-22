import 'dart:convert';
import 'package:flutter/material.dart';

enum ConfigType { boolean, slider, numeric, text }

ConfigType getConfigTypeEnum(String? t) {
  try {
    final val = ConfigType.values.byName(t ?? "");
    return val;
  } catch (e) {
    debugPrint("ConfigType <$t> not found.");
    return ConfigType.text;
  }
}

bool checkTypeValue(ConfigType t, dynamic v) {
  return switch (t) {
    ConfigType.boolean => v is ConfigBooleanValue,
    ConfigType.slider => v is ConfigSliderValue,
    ConfigType.numeric => v is ConfigNumericValue,
    ConfigType.text => v is ConfigTextValue,
  };
}

dynamic deserilizeValue(ConfigType t, String? v) {
  return switch (t) {
    ConfigType.boolean => ConfigBooleanValue.deserialize(v ?? ""),
    ConfigType.slider => ConfigSliderValue.deserialize(v ?? ""),
    ConfigType.numeric => ConfigNumericValue.deserialize(v ?? ""),
    ConfigType.text => ConfigTextValue.deserialize(v ?? ""),
  };
}

abstract class ConfigValue {
  ConfigValue(this.value);

  dynamic value;

  String serialize();

  dynamic getPayloadValue() {
    return value;
  }
}

class ConfigBooleanValue extends ConfigValue {
  ConfigBooleanValue({required bool value}) : super(value);

  @override
  String serialize() {
    return value.toString();
  }

  static ConfigBooleanValue deserialize(String x) {
    return ConfigBooleanValue(value: x == 'true');
  }
}

class ConfigNumericValue extends ConfigValue {
  ConfigNumericValue({required num? value}) : super(value);

  @override
  String serialize() {
    return value.toString();
  }

  static ConfigNumericValue deserialize(String x) {
    return ConfigNumericValue(value: num.tryParse(x));
  }
}

class ConfigSliderValue extends ConfigValue {
  ConfigSliderValue({required (double, double, double) value}) : super(value);

  @override
  String serialize() {
    final v = value as (double, double, double);
    return jsonEncode([v.$1, v.$2, v.$3]);
  }

  @override
  dynamic getPayloadValue() {
    final v = value as (double, double, double);
    return v.$2;
  }

  static ConfigSliderValue deserialize(String x) {
    final z = jsonDecode(x) as List;
    final val = (
      double.parse(z[0].toString()),
      double.parse(z[1].toString()),
      double.parse(z[2].toString()),
    );
    return ConfigSliderValue(value: val);
  }
}

class ConfigTextValue extends ConfigValue {
  ConfigTextValue({required String value}) : super(value);

  @override
  String serialize() {
    return value.toString();
  }

  static ConfigTextValue deserialize(String x) {
    return ConfigTextValue(value: x);
  }
}
