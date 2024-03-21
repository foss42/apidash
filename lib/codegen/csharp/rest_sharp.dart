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
      request.AddParameter("{{param}}", "{{value}}");
""";

  String kStringEnd = """
      var response = await client.ExecuteAsync(request);
      Console.WriteLine(response.Content);
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
        var templateParams = jj.Template(kTemplateParams);
        String paramsResult = "";
        for (var query in params) {
          paramsResult += templateParams
              .render({"param": query["name"], "value": query["value"]});
        }
        result += paramsResult;
        result += kStringLineBreak;
      }

      result += kStringEnd;
      return result;
    } catch (e) {
      return null;
    }
  }
}
