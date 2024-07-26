import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/utils/utils.dart'
    show padMultilineString, requestModelToHARJsonRequest, stripUrlParams;
import 'package:apidash/models/models.dart';
import 'package:apidash/consts.dart';

class RCodeGen {
  RCodeGen();

  String kStringImportR = """library(httr)
{%if hasFileInFormData -%}
library(httr)
{% endif %}

""";

  String kTemplateStart = """request <- httr::VERB(
  '{{method}}',
  url = '{{url}}'
""";

  String kTemplateParams = """,
  query = list({{params}})
""";

  String kTemplateHeader = """,
  add_headers({{headers}})
""";

  String kTemplateBody = """,
  body = {{body}}
""";

  String kStringRequest = """)
response <- request

print(status_code(response))
print(content(response))
""";

  String? getCode(
    HttpRequestModel requestModel,
  ) {
    try {
      jj.Template kRImportTemplate = jj.Template(kStringImportR);
      String importsData = kRImportTemplate.render({
        "hasFileInFormData": requestModel.hasFileInFormData,
      });

      String result = importsData;

      var harJson = requestModelToHARJsonRequest(
        requestModel,
        useEnabled: true,
      );

      var templateStart = jj.Template(kTemplateStart);
      result += templateStart.render({
        "url": stripUrlParams(requestModel.url),
        "method": harJson["method"].toUpperCase(),
      });

      var params = harJson["queryString"];
      if (params.isNotEmpty) {
        var templateParams = jj.Template(kTemplateParams);
        var m = {};
        for (var i in params) {
          m[i["name"]] = i["value"];
        }
        result += templateParams.render({
          "params": padMultilineString(
              m.entries.map((e) => '"${e.key}" = "${e.value}"').join(", "), 2)
        });
      }

      var headers = harJson["headers"];
      if (headers.isNotEmpty || requestModel.hasFormData) {
        var templateHeader = jj.Template(kTemplateHeader);
        var m = {};
        for (var i in headers) {
          m[i["name"]] = i["value"];
        }
        if (requestModel.hasFormData) {
          m[kHeaderContentType] = ContentType.formdata.header;
        }
        // Convert headers map to R named list format
        var formattedHeaders =
            m.entries.map((e) => '"${e.key}" = "${e.value}"').join(", ");
        result += templateHeader.render({"headers": formattedHeaders});
      }

      var templateBody = jj.Template(kTemplateBody);
      if (requestModel.hasFormData && requestModel.formDataMapList.isNotEmpty) {
        // Manually Create a R Object
        Map<String, String> formParams = {};
        int formFileCounter = 1;
        for (var element in requestModel.formDataMapList) {
          formParams["${element["name"]}"] = element["type"] == "text"
              ? '"${element["value"]}"'
              : "fileInput$formFileCounter";
          if (element["type"] == "file") formFileCounter++;
        }
        var sanitizedRObject = sanitzeRObject(formParams);
        result += templateBody.render({"body": sanitizedRObject});
      } else if (harJson["postData"]?["text"] != null) {
        // Ensure proper escaping for JSON
        String bodyContent =
            '"${harJson["postData"]["text"].replaceAll('"', '\\"')}"';
        result += templateBody.render({"body": bodyContent});
      }
      result += kStringRequest;
      return result;
    } catch (e) {
      return null;
    }
  }

  // Escape function and variables in R Object
  String sanitzeRObject(Map<String, String> formParams) {
    // Escape double quotes for R
    return formParams.entries
        .map((e) => '"${e.key}" = "${e.value}".replaceAll(' "', '\\" ')')
        .join(", ");
  }
}
