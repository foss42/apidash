import 'package:apidash_genai/llm_input_payload.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_request_model.freezed.dart';
part 'ai_request_model.g.dart';

@freezed
class AIRequestModel with _$AIRequestModel {
  const AIRequestModel._();

  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
    createToJson: true,
  )
  const factory AIRequestModel({
    @JsonKey(fromJson: LLMInputPayload.fromJSON, toJson: LLMInputPayload.toJSON)
    required LLMInputPayload payload,
  }) = _AIRequestModel;

  factory AIRequestModel.fromJson(Map<String, Object?> json) =>
      _$AIRequestModelFromJson(json);
}
