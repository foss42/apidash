import 'package:apidash/models/generic_request_model.dart';
import 'package:apidash/models/generic_response_model.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:genai/models/ai_request_model.dart';
import 'package:genai/models/ai_response_model.dart';
import 'models.dart';

part 'history_request_model.freezed.dart';

part 'history_request_model.g.dart';

@freezed
class HistoryRequestModel with _$HistoryRequestModel {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
  )
  const factory HistoryRequestModel({
    required String historyId,
    required HistoryMetaModel metaData,
    HttpRequestModel? httpRequestModel,
    HttpResponseModel? httpResponseModel,
    AIRequestModel? aiRequestModel,
    AIResponseModel? aiResponseModel,
  }) = _HistoryRequestModel;

  factory HistoryRequestModel.fromJson(Map<String, Object?> json) =>
      _$HistoryRequestModelFromJson(json);
}
