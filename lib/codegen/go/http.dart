import 'dart:convert';

import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/utils/utils.dart' show getValidRequestUri;
import 'package:apidash/models/models.dart' show RequestModel;
import 'package:apidash/consts.dart';

class GoHttpCodeGen {
  final String kTemplateStart = """package main

import (
  "fmt"
  "io"
  "net/http"
  "net/url"
  {% if isBody %}"bytes"
  {% if isFormDataRequest %}"mime/multipart"
  "os"{% endif %}{% endif %}
)

func main() {
  client := &http.Client{}

""";

  String kTemplateUrl = """
  url, err := url.Parse("{{url}}")
  if err != nil {
    fmt.Println(err)
    return
  }

""";

  String kTemplateRawBody = """
  {% if body %}body := strings.NewReader(`{{body}}`){% endif %}

""";

  String kTemplateJsonBody = """
  {% if body %}body := bytes.NewBuffer([]byte(`{{body}}`)){% endif %}

""";

  String kTemplateFormData = """
  body := &bytes.Buffer{}
  writer := multipart.NewWriter(body)
  var (
    file *os.File
    part io.Writer
  )
  {% for field in fields %}
  {% if field.type == "file" %}file, err = os.Open("{{field.value}}")
  if err != nil {
    fmt.Println(err)
    return
  }
  defer file.Close()

  part, err = writer.CreateFormFile("{{field.name}}", "{{field.value}}")
  if err != nil {
    fmt.Println(err)
    return
  }
  io.Copy(part, file)
  {% else %}writer.WriteField("{{field.name}}", "{{field.value}}"){% endif %}{% endfor %}
  writer.Close()


""";

  String kTemplateHeader = """
{% if headers %}{% for header, value in headers %}
  req.Header.Set("{{header}}", "{{value}}")
{% endfor %}
{% endif %}
""";

  String kTemplateQueryParam = """
  query := url.Query()
  {% for key, value in params %}
  query.Set("{{key}}", "{{value}}")
  {% endfor %}
  url.RawQuery = query.Encode()

""";

  String kTemplateRequest = """
  req, err := http.NewRequest("{{method}}", url.String(), {% if hasBody %}body{% else %}nil{% endif %})
  if err != nil {
    fmt.Println(err)
    return
  }

""";

  final String kTemplateEnd = """
  resp, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer resp.Body.Close()

  res, err := io.ReadAll(resp.Body)
  if err != nil {
    fmt.Println(err)
    return
  }
  fmt.Println(string(res))
}
""";

  String? getCode(
    RequestModel requestModel,
    String defaultUriScheme,
  ) {
    try {
      String result = "";
      var hasBody = false;
      var requestBody = requestModel.requestBody;

      String url = requestModel.url;
      if (!url.contains("://") && url.isNotEmpty) {
        url = "$defaultUriScheme://$url";
      }

      var templateStart = jj.Template(kTemplateStart);
      result += templateStart.render({
        "isBody": kMethodsWithBody.contains(requestModel.method) &&
            requestBody != null,
        "isFormDataRequest": requestModel.isFormDataRequest
      });

      var templateUrl = jj.Template(kTemplateUrl);
      result += templateUrl.render({"url": url});

      var rec = getValidRequestUri(
        url,
        requestModel.enabledRequestParams,
      );

      Uri? uri = rec.$1;

      if (uri != null) {
        var method = requestModel.method.name.toUpperCase();
        if (kMethodsWithBody.contains(requestModel.method) &&
            requestBody != null) {
          var contentLength = utf8.encode(requestBody).length;
          if (contentLength > 0) {
            hasBody = true;
          }
          if (requestModel.requestBodyContentType == ContentType.text) {
            var templateRawBody = jj.Template(kTemplateRawBody);
            result += templateRawBody.render({"body": requestBody});
          } else if (requestModel.requestBodyContentType == ContentType.json) {
            var templateJsonBody = jj.Template(kTemplateJsonBody);
            result += templateJsonBody.render({"body": requestBody});
          } else if (requestModel.isFormDataRequest) {
            hasBody = true;
            var templateFormData = jj.Template(kTemplateFormData);
            result += templateFormData.render({
              "fields": requestModel.formDataMapList,
            });
          }
        }

        if (uri.hasQuery) {
          var params = uri.queryParameters;
          if (params.isNotEmpty) {
            var templateQueryParam = jj.Template(kTemplateQueryParam);
            result += templateQueryParam.render({"params": params});
          }
        }

        var templateRequest = jj.Template(kTemplateRequest);
        result +=
            templateRequest.render({"method": method, "hasBody": hasBody});

        var headersList = requestModel.enabledRequestHeaders;
        if (headersList != null) {
          var headers = requestModel.enabledHeadersMap;
          if (headers.isNotEmpty) {
            var templateHeader = jj.Template(kTemplateHeader);
            result += templateHeader.render({"headers": headers});
          }
        }

        result += kTemplateEnd;
      }

      return result;
    } catch (e) {
      return null;
    }
  }
}
