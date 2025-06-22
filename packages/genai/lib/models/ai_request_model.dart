import 'package:freezed_annotation/freezed_annotation.dart';
import '../llm_model.dart';
import '../llm_provider.dart';
import '../llm_saveobject.dart';
import '../llm_input_payload.dart';
import '../llm_request.dart';
import '../providers/gemini.dart';
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
    final controller = model.provider.modelController;
    return controller.createRequest(model, payload);
  }

  factory AIRequestModel.fromDefaultSaveObject(LLMSaveObject? defaultLLMSO) {
    final gmC = GeminiModelController.instance;
    return AIRequestModel(
      model:
          defaultLLMSO?.selectedLLM ??
          LLMProvider.gemini.getLLMByIdentifier('gemini-2.0-flash'),
      provider: defaultLLMSO?.provider ?? LLMProvider.gemini,
      payload: LLMInputPayload(
        endpoint: defaultLLMSO?.endpoint ?? gmC.inputPayload.endpoint,
        credential: defaultLLMSO?.credential ?? '',
        systemPrompt: '',
        userPrompt: '',
        configMap: defaultLLMSO?.configMap ?? gmC.inputPayload.configMap,
      ),
    );
  }

  AIRequestModel clone() {
    return AIRequestModel(
      model: model,
      payload: payload.clone(),
      provider: provider,
    );
  }
}
