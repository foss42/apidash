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
  }) = _HistoryRequestModel;

  factory HistoryRequestModel.fromJson(Map<String, Object?> json) =>
      _$HistoryRequestModelFromJson(json);
}
