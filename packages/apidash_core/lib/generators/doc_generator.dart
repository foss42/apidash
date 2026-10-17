import 'package:genai/genai.dart';

/// Abstract contract for generating API documentation and session exports
/// from [HttpRequestModel] and [HttpResponseModel].
abstract class DocGenerator {
  const DocGenerator();

  /// Generates documentation or session export string.
  ///
  /// [request]: The HTTP request model to document.
  /// [response]: The optional HTTP response model received.
  /// [requestName]: An optional human-readable name or title for the request.
  String generate({
    required HttpRequestModel request,
    HttpResponseModel? response,
    String? requestName,
  });
}
