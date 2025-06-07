import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_auth_model.g.dart';
part 'api_auth_model.freezed.dart';

@freezed
class APIAuthModel with _$APIAuthModel {
  const factory APIAuthModel.none() = None;

  const factory APIAuthModel.basic({
    required String username,
    required String password,
  }) = BasicAuth;

  factory APIAuthModel.fromJson(Map<String, dynamic> json) =>
      _$APIAuthModelFromJson(json);

  const factory APIAuthModel.bearerToken({
    required String token,
  }) = BearerTokenAuth;

  const factory APIAuthModel.apiKey({
    required String key,
    @Default('header') String location, // or 'query'
    @Default('x-api-key') String name,
  }) = APIKeyAuth;

  const factory APIAuthModel.jwtBearer({
    required String jwt,
  }) = JWTBearerAuth;
}
