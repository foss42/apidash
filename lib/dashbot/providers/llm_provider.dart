class LLMConfig {
  final String model;
  String? apiUrl;
  String? apiKey;
  double? temperature;

  LLMConfig({
    required this.model,
    this.apiUrl,
    this.apiKey,
    this.temperature,
  });

  LLMConfig copyWith({String? apiUrl, String? apiKey, String? model, double? temperature}) {
    return LLMConfig(
      model: model ?? this.model,
      apiUrl: apiUrl ?? this.apiUrl,
      apiKey: apiKey ?? this.apiKey,
      temperature: temperature ?? this.temperature,
    );
  }
}
