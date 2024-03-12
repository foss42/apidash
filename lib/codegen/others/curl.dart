import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/utils/utils.dart' show requestModelToHARJsonRequest;
import 'package:apidash/models/models.dart' show RequestModel;
import 'package:apidash/consts.dart';

// ignore: camel_case_types
class cURLCodeGen {
  String kTemplateStart = """curl{{method}} --url '{{url}}'
""";

  String kTemplateHeader = """ \\
  --header '{{name}}: {{value}}'
""";
  String kTemplateFormData = """ \\
  --form '{{name}}={{value}}'
""";

  String kTemplateBody = """ \\
  --data '{{body}}'
""";

  String? getCode(
    RequestModel requestModel,
  ) {
    try {
      String result = "";

      var harJson = requestModelToHARJsonRequest(
        requestModel,
        useEnabled: true,
      );

      var templateStart = jj.Template(kTemplateStart);
      result += templateStart.render({
        "method": switch (harJson["method"]) {
          "GET" => "",
          "HEAD" => " --head",
          _ => " --request ${harJson["method"]} \\\n "
        },
        "url": harJson["url"],
      });

      var headers = harJson["headers"];
      if (headers.isNotEmpty) {
        for (var item in headers) {
          if (requestModel.hasFormData && item["name"] == kHeaderContentType) {
            continue;
          }
          var templateHeader = jj.Template(kTemplateHeader);
          result += templateHeader
              .render({"name": item["name"], "value": item["value"]});
        }
      }

      if (requestModel.hasJsonData || requestModel.hasTextData) {
        var templateBody = jj.Template(kTemplateBody);
        result += templateBody.render({"body": requestModel.requestBody});
      } else if (requestModel.hasFormData) {
        for (var formData in requestModel.formDataList) {
          var templateFormData = jj.Template(kTemplateFormData);
          if (formData.name.isNotEmpty && formData.value.isNotEmpty) {
            result += templateFormData.render({
              "name": formData.name,
              "value":
                  "${formData.type == FormDataType.file ? '@' : ''}${formData.value}",
            });
          }
        }
      }

      return result;
    } catch (e) {
      return null;
    }
  }
}
