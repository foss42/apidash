import '../../models/request_model.dart';

class CLibcurlCodeGen {
  String getCode(RequestModel requestModel, String defaultUriScheme) {
    try {
      StringBuffer result = StringBuffer();

      // Include necessary C libraries
      result.writeln('#include <stdio.h>');
      result.writeln('#include <stdlib.h>');
      result.writeln('#include <curl/curl.h>\n');

      // Compiling instructions
      result.writeln('/*\nCompiling with libcurl');
      result.writeln('\$ gcc <filename>.c -lcurl -o <executable-name>\n*/\n');

      // Main function
      result.writeln('int main() {');

      // Initialize libcurl
      result.writeln('  CURL *curl;');
      result.writeln('  CURLcode res;');
      result.writeln('  curl = curl_easy_init();\n');
      result.writeln('  if(curl) {');

      // Set URL
      String url = requestModel.url;
      if (!url.contains("://")) {
        url = "$defaultUriScheme://$url";
      }
      result.writeln('    curl_easy_setopt(curl, CURLOPT_URL, "$url");');

      // Set request method
      result.writeln(
          '    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "${requestModel.method}");\n');

      // Set request headers
      var headersList = requestModel.enabledRequestHeaders;
      if (headersList != null && headersList.isNotEmpty) {
        result.writeln('    struct curl_slist *headers = NULL;');
        for (var header in headersList) {
          result.writeln(
              '    headers = curl_slist_append(headers, "${header.name}: ${header.value}");');
        }
        result.writeln('    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);\n');
      }

      // Set request body if exists
      var requestBody = requestModel.requestBody;
      if (requestBody != null && requestBody.isNotEmpty) {
        result.writeln(
            '    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, "${Uri.encodeComponent(requestBody)}");\n');
      }

      // Perform the request
      result.writeln('    res = curl_easy_perform(curl);');
      result.writeln('    if(res != CURLE_OK) {');
      result.writeln(
          '      fprintf(stderr, "curl_easy_perform() failed: %s\\n", curl_easy_strerror(res));');
      result.writeln('    }\n');

      // Cleanup libcurl resources
      result.writeln('    curl_easy_cleanup(curl);');
      if (headersList != null && headersList.isNotEmpty) {
        result.writeln('    curl_slist_free_all(headers);');
      }
      result.writeln('  }\n');

      // Return code
      result.writeln('  return 0;');

      // Close main function
      result.writeln('}');

      return result.toString();
    } catch (e) {
      return '';
    }
  }
}
