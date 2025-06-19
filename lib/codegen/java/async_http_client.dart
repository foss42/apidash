import 'package:apidash_core/apidash_core.dart';
import 'package:jinja/jinja.dart' as jj;

class JavaAsyncHttpClientGen {
  final String kStringStart = '''
import org.asynchttpclient.*;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.stream.Collectors;

''';

  final String kTemplateMultipartImport = '''
import java.util.Map;
import java.util.HashMap;
import org.asynchttpclient.request.body.multipart.StringPart;
{% if hasFileInFormData %}import org.asynchttpclient.request.body.multipart.FilePart;
{% endif %}

''';

  final String kStringMainClassMainMethodStart = '''
public class Main {
    public static void main(String[] args) {
''';

  final String kStringAsyncHttpClientTryBlockStart = '''
        try (AsyncHttpClient asyncHttpClient = Dsl.asyncHttpClient()) {
''';

  final String kTemplateUrl = '''
            String url = "{{url}}";\n
''';

  final String kTemplateRequestCreation = '''
            BoundRequestBuilder requestBuilder = asyncHttpClient.prepare("{{ method|upper }}", url);\n
''';

  final String kTemplateUrlQueryParam = '''
            requestBuilder{% for name, value in queryParams %}
                .addQueryParam("{{ name }}", "{{ value }}"){% endfor %};\n
''';

  final String kTemplateRequestHeader = '''
            requestBuilder{% for name, value in headers %}
                .addHeader("{{ name }}", "{{ value }}"){% endfor %};\n
''';

  final String kTemplateMultipartTextFormData = '''

            Map<String, String> params = new HashMap<>() {
                { {% for key, value in textFields %}
                    put("{{ key }}", "{{ value }}");{% endfor %}
                }
            };

            for (String paramName : params.keySet()) {
                requestBuilder.addBodyPart(new StringPart(
                    paramName, params.get(paramName)
                ));
            }


''';

  final String kTemplateMultipartFileHandling = '''
            Map<String, String> files = new HashMap<>() {
                { {% for key, value in fileFields %}
                    put("{{ key }}", "{{ value }}");{% endfor %}
                }
            };

            for (String paramName : files.keySet()) {
                File file = new File(files.get(paramName));
                requestBuilder.addBodyPart(new FilePart(
                        paramName,
                        file,
                        "application/octet-stream",
                        StandardCharsets.UTF_8,
                        file.getName()
                ));
            }


''';

  String kTemplateRequestBodyContent = '''
            String bodyContent = """
{{body}}""";\n
''';
  String kStringRequestBodySetup = '''
            requestBuilder.setBody(bodyContent);
''';

  final String kStringRequestEnd = '''
            Future<Response> whenResponse = requestBuilder.execute();
            Response response = whenResponse.get();
            InputStream is = response.getResponseBodyAsStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
            String respBody = br.lines().collect(Collectors.joining("\\n"));
            System.out.println(response.getStatusCode());
            System.out.println(respBody);
        } catch (InterruptedException | ExecutionException | IOException ignored) {

        }
    }
}
''';

  String? getCode(
    HttpRequestModel requestModel,
  ) {
    try {
      String result = '';
      bool hasBody = false;

      var rec = getValidRequestUri(
        requestModel.url,
        requestModel.enabledParams,
      );
      Uri? uri = rec.$1;

      if (uri == null) {
        return "";
      }

      result += kStringStart;
      if (requestModel.hasFormData) {
        var templateMultipartImport = jj.Template(kTemplateMultipartImport);
        result += templateMultipartImport
            .render({"hasFileInFormData": requestModel.hasFileInFormData});
      }
      result += kStringMainClassMainMethodStart;
      result += kStringAsyncHttpClientTryBlockStart;

      var url = stripUriParams(uri);

      // contains the HTTP method associated with the request
      var method = requestModel.method;

      // generating the URL to which the request has to be submitted
      var templateUrl = jj.Template(kTemplateUrl);
      result += templateUrl.render({"url": url});

      // if request type is not form data, the request method can include
      // a body, and the body of the request is not null, in that case
      // we need to parse the body as it is, and write it to the body
      if (requestModel.hasTextData || requestModel.hasJsonData) {
        var templateBodyContent = jj.Template(kTemplateRequestBodyContent);
        result += templateBodyContent.render({"body": requestModel.body});
        hasBody = true;
      }

      var templateRequestCreation = jj.Template(kTemplateRequestCreation);
      result += templateRequestCreation.render({"method": method.name});

      // setting up query parameters
      var params = uri.queryParameters;
      if (params.isNotEmpty) {
        var templateUrlQueryParam = jj.Template(kTemplateUrlQueryParam);
        result += templateUrlQueryParam.render({"queryParams": params});
      }

      var headers = requestModel.enabledHeadersMap;
      if (hasBody && !requestModel.hasContentTypeHeader) {
        headers[kHeaderContentType] = requestModel.bodyContentType.header;
      }

      // setting up rest of the request headers
      if (headers.isNotEmpty) {
        var templateRequestHeader = jj.Template(kTemplateRequestHeader);
        result += templateRequestHeader.render({"headers": headers});
      }

      // handling form data
      if (requestModel.hasFormData) {
        var formDataList = requestModel.formDataList;

        Map<String, String> textFieldMap = {};
        Map<String, String> fileFieldMap = {};
        for (var field in formDataList) {
          if (field.type == FormDataType.text) {
            textFieldMap[field.name] = field.value;
          }
          if (field.type == FormDataType.file) {
            fileFieldMap[field.name] = field.value;
          }
        }

        if (textFieldMap.isNotEmpty) {
          var templateRequestFormData =
              jj.Template(kTemplateMultipartTextFormData);

          result += templateRequestFormData.render({
            "textFields": textFieldMap,
          });
        }

        if (requestModel.hasFileInFormData) {
          var templateFileHandling =
              jj.Template(kTemplateMultipartFileHandling);
          result += templateFileHandling.render({
            "fileFields": fileFieldMap,
          });
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
