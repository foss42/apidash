import 'package:apidash/consts.dart';
import 'package:apidash/models/http_request_model.dart';
import 'package:apidash/models/name_value_model.dart';
import 'package:apidash/models/request_model.dart';
import 'package:curl_converter/curl_converter.dart';

class CurlFileImport {
  RequestModel? getRequestModel(String contents, String newId) {
    if (contents.endsWith('\n')) {
      contents = contents.substring(0, contents.length - 1);
    }

    try {
      final curl = Curl.parse(contents);

      final method = HTTPVerb.values.byName(curl.method.toLowerCase());

      final uri = curl.uri.toString();
      final url = uri.substring(0, uri.lastIndexOf('?'));

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

      final body = curl.data;

      return RequestModel(
        id: newId,
        httpRequestModel: HttpRequestModel(
          method: method,
          url: url,
          headers: headers,
          params: params,
          body: body,
        ),
      );
    } catch (e) {
      print(e);
      return null;
    }
  }
}
