import 'package:apidash/models/request_model.dart';
import 'package:apidash/utils/har_utils.dart';

class GoNetHttpCodeGen {
  GoNetHttpCodeGen();

  String kStringImportGo(bool isBodyPresent) => """
package main

import (
  "fmt"
  "io"
  "net/http"${isBodyPresent ? '\n  "strings"' : ''}
)\n
""";

  String kTemplateStart = """func main() {
  url := "%s"
  method := "%s"\n""";

  String kTemplateHeader = """  headers := map[string]string{
%s
  }\n""";

  String kTemplateBody = """%s""";

  String kStringRequest = """
  if err != nil {
    fmt.Println("Error creating request:", err)
    return
  }

  // Set headers
  for key, value := range headers {
    req.Header.Set(key, value)
  }

  // Make the HTTP request
  client := &http.Client{}
  resp, err := client.Do(req)
  if err != nil {
    fmt.Println("Error making request:", err)
    return
  }
  defer resp.Body.Close()

  fmt.Printf("%s\\n%s\\n\\n", resp.Status, resp.Header)

  // Read and print the response
  bodyText, err := io.ReadAll(resp.Body)
  if err != nil {
    fmt.Println("Error reading response body:", err)
    return
  }
  fmt.Println(string(bodyText))
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
          headers += '    "${header['name']}": "${header['value']}",\n';
        }
        result += kTemplateHeader.replaceAll('%s', headers.trimRight());
      } else {
        result += '  headers := map[string]string{}\n';
      }

      // Add body if present
      if (isBodyPresent) {
        result += kTemplateBody.replaceAll('%s',
            '${'  body := strings.NewReader(`${harJson['postData']['text']}'}`)\n');
      }

      result +=
          '''\n  req, err := http.NewRequest(method, url, ${isBodyPresent ? 'body' : 'nil'})\n''';

      // Add the request execution code
      result += kStringRequest;

      return result;
    } catch (e) {
      return null;
    }
  }
}
