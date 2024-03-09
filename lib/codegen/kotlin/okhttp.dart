import 'dart:convert';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/utils/utils.dart'
    show getValidRequestUri, stripUriParams;
import '../../models/request_model.dart';
import 'package:apidash/consts.dart';

class KotlinOkHttpCodeGen {
  final String kTemplateStart = """import okhttp3.OkHttpClient
import okhttp3.Request{{importForQuery}}{{importForBody}}

fun main() {
    val client = OkHttpClient()

""";

  final String kStringImportForQuery = """

import okhttp3.HttpUrl.Companion.toHttpUrl""";

  final String kStringImportForBody = """

import okhttp3.RequestBody.Companion.toRequestBody
import okhttp3.MediaType.Companion.toMediaType""";

  final String kTemplateUrl = '''

    val url = "{{url}}"

''';

  final String kTemplateUrlQuery = '''

    val url = "{{url}}".toHttpUrl().newBuilder()
{{params}}        .build()

''';

  String kTemplateRequestBody = '''

    val mediaType = "{{contentType}}".toMediaType()

    val body = """{{body}}""".toRequestBody(mediaType)

''';

  final String kStringRequestStart = """

    val request = Request.Builder()
        .url(url)
""";

  final String kTemplateRequestEnd = """
        .{{method}}({{hasBody}})
        .build()

    val response = client.newCall(request).execute()

    println(response.code)
    println(response.body?.string())
}

""";
// Converting list of form data objects to kolin multi part data
  String kFormDataBody = '''
    val body = MultipartBody.Builder().setType(MultipartBody.FORM){% for item in formDataList %}{% if item.type == 'file' %}
          .addFormDataPart("{{item.name}}",null,File("{{item.value}}").asRequestBody("application/octet-stream".toMediaType()))
          {% else %}.addFormDataPart("{{item.name}}","{{item.value}}")
          {% endif %}{% endfor %}.build()
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
        if (!hasQuery) {
          var templateUrl = jj.Template(kTemplateUrl);
          result += templateUrl.render({"url": url});
        }

        var method = requestModel.method;
        var requestBody = requestModel.requestBody;
        if (requestModel.isFormDataRequest) {
          var formDataTemplate = jj.Template(kFormDataBody);

          result += formDataTemplate.render({
            "formDataList": requestModel.formDataMapList,
          });
        } else if (kMethodsWithBody.contains(method) && requestBody != null) {
          var contentLength = utf8.encode(requestBody).length;
          if (contentLength > 0) {
            hasBody = true;
            String contentType = requestModel.requestBodyContentType.header;
            var templateBody = jj.Template(kTemplateRequestBody);
            result += templateBody
                .render({"contentType": contentType, "body": requestBody});
          }
        }

        var templateStart = jj.Template(kTemplateStart);
        var stringStart = templateStart.render({
          "importForQuery": hasQuery ? kStringImportForQuery : "",
          "importForBody": hasBody ? kStringImportForBody : ""
        });

        result = stringStart + result;
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
      result = """$result        .addQueryParameter("$k", "${params[k]}")\n""";
    }
    return result;
  }

  String getHeaders(Map<String, String> headers) {
    String result = "";
    for (final k in headers.keys) {
      result = """$result        .addHeader("$k", "${headers[k]}")\n""";
    }
    return result;
  }
}
