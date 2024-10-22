import 'dart:convert';
import 'package:apidash_core/apidash_core.dart';
import 'package:jinja/jinja.dart' as jj;

class PhpHttpPlugCodeGen {
  final String kTemplateStart = """
<?php
require_once 'vendor/autoload.php';

use Http\\Discovery\\Psr17FactoryDiscovery;
use Http\\Discovery\\Psr18ClientDiscovery;
{% if hasFormData %}use Http\\Message\\MultipartStream\\MultipartStreamBuilder;{% endif %}

""";

  final String kTemplateUri = """
\$uri = "{{uri}}";

""";

  String kTemplateParams = """
\$queryParams = [{{params}}];
\$uri .= '?' . http_build_query(\$queryParams);

""";

  String kTemplateRequestInit = """
\$request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('{{method}}', \$uri);

""";

  String kTemplateBody = """
\$body = <<<'EOF'
{{body}}
EOF;

\$request = \$request->withBody(Psr17FactoryDiscovery::findStreamFactory()->createStream(\$body));

""";

  String kTemplateHeaders = """
\$headers = [{{headers}}];
foreach (\$headers as \$name => \$value) {
    \$request = \$request->withHeader(\$name, \$value);
}

""";

  String kTemplateFormDataWithFiles = """
\$builder = new MultipartStreamBuilder();
{{formDataFields}}
{{formDataFiles}}
\$request = \$request->withBody(\$builder->build());

""";

  String kTemplateFormDataWithoutFiles = """
\$builder = new MultipartStreamBuilder();
{{formDataFields}}
\$request = \$request->withBody(\$builder->build());

""";

  final String kStringRequestEnd = """
\$client = Psr18ClientDiscovery::find();
\$response = \$client->sendRequest(\$request);

echo \$response->getStatusCode() . " " . \$response->getReasonPhrase() . "\\n";
echo \$response->getBody();

""";

  String? getCode(HttpRequestModel requestModel) {
    try {
      String result = "";

      var rec = getValidRequestUri(
        requestModel.url,
        requestModel.enabledParams,
      );
      Uri? uri = rec.$1;

      if (uri != null) {
        var templateStart = jj.Template(kTemplateStart);
        result += templateStart.render({
          "hasFormData": requestModel.hasFormData,
        });

        var templateUri = jj.Template(kTemplateUri);
        result += templateUri.render({"uri": stripUriParams(uri)});

        if (uri.hasQuery) {
          var params = uri.queryParameters;
          if (params.isNotEmpty) {
            var templateParams = jj.Template(kTemplateParams);
            List<String> queryList = [];
            for (MapEntry<String, String> entry in params.entries) {
              String entryStr = "\"${entry.key}\" => \"${entry.value}\"";
              queryList.add(entryStr);
            }
            String paramsString = "\n ${queryList.join(",\n ")}\n";
            result += templateParams.render({"params": paramsString});
          }
        }

        var templateRequestInit = jj.Template(kTemplateRequestInit);
        result += templateRequestInit
            .render({"method": requestModel.method.name.toUpperCase()});

        var requestBody = requestModel.body;

        if ((requestModel.hasTextData || requestModel.hasJsonData) &&
            requestBody != null) {
          var contentLength = utf8.encode(requestBody).length;
          if (contentLength > 0) {
            var templateBody = jj.Template(kTemplateBody);
            result += templateBody.render({"body": requestBody});
          }
        } else if (requestModel.hasFormData) {
          String formDataFields = "";
          String formDataFiles = "";

          for (var formData in requestModel.formDataMapList) {
            if (formData['type'] == 'text') {
              formDataFields +=
                  "\$builder->addResource('${formData['name']}', '${formData['value']}');\n";
            } else if (formData['type'] == 'file') {
              formDataFiles +=
                  "\$builder->addResource('${formData['name']}', fopen('${formData['value']}', 'r'), ['filename' => '${formData['value']}']);\n";
            }
          }

          if (requestModel.hasFileInFormData) {
            var templateFormDataWithFiles =
                jj.Template(kTemplateFormDataWithFiles);
            result += templateFormDataWithFiles.render({
              "formDataFields": formDataFields,
              "formDataFiles": formDataFiles,
            });
          } else {
            var templateFormDataWithoutFiles =
                jj.Template(kTemplateFormDataWithoutFiles);
            result += templateFormDataWithoutFiles.render({
              "formDataFields": formDataFields,
            });
          }
        }

        var headers = requestModel.enabledHeadersMap;
        if (requestModel.hasBody && !requestModel.hasContentTypeHeader) {
          if (requestModel.hasJsonData || requestModel.hasTextData) {
            headers[kHeaderContentType] =
                "'${requestModel.bodyContentType.header}'";
          }
          if (requestModel.hasFormData) {
            headers[kHeaderContentType] =
                "'${ContentType.formdata.header}; boundary=' . \$builder->getBoundary()";
          }
        }

        if (headers.isNotEmpty) {
          var templateHeader = jj.Template(kTemplateHeaders);
          var headersString = '\n';
          headers.forEach((key, value) {
            if (key == kHeaderContentType) {
              headersString += "    '$key' => $value,\n";
            } else {
              headersString += "    '$key' => '$value',\n";
            }
          });
          result += templateHeader.render({"headers": headersString});
        }

        result += kStringRequestEnd;
      }

      return result;
    } catch (e) {
      return null;
    }
  }
}
