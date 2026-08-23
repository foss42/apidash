import 'package:apidash_core/apidash_core.dart';
import 'package:jinja/jinja.dart' as jj;
import '../../utils/utils.dart';

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

  String kTemplateFileBody = """ \\
  --data-binary '@{{body}}'
""";

  String? getCode(
    HttpRequestModel requestModel,
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

      if (requestModel.hasJsonData || requestModel.hasTextData || requestModel.hasFormUrlEncodedData) {
        var templateBody = jj.Template(kTemplateBody);
        result += templateBody.render({"body": requestModel.body});
      } else if (requestModel.hasFileData) {
        var templateFileBody = jj.Template(kTemplateFileBody);
        result += templateFileBody.render({"body": requestModel.bodyFile});
      } else if (requestModel.hasFormData) {
        for (var formData in requestModel.formDataList) {
          var templateFormData = jj.Template(kTemplateFormData);
          if (formData.name.isNotEmpty) {
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
