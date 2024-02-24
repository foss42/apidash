import 'dart:convert';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/utils/utils.dart' show getValidRequestUri, requestModelToHARJsonRequest, stripUriParams;
import '../../models/request_model.dart';
import 'package:apidash/consts.dart';

class JavaOkHttpCodeGen {
  final String kTemplateStart = """import okhttp3.*;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient();

""";

  final String kTemplateUrl = '''
        String url = "{{url}}";

''';

  final String kTemplateUrlQuery = '''
        HttpUrl url = HttpUrl.parse("{{url}}").newBuilder()
{{params}}                .build();

''';

  String kTemplateRequestBody = '''

        MediaType mediaType = MediaType.parse("{{contentType}}");

        RequestBody body = RequestBody.create({{body}}, mediaType);

''';

  final String kStringRequestStart = """

        Request request = new Request.Builder()
                .url(url)
""";

  final String kTemplateRequestEnd = """
                .{{method}}({{hasBody}})
                .build();

        try {
            okhttp3.Response response = client.newCall(request).execute();

            System.out.println(response.code());
            System.out.println(response.body().string());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

""";
  String kFormDataBody = '''

        FormBody.Builder formBuilder = new FormBody.Builder();
''';

  String? getCode(
    RequestModel requestModel,
    String defaultUriScheme,
  ) {
    try {
      String result = "";
      bool hasQuery = false;
      bool hasBody = false;

      String url = requestModel.url;
      if (!url.contains("://") && url.isNotEmpty) {
        url = "$defaultUriScheme://$url";
      }

      var rec = getValidRequestUri(
        url,
        requestModel.enabledRequestParams,
      );
      Uri? uri = rec.$1;

      if (uri != null) {
        String url = stripUriParams(uri);

        if (uri.hasQuery) {
          var params = uri.queryParameters;
          if (params.isNotEmpty) {
            hasQuery = true;
            var templateParams = jj.Template(kTemplateUrlQuery);
            result += templateParams
                .render({"url": url, "params": getQueryParams(params)});
          }
        }
        var rM = requestModel.copyWith(url: url);

      var harJson = requestModelToHARJsonRequest(rM, useEnabled: true);
        if (!hasQuery) {
          var templateUrl = jj.Template(kTemplateUrl);
          result += templateUrl.render({"url": url});
        }

        var method = requestModel.method;
        var requestBody = requestModel.requestBody;
        if (requestModel.isFormDataRequest && requestModel.formDataMapList.isNotEmpty) {
          for (var item in requestModel.formDataMapList) {
            kFormDataBody += """        formBuilder.add("${item["name"]}", "${item["value"]}");\n""";
          }
          result += kFormDataBody;
          result += """\n        RequestBody body = formBuilder.build();\n""";
        } else if (kMethodsWithBody.contains(method) && requestBody != null) {
          var contentLength = utf8.encode(requestBody).length;
          if (contentLength > 0) {
            hasBody = true;
            String contentType = requestModel.requestBodyContentType.header;
            var templateBody = jj.Template(kTemplateRequestBody);
            result += templateBody
                .render({"contentType": contentType, "body": kEncoder.convert(harJson["postData"]["text"])});
          }
        }

        result = kTemplateStart + result;
        result += kStringRequestStart;

        var headersList = requestModel.enabledRequestHeaders;
        if (headersList != null) {
          var headers = requestModel.enabledHeadersMap;
          if (headers.isNotEmpty) {
            result += getHeaders(headers);
          }
        }

        var templateRequestEnd = jj.Template(kTemplateRequestEnd);
        result += templateRequestEnd.render({
          "method": method.name.toLowerCase(),
          "hasBody": (hasBody || requestModel.isFormDataRequest) ? "body" : "",
        });
      }
      return result;
    } catch (e) {
      return null;
    }
  }

  String getQueryParams(Map<String, String> params) {
    String result = "";
    for (final k in params.keys) {
      result = """$result                .addQueryParameter("$k", "${params[k]}")\n""";
    }
    return result;
  }

  String getHeaders(Map<String, String> headers) {
    String result = "";
    for (final k in headers.keys) {
      result = """$result                .addHeader("$k", "${headers[k]}")\n""";
    }
    return result;
  }
}
