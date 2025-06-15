import 'package:freezed_annotation/freezed_annotation.dart';
import '../llm_input_payload.dart';
import '../llm_request.dart';
import '../providers/common.dart';
import '../providers/providers.dart';
part 'ai_request_model.freezed.dart';
part 'ai_request_model.g.dart';

@freezed
class AIRequestModel with _$AIRequestModel {
  const AIRequestModel._();

  @JsonSerializable(explicitToJson: true, anyMap: true)
  factory AIRequestModel({
    @JsonKey(fromJson: LLMInputPayload.fromJSON, toJson: LLMInputPayload.toJSON)
    required LLMInputPayload payload,
    @JsonKey(fromJson: LLMModel.fromJson, toJson: LLMModel.toJson)
    required LLMModel model,
    @JsonKey(fromJson: LLMProvider.fromJSON, toJson: LLMProvider.toJSON)
    required LLMProvider provider,
  }) = _AIRequestModel;

  factory AIRequestModel.fromJson(Map<String, Object?> json) =>
      _$AIRequestModelFromJson(json);

  AIRequestModel updatePayload(LLMInputPayload p) {
    return AIRequestModel(payload: p, model: model, provider: provider);
  }

  LLMRequestDetails createRequest() {
    final (_, ModelController controller) = model.provider.models;
    return controller.createRequest(model, payload);
  }
}
