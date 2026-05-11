import 'package:apidash_core/apidash_core.dart';

part 'request_meta_model.freezed.dart';
part 'request_meta_model.g.dart';

@freezed
class RequestMetaModel with _$RequestMetaModel {
  const factory RequestMetaModel({
    required String id,
    @Default(APIType.rest) APIType apiType,
    @Default("") String name,
    @Default("") String description,
    @Default(HTTPVerb.get) HTTPVerb method,
    @Default("") String url,
    int? responseStatus,
  }) = _RequestMetaModel;

  factory RequestMetaModel.fromJson(Map<String, Object?> json) =>
      _$RequestMetaModelFromJson(json);
}
