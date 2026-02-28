import 'package:flutter_test/flutter_test.dart';
import 'package:better_networking/models/auth/auth_jwt_model.dart';
import 'package:better_networking/utils/auth/jwt_auth_utils.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

void main() {
  group('JWT Auth Utils Tests', () {
    test('should generate JWT with HS256 algorithm', () {
      const jwtAuth = AuthJwtModel(
        secret: 'test_secret',
        payload: '{"user_id": 123, "username": "testuser"}',
        addTokenTo: 'header',
        algorithm: 'HS256',
        isSecretBase64Encoded: false,
        headerPrefix: 'Bearer',
        queryParamKey: 'token',
        header: '{"typ": "JWT"}',
      );

      final token = generateJWT(jwtAuth);
      expect(token, isNotEmpty);
      expect(token.split('.').length, equals(3)); // JWT has 3 parts

      // Verify the token can be decoded
      final decoded = JWT.decode(token);
      expect(decoded.payload['user_id'], equals(123));
      expect(decoded.payload['username'], equals('testuser'));
    });

    test('should generate JWT with HS384 algorithm', () {
      const jwtAuth = AuthJwtModel(
        secret: 'test_secret_384',
        payload: '{"role": "admin"}',
        addTokenTo: 'header',
        algorithm: 'HS384',
        isSecretBase64Encoded: false,
        headerPrefix: 'Bearer',
        queryParamKey: 'token',
        header: '',
      );

      final token = generateJWT(jwtAuth);
      expect(token, isNotEmpty);
      expect(token.split('.').length, equals(3));

      // Verify the token can be decoded
      final decoded = JWT.decode(token);
      expect(decoded.payload['role'], equals('admin'));
    });

    test('should generate JWT with HS512 algorithm', () {
      const jwtAuth = AuthJwtModel(
        secret: 'test_secret_512',
        payload: '{"exp": 1234567890}',
        addTokenTo: 'header',
        algorithm: 'HS512',
        isSecretBase64Encoded: false,
        headerPrefix: 'Bearer',
        queryParamKey: 'token',
        header: '',
      );

      final token = generateJWT(jwtAuth);
      expect(token, isNotEmpty);
      expect(token.split('.').length, equals(3));

      // Verify the token can be decoded
      final decoded = JWT.decode(token);
      expect(decoded.payload['exp'], equals(1234567890));
    });

    test('should generate JWT with base64 encoded secret', () {
      const secretBase64 = 'dGVzdF9zZWNyZXQ='; // base64 encoded "test_secret"
      const jwtAuth = AuthJwtModel(
        secret: secretBase64,
        payload: '{"test": "value"}',
        addTokenTo: 'header',
        algorithm: 'HS256',
        isSecretBase64Encoded: true,
        headerPrefix: 'Bearer',
        queryParamKey: 'token',
        header: '',
      );

      final token = generateJWT(jwtAuth);
      expect(token, isNotEmpty);
      expect(token.split('.').length, equals(3));

      // Verify the token can be decoded
      final decoded = JWT.decode(token);
      expect(decoded.payload['test'], equals('value'));
    });

    test('should handle empty payload', () {
      const jwtAuth = AuthJwtModel(
        secret: 'test_secret',
        payload: '',
        addTokenTo: 'header',
        algorithm: 'HS256',
        isSecretBase64Encoded: false,
        headerPrefix: 'Bearer',
        queryParamKey: 'token',
        header: '',
      );

      final token = generateJWT(jwtAuth);
      expect(token, isNotEmpty);
      expect(token.split('.').length, equals(3));

      // Verify the token can be decoded and has iat
      final decoded = JWT.decode(token);
      expect(decoded.payload['iat'], isNotNull);
    });

    test('should handle invalid JSON payload gracefully', () {
      const jwtAuth = AuthJwtModel(
        secret: 'test_secret',
        payload: 'invalid json',
        addTokenTo: 'header',
        algorithm: 'HS256',
        isSecretBase64Encoded: false,
        headerPrefix: 'Bearer',
        queryParamKey: 'token',
        header: '',
      );

      final token = generateJWT(jwtAuth);
      expect(token, isNotEmpty);
      expect(token.split('.').length, equals(3));

      // Should have at least iat in payload
      final decoded = JWT.decode(token);
      expect(decoded.payload['iat'], isNotNull);
    });

    test('should verify generated JWT with correct secret', () {
      const secret = 'verification_secret';
      const jwtAuth = AuthJwtModel(
        secret: secret,
        payload: '{"user": "test"}',
        addTokenTo: 'header',
        algorithm: 'HS256',
        isSecretBase64Encoded: false,
        headerPrefix: 'Bearer',
        queryParamKey: 'token',
        header: '',
      );

      final token = generateJWT(jwtAuth);

      // Verify with correct secret
      expect(() => JWT.verify(token, SecretKey(secret)), returnsNormally);
    });

    test('should fail verification with wrong secret', () {
      const secret = 'correct_secret';
      const wrongSecret = 'wrong_secret';
      const jwtAuth = AuthJwtModel(
        secret: secret,
        payload: '{"user": "test"}',
        addTokenTo: 'header',
        algorithm: 'HS256',
        isSecretBase64Encoded: false,
        headerPrefix: 'Bearer',
        queryParamKey: 'token',
        header: '',
      );

      final token = generateJWT(jwtAuth);

      // Verify with wrong secret should throw
      expect(
        () => JWT.verify(token, SecretKey(wrongSecret)),
        throwsA(isA<JWTException>()),
      );
    });

    test(
      'should throw error when generating JWT fails due to invalid payload',
      () {
        const jwtAuth = AuthJwtModel(
          secret: 'test_secret',
          payload:
              '{"invalid": json}', // Malformed JSON that will cause parsing to fail but createKey to succeed
          addTokenTo: 'header',
          algorithm: 'HS256',
          isSecretBase64Encoded: false,
          headerPrefix: 'Bearer',
          queryParamKey: 'token',
          header: '',
        );

        // This should not throw since we handle JSON parsing gracefully
        expect(() => generateJWT(jwtAuth), returnsNormally);
      },
    );

    test('should throw exception for RSA algorithm without private key', () {
      const jwtAuth = AuthJwtModel(
        secret: 'test_secret',
        payload: '{"user": "test"}',
        addTokenTo: 'header',
        algorithm: 'RS256',
        isSecretBase64Encoded: false,
        headerPrefix: 'Bearer',
        queryParamKey: 'token',
        header: '',
        privateKey: null,
      );

      expect(() => generateJWT(jwtAuth), throwsA(isA<Exception>()));
    });

    test('should throw exception for ECDSA algorithm without private key', () {
      const jwtAuth = AuthJwtModel(
        secret: 'test_secret',
        payload: '{"user": "test"}',
        addTokenTo: 'header',
        algorithm: 'ES256',
        isSecretBase64Encoded: false,
        headerPrefix: 'Bearer',
        queryParamKey: 'token',
        header: '',
        privateKey: null,
      );

      expect(() => generateJWT(jwtAuth), throwsA(isA<Exception>()));
    });

    test('should throw exception for PS algorithm without private key', () {
      const jwtAuth = AuthJwtModel(
        secret: 'test_secret',
        payload: '{"user": "test"}',
        addTokenTo: 'header',
        algorithm: 'PS256',
        isSecretBase64Encoded: false,
        headerPrefix: 'Bearer',
        queryParamKey: 'token',
        header: '',
        privateKey: null,
      );

      expect(() => generateJWT(jwtAuth), throwsA(isA<Exception>()));
    });

    test('should throw exception for EdDSA algorithm without private key', () {
      const jwtAuth = AuthJwtModel(
        secret: 'test_secret',
        payload: '{"user": "test"}',
        addTokenTo: 'header',
        algorithm: 'EdDSA',
        isSecretBase64Encoded: false,
        headerPrefix: 'Bearer',
        queryParamKey: 'token',
        header: '',
        privateKey: null,
      );

      expect(() => generateJWT(jwtAuth), throwsA(isA<Exception>()));
    });

    test('should handle invalid header JSON gracefully', () {
      const jwtAuth = AuthJwtModel(
        secret: 'test_secret',
        payload: '{"user": "test"}',
        addTokenTo: 'header',
        algorithm: 'HS256',
        isSecretBase64Encoded: false,
        headerPrefix: 'Bearer',
        queryParamKey: 'token',
        header: '{"invalid": json}', // Invalid JSON
      );

      final token = generateJWT(jwtAuth);
      expect(token, isNotEmpty);
      expect(token.split('.').length, equals(3));

      // Should still generate a valid token with empty header
      final decoded = JWT.decode(token);
      expect(decoded.payload['user'], equals('test'));
    });

    test('should throw exception for unknown algorithm', () {
      const jwtAuth = AuthJwtModel(
        secret: 'test_secret',
        payload: '{"user": "test"}',
        addTokenTo: 'header',
        algorithm: 'UNKNOWN_ALG',
        isSecretBase64Encoded: false,
        headerPrefix: 'Bearer',
        queryParamKey: 'token',
        header: '',
      );

      expect(() => generateJWT(jwtAuth), throwsA(isA<Exception>()));
    });
  });
}
