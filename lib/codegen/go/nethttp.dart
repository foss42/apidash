import 'package:apidash/models/request_model.dart';
import 'package:apidash/utils/har_utils.dart';

class GoNetHttpCodeGen {
  GoNetHttpCodeGen();

  String kStringImportGo(bool isBodyPresent) => """
package main

import (
\t"fmt"
\t"io"
\t"net/http"${isBodyPresent ? '\n\t"strings"' : ''}
)\n
""";

  String kTemplateStart = """func main() {
\turl := "%s"
\tmethod := "%s"\n""";

  String kTemplateHeader = """\theaders := map[string]string{
%s
\t}\n""";

  String kTemplateBody = """%s""";

  String kStringRequest = """
\tif err != nil {
\t\tfmt.Println("Error creating request:", err)
\t\treturn
\t}

\t// Set headers
\tfor key, value := range headers {
\t\treq.Header.Set(key, value)
\t}

\t// Make the HTTP request
\tclient := &http.Client{}
\tresp, err := client.Do(req)
\tif err != nil {
\t\tfmt.Println("Error making request:", err)
\t\treturn
\t}
\tdefer resp.Body.Close()

\tfmt.Printf("%s\\n%s\\n\\n", resp.Status, resp.Header)

\t// Read and print the response
\tbodyText, err := io.ReadAll(resp.Body)
\tif err != nil {
\t\tfmt.Println("Error reading response body:", err)
\t\treturn
\t}
\tfmt.Println(string(bodyText))
}
""";

  String? getCode(
    RequestModel requestModel,
    String defaultUriScheme,
  ) {
    try {
      // Fill in the URL and method in the template
      var harJson =
          requestModelToHARJsonRequest(requestModel, useEnabled: true);

      bool isBodyPresent =
          harJson['postData'] != null && harJson['postData']['text'] != null;

      var result = kStringImportGo(isBodyPresent);

      result += kTemplateStart.replaceFirst('%s', harJson['url']).replaceFirst(
          '%s', harJson['method'].toUpperCase()); // Convert to uppercase

      // Add headers if present
      if (harJson['headers'] != null && harJson['headers'].isNotEmpty) {
        var headers = '';
        for (var header in harJson['headers']) {
          headers += '\t\t"${header['name']}": "${header['value']}",\n';
        }
        result += kTemplateHeader.replaceAll('%s', headers.trimRight());
      } else {
        result += '\theaders := map[string]string{}\n';
      }

      // Add body if present
      if (isBodyPresent) {
        result += kTemplateBody.replaceAll('%s',
            '${'\tbody := strings.NewReader(`${harJson['postData']['text']}'}`)\n');
      }

      result +=
          '''\n\treq, err := http.NewRequest(method, url, ${isBodyPresent ? 'body' : 'nil'})\n''';

      // Add the request execution code
      result += kStringRequest;

      return result;
    } catch (e) {
      return null;
    }
  }
}
