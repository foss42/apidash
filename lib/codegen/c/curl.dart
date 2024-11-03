import 'package:apidash_core/apidash_core.dart';
import 'package:jinja/jinja.dart' as jj;

class CCurlCodeGen {
  final String kTemplateStart = """#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>
struct ResponseData {
    char *data;
    size_t size;
};

size_t write_callback(char *ptr, size_t size, size_t nmemb, void *userdata) {
    struct ResponseData *response_data = (struct ResponseData *)userdata;
    size_t real_size = size * nmemb;

    response_data->data = realloc(response_data->data, response_data->size + real_size + 1);
    if (response_data->data == NULL) {
        fprintf(stderr, "Memory allocation failed\\n");
        return 0;
    }

    memcpy(&(response_data->data[response_data->size]), ptr, real_size);
    response_data->size += real_size;
    response_data->data[response_data->size] = 0;

    return real_size;
}
int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();
  if(curl) {
""";

  String kTemplateUrl = """\n    curl_easy_setopt(curl, CURLOPT_URL, "{{url}}");
""";

  String kTemplateBody = """
    {% if body %}
    const char *data = "{{body}}";
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, data);
    {% endif %}

""";

  String kTemplateFormData = """
    
    curl_mime *mime;
    curl_mimepart *part;
    mime = curl_mime_init(curl);
    {% for field in fields %}{% if field.type == "file" %}
    part = curl_mime_addpart(mime);
    curl_mime_name(part, "{{field.name}}");
    curl_mime_filedata(part, "{{field.value}}");
    {% else %}  
    part = curl_mime_addpart(mime);    
    curl_mime_name(part, "{{field.name}}");    
    curl_mime_data(part, "{{field.value}}", CURL_ZERO_TERMINATED);
    {% endif %}
    {% endfor %}
""";

  String kTemplateHeader = """
  
    struct curl_slist *headers = NULL;
  {% if headers %}{% for header, value in headers %}  headers = curl_slist_append(headers,"{{header}}: {{value}}");\n  {% endfor %}
  {% endif %}  curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
""";
  String kTemplateQueryParam = """""";

  String kTemplateRequest =
      """{% if method != "GET" and method != "POST" %}\n    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "{{method}}");{% endif %}""";

  final String kTemplateEnd = """
{% if formdata %}curl_easy_setopt(curl, CURLOPT_MIMEPOST, mime);{% endif %}
    struct ResponseData response_data = {0};
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_callback);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response_data);
    res = curl_easy_perform(curl);
    long response_code;
    curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, &response_code);
    printf("Response code: %ld\\n", response_code);
    printf("Response body: %s\\n", response_data.data);
    free(response_data.data);{% if formdata %}\n    curl_mime_free(mime);{% endif %}{% if headers %}\n    curl_slist_free_all(headers);{% endif %}
  }
  curl_easy_cleanup(curl);
  return 0;
}""";

  String? getCode(
    HttpRequestModel requestModel,
  ) {
    try {
      String result = "";
      var hasBody = false;

      var rec = getValidRequestUri(
        requestModel.url,
        requestModel.enabledParams,
      );

      Uri? uri = rec.$1;

      if (uri == null) {
        return result;
      }

      var templateStart = jj.Template(kTemplateStart);
      result += templateStart.render({
        "hasFormData": requestModel.hasFormData,
        "hasFileInFormData": requestModel.hasFileInFormData,
      });

      var method = requestModel.method.name.toUpperCase();
      var templateRequest = jj.Template(kTemplateRequest);
      result += templateRequest.render({
        "method": method,
        "hasBody": hasBody,
      });

      var templateUrl = jj.Template(kTemplateUrl);
      result += templateUrl.render({"url": uri});

      var headersList = requestModel.enabledHeaders;
      if (headersList != null ||
          requestModel.hasBody ||
          requestModel.hasTextData ||
          requestModel.hasJsonData) {
        var headers = requestModel.enabledHeadersMap;
        // if (requestModel.hasFormData) {
        //   headers.putIfAbsent("Content-Type", () => "multipart/form-data");
        // }
        if (requestModel.hasTextData || requestModel.hasJsonData) {
          headers.putIfAbsent(
              kHeaderContentType, () => requestModel.bodyContentType.header);
        }
        if (headers.isNotEmpty) {
          var templateHeader = jj.Template(kTemplateHeader);
          result += templateHeader.render({
            "headers": headers,
          });
        }
      }

      if (requestModel.hasTextData || requestModel.hasJsonData) {
        hasBody = true;
        var templateRawBody = jj.Template(kTemplateBody);
        String body = "";
        if (requestModel.body != null) {
          body =
              requestModel.body!.replaceAll('"', '\\"').replaceAll('\n', '\\n');
        }
        result += templateRawBody.render({"body": body});
      } else if (requestModel.hasFormData) {
        hasBody = true;
        var templateFormData = jj.Template(kTemplateFormData);
        result += templateFormData.render({
          "hasFileInFormData": requestModel.hasFileInFormData,
          "fields": requestModel.formDataMapList,
        });
      }
      if (requestModel.hasTextData) {}
      if (uri.hasQuery) {
        var params = uri.queryParameters;
        if (params.isNotEmpty) {
          var templateQueryParam = jj.Template(kTemplateQueryParam);
          result += templateQueryParam.render({"params": params});
        }
      }
      var headers = requestModel.enabledHeadersMap;
      bool allow = headers.isNotEmpty ||
          requestModel.hasTextData ||
          requestModel.hasJsonData;
      var templateEnd = jj.Template(kTemplateEnd);
      result += templateEnd.render({
        "formdata": requestModel.hasFormData,
        "headers": allow,
      });

      return result;
    } catch (e) {
      return null;
    }
  }
}
