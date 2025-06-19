import 'dart:io';
import 'package:apidash_core/apidash_core.dart';
import 'package:jinja/jinja.dart' as jj;
import '../../utils/utils.dart';
import '../codegen_utils.dart';

class PythonRequestsCodeGen {
  final String kTemplateStart = """import requests
{% if hasFormData %}from requests_toolbelt.multipart.encoder import MultipartEncoder
{% endif %}
url = '{{url}}'

""";

  String kTemplateParams = """

params = {{params}}

""";

  String kTemplateBody = """

payload = r'''{{body}}'''

""";

  String kTemplateJson = """

payload = {{body}}

""";

  String kTemplateHeaders = """

headers = {{headers}}

""";

  String kTemplateRequest = """

response = requests.{{method}}(url
""";

  final String kTemplateFormDataBody = r'''

payload = MultipartEncoder({
{{formdata_payload}}
}{% if boundary != '' %}, 
    boundary="{{boundary}}"
{% endif %})

''';

  String kTemplateFormDataRowText = r"""  "{{name}}": "{{value}}",""";

  String kTemplateFormDataRowFile =
      r"""  "{{name}}": ("{{filename}}", open("{{path}}", "rb")),""";

  String kStringRequestParams = """, params=params""";

  String kStringRequestBody = """, data=payload""";

  String kStringRequestJson = """, json=payload""";

  String kStringRequestHeaders = """, headers=headers""";

  final String kStringRequestEnd = """)

print('Status Code:', response.status_code)
print('Response Body:', response.text)
""";

  String kStringFormDataContentType = "payload.content_type";

  String refactorHeaderString(String headerString) {
    return headerString.replaceAll(
        '"$kStringFormDataContentType"', kStringFormDataContentType);
  }

  String? getCode(
    HttpRequestModel requestModel, {
    String? boundary,
  }) {
    try {
      String result = "";
      bool hasQuery = false;
      bool hasHeaders = false;
      bool hasBody = false;
      bool hasJsonBody = false;

      var rec = getValidRequestUri(
        requestModel.url,
        requestModel.enabledParams,
      );
      Uri? uri = rec.$1;
      if (uri != null) {
        var templateStartUrl = jj.Template(kTemplateStart);
        result += templateStartUrl.render({
          "url": stripUriParams(uri),
          'hasFormData': requestModel.hasFormData
        });

        if (uri.hasQuery) {
          var params = uri.queryParameters;
          if (params.isNotEmpty) {
            hasQuery = true;
            var templateParams = jj.Template(kTemplateParams);
            var paramsString = kJsonEncoder.convert(params);
            result += templateParams.render({"params": paramsString});
          }
        }

        if (requestModel.hasFormData) {
          hasBody = true;
          List<String> formdataPayload = [];
          for (var item in requestModel.formDataList) {
            if (item.type == FormDataType.text) {
              formdataPayload.add(jj.Template(kTemplateFormDataRowText).render({
                "name": item.name,
                "value": item.value,
              }));
            }
            if (item.type == FormDataType.file) {
              formdataPayload.add(jj.Template(kTemplateFormDataRowFile).render({
                "name": item.name,
                "filename": getFilenameFromPath(item.value),
                "path": item.value,
              }));
            }
          }
          var formDataBodyData = jj.Template(kTemplateFormDataBody);
          result += formDataBodyData.render(
            {
              "formdata_payload": formdataPayload.join("\n"),
              "boundary": boundary ?? '',
            },
          );
        } else if (requestModel.hasJsonData) {
          hasJsonBody = true;
          var templateBody = jj.Template(kTemplateJson);
          var pyDict = jsonToPyDict(requestModel.body ?? "");
          result += templateBody.render({"body": pyDict});
        } else if (requestModel.hasTextData) {
          hasBody = true;
          var templateBody = jj.Template(kTemplateBody);
          result += templateBody.render({"body": requestModel.body});
        }

        var headersList = requestModel.enabledHeaders;
        if (headersList != null || hasBody) {
          var headers = requestModel.enabledHeadersMap;
          if (hasBody) {
            if (requestModel.hasFormData) {
              headers[HttpHeaders.contentTypeHeader] =
                  kStringFormDataContentType;
            } else {
              headers[HttpHeaders.contentTypeHeader] =
                  requestModel.bodyContentType.header;
            }
          }
          if (headers.isNotEmpty) {
            hasHeaders = true;
            var headersString = kJsonEncoder.convert(headers);
            headersString = refactorHeaderString(headersString);
            var templateHeaders = jj.Template(kTemplateHeaders);
            result += templateHeaders.render({"headers": headersString});
          }
        }

        var templateRequest = jj.Template(kTemplateRequest);
        result += templateRequest.render({
          "method": requestModel.method.name.toLowerCase(),
        });

        if (hasQuery) {
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
