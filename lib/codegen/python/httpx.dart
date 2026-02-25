import 'package:apidash_core/apidash_core.dart';
import 'package:jinja/jinja.dart' as jj;
import '../../utils/utils.dart';
import '../codegen_utils.dart';

class PythonHttpxCodeGen {
  final String kTemplateStart = """import httpx{% if hasFormData %}
# Note: httpx handles multipart differently, usually via files/data{% endif %}
url = '{{url}}'

""";

  String kTemplateParams = """params = {{params}}

""";

  String kTemplateBody = """payload = r'''{{body}}'''

""";

  String kTemplateJson = """payload = {{body}}

""";

  String kTemplateHeaders = """headers = {{headers}}

""";

  String kTemplateRequest = """response = httpx.{{method}}(url
""";

  final String kTemplateFormDataBody = r'''

data = {
{{formdata_payload}}
}

''';

  String kTemplateFormDataRowText = r"""  "{{name}}": "{{value}}",""";

  String kTemplateFormDataRowFile =
      r"""  "{{name}}": ("{{filename}}", open("{{path}}", "rb")),""";

  String kStringRequestParams = """, params=params""";

  String kStringRequestBody = """, content=payload""";

  String kStringRequestFormData = """, data=data""";

  String kStringRequestJson = """, json=payload""";

  String kStringRequestHeaders = """, headers=headers""";

  final String kStringRequestEnd = """)

print('Status Code:', response.status_code)
print('Response Body:', response.text)
""";

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
      bool hasFormData = false;

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
          hasFormData = true;
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
        if (headersList != null || hasBody || hasFormData) {
          var headers = requestModel.enabledHeadersMap;
          if (hasBody || hasFormData) {
            if (!requestModel.hasFormData) {
              headers[kHeaderContentType] = requestModel.bodyContentType.header;
            }
          }
          if (headers.isNotEmpty) {
            hasHeaders = true;
            var headersString = kJsonEncoder.convert(headers);
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

        if (hasFormData) {
          result += kStringRequestFormData;
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
