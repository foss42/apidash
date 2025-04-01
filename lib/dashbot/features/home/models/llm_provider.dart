import 'dart:convert';

class LlmProvider {
  final LlmProviderType type;
  final String name;
  final String subtitle;
  final String logo;
  final LocalLlmConfig? localConfig;
  final RemoteLlmConfig? remoteConfig;

  LlmProvider({
    required this.type,
    required this.name,
    required this.subtitle,
    required this.logo,
    this.localConfig,
    this.remoteConfig,
  }) : assert(
            (type == LlmProviderType.local && localConfig != null) ||
                (type == LlmProviderType.remote && remoteConfig != null),
            'Must provide correct configuration based on provider type');

  LlmProvider copyWith({
    LlmProviderType? type,
    String? name,
    String? subtitle,
    String? logo,
    LocalLlmConfig? localConfig,
    RemoteLlmConfig? remoteConfig,
  }) {
    return LlmProvider(
      type: type ?? this.type,
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      logo: logo ?? this.logo,
      localConfig: localConfig ?? this.localConfig,
      remoteConfig: remoteConfig ?? this.remoteConfig,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type.toString(),
      'name': name,
      'subtitle': subtitle,
      'logo': logo,
      'localConfig': localConfig?.toMap(),
      'remoteConfig': remoteConfig?.toMap(),
    };
  }

  String toJson() => json.encode(toMap());

  factory LlmProvider.fromMap(Map<String, dynamic> map) {
    return LlmProvider(
      type: LlmProviderType.values.firstWhere(
          (e) => e.toString() == map['type'],
          orElse: () => LlmProviderType.local),
      name: map['name'] as String,
      subtitle: map['subtitle'] as String,
      logo: map['logo'] as String,
      localConfig: map['localConfig'] != null
          ? LocalLlmConfig.fromMap(map['localConfig'] as Map<String, dynamic>)
          : null,
      remoteConfig: map['remoteConfig'] != null
          ? RemoteLlmConfig.fromMap(map['remoteConfig'] as Map<String, dynamic>)
          : null,
    );
  }

  factory LlmProvider.fromJson(String source) =>
      LlmProvider.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LlmProvider(type: $type, name: $name, subtitle: $subtitle, logo: $logo, localConfig: $localConfig, remoteConfig: $remoteConfig)';
  }
}

class LocalLlmConfig {
  String? modelName;
  String? baseUrl;

  LocalLlmConfig({
    required this.modelName,
    required this.baseUrl,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'modelName': modelName,
      'baseUrl': baseUrl,
    };
  }

  factory LocalLlmConfig.fromMap(Map<String, dynamic> map) {
    return LocalLlmConfig(
      modelName: map['modelName'] != null ? map['modelName'] as String : null,
      baseUrl: map['baseUrl'] != null ? map['baseUrl'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LocalLlmConfig.fromJson(String source) =>
      LocalLlmConfig.fromMap(json.decode(source) as Map<String, dynamic>);

  LocalLlmConfig copyWith({
    String? modelName,
    String? baseUrl,
  }) {
    return LocalLlmConfig(
      modelName: modelName ?? this.modelName,
      baseUrl: baseUrl ?? this.baseUrl,
    );
  }
}

class RemoteLlmConfig {
  String? apiKey;
  String? modelName;

  RemoteLlmConfig({
    required this.apiKey,
    required this.modelName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'apiKey': apiKey,
      'modelName': modelName,
    };
  }

  factory RemoteLlmConfig.fromMap(Map<String, dynamic> map) {
    return RemoteLlmConfig(
      apiKey: map['apiKey'] as String,
      modelName: map['modelName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RemoteLlmConfig.fromJson(String source) =>
      RemoteLlmConfig.fromMap(json.decode(source) as Map<String, dynamic>);

  RemoteLlmConfig copyWith({
    String? apiKey,
    String? modelName,
  }) {
    return RemoteLlmConfig(
      apiKey: apiKey ?? this.apiKey,
      modelName: modelName ?? this.modelName,
    );
  }
}

enum LlmProviderType {
  local,
  remote,
}
