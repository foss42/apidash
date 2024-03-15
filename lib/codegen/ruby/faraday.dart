import 'dart:io';
import 'dart:convert';
import 'package:apidash/utils/file_utils.dart';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart'
    show getNewUuid, getValidRequestUri, padMultilineString, stripUriParams;
import 'package:apidash/models/models.dart' show RequestModel;

class RubyFaradayCodeGen {
  final String kTemplateStart = """
require 'faraday'
{% if hasFormData %}require 'base64'
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
  req.url "{{path}}" {{queryParamsStr}}\n
""";

  String kStringRequestBody = """\n
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
boundary = "{{boundary}}"
body = build_form_data(fields_list,boundary)

''';

//   String? getCode(
//     RequestModel requestModel,
//     String defaultUriScheme,
//   ) {
//     String uuid = getNewUuid();

//     try {
//       String result = "";
//       bool hasHeaders = false;
//       bool hasQuery = false;
//       bool hasBody = false;

//       String url = requestModel.url;
//       if (!url.contains("://") && url.isNotEmpty) {
//         url = "$defaultUriScheme://$url";
//       }

//       var templateStartUrl = jj.Template(kTemplateStart);
//       result += templateStartUrl.render(
//         {'hasFormData': requestModel.hasFormData},
//       );
//       var rec = getValidRequestUri(
//         url,
//         requestModel.enabledRequestParams,
//       );

//       Uri? uri = rec.$1;

//       if (uri != null) {
//         if (uri.hasQuery) {
//           var params = uri.queryParameters.entries
//               .map((entry) => '"${entry.key}" => "${entry.value}"')
//               .toList();
//           if (params.isNotEmpty) {
//             hasQuery = true;
//             var templateParams = jj.Template(kTemplateParams);
//             result +=
//                 templateParams.render({"params": '{${params.join(', ')}}'});
//           }
//         }

//         var method = requestModel.method;
//         var requestBody = requestModel.requestBody;
//         if (kMethodsWithBody.contains(method) && requestBody != null) {
//           var contentLength = utf8.encode(requestBody).length;
//           if (contentLength > 0) {
//             hasBody = true;
//             var templateBody = jj.Template(kTemplateBody);
//             result += templateBody.render({"body": requestBody});
//           }
//         }

//         var headersList = requestModel.enabledRequestHeaders;
//         if (headersList != null || hasBody) {
//           var headers = requestModel.enabledHeadersMap.entries
//               .map((entry) => '"${entry.key}" => "${entry.value}"')
//               .toList();
//           if (requestModel.hasFormData) {
//             headers.add('"Content-Type" => "multipart/form-data; boundary=$uuid"');
//           }

//           if (headers.isNotEmpty || hasBody || requestModel.hasFormData) {
//             hasHeaders = true;
//             if (hasBody && !requestModel.hasContentTypeHeader && !requestModel.hasFormData) {
//               headers.add(
//                   '"${HttpHeaders.contentTypeHeader}" => "${requestModel.requestBodyContentType.header}"');
//             }
//             var templateHeaders = jj.Template(kTemplateHeaders);
//             result +=
//                 templateHeaders.render({"headers": '{${headers.join(', ')}}'});
//           }
//         }
//         if (requestModel.hasFormData) {
//           var formDataBodyData = jj.Template(kStringFormDataBody);
//           var fieldsListJson = json.encode(requestModel.formDataMapList);
//           fieldsListJson = fieldsListJson.replaceAll(':', '=>');
//           result += formDataBodyData.render(
//             {
//               "fields_list": fieldsListJson,
//             },
//           );
//         }
//         var templateConnection = jj.Template(kTemplateConnection);
//         result += templateConnection.render({
//           "baseUrl": uri.scheme + '://' + uri.authority,
//         });

//         var templateRequest = jj.Template(kTemplateRequest);
//         result += templateRequest.render({
//           "method": method.name.toLowerCase(),
//           "path": uri.path,
//           "queryParamsStr": hasQuery ? " + queryParamsStr" : "",
//         });

//         if (hasBody || requestModel.hasFormData) {
//           result += '\n' + kStringRequestBody;
//         }

//         if (hasHeaders || requestModel.hasFormData) {
//           result += "\n" + kStringRequestHeaders;
//         }

//         result += kStringRequestEnd;
//       }
//       return result;
//     } catch (e) {
//       return null;
//     }
//   }
// }
String? getCode(
    RequestModel requestModel, {
    String? boundary,
  }) {
    try {
      String result = "";
      bool hasHeaders = false;
      bool hasQuery = false;
      bool hasBody = false;

      var templateStartUrl = jj.Template(kTemplateStart);
      result += templateStartUrl.render(
        {
          "hasFormData": requestModel.hasFormData,
        },
      );
      var rec = getValidRequestUri(
        requestModel.url,
        requestModel.enabledRequestParams,
      );

      Uri? uri = rec.$1;

      if (uri != null) {
        if (uri.hasQuery) {
          var params = uri.queryParameters;
          if (params.isNotEmpty) {
            hasQuery = true;
            var templateParams = jj.Template(kTemplateParams);
            var paramsString = kEncoder.convert(params);
            result += templateParams.render({"params": paramsString.replaceAll(':', ' =>')});
          }
        }

        if (requestModel.hasData) {
          hasBody = true;
          if (requestModel.hasJsonData || requestModel.hasTextData) {
            var templateBody = jj.Template(kTemplateBody);
            result += templateBody.render({"body": requestModel.requestBody});
          }
        }

        var headersList = requestModel.enabledRequestHeaders;
        if (headersList != null || hasBody) {
          var headers = requestModel.enabledHeadersMap;

          if (headers.isNotEmpty || hasBody) {
            hasHeaders = true;
            if (hasBody && !requestModel.hasContentTypeHeader) {
              if (requestModel.hasJsonData || requestModel.hasTextData) {
                headers[HttpHeaders.contentTypeHeader] =
                    requestModel.requestBodyContentType.header;
              } else if (requestModel.hasFormData) {
                var formHeaderTemplate =
                    jj.Template(kTemplateFormHeaderContentType);
                headers[HttpHeaders.contentTypeHeader] =
                    formHeaderTemplate.render({
                  "boundary": boundary,
                });
              }
            }
            var headersString = kEncoder.convert(headers);
            var templateHeaders = jj.Template(kTemplateHeaders);
            result += templateHeaders.render({"headers": headersString.replaceAll(':', ' =>')});
          }
        }
        if (requestModel.hasFormData) {
          var formDataBodyData = jj.Template(kStringFormDataBody);
          result += formDataBodyData.render(
            {
              "fields_list": json.encode(requestModel.formDataMapList).replaceAll(':', ' =>'),
              "boundary": boundary,
            },
          );
        }
        var templateConnection = jj.Template(kTemplateConnection);
        result += templateConnection.render({
          "baseUrl": uri.scheme + '://' + uri.authority
        });

        var templateRequest = jj.Template(kTemplateRequest);
        result += templateRequest.render({
          "method": requestModel.method.name.toLowerCase(),
          "path": uri.path,
          "queryParamsStr": hasQuery ? " + queryParamsStr" : "",
        });

        if (hasBody || requestModel.hasFormData) {
          result += kStringRequestBody;
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
