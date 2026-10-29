import 'package:apidash_core/apidash_core.dart';
import 'package:jinja/jinja.dart' as jj;
import '../../utils/utils.dart';

/// Safely escapes single quotes (apostrophes) for POSIX single-quoted shell arguments.
String escapeSingleQuotedShellArg(String? input) {
  if (input == null) {
    return "";
  }
  return input.replaceAll("'", r"'\''");
}

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
        "url": escapeSingleQuotedShellArg(harJson["url"]?.toString()),
      });

      var headers = harJson["headers"];
      if (headers.isNotEmpty) {
        for (var item in headers) {
          if (requestModel.hasFormData && item["name"] == kHeaderContentType) {
            continue;
          }
          var templateHeader = jj.Template(kTemplateHeader);
          result += templateHeader.render({
            "name": escapeSingleQuotedShellArg(item["name"]?.toString()),
            "value": escapeSingleQuotedShellArg(item["value"]?.toString()),
          });
        }
      }

      if (requestModel.hasJsonData || requestModel.hasTextData) {
        var templateBody = jj.Template(kTemplateBody);
        result += templateBody.render({
          "body": escapeSingleQuotedShellArg(requestModel.body),
        });
      } else if (requestModel.hasFormData) {
        for (var formData in requestModel.formDataList) {
          var templateFormData = jj.Template(kTemplateFormData);
          if (formData.name.isNotEmpty) {
            result += templateFormData.render({
              "name": escapeSingleQuotedShellArg(formData.name),
              "value":
                  "${formData.type == FormDataType.file ? '@' : ''}${escapeSingleQuotedShellArg(formData.value)}",
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
