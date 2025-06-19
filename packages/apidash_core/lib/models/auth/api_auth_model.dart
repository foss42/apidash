import 'package:freezed_annotation/freezed_annotation.dart';
import '../../consts.dart';
import 'auth_api_key_model.dart';
import 'auth_basic_model.dart';
import 'auth_bearer_model.dart';
import 'auth_jwt_model.dart';

part 'api_auth_model.g.dart';
part 'api_auth_model.freezed.dart';

@freezed
class AuthModel with _$AuthModel {
  @JsonSerializable(explicitToJson: true)
  const factory AuthModel({
    required APIAuthType type,
    AuthApiKeyModel? apikey,
    AuthBearerModel? bearer,
    AuthBasicAuthModel? basic,
    AuthJwtModel? jwt,
  }) = _AuthModel;

  factory AuthModel.fromJson(Map<String, dynamic> json) =>
      _$AuthModelFromJson(json);
}
