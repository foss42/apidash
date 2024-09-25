import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/utils/utils.dart';
import 'package:curl_converter/curl_converter.dart';

class CurlFileImport {
  HttpRequestModel? getHttpRequestModel(String content) {
    content = content.trim();
    try {
      final curl = Curl.parse(content);
      final url = stripUriParams(curl.uri);
      final method = HTTPVerb.values.byName(curl.method.toLowerCase());

      final headers = curl.headers?.entries
          .map((entry) => NameValueModel(
                name: entry.key,
                value: entry.value,
              ))
          .toList();

      final params = curl.uri.queryParameters.entries
          .map((entry) => NameValueModel(
                name: entry.key,
                value: entry.value,
              ))
          .toList();

      // TODO: parse curl data to determine the type of body
      final body = curl.data;

      return HttpRequestModel(
        method: method,
        url: url,
        headers: headers,
        params: params,
        body: body,
      );
    } catch (e) {
      return null;
    }
  }
}
