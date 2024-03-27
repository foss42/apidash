import 'package:apidash/consts.dart';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/utils/utils.dart' show getValidRequestUri;
import 'package:apidash/utils/http_utils.dart' show stripUriParams;

import 'package:apidash/models/models.dart' show RequestModel;

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
\nREQUEST_URL = URI("{{ url }}")\n\n
""";

  final String kTemplateBody = """
PAYLOAD = <<-{{ boundary }}
{{ body }}
{{ boundary }}\n\n
""";

  final String kTemplateFormParamsWithFile = """
PAYLOAD = {
{% for param in params %}{% if param.type == "text" %}  "{{ param.name }}" => Faraday::Multipart::ParamPart.new("{{ param.value }}", "text/plain"),
{% elif param.type == "file" %}  "{{ param.name }}" => Faraday::Multipart::FilePart.new("{{ param.value }}", "application/octet-stream"),{% endif %}{% endfor %}
}\n\n
""";

  final String kTemplateFormParamsWithoutFile = """
PAYLOAD = URI.encode_www_form({\n{% for param in params %}  "{{ param.name }}" => "{{ param.value }}",\n{% endfor %}})\n\n
""";

  final String kTemplateConnection = """
conn = Faraday.new do |faraday|
  faraday.adapter Faraday.default_adapter{% if hasFile %}\n  faraday.request :multipart{% endif %}
end\n\n
""";

}
