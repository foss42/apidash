import 'dart:io';
import 'dart:convert';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart'
    show getNewUuid, getValidRequestUri, padMultilineString, stripUriParams;
import 'package:apidash/models/models.dart' show RequestModel;

class PythonRequestsCodeGen {
  final String kTemplateStart = """import requests
{% if isFormDataRequest %}import mimetypes
from codecs import encode
{% endif %}
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
  String kTemplateFormHeaderContentType = '''
multipart/form-data; boundary={{boundary}}''';

  int kHeadersPadding = 10;

  String kTemplateRequest = """

response = requests.{{method}}(url
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
    dataList.append(encode('--{{boundary}}--'))
    dataList.append(encode(''))
    return dataList

dataList = build_data_list({{fields_list}})
payload = b'\r\n'.join(dataList)
''';

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
      bool hasQuery = false;
      bool hasHeaders = false;
      bool hasBody = false;
      bool hasJsonBody = false;
      String uuid = getNewUuid();

      String url = requestModel.url;
      if (!url.contains("://") && url.isNotEmpty) {
        url = "$defaultUriScheme://$url";
      }

      var rec = getValidRequestUri(
        url,
        requestModel.enabledRequestParams,
      );
      Uri? uri = rec.$1;
      if (uri != null) {
        var templateStartUrl = jj.Template(kTemplateStart);
        result += templateStartUrl.render({
          "url": stripUriParams(uri),
          'isFormDataRequest': requestModel.isFormDataRequest
        });

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
            if (hasBody) {
              headers[HttpHeaders.contentTypeHeader] =
                  requestModel.requestBodyContentType.header;
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
              "fields_list": json.encode(requestModel.formDataMapList),
              "boundary": uuid,
            },
          );
        }
        var templateRequest = jj.Template(kTemplateRequest);
        result += templateRequest.render({
          "method": method.name.toLowerCase(),
        });

        if (hasQuery) {
          result += kStringRequestParams;
        }

        if (hasBody || requestModel.isFormDataRequest) {
          result += kStringRequestBody;
        }

        if (hasJsonBody || requestModel.isFormDataRequest) {
          result += kStringRequestJson;
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
