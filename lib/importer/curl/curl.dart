import 'package:apidash_core/apidash_core.dart';
import 'package:curl_parser/curl_parser.dart';

class CurlFileImport {
  HttpRequestModel? getHttpRequestModel(String content) {
    content = content.trim();
    try {
      final curl = Curl.parse(content);
      final url = stripUriParams(curl.uri);
      final method = HTTPVerb.values.byName(curl.method.toLowerCase());
      final headers = mapToRows(curl.headers);
      final params = mapToRows(curl.uri.queryParameters);
      final body = curl.data;
      final formData = curl.formData;

      // Determine content type based on form data and headers
      final bool hasJsonContentType = headers?.any((header) =>
              header.name == "Content-Type" &&
              header.value == "application/json") ??
          false;

      final ContentType contentType = curl.form
          ? ContentType.formdata
          : hasJsonContentType
              ? ContentType.json
              : ContentType.text;

      return HttpRequestModel(
          method: method,
          url: url,
          headers: headers,
          params: params,
          body: body,
          bodyContentType: contentType,
          formData: formData);
    } catch (e) {
      return null;
    }
  }
}
