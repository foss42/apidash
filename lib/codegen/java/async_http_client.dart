import 'dart:convert';
import 'package:apidash/utils/har_utils.dart';
import 'package:apidash/utils/http_utils.dart';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/models/models.dart' show RequestModel;
import 'package:apidash/consts.dart';

class JavaAsyncHttpClientGen {
  final String kTemplateStart = '''
import org.asynchttpclient.*;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Executors;
import java.util.stream.Collectors;

public class Main {
    public static void main(String[] args) {
        try (AsyncHttpClient asyncHttpClient = Dsl.asyncHttpClient()) {
''';

  final String kTemplateUrl = '''
            String url = "{{url}}";\n
''';

  final String kTemplateRequestCreation = '''
            Request request = asyncHttpClient
                .prepare("{{method}}", url)\n
''';

  final String kTemplateUrlQueryParam = '''
                .addQueryParam("{{name}}", "{{value}}")\n
''';

  final String kTemplateRequestHeader = '''
                .addHeader("{{name}}", "{{value}}")\n
''';
  final String kTemplateRequestFormData = '''
                .addFormParam("{{name}}", "{{value}}")\n
''';

  String kTemplateRequestBodyContent = '''
            String bodyContent = "{{body}}";\n
''';
  String kTemplateRequestBodySetup = '''
                .setBody(bodyContent)\n
''';

  final String kTemplateRequestEnd = """
                .build();
            ListenableFuture<Response> listenableFuture = asyncHttpClient.executeRequest(request);
            listenableFuture.addListener(() -> {
                try {
                    Response response = listenableFuture.get();
                    InputStream is = response.getResponseBodyAsStream();
                    BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
                    String respBody = br.lines().collect(Collectors.joining("\\n"));
                    System.out.println(response.getStatusCode());
                    System.out.println(respBody);
                } catch (InterruptedException | ExecutionException e) {
                    e.printStackTrace();
                }
            }, Executors.newCachedThreadPool());
            listenableFuture.get();
        } catch (InterruptedException | ExecutionException | IOException ignored) {

        }
    }
}
\n
""";

  String? getCode(
    RequestModel requestModel,
  ) {
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
      if (uri.hasQuery) {
        var params = uri.queryParameters;
        var templateUrlQueryParam = jj.Template(kTemplateUrlQueryParam);
        params.forEach((name, value) {
          result +=
              templateUrlQueryParam.render({"name": name, "value": value});
        });
      }

      result = kTemplateStart + result;

      var contentType = requestModel.requestBodyContentType.header;
      var templateRequestHeader = jj.Template(kTemplateRequestHeader);

      // especially sets up Content-Type header if the request has a body
      // and Content-Type is not explicitely set by the developer
      if (hasBody &&
          !requestModel.enabledHeadersMap.containsKey('Content-Type')) {
        result += templateRequestHeader
            .render({"name": 'Content-Type', "value": contentType});
      }

      // setting up rest of the request headers
      var headers = requestModel.enabledHeadersMap;
      headers.forEach((name, value) {
        result += templateRequestHeader.render({"name": name, "value": value});
      });

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
