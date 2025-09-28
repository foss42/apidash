import 'package:seed/seed.dart';
import '../../consts.dart';
import 'auth_api_key_model.dart';
import 'auth_basic_model.dart';
import 'auth_bearer_model.dart';
import 'auth_jwt_model.dart';
import 'auth_digest_model.dart';
import 'auth_oauth1_model.dart';
import 'auth_oauth2_model.dart';

part 'api_auth_model.g.dart';
part 'api_auth_model.freezed.dart';

@freezed
class AuthModel with _$AuthModel {
  @JsonSerializable(explicitToJson: true, anyMap: true)
  const factory AuthModel({
    required APIAuthType type,
    AuthApiKeyModel? apikey,
    AuthBearerModel? bearer,
    AuthBasicAuthModel? basic,
    AuthJwtModel? jwt,
    AuthDigestModel? digest,
    AuthOAuth1Model? oauth1,
    AuthOAuth2Model? oauth2,
  }) = _AuthModel;

  factory AuthModel.fromJson(Map<String, dynamic> json) =>
      _$AuthModelFromJson(json);
}
