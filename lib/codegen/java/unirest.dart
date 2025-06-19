import 'package:apidash_core/apidash_core.dart';
import 'package:jinja/jinja.dart' as jj;

class JavaUnirestGen {
  final String kStringUnirestImports = '''
import kong.unirest.core.*;

''';

  final String kStringFileIoImports = '''
import java.io.File;

''';
  final String kStringStart = '''
public class Main {
    public static void main(String[] args) {
''';

  final String kTemplateUrl = '''
        final String requestURL = "{{url}}";\n
''';

  final String kTemplateRequestBodyContent = '''
        final String requestBody = """
{{body}}""";

''';

  final String kTemplateRequestCreation = '''
        HttpResponse<JsonNode> response = Unirest
                .{{method}}(requestURL)\n
''';

  final String kTemplateRequestHeader = '''
                .header("{{name}}", "{{value}}")\n
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

  final String kStringRequestBodySetup = '''
                .body(requestBody)
''';

  final String kStringRequestEnd = """
                .asJson();
        System.out.println(response.getStatus());
        System.out.println(response.getBody());
    }
}
""";

  String? getCode(HttpRequestModel requestModel) {
    try {
      String result = '';
      bool hasBody = false;

      var rec = getValidRequestUri(
        requestModel.url,
        requestModel.enabledParams,
      );

      // uri is already generated based on url and enabled request params
      Uri? uri = rec.$1;

      if (uri == null) {
        return "";
      }

      // this is the common import and will be imported for every generated code snippet
      result += kStringUnirestImports;

      // java file io packages are to be imported only when there is a form with file present
      if (requestModel.hasFormData && requestModel.hasFileInFormData) {
        result += kStringFileIoImports;
      }

      // adding the main method under Main class
      result += kStringStart;

      var url = stripUriParams(uri);

      // generating the URL to which the request has to be submitted
      var templateUrl = jj.Template(kTemplateUrl);
      result += templateUrl.render({"url": url});

      // if request type is not form data, the request method can include
      // a body, and the body of the request is not null, in that case
      // we need to parse the body as it is, and write it to the body
      if (requestModel.hasTextData || requestModel.hasJsonData) {
        var templateBodyContent = jj.Template(kTemplateRequestBodyContent);
        result += templateBodyContent.render({
          "body": requestModel.body,
        });
        hasBody = true;
      }

      var templateRequestCreation = jj.Template(kTemplateRequestCreation);
      result += templateRequestCreation
          .render({"method": requestModel.method.name.toLowerCase()});

      // ~~~~~~~~~~~~~~~~~~ request header start ~~~~~~~~~~~~~~~~~~

      var headers = requestModel.enabledHeadersMap;
      if (hasBody && !requestModel.hasContentTypeHeader) {
        headers[kHeaderContentType] = requestModel.bodyContentType.header;
      }

      var templateRequestHeader = jj.Template(kTemplateRequestHeader);
      // setting up rest of the request headers
      headers.forEach((name, value) {
        result += templateRequestHeader.render({"name": name, "value": value});
      });

      // ~~~~~~~~~~~~~~~~~~ request header ends ~~~~~~~~~~~~~~~~~~

      // ~~~~~~~~~~~~~~~~~~ query parameters start ~~~~~~~~~~~~~~~~~~

      if (uri.hasQuery) {
        var params = uri.queryParameters;
        var templateUrlQueryParam = jj.Template(kTemplateUrlQueryParam);
        params.forEach((name, value) {
          result +=
              templateUrlQueryParam.render({"name": name, "value": value});
        });
      }

      // ~~~~~~~~~~~~~~~~~~ query parameters end ~~~~~~~~~~~~~~~~~~

      // handling form data
      if (requestModel.hasFormData) {
        // including form data into the request
        var templateRequestTextFormData =
            jj.Template(kTemplateRequestTextFormData);
        var templateRequestFileFormData =
            jj.Template(kTemplateRequestFileFormData);
        for (var field in requestModel.formDataList) {
          if (field.type == FormDataType.text) {
            result += templateRequestTextFormData
                .render({"name": field.name, "value": field.value});
          } else if (field.type == FormDataType.file) {
            result += templateRequestFileFormData
                .render({"name": field.name, "value": field.value});
          }
        }
      }

      if (hasBody) {
        result += kStringRequestBodySetup;
      }

      result += kStringRequestEnd;
      return result;
    } catch (e) {
      return null;
    }
  }
}
