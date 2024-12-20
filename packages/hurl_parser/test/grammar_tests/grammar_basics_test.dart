import 'package:flutter_test/flutter_test.dart';
import 'package:hurl_parser/src/grammar/base_grammar.dart';
import 'package:petitparser/petitparser.dart';

void main() {
  final hurl = HurlGrammar();

  group('Basic Leaf Parsers', () {
    test('Digit Parser', () {
      final digitParser = hurl.buildFrom(hurl.digit()).end();
      for (var i = 0; i < 10; i++) {
        expect(digitParser.parse('$i') is Success, isTrue);
      }
      expect(digitParser.parse('a') is Success, isFalse);
    });

    test('Letter Parser', () {
      final letterParser = hurl.buildFrom(hurl.letter()).end();
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('').forEach((c) {
        expect(letterParser.parse(c) is Success, isTrue);
      });
      expect(letterParser.parse('1') is Success, isFalse);
    });

    test('Space Parser', () {
      final spaceParser = hurl.buildFrom(hurl.space()).end();
      expect(spaceParser.parse(' ') is Success, isTrue);
      expect(spaceParser.parse('\t') is Success, isTrue);
      expect(spaceParser.parse('a') is Success, isFalse);
    });

    test('Line Terminator Parser', () {
      final terminatorParser = hurl.buildFrom(hurl.lineTerminator()).end();
      expect(terminatorParser.parse('\n') is Success, isTrue);
      expect(terminatorParser.parse(' \n') is Success, isTrue);
      expect(terminatorParser.parse('\t\n') is Success, isTrue);
      expect(terminatorParser.parse('a\n') is Success, isFalse);
    });
  });
}
