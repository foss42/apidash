import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/utils/utils.dart'
    show requestModelToHARJsonRequest;
import 'package:apidash/models/models.dart' show RequestModel;
import 'package:apidash/consts.dart';

class RubyNetHttpCodeGen {
  String kTemplateStart = """require "uri"
require "net/http"

url = URI("{{url}}")
https = Net::HTTP.new(url.host, url.port)
{% if check == "https" %}https.use_ssl = true{% endif %}
request = Net::HTTP::{{method}}.new(url)
""";

  String kTemplateHeader = """

{% for header in headers %}
{% if 'multipart' not in header['value'] %}request["{{ header['name'] }}"] = "{{ header['value'] }}"{% endif %}{% endfor %}
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
{% if method != "HEAD" %}puts "Response Body: #{response.body}"{% else %}puts "Response Body: #{response.to_hash}"{% endif %}

""";

  String? getCode(RequestModel requestModel) {
    try {
      String result = "";

      var harJson =
          requestModelToHARJsonRequest(requestModel, useEnabled: true);

      var templateStart = jj.Template(kTemplateStart);
      result += templateStart.render({
        "url": harJson["url"],
        "method": harJson["method"].toString().substring(0, 1).toUpperCase() +
            harJson["method"].toString().substring(1).toLowerCase(),
        "check": harJson["url"].toString().substring(0, 5),
      });

      var headers = harJson["headers"];
      if (headers.isNotEmpty) {
        var templateHeader = jj.Template(kTemplateHeader);
        result += templateHeader.render({
          "headers": headers,
        });
      }

      if (requestModel.hasTextData || requestModel.hasJsonData) {
        var templateBody = jj.Template(kTemplateBody);
        result += templateBody.render({
          "body": requestModel.requestBody,
        });
      }

      if (requestModel.hasFormData) {
        result += "\n";
        result += "form_data = [";
        var templateMultiPartBody = jj.Template(kMultiPartBodyTemplate);
        int length = requestModel.formDataMapList.length;
  
        for (var element in requestModel.formDataMapList) {
          result += "[";
          result += templateMultiPartBody.render({
            "name": element["name"],
            "value": element["value"],
            "type": element["type"]
          });
          length -= 1;
          if (length == 0) {
            result += "]";
          } else {
            result += "],";
          }
        }
        // result.substring(0,result.length - 1);
        result += "]\n";
        result += "request.set_form form_data, 'multipart/form-data'";
      }

      result +=
          jj.Template(kStringRequest).render({"method": harJson["method"]});
      return result;
    } catch (e) {
      return null;
    }
  }
}
