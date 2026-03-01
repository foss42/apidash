import 'package:apidash/utils/validation_utils.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Testing validation_utils', () {
    test('Testing getValidationResult function', () {
      // Test case 1: Valid GET request, should return null (no error)
      var requestModel1 = const HttpRequestModel()
          .copyWith(method: HTTPVerb.get, url: 'https://api.apidash.dev');
      expect(getValidationResult(requestModel1), null);

      // Test case 2: Empty URL, should return an error message
      var requestModel2 =
          const HttpRequestModel().copyWith(method: HTTPVerb.get, url: ' ');
      expect(getValidationResult(requestModel2),
          'Request URL is empty. Please provide a valid URL.');

      // Test case 3: GET request with a body, should return an error message
      var requestModel3 = const HttpRequestModel().copyWith(
          method: HTTPVerb.get, url: 'https://api.apidash.dev', body: '{}');
      expect(getValidationResult(requestModel3),
          'GET request contains a body. This is not supported.');

      // Test case 4: POST request with invalid JSON, should return an error message
      var requestModel4 = const HttpRequestModel().copyWith(
          method: HTTPVerb.post,
          url: 'https://api.apidash.dev',
          body: '{"a":,}',
          bodyContentType: ContentType.json);
      expect(getValidationResult(requestModel4),
          startsWith('Invalid JSON in request body:'));

      // Test case 5: Valid POST request with valid JSON body, should return null
      var requestModel5 = const HttpRequestModel().copyWith(
          method: HTTPVerb.post,
          url: 'https://api.apidash.dev',
          body: '{"a": 1}',
          bodyContentType: ContentType.json);
      expect(getValidationResult(requestModel5), null);
    });
  });
}
