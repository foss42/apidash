import 'package:better_networking/better_networking.dart';
import 'package:test/test.dart';

void main() {
  group('AuthModel Tests', () {
    test('should create AuthModel with none type', () {
      const authModel = AuthModel(type: APIAuthType.none);

      expect(authModel.type, APIAuthType.none);
      expect(authModel.basic, isNull);
      expect(authModel.bearer, isNull);
      expect(authModel.apikey, isNull);
      expect(authModel.jwt, isNull);
      expect(authModel.digest, isNull);
      expect(authModel.oauth1, isNull);
      expect(authModel.oauth2, isNull);
    });

    test('should create AuthModel with basic authentication', () {
      const basicAuth = AuthBasicAuthModel(
        username: 'testuser',
        password: 'testpass',
      );

      const authModel = AuthModel(type: APIAuthType.basic, basic: basicAuth);

      expect(authModel.type, APIAuthType.basic);
      expect(authModel.basic, isNotNull);
      expect(authModel.basic?.username, 'testuser');
      expect(authModel.basic?.password, 'testpass');
    });

    test('should create AuthModel with bearer token', () {
      const bearerAuth = AuthBearerModel(token: 'bearer-token-123');

      const authModel = AuthModel(type: APIAuthType.bearer, bearer: bearerAuth);

      expect(authModel.type, APIAuthType.bearer);
      expect(authModel.bearer, isNotNull);
      expect(authModel.bearer?.token, 'bearer-token-123');
    });

    test('should create AuthModel with API key authentication', () {
      const apiKeyAuth = AuthApiKeyModel(
        key: 'api-key-123',
        location: 'header',
        name: 'X-API-Key',
      );

      const authModel = AuthModel(type: APIAuthType.apiKey, apikey: apiKeyAuth);

      expect(authModel.type, APIAuthType.apiKey);
      expect(authModel.apikey, isNotNull);
      expect(authModel.apikey?.key, 'api-key-123');
      expect(authModel.apikey?.location, 'header');
      expect(authModel.apikey?.name, 'X-API-Key');
    });

    test('should create AuthModel with JWT authentication', () {
      const jwtAuth = AuthJwtModel(
        secret: 'jwt-secret',
        payload: '{"sub": "1234567890"}',
        addTokenTo: 'header',
        algorithm: 'HS256',
        isSecretBase64Encoded: false,
        headerPrefix: 'Bearer',
        queryParamKey: 'token',
        header: 'Authorization',
      );

      const authModel = AuthModel(type: APIAuthType.jwt, jwt: jwtAuth);

      expect(authModel.type, APIAuthType.jwt);
      expect(authModel.jwt, isNotNull);
      expect(authModel.jwt?.secret, 'jwt-secret');
      expect(authModel.jwt?.algorithm, 'HS256');
      expect(authModel.jwt?.isSecretBase64Encoded, false);
    });

    test('should create AuthModel with digest authentication', () {
      const digestAuth = AuthDigestModel(
        username: 'digestuser',
        password: 'digestpass',
        realm: 'test-realm',
        nonce: 'test-nonce',
        algorithm: 'MD5',
        qop: 'auth',
        opaque: 'test-opaque',
      );

      const authModel = AuthModel(type: APIAuthType.digest, digest: digestAuth);

      expect(authModel.type, APIAuthType.digest);
      expect(authModel.digest, isNotNull);
      expect(authModel.digest?.username, 'digestuser');
      expect(authModel.digest?.realm, 'test-realm');
      expect(authModel.digest?.algorithm, 'MD5');
    });

    test('should create AuthModel with OAuth1 authentication', () {
      const oauth1Auth = AuthOAuth1Model(
        consumerKey: 'oauth1-consumer-key',
        consumerSecret: 'oauth1-consumer-secret',
        credentialsFilePath: '/path/to/credentials.json',
        accessToken: 'oauth1-access-token',
        tokenSecret: 'oauth1-token-secret',
        signatureMethod: OAuth1SignatureMethod.hmacSha1,
        parameterLocation: 'header',
        version: '1.0',
        realm: 'oauth1-realm',
        callbackUrl: 'https://example.com/callback',
        includeBodyHash: false,
      );

      const authModel = AuthModel(type: APIAuthType.oauth1, oauth1: oauth1Auth);

      expect(authModel.type, APIAuthType.oauth1);
      expect(authModel.oauth1, isNotNull);
      expect(authModel.oauth1?.consumerKey, 'oauth1-consumer-key');
      expect(authModel.oauth1?.consumerSecret, 'oauth1-consumer-secret');
      expect(
        authModel.oauth1?.credentialsFilePath,
        '/path/to/credentials.json',
      );
      expect(authModel.oauth1?.accessToken, 'oauth1-access-token');
      expect(authModel.oauth1?.tokenSecret, 'oauth1-token-secret');
      expect(authModel.oauth1?.signatureMethod, OAuth1SignatureMethod.hmacSha1);
      expect(authModel.oauth1?.parameterLocation, 'header');
      expect(authModel.oauth1?.version, '1.0');
      expect(authModel.oauth1?.realm, 'oauth1-realm');
      expect(authModel.oauth1?.callbackUrl, 'https://example.com/callback');
      expect(authModel.oauth1?.includeBodyHash, false);
    });

    test('should create AuthModel with OAuth2 authentication', () {
      const oauth2Auth = AuthOAuth2Model(
        grantType: OAuth2GrantType.authorizationCode,
        authorizationUrl: 'https://oauth.example.com/authorize',
        accessTokenUrl: 'https://oauth.example.com/token',
        clientId: 'oauth2-client-id',
        clientSecret: 'oauth2-client-secret',
        credentialsFilePath: '/path/to/oauth2/credentials.json',
        redirectUrl: 'https://example.com/redirect',
        scope: 'read write',
        state: 'oauth2-state',
        codeChallengeMethod: 'S256',
        username: 'oauth2-username',
        password: 'oauth2-password',
        refreshToken: 'oauth2-refresh-token',
        accessToken: 'oauth2-access-token',
      );

      const authModel = AuthModel(type: APIAuthType.oauth2, oauth2: oauth2Auth);

      expect(authModel.type, APIAuthType.oauth2);
      expect(authModel.oauth2, isNotNull);
      expect(authModel.oauth2?.grantType, OAuth2GrantType.authorizationCode);
      expect(
        authModel.oauth2?.authorizationUrl,
        'https://oauth.example.com/authorize',
      );
      expect(
        authModel.oauth2?.accessTokenUrl,
        'https://oauth.example.com/token',
      );
      expect(authModel.oauth2?.clientId, 'oauth2-client-id');
      expect(authModel.oauth2?.clientSecret, 'oauth2-client-secret');
      expect(
        authModel.oauth2?.credentialsFilePath,
        '/path/to/oauth2/credentials.json',
      );
      expect(authModel.oauth2?.redirectUrl, 'https://example.com/redirect');
      expect(authModel.oauth2?.scope, 'read write');
      expect(authModel.oauth2?.state, 'oauth2-state');
      expect(authModel.oauth2?.codeChallengeMethod, 'S256');
      expect(authModel.oauth2?.username, 'oauth2-username');
      expect(authModel.oauth2?.password, 'oauth2-password');
      expect(authModel.oauth2?.refreshToken, 'oauth2-refresh-token');
      expect(authModel.oauth2?.accessToken, 'oauth2-access-token');
    });

    test('should handle OAuth1 with default values', () {
      const oauth1Auth = AuthOAuth1Model(
        consumerKey: 'test-consumer-key',
        consumerSecret: 'test-consumer-secret',
        credentialsFilePath: '/default/path/credentials.json',
      );

      expect(oauth1Auth.consumerKey, 'test-consumer-key');
      expect(oauth1Auth.consumerSecret, 'test-consumer-secret');
      expect(oauth1Auth.credentialsFilePath, '/default/path/credentials.json');
      expect(oauth1Auth.signatureMethod, OAuth1SignatureMethod.hmacSha1);
      expect(oauth1Auth.parameterLocation, 'header');
      expect(oauth1Auth.version, '1.0');
      expect(oauth1Auth.includeBodyHash, false);
      expect(oauth1Auth.accessToken, isNull);
      expect(oauth1Auth.tokenSecret, isNull);
    });

    test('should handle OAuth1 with custom values', () {
      const oauth1Auth = AuthOAuth1Model(
        consumerKey: 'custom-consumer-key',
        consumerSecret: 'custom-consumer-secret',
        credentialsFilePath: '/custom/path/credentials.json',
        accessToken: 'custom-access-token',
        tokenSecret: 'custom-token-secret',
        signatureMethod: OAuth1SignatureMethod.plaintext,
        parameterLocation: 'query',
        version: '1.0a',
        realm: 'custom-realm',
        callbackUrl: 'https://custom.example.com/callback',
        verifier: 'custom-verifier',
        nonce: 'custom-nonce',
        timestamp: '1640995200',
        includeBodyHash: true,
      );

      expect(oauth1Auth.consumerKey, 'custom-consumer-key');
      expect(oauth1Auth.consumerSecret, 'custom-consumer-secret');
      expect(oauth1Auth.signatureMethod, OAuth1SignatureMethod.plaintext);
      expect(oauth1Auth.parameterLocation, 'query');
      expect(oauth1Auth.version, '1.0a');
      expect(oauth1Auth.realm, 'custom-realm');
      expect(oauth1Auth.callbackUrl, 'https://custom.example.com/callback');
      expect(oauth1Auth.verifier, 'custom-verifier');
      expect(oauth1Auth.nonce, 'custom-nonce');
      expect(oauth1Auth.timestamp, '1640995200');
      expect(oauth1Auth.includeBodyHash, true);
    });

    test('should handle OAuth2 with default values', () {
      const oauth2Auth = AuthOAuth2Model(
        authorizationUrl: 'https://auth.example.com/authorize',
        accessTokenUrl: 'https://auth.example.com/token',
        clientId: 'test-client-id',
        clientSecret: 'test-client-secret',
        credentialsFilePath: '/default/oauth2/credentials.json',
      );

      expect(oauth2Auth.grantType, OAuth2GrantType.authorizationCode);
      expect(oauth2Auth.authorizationUrl, 'https://auth.example.com/authorize');
      expect(oauth2Auth.accessTokenUrl, 'https://auth.example.com/token');
      expect(oauth2Auth.clientId, 'test-client-id');
      expect(oauth2Auth.clientSecret, 'test-client-secret');
      expect(
        oauth2Auth.credentialsFilePath,
        '/default/oauth2/credentials.json',
      );
      expect(oauth2Auth.codeChallengeMethod, 'sha-256');
      expect(oauth2Auth.redirectUrl, isNull);
      expect(oauth2Auth.scope, isNull);
      expect(oauth2Auth.state, isNull);
    });

    test('should handle OAuth2 with custom grant type and values', () {
      const oauth2Auth = AuthOAuth2Model(
        grantType: OAuth2GrantType.clientCredentials,
        authorizationUrl: 'https://custom-auth.example.com/authorize',
        accessTokenUrl: 'https://custom-auth.example.com/token',
        clientId: 'custom-client-id',
        clientSecret: 'custom-client-secret',
        credentialsFilePath: '/custom/oauth2/credentials.json',
        redirectUrl: 'https://custom.example.com/redirect',
        scope: 'read write admin',
        state: 'custom-state',
        codeChallengeMethod: 'plain',
        codeVerifier: 'custom-code-verifier',
        codeChallenge: 'custom-code-challenge',
        username: 'custom-username',
        password: 'custom-password',
        refreshToken: 'custom-refresh-token',
        identityToken: 'custom-identity-token',
        accessToken: 'custom-access-token',
      );

      expect(oauth2Auth.grantType, OAuth2GrantType.clientCredentials);
      expect(
        oauth2Auth.authorizationUrl,
        'https://custom-auth.example.com/authorize',
      );
      expect(
        oauth2Auth.accessTokenUrl,
        'https://custom-auth.example.com/token',
      );
      expect(oauth2Auth.clientId, 'custom-client-id');
      expect(oauth2Auth.clientSecret, 'custom-client-secret');
      expect(oauth2Auth.redirectUrl, 'https://custom.example.com/redirect');
      expect(oauth2Auth.scope, 'read write admin');
      expect(oauth2Auth.state, 'custom-state');
      expect(oauth2Auth.codeChallengeMethod, 'plain');
      expect(oauth2Auth.codeVerifier, 'custom-code-verifier');
      expect(oauth2Auth.codeChallenge, 'custom-code-challenge');
      expect(oauth2Auth.username, 'custom-username');
      expect(oauth2Auth.password, 'custom-password');
      expect(oauth2Auth.refreshToken, 'custom-refresh-token');
      expect(oauth2Auth.identityToken, 'custom-identity-token');
      expect(oauth2Auth.accessToken, 'custom-access-token');
    });

    test(
      'should serialize and deserialize AuthModel with OAuth1 correctly',
      () {
        const originalModel = AuthModel(
          type: APIAuthType.oauth1,
          oauth1: AuthOAuth1Model(
            consumerKey: 'test-consumer-key',
            consumerSecret: 'test-consumer-secret',
            credentialsFilePath: '/test/credentials.json',
            accessToken: 'test-access-token',
            tokenSecret: 'test-token-secret',
          ),
        );

        final json = originalModel.toJson();
        final deserializedModel = AuthModel.fromJson(json);

        expect(deserializedModel.type, originalModel.type);
        expect(
          deserializedModel.oauth1?.consumerKey,
          originalModel.oauth1?.consumerKey,
        );
        expect(
          deserializedModel.oauth1?.consumerSecret,
          originalModel.oauth1?.consumerSecret,
        );
        expect(
          deserializedModel.oauth1?.credentialsFilePath,
          originalModel.oauth1?.credentialsFilePath,
        );
        expect(
          deserializedModel.oauth1?.accessToken,
          originalModel.oauth1?.accessToken,
        );
        expect(
          deserializedModel.oauth1?.tokenSecret,
          originalModel.oauth1?.tokenSecret,
        );
      },
    );

    test(
      'should serialize and deserialize AuthModel with OAuth2 correctly',
      () {
        const originalModel = AuthModel(
          type: APIAuthType.oauth2,
          oauth2: AuthOAuth2Model(
            grantType: OAuth2GrantType.authorizationCode,
            authorizationUrl: 'https://auth.example.com/authorize',
            accessTokenUrl: 'https://auth.example.com/token',
            clientId: 'test-client-id',
            clientSecret: 'test-client-secret',
            credentialsFilePath: '/test/oauth2/credentials.json',
            redirectUrl: 'https://example.com/redirect',
            scope: 'read write',
            state: 'test-state',
          ),
        );

        final json = originalModel.toJson();
        final deserializedModel = AuthModel.fromJson(json);

        expect(deserializedModel.type, originalModel.type);
        expect(
          deserializedModel.oauth2?.grantType,
          originalModel.oauth2?.grantType,
        );
        expect(
          deserializedModel.oauth2?.authorizationUrl,
          originalModel.oauth2?.authorizationUrl,
        );
        expect(
          deserializedModel.oauth2?.accessTokenUrl,
          originalModel.oauth2?.accessTokenUrl,
        );
        expect(
          deserializedModel.oauth2?.clientId,
          originalModel.oauth2?.clientId,
        );
        expect(
          deserializedModel.oauth2?.clientSecret,
          originalModel.oauth2?.clientSecret,
        );
        expect(
          deserializedModel.oauth2?.credentialsFilePath,
          originalModel.oauth2?.credentialsFilePath,
        );
        expect(
          deserializedModel.oauth2?.redirectUrl,
          originalModel.oauth2?.redirectUrl,
        );
        expect(deserializedModel.oauth2?.scope, originalModel.oauth2?.scope);
        expect(deserializedModel.oauth2?.state, originalModel.oauth2?.state);
      },
    );

    test('should serialize and deserialize AuthModel correctly', () {
      const originalModel = AuthModel(
        type: APIAuthType.basic,
        basic: AuthBasicAuthModel(username: 'testuser', password: 'testpass'),
      );

      final json = originalModel.toJson();
      final deserializedModel = AuthModel.fromJson(json);

      expect(deserializedModel.type, originalModel.type);
      expect(deserializedModel.basic?.username, originalModel.basic?.username);
      expect(deserializedModel.basic?.password, originalModel.basic?.password);
    });

    test('should handle copyWith for AuthModel', () {
      const originalModel = AuthModel(
        type: APIAuthType.basic,
        basic: AuthBasicAuthModel(username: 'testuser', password: 'testpass'),
      );

      const newBasicAuth = AuthBasicAuthModel(
        username: 'newuser',
        password: 'newpass',
      );

      final copiedModel = originalModel.copyWith(
        type: APIAuthType.basic,
        basic: newBasicAuth,
      );

      expect(copiedModel.type, APIAuthType.basic);
      expect(copiedModel.basic?.username, 'newuser');
      expect(copiedModel.basic?.password, 'newpass');
    });

    test('should handle API key with default values', () {
      const apiKeyAuth = AuthApiKeyModel(key: 'test-key');

      expect(apiKeyAuth.key, 'test-key');
      expect(apiKeyAuth.location, 'header');
      expect(apiKeyAuth.name, 'x-api-key');
    });

    test('should handle API key with custom values', () {
      const apiKeyAuth = AuthApiKeyModel(
        key: 'custom-key',
        location: 'query',
        name: 'api_key',
      );

      expect(apiKeyAuth.key, 'custom-key');
      expect(apiKeyAuth.location, 'query');
      expect(apiKeyAuth.name, 'api_key');
    });

    test('should handle JWT with private key', () {
      const jwtAuth = AuthJwtModel(
        secret: 'jwt-secret',
        privateKey: 'private-key-content',
        payload: '{"sub": "1234567890"}',
        addTokenTo: 'header',
        algorithm: 'RS256',
        isSecretBase64Encoded: true,
        headerPrefix: 'Bearer',
        queryParamKey: 'token',
        header: 'Authorization',
      );

      expect(jwtAuth.secret, 'jwt-secret');
      expect(jwtAuth.privateKey, 'private-key-content');
      expect(jwtAuth.algorithm, 'RS256');
      expect(jwtAuth.isSecretBase64Encoded, true);
    });

    test('should handle edge cases with empty strings', () {
      const basicAuth = AuthBasicAuthModel(username: '', password: '');

      const authModel = AuthModel(type: APIAuthType.basic, basic: basicAuth);

      expect(authModel.basic?.username, '');
      expect(authModel.basic?.password, '');
    });

    test('should handle JSON serialization with null values', () {
      const authModel = AuthModel(type: APIAuthType.none);

      final json = authModel.toJson();
      final deserializedModel = AuthModel.fromJson(json);

      expect(deserializedModel.type, APIAuthType.none);
      expect(deserializedModel.basic, isNull);
      expect(deserializedModel.bearer, isNull);
      expect(deserializedModel.apikey, isNull);
      expect(deserializedModel.jwt, isNull);
      expect(deserializedModel.digest, isNull);
      expect(deserializedModel.oauth1, isNull);
      expect(deserializedModel.oauth2, isNull);
    });

    test('should handle complex JWT payload', () {
      const complexPayload = '''
      {
        "sub": "1234567890",
        "name": "John Doe",
        "iat": 1516239022,
        "exp": 1516242622,
        "roles": ["admin", "user"],
        "permissions": {
          "read": true,
          "write": false
        }
      }
      ''';

      const jwtAuth = AuthJwtModel(
        secret: 'complex-secret',
        payload: complexPayload,
        addTokenTo: 'header',
        algorithm: 'HS512',
        isSecretBase64Encoded: false,
        headerPrefix: 'JWT',
        queryParamKey: 'jwt_token',
        header: 'X-JWT-Token',
      );

      expect(jwtAuth.payload, complexPayload);
      expect(jwtAuth.headerPrefix, 'JWT');
      expect(jwtAuth.queryParamKey, 'jwt_token');
      expect(jwtAuth.header, 'X-JWT-Token');
    });

    test('should handle digest auth with all parameters', () {
      const digestAuth = AuthDigestModel(
        username: 'digestuser',
        password: 'digestpass',
        realm: 'api.example.com',
        nonce: 'dcd98b7102dd2f0e8b11d0f600bfb0c093',
        algorithm: 'SHA-256',
        qop: 'auth-int',
        opaque: '5ccc069c403ebaf9f0171e9517f40e41',
      );

      expect(digestAuth.username, 'digestuser');
      expect(digestAuth.password, 'digestpass');
      expect(digestAuth.realm, 'api.example.com');
      expect(digestAuth.nonce, 'dcd98b7102dd2f0e8b11d0f600bfb0c093');
      expect(digestAuth.algorithm, 'SHA-256');
      expect(digestAuth.qop, 'auth-int');
      expect(digestAuth.opaque, '5ccc069c403ebaf9f0171e9517f40e41');
    });
  });

  test('should handle type mismatch scenarios', () {
    // Test when type is basic but bearer data is provided
    const authModel = AuthModel(
      type: APIAuthType.basic,
      bearer: AuthBearerModel(token: 'token'),
    );

    expect(authModel.type, APIAuthType.basic);
    expect(authModel.bearer?.token, 'token');
    expect(authModel.basic, isNull);
  });

  test('should handle multiple auth types provided', () {
    const authModel = AuthModel(
      type: APIAuthType.bearer,
      basic: AuthBasicAuthModel(username: 'user', password: 'pass'),
      bearer: AuthBearerModel(token: 'token'),
      apikey: AuthApiKeyModel(key: 'key'),
      oauth1: AuthOAuth1Model(
        consumerKey: 'consumer-key',
        consumerSecret: 'consumer-secret',
        credentialsFilePath: '/path/credentials.json',
      ),
      oauth2: AuthOAuth2Model(
        authorizationUrl: 'https://auth.example.com/authorize',
        accessTokenUrl: 'https://auth.example.com/token',
        clientId: 'client-id',
        clientSecret: 'client-secret',
        credentialsFilePath: '/path/oauth2-credentials.json',
      ),
    );

    expect(authModel.type, APIAuthType.bearer);
    expect(authModel.basic, isNotNull);
    expect(authModel.bearer, isNotNull);
    expect(authModel.apikey, isNotNull);
    expect(authModel.oauth1, isNotNull);
    expect(authModel.oauth2, isNotNull);
  });

  test('should handle serialization with special characters', () {
    const basicAuth = AuthBasicAuthModel(
      username: 'user@domain.com',
      password: r'P@ssw0rd!@#$%^&*()',
    );

    const authModel = AuthModel(type: APIAuthType.basic, basic: basicAuth);

    final json = authModel.toJson();
    final deserializedModel = AuthModel.fromJson(json);

    expect(deserializedModel.basic?.username, 'user@domain.com');
    expect(deserializedModel.basic?.password, r'P@ssw0rd!@#$%^&*()');
  });

  test('should handle very long strings', () {
    final longString = 'a' * 1000;

    final bearerAuth = AuthBearerModel(token: longString);
    final authModel = AuthModel(type: APIAuthType.bearer, bearer: bearerAuth);

    expect(authModel.bearer?.token, longString);
    expect(authModel.bearer?.token.length, 1000);
  });

  test('should handle Unicode characters', () {
    const basicAuth = AuthBasicAuthModel(
      username: 'user_测试_тест_テスト',
      password: 'password_🔑_🚀_💻',
    );

    const authModel = AuthModel(type: APIAuthType.basic, basic: basicAuth);

    final json = authModel.toJson();
    final deserializedModel = AuthModel.fromJson(json);

    expect(deserializedModel.basic?.username, 'user_测试_тест_テスト');
    expect(deserializedModel.basic?.password, 'password_🔑_🚀_💻');
  });

  test('should handle OAuth1 with minimal required fields', () {
    const oauth1Auth = AuthOAuth1Model(
      consumerKey: 'minimal-key',
      consumerSecret: 'minimal-secret',
      credentialsFilePath: '/minimal/path.json',
    );

    const authModel = AuthModel(type: APIAuthType.oauth1, oauth1: oauth1Auth);

    expect(authModel.type, APIAuthType.oauth1);
    expect(authModel.oauth1?.consumerKey, 'minimal-key');
    expect(authModel.oauth1?.consumerSecret, 'minimal-secret');
    expect(authModel.oauth1?.credentialsFilePath, '/minimal/path.json');
    expect(authModel.oauth1?.accessToken, isNull);
    expect(authModel.oauth1?.tokenSecret, isNull);
  });

  test('should handle OAuth2 with minimal required fields', () {
    const oauth2Auth = AuthOAuth2Model(
      authorizationUrl: 'https://min-auth.example.com/authorize',
      accessTokenUrl: 'https://min-auth.example.com/token',
      clientId: 'minimal-client-id',
      clientSecret: 'minimal-client-secret',
      credentialsFilePath: '/minimal/oauth2.json',
    );

    const authModel = AuthModel(type: APIAuthType.oauth2, oauth2: oauth2Auth);

    expect(authModel.type, APIAuthType.oauth2);
    expect(
      authModel.oauth2?.authorizationUrl,
      'https://min-auth.example.com/authorize',
    );
    expect(
      authModel.oauth2?.accessTokenUrl,
      'https://min-auth.example.com/token',
    );
    expect(authModel.oauth2?.clientId, 'minimal-client-id');
    expect(authModel.oauth2?.clientSecret, 'minimal-client-secret');
    expect(authModel.oauth2?.credentialsFilePath, '/minimal/oauth2.json');
    expect(authModel.oauth2?.redirectUrl, isNull);
    expect(authModel.oauth2?.scope, isNull);
  });

  test('should handle OAuth credentials with special characters', () {
    const oauth1Auth = AuthOAuth1Model(
      consumerKey: 'key_with@special#chars%',
      consumerSecret: 'secret_with!@#\$%^&*()',
      credentialsFilePath: '/path/with spaces/credentials.json',
      accessToken: 'token_with-dashes_and.dots',
      tokenSecret: 'secret_with/slashes\\backslashes',
    );

    const authModel = AuthModel(type: APIAuthType.oauth1, oauth1: oauth1Auth);

    final json = authModel.toJson();
    final deserializedModel = AuthModel.fromJson(json);

    expect(deserializedModel.oauth1?.consumerKey, 'key_with@special#chars%');
    expect(deserializedModel.oauth1?.consumerSecret, 'secret_with!@#\$%^&*()');
    expect(
      deserializedModel.oauth1?.credentialsFilePath,
      '/path/with spaces/credentials.json',
    );
    expect(deserializedModel.oauth1?.accessToken, 'token_with-dashes_and.dots');
    expect(
      deserializedModel.oauth1?.tokenSecret,
      'secret_with/slashes\\backslashes',
    );
  });

  test('should handle OAuth2 URLs with complex query parameters', () {
    const oauth2Auth = AuthOAuth2Model(
      authorizationUrl:
          'https://auth.example.com/authorize?response_type=code&client_id=test&redirect_uri=https://app.com/callback',
      accessTokenUrl:
          'https://auth.example.com/token?grant_type=authorization_code',
      clientId: 'complex-client-id',
      clientSecret: 'complex-client-secret',
      credentialsFilePath: '/complex/oauth2.json',
      redirectUrl: 'https://app.example.com/callback?state=abc123&code=def456',
      scope: 'read:user write:repo admin:org',
    );

    const authModel = AuthModel(type: APIAuthType.oauth2, oauth2: oauth2Auth);

    final json = authModel.toJson();
    final deserializedModel = AuthModel.fromJson(json);

    expect(
      deserializedModel.oauth2?.authorizationUrl,
      'https://auth.example.com/authorize?response_type=code&client_id=test&redirect_uri=https://app.com/callback',
    );
    expect(
      deserializedModel.oauth2?.accessTokenUrl,
      'https://auth.example.com/token?grant_type=authorization_code',
    );
    expect(
      deserializedModel.oauth2?.redirectUrl,
      'https://app.example.com/callback?state=abc123&code=def456',
    );
    expect(deserializedModel.oauth2?.scope, 'read:user write:repo admin:org');
  });

  test('should handle copyWith for OAuth1 AuthModel', () {
    const originalModel = AuthModel(
      type: APIAuthType.oauth1,
      oauth1: AuthOAuth1Model(
        consumerKey: 'original-key',
        consumerSecret: 'original-secret',
        credentialsFilePath: '/original/path.json',
      ),
    );

    const newOAuth1Auth = AuthOAuth1Model(
      consumerKey: 'new-key',
      consumerSecret: 'new-secret',
      credentialsFilePath: '/new/path.json',
      accessToken: 'new-access-token',
    );

    final copiedModel = originalModel.copyWith(oauth1: newOAuth1Auth);

    expect(copiedModel.type, APIAuthType.oauth1);
    expect(copiedModel.oauth1?.consumerKey, 'new-key');
    expect(copiedModel.oauth1?.consumerSecret, 'new-secret');
    expect(copiedModel.oauth1?.credentialsFilePath, '/new/path.json');
    expect(copiedModel.oauth1?.accessToken, 'new-access-token');
  });

  test('should handle copyWith for OAuth2 AuthModel', () {
    const originalModel = AuthModel(
      type: APIAuthType.oauth2,
      oauth2: AuthOAuth2Model(
        authorizationUrl: 'https://original-auth.example.com/authorize',
        accessTokenUrl: 'https://original-auth.example.com/token',
        clientId: 'original-client-id',
        clientSecret: 'original-client-secret',
        credentialsFilePath: '/original/oauth2.json',
      ),
    );

    const newOAuth2Auth = AuthOAuth2Model(
      authorizationUrl: 'https://new-auth.example.com/authorize',
      accessTokenUrl: 'https://new-auth.example.com/token',
      clientId: 'new-client-id',
      clientSecret: 'new-client-secret',
      credentialsFilePath: '/new/oauth2.json',
      scope: 'new-scope',
    );

    final copiedModel = originalModel.copyWith(oauth2: newOAuth2Auth);

    expect(copiedModel.type, APIAuthType.oauth2);
    expect(
      copiedModel.oauth2?.authorizationUrl,
      'https://new-auth.example.com/authorize',
    );
    expect(
      copiedModel.oauth2?.accessTokenUrl,
      'https://new-auth.example.com/token',
    );
    expect(copiedModel.oauth2?.clientId, 'new-client-id');
    expect(copiedModel.oauth2?.clientSecret, 'new-client-secret');
    expect(copiedModel.oauth2?.credentialsFilePath, '/new/oauth2.json');
    expect(copiedModel.oauth2?.scope, 'new-scope');
  });
}
