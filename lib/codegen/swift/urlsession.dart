import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/utils/utils.dart' show getValidRequestUri;
import 'package:jinja/jinja.dart' as jj;

class SwiftURLSessionCodeGen {
  final String kTemplateStart = """
import Foundation

""";

  final String kTemplateFormData = '''
let parameters = [
{% for param in formData %}
  [
    "key": "{{param.name}}",
    "value": "{{param.value}}",
    "type": "{{param.type}}"{% if param.contentType %},
    "contentType": "{{param.contentType}}"{% endif %}
  ],
{% endfor %}
] as [[String: Any]]
let boundary = "Boundary-\\(UUID().uuidString)"
var body = Data()
var error: Error? = nil
for param in parameters {
  if param["disabled"] as? Bool == true { continue }
  let paramName = param["key"] as! String
  body.append("--\\(boundary)\\r\\n".data(using: .utf8)!)
  body.append("Content-Disposition:form-data; name=\\"\\(paramName)\\"".data(using: .utf8)!)
  if let contentType = param["contentType"] as? String {
    body.append("\\r\\nContent-Type: \\(contentType)".data(using: .utf8)!)
  }
  let paramType = param["type"] as! String
  if paramType == "text" {
    let paramValue = param["value"] as! String
    body.append("\\r\\n\\r\\n\\(paramValue)\\r\\n".data(using: .utf8)!)
  } else if paramType == "file" {
    let paramSrc = param["value"] as! String
    let fileURL = URL(fileURLWithPath: paramSrc)
    if let fileContent = try? Data(contentsOf: fileURL) {
      body.append("; filename=\\"\\(paramSrc)\\"\\r\\n".data(using: .utf8)!)
      body.append("Content-Type: \\"content-type header\\"\\r\\n\\r\\n".data(using: .utf8)!)
      body.append(fileContent)
      body.append("\\r\\n".data(using: .utf8)!)
    }
  }
}
body.append("--\\(boundary)--\\r\\n".data(using: .utf8)!)
let postData = body

''';

  final String kTemplateJsonData = '''
let parameters = "{{jsonData}}"
let postData = parameters.data(using: .utf8)

''';

  final String kTemplateTextData = '''
let parameters = "{{textData}}"
let postData = parameters.data(using: .utf8)

''';

  final String kTemplateRequest = """
var request = URLRequest(url: URL(string: "{{url}}")!,timeoutInterval: Double.infinity)
request.httpMethod = "{{method}}"

""";

  final String kTemplateHeaders = """
{% for header, value in headers %}
request.addValue("{{value}}", forHTTPHeaderField: "{{header}}")
{% endfor %}

""";

  final String kTemplateBody = """
request.httpBody = postData

""";

  final String kTemplateEnd = """
let task = URLSession.shared.dataTask(with: request) { data, response, error in 
  guard let data = data else {
    print(String(describing: error))
    return
  }
  print(String(data: data, encoding: .utf8)!)
}
task.resume()
""";

  String? getCode(HttpRequestModel requestModel) {
    try {
      String result = kTemplateStart;

      var rec =
          getValidRequestUri(requestModel.url, requestModel.enabledParams);
      Uri? uri = rec.$1;

      if (requestModel.hasFormData) {
        var templateFormData = jj.Template(kTemplateFormData);
        result += templateFormData.render({
          "formData": requestModel.formDataMapList,
        });
      } else if (requestModel.hasJsonData) {
        var templateJsonData = jj.Template(kTemplateJsonData);
        result += templateJsonData.render({
          "jsonData":
              requestModel.body!.replaceAll('"', '\\"').replaceAll('\n', '\\n'),
        });
      } else if (requestModel.hasTextData) {
        var templateTextData = jj.Template(kTemplateTextData);
        result += templateTextData.render({
          "textData":
              requestModel.body!.replaceAll('"', '\\"').replaceAll('\n', '\\n'),
        });
      }

      var templateRequest = jj.Template(kTemplateRequest);
      result += templateRequest.render({
        "url": uri.toString(),
        "method": requestModel.method.name.toUpperCase()
      });

      var headers = requestModel.enabledHeadersMap;
      if (requestModel.hasFormData) {
        headers.putIfAbsent(kHeaderContentType,
            () => "multipart/form-data; boundary=\\(boundary)");
      } else if (requestModel.hasJsonData || requestModel.hasTextData) {
        headers.putIfAbsent(
            kHeaderContentType, () => requestModel.bodyContentType.header);
      }
      if (headers.isNotEmpty) {
        var templateHeader = jj.Template(kTemplateHeaders);
        result += templateHeader.render({"headers": headers});
      }

      if (requestModel.hasBody) {
        result += kTemplateBody;
      }

      result += kTemplateEnd;

      return result;
    } catch (e) {
      return null;
    }
  }
}
