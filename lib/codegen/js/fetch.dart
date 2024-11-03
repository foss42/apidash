import 'package:apidash_core/apidash_core.dart';
import 'package:jinja/jinja.dart' as jj;
import '../../utils/utils.dart';

class FetchCodeGen {
  FetchCodeGen({this.isNodeJs = false});

  final bool isNodeJs;

  String kStringImportNode = """
import fetch from 'node-fetch'
{% if hasFormData -%}
import { {% if hasFileInFormData %}fileFromSync, {% endif %}FormData } from 'node-fetch'
{% endif %}

""";

  String kTemplateStart = """const url = '{{url}}';

const options = {
  method: '{{method}}'
""";

  String kTemplateHeader = """,
  headers: {{headers}}
""";

  String kTemplateBody = """,
  body: {{body}}
""";

  String kMultiPartBodyTemplate = r'''
payload.append("{{name}}", {{value}})

''';
  String kStringRequest = """

};

fetch(url, options)
  .then(res => {
    console.log(res.status);
    return res.text()
  })
  .then(body => {
    console.log(body);
  })
  .catch(err => {
    console.error(`error:\${err}`);
  });
""";

  String? getCode(HttpRequestModel requestModel) {
    try {
      jj.Template kNodejsImportTemplate = jj.Template(kStringImportNode);
      String importsData = kNodejsImportTemplate.render({
        "hasFormData": requestModel.hasFormData,
        "hasFileInFormData": requestModel.hasFileInFormData,
      });

      String result = isNodeJs
          ? importsData
          : requestModel.hasFileInFormData
              ? "// refer https://github.com/foss42/apidash/issues/293#issuecomment-1995208098 for details regarding integration\n\n"
              : "";
      if (requestModel.hasFormData) {
        result += "const payload = new FormData();\n";
        var templateMultiPartBody = jj.Template(kMultiPartBodyTemplate);
        var formFileCounter = 1;
        for (var element in requestModel.formDataMapList) {
          result += templateMultiPartBody.render({
            "name": element["name"],
            "value": element["type"] == "text"
                ? "\"${element["value"]}\""
                : isNodeJs
                    ? "fileFromSync(\"${element["value"]}\")"
                    : "fileInput$formFileCounter.files[0]"
          });
          if (element["type"] != "text") formFileCounter++;
        }
        result += "\n";
      }

      var harJson =
          requestModelToHARJsonRequest(requestModel, useEnabled: true);

      var templateStart = jj.Template(kTemplateStart);
      result += templateStart.render({
        "url": harJson["url"],
        "method": harJson["method"],
      });

      var headers = harJson["headers"];

      if (headers.isNotEmpty) {
        var templateHeader = jj.Template(kTemplateHeader);
        var m = {};
        for (var i in headers) {
          // fetch can automatically add the Content-Type header when FormData is passed as body
          if (i["name"] == kHeaderContentType && requestModel.hasFormData) {
            continue;
          }
          m[i["name"]] = i["value"];
        }
        if (m.isNotEmpty) {
          result += templateHeader.render({
            "headers": padMultilineString(kJsonEncoder.convert(m), 2),
          });
        }
      }

      if (harJson["postData"]?["text"] != null) {
        var templateBody = jj.Template(kTemplateBody);
        result += templateBody.render({
          "body": kJsonEncoder.convert(harJson["postData"]["text"]),
        });
      } else if (requestModel.hasFormData) {
        var templateBody = jj.Template(kTemplateBody);
        result += templateBody.render({
          "body": 'payload',
        });
      }

      result += kStringRequest;
      return result;
    } catch (e) {
      return null;
    }
  }
}
