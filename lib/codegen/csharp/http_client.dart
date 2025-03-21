import 'package:apidash_core/apidash_core.dart';
import 'package:jinja/jinja.dart' as jj;

class CSharpHttpClientCodeGen {
  final String kTemplateNamespaces = r'''
using System;
using System.Net.Http;
using System.Collections.Generic;
using System.Linq;
{%- if formdata == 'multipart' %}
using System.IO;
{%- endif %}

''';


final String kTemplateQueryParams = '''
string baseUri = "{{ baseUri }}";

var query = new Dictionary<string, List<string>>();
{%- for key, values in queryParams %}
query["{{ key }}"] = new List<string>();
{%- for value in values %}
query["{{ key }}"].Add("{{ value }}");
{%- endfor %}
{%- endfor %}

var queryString = string.Join("&", query.SelectMany(kv => kv.Value.Select(v => string.Format("{0}={1}", kv.Key, v))));
string uri = string.Format("{0}?{1}", baseUri, queryString);
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

      // Extract query parameters and URL
      String baseUri = requestModel.url.split('?')[0];
      var queryParams = requestModel.enabledParamsMap; 

      if (queryParams.isNotEmpty) {
        result.writeln(jj.Template(kTemplateQueryParams).render({
          "baseUri": baseUri,
          "queryParams": queryParams,
        }));
      } else {
        result.writeln('string uri = "$baseUri";\n');
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
