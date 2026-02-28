import 'dart:io';
import 'dart:convert';
import 'package:apidash_core/apidash_core.dart';
import 'package:jinja/jinja.dart' as jj;

class PythonHttpClientCodeGen {
  final String kTemplateStart = """import http.client
{% if hasFormData %}import mimetypes
from codecs import encode
{% endif %}
""";

  String kTemplateParams = """
from urllib.parse import urlencode

queryParams = {{params}}
queryParamsStr = '?' + urlencode(queryParams)

""";

  String kTemplateBody = """

body = r'''{{body}}'''

""";

  String kTemplateHeaders = """

headers = {{headers}}

""";
  String kTemplateFormHeaderContentType = '''
multipart/form-data; boundary={{boundary}}''';

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

  final String kStringFormDataBody = r'''

def build_data_list(fields):
    dataList = []
    for field in fields:
        name = field.get('name', '')
        value = field.get('value', '')
        type_ = field.get('type', 'text')
        dataList.append(encode('--{{boundary}}'))
        if type_ == 'text':
            dataList.append(encode(f'Content-Disposition: form-data; name="{name}"'))
            dataList.append(encode('Content-Type: text/plain'))
            dataList.append(encode(''))
            dataList.append(encode(value))
        elif type_ == 'file':
            dataList.append(encode(f'Content-Disposition: form-data; name="{name}"; filename="{value}"'))
            dataList.append(encode(f'Content-Type: {mimetypes.guess_type(value)[0] or "application/octet-stream"}'))
            dataList.append(encode(''))
            dataList.append(open(value, 'rb').read())
    dataList.append(encode(f'--{{boundary}}--'))
    dataList.append(encode(''))
    return dataList

dataList = build_data_list({{fields_list}})
body = b'\r\n'.join(dataList)
''';
  String? getCode(
    HttpRequestModel requestModel, {
    String? boundary,
  }) {
    try {
      String result = "";
      bool hasHeaders = false;
      bool hasQuery = false;
      bool hasBody = false;

      var templateStartUrl = jj.Template(kTemplateStart);
      result += templateStartUrl.render(
        {
          "hasFormData": requestModel.hasFormData,
        },
      );
      var rec = getValidRequestUri(
        requestModel.url,
        requestModel.enabledParams,
      );

      Uri? uri = rec.$1;

      if (uri != null) {
        if (uri.hasQuery) {
          var params = uri.queryParameters;
          if (params.isNotEmpty) {
            hasQuery = true;
            var templateParams = jj.Template(kTemplateParams);
            var paramsString = kJsonEncoder.convert(params);
            result += templateParams.render({"params": paramsString});
          }
        }

        if (requestModel.hasBody) {
          hasBody = true;
          if (requestModel.hasJsonData || requestModel.hasTextData) {
            var templateBody = jj.Template(kTemplateBody);
            result += templateBody.render({"body": requestModel.body});
          }
        }

        var headersList = requestModel.enabledHeaders;
        if (headersList != null || hasBody) {
          var headers = requestModel.enabledHeadersMap;

          if (headers.isNotEmpty || hasBody) {
            hasHeaders = true;
            if (hasBody && !requestModel.hasContentTypeHeader) {
              if (requestModel.hasJsonData || requestModel.hasTextData) {
                headers[HttpHeaders.contentTypeHeader] =
                    requestModel.bodyContentType.header;
              } else if (requestModel.hasFormData) {
                var formHeaderTemplate =
                    jj.Template(kTemplateFormHeaderContentType);
                headers[HttpHeaders.contentTypeHeader] =
                    formHeaderTemplate.render({
                  "boundary": boundary,
                });
              }
            }
            var headersString = kJsonEncoder.convert(headers);
            var templateHeaders = jj.Template(kTemplateHeaders);
            result += templateHeaders.render({"headers": headersString});
          }
        }
        if (requestModel.hasFormData) {
          var formDataBodyData = jj.Template(kStringFormDataBody);
          result += formDataBodyData.render(
            {
              "fields_list": json.encode(requestModel.formDataMapList),
              "boundary": boundary,
            },
          );
        }
        var templateConnection = jj.Template(kTemplateConnection);
        result += templateConnection.render({
          "isHttps": uri.scheme == "https" ? "S" : "",
          "authority": uri.authority
        });

        var templateRequest = jj.Template(kTemplateRequest);
        result += templateRequest.render({
          "method": requestModel.method.name.toUpperCase(),
          "path": uri.path,
          "queryParamsStr": hasQuery ? " + queryParamsStr" : "",
        });

        if (hasBody || requestModel.hasFormData) {
          result += kStringRequestBody;
        }

        if (hasHeaders || requestModel.hasFormData) {
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
