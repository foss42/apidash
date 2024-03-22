import 'dart:convert';
import 'dart:io';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/utils/utils.dart'
    show getValidRequestUri, requestModelToHARJsonRequest, stripUriParams;
import '../../models/request_model.dart';
import 'package:apidash/consts.dart';

class JavaHttpClientCodeGen {
  final String kTemplatePackageImportsForFormdata = '''
import java.io.File;
import java.util.List;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.HashMap;
import java.math.BigInteger;
import java.security.SecureRandom;
import java.io.ObjectOutputStream;
import java.io.ByteArrayOutputStream;
import java.nio.charset.StandardCharsets;
import java.util.Map;
''';

  final String kTemplatePackageImports = '''
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpHeaders;
import java.net.http.HttpRequest.BodyPublishers;
import java.net.http.HttpResponse.BodyHandlers;
''';

  final String kTemplateStartClass = '''

public class JavaHttpClientExample {
    public static void main(String[] args) throws IOException, InterruptedException {
        HttpClient client = HttpClient.newHttpClient();
''';

  final String kTemplateUrl = '''

        String url = "{{url}}";

''';

  final String kTemplateUrlQuery = '''

        url += "?" + "{{params}}";

''';

  final String kTemplateMultiPartBuilder = '''

        var bldr = new HTTPRequestMultipartBody.Builder();
''';

  final String kTemplateFormdataFieldsStarter = '''
        Map<String, String> mp = new HashMap<>() {
            {
''';

  final String kTemplateFormdataFields = '''
                put("{{name}}", "{{value}}");''';

  final String kTemplateFormdataFieldsEnder = '''
            }
        };

        for (String key : mp.keySet()) {
            bldr.addPart(key, mp.get(key));
        }

''';

  final String kTemplateFormdataFilesStarter = '''
        String[][] files = {''';

  final String kTemplateFormdataFiles = '''
                { "{{name}}", "{{value}}"}''';

  final String kTemplateFormdataFilesEnder = '''
        };

        for (int i = 0; i < files.length; ++i) {
            File f = new File(files[i][1]);
            bldr.addPart(files[i][0], f, null, f.getName());
        }

''';

  final String kTemplateMultiPartBuildCaller = '''
        HTTPRequestMultipartBody multipartBody = bldr.build();

''';

  String kTemplateRequestBody = '''

        String body = "{{body}}";

''';

  final String kStringRequestStart = """

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
""";

  final String kTemplateRequestEnd = """
                .{{method}}({{body}})
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}
\n
""";

  String? getCode(
    RequestModel requestModel,
  ) {
    try {
      String result = "";
      bool hasQuery = false;
      bool hasBody = false;
      bool hasJsonBody = false;

      var rec = getValidRequestUri(
        requestModel.url,
        requestModel.enabledRequestParams,
      );
      Uri? uri = rec.$1;

      if (uri != null) {
        String url = stripUriParams(uri);

        if (uri.hasQuery) {
          var params = uri.queryParameters;
          if (params.isNotEmpty) {
            hasQuery = true;
            var templateParams = jj.Template(kTemplateUrlQuery);
            result += templateParams.render({"url": url, "params": uri.query});
          }
        }

        if (!hasQuery) {
          var templateUrl = jj.Template(kTemplateUrl);
          result += templateUrl.render({"url": url});
        }
        var rM = requestModel.copyWith(url: url);

        var harJson = requestModelToHARJsonRequest(rM, useEnabled: true);

        var method = requestModel.method;
        var requestBody = requestModel.requestBody;
        if (requestModel.hasFormData &&
            requestModel.formDataMapList.isNotEmpty &&
            kMethodsWithBody.contains(method)) {
          var formDataList = requestModel.formDataMapList;
          result += """
            StringBuilder formData = new StringBuilder();
            formData.append(""";

          for (var formDataMap in formDataList) {
            result += '"""${formDataMap['name']}=${formDataMap['value']}&""",';
          }

          result = result.substring(0, result.length - 1);
          result += ");\n";
          hasBody = true;
        } else if (kMethodsWithBody.contains(method) && requestBody != null) {
          var contentLength = utf8.encode(requestBody).length;
          if (contentLength > 0) {
            var templateBody = jj.Template(kTemplateRequestBody);
            hasBody = true;
            hasJsonBody =
                requestBody.startsWith("{") && requestBody.endsWith("}");
            if (harJson["postData"]?["text"] != null) {
              result += templateBody.render({
                "body": kEncoder.convert(harJson["postData"]["text"]).substring(
                    1, kEncoder.convert(harJson["postData"]["text"]).length - 1)
              });
            }
          }
        }

        result = kTemplateStart + result;
        result += kStringRequestStart;

        var headersList = requestModel.enabledRequestHeaders;
        var contentType = requestModel.requestBodyContentType.header;
        if (hasBody &&
            !requestModel.enabledHeadersMap.containsKey('Content-Type')) {
          result =
              """$result                .header("Content-Type", "$contentType")\n""";
        }
        if (headersList != null) {
          var headers = requestModel.enabledHeadersMap;
          if (headers.isNotEmpty) {
            result += getHeaders(headers, hasJsonBody);
          }
        }

        var templateRequestEnd = jj.Template(kTemplateRequestEnd);

        if (kMethodsWithBody.contains(method)) {
          result += templateRequestEnd.render({
            "method": method.name.toUpperCase(),
            "body": hasBody
                ? "BodyPublishers.ofString(body)"
                : "BodyPublishers.noBody()"
          });
        } else {
          result += templateRequestEnd
              .render({"method": method.name.toUpperCase(), "body": ""});
        }
      }
      return result;
    } catch (e) {
      return null;
    }
  }

  String getHeaders(Map<String, String> headers, hasJsonBody) {
    String result = "";
    for (final k in headers.keys) {
      if (k.toLowerCase() == 'authorization') {
        result = """$result                .header("$k", "${headers[k]}")\n""";
      } else {
        result = """$result                .header("$k", "${headers[k]}")\n""";
      }
    }
    return result;
  }
}
