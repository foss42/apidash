import 'package:apidash_core/apidash_core.dart';

String? getValidationResult(HttpRequestModel requestModel) {
  if (requestModel.url.trim().isEmpty) {
    return 'Request URL is empty. Please provide a valid URL.';
  }
  if (requestModel.method == HTTPVerb.get && requestModel.hasAnyBody) {
    return 'GET request contains a body. This is not supported.';
  }
  if (requestModel.hasJsonData) {
    try {
      kJsonDecoder.convert(requestModel.body!);
    } catch (e) {
      return 'Invalid JSON in request body: ${e.toString()}';
    }
  }
  return null;
}

