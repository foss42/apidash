import 'package:better_networking/utils/sensitive_data_redactor.dart';
import 'package:test/test.dart';

void main() {
  group('redactSensitiveValue', () {
    test('redacts values when the field name is sensitive', () {
      expect(
        redactSensitiveValue('super-secret-token', name: 'Authorization'),
        '[REDACTED]',
      );
      expect(redactSensitiveValue('abc123', name: 'x-api-key'), '[REDACTED]');
    });

    test('redacts bearer and basic credentials in free-form text', () {
      expect(
        redactSensitiveValue('Authorization: Bearer abc.def.ghi'),
        'Authorization: Bearer [REDACTED]',
      );
      expect(
        redactSensitiveValue('auth Basic dXNlcjpwYXNz'),
        'auth Basic [REDACTED]',
      );
    });

    test('redacts secret key-value pairs in free-form text', () {
      expect(
        redactSensitiveValue('url?access_token=abc123&safe=yes'),
        'url?access_token=[REDACTED]&safe=yes',
      );
    });

    test('keeps ordinary values readable', () {
      expect(redactSensitiveValue('status=ok&safe=yes'), 'status=ok&safe=yes');
    });
  });

  group('redactSensitiveUri', () {
    test('redacts sensitive OAuth callback parameters', () {
      final redacted = redactSensitiveUri(
        Uri.parse(
          'http://localhost:8080/callback?code=abc&state=visible&token=xyz',
        ),
      );

      expect(redacted, contains('code=%5BREDACTED%5D'));
      expect(redacted, contains('state=%5BREDACTED%5D'));
      expect(redacted, contains('token=%5BREDACTED%5D'));
      expect(redacted, isNot(contains('abc')));
      expect(redacted, isNot(contains('visible')));
      expect(redacted, isNot(contains('xyz')));
    });

    test('preserves URI without query parameters', () {
      const value = 'http://localhost:8080/callback';
      expect(redactSensitiveUri(Uri.parse(value)), value);
    });
  });
}
