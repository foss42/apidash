import 'package:curl_parser/curl_parser.dart';
import 'package:genai/genai.dart';
import '../utils/utils.dart';

class CurlIO {
  /// Parses curl command(s) from a string and converts them to a list of [HttpRequestModel].
  ///
  /// Supports both single and multiple curl commands in the content string.
  /// Multiple commands should be separated by newlines or whitespace.
  /// Skips curl commands that fail to parse and only returns successfully parsed models.
  ///
  /// Returns a list of [HttpRequestModel] if at least one curl command is successfully parsed,
  /// or null if no valid curl commands are found.
  List<HttpRequestModel>? getHttpRequestModelList(String content) {
    content = content.trim();
    
    // Split content into potential curl commands
    final curlCommands = splitCurlCommands(content);
    
    // Parse each curl command, skipping those that fail
    final httpRequestModels = <HttpRequestModel>[];
    for (final curlCommand in curlCommands) {
      try {
        final curl = Curl.parse(curlCommand);
        final httpRequestModel = convertCurlToHttpRequestModel(curl);
        httpRequestModels.add(httpRequestModel);
      } catch (e) {
        // Skip curls that fail to parse
        continue;
      }
    }
    
    return httpRequestModels.isEmpty ? null : httpRequestModels;
  }
}
