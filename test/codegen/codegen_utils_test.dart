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

  group('javaStringLiteral', () {
    test('plain value is unchanged', () {
      expect(javaStringLiteral('abc'), '"abc"');
    });

    test('escapes quotes, backslashes and control characters', () {
      expect(
        javaStringLiteral("it's \"q\" a\\b\nc\r\td\x01"),
        r'''"it's \"q\" a\\b\nc\r\td\001"''',
      );
    });

    test('backslash before u cannot start a unicode escape', () {
      // javac reads unicode escapes before parsing, so the backslash must be
      // doubled to keep the text as it is
      expect(
        javaStringLiteral(
          r'x\'
          'u0041',
        ),
        r'"x\\'
        'u0041"',
      );
    });
  });

  group('javaTextBlock', () {
    test('uses a text block when possible', () {
      expect(javaTextBlock('line 1\nline 2'), '"""\nline 1\nline 2"""');
    });

    test('doubles backslashes inside the text block', () {
      expect(
        javaTextBlock(r'say \"hi\" now'),
        '"""\n'
        r'say \\"hi\\" now"""',
      );
    });

    test(
      'falls back to a string literal when a text block would change it',
      () {
        expect(javaTextBlock('a """ b'), r'"a \"\"\" b"');
        expect(javaTextBlock('ends with "'), r'"ends with \""');
        expect(javaTextBlock('trailing  \nspaces'), r'"trailing  \nspaces"');
        expect(javaTextBlock('  shared\n  indent'), r'"  shared\n  indent"');
        expect(javaTextBlock('a\r\nb'), r'"a\r\nb"');
      },
    );
  });

  group('kotlinStringLiteral', () {
    test('plain value is unchanged', () {
      expect(kotlinStringLiteral('abc'), '"abc"');
    });

    test('escapes quotes, backslashes, dollar signs and newlines', () {
      expect(
        kotlinStringLiteral('a\$b \${c} "d" \\e\nf\r\tg'),
        r'"a\$b \${c} \"d\" \\e\nf\r\tg"',
      );
    });

    test('escapes control characters', () {
      expect(
        kotlinStringLiteral('a\x01'),
        r'"a\'
        'u0001"',
      );
    });
  });

  group('kotlinRawStringLiteral', () {
    test('uses a raw string when possible', () {
      expect(kotlinRawStringLiteral('a\n"b"\nc'), '"""a\n"b"\nc"""');
    });

    test('escapes only dollar signs that would start a template', () {
      expect(
        kotlinRawStringLiteral(r'$HOME ${x} $5 $'),
        r'''"""${'$'}HOME ${'$'}{x} $5 $"""''',
      );
    });

    test('falls back to a string literal when needed', () {
      expect(kotlinRawStringLiteral('a """ b'), r'"a \"\"\" b"');
      expect(kotlinRawStringLiteral('ends with "'), r'"ends with \""');
      expect(kotlinRawStringLiteral('a\r\nb'), r'"a\r\nb"');
    });
  });

  group('goStringLiteral', () {
    test('plain value is unchanged', () {
      expect(goStringLiteral('abc'), '"abc"');
    });

    test('escapes quotes, backslashes and control characters', () {
      expect(
        goStringLiteral("it's \"q\" a\\b\nc\r\td"),
        r'''"it's \"q\" a\\b\nc\r\td"''',
      );
    });

    test('leaves backticks alone', () {
      expect(goStringLiteral('`x`'), '"`x`"');
    });
  });

  group('goRawStringLiteral', () {
    test('uses a raw string when possible', () {
      expect(goRawStringLiteral('a\n"b" \\c'), '`a\n"b" \\c`');
    });

    test('falls back for backticks and carriage returns', () {
      expect(goRawStringLiteral('a `b`'), '"a `b`"');
      expect(goRawStringLiteral('a\r\nb'), r'"a\r\nb"');
    });
  });

  group('cStringLiteral', () {
    test('plain value is unchanged', () {
      expect(cStringLiteral('abc'), '"abc"');
    });

    test('escapes quotes, backslashes and control characters', () {
      expect(
        cStringLiteral("it's \"q\" a\\b\nc\r\td\x01"),
        r'''"it's \"q\" a\\b\nc\r\td\001"''',
      );
    });

    test('uses octal so following hex digits are not swallowed', () {
      expect(cStringLiteral('\x01abc'), r'"\001abc"');
    });

    test('breaks up trigraphs', () {
      expect(cStringLiteral('what??!'), r'"what?\?!"');
    });
  });

  group('csharpStringLiteral', () {
    test('plain value is unchanged', () {
      expect(csharpStringLiteral('abc'), '"abc"');
    });

    test('escapes quotes, backslashes and control characters', () {
      expect(
        csharpStringLiteral("it's \"q\" a\\b\nc\r\td\x01"),
        r'''"it's \"q\" a\\b\nc\r\td\'''
        'u0001"',
      );
    });

    test('escapes the characters C# treats as line breaks', () {
      final value = 'a${String.fromCharCode(0x2028)}b';
      expect(
        csharpStringLiteral(value),
        r'"a\'
        'u2028b"',
      );
    });
  });

  group('csharpRawStringLiteral', () {
    test('uses a raw string when possible', () {
      expect(
        csharpRawStringLiteral('{\n"a": "b\\c"\n}'),
        '"""\n{\n"a": "b\\c"\n}\n"""',
      );
    });

    test('uses a longer delimiter when the value has quote runs', () {
      expect(
        csharpRawStringLiteral('say """"hi""""'),
        '"""""\nsay """"hi""""\n"""""',
      );
    });

    test('falls back for carriage returns', () {
      expect(csharpRawStringLiteral('a\r\nb'), r'"a\r\nb"');
    });
  });
}
