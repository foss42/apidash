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

  //specifying headers
  String kTemplateHeaders = """

\$headers = [{{headers}}];
curl_setopt(\$request, CURLOPT_HTTPHEADER, \$headers);

""";

  //request template
  String kTemplateRequest = """

curl_setopt(\$request, CURLOPT_RETURNTRANSFER, 1);
curl_setopt(\$request, {{method}}, 1);

""";


  //ending template
  final String kStringRequestEnd = """
\$response = curl_exec(\$request);
curl_close(\$request);
var_dump(\$response);

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
