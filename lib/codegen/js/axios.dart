import 'package:apidash_core/apidash_core.dart';
import 'package:jinja/jinja.dart' as jj;
import '../../utils/utils.dart';

class AxiosCodeGen {
  AxiosCodeGen({this.isNodeJs = false});

  final bool isNodeJs;

  String kStringImportNode = """import axios from 'axios';
{%if hasFileInFormData -%}
import fs from 'fs'
{% endif %}

""";

  String kTemplateStart = """const config = {
  url: '{{url}}',
  method: '{{method}}'
""";

  String kTemplateParams = """,
  params: {{params}}
""";

  String kTemplateHeader = """,
  headers: {{headers}}
""";

  String kTemplateBody = """,
  data: {{body}}
""";

  String kStringRequest = """

};

axios(config)
  .then(res => {
    console.log(res.status);
    console.log(res.data);
  })
  .catch(err => {
    console.log(err);
  });
""";
  String? getCode(
    HttpRequestModel requestModel,
  ) {
    try {
      jj.Template kNodejsImportTemplate = jj.Template(kStringImportNode);
      String importsData = kNodejsImportTemplate.render({
        "hasFileInFormData": requestModel.hasFileInFormData,
      });

      String result = isNodeJs
          ? importsData
          : requestModel.hasFileInFormData
              ? "// refer https://github.com/foss42/apidash/issues/293#issuecomment-1997568083 for details regarding integration\n\n"
              : "";
      var harJson = requestModelToHARJsonRequest(
        requestModel,
        useEnabled: true,
      );

      var templateStart = jj.Template(kTemplateStart);
      result += templateStart.render({
        "url": stripUrlParams(requestModel.url),
        "method": harJson["method"].toLowerCase(),
      });

      var params = harJson["queryString"];
      if (params.isNotEmpty) {
        var templateParams = jj.Template(kTemplateParams);
        var m = {};
        for (var i in params) {
          m[i["name"]] = i["value"];
        }
        result += templateParams
            .render({"params": padMultilineString(kJsonEncoder.convert(m), 2)});
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
        result += templateHeader.render(
            {"headers": padMultilineString(kJsonEncoder.convert(m), 2)});
      }
      var templateBody = jj.Template(kTemplateBody);
      if (requestModel.hasFormData && requestModel.formDataMapList.isNotEmpty) {
        // Manually Create a JS Object
        Map<String, String> formParams = {};
        int formFileCounter = 1;
        for (var element in requestModel.formDataMapList) {
          formParams["${element["name"]}"] = element["type"] == "text"
              ? "${element["value"]}"
              : isNodeJs
                  ? "fs.createReadStream(${element["value"]})"
                  : "fileInput$formFileCounter.files[0]";
          if (element["type"] == "file") formFileCounter++;
        }
        var sanitizedJSObject =
            sanitzeJSObject(kJsonEncoder.convert(formParams));
        result += templateBody
            .render({"body": padMultilineString(sanitizedJSObject, 2)});
      } else if (harJson["postData"]?["text"] != null) {
        result += templateBody.render(
            {"body": kJsonEncoder.convert(harJson["postData"]["text"])});
      }
      result += kStringRequest;
      return result;
    } catch (e) {
      return null;
    }
  }

  // escape function and variables in JS Object
  String sanitzeJSObject(String jsObject) {
    RegExp pattern = isNodeJs
        ? RegExp(r'"fs\.createReadStream\((.*?)\)"')
        : RegExp(r'"fileInput(\d+)\.files\[0\]"');

    var sanitizedJSObject = jsObject.replaceAllMapped(pattern, (match) {
      return isNodeJs
          ? 'fs.createReadStream("${match.group(1)}")'
          : 'fileInput${match.group(1)}.files[0]';
    });
    return sanitizedJSObject;
  }
}
