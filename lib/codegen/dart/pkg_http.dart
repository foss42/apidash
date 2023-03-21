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

String kStringUrlParams = """

  var urlQueryParams = Map<String,String>.from(uri.queryParameters);
  urlQueryParams.addAll(queryParams);
  uri = uri.replace(queryParameters: urlQueryParams);
""";

String kStringNoUrlParams = """

  uri = uri.replace(queryParameters: queryParams);
""";

String kTemplateHeaders = """

  var headers = {{headers}};
""";

String kTemplateBody = """

  String body = r'''{{body}}''';
""";

String kTemplateRequest = """

  response = await http.{{method}}(requestUrl""";

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

String getDartHttpCode(RequestModel requestModel) {
  //try {
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
      result += templateParams.render({"params": encoder.convert(params)});
      Uri uri = Uri.parse(url);
      if (uri.hasQuery) {
        result += kStringUrlParams;
      } else {
        result += kStringNoUrlParams;
      }
    }
  }

  var headersList = requestModel.requestHeaders;
  if (headersList != null) {
    var headers = rowsToMap(requestModel.requestHeaders) ?? {};
    if (headers.isNotEmpty) {
      hasHeaders = true;
      var templateHeaders = jj.Template(kTemplateHeaders);
      result += templateHeaders.render({"headers": encoder.convert(headers)});
    }
  }

  var method = requestModel.method;
  if (kMethodsWithBody.contains(method) && requestModel.requestBody != null) {
    var body = requestModel.requestBody;
    hasBody = true;
    var templateBody = jj.Template(kTemplateBody);
    result += templateBody.render({"body": body});
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
  //} catch (e) {
  //  return "An error was encountered while generating code. $kRaiseIssue";
  //}
}
