import 'package:flutter_test/flutter_test.dart';
import 'package:hurl_parser/src/grammar/base_grammar.dart';
import 'package:petitparser/petitparser.dart';

void main() {
  final hurl = HurlGrammar();

  group('Basic Auth Section Tests', () {
    test('Simple Basic Auth', () {
      final parser = (hurl.buildFrom(hurl.basicAuthSection()).end());
      const input = '''[BasicAuth]
username: john
password: secret123
''';

      final result = parser.parse(input);
      expect(result is Success, isTrue);

      final values = result.value as List;
      expect(values, hasLength(4));
      expect(values[0], isEmpty); // Initial whitespace
      expect(values[1], equals('[BasicAuth]')); // Section header

      final kvPairs = values[3] as List;
      expect(kvPairs, hasLength(2));
      expect(kvPairs[0], equals({'key': 'username', 'value': 'john'}));
      expect(kvPairs[1], equals({'key': 'password', 'value': 'secret123'}));
    });

    test('Basic Auth with Template Variables', () {
      final parser = hurl.buildFrom(hurl.basicAuthSection()).end();
      const input = '''[BasicAuth]
username: {{username}}
password: {{password}}
''';

      final result = parser.parse(input);
      expect(result is Success, isTrue);

      final values = result.value as List;
      final kvPairs = values[3] as List;
      expect(kvPairs, hasLength(2));
      expect(kvPairs[0], equals({'key': 'username', 'value': '{{username}}'}));
      expect(kvPairs[1], equals({'key': 'password', 'value': '{{password}}'}));
    });

    test('Empty Basic Auth Section', () {
      final parser = hurl.buildFrom(hurl.basicAuthSection()).end();
      const input = '''[BasicAuth]
''';
      final result = parser.parse(input);
      expect(result is Success, isTrue);

      final values = result.value as List;
      expect(values[3], isEmpty); // No key-value pairs
    });
  });

  group('Query String Parameters Section Tests', () {
    test('Simple Query Parameters', () {
      final parser = hurl.buildFrom(hurl.queryStringParamsSection()).end();
      const input = '''[QueryStringParams]
page: 1
limit: 10
sort: desc
''';

      final result = parser.parse(input);
      expect(result is Success, isTrue);

      final values = result.value as List;
      expect(values[1], equals('[QueryStringParams]'));

      final kvPairs = values[3] as List;
      expect(kvPairs, hasLength(3));
      expect(kvPairs[0], equals({'key': 'page', 'value': '1'}));
      expect(kvPairs[1], equals({'key': 'limit', 'value': '10'}));
      expect(kvPairs[2], equals({'key': 'sort', 'value': 'desc'}));
    });

    test('Query Parameters with Special Characters', () {
      final parser = hurl.buildFrom(hurl.queryStringParamsSection()).end();
      const input = '''[Query]
search: hello world
tags: tag1,tag2,tag3
email: test+user@example.com
''';

      final result = parser.parse(input);
      expect(result is Success, isTrue);

      final values = result.value as List;
      expect(values[1], equals('[Query]'));

      final kvPairs = values[3] as List;
      expect(kvPairs, hasLength(3));
      expect(kvPairs[0], equals({'key': 'search', 'value': 'hello world'}));
      expect(kvPairs[1], equals({'key': 'tags', 'value': 'tag1,tag2,tag3'}));
      expect(kvPairs[2],
          equals({'key': 'email', 'value': 'test+user@example.com'}));
    });
  });

  group('Form Parameters Section Tests', () {
    test('Form Parameters with Various Types', () {
      final parser = hurl.buildFrom(hurl.formParamsSection()).end();
      const input = '''[FormParams]
name: John Doe
email: john@example.com
age: 30
newsletter: true
preferences: ["email","sms"]
''';

      final result = parser.parse(input);
      expect(result is Success, isTrue);

      final values = result.value as List;
      expect(values[1], equals('[FormParams]'));

      final kvPairs = values[3] as List;
      expect(kvPairs, hasLength(5));
      expect(kvPairs[0], equals({'key': 'name', 'value': 'John Doe'}));
      expect(kvPairs[1], equals({'key': 'email', 'value': 'john@example.com'}));
      expect(kvPairs[2], equals({'key': 'age', 'value': '30'}));
      expect(kvPairs[3], equals({'key': 'newsletter', 'value': 'true'}));
      expect(kvPairs[4],
          equals({'key': 'preferences', 'value': '["email","sms"]'}));
    });
  });

  group('Multipart Form Data Section Tests', () {
    test('Complex File Upload with Metadata', () {
      final parser = hurl.buildFrom(hurl.multipartFormDataSection()).end();
      const input = '''[MultipartFormData]
file1: file,/path/to/image.jpg;image/jpeg
file2: file,/path/to/doc.pdf;application/pdf
description: A test upload
tags: ["public","important"]
''';

      final result = parser.parse(input);
      expect(result is Success, isTrue);

      final values = result.value as List;
      expect(values[1], equals('[MultipartFormData]'));

      final params = values[3] as List;
      expect(params, hasLength(4));
      expect(params[0]['key'], equals('file1'));
      expect(params[0]['value'], contains('/path/to/image.jpg'));
      expect(params[0]['value'], contains('image/jpeg'));
      expect(params[1]['key'], equals('file2'));
      expect(params[1]['value'], contains('/path/to/doc.pdf'));
      expect(params[1]['value'], contains('application/pdf'));
      expect(
          params[2], equals({'key': 'description', 'value': 'A test upload'}));
      expect(params[3],
          equals({'key': 'tags', 'value': '["public","important"]'}));
    });
  });

  group('Options Section Tests', () {
    test('All Option Types', () {
      final parser = hurl.buildFrom(hurl.optionsSection()).end();
      const input = '''[Options]
compressed: true
aws-sigv4: aws:amz:us-east-1:s3
cacert: /path/to/cert.pem
''';

      final result = parser.parse(input);
      expect(result is Success, isTrue);
      final values = result.value as List;

      final options = values[3] as List;
      expect(options, hasLength(3));
      expect(options[0], equals({'type': 'compressed', 'value': true}));
      expect(options[1],
          equals({'type': 'aws-sigv4', 'value': 'aws:amz:us-east-1:s3'}));
      expect(
          options[2], equals({'type': 'cacert', 'value': '/path/to/cert.pem'}));
    });
  });

  group('Individual Option Tests', () {
    test('Compressed Option Values', () {
      final parser = hurl.buildFrom(hurl.compressedOption());

      // Test true value
      var result = parser.parse('compressed: true\n');
      expect(result is Success, isTrue);
      expect(result.value, equals({'type': 'compressed', 'value': true}));

      // Test false value
      result = parser.parse('compressed: false\n');
      expect(result is Success, isTrue);
      expect(result.value, equals({'type': 'compressed', 'value': false}));
    });

    test('AWS Sigv4 Option', () {
      final parser = hurl.buildFrom(hurl.awsSigv4Option());
      const input = 'aws-sigv4: aws:amz:region:service\n';

      final result = parser.parse(input);
      expect(result is Success, isTrue);
      expect(result.value,
          equals({'type': 'aws-sigv4', 'value': 'aws:amz:region:service'}));
    });

    test('CA Certificate Option', () {
      final parser = hurl.buildFrom(hurl.caCertificateOption());
      const input = 'cacert: /path/to/cert.pem\n';

      final result = parser.parse(input);
      expect(result is Success, isTrue);
      expect(result.value,
          equals({'type': 'cacert', 'value': '/path/to/cert.pem'}));
    });
  });
}
