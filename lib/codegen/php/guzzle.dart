import 'package:apidash_core/apidash_core.dart';
import 'package:jinja/jinja.dart' as jj;

class PhpGuzzleCodeGen {
  String kTemplateImport = """<?php
require_once 'vendor/autoload.php';

use GuzzleHttp\\Client;
use GuzzleHttp\\Psr7\\Request;
{% if hasFormData %}use GuzzleHttp\\Psr7\\MultipartStream;{% endif %}


""";

  String kTemplateMultiPartBody = """
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

  String kTemplateRequest = r"""
$client = new Client();

$request = new Request('{{method}}', '{{url}}'{{queryParams}}{{headers}}{{body}});
$res = $client->sendAsync($request)->wait();

echo $res->getStatusCode() . "\n";
echo $res->getBody();

""";

  String? getCode(HttpRequestModel requestModel) {
    try {
      var templateImport = jj.Template(kTemplateImport);
      String importsData = templateImport.render({
        "hasFormData": requestModel.hasFormData,
      });

      String result = importsData;

      if (requestModel.hasFormData) {
        var templateMultiPartBody = jj.Template(kTemplateMultiPartBody);
        var renderedMultiPartBody = templateMultiPartBody.render({
          "fields_list": requestModel.formDataList.map((field) {
            var row = '''
    [
        'name'     => '${field.name}',
        'contents' => ${field.type == FormDataType.file ? "fopen('${field.value}', 'r')" : "'${field.value}'"}
    ]''';
            return row;
          }).join(",\n"),
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

        if (!requestModel.hasContentTypeHeader && requestModel.hasBody) {
          if (requestModel.hasJsonData || requestModel.hasTextData) {
            headerList.add(
                "'$kHeaderContentType' => '${requestModel.bodyContentType.header}'");
          }
          if (requestModel.hasFormData) {
            headerList.add(
                "'$kHeaderContentType' => '${requestModel.bodyContentType.header}; boundary=' . \$body->getBoundary()");
          }
        }
        result += templateHeader.render({
          "headers": headerList.join(",\n"),
        });
      }

      var templateBody = jj.Template(kTemplateBody);

      if (requestModel.hasJsonData || requestModel.hasTextData) {
        result += templateBody.render({"body": requestModel.body});
      }

      var templateRequest = jj.Template(kTemplateRequest);
      result += templateRequest.render({
        "url": stripUrlParams(requestModel.url),
        "method": requestModel.method.name.toLowerCase(),
        "queryParams": params.isNotEmpty ? ". \$queryParamsStr" : "",
        "headers": headerList.isNotEmpty ? ", \$headers" : "",
        "body": requestModel.hasBody ? ", \$body" : "",
      });

      return result;
    } catch (e) {
      return null;
    }
  }
}
