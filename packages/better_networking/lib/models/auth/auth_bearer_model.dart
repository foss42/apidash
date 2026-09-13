import 'package:seed/seed.dart';

part 'auth_bearer_model.g.dart';
part 'auth_bearer_model.freezed.dart';

@freezed
abstract class AuthBearerModel with _$AuthBearerModel {
  const factory AuthBearerModel({
    required String token,
  }) = _AuthBearerModel;

  factory AuthBearerModel.fromJson(Map<String, dynamic> json) =>
      _$AuthBearerModelFromJson(json);
}
