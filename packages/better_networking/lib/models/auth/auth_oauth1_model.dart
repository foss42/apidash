import 'package:seed/seed.dart';
import '../../consts.dart';

part 'auth_oauth1_model.g.dart';
part 'auth_oauth1_model.freezed.dart';

@freezed
class AuthOAuth1Model with _$AuthOAuth1Model {
  const factory AuthOAuth1Model({
    required String consumerKey,
    required String consumerSecret,
    String? credentialsFilePath,
    String? accessToken,
    String? tokenSecret,
    @Default(OAuth1SignatureMethod.hmacSha1)
    OAuth1SignatureMethod signatureMethod,
    @Default("header") String parameterLocation,
    @Default('1.0') String version,
    String? realm,
    String? callbackUrl,
    String? verifier,
    String? nonce,
    String? timestamp,
    @Default(false) bool includeBodyHash,
  }) = _AuthOAuth1Model;

  factory AuthOAuth1Model.fromJson(Map<String, dynamic> json) =>
      _$AuthOAuth1ModelFromJson(json);
}
