import 'package:apidash_core/apidash_core.dart';

part 'history_meta_model.freezed.dart';

part 'history_meta_model.g.dart';

@freezed
class HistoryMetaModel with _$HistoryMetaModel {
  const factory HistoryMetaModel({
    required String historyId,
    required String requestId,
    @Default("") String name,
    required String url,
    required HTTPVerb method,
    required int responseStatus,
    required DateTime timeStamp,
  }) = _HistoryMetaModel;

  factory HistoryMetaModel.fromJson(Map<String, Object?> json) =>
      _$HistoryMetaModelFromJson(json);
}
