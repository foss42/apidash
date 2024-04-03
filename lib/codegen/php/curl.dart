import 'dart:convert';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/utils/utils.dart'
    show getNewUuid, getValidRequestUri, requestModelToHARJsonRequest;
import 'package:apidash/models/models.dart' show RequestModel;
import 'package:apidash/consts.dart';

class PHPcURLCodeGen {
  final String kTemplateStart = r'''
<?php


''';

  final String kTemplateUri = r'''
$uri = '{{uri}}';


''';

  String kTemplateBody = r'''
{%- if body is iterable -%}
$request_body = [
{%- for data in body %}
{%- if data.type == 'text' %}
    '{{ data.name }}' => '{{ data.value }}',
{%- elif data.type == 'file' %}
    '{{ data.name }}' => new CURLFILE('{{ data.value }}'),
{%- endif %}
{%- endfor %}
];
{%- else -%}
$request_body = '{{body}}';
{%- endif %}


''';

  //defining query parameters
  String kTemplateParams = r'''
$queryParams = [
{%- for name, value in params %}
    '{{ name }}' => '{{ value }}',
{%- endfor %}
];
$uri .= '?' . http_build_query($queryParams);


''';

  //specifying headers
  String kTemplateHeaders = r'''
$headers = [
{%- for name, value in headers %}
    '{{ name }}: {{ value }}',
{%- endfor %}
];


''';

  //initialising the request
  String kStringRequestInit = r'''
$request = curl_init($uri);

''';

  String kTemplateRequestOptsInit = r'''
curl_setopt_array($request, [
    CURLOPT_RETURNTRANSFER => 1,
    CURLOPT_CUSTOMREQUEST => '{{ method|upper }}',

''';
  String kStringHeaderOpt = r'''
    CURLOPT_HTTPHEADER => $headers,
''';
  //passing the request body
  String kStringRequestBodyOpt = r'''
    CURLOPT_POSTFIELDS => $request_body,
''';

  //ending template
  final String kStringRequestEnd = r'''
    CURLOPT_SSL_VERIFYPEER => 0,
    CURLOPT_MAXREDIRS => 10,
    CURLOPT_TIMEOUT => 0,
    CURLOPT_FOLLOWLOCATION => true,
    CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
]);

$response = curl_exec($request);

curl_close($request);

$httpCode = curl_getinfo($request, CURLINFO_HTTP_CODE);
echo "Status Code: " . $httpCode . "\n";
echo $response;
''';

  String? getCode(RequestModel requestModel) {
    try {
      String result = "";
      bool hasHeaders = false;
      bool hasQuery = false;
      bool hasBody = false;

      var rec = getValidRequestUri(
        requestModel.url,
        requestModel.enabledRequestParams,
      );

      Uri? uri = rec.$1;

      //renders starting template
      if (uri != null) {
        var templateStart = jj.Template(kTemplateStart);
        result += templateStart.render();

        // if the request does not contain any file uploads, we do not need
        // to add the class for File in the request
        if (requestModel.hasFileInFormData) {
          result += kFileClassString;
        }

        //adds the function to build formdata with or without 'file' type
        if (requestModel.hasFormData) {
          result += requestModel.hasFileInFormData
              ? kBuildFormDataFunctionWithFilesString
              : kBuildFormDataFunctionWithoutFilesString;
        }

        var templateUri = jj.Template(kTemplateUri);
        result += templateUri.render({"uri": requestModel.url});

        //checking and adding query params
        if (uri.hasQuery) {
          var params = uri.queryParameters;
          if (params.isNotEmpty) {
            hasQuery = true;
            var templateParams = jj.Template(kTemplateParams);

            // generating the map of key and value for the query parameters
            List<String> queryList = [];
            for (MapEntry<String, String> entry in params.entries) {
              String entryStr = "\"${entry.key}\" => \"${entry.value}\"";
              queryList.add(entryStr);
            }
            String paramsString = "\n    ${queryList.join(",\n    ")}\n";

            result += templateParams.render({"params": paramsString});
          }
        }

        var headers = requestModel.enabledHeadersMap;
        if (requestModel.hasBody) {
          if (!headers.containsKey('Content-Type')) {
            if (requestModel.hasJsonData) {
              headers['Content-Type'] = 'application/json';
            } else if (requestModel.hasTextData) {
              headers['Content-Type'] = 'text/plain';
            }
          }
        }

        if (headers.isNotEmpty) {
          var templateHeader = jj.Template(kTemplateHeaders);
          result += templateHeader.render({'headers': headers});
        }

        // contains the HTTP method associated with the request
        var method = requestModel.method;

        // contains the entire request body as a string if body is present
        var requestBody = requestModel.requestBody;

        //renders the request body
        if (kMethodsWithBody.contains(method) && requestBody != null) {
          var contentLength = utf8.encode(requestBody).length;
          if (contentLength > 0) {
            hasBody = true;
            var templateBody = jj.Template(kTemplateBody);
            result += templateBody.render({"body": requestBody});
          }
        }

        //renders the request temlate
        var templateRequest = jj.Template(kTemplateRequest);
        result += templateRequest.render({
          "authority": uri.authority,
          "method": httpMethod(method.name.toUpperCase()),
          "path": uri.path,
          "queryParamsStr": hasQuery ? "queryParamsStr" : "",
        });

        if (hasBody || requestModel.hasFormData) {
          result += kStringRequestBody;
        }

        //and of the request
        result += kStringRequestEnd;
      }
      return result;
    } catch (e) {
      return null;
    }
  }

  //function for http verb to curl mapping
  String httpMethod(String methodName) {
    switch (methodName) {
      case "POST":
        return "CURLOPT_POST";
      case "GET":
        return "CURLOPT_HTTPGET";
      case "PUT":
        return "CURLOPT_PUT";
      case "DELETE":
        return "CURLOPT_CUSTOMREQUEST";
      case "PATCH":
        return "CURLOPT_CUSTOMREQUEST";
      case "HEAD":
        return "CURLOPT_NOBODY";
      default:
        return "";
    }
  }
}
