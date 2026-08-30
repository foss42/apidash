import 'package:apidash/utils/utils.dart';
import 'package:apidash_core/apidash_core.dart';
import 'request_model.dart';

part 'request_meta_model.freezed.dart';

part 'request_meta_model.g.dart';

@freezed
abstract class RequestMetaModel with _$RequestMetaModel {
  @JsonSerializable(explicitToJson: true, anyMap: true)
  const RequestMetaModel._();

  const factory RequestMetaModel({
    required String id,
    @Default('') String name,
    @Default(APIType.rest) APIType apiType,

    /// Abbreviation for the request.
    @Default('') String abbr,
    @Default('') String url,
  }) = _RequestMetaModel;

  factory RequestMetaModel.fromJson(Map<String, Object?> json) =>
      _$RequestMetaModelFromJson(json);

  factory RequestMetaModel.fromRequestModel(RequestModel model) {
    return RequestMetaModel(
      id: model.id,
      name: model.name,
      apiType: model.apiType,
      abbr: getAbbr(model.apiType, method: model.httpRequestModel?.method),
      url: model.getUrl() ?? '',
    );
  }
}
