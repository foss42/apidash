import 'dart:convert';
import 'package:apidash_core/apidash_core.dart';
import 'package:jinja/jinja.dart' as jj;

class CSharpRestSharp {
  String kStringImports = """
using System;
using RestSharp;
using System.Threading.Tasks;


""";

  String kStringInit = """
class Program
{
  static async Task Main(){
    try{
""";

  String kInitClientTemplate = """
      const String _baseUrl = "{{baseUrl}}";
      var client = new RestClient(_baseUrl);


""";

  String kMethodTypeTemplate = """
      var request = new RestRequest("{{path}}", Method.{{method}});


""";

  String kTemplateParams = """
      request.AddQueryParameter("{{param}}", "{{value}}");

""";

  String kTemplateHeaders = """
      request.AddHeader("{{header}}", "{{value}}");

""";

  String kTemplateFormData = """
      {% if type == "text" -%}
      request.AddParameter("{{name}}", "{{value}}", ParameterType.GetOrPost);
{% else -%}
       request.AddFile("{{name}}", "{{value}}", options: options);
{% endif -%}
""";

  String kStringFormDataOption = """
      request.AlwaysMultipartFormData = true;
""";

  String kStringFormdataFileOption = """
      var options = new FileParameterOptions
      {
          DisableFilenameEncoding = true
      };
""";

  String kTemplateJsonData = """
      var jsonBody = new {{jsonData}};
      request.AddJsonBody(jsonBody);


""";

  String kTemplateTextData = """
      var textBody = {{textData}};
      request.AddStringBody(textBody, ContentType.Plain);


""";

  String kStringEnd = """
      var response = await client.ExecuteAsync(request);
      Console.WriteLine("Status Code: " + (int)response.StatusCode);
      Console.WriteLine("Response Content: " + response.Content);
    }
    catch(Exception ex){
      Console.WriteLine("Error: " + ex);
    }
  }
}
""";

  String? getCode(HttpRequestModel requestModel) {
    try {
      String result = "";
      var rec = getValidRequestUri(
        requestModel.url,
        requestModel.enabledParams,
      );
      Uri? uri = rec.$1;
      if (uri != null) {
        jj.Template kNodejsImportTemplate = jj.Template(kStringImports);
        String importsData = kNodejsImportTemplate.render();
        result += importsData;

        result += kStringInit;

        jj.Template templateInitClient = jj.Template(kInitClientTemplate);
        String initClient = templateInitClient
            .render({"baseUrl": "${uri.scheme}://${uri.authority}"});
        result += initClient;

        jj.Template templateMethodType = jj.Template(kMethodTypeTemplate);
        String methodType = templateMethodType.render({
          "path": uri.path,
          "method": requestModel.method.name.capitalize(),
        });
        result += methodType;

        if (uri.hasQuery) {
          var params = uri.queryParameters;
          if (params.isNotEmpty) {
            jj.Template templateParams = jj.Template(kTemplateParams);
            String paramsResult = "";
            for (var item in params.entries) {
              paramsResult += templateParams
                  .render({"param": item.key, "value": item.value});
            }
            result += "$paramsResult\n";
          }
        }

        var headersList = requestModel.enabledHeaders;
        if (headersList != null ||
            requestModel.hasJsonData ||
            requestModel.hasTextData) {
          var headers = requestModel.enabledHeadersMap;
          if (requestModel.hasJsonData || requestModel.hasTextData) {
            headers[kHeaderContentType] = requestModel.bodyContentType.header;
          }
          if (headers.isNotEmpty) {
            jj.Template templateHeaders = jj.Template(kTemplateHeaders);
            String headersResult = "";
            for (var item in headers.entries) {
              headersResult += templateHeaders
                  .render({"header": item.key, "value": item.value});
            }
            result += "$headersResult\n";
          }
        }

        if (requestModel.hasFormData) {
          jj.Template templateFormData = jj.Template(kTemplateFormData);
          String formDataResult = "";
          for (var data in requestModel.formDataMapList) {
            formDataResult += templateFormData.render({
              "name": data["name"],
              "value": data["value"],
              "type": data["type"]
            });
          }
          result += kStringFormDataOption;
          if (requestModel.hasFileInFormData) {
            result += kStringFormdataFileOption;
          }
          result += "$formDataResult\n";
        }

        if (requestModel.hasJsonData) {
          var templateJsonData = jj.Template(kTemplateJsonData);
          Map<String, dynamic> bodyData = json.decode(requestModel.body!);
          List<String> jsonArr = [];

          bodyData.forEach((key, value) {
            jsonArr += ["$key = \"$value\""];
          });
          String jsonDataResult = "{\n${jsonArr.join(",\n")}\n}";

          result += templateJsonData.render({"jsonData": jsonDataResult});
        }

        if (requestModel.hasTextData) {
          jj.Template templateTextData = jj.Template(kTemplateTextData);
          result += templateTextData
              .render({"textData": jsonEncode(requestModel.body)});
        }

        result += kStringEnd;
      }
      return result;
    } catch (e) {
      return null;
    }
  }
}
