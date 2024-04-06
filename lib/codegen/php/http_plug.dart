import 'dart:convert';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/utils/utils.dart'
    show getValidRequestUri, requestModelToHARJsonRequest;
import 'package:apidash/models/models.dart' show RequestModel;

class PhpHttpPlugCodeGen {
  final String kTemplateStart = """
<?php
require_once 'vendor/autoload.php';

use Http\\Discovery\\Psr17FactoryDiscovery;
use Http\\Discovery\\Psr18ClientDiscovery;

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

""";

  String kTemplateHeaders = """
\$headers = [{{headers}}];
foreach (\$headers as \$name => \$value) {
    \$request = \$request->withHeader(\$name, \$value);
}

""";

  String kTemplateFormHeaderContentType = '''
multipart/form-data; boundary={{boundary}}''';

  String kStringRequestBody = """
\$request = \$request->withBody(Psr17FactoryDiscovery::findStreamFactory()->createStream(\$body));

""";

  final String kStringRequestEnd = """
\$client = Psr18ClientDiscovery::find();
\$response = \$client->sendRequest(\$request);

echo \$response->getStatusCode() . " " . \$response->getReasonPhrase() . "\\n";
echo \$response->getBody();

""";

  String kBoundaryUniqueIdTemplate = """
\$boundary = "{{boundary}}";

""";

  String kFileClassString = """
class File
{
    public string \$name;
    public string \$filename;
    public string \$content;

    function __construct(\$name, \$filename)
    {
        \$this->name = \$name;
        \$this->filename = \$filename;
        \$available_content = file_get_contents(\$this->filename);
        \$this->content = \$available_content ? \$available_content : "";
    }
}

""";

  String kBuildFormDataFunctionWithoutFilesString = """
function build_data(\$boundary, \$fields)
{
    \$data = '';
    \$eol = "\\r\\n";
    \$delimiter = \$boundary;

    foreach (\$fields as \$name => \$content) {
        \$data .= "--" . \$delimiter . \$eol
            . 'Content-Disposition: form-data; name="' . \$name . "\\"" . \$eol . \$eol
            . \$content . \$eol;
    }

    \$data .= "--" . \$delimiter . "--" . \$eol;

    return \$data;
}

""";

  String kBuildFormDataFunctionWithFilesString = """
function build_data_files(\$boundary, \$fields, \$files)
{
    \$data = '';
    \$eol = "\\r\\n";
    \$delimiter = \$boundary;

    foreach (\$fields as \$name => \$content) {
        \$data .= "--" . \$delimiter . \$eol
            . 'Content-Disposition: form-data; name="' . \$name . "\\"" . \$eol . \$eol
            . \$content . \$eol;
    }

    foreach (\$files as \$uploaded_file) {
        if (\$uploaded_file instanceof File) {
            \$data .= "--" . \$delimiter . \$eol
                . 'Content-Disposition: form-data; name="' . \$uploaded_file->name . '"; filename="' . \$uploaded_file->filename . '"' . \$eol
                . 'Content-Transfer-Encoding: binary' . \$eol;
            \$data .= \$eol;
            \$data .= \$uploaded_file->content . \$eol;
        }
    }

    \$data .= "--" . \$delimiter . "--" . \$eol;

    return \$data;
}

""";

  String kMultiPartBodyWithFiles = """
\$body = build_data_files(\$boundary, \$fields, \$files);

""";

  String kMultiPartBodyWithoutFiles = """
\$body = build_data(\$boundary, \$fields);

""";

  String? getCode(
    RequestModel requestModel, {
    String? boundary,
  }) {
    try {
      String result = "";
      bool hasBody = false;
      var requestBody = requestModel.requestBody;


      var rec = getValidRequestUri(
        requestModel.url,
        requestModel.enabledRequestParams,
      );
      Uri? uri = rec.$1;

      if (uri != null) {
        var templateStart = jj.Template(kTemplateStart);
        result += templateStart.render();

        if (requestModel.hasFileInFormData) {
          result += kFileClassString;
        }

        if (requestModel.hasFormData) {
          result += requestModel.hasFileInFormData
              ? kBuildFormDataFunctionWithFilesString
              : kBuildFormDataFunctionWithoutFilesString;
        }

        var templateUri = jj.Template(kTemplateUri);
        result += templateUri.render({"uri": requestModel.url.split("?")[0]});

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

        var harJson =
            requestModelToHARJsonRequest(requestModel, useEnabled: true);
        var headers = harJson["headers"];

        if (headers.isNotEmpty || requestModel.hasFormData) {
          var templateHeader = jj.Template(kTemplateHeaders);
          var m = {};
          for (var i in headers) {
            m[i["name"]] = i["value"];
          }

          if (requestModel.hasFormData) {
            m['Content-Type'] = "multipart/form-data; boundary=$boundary";
            var boundaryUniqueIdTemplate =
                jj.Template(kBoundaryUniqueIdTemplate);
            result += boundaryUniqueIdTemplate.render({"boundary": boundary});

            var fieldsString = '\$fields = [\n';
            var filesString = '\$files = [\n';
            for (var formData in requestModel.formDataMapList) {
              if (formData['type'] == 'text') {
                fieldsString +=
                    ' "${formData['name']}" => "${formData['value']}",\n';
              } else if (formData['type'] == 'file') {
                filesString +=
                    ' new File("${formData['name']}", "${formData['value']}"),\n';
              }
            }
            fieldsString += '];\n';
            filesString += '];\n';
            result += fieldsString;

            if (requestModel.hasFileInFormData) {
              result += filesString;
              result += kMultiPartBodyWithFiles;
            } else {
              result += kMultiPartBodyWithoutFiles;
            }
          } else if ((requestModel.hasTextData || requestModel.hasJsonData) && requestBody != null) {
            var contentLength = utf8.encode(requestBody).length;
            if (contentLength > 0) {
              hasBody = true;
              var templateBody = jj.Template(kTemplateBody);
              result += templateBody.render({"body": requestBody});
            }
          }

          var headersString = '\n';
          m.forEach((key, value) {
            headersString += "\t\t\t\t'$key' => '$value', \n";
          });
          result += templateHeader.render({
            "headers": headersString,
          });
        }

        if (hasBody || requestModel.hasFormData) {
          result += kStringRequestBody;
        }

        result += kStringRequestEnd;
      }

      return result;
    } catch (e) {
      return null;
    }
  }
}
