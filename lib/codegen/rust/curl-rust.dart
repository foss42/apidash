import 'dart:convert';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/utils/utils.dart'
    show getNewUuid, getValidRequestUri, padMultilineString;
import 'package:apidash/models/models.dart' show RequestModel;
import 'package:apidash/consts.dart';

class RustCurlCodeGen {
  final String kTemplateStart = """use curl::easy::Easy;
use serde_json::json;

fn main() {
""";

  String kTemplateUrl = """
    let mut easy = Easy::new();
    easy.url("{{url}}").unwrap();
    """;

  String kTemplateMethod = """easy.{{method}}(true).unwrap();
  """;

  String kTemplateRawBody =
      """easy.post_field_copy({{body}}.as_bytes()).unwrap();
      """;

  String kTemplateJsonBody =
      """easy.post_fields_copy(json!({{body}}).to_string().as_bytes()).unwrap();
      """;

  String kTemplateFormData = """
    let mut form = curl::easy::Form::new();
    {% for field in fields %}
    form.part("{{field.name}}")
        {% if field.type == "file" %}.file("{{field.value}}"){% else %}.contents(b"{{field.value}}"){% endif %}
        .add();
    {% endfor %}
    easy.httppost(form);
    """;

  String kTemplateHeader = """easy.header("{{header}}", "{{value}}");
  """;

  final String kTemplateEnd = """easy.perform().unwrap();
}
""";

  String? getCode(
    RequestModel requestModel,
    String defaultUriScheme,
  ) {
    try {
      String result = "";

      String url = requestModel.url;
      if (!url.contains("://") && url.isNotEmpty) {
        url = "$defaultUriScheme://$url";
      }

      result += kTemplateStart;

      var rec = getValidRequestUri(
        url,
        requestModel.enabledRequestParams,
      );

      Uri? uri = rec.$1;

      if (uri != null) {
        var templateUrl = jj.Template(kTemplateUrl);
        result += templateUrl.render({"url": uri.toString()});

        var method = requestModel.method;
        var templateMethod = jj.Template(kTemplateMethod);
        result += templateMethod.render({"method": method.name.toLowerCase()});

        var requestBody = requestModel.requestBody;
        if (kMethodsWithBody.contains(method) && requestBody != null) {
          if (requestModel.requestBodyContentType == ContentType.text) {
            var templateRawBody = jj.Template(kTemplateRawBody);
            result += templateRawBody.render({"body": requestBody});
          } else if (requestModel.requestBodyContentType == ContentType.json) {
            var templateJsonBody = jj.Template(kTemplateJsonBody);
            result += templateJsonBody.render({"body": requestBody});
          } else if (requestModel.isFormDataRequest) {
            var templateFormData = jj.Template(kTemplateFormData);
            result += templateFormData.render({
              "fields": requestModel.formDataMapList,
            });
          }
        }

        var headersList = requestModel.enabledRequestHeaders;
        if (headersList != null) {
          var headers = requestModel.enabledHeadersMap;
          for (var header in headers.keys) {
            var templateHeader = jj.Template(kTemplateHeader);
            result += templateHeader.render({
              "header": header,
              "value": headers[header],
            });
          }
        }

        result += kTemplateEnd;
      }

      return result;
    } catch (e) {
      return null;
    }
  }
}
