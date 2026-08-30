import 'package:apidash_core/apidash_core.dart';
import 'request_meta_model.dart';

part 'collection_model.freezed.dart';

part 'collection_model.g.dart';

@freezed
abstract class CollectionModel with _$CollectionModel {
  @JsonSerializable(explicitToJson: true, anyMap: true)
  const CollectionModel._();

  const factory CollectionModel({
    required String id,
    required String name,
    // List of request metadata associated with this collection.
    @Default(<RequestMetaModel>[]) List<RequestMetaModel> requestMetaList,
  }) = _CollectionModel;

  factory CollectionModel.fromJson(Map<String, Object?> json) =>
      _$CollectionModelFromJson(json);

  List<String> get requestIds => requestMetaList.map((r) => r.id).toList();
}
