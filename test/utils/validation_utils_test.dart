import 'package:apidash/utils/validation_utils.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('getValidationResult', () {
    test('returns error when url is empty', () {
      const req = HttpRequestModel(url: '   ');
      final result = getValidationResult(req);
      expect(result, 'Request URL is empty. Please provide a valid URL.');
    });

    test('returns error when GET request has body', () {
      const req = HttpRequestModel(
        url: 'https://api.test.com',
        method: HTTPVerb.get,
        bodyContentType: ContentType.text,
        body: 'Hello',
      );
      final result = getValidationResult(req);
      expect(result, 'GET request contains a body. This is not supported.');
    });

    test('returns error when JSON body is invalid', () {
      const req = HttpRequestModel(
        url: 'https://api.test.com',
        method: HTTPVerb.post,
        bodyContentType: ContentType.json,
        body: '{invalid_json}',
      );
      final result = getValidationResult(req);
      expect(result, startsWith('Invalid JSON in request body:'));
    });

    test('returns null when valid JSON', () {
      const req = HttpRequestModel(
        url: 'https://api.test.com',
        method: HTTPVerb.post,
        bodyContentType: ContentType.json,
        body: '{"key": "value"}',
      );
      final result = getValidationResult(req);
      expect(result, isNull);
    });

    test('returns null when valid request without body', () {
      const req = HttpRequestModel(
        url: 'https://api.test.com',
        method: HTTPVerb.get,
      );
      final result = getValidationResult(req);
      expect(result, isNull);
    });
  });
}
