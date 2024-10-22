import 'package:apidash_core/apidash_core.dart';
import 'package:jinja/jinja.dart' as jj;
import '../../utils/har_utils.dart';

class JavaHttpClientCodeGen {
  final String kTemplateStart = """import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.io.IOException;
{% if hasFormData %}import java.util.HashMap;
import java.util.Map;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;{% endif %}

public class Main {
  public static void main(String[] args) {
    try {
      HttpClient client = HttpClient.newHttpClient();

""";

  String kTemplateUrl = """
      URI uri = URI.create("{{url}}");

""";

  String kTemplateFormHeaderContentType = '''
multipart/form-data; boundary={{boundary}}''';

  String kTemplateMethod = """
{% if method == 'get' %}
      HttpRequest.Builder requestBuilder = HttpRequest.newBuilder(uri).GET();
{% elif method == 'post' %}
      HttpRequest.Builder requestBuilder = HttpRequest.newBuilder(uri).POST({% if hasBody %}bodyPublisher{% else %}HttpRequest.BodyPublishers.noBody(){% endif %});
{% elif method == 'put' %}
      HttpRequest.Builder requestBuilder = HttpRequest.newBuilder(uri).PUT({% if hasBody %}bodyPublisher{% else %}HttpRequest.BodyPublishers.noBody(){% endif %});
{% elif method == 'delete' %}
      HttpRequest.Builder requestBuilder = HttpRequest.newBuilder(uri).method("DELETE", {% if hasBody %}bodyPublisher{% else %}HttpRequest.BodyPublishers.noBody(){% endif %});
{% elif method == 'patch' %}
      HttpRequest.Builder requestBuilder = HttpRequest.newBuilder(uri).method("PATCH", {% if hasBody %}bodyPublisher{% else %}HttpRequest.BodyPublishers.noBody(){% endif %});
{% elif method == 'head' %}
      HttpRequest.Builder requestBuilder = HttpRequest.newBuilder(uri).method("HEAD", HttpRequest.BodyPublishers.noBody());
{% endif %}
""";

  String kTemplateRawBody = """
      HttpRequest.BodyPublisher bodyPublisher = HttpRequest.BodyPublishers.ofString(\"\"\"
      {{body}}\"\"\");
""";

  String kTemplateJsonBody = """
      HttpRequest.BodyPublisher bodyPublisher = HttpRequest.BodyPublishers.ofString(\"\"\"
{{body}}\"\"\");
""";

  String kTemplateFormData = """
      String boundary = "{{boundary}}";
      Map<Object, Object> data = new HashMap<>();
      {% for field in fields %}
      {% if field.type == "file" %}data.put("{{field.name}}", Paths.get("{{field.value}}"));{% else %}data.put("{{field.name}}", "{{field.value}}");{% endif %}{% endfor %}
      HttpRequest.BodyPublisher bodyPublisher = buildMultipartFormData(data, boundary);
""";

  String kTemplateHeader = """
      requestBuilder = requestBuilder.headers({% for header, value in headers %}
        "{{header}}", "{{value}}"{% if not loop.last %},{% endif %}{% endfor %}
      );

""";

  final String kTemplateEnd = """
      HttpResponse<String> response = client.send(requestBuilder.build(), HttpResponse.BodyHandlers.ofString());
      System.out.println("Response body: " + response.body());
      System.out.println("Response code: " + response.statusCode());
    } catch (IOException | InterruptedException e) {
      System.out.println("An error occurred: " + e.getMessage());
    }
  }
  {% if hasFormData %}
  private static HttpRequest.BodyPublisher buildMultipartFormData(Map<Object, Object> data, String boundary) throws IOException {
    var byteArrays = new ArrayList<byte[]>();
    var CRLF = "\\r\\n".getBytes(StandardCharsets.UTF_8);

    for (Map.Entry<Object, Object> entry : data.entrySet()) {
        byteArrays.add(("--" + boundary + "\\r\\n").getBytes(StandardCharsets.UTF_8));
        if (entry.getValue() instanceof Path) {
            var file = (Path) entry.getValue();
            var fileName = file.getFileName().toString();
            byteArrays.add(("Content-Disposition: form-data; name=\\"" + entry.getKey() + "\\"; filename=\\"" + fileName + "\\"\\r\\n").getBytes(StandardCharsets.UTF_8));
            byteArrays.add(("Content-Type: " + Files.probeContentType(file) + "\\r\\n\\r\\n").getBytes(StandardCharsets.UTF_8));
            byteArrays.add(Files.readAllBytes(file));
            byteArrays.add(CRLF);
        } else {
            byteArrays.add(("Content-Disposition: form-data; name=\\"" + entry.getKey() + "\\"\\r\\n\\r\\n").getBytes(StandardCharsets.UTF_8));
            byteArrays.add(entry.getValue().toString().getBytes(StandardCharsets.UTF_8));
            byteArrays.add(CRLF);
        }
    }
    byteArrays.add(("--" + boundary + "--\\r\\n").getBytes(StandardCharsets.UTF_8));

    return HttpRequest.BodyPublishers.ofByteArrays(byteArrays);
  }{% endif %}
}
""";

  String? getCode(
    HttpRequestModel requestModel, {
    String? boundary,
  }) {
    try {
      String result = "";
      var requestBody = requestModel.body;
      String url = requestModel.url;

      result += jj.Template(kTemplateStart).render({
        "hasFormData": requestModel.hasFormData,
      });

      var rec = getValidRequestUri(
        url,
        requestModel.enabledParams,
      );

      Uri? uri = rec.$1;

      var harJson =
          requestModelToHARJsonRequest(requestModel, useEnabled: true);

      if (uri != null) {
        var templateUrl = jj.Template(kTemplateUrl);
        result += templateUrl.render({"url": harJson["url"]});

        String? bodyPublisher = "";
        if (requestModel.hasTextData) {
          var templateBody = jj.Template(kTemplateRawBody);
          bodyPublisher = templateBody.render({"body": requestBody});
        } else if (requestModel.hasJsonData) {
          var templateBody = jj.Template(kTemplateJsonBody);
          bodyPublisher = templateBody.render({"body": requestBody});
        } else if (requestModel.hasFormData) {
          var templateFormData = jj.Template(kTemplateFormData);
          bodyPublisher = templateFormData.render({
            "fields": requestModel.formDataMapList,
            "boundary": boundary,
          });
        }

        result += bodyPublisher;

        var methodTemplate = jj.Template(kTemplateMethod);
        result += methodTemplate.render({
          "method": requestModel.method.name,
          "hasBody": requestModel.hasBody,
        });

        var headersList = requestModel.enabledHeaders;
        if (headersList != null || requestModel.hasBody) {
          var headers = requestModel.enabledHeadersMap;
          if (requestModel.hasJsonData || requestModel.hasTextData) {
            headers.putIfAbsent(
                kHeaderContentType, () => requestModel.bodyContentType.header);
          }
          if (requestModel.hasFormData) {
            var formDataHeader = jj.Template(kTemplateFormHeaderContentType);
            headers.putIfAbsent(
                kHeaderContentType,
                () => formDataHeader.render({
                      "boundary": boundary,
                    }));
          }
          if (headers.isNotEmpty) {
            var templateHeader = jj.Template(kTemplateHeader);
            result += templateHeader.render({
              "headers": headers,
            });
          }
        }

        var templateEnd = jj.Template(kTemplateEnd);
        result += templateEnd.render({
          "hasFormData": requestModel.hasFormData,
          "boundary": boundary,
        });
      }

      return result.replaceAll(RegExp('\\n\\n+'), '\n\n');
    } catch (e) {
      return null;
    }
  }
}
