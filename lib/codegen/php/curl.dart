import 'package:apidash_core/apidash_core.dart';
import 'package:jinja/jinja.dart' as jj;

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
    CURLOPT_FOLLOWLOCATION => true,
]);

$response = curl_exec($request);

curl_close($request);

$httpCode = curl_getinfo($request, CURLINFO_HTTP_CODE);
echo "Status Code: " . $httpCode . "\n";
echo $response . "\n";
''';

  String? getCode(HttpRequestModel requestModel) {
    try {
      String result = "";
      bool hasBody = false;

      var rec = getValidRequestUri(
        requestModel.url,
        requestModel.enabledParams,
      );

      Uri? uri = rec.$1;

      //renders starting template
      if (uri != null) {
        var templateStart = jj.Template(kTemplateStart);
        result += templateStart.render();

        var templateUri = jj.Template(kTemplateUri);
        result += templateUri.render({'uri': stripUriParams(uri)});

        //renders the request body contains the HTTP method associated with the request
        if (requestModel.hasBody) {
          hasBody = true;
          // contains the entire request body as a string if body is present
          var templateBody = jj.Template(kTemplateBody);
          result += templateBody.render({
            'body': requestModel.hasFormData
                ? requestModel.formDataMapList
                : requestModel.body,
          });
        }

        //checking and adding query params
        if (uri.hasQuery) {
          if (requestModel.enabledParamsMap.isNotEmpty) {
            var templateParams = jj.Template(kTemplateParams);
            result += templateParams
                .render({"params": requestModel.enabledParamsMap});
          }
        }

        var headers = requestModel.enabledHeadersMap;
        if (requestModel.hasBody && !requestModel.hasContentTypeHeader) {
          if (requestModel.hasJsonData || requestModel.hasTextData) {
            headers[kHeaderContentType] = requestModel.bodyContentType.header;
          }
        }

        if (headers.isNotEmpty) {
          var templateHeader = jj.Template(kTemplateHeaders);
          result += templateHeader.render({'headers': headers});
        }

        // renders the initial request init function call
        result += kStringRequestInit;

        //renders the request temlate
        var templateRequestOptsInit = jj.Template(kTemplateRequestOptsInit);
        result += templateRequestOptsInit
            .render({'method': requestModel.method.name});
        if (headers.isNotEmpty) {
          result += kStringHeaderOpt;
        }
        if (hasBody || requestModel.hasFormData) {
          result += kStringRequestBodyOpt;
        }

        //and of the request
        result += kStringRequestEnd;
      }
      return result;
    } catch (e) {
      return null;
    }
  }
}
