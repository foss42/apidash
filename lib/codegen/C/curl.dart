import 'package:apidash/consts.dart';
import 'package:apidash/utils/header_utils.dart';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/utils/utils.dart'
    show getValidRequestUri, requestModelToHARJsonRequest;
import 'package:apidash/models/models.dart' show RequestModel;

class cCurlCodeGen {
  final String kTemplateStart = """#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>


int main() {
  CURL *curl;
  CURLcode res;
  curl = curl_easy_init();
  if(curl) {
""";

  String kTemplateUrl = """

    curl_easy_setopt(curl, CURLOPT_URL, "{{url}}");
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl, CURLOPT_DEFAULT_PROTOCOL, "https");
    struct curl_slist *headers = NULL;
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
  {% if headers %}{% for header, value in headers %}  
    headers = curl_slist_append(headers,"{{header}}: {{value}}") {% endfor %}
  {% endif %} 
""";
  String kTemplateHeaderEnd = """

    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
""";
  String kStringFormDataHeader = """""";

  String kTemplateQueryParam = """

""";

  String kTemplateRequest = """
  
    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "{{method}}");
""";

  final String kTemplateEnd = """
      
    {% if formdata %}curl_easy_setopt(curl, CURLOPT_MIMEPOST, mime);{% endif %}
    res = curl_easy_perform(curl);
    {% if formdata %}curl_mime_free(mime);{% endif %}
    {% if headers %}curl_slist_free_all(headers);{% endif %}
  }
  curl_easy_cleanup(curl);
  return 0;
}""";

  String? getCode(
    RequestModel requestModel,
  ) {
    try {
      String result = "";
      var hasBody = false;
      var requestBody = requestModel.requestBody;

      String url = requestModel.url;

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

      var harJson =
          requestModelToHARJsonRequest(requestModel, useEnabled: true);
      var templateUrl = jj.Template(kTemplateUrl);
      String correctUrl = harJson["url"];
      result += templateUrl.render({"url": correctUrl});

      var rec = getValidRequestUri(
        url,
        requestModel.enabledRequestParams,
      );

      var headersList = requestModel.enabledRequestHeaders;
      if (headersList != null || requestModel.hasBody) {
        var headers = requestModel.enabledHeadersMap;
        if (requestModel.hasJsonData || requestModel.hasTextData) {
          headers.putIfAbsent(kHeaderContentType,
              () => requestModel.requestBodyContentType.header);
        }
        if (headers.isNotEmpty) {
          var templateHeader = jj.Template(kTemplateHeader);
          result += templateHeader.render({
            "headers": headers,
          });
        }
      }
      result += kTemplateHeaderEnd;

      Uri? uri = rec.$1;

      if (uri != null) {
        if (requestModel.hasTextData || requestModel.hasJsonData) {
          hasBody = true;
          var templateRawBody = jj.Template(kTemplateBody);
          result += templateRawBody.render({"body": requestBody});
        } else if (requestModel.hasFormData) {
          hasBody = true;
          var templateFormData = jj.Template(kTemplateFormData);
          result += templateFormData.render({
            "hasFileInFormData": requestModel.hasFileInFormData,
            "fields": requestModel.formDataMapList,
          });
        }
        if(requestModel.hasTextData){

        }
        if (uri.hasQuery) {
          var params = uri.queryParameters;
          if (params.isNotEmpty) {
            var templateQueryParam = jj.Template(kTemplateQueryParam);
            result += templateQueryParam.render({"params": params});
          }
        }
        var headers = requestModel.enabledHeadersMap;
        bool allow = headers.isNotEmpty ||
            requestModel.hasJsonData ||
            requestModel.hasTextData;
        var templateEnd = jj.Template(kTemplateEnd);
        result += templateEnd.render({
          "formdata": requestModel.hasFormData,
          "headers": allow,
        });
      }

      return result;
    } catch (e) {
      return null;
    }
  }
}
