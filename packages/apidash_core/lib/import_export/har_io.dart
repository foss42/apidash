import 'dart:convert';
import 'dart:developer' as developer;
import '../consts.dart';
import '../models/models.dart';
import '../utils/utils.dart';

class HarIO {
  List<HttpRequestModel>? getHttpRequestModelList(String content) {
    try {
      developer.log("Starting HAR parsing...", name: "HarIO");
      final harJson = jsonDecode(content);

      // Check that the JSON is a Map and contains the 'log' key.
      if (harJson is! Map || !harJson.containsKey('log')) {
        developer.log("HAR JSON missing 'log' key.", name: "HarIO");
        return null;
      }
      final log = harJson['log'];
      if (log is! Map || !log.containsKey('entries')) {
        developer.log("HAR JSON 'log' missing 'entries' key.", name: "HarIO");
        return null;
      }

      final List entries = log['entries'];
      developer.log("Found ${entries.length} entries in HAR.", name: "HarIO");
      List<HttpRequestModel> requestModels = [];

      // Iterate through the 'entries' array
      for (var entry in entries) {
        final request = entry['request'];
        if (request == null || request['method'] == null || request['url'] == null) {
          developer.log("Skipping entry: missing request, method, or URL.", name: "HarIO");
          continue;
        }
        final String method = request['method'];
        final String url = request['url'];

        // Process headers.
        Map<String, String> headersMap = {};
        if (request['headers'] is List) {
          for (var h in request['headers']) {
            if (h['name'] != null && h['value'] != null) {
              headersMap[h['name']] = h['value'];
            }
          }
        }
        final headers = mapToRows(headersMap);
        final params = mapToRows(Uri.parse(url).queryParameters);

        // Optionally extract the body from postData.
        final body = request.containsKey('postData')
            ? (request['postData']?['text'])
            : null;

        final ContentType contentType =
            getContentTypeFromHeadersMap(headersMap) ?? ContentType.text;

        requestModels.add(
          HttpRequestModel(
            method: HTTPVerb.values.byName(method.toLowerCase()),
            url: stripUrlParams(url),
            headers: headers,
            params: params,
            body: body,
            bodyContentType: contentType,
            formData: null,
          ),
        );
      }

      developer.log("Parsed ${requestModels.length} requests from HAR.", name: "HarIO");
      return requestModels;
    } catch (e, s) {
      developer.log("Failed to parse HAR file: $e", name: "HarIO", error: e, stackTrace: s);
      return null;
    }
  }
}