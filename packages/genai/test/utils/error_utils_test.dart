import 'package:flutter_test/flutter_test.dart';
import 'package:genai/utils/error_utils.dart';

void main() {
  group('extractGenAIErrorMessage', () {
    test('1. extracts Gemini error.message', () {
      const body = '''
{
  "error": {
    "code": 400,
    "message": "API key not valid. Please pass a valid API key.",
    "status": "INVALID_ARGUMENT"
  }
}
''';
      expect(
        extractGenAIErrorMessage(body, 400),
        'API key not valid. Please pass a valid API key.',
      );
    });

    test('2. extracts Anthropic error.message', () {
      const body = '''
{
  "type": "error",
  "error": {
    "type": "authentication_error",
    "message": "invalid x-api-key"
  }
}
''';
      expect(
        extractGenAIErrorMessage(body, 401),
        'invalid x-api-key',
      );
    });

    test('3. extracts OpenAI and Azure error.message', () {
      const body = '''
{
  "error": {
    "message": "Incorrect API key provided: sk-test12345",
    "type": "invalid_request_error",
    "code": "invalid_api_key"
  }
}
''';
      // Notice also verifying credential redaction on sk- key
      expect(
        extractGenAIErrorMessage(body, 401),
        'Incorrect API key provided: sk-***',
      );
    });

    test('4. extracts Ollama string error', () {
      const body = '{"error": "model \'llama3\' not found, try pulling it first"}';
      expect(
        extractGenAIErrorMessage(body, 404),
        "model 'llama3' not found, try pulling it first",
      );
    });

    test('5. extracts generic JSON message', () {
      const body = '{"message": "Rate limit exceeded. Please wait 60s."}';
      expect(
        extractGenAIErrorMessage(body, 429),
        'Rate limit exceeded. Please wait 60s.',
      );
    });

    test('6. extracts FastAPI detail string and validation list', () {
      const bodyString = '{"detail": "Not authenticated"}';
      expect(
        extractGenAIErrorMessage(bodyString, 401),
        'Not authenticated',
      );

      const bodyList = '''
{
  "detail": [
    {"loc": ["body", "prompt"], "msg": "Field required", "type": "missing"}
  ]
}
''';
      expect(
        extractGenAIErrorMessage(bodyList, 422),
        'Field required',
      );
    });

    test('7. handles plain text responses', () {
      expect(
        extractGenAIErrorMessage('Unauthorized access', 401),
        'HTTP 401: Unauthorized access',
      );
    });

    test('8. handles malformed JSON safely without throwing', () {
      const malformed = '{"error": {"message": "unclosed json string';
      expect(
        extractGenAIErrorMessage(malformed, 400),
        'HTTP 400: {"error": {"message": "unclosed json string',
      );
    });

    test('9. handles HTML gateway responses without exposing raw HTML', () {
      const htmlBody = '''
<!DOCTYPE html>
<html>
  <head><title>502 Bad Gateway</title></head>
  <body><center><h1>502 Bad Gateway</h1></center><hr><center>cloudflare</center></body>
</html>
''';
      expect(
        extractGenAIErrorMessage(htmlBody, 502),
        'HTTP 502 error',
      );

      const simpleHtml = '<p>Service Unavailable</p>';
      expect(
        extractGenAIErrorMessage(simpleHtml, 503),
        'HTTP 503 error',
      );
    });

    test('10. handles empty and whitespace-only responses', () {
      expect(extractGenAIErrorMessage('', 500), 'HTTP 500 error');
      expect(extractGenAIErrorMessage('   \n\t  ', 503), 'HTTP 503 error');
    });

    test('handles empty error objects gracefully', () {
      const body = '{"error": {}}';
      expect(
        extractGenAIErrorMessage(body, 400),
        'HTTP 400: {"error": {}}',
      );
    });

    test('handles non-string message fields gracefully', () {
      const body = '{"error": {"message": 12345}}';
      expect(
        extractGenAIErrorMessage(body, 400),
        'HTTP 400: {"error": {"message": 12345}}',
      );

      const bodyBool = '{"error": {"message": false}}';
      expect(
        extractGenAIErrorMessage(bodyBool, 400),
        'HTTP 400: {"error": {"message": false}}',
      );
    });

    test('handles JSON arrays without crashing', () {
      const arrayBody = '["Error 1", "Error 2"]';
      expect(
        extractGenAIErrorMessage(arrayBody, 500),
        'HTTP 500: ["Error 1", "Error 2"]',
      );

      const emptyArray = '[]';
      expect(
        extractGenAIErrorMessage(emptyArray, 500),
        'HTTP 500: []',
      );
    });

    test('truncates excessively long error responses', () {
      final longText = 'A' * 1000;
      final result = extractGenAIErrorMessage(longText, 500);

      expect(result.length, lessThanOrEqualTo(520)); // "HTTP 500: " + 500 chars + "..."
      expect(result.endsWith('...'), isTrue);
      expect(result.startsWith('HTTP 500: '), isTrue);
    });

    test('strips stray HTML tags inside error messages', () {
      const body = '{"error": {"message": "<b>Invalid token</b> provided."}}';
      expect(
        extractGenAIErrorMessage(body, 401),
        'Invalid token provided.',
      );
    });

    test('redacts Google AIza keys and Bearer tokens', () {
      // Construct synthetic key dynamically to avoid static secret-scanning false positives
      // while testing the 39-character AIza + 35 regex redaction rule.
      final fakeGoogleKey = 'AIza${List.filled(35, '0').join()}';
      final googleBody =
          '{"error": {"message": "Key $fakeGoogleKey is blocked."}}';
      expect(
        extractGenAIErrorMessage(googleBody, 403),
        'Key AIza*** is blocked.',
      );

      const bearerBody = 'Header Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9 was rejected';
      expect(
        extractGenAIErrorMessage(bearerBody, 401),
        'HTTP 401: Header Bearer *** was rejected',
      );
    });
  });
}
