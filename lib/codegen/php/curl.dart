import 'dart:convert';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/utils/utils.dart'
    show getNewUuid, getValidRequestUri, requestModelToHARJsonRequest;
import 'package:apidash/models/models.dart' show RequestModel;
import 'package:apidash/consts.dart';

class PHPcURLCodeGen {
  //starting template
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
