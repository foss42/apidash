import 'package:apidash/models/generic_request_model.dart';
import 'package:apidash/models/generic_response_model.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:genai/models/ai_request_model.dart';
import 'package:genai/models/ai_response_model.dart';
part 'request_model.freezed.dart';
part 'request_model.g.dart';

@freezed
class RequestModel with _$RequestModel {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
  )
  const factory RequestModel({
    required String id,
    @Default(APIType.rest) APIType apiType,
    @Default("") String name,
    @Default("") String description,
    @JsonKey(includeToJson: false) @Default(0) requestTabIndex,
    int? responseStatus,
    String? message,
    @JsonKey(includeToJson: false) @Default(false) bool isWorking,
    @JsonKey(includeToJson: false) DateTime? sendingTime,
    // Request Models
    HttpRequestModel? httpRequestModel,
    HttpResponseModel? httpResponseModel,
    AIRequestModel? aiRequestModel,
    AIResponseModel? aiResponseModel,
  }) = _RequestModel;

  factory RequestModel.fromJson(Map<String, Object?> json) =>
      _$RequestModelFromJson(json);
}
