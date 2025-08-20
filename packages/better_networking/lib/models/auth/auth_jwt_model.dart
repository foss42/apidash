import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_jwt_model.freezed.dart';
part 'auth_jwt_model.g.dart';

@freezed
class AuthJwtModel with _$AuthJwtModel {
  const factory AuthJwtModel({
    required String secret,
    String? privateKey,
    required String payload,
    required String addTokenTo,
    required String algorithm,
    required bool isSecretBase64Encoded,
    required String headerPrefix,
    required String queryParamKey,
    required String header,
  }) = _AuthJwtModel;

  factory AuthJwtModel.fromJson(Map<String, dynamic> json) =>
      _$AuthJwtModelFromJson(json);
}
