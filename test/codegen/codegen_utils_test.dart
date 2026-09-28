import 'package:apidash/codegen/codegen_utils.dart';
import 'package:test/test.dart';

void main() {
  group('jsonToPyDict', () {
    test('replaces JSON literals outside strings', () {
      expect(
        jsonToPyDict('{"a": true, "b": false, "c": null, "d": [null]}'),
        '{"a": True, "b": False, "c": None, "d": [None]}',
      );
    });

    test('keeps JSON literals inside strings', () {
      expect(
        jsonToPyDict(r'{"text": "say \"true\" or null", "arr": ["false"]}'),
        r'{"text": "say \"true\" or null", "arr": ["false"]}',
      );
    });

    test('keeps escaped backslash before closing quote', () {
      expect(
        jsonToPyDict(r'{"dir": "C:\\", "ok": true}'),
        r'{"dir": "C:\\", "ok": True}',
      );
    });

    test('converts escaped forward slash', () {
      expect(jsonToPyDict(r'{"path": "a\/b"}'), '{"path": "a/b"}');
    });

    test('returns invalid JSON without crashing', () {
      expect(jsonToPyDict('{"text": "unterminated'), '{"text": "unterminated');
    });
  });

  group('pyStringLiteral', () {
    test('plain value is unchanged', () {
      expect(pyStringLiteral('abc'), "'abc'");
    });

    test('escapes quotes, backslashes and control characters', () {
      expect(
        pyStringLiteral("it's a\\b\nc\r\td\x01"),
        r"'it\'s a\\b\nc\r\td\x01'",
      );
    });

    test('escapes only the chosen quote', () {
      expect(
        pyStringLiteral('say "hi" it\'s', quote: '"'),
        r'''"say \"hi\" it's"''',
      );
    });

    test('keeps non-ASCII characters', () {
      expect(pyStringLiteral('héllo 👋'), "'héllo 👋'");
    });
  });

  group('pyMultilineStringLiteral', () {
    test('uses a raw string when possible', () {
      expect(
        pyMultilineStringLiteral('line 1\nC:\\new "x"'),
        "r'''line 1\nC:\\new \"x\"'''",
      );
    });

    test('falls back to an escaped string when needed', () {
      expect(pyMultilineStringLiteral("a ''' b"), r"'a \'\'\' b'");
      expect(pyMultilineStringLiteral("ends with '"), r"'ends with \''");
      expect(pyMultilineStringLiteral('ends with \\'), r"'ends with \\'");
      expect(pyMultilineStringLiteral('a\r\nb'), r"'a\r\nb'");
    });
  });

  group('jsStringLiteral', () {
    test('plain value is unchanged', () {
      expect(jsStringLiteral('abc'), "'abc'");
    });

    test('escapes quotes, backslashes and control characters', () {
      expect(
        jsStringLiteral("it's a\\b\nc\r\td\x01"),
        r"'it\'s a\\b\nc\r\td\x01'",
      );
    });

    test('escapes only the chosen quote', () {
      expect(
        jsStringLiteral('say "hi" it\'s', quote: '"'),
        r'''"say \"hi\" it's"''',
      );
    });

    test('leaves template literal syntax alone', () {
      expect(jsStringLiteral(r'`${x}` $y'), r"'`${x}` $y'");
    });

    test('escapes line and paragraph separators', () {
      expect(jsStringLiteral('a\u2028b\u2029c'), "'a\\u2028b\\u2029c'");
    });

    test('keeps non-ASCII characters', () {
      expect(jsStringLiteral('héllo 👋'), "'héllo 👋'");
    });
  });
}
