import 'dart:io';
import 'dart:convert';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart'
    show getValidRequestUri, padMultilineString, rowsToMap;
import 'package:apidash/models/models.dart' show RequestModel;

class PythonHttpClient {
  final String kTemplateStart = """import http.client
""";

  String kTemplateParams = """
from urllib.parse import urlencode

queryParams = {{params}}
queryParamsStr = '?' + urlencode(queryParams)

""";
  int kParamsPadding = 14;

  String kTemplateBody = """

body = r'''{{body}}'''

""";

  String kTemplateHeaders = """

headers = {{headers}}

""";

  int kHeadersPadding = 10;

  String kTemplateConnection = """

conn = http.client.HTTP{{isHttps}}Connection("{{authority}}")""";

  String kTemplateRequest = """

conn.request("{{method}}", "{{path}}"{{queryParamsStr}}""";

  String kStringRequestBody = """,
              body= body""";

  String kStringRequestHeaders = """,
              headers= headers""";

  final String kStringRequestEnd = """)

res = conn.getresponse()
data = res.read()

print(data.decode("utf-8"))
""";

  String? getCode(
    RequestModel requestModel,
    String defaultUriScheme,
  ) {
    try {
      String result = "";
      bool hasHeaders = false;
      bool hasBody = false;

      String url = requestModel.url;
      if (!url.contains("://") && url.isNotEmpty) {
        url = "$defaultUriScheme://$url";
      }

      result += kTemplateStart;
      var rec = getValidRequestUri(url, requestModel.requestParams);
      Uri? uri = rec.$1;

      if (uri != null) {
        if (uri.hasQuery) {
          var params = uri.queryParameters;
          if (params.isNotEmpty) {
            var templateParams = jj.Template(kTemplateParams);
            var paramsString = kEncoder.convert(params);
            paramsString = padMultilineString(paramsString, kParamsPadding);
            result += templateParams.render({"params": paramsString});
          }
        }

        var method = requestModel.method;
        var requestBody = requestModel.requestBody;
        if (kMethodsWithBody.contains(method) && requestBody != null) {
          var contentLength = utf8.encode(requestBody).length;
          if (contentLength > 0) {
            hasBody = true;
            var templateBody = jj.Template(kTemplateBody);
            result += templateBody.render({"body": requestBody});
          }
        }

        var headersList = requestModel.requestHeaders;
        if (headersList != null || hasBody) {
          var headers = rowsToMap(requestModel.requestHeaders) ?? {};
          if (headers.isNotEmpty || hasBody) {
            hasHeaders = true;
            if (hasBody) {
              headers[HttpHeaders.contentTypeHeader] =
                  kContentTypeMap[requestModel.requestBodyContentType] ?? "";
            }
            var headersString = kEncoder.convert(headers);
            headersString = padMultilineString(headersString, kHeadersPadding);
            var templateHeaders = jj.Template(kTemplateHeaders);
            result += templateHeaders.render({"headers": headersString});
          }
        }

        var templateConnection = jj.Template(kTemplateConnection);
        result += templateConnection.render({
          "isHttps": uri.scheme == "https" ? "S" : "",
          "authority": uri.authority
        });

        var templateRequest = jj.Template(kTemplateRequest);
        result += templateRequest.render({
          "method": method.name.toUpperCase(),
          "path": uri.path,
          "queryParamsStr": (uri.hasQuery && uri.queryParameters.isNotEmpty)
              ? " + queryParamsStr"
              : "",
        });

        if (hasBody) {
          result += kStringRequestBody;
        }

        if (hasHeaders) {
          result += kStringRequestHeaders;
        }

        result += kStringRequestEnd;
      }
      return result;
    } catch (e) {
      return null;
    }
  }
}
