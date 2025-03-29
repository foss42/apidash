import 'package:apidash_core/apidash_core.dart';
import 'package:jinja/jinja.dart' as jj;
import 'package:path/path.dart' as path;

class SwiftURLSessionCodeGen {
  final String kTemplateStart = """
import Foundation

""";

  final String kTemplateFormDataImport = """
import MultipartFormData

""";

  final String kTemplateFormData = '''
let boundary = try! Boundary()
let multipartFormData = try! MultipartFormData(boundary: boundary) {
{% for param in formData %}
    {% if param.type == 'text' %}
    Subpart {
        ContentDisposition(name: "{{param.name}}")
    } body: {
        Data("{{param.value}}".utf8)
    }
    {% elif param.type == 'file' %}
    try Subpart {
        ContentDisposition(name: "{{param.name}}", filename: "{{param.filename}}")
        ContentType(mimeType: MimeType(pathExtension: "{{param.extension}}"))
    } body: {
        try Data(contentsOf: URL(fileURLWithPath: "{{param.filepath}}"))
    }
    {% endif %}
{% endfor %}
}

''';

  final String kTemplateJsonData = '''
let postData = """
{{jsonData}}
""".data(using: .utf8)

''';

  final String kTemplateTextData = '''
let postData = """
{{textData}}
""".data(using: .utf8)

''';

  final String kTemplateRequest = """
var request = URLRequest(url: URL(string: "{{url}}")!)
request.httpMethod = "{{method}}"

""";

  final String kTemplateHeaders = """
{% for header, value in headers %}
request.addValue("{{value}}", forHTTPHeaderField: "{{header}}")
{% endfor %}

""";

  final String kTemplateFormDataBody = """
request.httpBody = try! multipartFormData.encode()
""";

  final String kTemplateJsonTextBody = """
request.httpBody = postData

""";

  final String kTemplateEnd = """
let semaphore = DispatchSemaphore(value: 0) 

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
    defer { semaphore.signal() }  

    if let error = error {
        print("Error: \\(error.localizedDescription)")
        return
    }
    guard let data = data else {
        print("No data received")
        return
    }
    if let responseString = String(data: data, encoding: .utf8) {
        print("Response: \\(responseString)")
    }
}

task.resume()

semaphore.wait()
""";


  String? getCode(HttpRequestModel requestModel) {
    try {
      String result = kTemplateStart;

      var rec = getValidRequestUri(requestModel.url, requestModel.enabledParams);
      Uri? uri = rec.$1;

      if (requestModel.hasFormData) {
        result += kTemplateFormDataImport;
        
        var formDataList = requestModel.formDataMapList.map((param) {
          if (param['type'] == 'file') {
            final filePath = param['value'] as String;
            final fileName = path.basename(filePath);
            final fileExtension = 
                path.extension(fileName).toLowerCase().replaceFirst('.', '');
            return {
              'type': 'file',
              'name': param['name'],
              'filename': fileName,
              'extension': fileExtension,
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
      } 
      // Handle JSON data
      else if (requestModel.hasJsonData) {
        var templateJsonData = jj.Template(kTemplateJsonData);
        result += templateJsonData.render({
          "jsonData": requestModel.body!
                    });
      } 
      // Handle text data
      else if (requestModel.hasTextData) {
        var templateTextData = jj.Template(kTemplateTextData);
        result += templateTextData.render({
          "textData": requestModel.body!
        });
      }

      var templateRequest = jj.Template(kTemplateRequest);
      result += templateRequest.render({
        "url": uri.toString(),
        "method": requestModel.method.name.toUpperCase()
      });

      var headers = requestModel.enabledHeadersMap;
      if (requestModel.hasFormData) {
        headers['Content-Type'] = 
            "multipart/form-data; boundary=\\(boundary.stringValue)";
      } else if(requestModel.hasJsonData||requestModel.hasTextData){
        headers['Content-Type'] = 'application/json';
    }

      if (headers.isNotEmpty) {
        var templateHeader = jj.Template(kTemplateHeaders);
        result += templateHeader.render({"headers": headers});
      }

      if (requestModel.hasFormData) {
        result += kTemplateFormDataBody;
      } else if (requestModel.hasJsonData || requestModel.hasTextData) {
        result += kTemplateJsonTextBody;
      }

      result += kTemplateEnd;

      return result;
    } catch (e) {
      return null;
    }
  }
}
