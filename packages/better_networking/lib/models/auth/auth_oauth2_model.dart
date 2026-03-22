import 'package:seed/seed.dart';
import '../../consts.dart';

part 'auth_oauth2_model.g.dart';
part 'auth_oauth2_model.freezed.dart';

@freezed
class AuthOAuth2Model with _$AuthOAuth2Model {
  const factory AuthOAuth2Model({
    @Default(OAuth2GrantType.authorizationCode) OAuth2GrantType grantType,
    required String authorizationUrl,
    required String accessTokenUrl,
    required String clientId,
    required String clientSecret,
    String? credentialsFilePath,
    String? redirectUrl,
    String? scope,
    String? state,
    @Default("sha-256") String codeChallengeMethod,
    String? codeVerifier,
    String? codeChallenge,
    String? username,
    String? password,
    String? refreshToken,
    String? identityToken,
    String? accessToken,
  }) = _AuthOAuth2Model;

  factory AuthOAuth2Model.fromJson(Map<String, dynamic> json) =>
      _$AuthOAuth2ModelFromJson(json);
}
