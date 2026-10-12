import 'package:apidash_core/apidash_core.dart';

part 'name_path_model.freezed.dart';
part 'name_path_model.g.dart';

@freezed
abstract class NamePathModel with _$NamePathModel {
  const factory NamePathModel({required String name, required String path}) =
      _NamePathModel;

  factory NamePathModel.fromJson(Map<String, Object?> json) =>
      _$NamePathModelFromJson(json);
}
