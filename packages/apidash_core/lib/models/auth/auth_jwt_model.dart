import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_jwt_model.g.dart';
part 'auth_jwt_model.freezed.dart';

@freezed
class AuthJwtModel with _$AuthJwtModel {
  const factory AuthJwtModel({
    required String jwt,
  }) = _AuthJwtModel;

  factory AuthJwtModel.fromJson(Map<String, dynamic> json) =>
      _$AuthJwtModelFromJson(json);
}
