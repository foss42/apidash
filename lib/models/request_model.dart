import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_core/models/generic_request_model.dart';
import 'package:apidash_core/models/generic_response_model.dart';

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
    // HttpRequestModel? httpRequestModel,
    int? responseStatus,
    String? message,
    // HttpResponseModel? httpResponseModel,
    @JsonKey(includeToJson: false) @Default(false) bool isWorking,
    @JsonKey(includeToJson: false) DateTime? sendingTime,
    GenericRequestModel? genericRequestModel,
    GenericResponseModel? genericResponseModel,
  }) = _RequestModel;

  factory RequestModel.fromJson(Map<String, Object?> json) =>
      _$RequestModelFromJson(json);
}
