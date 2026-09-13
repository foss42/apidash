import 'package:better_networking/better_networking.dart';
import '../interface/interface.dart';
import 'model_config.dart';
part 'ai_request_model.freezed.dart';
part 'ai_request_model.g.dart';

@freezed
abstract class AIRequestModel with _$AIRequestModel {
  const AIRequestModel._();

  @JsonSerializable(explicitToJson: true, anyMap: true)
  const factory AIRequestModel({
    ModelAPIProvider? modelApiProvider,
    @Default("") String url,
    @Default(null) String? model,
    @Default(null) String? apiKey,
    @JsonKey(name: "system_prompt") @Default("") String systemPrompt,
    @JsonKey(name: "user_prompt") @Default("") String userPrompt,
    @JsonKey(name: "model_configs")
    @Default(<ModelConfig>[])
    List<ModelConfig> modelConfigs,
    @Default(null) bool? stream,
  }) = _AIRequestModel;

  factory AIRequestModel.fromJson(Map<String, Object?> json) =>
      _$AIRequestModelFromJson(json);

  HttpRequestModel? get httpRequestModel =>
      kModelProvidersMap[modelApiProvider]?.createRequest(this);

  String? getFormattedOutput(Map x) =>
      kModelProvidersMap[modelApiProvider]?.outputFormatter(x);

  String? getFormattedStreamOutput(Map x) =>
      kModelProvidersMap[modelApiProvider]?.streamOutputFormatter(x);

  Map<String, dynamic> getModelConfigMap() {
    Map<String, dynamic> m = {};
    for (var config in modelConfigs) {
      m[config.id] = config.value.getPayloadValue();
    }
    return m;
  }

  int? getModelConfigIdx(String id) {
    for (var idx = 0; idx < modelConfigs.length; idx++) {
      if (modelConfigs[idx].id == id) {
        return idx;
      }
    }
    return null;
  }
}
