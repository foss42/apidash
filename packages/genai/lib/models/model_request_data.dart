import 'package:freezed_annotation/freezed_annotation.dart';
import 'model_config.dart';
part 'model_request_data.freezed.dart';
part 'model_request_data.g.dart';

@freezed
class ModelRequestData with _$ModelRequestData {
  const ModelRequestData._();

  @JsonSerializable(explicitToJson: true, anyMap: true)
  const factory ModelRequestData({
    @Default("") String url,
    @Default("") String model,
    @Default("") String apiKey,
    @JsonKey(name: "system_prompt") @Default("") String systemPrompt,
    @JsonKey(name: "user_prompt") @Default("") String userPrompt,
    @JsonKey(name: "model_configs")
    @Default(<ModelConfig>[])
    List<ModelConfig> modelConfigs,
    @Default(null) bool? stream,
  }) = _ModelRequestData;

  factory ModelRequestData.fromJson(Map<String, Object?> json) =>
      _$ModelRequestDataFromJson(json);

  Map<String, dynamic> getModelConfigMap() {
    Map<String, dynamic> m = {};
    for (var config in modelConfigs) {
      m[config.id] = config.value.getPayloadValue();
    }
    return m;
  }
}
