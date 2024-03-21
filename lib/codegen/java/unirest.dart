import 'dart:convert';
import 'package:apidash/utils/har_utils.dart';
import 'package:apidash/utils/http_utils.dart';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/models/models.dart' show RequestModel;
import 'package:apidash/consts.dart';

class JavaUnirestGen {
  final String kTemplateUnirestImports = '''
import kong.unirest.core.*;\n
''';

  final String kTemplateFileIoImports = '''
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;\n
''';
  final String kTemplateStart = '''
public class Main {
    public static void main(String[] args) {
''';

  final String kTemplateUrl = '''
        final String requestURL = "{{url}}";\n
''';

  final String kTemplateRequestBodyContent = '''
        final String requestBody = "{{body}}";\n
''';

  final String kTemplateRequestCreation = '''
        HttpResponse<JsonNode> response = Unirest
                .{{method}}(requestURL)\n
''';

  final String kTemplateRequestHeader = '''
                .header("{{name}}", "{{value}}")\n
''';

  final String kTemplateContentType = '''
                .contentType("{{contentType}}")\n
''';

  final String kTemplateUrlQueryParam = '''
                .queryString("{{name}}", "{{value}}")\n
''';

  final String kTemplateRequestTextFormData = '''
                .field("{{name}}", "{{value}}")\n
''';

  final String kTemplateRequestFileFormData = '''
                .field("{{name}}", new File("{{value}}"))\n
''';

  final String kTemplateRequestBodySetup = '''
                .body(requestBody)\n
''';

  final String kTemplateBoundarySetup = '''
                .boundary("{{boundary}}")\n
''';

  final String kTemplateRequestEnd = """
                .asJson();
        System.out.println(response.getStatus());
        System.out.println(response.getBody());
    }
}\n
""";

  String? getCode(RequestModel requestModel, String? boundary) {
    try {
      String result = '';
      bool hasBody = false;
      var rec = getValidRequestUri(
        requestModel.url,
        requestModel.enabledRequestParams,
      );

      // uri is already generated based on url and enabled request params
      Uri? uri = rec.$1;

      if (uri == null) {
        return "";
      }

      // this is the common import and will be imported for every generated code snippet
      result += kTemplateUnirestImports;

      // java file io packages are to be imported only when there is a form with file present
      if (requestModel.hasBody &&
          kMethodsWithBody.contains(requestModel.method) &&
          requestModel.hasFormData &&
          requestModel.hasFileInFormData) {
        result += kTemplateFileIoImports;
      }

      // adding the main method under Main class
      result += kTemplateStart;

      var url = stripUriParams(uri);

      // contains the HTTP method associated with the request
      var method = requestModel.method;

      // contains the entire request body as a string if body is present
      var requestBody = requestModel.requestBody;

      // generating the URL to which the request has to be submitted
      var templateUrl = jj.Template(kTemplateUrl);
      result += templateUrl.render({"url": url});

      // creating request body if available
      var rM = requestModel.copyWith(url: url);
      var harJson = requestModelToHARJsonRequest(rM, useEnabled: true);

      // if request type is not form data, the request method can include
      // a body, and the body of the request is not null, in that case
      // we need to parse the body as it is, and write it to the body
      if (!requestModel.hasFormData &&
          kMethodsWithBody.contains(method) &&
          requestBody != null) {
        // find out the content length for the request, i.e. request body's size
        var contentLength = utf8.encode(requestBody).length;
        if (contentLength > 0) {
          var templateBodyContent = jj.Template(kTemplateRequestBodyContent);
          hasBody = true;
          if (harJson["postData"]?["text"] != null) {
            result += templateBodyContent.render({
              "body": kEncoder.convert(harJson["postData"]["text"]).substring(
                  1, kEncoder.convert(harJson["postData"]["text"]).length - 1)
            });
          }
        }
      }

      var templateRequestCreation = jj.Template(kTemplateRequestCreation);
      result +=
          templateRequestCreation.render({"method": method.name.toLowerCase()});


      return result;
    } catch (e) {
      return null;
    }
  }
}
