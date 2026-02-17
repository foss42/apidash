import 'package:curl_parser/curl_parser.dart';
import 'package:genai/genai.dart';

/// Converts a [Curl] model to an [HttpRequestModel].
///
/// Extracts URL, method, headers, query parameters, body, and form data
/// from the provided [Curl] object and creates an [HttpRequestModel].
///
/// Returns the converted [HttpRequestModel].
HttpRequestModel convertCurlToHttpRequestModel(Curl curl) {
  final url = stripUriParams(curl.uri);
  final method = HTTPVerb.values.byName(curl.method.toLowerCase());
  final headers = mapToRows(curl.headers);
  final params = mapToRows(curl.uri.queryParameters);
  final body = curl.data;
  // TODO: formdata with file paths must be set to empty as
  // there will be permission issue while trying to access the path
  final formData = curl.formData;
  // Determine content type based on form data and headers
  final ContentType contentType = curl.form
      ? ContentType.formdata
      : (getContentTypeFromHeadersMap(curl.headers) ?? ContentType.text);

  return HttpRequestModel(
    method: method,
    url: url,
    headers: headers,
    params: params,
    body: body,
    bodyContentType: contentType,
    formData: formData,
  );
}
