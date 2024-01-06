import 'dart:io';
import 'dart:convert';
import 'package:apidash/utils/extensions/request_model_extension.dart';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart'
    show getNewUuid, getValidRequestUri, padMultilineString, rowsToFormDataMap;
import 'package:apidash/models/models.dart' show FormDataModel, RequestModel;

class PythonHttpClientCodeGen {
  final String kTemplateStart = """import http.client
{% if isFormDataRequest %}
import mimetypes
from codecs import encode
{% endif %}

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
  String kTemplateFormHeaderContentType = '''
multipart/form-data; boundary={{boundary}}''';

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
    RequestModel requestModel,
    String defaultUriScheme,
  ) {
    List<FormDataModel> formDataList = requestModel.formDataList ?? [];
    String uuid = getNewUuid();

    try {
      String result = "";
      bool hasHeaders = false;
      bool hasQuery = false;
      bool hasBody = false;

      String url = requestModel.url;
      if (!url.contains("://") && url.isNotEmpty) {
        url = "$defaultUriScheme://$url";
      }

      var templateStartUrl = jj.Template(kTemplateStart);
      result += templateStartUrl.render(
        {
          "isFormDataRequest": requestModel.isFormDataRequest,
        },
      );
      var rec = getValidRequestUri(
        url,
        requestModel.enabledRequestParams,
      );

      Uri? uri = rec.$1;

      if (uri != null) {
        if (uri.hasQuery) {
          var params = uri.queryParameters;
          if (params.isNotEmpty) {
            hasQuery = true;
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

        var headersList = requestModel.enabledRequestHeaders;
        if (headersList != null || hasBody) {
          var headers = requestModel.enabledHeadersMap;
          if (requestModel.isFormDataRequest) {
            var formHeaderTemplate =
                jj.Template(kTemplateFormHeaderContentType);
            headers[HttpHeaders.contentTypeHeader] = formHeaderTemplate.render({
              "boundary": uuid,
            });
          }

          if (headers.isNotEmpty || hasBody) {
            hasHeaders = true;
            bool hasContentTypeHeader = headers.keys.any((k) => k.toLowerCase() == HttpHeaders.contentTypeHeader);

            if (hasBody && !hasContentTypeHeader) {
              headers[HttpHeaders.contentTypeHeader] =
                  kContentTypeMap[requestModel.requestBodyContentType] ?? "";
            }
            var headersString = kEncoder.convert(headers);
            headersString = padMultilineString(headersString, kHeadersPadding);
            var templateHeaders = jj.Template(kTemplateHeaders);
            result += templateHeaders.render({"headers": headersString});
          }
        }
        if (requestModel.isFormDataRequest) {
          var formDataBodyData = jj.Template(kStringFormDataBody);
          result += formDataBodyData.render(
            {
              "fields_list": json.encode(rowsToFormDataMap(formDataList)),
              "boundary": uuid,
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
          "method": method.name.toUpperCase(),
          "path": uri.path,
          "queryParamsStr": hasQuery ? " + queryParamsStr" : "",
        });

        if (hasBody || requestModel.isFormDataRequest) {
          result += kStringRequestBody;
        }

        if (hasHeaders || requestModel.isFormDataRequest) {
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
