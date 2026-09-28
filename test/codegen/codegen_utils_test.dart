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

  group('rubyStringLiteral', () {
    test('plain value is unchanged', () {
      expect(rubyStringLiteral('abc'), '"abc"');
    });

    test('escapes quotes, backslashes and control characters', () {
      expect(
        rubyStringLiteral("it's \"q\" a\\b\nc\r\td\x01"),
        r'''"it's \"q\" a\\b\nc\r\td\x01"''',
      );
    });

    test('escapes only the # that would start interpolation', () {
      expect(
        rubyStringLiteral(r'#{x} #@y #$z #1 #'),
        r'"\#{x} \#@y \#$z #1 #"',
      );
    });
  });

  group('rubyHeredoc', () {
    test('uses a literal heredoc without the trailing newline', () {
      expect(
        rubyHeredoc('{"a": "b\\c #{x}"}'),
        "<<'HEREDOC'.chomp\n"
        '{"a": "b\\c #{x}"}\n'
        'HEREDOC',
      );
    });

    test('falls back when a line would end the heredoc', () {
      expect(rubyHeredoc('a\nHEREDOC\nb'), r'"a\nHEREDOC\nb"');
    });

    test('falls back for carriage returns', () {
      expect(rubyHeredoc('a\r\nb'), r'"a\r\nb"');
    });
  });

  group('phpStringLiteral', () {
    test('plain value is unchanged', () {
      expect(phpStringLiteral('abc'), "'abc'");
    });

    test('escapes quotes and backslashes only', () {
      expect(
        phpStringLiteral("it's \"q\" C:\\new \$x\nnext"),
        r"""'it\'s "q" C:\\new $x"""
        '\nnext\'',
      );
    });

    test('uses a double-quoted string for carriage returns', () {
      expect(phpStringLiteral('a\r\nb'), r'"a\r\nb"');
    });
  });

  group('phpDoubleQuotedStringLiteral', () {
    test(
      'escapes quotes, backslashes, dollar signs and control characters',
      () {
        expect(
          phpDoubleQuotedStringLiteral("\"q\" a\\b \$x {\$y}\nc\x01"),
          r'"\"q\" a\\b \$x {\$y}\nc\x01"',
        );
      },
    );
  });

  group('phpHeredoc', () {
    test('keeps a heredoc for plain text when allowed', () {
      expect(
        phpHeredoc('{"a": 1}', 'END', allowHeredoc: true),
        '<<<END\n{"a": 1}\nEND',
      );
    });

    test('uses a nowdoc when a heredoc would change the text', () {
      expect(
        phpHeredoc(r'{"a": "\"$x\""}', 'END', allowHeredoc: true),
        "<<<'END'\n"
        r'{"a": "\"$x\""}'
        "\nEND",
      );
      expect(phpHeredoc('{"a": 1}', 'EOF'), "<<<'EOF'\n{\"a\": 1}\nEOF");
    });

    test('falls back when a line would end the block', () {
      expect(phpHeredoc('a\n  END;\nb', 'END'), "'a\n  END;\nb'");
      expect(phpHeredoc('a\nENDING', 'END'), "<<<'END'\na\nENDING\nEND");
    });
  });

  group('juliaStringLiteral', () {
    test('plain value is unchanged', () {
      expect(juliaStringLiteral('abc'), '"abc"');
    });

    test(
      'escapes quotes, backslashes, dollar signs and control characters',
      () {
        expect(
          juliaStringLiteral("\"q\" a\\b \$x \$(y)\nc\r\td\x01"),
          r'"\"q\" a\\b \$x \$(y)\nc\r\td\x01"',
        );
      },
    );
  });

  group('juliaTripleQuotedStringLiteral', () {
    test('uses a triple-quoted string when possible', () {
      expect(
        juliaTripleQuotedStringLiteral('{\n  "a": 1\n}'),
        '"""{\n  "a": 1\n}"""',
      );
    });

    test('falls back when triple quotes would change the text', () {
      expect(juliaTripleQuotedStringLiteral(r'a $x'), r'"a \$x"');
      expect(juliaTripleQuotedStringLiteral(r'a\b'), r'"a\\b"');
      expect(
        juliaTripleQuotedStringLiteral('first\n  second'),
        r'"first\n  second"',
      );
      expect(juliaTripleQuotedStringLiteral('\nx'), r'"\nx"');
      expect(juliaTripleQuotedStringLiteral('ends "'), r'"ends \""');
    });
  });

  group('rustStringLiteral', () {
    test('plain value is unchanged', () {
      expect(rustStringLiteral('abc'), '"abc"');
    });

    test('escapes quotes, backslashes and control characters', () {
      expect(
        rustStringLiteral("it's \"q\" a\\b\nc\r\td\x01"),
        r'''"it's \"q\" a\\b\nc\r\td\'''
        'u{1}"',
      );
    });

    test('leaves braces alone', () {
      expect(rustStringLiteral('{x}'), '"{x}"');
    });
  });

  group('rustRawStringLiteral', () {
    test('uses r#"..."# for plain text', () {
      expect(rustRawStringLiteral(r'a "b" \c'), r'r#"a "b" \c"#');
    });

    test('uses more #s when the value contains "#', () {
      expect(
        rustRawStringLiteral('color: "#fff" and "##"'),
        'r###"color: "#fff" and "##""###',
      );
    });

    test('respects minHashes', () {
      expect(rustRawStringLiteral(r'C:\a', minHashes: 0), r'r"C:\a"');
      expect(rustRawStringLiteral(r'a "b"', minHashes: 0), r'r#"a "b""#');
    });

    test('falls back for carriage returns', () {
      expect(rustRawStringLiteral('a\r\nb'), r'"a\r\nb"');
    });
  });

  group('rustByteStringLiteral', () {
    test('uses a byte string for ASCII', () {
      expect(rustByteStringLiteral('a "b"\n'), r'b"a \"b\"\n"');
    });

    test('uses as_bytes() for non-ASCII', () {
      expect(rustByteStringLiteral('café'), '"café".as_bytes()');
    });
  });

  group('jsonToRustJsonMacro', () {
    test('keeps plain JSON as it is', () {
      expect(
        jsonToRustJsonMacro('{\n"a": "b",\n"n": 1\n}'),
        '{\n"a": "b",\n"n": 1\n}',
      );
    });

    test('rewrites JSON escapes that are not valid in Rust', () {
      expect(
        jsonToRustJsonMacro(r'{"p": "a\/b", "q": "say \"hi\""}'),
        r'{"p": "a/b", "q": "say \"hi\""}',
      );
    });
  });

  group('swiftStringLiteral', () {
    test('plain value is unchanged', () {
      expect(swiftStringLiteral('abc'), '"abc"');
    });

    test('escapes quotes, backslashes and control characters', () {
      expect(
        swiftStringLiteral("\"q\" a\\b \\(x)\nc\r\td\x01"),
        r'''"\"q\" a\\b \\(x)\nc\r\td\'''
        'u{1}"',
      );
    });

    test('swiftStringContent has no surrounding quotes', () {
      expect(swiftStringContent('say "hi"'), r'say \"hi\"');
    });
  });

  group('swiftMultilineStringLiteral', () {
    test('keeps lines and escapes backslashes', () {
      expect(
        swiftMultilineStringLiteral('{\n"a": "b\\"c"\n}'),
        '"""\n{\n"a": "b\\\\"c"\n}\n"""',
      );
    });

    test('escapes runs of three or more quotes only', () {
      expect(
        swiftMultilineStringLiteral('a "" b """ c'),
        '"""\na "" b '
        r'\"\"\"'
        ' c\n"""',
      );
    });

    test('escapes carriage returns', () {
      expect(
        swiftMultilineStringLiteral('a\r\nb'),
        '"""\na'
        r'\r'
        '\nb\n"""',
      );
    });
  });

  group('dartStringLiteral', () {
    test('plain value is unchanged', () {
      expect(dartStringLiteral('abc'), "'abc'");
    });

    test(
      'escapes quotes, backslashes, dollar signs and control characters',
      () {
        expect(
          dartStringLiteral("it's \$x \${y} a\\b\nc\r\td\x01"),
          r"'it\'s \$x \${y} a\\b\nc\r\td\x01'",
        );
      },
    );
  });

  group('dartRawMultilineStringLiteral', () {
    test('uses a raw string when possible', () {
      expect(
        dartRawMultilineStringLiteral('{\n"a": "\$x \\n"\n}'),
        "r'''{\n\"a\": \"\$x \\n\"\n}'''",
      );
    });

    test('falls back when a raw string would change the text', () {
      expect(dartRawMultilineStringLiteral("a ''' b"), r"'a \'\'\' b'");
      expect(dartRawMultilineStringLiteral("ends '"), r"'ends \''");
      expect(dartRawMultilineStringLiteral('\nx'), r"'\nx'");
      expect(dartRawMultilineStringLiteral('  \nx'), r"'  \nx'");
      expect(dartRawMultilineStringLiteral('a\r\nb'), r"'a\r\nb'");
    });
  });

  group('jsonToDartLiteral', () {
    test('escapes dollar signs', () {
      expect(
        jsonToDartLiteral([
          {'value': r'$HOME ${x}'},
        ]),
        r'[{"value":"\$HOME \${x}"}]',
      );
    });
  });

  group('shellSingleQuoted', () {
    test('keeps plain values unchanged', () {
      expect(shellSingleQuoted(r'say "hi" $HOME \n'), r"""'say "hi" $HOME \n'""");
    });

    test('keeps newlines inside the quotes', () {
      expect(shellSingleQuoted('a\nb'), "'a\nb'");
    });

    test('escapes single quotes', () {
      expect(shellSingleQuoted("it's"), r"""'it'\''s'""");
    });

    test('uses ANSI-C quoting for carriage returns', () {
      expect(shellSingleQuoted("it's\r\n\\"), r"""$'it\'s\r\n\\'""");
    });

    test('uses ANSI-C quoting for other control characters', () {
      expect(shellSingleQuoted('a\x01b'), r"""$'a\x01b'""");
    });
  });
}
