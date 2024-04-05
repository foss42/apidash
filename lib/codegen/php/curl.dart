import 'dart:convert';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/utils/utils.dart'
    show getNewUuid, getValidRequestUri, requestModelToHARJsonRequest;
import 'package:apidash/models/models.dart' show RequestModel;
import 'package:apidash/consts.dart';

class PHPcURLCodeGen {
  final String kTemplateStart = """
<?php

""";

  final String kTemplateUri = """
\$uri = "{{uri}}";

""";

  //defining query parameters
  String kTemplateParams = """

\$queryParams = [{{params}}];
\$queryString = "?" . http_build_query(\$queryParams);
if (count(\$queryParams) > 0) {
    \$uri .= \$queryString;
}

""";

  //initialising the request
  String kTemplateRequestInit = """

\$request = curl_init(\$uri);

""";

  String kTemplateBody = """

\$request_body = <<<EOF
{{body}}
EOF;

""";
  //specifying headers
  String kTemplateHeaders = """

\$headers = [{{headers}}];
curl_setopt(\$request, CURLOPT_HTTPHEADER, \$headers);

""";

  String kTemplateFormHeaderContentType = '''
multipart/form-data; boundary={{boundary}}''';

  String kTemplateRequest = """

curl_setopt(\$request, CURLOPT_RETURNTRANSFER, 1);
curl_setopt(\$request, {{method}}, 1);

""";

  //passing the request body
  String kStringRequestBody = """
curl_setopt(\$request, CURLOPT_POSTFIELDS, \$request_body);

""";

  //ending template
  final String kStringRequestEnd = """
\$response = curl_exec(\$request);
curl_close(\$request);
var_dump(\$response);

""";

  //template for generating unique boundary
  String kBoundaryUniqueIdTemplate = """
\$boundary = "{{uuid}}";

""";

  //
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

  //function to build formdata without 'file' type
  String kBuildFormDataFunctionWithoutFilesString = """
function build_data(\$boundary, \$fields)
{
    \$data = '';
    \$eol = "\\r\\n";

    \$delimiter = '-------------' . \$boundary;

    foreach (\$fields as \$name => \$content) {
        \$data .= "--" . \$delimiter . \$eol
            . 'Content-Disposition: form-data; name="' . \$name . "\\"" . \$eol . \$eol
            . \$content . \$eol;
    }
    \$data .= "--" . \$delimiter . "--" . \$eol;
    return \$data;
}
""";

  //function to build formdata with 'file' type
  String kBuildFormDataFunctionWithFilesString = """
function build_data_files(\$boundary, \$fields, \$files)
{
    \$data = '';
    \$eol = "\\r\\n";

    \$delimiter = '-------------' . \$boundary;

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

  //
  String kMultiPartBodyWithFiles = """
\$request_body = build_data_files(\$boundary, \$fields, \$files);

""";

  //
  String kMultiPartBodyWithoutFiles = """
\$request_body = build_data(\$boundary, \$fields);

""";

  String? getCode(RequestModel requestModel) {
    String uuid = getNewUuid();
    uuid = uuid.replaceAll(RegExp(r'-'), "");

    try {
      String result = "";
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

        // renders the initial request init function call
        var templateRequestInit = jj.Template(kTemplateRequestInit);
        result += templateRequestInit.render();

        var harJson =
            requestModelToHARJsonRequest(requestModel, useEnabled: true);

        var headers = harJson["headers"];

        //parses and adds the headers
        if (headers.isNotEmpty || requestModel.hasFormData) {
          var templateHeader = jj.Template(kTemplateHeaders);
          var m = {};
          for (var i in headers) {
            m[i["name"]] = i["value"];
          }

          if (requestModel.hasFormData) {
            // we will override any existing boundary and use our own boundary
            m['Content-Type'] =
                "multipart/form-data; boundary=-------------$uuid";

            var boundaryUniqueIdTemplate =
                jj.Template(kBoundaryUniqueIdTemplate);
            result += boundaryUniqueIdTemplate.render({"uuid": uuid});

            var fieldsString = '\$fields = [\n';
            var filesString = '\$files = [\n';

            for (var formData in requestModel.formDataMapList) {
              if (formData['type'] == 'text') {
                // the four spaces on the left hand side are for indentation, hence do not remove
                fieldsString +=
                    '    "${formData['name']}" => "${formData['value']}",\n';
              } else if (formData['type'] == 'file') {
                filesString +=
                    '    new File("${formData['name']}", "${formData['value']}"),\n';
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
          }

          var headersString = '\n';
          m.forEach((key, value) {
            headersString += "\t\t\t\t'$key: $value', \n";
          });

          result += templateHeader.render({
            "headers": headersString,
          });
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
