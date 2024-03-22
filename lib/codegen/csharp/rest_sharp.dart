import 'dart:convert';

import 'package:jinja/jinja.dart' as jj;
import '../../models/request_model.dart';
import '../../utils/har_utils.dart';
import '../../utils/http_utils.dart';

class CSharpRestSharp {
  String kStringLineBreak = """


""";
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
      request.AddParameter("{{name}}", "{{value}}", ParameterType.RequestBody);
{% else -%}
       request.AddFile("{{name}}", "{{value}}");
{% endif -%}
      
""";
  String kTemplateJsonData = """
      var jsonBody = new {{jsonData}};
      request.AddJsonBody(jsonBody);
""";
  String kTemplateTextData = """
      var textBody = "{{textData}}";
      request.AddStringBody(textBody);
""";

  String kStringEnd = """
      var response = await client.ExecuteAsync(request);
      Console.WriteLine("Status Code: " + response.StatusCode);
      Console.WriteLine("Response Content: " + response.Content);
    }
    catch(Exception ex){
      Console.WriteLine("Error: " + ex);
    }
  }
} 
""";

  String? getCode(RequestModel requestModel) {
    try {
      var harJson =
          requestModelToHARJsonRequest(requestModel, useEnabled: true);

      String result = "";
      jj.Template kNodejsImportTemplate = jj.Template(kStringImports);
      String importsData = kNodejsImportTemplate.render();
      result += importsData;
      result += kStringLineBreak;

      result += kStringInit;

      jj.Template templateInitClient = jj.Template(kInitClientTemplate);
      String initClient =
          templateInitClient.render({"baseUrl": getBaseUrl(requestModel.url)});
      result += initClient;
      result += kStringLineBreak;

      jj.Template templateMethodType = jj.Template(kMethodTypeTemplate);
      String methodType = templateMethodType.render({
        "path": getUrlPath(requestModel.url),
        "method": requestModel.method.name.replaceRange(
            0,
            1,
            requestModel.method.name[0]
                .toUpperCase()) // making the first character capital
      });
      result += methodType;
      result += kStringLineBreak;

      var params = harJson["queryString"];
      if (params.isNotEmpty) {
        jj.Template templateParams = jj.Template(kTemplateParams);
        String paramsResult = "";
        for (var query in params) {
          paramsResult += templateParams
              .render({"param": query["name"], "value": query["value"]});
        }
        result += paramsResult;
        result += kStringLineBreak;
      }

      var headers = harJson["headers"];
      if (headers.isNotEmpty) {
        jj.Template templateHeaders = jj.Template(kTemplateHeaders);
        String headersResult = "";
        for (var header in headers) {
          headersResult += templateHeaders.render({
            "header": header["name"],
            "value": header["name"] == "Content-Type"
                ? header["value"]
                    .toString()
                    .split(';')
                    .first // boundary is removed
                : header["value"]
          });
        }
        result += headersResult;
        result += kStringLineBreak;
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
        result += formDataResult;
        result += kStringLineBreak;
      }

      if (requestModel.hasJsonData) {
        var templateJsonData = jj.Template(kTemplateJsonData);
        Map<String, dynamic> bodyData = json.decode(requestModel.requestBody!);
        String jsonDataResult = "{\n";

        bodyData.forEach((key, value) {
          jsonDataResult += "\t\t\t\t\t$key = \"$value\",\n";
        });
        jsonDataResult = jsonDataResult.length >= 3
            ? jsonDataResult.substring(0, jsonDataResult.length - 2)
            : jsonDataResult;
        jsonDataResult += "\n\t\t\t\t\t}";

        result += templateJsonData.render({"jsonData": jsonDataResult});
        result += kStringLineBreak;
      }

      if (requestModel.hasTextData) {
        jj.Template templateTextData = jj.Template(kTemplateTextData);
        result +=
            templateTextData.render({"textData": requestModel.requestBody});
        result += kStringLineBreak;
      }

      result += kStringEnd;
      return result;
    } catch (e) {
      return null;
    }
  }
}
