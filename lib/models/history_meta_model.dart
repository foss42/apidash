import 'package:apidash_core/apidash_core.dart';

part 'history_meta_model.freezed.dart';

part 'history_meta_model.g.dart';

@freezed
class HistoryMetaModel with _$HistoryMetaModel {
  const factory HistoryMetaModel({
    @Default("") String historyId,
    @Default("") String requestId,
    @Default(APIType.rest) APIType apiType,
    @Default("") String name,
    @Default("") String url,
    @Default(HTTPVerb.get) HTTPVerb method,
    @Default(200) int responseStatus,
    DateTime? timeStamp,
  }) = _HistoryMetaModel;

  factory HistoryMetaModel.fromJson(Map<String, Object?> json) =>
      _$HistoryMetaModelFromJson(json);
}
