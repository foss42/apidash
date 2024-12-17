import 'package:flutter_test/flutter_test.dart';
import 'package:hurl_parser/src/grammar/base_grammar.dart';
import 'package:petitparser/petitparser.dart';

void main() {
  final hurl = HurlGrammar();

  group('CA Certificate Option Tests', () {
    void testCaCertPath(String input, String expectedPath) {
      final parser = hurl.buildFrom(hurl.caCertificateOption());
      final result = parser.parse(input);

      expect(result.isSuccess, isTrue, reason: 'Failed to parse: $input');
      expect(result.value['type'], equals('cacert'));
      expect(result.value['value'], equals(expectedPath));
    }

    test('Unix-style paths', () {
      testCaCertPath('cacert: /path/to/cert.pem\n', '/path/to/cert.pem');
      testCaCertPath(
          'cacert: /absolute/path/cert.pem\n', '/absolute/path/cert.pem');
      testCaCertPath('cacert: ./relative/cert.pem\n', './relative/cert.pem');
      testCaCertPath('cacert: ../parent/cert.pem\n', '../parent/cert.pem');
      testCaCertPath('cacert: ~/user/cert.pem\n', '~/user/cert.pem');
    });

    // TODO:
    // FIXME: Windows-style paths are not supported
    // test('Windows-style paths', () {
    //   testCaCertPath(
    //       'cacert: C:\\path\\to\\cert.pem\n', 'C:\\path\\to\\cert.pem');
    //   testCaCertPath('cacert: D:\\certs\\root.pem\n', 'D:\\certs\\root.pem');
    //   testCaCertPath('cacert: ..\\parent\\cert.pem\n', '..\\parent\\cert.pem');
    //   testCaCertPath(
    //       'cacert: .\\relative\\cert.pem\n', '.\\relative\\cert.pem');
    // });

    test('Paths with special characters', () {
      testCaCertPath('cacert: /path_with_underscore/cert.pem\n',
          '/path_with_underscore/cert.pem');
      testCaCertPath(
          'cacert: /path-with-dashes/cert.pem\n', '/path-with-dashes/cert.pem');
      testCaCertPath(
          'cacert: /path.with.dots/cert.pem\n', '/path.with.dots/cert.pem');
    });

    test('Different certificate extensions', () {
      testCaCertPath('cacert: /path/cert.pem\n', '/path/cert.pem');
      testCaCertPath('cacert: /path/cert.crt\n', '/path/cert.crt');
      testCaCertPath('cacert: /path/cert.cer\n', '/path/cert.cer');
      testCaCertPath('cacert: /path/ca.der\n', '/path/ca.der');
    });

    test('As part of Options section', () {
      final parser = hurl.buildFrom(hurl.optionsSection());
      const input = '''[Options]
cacert: /path/to/cert.pem
compressed: true
''';
      final result = parser.parse(input);
      expect(result is Success, isTrue,
          reason: 'Failed to parse options section');

      // Access the options list from the parsed result
      // The structure is [lineTerminators, "[Options]", lineTerminator, options]
      final options = result.value[3] as List;

      expect(options, hasLength(2));
      expect(options[0]['type'], equals('cacert'));
      expect(options[0]['value'], equals('/path/to/cert.pem'));
      expect(options[1]['type'], equals('compressed'));
      expect(options[1]['value'], equals(true));
    });

    test('Multiple certificates in Options', () {
      final parser = hurl.buildFrom(hurl.optionsSection());
      const input = '''[Options]
cacert: /path/to/cert1.pem
compressed: true
cacert: /path/to/cert2.pem
''';
      final result = parser.parse(input);
      expect(result is Success, isTrue,
          reason: 'Failed to parse multiple options');

      // Access the options list from the parsed result
      final options = result.value[3] as List;

      expect(options, hasLength(3));
      expect(options[0]['type'], equals('cacert'));
      expect(options[0]['value'], equals('/path/to/cert1.pem'));
      expect(options[1]['type'], equals('compressed'));
      expect(options[1]['value'], equals(true));
      expect(options[2]['type'], equals('cacert'));
      expect(options[2]['value'], equals('/path/to/cert2.pem'));
    });
  });
}
