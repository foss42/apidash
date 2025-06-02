import 'package:apidash_core/apidash_core.dart';
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
    required HttpRequestModel httpRequestModel,
    required HttpResponseModel httpResponseModel,
//ExtraDetails for anything else that can be included
    @JsonKey(fromJson: customMapFromJson, toJson: customMapToJson)
    @Default({})
    Map extraDetails,
  }) = _HistoryRequestModel;

  factory HistoryRequestModel.fromJson(Map<String, Object?> json) =>
      _$HistoryRequestModelFromJson(json);
}
