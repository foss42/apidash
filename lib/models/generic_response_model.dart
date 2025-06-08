import 'package:apidash_core/apidash_core.dart';
import 'package:genai/models/ai_response_model.dart';

part 'generic_response_model.freezed.dart';
part 'generic_response_model.g.dart';

@freezed
class GenericResponseModel with _$GenericResponseModel {
  const GenericResponseModel._();

  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
    createToJson: true,
  )
  const factory GenericResponseModel({
    required AIResponseModel? aiResponseModel,
    required HttpResponseModel? httpResponseModel,
  }) = _GenericResponseModel;

  factory GenericResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GenericResponseModelFromJson(json);
}
