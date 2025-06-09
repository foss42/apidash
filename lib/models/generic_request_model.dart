import 'package:genai/models/ai_request_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:apidash_core/apidash_core.dart';
part 'generic_request_model.freezed.dart';
part 'generic_request_model.g.dart';

@freezed
class GenericRequestModel with _$GenericRequestModel {
  const GenericRequestModel._();

  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
  )
  const factory GenericRequestModel({
    required AIRequestModel? aiRequestModel,
    required HttpRequestModel? httpRequestModel,
  }) = _GenericRequestModel;

  factory GenericRequestModel.fromJson(Map<String, dynamic> json) =>
      _$GenericRequestModelFromJson(json);

  GenericRequestModel clone() {
    return GenericRequestModel(
      aiRequestModel: aiRequestModel?.clone(),
      httpRequestModel: httpRequestModel,
    );
  }
}
