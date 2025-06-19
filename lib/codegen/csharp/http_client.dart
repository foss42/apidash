import 'package:apidash_core/apidash_core.dart';
import 'package:jinja/jinja.dart' as jj;

class CSharpHttpClientCodeGen {
  final String kTemplateNamespaces = r'''
using System;
using System.Net.Http;
{%- if formdata == 'multipart' %}
using System.IO;
{%- elif formdata == 'urlencoded' %}
using System.Collections.Generic;
{%- endif %}

''';

  final String kTemplateUri = '''
string uri = "{{ uri }}";

''';

  final String kTemplateHttpClientAndRequest = '''
using (var client = new HttpClient())
using (var request = new HttpRequestMessage(HttpMethod.{{ method | capitalize }}, uri))
{
''';

  final String kTemplateHeaders = r'''
    {% for name, value in headers -%}
    request.Headers.Add("{{ name }}", "{{ value}}");
    {% endfor %}
''';

  final String kTemplateFormUrlEncodedContent = '''
    var payload = new Dictionary<string, string>
    {
    {%- for data in formdata %}
        { "{{ data.name }}", "{{ data.value }}" },
    {%- endfor %}
    };
    var content = new FormUrlEncodedContent(payload);
''';

  final String kTemplateMultipartFormDataContent = r'''
    var content = new MultipartFormDataContent
    {
{%- for data in formdata %}
{%- if data.type == "text" %}
        { new StringContent("{{ data.value }}"), "{{ data.name }}" },
{%- else %}
        {
            new StreamContent(File.OpenRead("{{ data.value }}")), 
            "{{ data.name }}", 
            "{{ data.value }}"
        },
{%- endif %}
{%- endfor %}
    };
''';

  final String kTemplateRawBody = '''
    var payload = """
{{ body }}
""";
    var content = new StringContent(payload, null, "{{ mediaType }}");
''';

  final String kStringContentSetup = '''
    request.Content = content;
''';

  final kStringEnd = '''
    HttpResponseMessage response = await client.SendAsync(request);

    Console.WriteLine((int)response.StatusCode);
    Console.WriteLine(await response.Content.ReadAsStringAsync());
}
''';

  String? getCode(HttpRequestModel requestModel) {
    try {
      StringBuffer result = StringBuffer();

      // Include necessary C# namespace
      String formdataImport = requestModel.hasFormData
          ? "multipart" //(requestModel.hasFileInFormData ? "multipart" : "urlencoded")
          : "nodata";
      result.writeln(jj.Template(kTemplateNamespaces)
          .render({"formdata": formdataImport}));

      // Set request URL
      var (uri, _) =
          getValidRequestUri(requestModel.url, requestModel.enabledParams);
      if (uri != null) {
        result.writeln(jj.Template(kTemplateUri).render({"uri": uri}));
      }

      // Initialize HttpClient and create HttpRequestMessage
      result.writeln(jj.Template(kTemplateHttpClientAndRequest).render({
        "method": requestModel.method.name,
      }));

      // Set request headers
      var headers = requestModel.enabledHeadersMap;
      if (headers.isNotEmpty) {
        result.writeln(
            jj.Template(kTemplateHeaders).render({"headers": headers}));
      }

      // Set request body if exists
      if (kMethodsWithBody.contains(requestModel.method) &&
          requestModel.hasBody) {
        var requestBody = requestModel.body;

        if (!requestModel.hasFormData &&
            requestBody != null &&
            requestBody.isNotEmpty) {
          // if the request body is not formdata then render raw text body
          result.writeln(jj.Template(kTemplateRawBody).render({
            "body": requestBody,
            "mediaType": requestModel.bodyContentType.header,
          }));
        } else if (requestModel.hasFormData) {
          // final String renderingTemplate = requestModel.hasFileInFormData
          //     ? kTemplateMultipartFormDataContent
          //     : kTemplateFormUrlEncodedContent;

          final String renderingTemplate = kTemplateMultipartFormDataContent;
          result.writeln(jj.Template(renderingTemplate).render({
            "formdata": requestModel.formDataMapList,
          }));
        }

        result.writeln(kStringContentSetup);
      }

      // Send request and get response
      result.write(kStringEnd);
      return result.toString();
    } catch (e) {
      return null;
    }
  }
}
