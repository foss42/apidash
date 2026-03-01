
import 'package:test/test.dart';
import 'package:hurl_parser/hurl_parser.dart';

void main() {
  group('HurlParser', () {
    test('parses basic GET request', () {
      final content = '''
GET https://example.com/api/v1/users
User-Agent: TestAgent/1.0
''';
      final parser = HurlParser();
      final entries = parser.parse(content);

      expect(entries, isNotEmpty);
      expect(entries.first.method, 'GET');
      expect(entries.first.url, 'https://example.com/api/v1/users');
      expect(entries.first.headers, containsPair('User-Agent', 'TestAgent/1.0'));
    });

    test('parses request with body', () {
       final content = '''
POST https://example.com/data
Content-Type: application/json

{"foo": "bar"}
''';
      final parser = HurlParser();
      final entries = parser.parse(content);

      expect(entries.first.method, 'POST');
      expect(entries.first.body, contains('"foo": "bar"'));
    });

    test('parses request with Windows line endings (CRLF)', () {
      final content = 'GET https://example.com/windows\r\nUser-Agent: WindowsAgent\r\n\r\n';
      final parser = HurlParser();
      final entries = parser.parse(content);

      expect(entries, isNotEmpty);
      expect(entries.first.method, 'GET');
      expect(entries.first.url, 'https://example.com/windows');
      expect(entries.first.headers, containsPair('User-Agent', 'WindowsAgent'));
    });

    test('parses request with comments', () {
      final content = '''
# Simple GET Request
GET https://example.com/comments
''';
      final parser = HurlParser();
      final entries = parser.parse(content);

      expect(entries, isNotEmpty);
      expect(entries.first.method, 'GET');
    });
  });
}
