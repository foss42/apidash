import 'package:apidash/models/request_model.dart';
import 'package:apidash/utils/har_utils.dart';

class SwiftUrlsessionCodeGen {
  SwiftUrlsessionCodeGen();

  String template = """import Foundation

let group = DispatchGroup()
group.enter()

var request = URLRequest(url: URL(string: "%URL%")!)
request.httpMethod = "%METHOD%"
%HEADER%%BODY%
let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
    defer { group.leave() }

    if let error = error {
        print("Error: \\(error)")
    } else if let httpResponse = response as? HTTPURLResponse {
        print("Status Code: \\(httpResponse.statusCode)")

        if let data = data, let bodyText = String(data: data, encoding: .utf8) {
            if (200..<300).contains(httpResponse.statusCode) {
                print("Response Body: \\(bodyText)")
            } else {
                print("Error Response Body: \\(bodyText)")
            }
        }
    }
}

task.resume()
group.wait()
""";

  String? getCode(
    RequestModel requestModel,
    String defaultUriScheme,
  ) {
    try {
      // Fill in the URL and method in the template
      var harJson =
          requestModelToHARJsonRequest(requestModel, useEnabled: true);

      var result = template
          .replaceFirst('%URL%', harJson['url'])
          .replaceFirst('%METHOD%', harJson['method'].toUpperCase());

      // Add headers if present
      if (harJson['headers'] != null && harJson['headers'].isNotEmpty) {
        var headers = '';
        for (var header in harJson['headers']) {
          headers +=
              'request.addValue("${header['value']}", forHTTPHeaderField: "${header['name']}")\n';
        }
        result = result.replaceFirst("%HEADER%", headers);
      } else {
        result = result.replaceFirst("%HEADER%", "");
      }

      result = result.replaceFirst(
          "%BODY%",
          !(harJson['postData'] != null && harJson['postData']['text'] != null)
              ? ""
              : """\nrequest.httpBody = \"\""
${harJson['postData']['text']}
\"\"\".data(using: .utf8)!
""");

      return result;
    } catch (e) {
      return null;
    }
  }
}
