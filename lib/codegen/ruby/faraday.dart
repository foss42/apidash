import 'package:apidash_core/apidash_core.dart';
import 'package:jinja/jinja.dart' as jj;

// Note that delete is a special case in Faraday as API Dash supports request
// body inside delete reqest, but Faraday does not. Hence we need to manually
// setup request body for delete request and add that to request.
//
// Refer https://lostisland.github.io/faraday/#/getting-started/quick-start?id=get-head-delete-trace
class RubyFaradayCodeGen {
  final String kStringFaradayRequireStatement = """
require 'uri'
require 'faraday'
""";

  final String kStringFaradayMultipartRequireStatement = '''
require 'faraday/multipart'
''';

  final String kTemplateRequestUrl = """

REQUEST_URL = URI("{{ url }}")


""";

  final String kTemplateBody = """
PAYLOAD = <<HEREDOC
{{ body }}
HEREDOC


""";

  final String kTemplateFormParamsWithFile = """
PAYLOAD = {
{% for param in params %}{% if param.type == "text" %}  "{{ param.name }}" => Faraday::Multipart::ParamPart.new("{{ param.value }}", "text/plain"),
{% elif param.type == "file" %}  "{{ param.name }}" => Faraday::Multipart::FilePart.new("{{ param.value }}", "application/octet-stream"),{% endif %}{% endfor %}
}


""";

  final String kTemplateFormParamsWithoutFile = """
PAYLOAD = URI.encode_www_form({\n{% for param in params %}  "{{ param.name }}" => "{{ param.value }}",\n{% endfor %}})\n\n
""";

  final String kTemplateConnection = """
conn = Faraday.new do |faraday|
  faraday.adapter Faraday.default_adapter{% if hasFile %}\n  faraday.request :multipart{% endif %}
end


""";

  final String kTemplateRequestStart = """
response = conn.{{ method|lower }}(REQUEST_URL{% if doesMethodAcceptBody and containsBody %}, PAYLOAD{% endif %}) do |req|

""";

  final String kTemplateRequestParams = """
  req.params = {
{% for key, val in params %}    "{{ key }}" => "{{ val }}",\n{% endfor %}  }

""";

  final String kTemplateRequestHeaders = """
  req.headers = {
{% for key, val in headers %}    "{{ key }}" => "{{ val }}",\n{% endfor %}  }

""";

  final String kStringDeleteRequestBody = """
  req.body = PAYLOAD
""";

  final String kStringRequestEnd = """
end

""";

  final String kStringResponse = """
puts "Status Code: #{response.status}"
puts "Response Body: #{response.body}"
""";

  String? getCode(
    HttpRequestModel requestModel,
  ) {
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

      var url = stripUriParams(uri);

      result += kStringFaradayRequireStatement;
      if (requestModel.hasFormDataContentType &&
          requestModel.hasFileInFormData) {
        result += kStringFaradayMultipartRequireStatement;
      }

      var templateRequestUrl = jj.Template(kTemplateRequestUrl);
      result += templateRequestUrl.render({"url": url});

      if (requestModel.hasFormData) {
        jj.Template payload;
        if (requestModel.hasFileInFormData) {
          payload = jj.Template(kTemplateFormParamsWithFile);
        } else {
          payload = jj.Template(kTemplateFormParamsWithoutFile);
        }
        result += payload.render({"params": requestModel.formDataMapList});
      } else if (requestModel.hasJsonData || requestModel.hasTextData) {
        var templateBody = jj.Template(kTemplateBody);
        result += templateBody.render({
          "body": requestModel.body,
        });
      }

      // creating faraday connection for request
      var templateConnection = jj.Template(kTemplateConnection);
      result += templateConnection.render({
        "hasFile": requestModel.hasFormDataContentType &&
            requestModel.hasFileInFormData
      });

      // start of the request sending
      var templateRequestStart = jj.Template(kTemplateRequestStart);
      result += templateRequestStart.render({
        "method": requestModel.method.name,
        "doesMethodAcceptBody":
            kMethodsWithBody.contains(requestModel.method) &&
                requestModel.method != HTTPVerb.delete,
        "containsBody": requestModel.hasBody,
      });

      var headers = requestModel.enabledHeadersMap;
      if (requestModel.hasBody && !requestModel.hasContentTypeHeader) {
        if (requestModel.hasJsonData || requestModel.hasTextData) {
          headers[kHeaderContentType] = requestModel.bodyContentType.header;
        }
      }

      if (headers.isNotEmpty) {
        var templateRequestHeaders = jj.Template(kTemplateRequestHeaders);
        result += templateRequestHeaders.render({"headers": headers});
      }

      if (uri.hasQuery) {
        var params = uri.queryParameters;
        if (params.isNotEmpty) {
          var templateRequestParams = jj.Template(kTemplateRequestParams);
          result += templateRequestParams.render({"params": params});
        }
      }

      if (requestModel.hasBody && requestModel.method == HTTPVerb.delete) {
        result += kStringDeleteRequestBody;
      }

      result += kStringRequestEnd;
      result += kStringResponse;
      return result;
    } catch (e) {
      return null;
    }
  }
}
