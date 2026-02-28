import 'package:better_networking/models/auth/auth_oauth1_model.dart';
import 'package:better_networking/consts.dart';
import 'package:test/test.dart';
import 'auth_models.dart';

void main() {
  group('Testing AuthOAuth1Model', () {
    test("Testing AuthOAuth1Model copyWith", () {
      var authOAuth1Model = authOAuth1Model1;
      final authOAuth1ModelCopyWith = authOAuth1Model.copyWith(
        consumerKey: 'new_consumer_key',
        signatureMethod: OAuth1SignatureMethod.plaintext,
        parameterLocation: 'query',
        includeBodyHash: true,
      );
      expect(authOAuth1ModelCopyWith.consumerKey, 'new_consumer_key');
      expect(
        authOAuth1ModelCopyWith.signatureMethod,
        OAuth1SignatureMethod.plaintext,
      );
      expect(authOAuth1ModelCopyWith.parameterLocation, 'query');
      expect(authOAuth1ModelCopyWith.includeBodyHash, true);
      // original model unchanged
      expect(authOAuth1Model.consumerKey, 'oauth1-consumer-key-123');
      expect(authOAuth1Model.signatureMethod, OAuth1SignatureMethod.hmacSha1);
      expect(authOAuth1Model.parameterLocation, 'header');
      expect(authOAuth1Model.includeBodyHash, false);
    });

    test("Testing AuthOAuth1Model toJson", () {
      var authOAuth1Model = authOAuth1Model1;
      expect(authOAuth1Model.toJson(), authOAuth1ModelJson1);
    });

    test("Testing AuthOAuth1Model fromJson", () {
      var authOAuth1Model = authOAuth1Model1;
      final modelFromJson = AuthOAuth1Model.fromJson(authOAuth1ModelJson1);
      expect(modelFromJson, authOAuth1Model);
      expect(modelFromJson.consumerKey, 'oauth1-consumer-key-123');
      expect(modelFromJson.consumerSecret, 'oauth1-consumer-secret-456');
      expect(
        modelFromJson.credentialsFilePath,
        '/path/to/oauth1/credentials.json',
      );
      expect(modelFromJson.accessToken, 'oauth1-access-token-789');
      expect(modelFromJson.tokenSecret, 'oauth1-token-secret-012');
      expect(modelFromJson.signatureMethod, OAuth1SignatureMethod.hmacSha1);
    });

    test("Testing AuthOAuth1Model getters", () {
      var authOAuth1Model = authOAuth1Model1;
      expect(authOAuth1Model.consumerKey, 'oauth1-consumer-key-123');
      expect(authOAuth1Model.consumerSecret, 'oauth1-consumer-secret-456');
      expect(
        authOAuth1Model.credentialsFilePath,
        '/path/to/oauth1/credentials.json',
      );
      expect(authOAuth1Model.accessToken, 'oauth1-access-token-789');
      expect(authOAuth1Model.tokenSecret, 'oauth1-token-secret-012');
      expect(authOAuth1Model.signatureMethod, OAuth1SignatureMethod.hmacSha1);
      expect(authOAuth1Model.parameterLocation, 'header');
      expect(authOAuth1Model.version, '1.0');
      expect(authOAuth1Model.realm, 'oauth1-realm');
      expect(authOAuth1Model.callbackUrl, 'https://example.com/callback');
      expect(authOAuth1Model.verifier, 'oauth1-verifier-345');
      expect(authOAuth1Model.nonce, 'oauth1-nonce-678');
      expect(authOAuth1Model.timestamp, '1640995200');
      expect(authOAuth1Model.includeBodyHash, false);
    });

    test("Testing AuthOAuth1Model equality", () {
      const authOAuth1Model1Copy = AuthOAuth1Model(
        consumerKey: 'oauth1-consumer-key-123',
        consumerSecret: 'oauth1-consumer-secret-456',
        credentialsFilePath: '/path/to/oauth1/credentials.json',
        accessToken: 'oauth1-access-token-789',
        tokenSecret: 'oauth1-token-secret-012',
        signatureMethod: OAuth1SignatureMethod.hmacSha1,
        parameterLocation: 'header',
        version: '1.0',
        realm: 'oauth1-realm',
        callbackUrl: 'https://example.com/callback',
        verifier: 'oauth1-verifier-345',
        nonce: 'oauth1-nonce-678',
        timestamp: '1640995200',
        includeBodyHash: false,
      );
      expect(authOAuth1Model1, authOAuth1Model1Copy);
      expect(authOAuth1Model1, isNot(authOAuth1Model2));
    });

    test("Testing AuthOAuth1Model with different values", () {
      expect(authOAuth1Model2.consumerKey, 'different-consumer-key');
      expect(authOAuth1Model2.consumerSecret, 'different-consumer-secret');
      expect(
        authOAuth1Model2.credentialsFilePath,
        '/different/path/credentials.json',
      );
      expect(authOAuth1Model2.signatureMethod, OAuth1SignatureMethod.plaintext);
      expect(authOAuth1Model2.parameterLocation, 'query');
      expect(authOAuth1Model2.version, '1.0a');
      expect(authOAuth1Model2.includeBodyHash, true);
      expect(authOAuth1Model1.consumerKey, isNot(authOAuth1Model2.consumerKey));
      expect(
        authOAuth1Model1.signatureMethod,
        isNot(authOAuth1Model2.signatureMethod),
      );
    });

    test("Testing AuthOAuth1Model with default values", () {
      const authOAuth1ModelDefaults = AuthOAuth1Model(
        consumerKey: 'test-consumer-key',
        consumerSecret: 'test-consumer-secret',
        credentialsFilePath: '/test/credentials.json',
      );

      expect(authOAuth1ModelDefaults.consumerKey, 'test-consumer-key');
      expect(authOAuth1ModelDefaults.consumerSecret, 'test-consumer-secret');
      expect(
        authOAuth1ModelDefaults.credentialsFilePath,
        '/test/credentials.json',
      );
      expect(
        authOAuth1ModelDefaults.signatureMethod,
        OAuth1SignatureMethod.hmacSha1,
      );
      expect(authOAuth1ModelDefaults.parameterLocation, 'header');
      expect(authOAuth1ModelDefaults.version, '1.0');
      expect(authOAuth1ModelDefaults.includeBodyHash, false);
      expect(authOAuth1ModelDefaults.accessToken, isNull);
      expect(authOAuth1ModelDefaults.tokenSecret, isNull);
      expect(authOAuth1ModelDefaults.realm, isNull);
      expect(authOAuth1ModelDefaults.callbackUrl, isNull);
      expect(authOAuth1ModelDefaults.verifier, isNull);
      expect(authOAuth1ModelDefaults.nonce, isNull);
      expect(authOAuth1ModelDefaults.timestamp, isNull);
    });

    test("Testing AuthOAuth1Model with all signature methods", () {
      const authOAuth1ModelHmacSha1 = AuthOAuth1Model(
        consumerKey: 'test-key',
        consumerSecret: 'test-secret',
        credentialsFilePath: '/test/credentials.json',
        signatureMethod: OAuth1SignatureMethod.hmacSha1,
      );

      const authOAuth1ModelPlaintext = AuthOAuth1Model(
        consumerKey: 'test-key',
        consumerSecret: 'test-secret',
        credentialsFilePath: '/test/credentials.json',
        signatureMethod: OAuth1SignatureMethod.plaintext,
      );

      expect(
        authOAuth1ModelHmacSha1.signatureMethod,
        OAuth1SignatureMethod.hmacSha1,
      );
      expect(
        authOAuth1ModelPlaintext.signatureMethod,
        OAuth1SignatureMethod.plaintext,
      );
      expect(authOAuth1ModelHmacSha1.signatureMethod.displayType, 'HMAC-SHA1');
      expect(authOAuth1ModelPlaintext.signatureMethod.displayType, 'Plaintext');
    });

    test("Testing AuthOAuth1Model parameter locations", () {
      const authOAuth1ModelHeader = AuthOAuth1Model(
        consumerKey: 'test-key',
        consumerSecret: 'test-secret',
        credentialsFilePath: '/test/credentials.json',
        parameterLocation: 'header',
      );

      const authOAuth1ModelQuery = AuthOAuth1Model(
        consumerKey: 'test-key',
        consumerSecret: 'test-secret',
        credentialsFilePath: '/test/credentials.json',
        parameterLocation: 'query',
      );

      expect(authOAuth1ModelHeader.parameterLocation, 'header');
      expect(authOAuth1ModelQuery.parameterLocation, 'query');
    });

    test("Testing AuthOAuth1Model with optional tokens", () {
      const authOAuth1ModelWithTokens = AuthOAuth1Model(
        consumerKey: 'test-key',
        consumerSecret: 'test-secret',
        credentialsFilePath: '/test/credentials.json',
        accessToken: 'test-access-token',
        tokenSecret: 'test-token-secret',
      );

      const authOAuth1ModelWithoutTokens = AuthOAuth1Model(
        consumerKey: 'test-key',
        consumerSecret: 'test-secret',
        credentialsFilePath: '/test/credentials.json',
      );

      expect(authOAuth1ModelWithTokens.accessToken, 'test-access-token');
      expect(authOAuth1ModelWithTokens.tokenSecret, 'test-token-secret');
      expect(authOAuth1ModelWithoutTokens.accessToken, isNull);
      expect(authOAuth1ModelWithoutTokens.tokenSecret, isNull);
    });

    test("Testing AuthOAuth1Model with body hash options", () {
      const authOAuth1ModelWithBodyHash = AuthOAuth1Model(
        consumerKey: 'test-key',
        consumerSecret: 'test-secret',
        credentialsFilePath: '/test/credentials.json',
        includeBodyHash: true,
      );

      const authOAuth1ModelWithoutBodyHash = AuthOAuth1Model(
        consumerKey: 'test-key',
        consumerSecret: 'test-secret',
        credentialsFilePath: '/test/credentials.json',
        includeBodyHash: false,
      );

      expect(authOAuth1ModelWithBodyHash.includeBodyHash, true);
      expect(authOAuth1ModelWithoutBodyHash.includeBodyHash, false);
    });
  });
}
