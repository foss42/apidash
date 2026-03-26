import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';
import 'package:apidash/utils/validation_utils.dart';
import '../models/http_request_models.dart';

void main() {
  group("Testing getValidationResult", () {
    test('returns error for empty URL', () {
      const model = HttpRequestModel(
        method: HTTPVerb.get,
        url: '',
      );
      expect(
        getValidationResult(model),
        'Request URL is empty. Please provide a valid URL.',
      );
    });

    test('returns error for whitespace-only URL', () {
      const model = HttpRequestModel(
        method: HTTPVerb.get,
        url: '   ',
      );
      expect(
        getValidationResult(model),
        'Request URL is empty. Please provide a valid URL.',
      );
    });

    test('returns error for GET request with body', () {
      // httpRequestModelGet7 has bodyContentType: ContentType.text and a body
      expect(
        getValidationResult(httpRequestModelGet7),
        'GET request contains a body. This is not supported.',
      );
    });

    test('returns error for invalid JSON body', () {
      const model = HttpRequestModel(
        method: HTTPVerb.post,
        url: 'https://api.apidash.dev',
        bodyContentType: ContentType.json,
        body: '{invalid json}',
      );
      final result = getValidationResult(model);
      expect(result, isNotNull);
      expect(result, contains('Invalid JSON in request body'));
    });

    test('returns null for valid GET request without body', () {
      // httpRequestModelGet1 = basic GET to https://api.apidash.dev
      expect(getValidationResult(httpRequestModelGet1), isNull);
    });

    test('returns null for valid POST with JSON body', () {
      // httpRequestModelPost3 = POST with valid JSON body and ContentType.json
      expect(getValidationResult(httpRequestModelPost3), isNull);
    });

    test('returns null for POST with text body (skips JSON validation)', () {
      // httpRequestModelPost1 = POST with text body, ContentType.text
      expect(getValidationResult(httpRequestModelPost1), isNull);
    });
  });
}
