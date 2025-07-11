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
    });

    test('should create AuthModel with basic authentication', () {
      const basicAuth = AuthBasicAuthModel(
        username: 'testuser',
        password: 'testpass',
      );

      const authModel = AuthModel(
        type: APIAuthType.basic,
        basic: basicAuth,
      );

      expect(authModel.type, APIAuthType.basic);
      expect(authModel.basic, isNotNull);
      expect(authModel.basic?.username, 'testuser');
      expect(authModel.basic?.password, 'testpass');
    });

    test('should create AuthModel with bearer token', () {
      const bearerAuth = AuthBearerModel(token: 'bearer-token-123');

      const authModel = AuthModel(
        type: APIAuthType.bearer,
        bearer: bearerAuth,
      );

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

      const authModel = AuthModel(
        type: APIAuthType.apiKey,
        apikey: apiKeyAuth,
      );

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

      const authModel = AuthModel(
        type: APIAuthType.jwt,
        jwt: jwtAuth,
      );

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

      const authModel = AuthModel(
        type: APIAuthType.digest,
        digest: digestAuth,
      );

      expect(authModel.type, APIAuthType.digest);
      expect(authModel.digest, isNotNull);
      expect(authModel.digest?.username, 'digestuser');
      expect(authModel.digest?.realm, 'test-realm');
      expect(authModel.digest?.algorithm, 'MD5');
    });

    test('should serialize and deserialize AuthModel correctly', () {
      const originalModel = AuthModel(
        type: APIAuthType.basic,
        basic: AuthBasicAuthModel(
          username: 'testuser',
          password: 'testpass',
        ),
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
        basic: AuthBasicAuthModel(
          username: 'testuser',
          password: 'testpass',
        ),
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
      const basicAuth = AuthBasicAuthModel(
        username: '',
        password: '',
      );

      const authModel = AuthModel(
        type: APIAuthType.basic,
        basic: basicAuth,
      );

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
    );

    expect(authModel.type, APIAuthType.bearer);
    expect(authModel.basic, isNotNull);
    expect(authModel.bearer, isNotNull);
    expect(authModel.apikey, isNotNull);
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
}
