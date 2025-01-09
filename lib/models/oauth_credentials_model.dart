import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

part 'oauth_credentials_model.freezed.dart';
part 'oauth_credentials_model.g.dart';
/// Represents OAuth 2.0 Credentials with additional metadata
@freezed
class OAuthCredentials with _$OAuthCredentials {
  const OAuthCredentials._();
  @JsonSerializable(explicitToJson: true)
  const factory OAuthCredentials({
    /// Access token
    String? accessToken,
    /// Refresh token (optional)
    String? refreshToken,
    /// Token type (e.g., 'Bearer')
    @Default('Bearer') String tokenType,
    /// ID of the associated OAuth configuration
    String? configId,
  }) = _OAuthCredentials;
  factory OAuthCredentials.fromJson(Map<String, dynamic> json) => 
      _$OAuthCredentialsFromJson(json);
  /// Convert from oauth2 Credentials
  factory OAuthCredentials.fromOAuth2Credentials(oauth2.Credentials credentials) {
    return OAuthCredentials(
      accessToken: credentials.accessToken ?? '',
      refreshToken: credentials.refreshToken,
      tokenType: 'Bearer',
      );
  }
  /// Check if the token is valid
  bool get isValid => accessToken != null && accessToken!.isNotEmpty;
  /// Get the headers for API requests
  Map<String, String> get headers => {
    'Authorization': '$tokenType $accessToken',
  };
  /// Convert to oauth2 Credentials
  oauth2.Credentials toOAuth2Credentials() {
    return oauth2.Credentials(
      accessToken ?? '',
      refreshToken: refreshToken,
      tokenEndpoint: null,
      scopes: null,
      expiration: null,
      delimiter: null,
    );
  }
}