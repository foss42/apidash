import 'package:flutter_test/flutter_test.dart';
import 'package:apidash_core/apidash_core.dart';

class TestDocGenerator extends DocGenerator {
  const TestDocGenerator();

  @override
  String generate({
    required HttpRequestModel request,
    HttpResponseModel? response,
    String? requestName,
  }) {
    return 'Generated: ${requestName ?? request.url}';
  }
}

void main() {
  group('DocGenerator interface tests', () {
    test('Can subclass and call generate()', () {
      const generator = TestDocGenerator();
      const req = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.example.com/test',
      );
      final output = generator.generate(request: req, requestName: 'Sample Request');
      expect(output, 'Generated: Sample Request');

      final fallbackOutput = generator.generate(request: req);
      expect(fallbackOutput, 'Generated: https://api.example.com/test');
    });
  });

  group('escapeMarkdownTable tests', () {
    test('Handles null and empty string', () {
      expect(escapeMarkdownTable(null), '-');
      expect(escapeMarkdownTable(''), '-');
    });

    test('Escapes pipe characters', () {
      expect(escapeMarkdownTable('col1 | col2'), r'col1 \| col2');
      expect(escapeMarkdownTable('|a|b|c|'), r'\|a\|b\|c\|');
    });

    test('Escapes backslashes and converts newlines', () {
      expect(escapeMarkdownTable(r'path\to\file'), r'path\\to\\file');
      expect(escapeMarkdownTable('line1\nline2'), 'line1<br/>line2');
      expect(escapeMarkdownTable('line1\r\nline2'), 'line1<br/>line2');
      expect(escapeMarkdownTable('line1\rline2'), 'line1<br/>line2');
    });

    test('Leaves plain text unchanged', () {
      expect(escapeMarkdownTable('Content-Type'), 'Content-Type');
      expect(escapeMarkdownTable('application/json'), 'application/json');
    });
  });

  group('formatByteSize tests', () {
    test('Handles null, zero and negative bytes', () {
      expect(formatByteSize(null), '0 B');
      expect(formatByteSize(0), '0 B');
      expect(formatByteSize(-50), '0 B');
    });

    test('Formats bytes (< 1024 B)', () {
      expect(formatByteSize(1), '1 B');
      expect(formatByteSize(512), '512 B');
      expect(formatByteSize(1023), '1023 B');
    });

    test('Formats kilobytes (KB)', () {
      expect(formatByteSize(1024), '1 KB');
      expect(formatByteSize(1536), '1.5 KB');
      expect(formatByteSize(10240), '10 KB');
    });

    test('Formats megabytes (MB) and gigabytes (GB)', () {
      expect(formatByteSize(1048576), '1 MB');
      expect(formatByteSize(1572864), '1.5 MB');
      expect(formatByteSize(1073741824), '1 GB');
    });
  });

  group('formatDuration tests', () {
    test('Handles null', () {
      expect(formatDuration(null), '-');
    });

    test('Formats microseconds (< 1000 µs)', () {
      expect(formatDuration(const Duration(microseconds: 500)), '500 µs');
      expect(formatDuration(const Duration(microseconds: 999)), '999 µs');
    });

    test('Formats milliseconds (< 1000 ms)', () {
      expect(formatDuration(const Duration(milliseconds: 1)), '1 ms');
      expect(formatDuration(const Duration(milliseconds: 45)), '45 ms');
      expect(formatDuration(const Duration(milliseconds: 950)), '950 ms');
    });

    test('Formats seconds (>= 1 s)', () {
      expect(formatDuration(const Duration(milliseconds: 1000)), '1 s');
      expect(formatDuration(const Duration(milliseconds: 1500)), '1.5 s');
      expect(formatDuration(const Duration(milliseconds: 2340)), '2.34 s');
    });
  });

  group('detectMimeLanguage tests', () {
    test('Handles null and empty', () {
      expect(detectMimeLanguage(null), 'text');
      expect(detectMimeLanguage(''), 'text');
      expect(detectMimeLanguage('   '), 'text');
    });

    test('Detects JSON MIME types', () {
      expect(detectMimeLanguage('application/json'), 'json');
      expect(detectMimeLanguage('application/json; charset=utf-8'), 'json');
      expect(detectMimeLanguage('application/problem+json'), 'json');
    });

    test('Detects XML MIME types', () {
      expect(detectMimeLanguage('application/xml'), 'xml');
      expect(detectMimeLanguage('text/xml; charset=utf-8'), 'xml');
    });

    test('Detects other standard web MIME types', () {
      expect(detectMimeLanguage('text/html'), 'html');
      expect(detectMimeLanguage('application/javascript'), 'javascript');
      expect(detectMimeLanguage('text/css'), 'css');
      expect(detectMimeLanguage('text/yaml'), 'yaml');
      expect(detectMimeLanguage('text/markdown'), 'markdown');
      expect(detectMimeLanguage('text/plain'), 'text');
    });
  });

  group('formatDocBody tests', () {
    test('Handles null and empty strings', () {
      expect(formatDocBody(null), '');
      expect(formatDocBody(''), '');
      expect(formatDocBody('   '), '');
    });

    test('Pretty-prints valid JSON', () {
      const rawJson = '{"name":"John","age":30,"active":true}';
      final formatted = formatDocBody(rawJson, contentType: 'application/json');
      expect(formatted, contains('  "name": "John"'));
      expect(formatted, contains('  "age": 30'));
      expect(formatted, contains('  "active": true'));
    });

    test('Falls back gracefully for malformed JSON', () {
      const malformedJson = '{"name": "John", missing: }';
      final formatted = formatDocBody(malformedJson, contentType: 'application/json');
      expect(formatted, malformedJson);
    });

    test('Pretty-prints valid XML', () {
      const rawXml = '<root><user id="1"><name>Alice</name></user></root>';
      final formatted = formatDocBody(rawXml, contentType: 'application/xml');
      expect(formatted, contains('<root>'));
      expect(formatted, contains('  <user id="1">'));
      expect(formatted, contains('    <name>Alice</name>'));
    });

    test('Falls back gracefully for malformed XML', () {
      const malformedXml = '<root><unclosed>';
      final formatted = formatDocBody(malformedXml, contentType: 'application/xml');
      expect(formatted, malformedXml);
    });

    test('Returns plain text trimmed', () {
      const text = '  Hello World!  ';
      expect(formatDocBody(text, contentType: 'text/plain'), 'Hello World!');
    });
  });

  group('getHttpStatusText tests', () {
    test('Handles null', () {
      expect(getHttpStatusText(null), '-');
    });

    test('Maps common standard HTTP status codes', () {
      expect(getHttpStatusText(200), 'OK');
      expect(getHttpStatusText(201), 'Created');
      expect(getHttpStatusText(204), 'No Content');
      expect(getHttpStatusText(400), 'Bad Request');
      expect(getHttpStatusText(401), 'Unauthorized');
      expect(getHttpStatusText(403), 'Forbidden');
      expect(getHttpStatusText(404), 'Not Found');
      expect(getHttpStatusText(429), 'Too Many Requests');
      expect(getHttpStatusText(500), 'Internal Server Error');
      expect(getHttpStatusText(502), 'Bad Gateway');
      expect(getHttpStatusText(503), 'Service Unavailable');
    });

    test('Maps arbitrary status ranges', () {
      expect(getHttpStatusText(299), 'Success');
      expect(getHttpStatusText(399), 'Redirection');
      expect(getHttpStatusText(499), 'Client Error');
      expect(getHttpStatusText(599), 'Server Error');
      expect(getHttpStatusText(999), 'Status 999');
    });
  });

  group('getHeaderDescription tests', () {
    test('Handles null and empty strings', () {
      expect(getHeaderDescription(null), '-');
      expect(getHeaderDescription(''), '-');
      expect(getHeaderDescription('   '), '-');
    });

    test('Resolves common header descriptions case-insensitively', () {
      expect(getHeaderDescription('Authorization'),
          'Authentication credentials');
      expect(getHeaderDescription('content-type'),
          'Media type of the request body');
      expect(getHeaderDescription('ACCEPT'),
          'Acceptable response media types');
      expect(getHeaderDescription('User-Agent'),
          'Client application user agent string');
    });

    test('Falls back to - for custom or unknown headers', () {
      expect(getHeaderDescription('X-Custom-Header'), '-');
      expect(getHeaderDescription('my-tracking-id'), '-');
    });
  });

  group('escapeBashSingleQuotes tests', () {
    test('Handles null and empty string', () {
      expect(escapeBashSingleQuotes(null), '');
      expect(escapeBashSingleQuotes(''), '');
    });

    test('Leaves plain text without single quotes untouched', () {
      expect(escapeBashSingleQuotes('hello world'), 'hello world');
    });

    test('Escapes single quotes with bash closing/escaped sequence', () {
      expect(escapeBashSingleQuotes("don't"), r"don'\''t");
      expect(escapeBashSingleQuotes("it's a 'test'"), r"it'\''s a '\''test'\''");
    });
  });
}
