import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';

void main() {
  const generator = CurlSessionGenerator();

  group('CurlSessionGenerator - Method & URL', () {
    test('Generates simple GET curl command', () {
      const request = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.example.com/users',
      );
      final result = generator.generate(request: request);
      expect(result, "curl -X GET 'https://api.example.com/users'\n");
    });

    test('Appends enabled query parameters to URL', () {
      const request = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.example.com/search',
        params: [
          NameValueModel(name: 'q', value: 'dart'),
          NameValueModel(name: 'page', value: '2'),
        ],
      );
      final result = generator.generate(request: request);
      expect(
        result,
        "curl -X GET 'https://api.example.com/search?q=dart&page=2'\n",
      );
    });

    test('Includes requestName comment if specified', () {
      const request = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.example.com/health',
      );
      final result = generator.generate(
        request: request,
        requestName: 'Check Service Health',
      );
      expect(
        result,
        startsWith(
          "# Check Service Health\ncurl -X GET 'https://api.example.com/health'\n",
        ),
      );
    });
  });

  group('CurlSessionGenerator - Headers and Body', () {
    test('Includes -H headers and --data body for POST request', () {
      const request = HttpRequestModel(
        method: HTTPVerb.post,
        url: 'https://api.example.com/users',
        headers: [
          NameValueModel(name: 'Authorization', value: 'Bearer token123'),
          NameValueModel(name: 'Content-Type', value: 'application/json'),
        ],
        bodyContentType: ContentType.json,
        body: '{"name":"Alice"}',
      );
      final result = generator.generate(request: request);
      final expected =
          "curl -X POST 'https://api.example.com/users' \\\n"
          "  -H 'Authorization: Bearer token123' \\\n"
          "  -H 'Content-Type: application/json' \\\n"
          "  --data '{\"name\":\"Alice\"}'\n";
      expect(result, expected);
    });

    test('Escapes single quotes inside body with bash escape sequence', () {
      const request = HttpRequestModel(
        method: HTTPVerb.post,
        url: 'https://api.example.com/quotes',
        headers: [
          NameValueModel(name: 'Content-Type', value: 'application/json'),
        ],
        bodyContentType: ContentType.json,
        body: '{"quote":"It\'s great"}',
      );
      final result = generator.generate(request: request);
      expect(result.contains(r"It'\''s great"), isTrue);
    });

    test(
      'Generates -F flags for multipart/form-data and skips Content-Type header',
      () {
        const request = HttpRequestModel(
          method: HTTPVerb.post,
          url: 'https://api.example.com/upload',
          headers: [
            NameValueModel(name: 'Authorization', value: 'Bearer token123'),
            NameValueModel(name: 'Content-Type', value: 'multipart/form-data'),
          ],
          bodyContentType: ContentType.formdata,
          formData: [
            FormDataModel(
              name: 'description',
              value: 'User Avatar',
              type: FormDataType.text,
            ),
            FormDataModel(
              name: 'photo',
              value: '/tmp/avatar.png',
              type: FormDataType.file,
            ),
          ],
        );
        final result = generator.generate(request: request);
        expect(result.contains("-H 'Authorization: Bearer token123'"), isTrue);
        // Content-Type should be omitted so curl sets correct boundary automatically
        expect(
          result.contains("-H 'Content-Type: multipart/form-data'"),
          isFalse,
        );
        expect(result.contains("-F 'description=User Avatar'"), isTrue);
        expect(result.contains("-F 'photo=@/tmp/avatar.png'"), isTrue);
      },
    );
  });

  group('CurlSessionGenerator - Appended Response Summary Comment', () {
    test('Omits response comment when response is null', () {
      const request = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.example.com/ping',
      );
      final result = generator.generate(request: request);
      expect(result.contains('# Response:'), isFalse);
    });

    test('Appends # Response: 200 OK (45 ms) for successful response', () {
      const request = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.example.com/ping',
      );
      const response = HttpResponseModel(
        statusCode: 200,
        time: Duration(milliseconds: 45),
      );
      final result = generator.generate(request: request, response: response);
      expect(
        result,
        "curl -X GET 'https://api.example.com/ping'\n\n# Response: 200 OK (45 ms)\n",
      );
    });

    test('Appends # Response: 404 Not Found (120 ms) for error response', () {
      const request = HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.example.com/missing',
      );
      const response = HttpResponseModel(
        statusCode: 404,
        time: Duration(milliseconds: 120),
      );
      final result = generator.generate(request: request, response: response);
      expect(
        result,
        "curl -X GET 'https://api.example.com/missing'\n\n# Response: 404 Not Found (120 ms)\n",
      );
    });
  });

  group('CurlSessionGenerator - Full Specification Conformance', () {
    test(
      'Matches exact specification structure with multi-line flags and response comment',
      () {
        const request = HttpRequestModel(
          method: HTTPVerb.post,
          url: 'https://api.example.com/v1/users',
          headers: [
            NameValueModel(name: 'Authorization', value: 'Bearer secret'),
            NameValueModel(name: 'Content-Type', value: 'application/json'),
          ],
          params: [NameValueModel(name: 'notify', value: 'true')],
          bodyContentType: ContentType.json,
          body: '{"username":"johndoe"}',
        );

        const response = HttpResponseModel(
          statusCode: 200,
          time: Duration(milliseconds: 45),
        );

        final result = generator.generate(request: request, response: response);

        final expected =
            "curl -X POST 'https://api.example.com/v1/users?notify=true' \\\n"
            "  -H 'Authorization: Bearer secret' \\\n"
            "  -H 'Content-Type: application/json' \\\n"
            "  --data '{\"username\":\"johndoe\"}'\n\n"
            "# Response: 200 OK (45 ms)\n";

        expect(result, expected);
      },
    );
  });
}
