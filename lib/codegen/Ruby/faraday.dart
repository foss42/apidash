// import 'dart:io';
// import 'dart:convert';
// import 'package:jinja/jinja.dart' as jj;
// import 'package:apidash/consts.dart';
// import 'package:apidash/utils/utils.dart'
//     show getNewUuid, getValidRequestUri, padMultilineString, stripUriParams;
// import 'package:apidash/models/models.dart' show RequestModel;

// class RubyFaradayCodeGen {
//   final String kTemplateStart = """

// require 'faraday'
// {% if jsonisthere %}require 'json'
// {% endif %}
// url = "{{url}}"

// """;

//   String kTemplateParams = """

// params = {{params}}

// """;
//   int kParamsPadding = 9;

//   String kTemplateBody = """

// payload = r'''{{body}}'''

// """;

//   String kTemplateJson = """

// payload = '{{body}}'

// """;

//   String kTemplateHeaders = """

// headers = {{headers}}
// {% if jsonisthere %}
// additional_headers = {
//   "Content-Type" : "application/json"
// }
// headers.merge!(additional_headers)
// {% endif %}

// """;
//   String kTemplateFormHeaderContentType = '''
// multipart/form-data; boundary={{boundary}}''';

//   int kHeadersPadding = 10;

//   String kTemplateRequest = """

// conn = Faraday.new(url: url) do |faraday|
//   faraday.adapter Faraday.default_adapter
// end

// response = conn.{{method}} do |req|
// """;

//   final String kStringFormDataBody = r'''

// def build_data_list(fields):
//     dataList = []
//     for field in fields:
//         name = field.get('name', '')
//         value = field.get('value', '')
//         type_ = field.get('type', 'text')

//         dataList.append(encode('--{{boundary}}'))
//         if type_ == 'text':
//             dataList.append(encode(f'Content-Disposition: form-data; name="{name}"'))
//             dataList.append(encode('Content-Type: text/plain'))
//             dataList.append(encode(''))
//             dataList.append(encode(value))
//         elif type_ == 'file':
//             dataList.append(encode(f'Content-Disposition: form-data; name="{name}"; filename="{value}"'))
//             dataList.append(encode(f'Content-Type: {mimetypes.guess_type(value)[0] or "application/octet-stream"}'))
//             dataList.append(encode(''))
//             dataList.append(open(value, 'rb').read())
//     dataList.append(encode('--{{boundary}}--'))
//     dataList.append(encode(''))
//     return dataList

// dataList = build_data_list({{fields_list}})
// payload = b'\r\n'.join(dataList)
// ''';

//   String kStringRequestParams = """req.params = params""";

//   String kStringRequestBody = """, data=payload""";

//   String kStringRequestJson = """\nreq.body = payload""";

//   String kStringRequestHeaders = """
// req.headers = headers
// """;

//   final String kStringRequestEnd = """

// puts "Status Code: #{response.status}"
// puts "Response Body: #{response.body}"
// """;
// //   final String kStringaddContentType = """
// // additional_headers = {
// //   "Content-Type" : "application/json"
// // }
// // headers.merge!(additional_headers)
// // """;
//   String? getCode(
//     RequestModel requestModel,
//     String defaultUriScheme,
//   ) {
//     try {
//       String result = "";
//       bool hasQuery = false;
//       bool hasHeaders = false;
//       bool hasBody = false;
//       bool hasJsonBody = false;
//       String uuid = getNewUuid();

//       String url = requestModel.url;
//       if (!url.contains("://") && url.isNotEmpty) {
//         url = "$defaultUriScheme://$url";
//       }

//       var rec = getValidRequestUri(
//         url,
//         requestModel.enabledRequestParams,
//       );
//       Uri? uri = rec.$1;
//       if (uri != null) {
//         var templateStartUrl = jj.Template(kTemplateStart);
//         result += templateStartUrl.render({
//           "url": stripUriParams(uri),
//           'jsonisthere': hasJsonBody,
//         });

//         if (uri.hasQuery) {
//           var params = uri.queryParameters;
//           if (params.isNotEmpty) {
//             hasQuery = true;
//             var templateParams = jj.Template(kTemplateParams);
//             var paramsString = kEncoder.convert(params);
//             paramsString = padMultilineString(paramsString, kParamsPadding);
//             result += templateParams.render({"params": paramsString});
//           }
//         }

//         var method = requestModel.method;
//         var requestBody = requestModel.requestBody;
//         if (kMethodsWithBody.contains(method) && requestBody != null) {
//           var contentLength = utf8.encode(requestBody).length;
//           if (contentLength > 0) {
//             if (requestModel.requestBodyContentType == ContentType.json) {
//               hasJsonBody = true;
//               var templateBody = jj.Template(kTemplateJson);
//               result += templateBody.render({"body": requestBody.toString()});
//             } else {
//               hasBody = true;
//               var templateBody = jj.Template(kTemplateBody);
//               result += templateBody.render({"body": requestBody});
//             }
//           }
//         }

//         var headersList = requestModel.enabledRequestHeaders;
//         if (headersList != null || hasBody) {
//           var headers = requestModel.enabledHeadersMap;
//           if (requestModel.isFormDataRequest) {
//             var formHeaderTemplate =
//                 jj.Template(kTemplateFormHeaderContentType);
//             headers[HttpHeaders.contentTypeHeader] = formHeaderTemplate.render({
//               "boundary": uuid,
//             });
//           }
//           if (headers.isNotEmpty || hasBody) {
//             hasHeaders = true;
//             if (hasBody) {
//               headers[HttpHeaders.contentTypeHeader] =
//                   requestModel.requestBodyContentType.header;
//             }
//             var headersString = kEncoder.convert(headers);
//             headersString = padMultilineString(headersString, kHeadersPadding);
//             var templateHeaders = jj.Template(kTemplateHeaders);
//             result += templateHeaders
//                 .render({"headers": headersString, "jsonisthere": hasJsonBody});
//           }
//         }
//         if (requestModel.isFormDataRequest) {
//           var formDataBodyData = jj.Template(kStringFormDataBody);
//           result += formDataBodyData.render(
//             {
//               "fields_list": json.encode(requestModel.formDataMapList),
//               "boundary": uuid,
//             },
//           );
//         }
//         var templateRequest = jj.Template(kTemplateRequest);
//         result += templateRequest.render({
//           "method": method.name.toLowerCase(),
//         });

//         if (hasQuery) {
//           result += "\n" + kStringRequestParams;
//         }

//         if (hasBody || requestModel.isFormDataRequest) {
//           result += kStringRequestBody;
//         }

//         if (hasJsonBody || requestModel.isFormDataRequest) {
//           result += kStringRequestJson;
//         }

//         if (hasHeaders || requestModel.isFormDataRequest) {
//           result += "\n" + kStringRequestHeaders;
//         }
//         result += "\nend";
//         result += "\n" + kStringRequestEnd;
//       }
//       return result;
//     } catch (e) {
//       return null;
//     }
//   }
// }
// import 'dart:io';
// import 'dart:convert';
// import 'package:jinja/jinja.dart' as jj;
// import 'package:apidash/consts.dart';
// import 'package:apidash/utils/utils.dart'
//      show getNewUuid, getValidRequestUri, padMultilineString, stripUriParams;
// import 'package:apidash/models/models.dart' show RequestModel;

// class RubyFaradayCodeGen {
//   final String kTemplateStart = """
// require 'faraday'

// """;

//   String kTemplateParams = """
// require 'uri'

// queryParams = {{params}}
// queryParamsStr = '?' + URI.encode_www_form(queryParams)

// """;
//   int kParamsPadding = 14;

//   String kTemplateBody = """

// body = '{{body}}'

// """;

//   String kTemplateHeaders = """

// headers = {{headers}}

// """;
//   String kTemplateFormHeaderContentType = '''
// multipart/form-data; boundary={{boundary}}''';

//   int kHeadersPadding = 10;

//   String kTemplateConnection = """

// conn = Faraday.new(url: "{{baseUrl}}") do |faraday|
//   faraday.adapter Faraday.default_adapter
// end

// """;

//   String kTemplateRequest = """

// response = conn.{{method}} do |req|
//   req.url "{{path}}" {{queryParamsStr}}
// """;

//   String kStringRequestBody = """
//   req.body = body
// """;

//   String kStringRequestHeaders = """
//   req.headers = headers
// """;

//   final String kStringRequestEnd = """
// end

// puts "Status Code: \#{response.status}"
// puts "Response Body: \#{response.body}"
// """;

//   final String kStringFormDataBody = r'''
// def build_form_data(fields)
//   data = ''

//   fields.each do |field|
//     data += \"--\#{boundary}\r\n\"
//     data += \"Content-Disposition: form-data; name=\\\"\#{field['name']}\\\"\r\n\"
//     data += \"\r\n\"
//     data += field['value'] + '\\r\\n'
//   end

//   data += \"--\#{boundary}--\r\n\"
//   data
// end

// # Assign the generated form-data to the body variable
// body = build_form_data(fields_list)
// ''';

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
//         {},
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
//           if (requestModel.isFormDataRequest) {
//             headers.add('"Content-Type" => "multipart/form-data"');
//             result += kTemplateFormHeaderContentType.replaceFirst(
//                 '#{boundary}', uuid);
//           }

//           if (headers.isNotEmpty || hasBody) {
//             hasHeaders = true;
//             if (hasBody && !requestModel.hasContentTypeHeader) {
//               headers.add(
//                   '"${HttpHeaders.contentTypeHeader}" => "${requestModel.requestBodyContentType.header}"');
//             }
//             var templateHeaders = jj.Template(kTemplateHeaders);
//            result +=
//                 templateHeaders.render({"headers": '{${headers.join(', ')}}'});
//           }
//         }
//         if (requestModel.isFormDataRequest) {
//           var formDataBodyData = jj.Template(kStringFormDataBody);
//           result += formDataBodyData.render(
//             {
//               "fields_list": json.encode(requestModel.formDataMapList),
//               "boundary": uuid,
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

//         if (hasBody || requestModel.isFormDataRequest) {
//           result += '\n'+kStringRequestBody;
//         }

//         if (hasHeaders || requestModel.isFormDataRequest) {
//           result += "\n"+kStringRequestHeaders;
//         }

//         result += kStringRequestEnd;
//       }
//       return result;
//     } catch (e) {
//       return null;
//     }
//   }
// }
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
