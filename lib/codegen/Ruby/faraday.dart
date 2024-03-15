import 'dart:io';
import 'dart:convert';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart'
    show getNewUuid, getValidRequestUri, padMultilineString, stripUriParams;
import 'package:apidash/models/models.dart' show RequestModel;

class RubyFaradayCodeGen {
  final String kTemplateStart = """
require 'faraday'
{% if isFormDataRequest %}require 'base64'
{% endif %}
""";

  String kTemplateParams = """
require 'uri'

queryParams = {{params}}
queryParamsStr = '?' + URI.encode_www_form(queryParams)

""";
  int kParamsPadding = 14;

  String kTemplateBody = """

body = '{{body}}'

""";

  String kTemplateHeaders = """

headers = {{headers}}

""";
  String kTemplateFormHeaderContentType = '''
multipart/form-data; boundary={{boundary}}''';

  int kHeadersPadding = 10;

  String kTemplateConnection = """

conn = Faraday.new(url: "{{baseUrl}}") do |faraday|
  faraday.adapter Faraday.default_adapter
end

""";

  String kTemplateRequest = """

response = conn.{{method}} do |req|
  req.url "{{path}}" {{queryParamsStr}}
""";

  String kStringRequestBody = """
  req.body = body
""";

  String kStringRequestHeaders = """
  req.headers = headers
""";

  final String kStringRequestEnd = """
end

puts "Status Code: \#{response.status}"
puts "Response Body: \#{response.body}"
""";

  final String kStringFormDataBody = r'''
boundary = "{{boundary}}"

def build_form_data(fields,boundary)
  data = ''

  fields.each do |field|
    data += "--#{boundary}\r\n"
    data += "Content-Disposition: form-data; name=\"#{field['name']}\""

    if field['type'] == 'file'
      file_content = File.read(field['value'])
      encoded_file = Base64.strict_encode64(file_content)

      data += "; filename=\"#{File.basename(field['value'])}\"\r\n"
      data += "Content-Type: application/octet-stream\r\n\r\n"
      data += "#{encoded_file}\r\n"
    else
      data += "\r\n\r\n#{field['value']}\r\n"
    end
  end

  data += "--#{boundary}--\r\n"
  data
end
fields_list = {{fields_list}}
# Assign the generated form-data to the body variable
body = build_form_data(fields_list,boundary)
''';

  String? getCode(
    RequestModel requestModel,
    String defaultUriScheme,
  ) {
    String uuid = getNewUuid();

    try {
      String result = "";
      bool hasHeaders = false;
      bool hasQuery = false;
      bool hasBody = false;

      String url = requestModel.url;
      if (!url.contains("://") && url.isNotEmpty) {
        url = "$defaultUriScheme://$url";
      }

      var templateStartUrl = jj.Template(kTemplateStart);
      result += templateStartUrl.render(
        {'isFormDataRequest':requestModel.isFormDataRequest},
      );
      var rec = getValidRequestUri(
        url,
        requestModel.enabledRequestParams,
      );

      Uri? uri = rec.$1;

      if (uri != null) {
        if (uri.hasQuery) {
          var params = uri.queryParameters.entries
              .map((entry) => '"${entry.key}" => "${entry.value}"')
              .toList();
          if (params.isNotEmpty) {
            hasQuery = true;
            var templateParams = jj.Template(kTemplateParams);
            result +=
                templateParams.render({"params": '{${params.join(', ')}}'});
          }
        }

        var method = requestModel.method;
        var requestBody = requestModel.requestBody;
        if (kMethodsWithBody.contains(method) && requestBody != null) {
          var contentLength = utf8.encode(requestBody).length;
          if (contentLength > 0) {
            hasBody = true;
            var templateBody = jj.Template(kTemplateBody);
            result += templateBody.render({"body": requestBody});
          }
        }

        var headersList = requestModel.enabledRequestHeaders;
        if (headersList != null || hasBody) {
          var headers = requestModel.enabledHeadersMap.entries
              .map((entry) => '"${entry.key}" => "${entry.value}"')
              .toList();
          if (requestModel.isFormDataRequest) {
            headers
                .add('"Content-Type" => "multipart/form-data"');
          }

          if (headers.isNotEmpty || hasBody) {
            hasHeaders = true;
            if (hasBody && !requestModel.hasContentTypeHeader) {
              headers.add(
                  '"${HttpHeaders.contentTypeHeader}" => "${requestModel.requestBodyContentType.header}"');
            }
            var templateHeaders = jj.Template(kTemplateHeaders);
            result +=
                templateHeaders.render({"headers": '{${headers.join(', ')}}'});
          }
        }
        if (requestModel.isFormDataRequest) {
          var formDataBodyData = jj.Template(kStringFormDataBody);
          var fieldsListJson = json.encode(requestModel.formDataMapList);
          fieldsListJson = fieldsListJson.replaceAll(':', '=>');
          result += formDataBodyData.render(
            {
              "fields_list": fieldsListJson,
              "boundary": uuid,
            },
          );
        }
        var templateConnection = jj.Template(kTemplateConnection);
        result += templateConnection.render({
          "baseUrl": uri.scheme + '://' + uri.authority,
        });

        var templateRequest = jj.Template(kTemplateRequest);
        result += templateRequest.render({
          "method": method.name.toLowerCase(),
          "path": uri.path,
          "queryParamsStr": hasQuery ? " + queryParamsStr" : "",
        });

        if (hasBody || requestModel.isFormDataRequest) {
          result += '\n' + kStringRequestBody;
        }

        if (hasHeaders || requestModel.isFormDataRequest) {
          result += "\n" + kStringRequestHeaders;
        }

        result += kStringRequestEnd;
      }
      return result;
    } catch (e) {
      return null;
    }
  }
}
