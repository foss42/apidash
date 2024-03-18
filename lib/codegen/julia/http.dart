import 'dart:io';
import 'dart:convert';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart'
    show getNewUuid, getValidRequestUri, padMultilineString, stripUriParams;
import 'package:apidash/models/models.dart' show RequestModel;

class JuliaHttpClientCodeGen {
  final String kTemplateStart = """using HTTP,JSON

url = "{{url}}"

""";

  String kTemplateParams = """
{% set new_params = params | replace(":", "=>") | replace("{", "(") | replace("}", ")") %}

params = Dict{{new_params}}
""";

  int kParamsPadding = 9;

  String kTemplateBody = '''
{% set new_params = body | replace(":", "=>") | replace("{", "(") | replace("}", ")") %}

payload = Dict{{new_params}}
''';

  String kTemplateJson = """
{% set new_params = body | replace(":", "=>") | replace("{", "(") | replace("}", ")") %}

payload = Dict{{new_params}}
""";

  String kTemplateHeaders = """
{% set new_params = headers | replace(":", "=>") | replace("{", "(") | replace("}", ")") %}

headers = Dict{{new_params}}
""";

  String kTemplateFormHeaderContentType = '''
multipart/form-data; boundary={{boundary}}''';

  int kHeadersPadding = 10;

  String kTemplateRequest = """


response = HTTP.{{method}}(url
""";

  final String kStringFormDataBody = r'''
function build_data_list(fields)
    dataList = []
    for field in fields
        name = field["name"]
        value = field["value"]
        type_ = get(field, "type", "text")

        push!(dataList, b"--{{boundary}}")
        if type_ == "text"
            push!(dataList, b"Content-Disposition: form-data; name=\"$name\"")
            push!(dataList, b"Content-Type: text/plain")
            push!(dataList, b"")
            push!(dataList, codeunits(value))
        elseif type_ == "file"
            push!(dataList, b"Content-Disposition: form-data; name=\"$name\"; filename=\"$value\"")
            push!(dataList, b"Content-Type: $value")
            push!(dataList, b"")
            push!(dataList, String(read(value)))
        end
    end
    push!(dataList, "--{{boundary}}--")
    push!(dataList, b"")
    return dataList
end

dataList = build_data_list({{fields_list}})
payload = join(dataList, b"\r\n")
''';

  String kStringRequestParams = """, query=params""";

  String kStringRequestBody = """, payload=payload""";

  String kStringRequestJson = """, JSON.json(payload)""";

  String kStringRequestHeaders = """, headers=headers""";

  final String kStringRequestEnd = """
)

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";

  String? getCode(RequestModel requestModel) {
    try {
      String result = "";
      bool hasQuery = false;
      bool hasHeaders = false;
      bool hasBody = false;
      bool hasJsonBody = false;
      String uuid = getNewUuid();

      var rec = getValidRequestUri(
        requestModel.url,
        requestModel.enabledRequestParams,
      );
      Uri? uri = rec.$1;
      if (uri != null) {
        var templateStartUrl = jj.Template(kTemplateStart);
        result += templateStartUrl.render({
          "url": stripUriParams(uri),
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

        if (requestModel.hasJsonData) {
          hasJsonBody = true;
          var templateBody = jj.Template(kTemplateJson);
          result += templateBody.render({"body": requestModel.requestBody});
        } else if (requestModel.hasTextData) {
          hasBody = true;
          var templateBody = jj.Template(kTemplateBody);
          result += templateBody.render({"body": requestModel.requestBody});
        }

        var headersList = requestModel.enabledRequestHeaders;
        if (headersList != null || hasBody) {
          var headers = requestModel.enabledHeadersMap;
          if (requestModel.hasFormData) {
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
        if (requestModel.hasFormData) {
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
          "method": requestModel.method.name.toLowerCase(),
        });

        if (hasQuery) {
          result += kStringRequestParams;
        }

        if (hasBody || requestModel.hasFormData) {
          result += kStringRequestBody;
        }

        if (hasJsonBody || requestModel.hasFormData) {
          result += kStringRequestJson;
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
