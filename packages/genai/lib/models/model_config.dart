import 'model_config_value.dart';

class ModelConfig {
  final String id;
  final String name;
  final String description;
  final ConfigType type;
  final ConfigValue value;

  ModelConfig({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.value,
  }) {
    assert(checkTypeValue(type, value));
  }

  ModelConfig updateValue(ConfigValue value) {
    return ModelConfig(
      id: id,
      name: name,
      description: description,
      type: type,
      value: value,
    );
  }

  factory ModelConfig.fromJson(Map x) {
    final id = x['id'] as String?;
    final name = x['name'] as String?;
    final description = x['description'] as String?;
    final type = x['type'] as String?;
    final value = x['value'] as String?;

    final cT = getConfigTypeEnum(type);
    final cV = deserilizeValue(cT, value);

    return ModelConfig(
      id: id ?? "",
      name: name ?? "",
      description: description ?? "",
      type: cT,
      value: cV,
    );
  }

  Map<String, String?> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.name.toString(),
      'value': value.serialize(),
    };
  }

  ModelConfig copyWith({
    String? id,
    String? name,
    String? description,
    ConfigType? type,
    ConfigValue? value,
  }) {
    return ModelConfig(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      value: value ?? this.value,
    );
  }
}
