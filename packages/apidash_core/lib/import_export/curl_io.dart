import 'package:curl_parser/curl_parser.dart';
import 'package:genai/genai.dart';
import '../utils/utils.dart';

class CurlIO {
  /// Parses a curl command string and converts it to a list of [HttpRequestModel].
  ///
  /// Returns a list containing a single [HttpRequestModel] if parsing succeeds,
  /// or null if parsing fails.
  List<HttpRequestModel>? getHttpRequestModelList(String content) {
    content = content.trim();
    try {
      final curl = Curl.parse(content);
      final httpRequestModel = convertCurlToHttpRequestModel(curl);
      return [httpRequestModel];
    } catch (e) {
      return null;
    }
  }
}
