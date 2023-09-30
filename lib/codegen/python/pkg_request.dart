import 'dart:io';
import 'dart:convert';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart'
    show getValidRequestUri, padMultilineString, rowsToMap;
import 'package:apidash/models/models.dart' show RequestModel;

class PythonRequestCodeGen {
  final String kTemplateStart = """import requests

url = '{{url}}'

""";

  String kTemplateParams = """

params = {{params}}

""";
  int kParamsPadding = 9;

  String kTemplateBody = """

payload = r'''{{body}}'''

""";

  String kTemplateJson = """

payload = {{body}}

""";

  String kTemplateHeaders = """

headers = {{headers}}

""";

  int kHeadersPadding = 10;

  String kTemplateRequest = """

response = requests.{{method}}(url
""";

  String kStringRequestParams = """, params=params""";

  String kStringRequestBody = """, data=payload""";

  String kStringRequestJson = """, json=payload""";

  String kStringRequestHeaders = """, headers=headers""";

  final String kStringRequestEnd = """)

print('Status Code:', response.status_code)
print('Response Body:', response.text)
""";

  String? getCode(
    RequestModel requestModel,
    String defaultUriScheme,
  ) {
    try {
      String result = "";
      bool hasParams = false;
      bool hasHeaders = false;
      bool hasBody = false;
      bool hasJsonBody = false;

      String url = requestModel.url;
      if (!url.contains("://") && url.isNotEmpty) {
        url = "$defaultUriScheme://$url";
      }

      var rec = getValidRequestUri(url, requestModel.requestParams);
      Uri? uri = rec.$1;
      if (uri != null) {
        var templateStartUrl = jj.Template(kTemplateStart);
        result += templateStartUrl
            .render({"url": "${uri.scheme}://${uri.authority}${uri.path}"});

        if (uri.hasQuery) {
          hasParams = true;
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
            if (requestModel.requestBodyContentType == ContentType.json) {
              hasJsonBody = true;
              var templateBody = jj.Template(kTemplateJson);
              result += templateBody.render({"body": requestBody});
            } else {
              hasBody = true;
              var templateBody = jj.Template(kTemplateBody);
              result += templateBody.render({"body": requestBody});
            }
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

        var templateRequest = jj.Template(kTemplateRequest);
        result += templateRequest.render({
          "method": method.name.toLowerCase(),
        });

        if (hasParams) {
          result += kStringRequestParams;
        }

        if (hasBody) {
          result += kStringRequestBody;
        }

        if (hasJsonBody) {
          result += kStringRequestJson;
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
