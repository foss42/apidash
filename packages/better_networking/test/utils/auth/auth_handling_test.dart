import 'package:better_networking/better_networking.dart';
import 'package:test/test.dart';

void main() {
  group('Authentication Handling Tests', () {
    test(
      'given sendHttpRequest when no authentication is provided then it should not throw any error',
      () async {
        const httpRequestModel = HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/users',
        );

        final result = await sendHttpRequest(
          'test-request',
          APIType.rest,
          null,
          httpRequestModel,
        );

        expect(
          result.$1?.request?.url.toString(),
          equals('https://api.apidash.dev/users'),
        );
      },
    );
    test(
      'given handleAuth when no authentication is provided then it should return the same httpRequestModel',
      () async {
        const httpRequestModel = HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/users',
        );

        final result = await handleAuth(httpRequestModel, null);

        expect(result.headers, isNull);
        expect(result.url, equals('https://api.apidash.dev/users'));
      },
    );

    test(
      'given handleAuth when none authentication type is provided then it should add any headers or throw errors',
      () async {
        const httpRequestModel = HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/users',
        );

        const authModel = AuthModel(type: APIAuthType.none);

        final result = await handleAuth(httpRequestModel, authModel);

        expect(result.headers, isEmpty);
        expect(result.url, equals('https://api.apidash.dev/users'));
      },
    );

    test(
      'given handleAuth when basic authentication fields are provided then it should add an authorization header',
      () async {
        const httpRequestModel = HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/users',
        );

        const basicAuth = AuthBasicAuthModel(
          username: 'testuser',
          password: 'testpass',
        );
        const authModel = AuthModel(type: APIAuthType.basic, basic: basicAuth);

        final result = await handleAuth(httpRequestModel, authModel);

        expect(result.headers, isNotEmpty);
        expect(
          result.headers?.any((h) => h.name.toLowerCase() == 'authorization'),
          isTrue,
        );
        expect(result.url, equals('https://api.apidash.dev/users'));
      },
    );

    test(
      'given handleAuth when handle bearer authentication fields are provided then it should add an authorization header',
      () async {
        const httpRequestModel = HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/users',
        );

        const bearerAuth = AuthBearerModel(token: 'bearer-token-123');
        const authModel = AuthModel(
          type: APIAuthType.bearer,
          bearer: bearerAuth,
        );

        final result = await handleAuth(httpRequestModel, authModel);

        expect(result.headers, isNotEmpty);
        expect(
          result.headers?.any((h) => h.name.toLowerCase() == 'authorization'),
          isTrue,
        );
        expect(result.url, equals('https://api.apidash.dev/users'));
      },
    );

    test(
      'given handleAuth when API key authentication fields are provided then it should add an authorization header',
      () async {
        const httpRequestModel = HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/users',
        );

        const apiKeyAuth = AuthApiKeyModel(
          key: 'api-key-123',
          location: 'header',
          name: 'X-API-Key',
        );
        const authModel = AuthModel(
          type: APIAuthType.apiKey,
          apikey: apiKeyAuth,
        );

        final result = await handleAuth(httpRequestModel, authModel);

        expect(result.headers, isNotEmpty);
        expect(
          result.headers?.any((h) => h.name.toLowerCase() == 'x-api-key'),
          isTrue,
        );
        expect(result.url, equals('https://api.apidash.dev/users'));
      },
    );

    test(
      'given handleAuth when API key authentication fields are provided then it should add an authorization query',
      () async {
        const httpRequestModel = HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/users',
        );

        const apiKeyAuth = AuthApiKeyModel(
          key: 'api-key-123',
          location: 'query',
          name: 'apikey',
        );
        const authModel = AuthModel(
          type: APIAuthType.apiKey,
          apikey: apiKeyAuth,
        );

        final result = await handleAuth(httpRequestModel, authModel);

        expect(result.params, isNotEmpty);
        expect(result.params?.any((p) => p.name == 'apikey'), isTrue);
        expect(result.url, equals('https://api.apidash.dev/users'));
      },
    );

    test(
      'given handleAuth when JWT authentication fields are provided then it should add an authorization header',
      () async {
        const httpRequestModel = HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/users',
        );

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

        final result = await handleAuth(httpRequestModel, authModel);

        expect(result.headers, isNotEmpty);
        expect(
          result.headers?.any((h) => h.name.toLowerCase() == 'authorization'),
          isTrue,
        );
        expect(result.url, equals('https://api.apidash.dev/users'));
      },
    );

    test(
      'given handleAuth when digest authentication fields are provided then it should add an authorization header',
      () async {
        const httpRequestModel = HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/users',
        );

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

        final result = await handleAuth(httpRequestModel, authModel);

        expect(result.headers, isNotEmpty);
        expect(
          result.headers?.any((h) => h.name.toLowerCase() == 'authorization'),
          isTrue,
        );
        expect(result.url, equals('https://api.apidash.dev/users'));
      },
    );

    test(
      'given handleAuth when multiple headers are provided then it should add an authorization header to the existing headers',
      () async {
        const httpRequestModel = HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/users',
          headers: [
            NameValueModel(name: 'Content-Type', value: 'application/json'),
            NameValueModel(name: 'Accept', value: 'application/json'),
          ],
        );

        const bearerAuth = AuthBearerModel(token: 'bearer-token-123');
        const authModel = AuthModel(
          type: APIAuthType.bearer,
          bearer: bearerAuth,
        );

        final result = await handleAuth(httpRequestModel, authModel);

        expect(result.headers, isNotEmpty);
        expect(result.headers?.any((h) => h.name == 'Content-Type'), isTrue);
        expect(result.headers?.any((h) => h.name == 'Accept'), isTrue);
        expect(
          result.headers?.any((h) => h.name.toLowerCase() == 'authorization'),
          isTrue,
        );
        expect(result.url, equals('https://api.apidash.dev/users'));
      },
    );

    test(
      'given handleAuth when multiple params are provided then it should add it to the existing params',
      () async {
        const httpRequestModel = HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/users',
          params: [
            NameValueModel(name: 'limit', value: '10'),
            NameValueModel(name: 'offset', value: '0'),
          ],
        );

        const apiKeyAuth = AuthApiKeyModel(
          key: 'api-key-123',
          location: 'query',
          name: 'apikey',
        );
        const authModel = AuthModel(
          type: APIAuthType.apiKey,
          apikey: apiKeyAuth,
        );

        final result = await handleAuth(httpRequestModel, authModel);

        expect(result.params, isNotEmpty);
        expect(result.params?.any((p) => p.name == 'limit'), isTrue);
        expect(result.params?.any((p) => p.name == 'offset'), isTrue);
        expect(result.params?.any((p) => p.name == 'apikey'), isTrue);
        expect(result.url, equals('https://api.apidash.dev/users'));
      },
    );

    test(
      'given handleAuth when special characters are provided it should not throw an error',
      () async {
        const httpRequestModel = HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/users',
        );

        const basicAuth = AuthBasicAuthModel(
          username: 'user@domain.com',
          password: r'P@ssw0rd!@#$%^&*()',
        );
        const authModel = AuthModel(type: APIAuthType.basic, basic: basicAuth);

        final result = await handleAuth(httpRequestModel, authModel);

        expect(result.headers, isNotEmpty);
        expect(
          result.headers?.any((h) => h.name.toLowerCase() == 'authorization'),
          isTrue,
        );
        expect(result.url, equals('https://api.apidash.dev/users'));
      },
    );

    test(
      'given handleAuth when no values are provided it should not throw an error',
      () async {
        const httpRequestModel = HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.apidash.dev/users',
        );

        const basicAuth = AuthBasicAuthModel(username: '', password: '');
        const authModel = AuthModel(type: APIAuthType.basic, basic: basicAuth);

        final result = await handleAuth(httpRequestModel, authModel);

        expect(result.headers, isNotEmpty);
        expect(
          result.headers?.any((h) => h.name.toLowerCase() == 'authorization'),
          isTrue,
        );
        expect(result.url, equals('https://api.apidash.dev/users'));
      },
    );
  });
}
