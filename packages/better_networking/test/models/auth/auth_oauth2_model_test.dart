import 'package:better_networking/models/auth/auth_oauth2_model.dart';
import 'package:better_networking/consts.dart';
import 'package:test/test.dart';
import 'auth_models.dart';

void main() {
  group('Testing AuthOAuth2Model', () {
    test("Testing AuthOAuth2Model copyWith", () {
      var authOAuth2Model = authOAuth2Model1;
      final authOAuth2ModelCopyWith = authOAuth2Model.copyWith(
        grantType: OAuth2GrantType.clientCredentials,
        clientId: 'new_client_id',
        scope: 'new_scope',
        codeChallengeMethod: 'plain',
      );
      expect(
        authOAuth2ModelCopyWith.grantType,
        OAuth2GrantType.clientCredentials,
      );
      expect(authOAuth2ModelCopyWith.clientId, 'new_client_id');
      expect(authOAuth2ModelCopyWith.scope, 'new_scope');
      expect(authOAuth2ModelCopyWith.codeChallengeMethod, 'plain');
      // original model unchanged
      expect(authOAuth2Model.grantType, OAuth2GrantType.authorizationCode);
      expect(authOAuth2Model.clientId, 'oauth2-client-id-123');
      expect(authOAuth2Model.scope, 'read write admin');
      expect(authOAuth2Model.codeChallengeMethod, 'S256');
    });

    test("Testing AuthOAuth2Model toJson", () {
      var authOAuth2Model = authOAuth2Model1;
      expect(authOAuth2Model.toJson(), authOAuth2ModelJson1);
    });

    test("Testing AuthOAuth2Model fromJson", () {
      var authOAuth2Model = authOAuth2Model1;
      final modelFromJson = AuthOAuth2Model.fromJson(authOAuth2ModelJson1);
      expect(modelFromJson, authOAuth2Model);
      expect(modelFromJson.grantType, OAuth2GrantType.authorizationCode);
      expect(
        modelFromJson.authorizationUrl,
        'https://oauth.example.com/authorize',
      );
      expect(modelFromJson.accessTokenUrl, 'https://oauth.example.com/token');
      expect(modelFromJson.clientId, 'oauth2-client-id-123');
      expect(modelFromJson.clientSecret, 'oauth2-client-secret-456');
      expect(
        modelFromJson.credentialsFilePath,
        '/path/to/oauth2/credentials.json',
      );
    });

    test("Testing AuthOAuth2Model getters", () {
      var authOAuth2Model = authOAuth2Model1;
      expect(authOAuth2Model.grantType, OAuth2GrantType.authorizationCode);
      expect(
        authOAuth2Model.authorizationUrl,
        'https://oauth.example.com/authorize',
      );
      expect(authOAuth2Model.accessTokenUrl, 'https://oauth.example.com/token');
      expect(authOAuth2Model.clientId, 'oauth2-client-id-123');
      expect(authOAuth2Model.clientSecret, 'oauth2-client-secret-456');
      expect(
        authOAuth2Model.credentialsFilePath,
        '/path/to/oauth2/credentials.json',
      );
      expect(authOAuth2Model.redirectUrl, 'https://example.com/redirect');
      expect(authOAuth2Model.scope, 'read write admin');
      expect(authOAuth2Model.state, 'oauth2-state-789');
      expect(authOAuth2Model.codeChallengeMethod, 'S256');
      expect(authOAuth2Model.codeVerifier, 'oauth2-code-verifier-012');
      expect(authOAuth2Model.codeChallenge, 'oauth2-code-challenge-345');
      expect(authOAuth2Model.username, 'oauth2-username');
      expect(authOAuth2Model.password, 'oauth2-password');
      expect(authOAuth2Model.refreshToken, 'oauth2-refresh-token-678');
      expect(authOAuth2Model.identityToken, 'oauth2-identity-token-901');
      expect(authOAuth2Model.accessToken, 'oauth2-access-token-234');
    });

    test("Testing AuthOAuth2Model equality", () {
      const authOAuth2Model1Copy = AuthOAuth2Model(
        grantType: OAuth2GrantType.authorizationCode,
        authorizationUrl: 'https://oauth.example.com/authorize',
        accessTokenUrl: 'https://oauth.example.com/token',
        clientId: 'oauth2-client-id-123',
        clientSecret: 'oauth2-client-secret-456',
        credentialsFilePath: '/path/to/oauth2/credentials.json',
        redirectUrl: 'https://example.com/redirect',
        scope: 'read write admin',
        state: 'oauth2-state-789',
        codeChallengeMethod: 'S256',
        codeVerifier: 'oauth2-code-verifier-012',
        codeChallenge: 'oauth2-code-challenge-345',
        username: 'oauth2-username',
        password: 'oauth2-password',
        refreshToken: 'oauth2-refresh-token-678',
        identityToken: 'oauth2-identity-token-901',
        accessToken: 'oauth2-access-token-234',
      );
      expect(authOAuth2Model1, authOAuth2Model1Copy);
      expect(authOAuth2Model1, isNot(authOAuth2Model2));
    });

    test("Testing AuthOAuth2Model with different values", () {
      expect(authOAuth2Model2.grantType, OAuth2GrantType.clientCredentials);
      expect(
        authOAuth2Model2.authorizationUrl,
        'https://different-oauth.example.com/auth',
      );
      expect(
        authOAuth2Model2.accessTokenUrl,
        'https://different-oauth.example.com/token',
      );
      expect(authOAuth2Model2.clientId, 'different-client-id');
      expect(authOAuth2Model2.clientSecret, 'different-client-secret');
      expect(
        authOAuth2Model2.credentialsFilePath,
        '/different/oauth2/path.json',
      );
      expect(authOAuth2Model2.scope, 'api:read');
      expect(authOAuth2Model2.codeChallengeMethod, 'plain');
      expect(authOAuth2Model1.grantType, isNot(authOAuth2Model2.grantType));
      expect(authOAuth2Model1.clientId, isNot(authOAuth2Model2.clientId));
    });

    test("Testing AuthOAuth2Model with default values", () {
      const authOAuth2ModelDefaults = AuthOAuth2Model(
        authorizationUrl: 'https://auth.example.com/authorize',
        accessTokenUrl: 'https://auth.example.com/token',
        clientId: 'test-client-id',
        clientSecret: 'test-client-secret',
        credentialsFilePath: '/test/credentials.json',
      );

      expect(
        authOAuth2ModelDefaults.grantType,
        OAuth2GrantType.authorizationCode,
      );
      expect(
        authOAuth2ModelDefaults.authorizationUrl,
        'https://auth.example.com/authorize',
      );
      expect(
        authOAuth2ModelDefaults.accessTokenUrl,
        'https://auth.example.com/token',
      );
      expect(authOAuth2ModelDefaults.clientId, 'test-client-id');
      expect(authOAuth2ModelDefaults.clientSecret, 'test-client-secret');
      expect(
        authOAuth2ModelDefaults.credentialsFilePath,
        '/test/credentials.json',
      );
      expect(authOAuth2ModelDefaults.codeChallengeMethod, 'sha-256');
      expect(authOAuth2ModelDefaults.redirectUrl, isNull);
      expect(authOAuth2ModelDefaults.scope, isNull);
      expect(authOAuth2ModelDefaults.state, isNull);
      expect(authOAuth2ModelDefaults.codeVerifier, isNull);
      expect(authOAuth2ModelDefaults.codeChallenge, isNull);
      expect(authOAuth2ModelDefaults.username, isNull);
      expect(authOAuth2ModelDefaults.password, isNull);
      expect(authOAuth2ModelDefaults.refreshToken, isNull);
      expect(authOAuth2ModelDefaults.identityToken, isNull);
      expect(authOAuth2ModelDefaults.accessToken, isNull);
    });

    test("Testing AuthOAuth2Model with all grant types", () {
      const authOAuth2ModelAuthCode = AuthOAuth2Model(
        grantType: OAuth2GrantType.authorizationCode,
        authorizationUrl: 'https://auth.example.com/authorize',
        accessTokenUrl: 'https://auth.example.com/token',
        clientId: 'test-client-id',
        clientSecret: 'test-client-secret',
        credentialsFilePath: '/test/credentials.json',
      );

      const authOAuth2ModelClientCreds = AuthOAuth2Model(
        grantType: OAuth2GrantType.clientCredentials,
        authorizationUrl: 'https://auth.example.com/authorize',
        accessTokenUrl: 'https://auth.example.com/token',
        clientId: 'test-client-id',
        clientSecret: 'test-client-secret',
        credentialsFilePath: '/test/credentials.json',
      );

      expect(
        authOAuth2ModelAuthCode.grantType,
        OAuth2GrantType.authorizationCode,
      );
      expect(
        authOAuth2ModelClientCreds.grantType,
        OAuth2GrantType.clientCredentials,
      );
      expect(
        authOAuth2ModelAuthCode.grantType.displayType,
        'Authorization Code',
      );
      expect(
        authOAuth2ModelClientCreds.grantType.displayType,
        'Client Credentials',
      );
    });

    test("Testing AuthOAuth2Model with PKCE parameters", () {
      const authOAuth2ModelWithPKCE = AuthOAuth2Model(
        authorizationUrl: 'https://auth.example.com/authorize',
        accessTokenUrl: 'https://auth.example.com/token',
        clientId: 'test-client-id',
        clientSecret: 'test-client-secret',
        credentialsFilePath: '/test/credentials.json',
        codeChallengeMethod: 'S256',
        codeVerifier: 'test-code-verifier',
        codeChallenge: 'test-code-challenge',
      );

      expect(authOAuth2ModelWithPKCE.codeChallengeMethod, 'S256');
      expect(authOAuth2ModelWithPKCE.codeVerifier, 'test-code-verifier');
      expect(authOAuth2ModelWithPKCE.codeChallenge, 'test-code-challenge');
    });

    test(
      "Testing AuthOAuth2Model with resource owner password credentials",
      () {
        const authOAuth2ModelWithPassword = AuthOAuth2Model(
          authorizationUrl: 'https://auth.example.com/authorize',
          accessTokenUrl: 'https://auth.example.com/token',
          clientId: 'test-client-id',
          clientSecret: 'test-client-secret',
          credentialsFilePath: '/test/credentials.json',
          username: 'test-username',
          password: 'test-password',
        );

        expect(authOAuth2ModelWithPassword.username, 'test-username');
        expect(authOAuth2ModelWithPassword.password, 'test-password');
      },
    );

    test("Testing AuthOAuth2Model with tokens", () {
      const authOAuth2ModelWithTokens = AuthOAuth2Model(
        authorizationUrl: 'https://auth.example.com/authorize',
        accessTokenUrl: 'https://auth.example.com/token',
        clientId: 'test-client-id',
        clientSecret: 'test-client-secret',
        credentialsFilePath: '/test/credentials.json',
        accessToken: 'test-access-token',
        refreshToken: 'test-refresh-token',
        identityToken: 'test-identity-token',
      );

      expect(authOAuth2ModelWithTokens.accessToken, 'test-access-token');
      expect(authOAuth2ModelWithTokens.refreshToken, 'test-refresh-token');
      expect(authOAuth2ModelWithTokens.identityToken, 'test-identity-token');
    });

    test("Testing AuthOAuth2Model with scopes and state", () {
      const authOAuth2ModelWithScope = AuthOAuth2Model(
        authorizationUrl: 'https://auth.example.com/authorize',
        accessTokenUrl: 'https://auth.example.com/token',
        clientId: 'test-client-id',
        clientSecret: 'test-client-secret',
        credentialsFilePath: '/test/credentials.json',
        scope: 'read write delete',
        state: 'test-state-parameter',
      );

      expect(authOAuth2ModelWithScope.scope, 'read write delete');
      expect(authOAuth2ModelWithScope.state, 'test-state-parameter');
    });

    test("Testing AuthOAuth2Model with redirect URL", () {
      const authOAuth2ModelWithRedirect = AuthOAuth2Model(
        authorizationUrl: 'https://auth.example.com/authorize',
        accessTokenUrl: 'https://auth.example.com/token',
        clientId: 'test-client-id',
        clientSecret: 'test-client-secret',
        credentialsFilePath: '/test/credentials.json',
        redirectUrl: 'https://myapp.example.com/oauth/callback',
      );

      expect(
        authOAuth2ModelWithRedirect.redirectUrl,
        'https://myapp.example.com/oauth/callback',
      );
    });

    test("Testing AuthOAuth2Model code challenge methods", () {
      const authOAuth2ModelSha256 = AuthOAuth2Model(
        authorizationUrl: 'https://auth.example.com/authorize',
        accessTokenUrl: 'https://auth.example.com/token',
        clientId: 'test-client-id',
        clientSecret: 'test-client-secret',
        credentialsFilePath: '/test/credentials.json',
        codeChallengeMethod: 'S256',
      );

      const authOAuth2ModelPlain = AuthOAuth2Model(
        authorizationUrl: 'https://auth.example.com/authorize',
        accessTokenUrl: 'https://auth.example.com/token',
        clientId: 'test-client-id',
        clientSecret: 'test-client-secret',
        credentialsFilePath: '/test/credentials.json',
        codeChallengeMethod: 'plain',
      );

      expect(authOAuth2ModelSha256.codeChallengeMethod, 'S256');
      expect(authOAuth2ModelPlain.codeChallengeMethod, 'plain');
    });
  });
}
