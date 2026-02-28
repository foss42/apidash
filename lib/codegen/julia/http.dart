import 'dart:io';
import 'package:apidash_core/apidash_core.dart';
import 'package:jinja/jinja.dart' as jj;

class JuliaHttpClientCodeGen {
  final String kTemplateStart = """
using HTTP{% if hasJson %}, JSON{% endif %}
\n
""";

  final String kTemplateUrl = """
url = "{{url}}"
\n
""";

  String kTemplateParams = """
params = Dict(
{%- for name, value in params %}
    "{{ name }}" => "{{ value }}",
{%- endfor %}
)
\n
""";

  String kTemplateHeaders = """
headers = Dict(
{%- for name, value in headers %}
    "{{ name }}" => "{{ value }}",
{%- endfor %}
)
\n
""";

  final String kTemplateFormDataBody = '''
data = Dict(
{%- for data in formdata %}
{%- if data.type == "text" %}
    "{{ data.name }}" => "{{ data.value }}",
{%- else %}
    "{{ data.name }}" => open("{{ data.value }}"),
{%- endif %}
{%- endfor %}
)

payload = HTTP.Form(data)
\n
''';

  String kTemplateBody = '''
payload = """{{ body }}"""
\n
''';

  String kTemplateRequest = """
response = HTTP.request("{{ method | upper }}", url
""";

  String kStringRequestParams = """, query=params""";

  String kStringRequestBody = """, body=payload""";

  String kStringRequestHeaders = """, headers=headers""";

  final String kStringRequestEnd = r"""
, status_exception=false)

println("Status Code: $(response.status) $(HTTP.StatusCodes.statustext(response.status))")
println("Response Body: \n$(String(response.body))")
""";

  String? getCode(HttpRequestModel requestModel) {
    try {
      String result = "";
      bool hasQuery = false;
      bool hasHeaders = false;
      bool addHeaderForBody = false;

      var rec = getValidRequestUri(
        requestModel.url,
        requestModel.enabledParams,
      );
      Uri? uri = rec.$1;
      if (uri != null) {
        final templateStart = jj.Template(kTemplateStart);
        result += templateStart.render({
          // "hasJson": requestModel.hasBody && requestModel.hasJsonContentType && requestModel.hasJsonData,
          "hasJson":
              false, // we manually send false because we do not require JSON package
        });

        final templateUrl = jj.Template(kTemplateUrl);
        result += templateUrl.render({"url": stripUriParams(uri)});

        if (uri.hasQuery) {
          var params = uri.queryParameters;
          if (params.isNotEmpty) {
            hasQuery = true;
            final templateParams = jj.Template(kTemplateParams);
            result += templateParams.render({"params": params});
          }
        }

        if (requestModel.hasJsonData || requestModel.hasTextData) {
          addHeaderForBody = true;
          final templateBody = jj.Template(kTemplateBody);
          var bodyStr = requestModel.body;
          result += templateBody.render({"body": bodyStr});
        }

        if (requestModel.hasFormData) {
          final formDataBodyData = jj.Template(kTemplateFormDataBody);
          result += formDataBodyData.render(
            {
              "hasFile": requestModel.hasFileInFormData,
              "formdata": requestModel.formDataMapList,
            },
          );
        }

        var headersList = requestModel.enabledHeaders;
        if (headersList != null || addHeaderForBody) {
          var headers = requestModel.enabledHeadersMap;

          if (!requestModel.hasContentTypeHeader) {
            if (addHeaderForBody) {
              headers[HttpHeaders.contentTypeHeader] =
                  requestModel.bodyContentType.header;
            }
          }

          if (headers.isNotEmpty) {
            hasHeaders = true;
            var templateHeaders = jj.Template(kTemplateHeaders);
            result += templateHeaders.render({"headers": headers});
          }
        }

        var templateRequest = jj.Template(kTemplateRequest);
        result += templateRequest.render({
          "method": requestModel.method.name,
        });

        if (hasHeaders) {
          result += kStringRequestHeaders;
        }

        if (requestModel.hasBody) {
          result += kStringRequestBody;
        }

        if (hasQuery) {
          result += kStringRequestParams;
        }

        result += kStringRequestEnd;
      }

      return result;
    } catch (e) {
      return null;
    }
  }
}
