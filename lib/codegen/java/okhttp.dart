import 'dart:convert';
import 'package:apidash_core/apidash_core.dart';
import 'package:jinja/jinja.dart' as jj;

class JavaOkHttpCodeGen {
  final String kTemplateStart = """
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;{{importForQuery}}{{importForBody}}{{importForFormData}}

import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient().newBuilder().build();

""";

  final String kStringImportForQuery = """

import okhttp3.HttpUrl;""";

  final String kStringImportForBody = """

import okhttp3.RequestBody;
import okhttp3.MediaType;""";

  final String kStringImportForFormData = """

import okhttp3.RequestBody;
import okhttp3.MultipartBody;""";

  final String kTemplateUrl = '''

        String url = "{{url}}";

''';

  final String kTemplateUrlQuery = '''

        HttpUrl url = HttpUrl.parse("{{url}}").newBuilder()
            {{params}}
            .build();

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

        try (Response response = client.newCall(request).execute()) {
            System.out.println(response.code());
            if (response.body() != null) {
                System.out.println(response.body().string());
            }
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}

""";
// Converting list of form data objects to kolin multi part data
  String kFormDataBody = '''
        RequestBody body = new MultipartBody.Builder().setType(MultipartBody.FORM)
            {%- for item in formDataList -%}
              {% if item.type == 'file' %}
            .addFormDataPart("{{ item.name }}",null,RequestBody.create(MediaType.parse("application/octet-stream"),new File("{{ item.value }}")))
              {%- else %}
            .addFormDataPart("{{ item.name }}","{{ item.value }}")
              {%- endif %}
            {%- endfor %}
            .build();

''';

  String? getCode(
    HttpRequestModel requestModel,
  ) {
    try {
      String result = "";
      bool hasQuery = false;
      bool hasBody = false;
      bool hasFormData = false;

      var rec = getValidRequestUri(
        requestModel.url,
        requestModel.enabledParams,
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
        var requestBody = requestModel.body;
        if (requestModel.hasFormData) {
          hasFormData = true;
          var formDataTemplate = jj.Template(kFormDataBody);

          result += formDataTemplate.render({
            "formDataList": requestModel.formDataMapList,
          });
        } else if (kMethodsWithBody.contains(method) && requestBody != null) {
          var contentLength = utf8.encode(requestBody).length;
          if (contentLength > 0) {
            hasBody = true;
            String contentType = requestModel.bodyContentType.header;
            var templateBody = jj.Template(kTemplateRequestBody);
            result += templateBody.render({
              "contentType": contentType,
              "body": kJsonEncoder.convert(requestBody)
            });
          }
        }

        var templateStart = jj.Template(kTemplateStart);
        var stringStart = templateStart.render({
          "importForQuery": hasQuery ? kStringImportForQuery : "",
          "importForBody": hasBody ? kStringImportForBody : "",
          "importForFormData": hasFormData ? kStringImportForFormData : ""
        });

        result = stringStart + result;
        result += kStringRequestStart;

        var headersList = requestModel.enabledHeaders;
        if (headersList != null) {
          var headers = requestModel.enabledHeadersMap;
          if (headers.isNotEmpty) {
            result += getHeaders(headers);
          }
        }

        var templateRequestEnd = jj.Template(kTemplateRequestEnd);
        result += templateRequestEnd.render({
          "method": method.name.toLowerCase(),
          "hasBody": (hasBody || requestModel.hasFormData) ? "body" : "",
        });
      }
      return result;
    } catch (e) {
      return null;
    }
  }

  String getQueryParams(Map<String, String> params) {
    final paramStrings = params.entries
        .map((entry) => '.addQueryParameter("${entry.key}", "${entry.value}")')
        .toList();
    return paramStrings.join('\n            ');
  }

  String getHeaders(Map<String, String> headers) {
    String result = "";
    for (final k in headers.keys) {
      result = """$result            .addHeader("$k", "${headers[k]}")\n""";
    }
    return result;
  }
}
