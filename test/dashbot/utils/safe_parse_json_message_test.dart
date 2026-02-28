import 'package:apidash/dashbot/utils/utils.dart';
import 'package:test/test.dart';

void main() {
  group('MessageJson.safeParse', () {
    test('parses valid JSON object', () {
      final m = MessageJson.safeParse('{"a":1,"b":"x"}');
      expect(m, containsPair('a', 1));
      expect(m['b'], 'x');
    });

    test('returns empty map for non-object top-level JSON', () {
      final m = MessageJson.safeParse('[1,2,3]');
      expect(m, isEmpty);
    });

    test('extracts object from markdown fenced code block', () {
      const input =
          '''Here is your result:\n```json\n{\n  "ok": true,\n  "count": 2\n}\n```\nThanks''';
      final m = MessageJson.safeParse(input);
      expect(m['ok'], true);
      expect(m['count'], 2);
    });

    test('throws FormatException on invalid JSON with no braces slice', () {
      expect(() => MessageJson.safeParse('totally invalid'),
          throwsFormatException);
    });

    test('falls back to slice between first { and last }', () {
      const input = 'prefix {"z":42, "k":"v"} suffix';
      final m = MessageJson.safeParse(input);
      expect(m['z'], 42);
      expect(m['k'], 'v');
    });
  });
}
