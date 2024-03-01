import 'dart:convert';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/utils/utils.dart' show padMultilineString;
import 'package:apidash/models/models.dart' show RequestModel;

class RubyFaradayCodeGen {
  RubyFaradayCodeGen();

  String kTemplateStart = '''require 'faraday'
require 'json'
''';

  String kTemplateUrl = '''

url = "{{url}}"

''';

  String kTemplateUrlQuery = '''

url = "{{url}}"
''';

  String kTemplateRequestBody = '''

body = "{{body}}"

''';

  String kStringRequestStart = '''

conn = Faraday.new(url: url) do |faraday|
  faraday.adapter Faraday.default_adapter
end

response = conn.{{method}} do |req|
  req.headers['Content-Type'] = 'application/json'
{{body}}
end

puts response.body
''';

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

      var rec = Uri.parse(url);

      if (rec != null) {
        String url = rec.toString();
        if (rec.hasQuery) {
          var params = rec.queryParameters;
          if (params.isNotEmpty) {
            var templateParams = jj.Template(kTemplateUrlQuery);
            var paramsString = params.entries.map((e) => '${e.key}=${e.value}').join('&');
            result += templateParams.render({"url": url, "params": paramsString});
          }
        } else {
          var templateUrl = jj.Template(kTemplateUrl);
          result += templateUrl.render({"url": url});
        }

        var requestBody = requestModel.requestBody;
        if (['POST', 'PUT', 'PATCH', 'DELETE'].contains(requestModel.method.toString().toUpperCase()) && requestBody != null) {
          var templateBody = jj.Template(kTemplateRequestBody);
          result += templateBody.render({"body": requestBody});
        }

        var templateStart = jj.Template(kTemplateStart);
        result = templateStart.render({}) + result;
        var method = requestModel.method;
        var templateMethod = jj.Template(kStringRequestStart);
        result += templateMethod.render({"method": method.name.toLowerCase(), "body": requestBody != null ? "\n  req.body = body" : ""});
      }
      return result;
    } catch (e) {
      return null;
    }
  }
}
