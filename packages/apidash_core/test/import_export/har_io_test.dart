import 'package:test/test.dart';
import 'package:apidash_core/apidash_core.dart';

void main() {
  group('HarParserIO parseFormData', () {
    late HarParserIO harParser;

    setUp(() {
      harParser = HarParserIO();
    });

    test('parses a simple key-value pair', () {
      expect(harParser.parseFormData('name=apidash'), {'name': 'apidash'});
    });

    test('keeps values containing a trailing = (base64)', () {
      expect(
        harParser.parseFormData('token=YWJjZA=='),
        {'token': 'YWJjZA=='},
      );
    });

    test('keeps values containing = in the middle', () {
      expect(
        harParser.parseFormData('filter=a=b'),
        {'filter': 'a=b'},
      );
    });

    test('preserves all pairs when a value contains =', () {
      expect(
        harParser.parseFormData('user=deepak&token=abc==&role=admin'),
        {'user': 'deepak', 'token': 'abc==', 'role': 'admin'},
      );
    });

    test('decodes percent-encoded keys and values', () {
      expect(
        harParser.parseFormData('full%20name=John%20Doe'),
        {'full name': 'John Doe'},
      );
    });

    test('handles an empty value', () {
      expect(harParser.parseFormData('key='), {'key': ''});
    });

    test('returns an empty map for null or empty input', () {
      expect(harParser.parseFormData(null), {});
      expect(harParser.parseFormData(''), {});
    });
  });
}
