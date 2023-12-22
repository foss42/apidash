import 'dart:io';
import 'dart:convert';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart' show padMultilineString;
import 'package:apidash/models/models.dart' show RequestModel;

class DartHttpCodeGen {
  String kTemplateStart = """import 'package:http/http.dart' as http;

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
  String kStringRequestEnd = r""");

  int statusCode = response.statusCode;
  if (statusCode >= 200 && statusCode < 300) {
    print('Status Code: $statusCode');
    print('Response Body: ${response.body}');
  }
  else{
    print('Error Status Code: $statusCode');
    print('Error Response Body: ${response.body}');
  }
}
""";

  String? getCode(
    RequestModel requestModel,
    String defaultUriScheme,
  ) {
    try {
      String result = "";
      bool hasHeaders = false;
      bool hasBody = false;

      String url = requestModel.url;
      if (!url.contains("://") && url.isNotEmpty) {
        url = "$defaultUriScheme://$url";
      }
      var templateStartUrl = jj.Template(kTemplateStart);
      result += templateStartUrl.render({"url": url});

      var paramsList = requestModel.requestParams;
      if (paramsList != null) {
        var params = requestModel.paramsMap;
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
      var requestBody = requestModel.requestBody;
      if (kMethodsWithBody.contains(method) && requestBody != null) {
        var contentLength = utf8.encode(requestBody).length;
        if (contentLength > 0) {
          hasBody = true;
          var templateBody = jj.Template(kTemplateBody);
          result += templateBody.render({"body": requestBody});
        }
      }

      var headersList = requestModel.enabledRequestHeaders;
      if (headersList != null || hasBody) {
        var headers = requestModel.enabledHeadersMap;
        if (headers.isNotEmpty || hasBody) {
          hasHeaders = true;
          if (hasBody) {
            headers[HttpHeaders.contentTypeHeader] =
                kContentTypeMap[requestModel.requestBodyContentType] ?? "";
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
      return result;
    } catch (e) {
      return null;
    }
  }
}
