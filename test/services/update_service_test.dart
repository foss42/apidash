import 'package:apidash/services/update_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('normalizeVersion', () {
    test('strips a leading v', () {
      expect(normalizeVersion('v0.5.0'), '0.5.0');
    });
    test('trims surrounding whitespace', () {
      expect(normalizeVersion('  1.2.3 '), '1.2.3');
    });
    test('leaves a plain version untouched', () {
      expect(normalizeVersion('1.2.3'), '1.2.3');
    });
  });

  group('isUpdateAvailable', () {
    test('true when latest is newer', () {
      expect(isUpdateAvailable('0.5.0', '0.5.1'), isTrue);
      expect(isUpdateAvailable('0.5.0', '1.0.0'), isTrue);
    });
    test('false when versions are equal', () {
      expect(isUpdateAvailable('0.5.0', '0.5.0'), isFalse);
    });
    test('false when latest is older', () {
      expect(isUpdateAvailable('0.6.0', '0.5.9'), isFalse);
    });
    test('tolerates a leading v on either side', () {
      expect(isUpdateAvailable('v0.5.0', 'v0.5.1'), isTrue);
      expect(isUpdateAvailable('0.5.0', 'v0.5.0'), isFalse);
    });
    test('false for unparseable input', () {
      expect(isUpdateAvailable('not-a-version', '0.5.1'), isFalse);
      expect(isUpdateAvailable('0.5.0', 'garbage'), isFalse);
    });
  });
}
