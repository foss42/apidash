import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/utils/utils.dart'
    show stripUrlParams;
import 'package:apidash/models/models.dart' show RequestModel;
import 'package:apidash/consts.dart';

class PhpGuzzleCodeGen {
  String kStringImportNode = """<?php
require_once 'vendor/autoload.php';

use GuzzleHttp\\Client;
use GuzzleHttp\\Psr7\\Request;
{% if hasFormData %}use GuzzleHttp\\Psr7\\MultipartStream;{% endif %}


""";

  String kMultiPartBodyTemplate = """
\$body = new MultipartStream([
{{fields_list}}
]);


""";

  String kTemplateParams = """
\$queryParams = [
{{params}}
];
\$queryParamsStr = '?' . http_build_query(\$queryParams);


""";

  String kTemplateHeader = """
\$headers = [
{{headers}}
];


""";

  String kTemplateBody = """
\$body = <<<END
{{body}}
END;


""";

  String kStringRequest = r"""
$client = new Client();

$request = new Request('{{method}}', '{{url}}'{{queryParams}}{{headers}}{{body}});
$res = $client->sendAsync($request)->wait();

echo $res->getStatusCode() . "\n";
echo $res->getBody();

""";

  String? getCode(RequestModel requestModel) {
    try {
      jj.Template kNodejsImportTemplate = jj.Template(kStringImportNode);
      String importsData = kNodejsImportTemplate.render({
        "hasFormData": requestModel.hasFormData,
      });

      String result = importsData;

      if (requestModel.hasFormData && requestModel.formDataMapList.isNotEmpty) {
        var templateMultiPartBody = jj.Template(kMultiPartBodyTemplate);
        var renderedMultiPartBody = templateMultiPartBody.render({
          "fields_list": requestModel.formDataMapList.map((field) {
            return '''
    [
        'name'     => '${field['name']}',
        'contents' => '${field['value']}'
    ],\n''';
          }).join(),
        });
        result += renderedMultiPartBody;
      }

      var params = requestModel.enabledParamsMap;
      if (params.isNotEmpty) {
        var templateParams = jj.Template(kTemplateParams);
        List<String> paramList = [];
        params.forEach((key, value) {
          paramList.add("'$key' => '$value'");
        });
        result += templateParams.render({
          "params": paramList.join(",\n"),
        });
      }

      var headers = requestModel.enabledHeadersMap;
      List<String> headerList = [];
      if (headers.isNotEmpty || requestModel.hasBody) {
        var templateHeader = jj.Template(kTemplateHeader);
        headers.forEach((key, value) {
          headerList.add("'$key' => '$value'");
        });

        if(!requestModel.hasContentTypeHeader && requestModel.hasBody){
          if(requestModel.hasJsonData || requestModel.hasTextData){
            headerList.add("'$kHeaderContentType' => '${requestModel.requestBodyContentType.header}'");
          }
          if(requestModel.hasFormData){
            headerList.add("'$kHeaderContentType' => '${requestModel.requestBodyContentType.header}; boundary=' . \$body->getBoundary()");
          }
        }
        result += templateHeader.render({
          "headers": headerList.join(",\n"),
        });
      }

      var templateBody = jj.Template(kTemplateBody);

      if (requestModel.hasJsonData || requestModel.hasTextData) {
        result += templateBody
            .render({"body": requestModel.requestBody});
      }

      var templateRequest = jj.Template(kStringRequest);
      result += templateRequest.render({
        "url": stripUrlParams(requestModel.url),
        "method": requestModel.method.name.toLowerCase(),
        "queryParams":
            params.isNotEmpty ? ". \$queryParamsStr" : "",
        "headers": headerList.isNotEmpty ? ", \$headers" : "",
        "body": requestModel.hasBody? ", \$body" : "",
      });

      return result;
    } catch (e) {
      return null;
    }
  }
}
