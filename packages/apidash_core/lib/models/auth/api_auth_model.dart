import 'package:apidash_core/models/auth/auth_api_key_model.dart';
import 'package:apidash_core/models/auth/auth_basic_model.dart';
import 'package:apidash_core/models/auth/auth_bearer_model.dart';
import 'package:apidash_core/models/auth/auth_jwt_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../consts.dart';

part 'api_auth_model.g.dart';
part 'api_auth_model.freezed.dart';


@freezed
class Auth with _$Auth {
  const factory Auth({
    required APIAuthType type,
    AuthApiKeyModel? apikey,
    AuthBearerModel? bearer,
    AuthBasicAuthModel? basic,
    AuthJwtModel? jwt,
  }) = _Auth;

  factory Auth.fromJson(Map<String, dynamic> json) => _$AuthFromJson(json);
}
