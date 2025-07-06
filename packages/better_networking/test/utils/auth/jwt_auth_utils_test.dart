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
  });
}
