import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_digest_model.g.dart';
part 'auth_digest_model.freezed.dart';

@freezed
class AuthDigestModel with _$AuthDigestModel {
  const factory AuthDigestModel({
    required String username,
    required String password,
    required String realm,
    required String nonce,
    required String algorithm,
    required String qop,
    required String opaque,
  }) = _AuthDigestModel;

  factory AuthDigestModel.fromJson(Map<String, dynamic> json) =>
      _$AuthDigestModelFromJson(json);
}
