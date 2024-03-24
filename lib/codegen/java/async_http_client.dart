import 'dart:convert';
import 'package:apidash/utils/har_utils.dart';
import 'package:apidash/utils/http_utils.dart';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/models/models.dart' show RequestModel;
import 'package:apidash/consts.dart';

class JavaAsyncHttpClientGen {
  final String kTemplateStart = '''
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
import org.asynchttpclient.request.body.multipart.FilePart;
import org.asynchttpclient.request.body.multipart.StringPart;

''';

  final String kTemplateMainClassMainMethodStart = '''
public class Main {
    public static void main(String[] args) {
''';

  final String kTemplateAsyncHttpClientTryBlockStart = '''
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
  final String kTemplateSimpleTextFormData = '''
            requestBuilder{% for param in params if param.type == "text" %}
                .addFormParam("{{ param.name }}", "{{ param.value }}"){% endfor %};\n
''';

  final String kTemplateMultipartTextFormData = '''

            Map<String, String> params = new HashMap<>() {
                { {% for param in params if param.type == "text" %}
                    put("{{ param.name }}", "{{ param.value }}");{% endfor %}
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
                { {% for field in fields if field.type == "file" %}
                    put("{{ field.name }}", "{{ field.value }}");{% endfor %}
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
            String bodyContent = "{{body}}";\n
''';
  String kTemplateRequestBodySetup = '''
            requestBuilder.setBody(bodyContent);\n
''';

  final String kTemplateRequestEnd = '''
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
}\n
''';

  String? getCode(
    RequestModel requestModel, {
    String? boundary,
  }) {
    try {
      String result = "";
      bool hasBody = false;

      var rec = getValidRequestUri(
        requestModel.url,
        requestModel.enabledRequestParams,
      );
      Uri? uri = rec.$1;

      if (uri == null) {
        return "";
      }

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
          templateRequestCreation.render({"method": method.name.toUpperCase()});

      // setting up query parameters
      var params = uri.queryParameters;
      if (params.isNotEmpty) {
        var templateUrlQueryParam = jj.Template(kTemplateUrlQueryParam);
        result += templateUrlQueryParam.render({"queryParams": params});
      }

      var headers = <String, String>{};
      for (var i in harJson["headers"]) {
        headers[i["name"]] = i["value"];
      }

      // especially sets up Content-Type header if the request has a body
      // and Content-Type is not explicitely set by the developer
      if (requestModel.hasBody && !headers.containsKey("Content-Type")) {
        headers["Content-Type"] = requestModel.requestBodyContentType.header;
      }

      if (requestModel.hasBody &&
          requestModel.hasFormData &&
          !requestModel.hasFileInFormData) {
        headers["Content-Type"] = "application/x-www-form-urlencoded";
      }

      // we will use this request boundary to set boundary if multipart formdata is used
      // String requestBoundary = "";
      String multipartTypePrefix = "multipart/form-data; boundary=";
      if (headers.containsKey("Content-Type") &&
          headers["Content-Type"]!.startsWith(RegExp(multipartTypePrefix))) {
        // String tmp = headers["Content-Type"]!;
        // requestBoundary = tmp.substring(multipartTypePrefix.length);

        // if a boundary is provided, we will use that as the default boundary
        if (boundary != null) {
          // requestBoundary = boundary;
          headers["Content-Type"] = multipartTypePrefix + boundary;
        }
      }

      // setting up rest of the request headers
      if (headers.isNotEmpty) {
        var templateRequestHeader = jj.Template(kTemplateRequestHeader);
        result += templateRequestHeader.render({
          "headers": headers //
        });
      }

      // handling form data
      if (requestModel.hasFormData &&
          requestModel.formDataMapList.isNotEmpty &&
          kMethodsWithBody.contains(method)) {
        // including form data into the request
        var formDataList = requestModel.formDataMapList;
        var templateRequestFormData = jj.Template(kTemplateRequestFormData);
        for (var formDataMap in formDataList) {
          result += templateRequestFormData.render(
              {"name": formDataMap['name'], "value": formDataMap['value']});
        }
        hasBody = true;
      }

      var templateRequestBodySetup = jj.Template(kTemplateRequestBodySetup);
      if (kMethodsWithBody.contains(method) && hasBody) {
        result += templateRequestBodySetup.render();
      }

      var templateRequestBodyEnd = jj.Template(kTemplateRequestEnd);
      result += templateRequestBodyEnd.render();

      return result;
    } catch (e) {
      return null;
    }
  }
}
