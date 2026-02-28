import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';
import 'http_request_models.dart';

void main() {
  test('Testing copyWith', () {
    var httpRequestModel = httpRequestModelPost10;
    final httpRequestModelcopyWith =
        httpRequestModel.copyWith(url: 'https://apidash.dev');
    expect(httpRequestModelcopyWith.url, 'https://apidash.dev');
    // original model unchanged
    expect(httpRequestModel.url, 'https://api.apidash.dev/case/lower');
  });

  test('Testing toJson', () {
    var httpRequestModel = httpRequestModelPost10;
    expect(httpRequestModel.toJson(), httpRequestModelPost10Json);
  });

  test('Testing fromJson', () {
    var httpRequestModel = httpRequestModelPost10;
    final modelFromJson = HttpRequestModel.fromJson(httpRequestModelPost10Json);
    expect(modelFromJson, httpRequestModel);
    expect(modelFromJson.params, const [
      NameValueModel(name: 'size', value: '2'),
      NameValueModel(name: 'len', value: '3'),
    ]);
  });

  test('Testing getters', () {
    var httpRequestModel = httpRequestModelPost10;
    expect(httpRequestModel.headersMap, {
      'User-Agent': 'Test Agent',
      'Content-Type': 'application/json; charset=utf-8'
    });
    expect(httpRequestModel.paramsMap, {'size': '2', 'len': '3'});
    expect(httpRequestModel.enabledHeaders, const [
      NameValueModel(
          name: 'Content-Type', value: 'application/json; charset=utf-8')
    ]);
    expect(httpRequestModel.enabledParams, const [
      NameValueModel(name: 'size', value: '2'),
      NameValueModel(name: 'len', value: '3'),
    ]);
    expect(httpRequestModel.enabledHeadersMap,
        {'Content-Type': 'application/json; charset=utf-8'});
    expect(httpRequestModel.enabledParamsMap, {'size': '2', 'len': '3'});
    expect(httpRequestModel.hasContentTypeHeader, true);

    expect(httpRequestModel.hasFormDataContentType, false);
    expect(httpRequestModel.hasUrlencodedContentType, false);
    expect(httpRequestModel.hasJsonContentType, true);
    expect(httpRequestModel.hasTextContentType, false);
    expect(httpRequestModel.hasFormData, false);

    expect(httpRequestModel.hasJsonData, true);
    expect(httpRequestModel.hasTextData, false);
    expect(httpRequestModel.hasFormData, false);

    httpRequestModel =
        httpRequestModel.copyWith(bodyContentType: ContentType.formdata);
    expect(httpRequestModel.hasFormData, true);
    expect(httpRequestModel.formDataList, const [
      FormDataModel(name: "token", value: "xyz", type: FormDataType.text),
      FormDataModel(
          name: "imfile",
          value: "/Documents/up/1.png",
          type: FormDataType.file),
    ]);
    expect(httpRequestModel.formDataMapList, [
      {'name': 'token', 'value': 'xyz', 'type': 'text'},
      {'name': 'imfile', 'value': '/Documents/up/1.png', 'type': 'file'}
    ]);
    expect(httpRequestModel.hasFileInFormData, true);

    httpRequestModel =
        httpRequestModel.copyWith(bodyContentType: ContentType.urlencoded);
    expect(httpRequestModel.hasFormDataContentType, false);
    expect(httpRequestModel.hasUrlencodedContentType, true);
    expect(httpRequestModel.hasFormData, true);
  });

  test('Testing immutability', () {
    var httpRequestModel = httpRequestModelPost10;
    var httpRequestModel2 =
        httpRequestModel.copyWith(headers: httpRequestModel.headers);
    expect(httpRequestModel.headers, httpRequestModel2.headers);
    expect(
        identical(httpRequestModel.headers, httpRequestModel2.headers), false);
    var httpRequestModel3 = httpRequestModel.copyWith(headers: null);
    expect(httpRequestModel3.headers, null);
  });

  group('HttpRequestModel Auth Tests', () {
    test('should create HttpRequestModel with no authentication', () {
      const httpRequestModel = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.apidash.dev/users',
      );

      expect(httpRequestModel.authModel?.type, APIAuthType.none);
    });

    test('should create HttpRequestModel with basic authentication', () {
      const basicAuth = AuthBasicAuthModel(
        username: 'testuser',
        password: 'testpass',
      );
      const authModel = AuthModel(
        type: APIAuthType.basic,
        basic: basicAuth,
      );

      const httpRequestModel = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.apidash.dev/users',
        authModel: authModel,
      );

      expect(httpRequestModel.authModel, isNotNull);
      expect(httpRequestModel.authModel?.type, APIAuthType.basic);
      expect(httpRequestModel.authModel?.basic?.username, 'testuser');
      expect(httpRequestModel.authModel?.basic?.password, 'testpass');
    });

    test('should create HttpRequestModel with bearer authentication', () {
      const bearerAuth = AuthBearerModel(token: 'bearer-token-123');
      const authModel = AuthModel(
        type: APIAuthType.bearer,
        bearer: bearerAuth,
      );

      const httpRequestModel = HttpRequestModel(
        method: HTTPVerb.post,
        url: 'https://api.apidash.dev/users',
        authModel: authModel,
      );

      expect(httpRequestModel.authModel?.type, APIAuthType.bearer);
      expect(httpRequestModel.authModel?.bearer?.token, 'bearer-token-123');
    });

    test('should create HttpRequestModel with API key authentication', () {
      const apiKeyAuth = AuthApiKeyModel(
        key: 'api-key-123',
        location: 'header',
        name: 'X-API-Key',
      );
      const authModel = AuthModel(
        type: APIAuthType.apiKey,
        apikey: apiKeyAuth,
      );

      const httpRequestModel = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.apidash.dev/users',
        authModel: authModel,
      );

      expect(httpRequestModel.authModel?.type, APIAuthType.apiKey);
      expect(httpRequestModel.authModel?.apikey?.key, 'api-key-123');
      expect(httpRequestModel.authModel?.apikey?.location, 'header');
      expect(httpRequestModel.authModel?.apikey?.name, 'X-API-Key');
    });

    test('should create HttpRequestModel with JWT authentication', () {
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

      const httpRequestModel = HttpRequestModel(
        method: HTTPVerb.patch,
        url: 'https://api.apidash.dev/users/1',
        authModel: authModel,
      );

      expect(httpRequestModel.authModel?.type, APIAuthType.jwt);
      expect(httpRequestModel.authModel?.jwt?.secret, 'jwt-secret');
      expect(httpRequestModel.authModel?.jwt?.algorithm, 'HS256');
      expect(httpRequestModel.authModel?.jwt?.isSecretBase64Encoded, false);
    });

    test('should create HttpRequestModel with digest authentication', () {
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

      const httpRequestModel = HttpRequestModel(
        method: HTTPVerb.delete,
        url: 'https://api.apidash.dev/users/1',
        authModel: authModel,
      );

      expect(httpRequestModel.authModel?.type, APIAuthType.digest);
      expect(httpRequestModel.authModel?.digest?.username, 'digestuser');
      expect(httpRequestModel.authModel?.digest?.realm, 'test-realm');
      expect(httpRequestModel.authModel?.digest?.algorithm, 'MD5');
    });

    test(
        'should serialize and deserialize HttpRequestModel with auth correctly',
        () {
      const basicAuth = AuthBasicAuthModel(
        username: 'testuser',
        password: 'testpass',
      );
      const authModel = AuthModel(
        type: APIAuthType.basic,
        basic: basicAuth,
      );

      const originalModel = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.apidash.dev/users',
        authModel: authModel,
      );

      final json = originalModel.toJson();
      final deserializedModel = HttpRequestModel.fromJson(json);

      expect(deserializedModel.method, originalModel.method);
      expect(deserializedModel.url, originalModel.url);
      expect(deserializedModel.authModel?.type, originalModel.authModel?.type);
      expect(deserializedModel.authModel?.basic?.username,
          originalModel.authModel?.basic?.username);
      expect(deserializedModel.authModel?.basic?.password,
          originalModel.authModel?.basic?.password);
    });

    test('should handle copyWith for HttpRequestModel with auth', () {
      const originalAuth = AuthBasicAuthModel(
        username: 'testuser',
        password: 'testpass',
      );
      const originalAuthModel = AuthModel(
        type: APIAuthType.basic,
        basic: originalAuth,
      );

      const originalModel = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.apidash.dev/users',
        authModel: originalAuthModel,
      );

      const newAuth = AuthBearerModel(token: 'new-bearer-token');
      const newAuthModel = AuthModel(
        type: APIAuthType.bearer,
        bearer: newAuth,
      );

      final copiedModel = originalModel.copyWith(
        authModel: newAuthModel,
      );

      expect(copiedModel.method, originalModel.method);
      expect(copiedModel.url, originalModel.url);
      expect(copiedModel.authModel?.type, APIAuthType.bearer);
      expect(copiedModel.authModel?.bearer?.token, 'new-bearer-token');
    });

    test('should handle HttpRequestModel with complex auth scenarios', () {
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
        privateKey: 'private-key-content',
        payload: complexPayload,
        addTokenTo: 'query',
        algorithm: 'RS256',
        isSecretBase64Encoded: true,
        headerPrefix: 'JWT',
        queryParamKey: 'jwt_token',
        header: 'X-JWT-Token',
      );
      const authModel = AuthModel(
        type: APIAuthType.jwt,
        jwt: jwtAuth,
      );

      const httpRequestModel = HttpRequestModel(
        method: HTTPVerb.post,
        url: 'https://api.apidash.dev/secure-endpoint',
        authModel: authModel,
        headers: [
          NameValueModel(name: 'Content-Type', value: 'application/json'),
          NameValueModel(name: 'Accept', value: 'application/json'),
        ],
      );

      expect(httpRequestModel.authModel?.jwt?.payload, complexPayload);
      expect(
          httpRequestModel.authModel?.jwt?.privateKey, 'private-key-content');
      expect(httpRequestModel.authModel?.jwt?.algorithm, 'RS256');
      expect(httpRequestModel.authModel?.jwt?.isSecretBase64Encoded, true);
      expect(httpRequestModel.authModel?.jwt?.addTokenTo, 'query');
    });

    test('should handle HttpRequestModel with auth and other fields', () {
      const apiKeyAuth = AuthApiKeyModel(
        key: 'api-key-123',
        location: 'header',
        name: 'X-API-Key',
      );
      const authModel = AuthModel(
        type: APIAuthType.apiKey,
        apikey: apiKeyAuth,
      );

      const httpRequestModel = HttpRequestModel(
        method: HTTPVerb.post,
        url: 'https://api.apidash.dev/users',
        authModel: authModel,
        headers: [
          NameValueModel(name: 'Content-Type', value: 'application/json'),
          NameValueModel(name: 'Accept', value: 'application/json'),
        ],
        params: [
          NameValueModel(name: 'limit', value: '10'),
          NameValueModel(name: 'offset', value: '0'),
        ],
        body: '{"name": "John Doe", "email": "john@example.com"}',
        bodyContentType: ContentType.json,
      );

      expect(httpRequestModel.authModel?.type, APIAuthType.apiKey);
      expect(httpRequestModel.authModel?.apikey?.key, 'api-key-123');
      expect(httpRequestModel.headers?.length, 2);
      expect(httpRequestModel.params?.length, 2);
      expect(httpRequestModel.body,
          '{"name": "John Doe", "email": "john@example.com"}');
      expect(httpRequestModel.bodyContentType, ContentType.json);
    });

    test('should handle HttpRequestModel with multiple auth types in sequence',
        () {
      const originalAuth = AuthBasicAuthModel(
        username: 'testuser',
        password: 'testpass',
      );
      const originalAuthModel = AuthModel(
        type: APIAuthType.basic,
        basic: originalAuth,
      );

      var httpRequestModel = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.apidash.dev/users',
        authModel: originalAuthModel,
      );

      expect(httpRequestModel.authModel?.type, APIAuthType.basic);

      // Change to bearer
      const bearerAuth = AuthBearerModel(token: 'bearer-token');
      const bearerAuthModel = AuthModel(
        type: APIAuthType.bearer,
        bearer: bearerAuth,
      );

      httpRequestModel = httpRequestModel.copyWith(authModel: bearerAuthModel);
      expect(httpRequestModel.authModel?.type, APIAuthType.bearer);

      // Change to API key
      const apiKeyAuth = AuthApiKeyModel(
        key: 'api-key',
        location: 'query',
        name: 'key',
      );
      const apiKeyAuthModel = AuthModel(
        type: APIAuthType.apiKey,
        apikey: apiKeyAuth,
      );

      httpRequestModel = httpRequestModel.copyWith(authModel: apiKeyAuthModel);
      expect(httpRequestModel.authModel?.type, APIAuthType.apiKey);
      expect(httpRequestModel.authModel?.apikey?.location, 'query');
      expect(httpRequestModel.authModel?.apikey?.name, 'key');
    });
  });
}
