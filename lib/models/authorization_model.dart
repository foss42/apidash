import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';

part 'authorization_model.freezed.dart';

part 'authorization_model.g.dart';

@freezed
class AuthorizationModel with _$AuthorizationModel {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
  )
  const factory AuthorizationModel({
    @Default(AuthType.noauth) AuthType authType,
    @Default(false) bool isEnabled,
    @Default(BasicAuthModel(username: '', password: '')) BasicAuthModel basicAuthModel,
    @Default(BearerAuthModel(token: '')) BearerAuthModel bearerAuthModel,
    @Default(ApiKeyAuthModel(key: '', value: '', addTo: AddTo.header)) ApiKeyAuthModel apiKeyAuthModel,
    // JWTBearerAuthModel? jwtBearerAuthModel,
    // DigestAuthModel? digestAuthModel,
    // OAuth1AuthModel? oauth1AuthModel,
    // OAuth2AuthModel? oauth2AuthModel,
  }) = _AuthorizationModel;

  factory AuthorizationModel.fromJson(Map<String, Object?> json) =>
      _$AuthorizationModelFromJson(json);
}

@freezed
class BasicAuthModel with _$BasicAuthModel {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
  )
  const factory BasicAuthModel({
    @Default("") String username,
    @Default("") String password,
  }) = _BasicAuthModel;

  factory BasicAuthModel.fromJson(Map<String, Object?> json) =>
      _$BasicAuthModelFromJson(json);
}

@freezed
class BearerAuthModel with _$BearerAuthModel {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
  )
  const factory BearerAuthModel({
    @Default("") String token,
  }) = _BearerAuthModel;

  factory BearerAuthModel.fromJson(Map<String, Object?> json) =>
      _$BearerAuthModelFromJson(json);
}

@freezed
class ApiKeyAuthModel with _$ApiKeyAuthModel {
  @JsonSerializable(
    explicitToJson: true,
    anyMap: true,
  )
  const factory ApiKeyAuthModel({
    @Default("") String key,
    @Default("") String value,
    @Default(AddTo.header) AddTo addTo,
  }) = _ApiKeyAuthModel;

  factory ApiKeyAuthModel.fromJson(Map<String, Object?> json) =>
      _$ApiKeyAuthModelFromJson(json);
}

// @freezed
// class DigestAuthModel with _$DigestAuthModel {
//   @JsonSerializable(
//     explicitToJson: true,
//     anyMap: true,
//   )
