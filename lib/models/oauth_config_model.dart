import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
part 'oauth_config_model.g.dart';
part 'oauth_config_model.freezed.dart';

enum OAuthFlow {
  authorizationCode,
}

@freezed
class OAuthConfig with _$OAuthConfig {
  const OAuthConfig._();
  const factory OAuthConfig({
    /// Unique identifier for this OAuth configuration
    required String id,
    /// Name of the configuration
    required String name,
    /// OAuth Flow type
    required OAuthFlow flow,
    /// Client ID from OAuth provider
    required String clientId,
    /// Client Secret from OAuth provider
    required String clientSecret,
    /// Authorization endpoint URL
    required String authUrl,
    /// Token endpoint URL
    required String tokenEndpoint,
    /// Callback URL for OAuth
    required String callbackUrl,
    /// OAuth scope
    required String scope,
    /// State
    required String state,
    /// Auto refresh token option
    @Default(false) bool autoRefresh,
    /// Share token option
    @Default(false) bool shareToken,
  }) = _OAuthConfig;
  factory OAuthConfig.fromJson(Map<String, dynamic> json) =>
      _$OAuthConfigFromJson(json);
  factory OAuthConfig.empty() => OAuthConfig(
        id: const Uuid().v4(),
        name: '',
        flow: OAuthFlow.authorizationCode,
        clientId: '',
        clientSecret: '',
        authUrl: '',
        tokenEndpoint: '',
        callbackUrl: '',
        scope: '',
        state: '',
      );
}