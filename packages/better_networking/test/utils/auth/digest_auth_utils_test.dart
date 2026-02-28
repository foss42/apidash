import 'package:better_networking/utils/auth/digest_auth_utils.dart';
import 'package:better_networking/better_networking.dart';
import 'package:test/test.dart';

void main() {
  group('Digest Auth Utils Tests', () {
    group('splitAuthenticateHeader', () {
      test('should parse valid Digest header correctly', () {
        const header =
            'Digest realm="test", nonce="123", algorithm=MD5, qop="auth"';
        final result = splitAuthenticateHeader(header);

        expect(result, isNotNull);
        expect(result!['realm'], equals('test'));
        expect(result['nonce'], equals('123'));
        expect(result['algorithm'], equals('MD5'));
        expect(result['qop'], equals('auth'));
      });

      test('should return null for non-Digest header', () {
        const header = 'Basic realm="test"';
        final result = splitAuthenticateHeader(header);

        expect(result, isNull);
      });

      test('should return null for empty header', () {
        const header = '';
        final result = splitAuthenticateHeader(header);

        expect(result, isNull);
      });

      test('should return null for header without Digest prefix', () {
        const header = 'realm="test", nonce="123"';
        final result = splitAuthenticateHeader(header);

        expect(result, isNull);
      });

      test('should handle header with quotes around values', () {
        const header =
            'Digest realm="my realm", nonce="abc123", opaque="xyz789"';
        final result = splitAuthenticateHeader(header);

        expect(result, isNotNull);
        expect(result!['realm'], equals('my realm'));
        expect(result['nonce'], equals('abc123'));
        expect(result['opaque'], equals('xyz789'));
      });

      test('should handle header with equals in values', () {
        const header = 'Digest realm="test=value", nonce="123=456"';
        final result = splitAuthenticateHeader(header);

        expect(result, isNotNull);
        expect(result!['realm'], equals('test=value'));
        expect(result['nonce'], equals('123=456'));
      });
    });

    group('Hash Functions', () {
      test('should compute SHA-256 hash correctly', () {
        const input = 'test data';
        final result = sha256Hash(input);

        expect(result, isNotEmpty);
        expect(
          result,
          hasLength(64),
        ); // SHA-256 produces 64 character hex string
        expect(
          result,
          equals(
            '916f0027a575074ce72a331777c3478d6513f786a591bd892da1a577bf2335f9',
          ),
        );
      });

      test('should compute MD5 hash correctly', () {
        const input = 'test data';
        final result = md5Hash(input);

        expect(result, isNotEmpty);
        expect(result, hasLength(32)); // MD5 produces 32 character hex string
        expect(result, equals('eb733a00c0c9d336e65691a37ab54293'));
      });

      test('should handle empty string in SHA-256', () {
        const input = '';
        final result = sha256Hash(input);

        expect(result, isNotEmpty);
        expect(
          result,
          equals(
            'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
          ),
        );
      });

      test('should handle empty string in MD5', () {
        const input = '';
        final result = md5Hash(input);

        expect(result, isNotEmpty);
        expect(result, equals('d41d8cd98f00b204e9800998ecf8427e'));
      });
    });

    group('computeResponse', () {
      test('should compute response with MD5 algorithm and auth qop', () {
        final result = computeResponse(
          'GET',
          '/api/users',
          '',
          'MD5',
          'auth',
          'opaque123',
          'test-realm',
          'cnonce123',
          'nonce123',
          1,
          'testuser',
          'testpass',
        );

        expect(result['username'], equals('testuser'));
        expect(result['realm'], equals('test-realm'));
        expect(result['nonce'], equals('nonce123'));
        expect(result['uri'], equals('/api/users'));
        expect(result['qop'], equals('auth'));
        expect(result['nc'], equals('00000001'));
        expect(result['cnonce'], equals('cnonce123'));
        expect(result['opaque'], equals('opaque123'));
        expect(result['algorithm'], equals('MD5'));
        expect(result['response'], isNotNull);
      });

      test('should compute response with MD5 algorithm and auth-int qop', () {
        final result = computeResponse(
          'POST',
          '/api/users',
          '{"name": "test"}',
          'MD5',
          'auth-int',
          null,
          'test-realm',
          'cnonce123',
          'nonce123',
          1,
          'testuser',
          'testpass',
        );

        expect(result['qop'], equals('auth-int'));
        expect(result['response'], isNotNull);
        expect(result['opaque'], isNull);
      });

      test('should compute response with MD5 algorithm and no qop', () {
        final result = computeResponse(
          'GET',
          '/api/users',
          '',
          'MD5',
          null,
          null,
          'test-realm',
          'cnonce123',
          'nonce123',
          1,
          'testuser',
          'testpass',
        );

        expect(result['qop'], isNull);
        expect(result['response'], isNotNull);
      });

      test('should compute response with SHA-256 algorithm and auth qop', () {
        final result = computeResponse(
          'GET',
          '/api/users',
          '',
          'SHA-256',
          'auth',
          null,
          'test-realm',
          'cnonce123',
          'nonce123',
          1,
          'testuser',
          'testpass',
        );

        expect(result['algorithm'], equals('SHA-256'));
        expect(result['response'], isNotNull);
      });

      test(
        'should compute response with SHA-256 algorithm and auth-int qop',
        () {
          final result = computeResponse(
            'POST',
            '/api/users',
            '{"data": "test"}',
            'SHA-256',
            'auth-int',
            null,
            'test-realm',
            'cnonce123',
            'nonce123',
            1,
            'testuser',
            'testpass',
          );

          expect(result['algorithm'], equals('SHA-256'));
          expect(result['qop'], equals('auth-int'));
          expect(result['response'], isNotNull);
        },
      );

      test('should compute response with SHA-256 algorithm and no qop', () {
        final result = computeResponse(
          'GET',
          '/api/users',
          '',
          'SHA-256',
          null,
          null,
          'test-realm',
          'cnonce123',
          'nonce123',
          1,
          'testuser',
          'testpass',
        );

        expect(result['algorithm'], equals('SHA-256'));
        expect(result['qop'], isNull);
        expect(result['response'], isNotNull);
      });

      test('should compute response with MD5-sess algorithm', () {
        final result = computeResponse(
          'GET',
          '/api/users',
          '',
          'MD5-sess',
          'auth',
          null,
          'test-realm',
          'cnonce123',
          'nonce123',
          1,
          'testuser',
          'testpass',
        );

        expect(result['algorithm'], equals('MD5-sess'));
        expect(result['response'], isNotNull);
      });

      test('should compute response with SHA-256-sess algorithm', () {
        final result = computeResponse(
          'GET',
          '/api/users',
          '',
          'SHA-256-sess',
          'auth',
          null,
          'test-realm',
          'cnonce123',
          'nonce123',
          1,
          'testuser',
          'testpass',
        );

        expect(result['algorithm'], equals('SHA-256-sess'));
        expect(result['response'], isNotNull);
      });

      test('should throw error for unsupported algorithm', () {
        expect(
          () => computeResponse(
            'GET',
            '/api/users',
            '',
            'UNSUPPORTED',
            'auth',
            null,
            'test-realm',
            'cnonce123',
            'nonce123',
            1,
            'testuser',
            'testpass',
          ),
          throwsArgumentError,
        );
      });
    });

    group('DigestAuth class', () {
      test('should create DigestAuth from model', () {
        const model = AuthDigestModel(
          username: 'testuser',
          password: 'testpass',
          realm: 'test-realm',
          nonce: 'test-nonce',
          algorithm: 'MD5',
          qop: 'auth',
          opaque: 'test-opaque',
        );

        final digestAuth = DigestAuth.fromModel(model);

        expect(digestAuth.username, equals('testuser'));
        expect(digestAuth.password, equals('testpass'));
      });

      test('should generate auth string correctly', () {
        const model = AuthDigestModel(
          username: 'testuser',
          password: 'testpass',
          realm: 'test-realm',
          nonce: 'test-nonce',
          algorithm: 'MD5',
          qop: 'auth',
          opaque: 'test-opaque',
        );

        final digestAuth = DigestAuth.fromModel(model);
        const httpRequest = HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.example.com/users',
        );

        final authString = digestAuth.getAuthString(httpRequest);

        expect(authString, startsWith('Digest '));
        expect(authString, contains('username="testuser"'));
        expect(authString, contains('realm="test-realm"'));
        expect(authString, contains('nonce="test-nonce"'));
        expect(authString, contains('uri="/users"'));
        expect(authString, contains('algorithm=MD5'));
        expect(authString, contains('qop=auth'));
        expect(authString, contains('opaque="test-opaque"'));
        expect(authString, contains('response="'));
      });

      test('should handle URL with query parameters', () {
        const model = AuthDigestModel(
          username: 'testuser',
          password: 'testpass',
          realm: 'test-realm',
          nonce: 'test-nonce',
          algorithm: 'MD5',
          qop: 'auth',
          opaque: '',
        );

        final digestAuth = DigestAuth.fromModel(model);
        const httpRequest = HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.example.com/users?limit=10&offset=0',
        );

        final authString = digestAuth.getAuthString(httpRequest);

        expect(authString, contains('uri="/users?limit=10&offset=0"'));
      });

      test('should handle empty opaque value', () {
        const model = AuthDigestModel(
          username: 'testuser',
          password: 'testpass',
          realm: 'test-realm',
          nonce: 'test-nonce',
          algorithm: 'MD5',
          qop: 'auth',
          opaque: '',
        );

        final digestAuth = DigestAuth.fromModel(model);
        const httpRequest = HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.example.com/users',
        );

        final authString = digestAuth.getAuthString(httpRequest);

        expect(authString, isNot(contains('opaque=')));
      });

      test('should increment nonce count with each call', () {
        const model = AuthDigestModel(
          username: 'testuser',
          password: 'testpass',
          realm: 'test-realm',
          nonce: 'test-nonce',
          algorithm: 'MD5',
          qop: 'auth',
          opaque: '',
        );

        final digestAuth = DigestAuth.fromModel(model);
        const httpRequest = HttpRequestModel(
          method: HTTPVerb.get,
          url: 'https://api.example.com/users',
        );

        final authString1 = digestAuth.getAuthString(httpRequest);
        final authString2 = digestAuth.getAuthString(httpRequest);

        expect(authString1, contains('nc=00000001'));
        expect(authString2, contains('nc=00000002'));
      });
    });
  });
}
