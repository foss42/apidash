import 'package:apidash_core/apidash_core.dart';
import 'package:jinja/jinja.dart' as jj;
import 'package:path/path.dart' as path;

class SwiftAlamofireCodeGen {
  final String kTemplateStart = """
import Foundation
import Alamofire
""";

  final String kTemplateFormData = '''
let multipartFormData = MultipartFormData()
{% for param in formData %}    {% if param.type == 'text' %}multipartFormData.append(Data("{{param.value}}".utf8), withName: "{{param.name}}")    {% elif param.type == 'file' %}
let fileURL = URL(fileURLWithPath: "{{param.filepath}}")
multipartFormData.append(fileURL, withName: "{{param.name}}", fileName: "{{param.filename}}", mimeType: "application/octet-stream")
    {% endif %}
{% endfor %}
''';

  final String kTemplateJsonData = '''
let jsonString = """
{{jsonData}}
"""
let jsonData = jsonString.data(using: .utf8)\n
''';

  final String kTemplateTextData = '''
let textString = """
{{textData}}
"""
let textData = textString.data(using: .utf8)\n
''';

  final String kTemplateRequest = """
let url = "{{url}}"

{% if hasFormData %}
AF.upload(multipartFormData: multipartFormData, to: url, method: .{{method}}{% if hasHeaders %}, headers: {{headers}}{% endif %})
{% elif hasBody %}
AF.upload({% if hasJsonData %}jsonData{% else %}textData{% endif %}!, to: url, method: .{{method}}{% if hasHeaders %}, headers: {{headers}}{% endif %})
{% else %}
AF.request(url, method: .{{method}}{% if hasHeaders %}, headers: {{headers}}{% endif %})
{% endif %}
.responseData { response in
    switch response.result {
    case .success(let data):
        if let responseString = String(data: data, encoding: .utf8) {
            print("Response: \\(responseString)")
        }
    case .failure(let error):
        print("Error: \\(error)")
    }
    exit(0)
}

dispatchMain()
""";

  String? getCode(HttpRequestModel requestModel) {
    try {
      String result = kTemplateStart;

      var rec =
          getValidRequestUri(requestModel.url, requestModel.enabledParams);
      Uri? uri = rec.$1;

      var headers = requestModel.enabledHeadersMap;

      bool hasBody = false;
      bool hasJsonData = false;
      if (requestModel.hasFormData) {
        var formDataList = requestModel.formDataMapList.map((param) {
          if (param['type'] == 'file') {
            final filePath = param['value'] as String;
            final fileName = path.basename(filePath);
            return {
              'type': 'file',
              'name': param['name'],
              'filename': fileName,
              'filepath': filePath
            };
          } else {
            return {
              'type': 'text',
              'name': param['name'],
              'value': param['value']
            };
          }
        }).toList();

        var templateFormData = jj.Template(kTemplateFormData);
        result += templateFormData.render({
          "formData": formDataList,
        });

        hasBody = true;
      } else if (requestModel.hasJsonData) {
        var templateJsonData = jj.Template(kTemplateJsonData);
        result += templateJsonData.render({
          "jsonData":
              requestModel.body!.replaceAll('"', '\\"').replaceAll('\n', '\\n'),
        });

        headers.putIfAbsent("Content-Type", () => "application/json");
        hasBody = true;
        hasJsonData = true;
      }
      // Handle text data
      else if (requestModel.hasTextData) {
        var templateTextData = jj.Template(kTemplateTextData);
        result += templateTextData.render({
          "textData":
              requestModel.body!.replaceAll('"', '\\"').replaceAll('\n', '\\n'),
        });

        headers.putIfAbsent(
            kHeaderContentType, () => requestModel.bodyContentType.header);
        hasBody = true;
      }

      String headersString = "nil";
      bool hasHeaders = false;
      if (headers.isNotEmpty) {
        List<String> headerItems = [];
        headers.forEach((key, value) {
          headerItems.add('"$key": "$value"');
        });
        headersString = "[${headerItems.join(', ')}]";
        hasHeaders = true;
      }

      var templateRequest = jj.Template(kTemplateRequest);
      result += templateRequest.render({
        "url": uri.toString(),
        "method": requestModel.method.name.toLowerCase(),
        "headers": headersString,
        "hasHeaders": hasHeaders,
        "hasFormData": requestModel.hasFormData,
        "hasBody": hasBody,
        "hasJsonData": hasJsonData
      });

      return result;
    } catch (e) {
      return null;
    }
  }
}
