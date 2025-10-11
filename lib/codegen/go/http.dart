import 'package:apidash_core/apidash_core.dart';
import 'package:jinja/jinja.dart' as jj;

class GoHttpCodeGen {
  final String kTemplateStart = """package main

import (
  "fmt"
  "io"
  "net/http"
  "net/url"{% if hasBody %}
  "bytes"{% if hasFormData %}
  "mime/multipart"{% if hasFileInFormData %}
  "os"{% endif %}{% endif %}{% endif %}
)

func main() {
  client := &http.Client{}

""";

  String kTemplateUrl = """
  url, _ := url.Parse("{{url}}")

""";

  String kTemplateBody = """
  {% if body %}payload := bytes.NewBuffer([]byte(`{{body}}`)){% endif %}

""";

  String kTemplateFormData = """
  payload := &bytes.Buffer{}
  writer := multipart.NewWriter(payload){% if hasFileInFormData %}
  var (
    file *os.File
    part io.Writer
  ){% endif %}
  {% for field in fields %}
  {% if field.type == "file" %}file, _ = os.Open("{{field.value}}")
  defer file.Close()
  part, _ = writer.CreateFormFile("{{field.name}}", "{{field.value}}")
  io.Copy(part, file)
  {% else %}writer.WriteField("{{field.name}}", "{{field.value}}"){% endif %}{% endfor %}
  writer.Close()


""";

  String kTemplateHeader = """
{% if headers %}{% for header, value in headers %}
  req.Header.Set("{{header}}", "{{value}}"){% endfor %}
{% endif %}
""";

  String kStringFormDataHeader = """
  req.Header.Set("Content-Type", writer.FormDataContentType())
""";

  String kTemplateQueryParam = """
  query := url.Query()
  {% for key, value in params %}
  query.Set("{{key}}", "{{value}}"){% endfor %}

  url.RawQuery = query.Encode()

""";

  String kTemplateRequest = """
  req, _ := http.NewRequest("{{method}}", url.String(), {% if hasBody %}payload{% else %}nil{% endif %})

""";

  final String kTemplateEnd = """

  response, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer response.Body.Close()

  fmt.Println("Status Code:", response.StatusCode)
  body, _ := io.ReadAll(response.Body)
  fmt.Println("Response body:", string(body))
}""";

  String? getCode(
    HttpRequestModel requestModel,
  ) {
    try {
      String result = "";
      var hasBody = false;

      String url = requestModel.url;

      var templateStart = jj.Template(kTemplateStart);
      result += templateStart.render({
        "hasBody": requestModel.hasBody,
        "hasFormData": requestModel.hasFormData,
        "hasFileInFormData": requestModel.hasFileInFormData,
      });

      var templateUrl = jj.Template(kTemplateUrl);
      result += templateUrl.render({"url": url});

      var rec = getValidRequestUri(
        url,
        requestModel.enabledParams,
      );

      Uri? uri = rec.$1;

      if (uri != null) {
        if (requestModel.hasTextData || requestModel.hasJsonData) {
          hasBody = true;
          var templateRawBody = jj.Template(kTemplateBody);
          result += templateRawBody.render({"body": requestModel.body});
        } else if (requestModel.hasFormData) {
          hasBody = true;
          var templateFormData = jj.Template(kTemplateFormData);
          result += templateFormData.render({
            "hasFileInFormData": requestModel.hasFileInFormData,
            "fields": requestModel.formDataMapList,
          });
        }

        if (uri.hasQuery) {
          var params = uri.queryParameters;
          if (params.isNotEmpty) {
            var templateQueryParam = jj.Template(kTemplateQueryParam);
            result += templateQueryParam.render({"params": params});
          }
        }

        var method = requestModel.method.name.toUpperCase();
        var templateRequest = jj.Template(kTemplateRequest);
        result += templateRequest.render({
          "method": method,
          "hasBody": hasBody,
        });

        var headersList = requestModel.enabledHeaders;
        if (headersList != null || requestModel.hasBody) {
          var headers = requestModel.enabledHeadersMap;
          if (requestModel.hasJsonData || requestModel.hasTextData) {
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
        if (requestModel.hasFormData) {
          result += kStringFormDataHeader;
        }

        result += kTemplateEnd;
      }

      return result;
    } catch (e) {
      return null;
    }
  }
}
