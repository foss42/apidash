import 'package:better_networking/utils/string_utils.dart';
import 'package:test/test.dart';

void main() {
  group('RandomStringGenerator', () {
    test('getRandomString returns correct length', () {
      final result = RandomStringGenerator.getRandomString(10);
      expect(result.length, 10);
    });

    test('getRandomString returns only valid characters', () {
      final result = RandomStringGenerator.getRandomString(100);
      const _chars =
          'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
      final validChars = _chars.split('').toSet();
      final isValid = result.split('').every(validChars.contains);
      expect(isValid, true);
    });

    test('getRandomStringLines returns correct number of lines', () {
      final result = RandomStringGenerator.getRandomStringLines(5, 8);
      final lines = result.split('\n');
      expect(lines.length, 5);
      expect(lines.every((line) => line.length == 8), true);
    });

    test('getRandomStringLines returns empty string for 0 lines', () {
      final result = RandomStringGenerator.getRandomStringLines(0, 8);
      expect(result, '');
    });

    test('getRandomString returns empty string for length 0', () {
      final result = RandomStringGenerator.getRandomString(0);
      expect(result, '');
    });
  });
}
