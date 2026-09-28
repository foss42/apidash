import 'package:apidash_core/apidash_core.dart';
import 'package:jinja/jinja.dart' as jj;
import '../../utils/utils.dart';
import '../codegen_utils.dart';

// ignore: camel_case_types
class cURLCodeGen {
  String kTemplateStart = """curl{{method}} --url {{url}}
""";

  String kTemplateHeader = """ \\
  --header {{header}}
""";
  String kTemplateFormData = """ \\
  {{option}} {{field}}
""";

  String kTemplateBody = """ \\
  {{option}} {{body}}
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
        "url": shellSingleQuoted(harJson["url"]),
      });

      var headers = harJson["headers"];
      if (headers.isNotEmpty) {
        for (var item in headers) {
          if (requestModel.hasFormData && item["name"] == kHeaderContentType) {
            continue;
          }
          String name = item["name"];
          String value = item["value"];
          var templateHeader = jj.Template(kTemplateHeader);
          result += templateHeader.render({
            // curl drops a header with an empty value unless it is written
            // as `Name;`
            "header": shellSingleQuoted(
              value.trim().isEmpty ? "$name;" : "$name: $value",
            ),
          });
        }
      }

      if (requestModel.hasJsonData || requestModel.hasTextData) {
        String body = requestModel.body!;
        var templateBody = jj.Template(kTemplateBody);
        result += templateBody.render({
          // `--data @name` would read the file `name`
          "option": body.startsWith("@") ? "--data-raw" : "--data",
          "body": shellSingleQuoted(body),
        });
      } else if (requestModel.hasFormData) {
        for (var formData in requestModel.formDataList) {
          var templateFormData = jj.Template(kTemplateFormData);
          if (formData.name.isNotEmpty) {
            result += templateFormData.render(
              formData.type == FormDataType.file
                  ? {
                      "option": "--form",
                      "field": shellSingleQuoted(
                        "${formData.name}=@${_formFilePath(formData.value)}",
                      ),
                    }
                  : {
                      "option": _isPlainFormText(formData.value)
                          ? "--form"
                          : "--form-string",
                      "field": shellSingleQuoted(
                        "${formData.name}=${formData.value}",
                      ),
                    },
            );
          }
        }
      }

      return result;
    } catch (e) {
      return null;
    }
  }

  /// Whether `--form` sends [value] unchanged. Otherwise curl reads a leading
  /// `@` or `<` as a file, strips surrounding whitespace and a leading quoted
  /// string, and treats `;` as the start of `;type=`-style options.
  bool _isPlainFormText(String value) =>
      value == value.trim() &&
      !value.startsWith(RegExp('[@<"]')) &&
      !value.contains(";");

  /// Returns the file [path] for `--form name=@path`, in double quotes when
  /// curl would otherwise split it at `;` or `,` or trim its whitespace.
  /// Inside the quotes curl only treats `\\` and `\"` as escapes.
  String _formFilePath(String path) {
    if (path == path.trim() &&
        !path.startsWith('"') &&
        !path.contains(RegExp('[;,]'))) {
      return path;
    }
    return '"${path.replaceAll(r'\', r'\\').replaceAll('"', r'\"')}"';
  }
}
