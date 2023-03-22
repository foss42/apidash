import 'dart:io';
import 'dart:convert';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart' show RequestModel, rowsToMap;

String kTemplateUrl = """import 'package:http/http.dart' as http;

void main() async {
  var uri = Uri.parse('{{url}}');

""";

String kTemplateParams = """

  var queryParams = {{params}};
""";
int kParamsPadding = 20;

String kStringUrlParams = """

  var urlQueryParams = Map<String,String>.from(uri.queryParameters);
  urlQueryParams.addAll(queryParams);
  uri = uri.replace(queryParameters: urlQueryParams);
""";

String kStringNoUrlParams = """

  uri = uri.replace(queryParameters: queryParams);
""";

String kTemplateBody = """

  String body = r'''{{body}}''';

""";

String kBodyImportDartConvert = """
import 'dart:convert';
""";

String kBodyLength = """

  var contentLength = utf8.encode(body).length;
""";

String kTemplateHeaders = """

  var headers = {{headers}};

""";
int kHeadersPadding = 16;

String kTemplateRequest = """

  final response = await http.{{method}}(uri""";

String kStringRequestHeaders = """,
                                  headers: headers""";

String kStringRequestBody = """,
                                  body: body""";
String kStringRequestEnd = """);
""";

String kTemplateSingleSuccess = """

  if (response.statusCode == {{code}}) {
""";

String kTemplateMultiSuccess = """

  if ({{codes}}.contains(response.statusCode)) {\n""";

String kStringResult = r"""

    print('Status Code: ${response.statusCode}');
    print('Result: ${response.body}');
  }
  else{
    print('Error Status Code: ${response.statusCode}');
  }
}
""";

String padMultilineString(String text, int padding,
    {bool firstLinePadded = false}) {
  var lines = kSplitter.convert(text);
  int start = firstLinePadded ? 0 : 1;
  for (start; start < lines.length; start++) {
    lines[start] = ' ' * padding + lines[start];
  }
  return lines.join("\n");
}

String? getDartHttpCode(RequestModel requestModel) {
  try {
    String result = "";
    bool hasHeaders = false;
    bool hasBody = false;

    String url = requestModel.url;
    if (!url.contains("://") && url.isNotEmpty) {
      url = kDefaultUriScheme + url;
    }
    var templateUrl = jj.Template(kTemplateUrl);
    result += templateUrl.render({"url": url});

    var paramsList = requestModel.requestParams;
    if (paramsList != null) {
      var params = rowsToMap(requestModel.requestParams) ?? {};
      if (params.isNotEmpty) {
        var templateParams = jj.Template(kTemplateParams);
        var paramsString = kEncoder.convert(params);
        paramsString = padMultilineString(paramsString, kParamsPadding);
        result += templateParams.render({"params": paramsString});
        Uri uri = Uri.parse(url);
        if (uri.hasQuery) {
          result += kStringUrlParams;
        } else {
          result += kStringNoUrlParams;
        }
      }
    }

    var method = requestModel.method;
    if (kMethodsWithBody.contains(method) && requestModel.requestBody != null) {
      var contentLength = utf8.encode(requestModel.requestBody).length;
      if (contentLength > 0) {
        hasBody = true;
        var body = requestModel.requestBody;
        var templateBody = jj.Template(kTemplateBody);
        result += templateBody.render({"body": body});
        result = kBodyImportDartConvert + result;
        result += kBodyLength;
      }
    }

    var headersList = requestModel.requestHeaders;
    if (headersList != null || hasBody) {
      var headers = rowsToMap(requestModel.requestHeaders) ?? {};
      if (headers.isNotEmpty || hasBody) {
        hasHeaders = true;
        if (hasBody) {
          headers[HttpHeaders.contentLengthHeader] = r"$contentLength";
          switch (requestModel.requestBodyContentType) {
            case ContentType.json:
              headers[HttpHeaders.contentTypeHeader] = 'application/json';
              break;
            case ContentType.text:
              headers[HttpHeaders.contentTypeHeader] = 'text/plain';
              break;
          }
        }
        var headersString = kEncoder.convert(headers);
        headersString = padMultilineString(headersString, kHeadersPadding);
        var templateHeaders = jj.Template(kTemplateHeaders);
        result += templateHeaders.render({"headers": headersString});
      }
    }

    var templateRequest = jj.Template(kTemplateRequest);
    result += templateRequest.render({"method": method.name});

    if (hasHeaders) {
      result += kStringRequestHeaders;
    }

    if (hasBody) {
      result += kStringRequestBody;
    }

    result += kStringRequestEnd;

    var success = kCodegenSuccessStatusCodes[method]!;
    if (success.length > 1) {
      var templateMultiSuccess = jj.Template(kTemplateMultiSuccess);
      result += templateMultiSuccess.render({"codes": success});
    } else {
      var templateSingleSuccess = jj.Template(kTemplateSingleSuccess);
      result += templateSingleSuccess.render({"code": success[0]});
    }
    result += kStringResult;

    return result;
  } catch (e) {
    return null;
  }
}
