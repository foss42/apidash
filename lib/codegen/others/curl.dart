import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/utils/utils.dart' show requestModelToHARJsonRequest;
import 'package:apidash/models/models.dart' show RequestModel;

// ignore: camel_case_types
class cURLCodeGen {
  String kTemplateStart = """curl{{method}} --url '{{url}}'
""";

  String kTemplateHeader = """ \\
  --header '{{name}}: {{value}}'
""";
  String kTemplateFormData = """ \\
  --form '{{name}}: {{value}}'
""";

  String kTemplateBody = """ \\
  --data '{{body}}'
""";

  String? getCode(
    RequestModel requestModel,
    String defaultUriScheme,
  ) {
    try {
      String result = "";

      String url = requestModel.url;
      if (!url.contains("://") && url.isNotEmpty) {
        url = "$defaultUriScheme://$url";
      }
      var rM = requestModel.copyWith(url: url);

      var harJson = requestModelToHARJsonRequest(rM, useEnabled: true);

      var templateStart = jj.Template(kTemplateStart);
      result += templateStart.render({
        "method": switch (harJson["method"]) {
          "GET" => "",
          "HEAD" => " --head",
          _ => " --request ${harJson["method"]} \\\n"
        },
        "url": harJson["url"],
      });

      var headers = harJson["headers"];
      if (headers.isNotEmpty) {
        for (var item in headers) {
          var templateHeader = jj.Template(kTemplateHeader);
          result += templateHeader
              .render({"name": item["name"], "value": item["value"]});
        }
      }
      if (harJson['formData'] != null) {
        var formDataList = harJson['formData'] as List<Map<String, dynamic>>;
        for (var formData in formDataList) {
          var templateFormData = jj.Template(kTemplateFormData);
          if (formData['type'] != null &&
              formData['name'] != null &&
              formData['value'] != null &&
              formData['name']!.isNotEmpty &&
              formData['value']!.isNotEmpty) {
            result += templateFormData.render({
              "name": formData["name"],
              "value":
                  "${formData['type'] == 'file' ? '@' : ''}${formData["value"]}",
            });
          }
        }
      }

      if (harJson["postData"]?["text"] != null) {
        var templateBody = jj.Template(kTemplateBody);
        result += templateBody.render({"body": harJson["postData"]["text"]});
      }
      return result;
    } catch (e) {
      return null;
    }
  }
}
