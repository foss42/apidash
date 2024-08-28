import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/utils/utils.dart' show getValidRequestUri;
import 'package:jinja/jinja.dart' as jj;

class SwiftURLSessionCodeGen {
  final String kTemplateStart = """
import Foundation

""";

  final String kTemplateParameters = '''
let parameters = "{{parameters}}"
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


      if (requestModel.hasJsonData || requestModel.hasTextData) {
        var templateParameters = jj.Template(kTemplateParameters);
        result += templateParameters.render({
          "parameters":
              requestModel.body!.replaceAll('"', '\\"').replaceAll('\n', '\\n')
        });
      }

      var templateRequest = jj.Template(kTemplateRequest);
      result += templateRequest.render({
        "url": uri.toString(),
        "method": requestModel.method.name.toUpperCase()
      });

      var headers = requestModel.enabledHeadersMap;
      if (requestModel.hasJsonData || requestModel.hasTextData) {
        headers.putIfAbsent(
            kHeaderContentType, () => requestModel.bodyContentType.header);
      }
      if (headers.isNotEmpty) {
        var templateHeader = jj.Template(kTemplateHeaders);
        result += templateHeader.render({"headers": headers});
      }

      if (requestModel.hasTextData || requestModel.hasJsonData) {
        result += kTemplateBody;
      }

      result += kTemplateEnd;

      return result;
    } catch (e) {
      return null;
    }
  }
}
