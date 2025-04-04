import 'package:apidash_core/apidash_core.dart';
import 'package:jinja/jinja.dart' as jj;

class RubyNetHttpCodeGen {
  String kTemplateStart = """require "uri"
require "net/http"

url = URI("{{url}}")
""";

  String kTemplateRequestParams = """
\nparams = {
{% for key, val in params %} "{{ key }}" => {% if val is list %}[{% for v in val %}"{{ v|string }}"{% if not loop.last %}, {% endif %}{% endfor %}]{% else %}"{{ val|string }}"{% endif %},
{% endfor %}}
url.query = URI.encode_www_form(params)\n
""";

  String kTemplateConnectionAndRequest = """
https = Net::HTTP.new(url.host, url.port)
{% if check == "https" %}https.use_ssl = true{% endif %}
request = Net::HTTP::{{method}}.new(url)
""";

  String kTemplateHeader = """
{% for key, value in headers %}
request["{{key}}"] = "{{value}}"
{% endfor %}
""";

  String kTemplateBody = """

request.body = <<HEREDOC
{{body}}
HEREDOC

""";
  String kMultiPartBodyTemplate = r'''
{% if type == "file" %}"{{name}}", File.open("{{value}}"){% else %}"{{name}}", "{{value}}"{% endif %}
''';
  String kStringRequest = """

response = https.request(request)

puts "Response Code: #{response.code}"
{% if method != "head" %}
puts "Response Body: #{response.body}"
{% else %}
puts "Response Headers: #{response.to_hash}"
{% endif %}

""";

  String? getCode(HttpRequestModel requestModel) {
    try {
      String result = "";

      var rec = getValidRequestUri(
        requestModel.url,
        requestModel.enabledParams,
      );

      Uri? uri = rec.$1;

      if (uri == null) {
        return "";
      }

      var templateStart = jj.Template(kTemplateStart);
      result += templateStart.render({
        "url": uri.toString().split('?').first,
      });
      if (requestModel.enabledParamsMap.isNotEmpty) {
        var templateRequestParams = jj.Template(kTemplateRequestParams);
        result += templateRequestParams.render({
          "params": requestModel.enabledParamsMap,
        });
      }

      var connectionTemplate = jj.Template(kTemplateConnectionAndRequest);
      result += connectionTemplate.render({
        "method": requestModel.method.name.capitalize(),
        "check": uri.scheme,
      });

      var headers = requestModel.enabledHeadersMap;
      if (!requestModel.hasContentTypeHeader &&
          (requestModel.hasJsonData || requestModel.hasTextData)) {
        headers[kHeaderContentType] = requestModel.bodyContentType.header;
      }

      if (headers.isNotEmpty) {
        var templateHeader = jj.Template(kTemplateHeader);
        result += templateHeader.render({
          "headers": headers,
        });
      }

      if (requestModel.hasTextData || requestModel.hasJsonData) {
        var templateBody = jj.Template(kTemplateBody);
        result += templateBody.render({
          "body": requestModel.body,
        });
      }

      if (requestModel.hasFormData) {
        result += "\nform_data = [";
        var templateMultiPartBody = jj.Template(kMultiPartBodyTemplate);
        int length = requestModel.formDataMapList.length;

        for (var element in requestModel.formDataMapList) {
          result += "[";
          result += templateMultiPartBody.render({
            "name": element["name"],
            "value": element["value"],
            "type": element["type"]
          });
          result += "]";
          if (--length > 0) result += ", ";
        }
        result += "]\n";
        result +=
            "request.set_form form_data, '${ContentType.formdata.header}'\n";
      }

      result += jj.Template(kStringRequest)
          .render({"method": requestModel.method.name});
      return result;
    } catch (e) {
      return null;
    }
  }
}
