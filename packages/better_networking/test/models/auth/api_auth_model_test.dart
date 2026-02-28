import 'package:better_networking/models/auth/api_auth_model.dart';
import 'package:better_networking/models/auth/auth_basic_model.dart';
import 'package:better_networking/models/auth/auth_bearer_model.dart';
import 'package:better_networking/consts.dart';
import 'package:test/test.dart';
import 'auth_models.dart';

void main() {
  group('Testing AuthModel (API Auth Model)', () {
    test("Testing AuthModel copyWith", () {
      var authModel = authModel1;
      final authModelCopyWith = authModel.copyWith(
        type: APIAuthType.bearer,
        bearer: const AuthBearerModel(token: 'new-bearer-token'),
        basic: null,
      );
      expect(authModelCopyWith.type, APIAuthType.bearer);
      expect(authModelCopyWith.bearer?.token, 'new-bearer-token');
      expect(authModelCopyWith.basic, null);
      // original model unchanged
      expect(authModel.type, APIAuthType.basic);
      expect(authModel.basic?.username, 'john_doe');
    });

    test("Testing AuthModel toJson", () {
      var authModel = authModel1;
      expect(authModel.toJson(), authModelJson1);
    });

    test("Testing AuthModel fromJson for basic authentication", () {
      var authModel = authModel1;
      final modelFromJson = AuthModel.fromJson(authModelJson1);
      expect(modelFromJson, authModel);
      expect(modelFromJson.type, APIAuthType.basic);
      expect(modelFromJson.basic?.username, 'john_doe');
      expect(modelFromJson.basic?.password, 'secure_password');
    });

    test("Testing AuthModel fromJson for bearer authentication", () {
      var authModel = authModel2;
      final modelFromJson = AuthModel.fromJson(authModelJson2);
      expect(modelFromJson, authModel);
      expect(modelFromJson.type, APIAuthType.bearer);
      expect(
        modelFromJson.bearer?.token,
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c',
      );
    });

    test("Testing AuthModel fromJson for api key authentication", () {
      var authModel = authModel3;
      final apiKeyModelJson = {
        "type": "apiKey",
        "apikey": authApiKeyModelJson1,
        "bearer": null,
        "basic": null,
        "jwt": null,
        "digest": null,
      };
      final modelFromJson = AuthModel.fromJson(apiKeyModelJson);
      expect(modelFromJson, authModel);
      expect(modelFromJson.type, APIAuthType.apiKey);
      expect(modelFromJson.apikey?.key, 'ak-test-key-12345');
      expect(modelFromJson.apikey?.location, 'header');
      expect(modelFromJson.apikey?.name, 'x-api-key');
    });

    test("Testing AuthModel fromJson for jwt authentication", () {
      var authModel = authModel4;
      final jwtModelJson = {
        "type": "jwt",
        "apikey": null,
        "bearer": null,
        "basic": null,
        "jwt": authJwtModelJson1,
        "digest": null,
      };
      final modelFromJson = AuthModel.fromJson(jwtModelJson);
      expect(modelFromJson, authModel);
      expect(modelFromJson.type, APIAuthType.jwt);
      expect(modelFromJson.jwt?.secret, 'jwt-secret-key');
      expect(modelFromJson.jwt?.algorithm, 'RS256');
      expect(modelFromJson.jwt?.isSecretBase64Encoded, true);
      expect(modelFromJson.jwt?.headerPrefix, 'JWT');
    });

    test("Testing AuthModel fromJson for digest authentication", () {
      var authModel = authModel5;
      final digestModelJson = {
        "type": "digest",
        "apikey": null,
        "bearer": null,
        "basic": null,
        "jwt": null,
        "digest": authDigestModelJson1,
      };
      final modelFromJson = AuthModel.fromJson(digestModelJson);
      expect(modelFromJson, authModel);
      expect(modelFromJson.type, APIAuthType.digest);
      expect(modelFromJson.digest?.algorithm, 'SHA-256');
      expect(modelFromJson.digest?.username, 'digest_user');
      expect(modelFromJson.digest?.password, 'digest_pass');
      expect(modelFromJson.digest?.realm, 'protected-area');
      expect(modelFromJson.digest?.qop, 'auth-int');
    });

    test("Testing AuthModel getters for different auth types", () {
      expect(authModelNone.type, APIAuthType.none);
      expect(authModel1.type, APIAuthType.basic);
      expect(authModel2.type, APIAuthType.bearer);
      expect(authModel3.type, APIAuthType.apiKey);
      expect(authModel4.type, APIAuthType.jwt);
      expect(authModel5.type, APIAuthType.digest);
    });

    test("Testing AuthModel with basic authentication", () {
      var authModel = authModel1;
      expect(authModel.type, APIAuthType.basic);
      expect(authModel.basic, isNotNull);
      expect(authModel.basic?.username, 'john_doe');
      expect(authModel.basic?.password, 'secure_password');
      expect(authModel.bearer, null);
      expect(authModel.apikey, null);
      expect(authModel.jwt, null);
      expect(authModel.digest, null);
    });

    test("Testing AuthModel with bearer authentication", () {
      var authModel = authModel2;
      expect(authModel.type, APIAuthType.bearer);
      expect(authModel.bearer, isNotNull);
      expect(
        authModel.bearer?.token,
        startsWith('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'),
      );
      expect(authModel.basic, null);
      expect(authModel.apikey, null);
      expect(authModel.jwt, null);
      expect(authModel.digest, null);
    });

    test("Testing AuthModel with API key authentication", () {
      var authModel = authModel3;
      expect(authModel.type, APIAuthType.apiKey);
      expect(authModel.apikey, isNotNull);
      expect(authModel.apikey?.key, 'ak-test-key-12345');
      expect(authModel.apikey?.location, 'header');
      expect(authModel.apikey?.name, 'x-api-key');
      expect(authModel.basic, null);
      expect(authModel.bearer, null);
      expect(authModel.jwt, null);
      expect(authModel.digest, null);
    });

    test("Testing AuthModel with JWT authentication", () {
      var authModel = authModel4;
      expect(authModel.type, APIAuthType.jwt);
      expect(authModel.jwt, isNotNull);
      expect(authModel.jwt?.secret, 'jwt-secret-key');
      expect(authModel.jwt?.algorithm, 'RS256');
      expect(authModel.jwt?.isSecretBase64Encoded, true);
      expect(authModel.basic, null);
      expect(authModel.bearer, null);
      expect(authModel.apikey, null);
      expect(authModel.digest, null);
    });

    test("Testing AuthModel with digest authentication", () {
      var authModel = authModel5;
      expect(authModel.type, APIAuthType.digest);
      expect(authModel.digest, isNotNull);
      expect(authModel.digest?.username, 'digest_user');
      expect(authModel.digest?.algorithm, 'SHA-256');
      expect(authModel.digest?.qop, 'auth-int');
      expect(authModel.basic, null);
      expect(authModel.bearer, null);
      expect(authModel.apikey, null);
      expect(authModel.jwt, null);
    });

    test("Testing AuthModel with none authentication", () {
      var authModel = authModelNone;
      expect(authModel.type, APIAuthType.none);
      expect(authModel.basic, null);
      expect(authModel.bearer, null);
      expect(authModel.apikey, null);
      expect(authModel.jwt, null);
      expect(authModel.digest, null);
    });

    test("Testing AuthModel equality", () {
      const authModel1Copy = AuthModel(
        type: APIAuthType.basic,
        basic: AuthBasicAuthModel(
          username: 'john_doe',
          password: 'secure_password',
        ),
      );
      expect(authModel1, authModel1Copy);
      expect(authModel1, isNot(authModel2));
      expect(authModelNone, const AuthModel(type: APIAuthType.none));
    });

    test("Testing AuthModel JSON serialization for different types", () {
      var bearerModel = authModel2;
      var bearerJson = bearerModel.toJson();
      expect(bearerJson['type'], 'bearer');
      expect(bearerJson['bearer'], isNotNull);
      expect(bearerJson['basic'], null);

      final modelFromJson = AuthModel.fromJson(authModelJson2);
      expect(modelFromJson, bearerModel);
    });

    test("Testing AuthModel JSON serialization for none type", () {
      var noneModel = authModelNone;
      var noneJson = noneModel.toJson();
      expect(noneJson, authModelNoneJson);

      final modelFromJson = AuthModel.fromJson(authModelNoneJson);
      expect(modelFromJson, noneModel);
      expect(modelFromJson.type, APIAuthType.none);
    });
  });
}
