import 'package:apidash/models/models.dart' show RequestModel;
import 'package:jinja/jinja.dart' as jj;

import '../../consts.dart';

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
      if (requestModel.enabledParamsMap.isNotEmpty) {
        if (!url.contains('?')) {
          url += "?";
        } else {
          url += "&";
        }
        for (MapEntry<String, String> entry
            in requestModel.enabledParamsMap.entries) {
          url += "${Uri.encodeFull(entry.key)}=${Uri.encodeFull(entry.value)}&";
        }
        url = url.substring(0, url.length - 1);
      }
      var rM = requestModel.copyWith(url: url);
      var templateStart = jj.Template(kTemplateStart);
      result += templateStart.render({
        "method": switch (rM.method.name.toUpperCase()) {
          "GET" => "",
          "HEAD" => " --head",
          _ => " --request ${rM.method.name.toUpperCase()} \\\n"
        },
        "url": rM.url,
      });

      Map<String, String> headers = rM.enabledHeadersMap;
      if (rM.requestBody != null &&
          rM.requestBody!.isNotEmpty &&
          rM.method != HTTPVerb.get &&
          rM.requestBodyContentType != ContentType.formdata) {
        var templateHeader = jj.Template(kTemplateHeader);
        result += templateHeader.render({
          "name": "Content-Type",
          "value": rM.requestBodyContentType.header
        });
      }
      for (MapEntry<String, String> header in headers.entries) {
        var templateHeader = jj.Template(kTemplateHeader);
        result +=
            templateHeader.render({"name": header.key, "value": header.value});
      }

      if (rM.requestBodyContentType == ContentType.formdata) {
        List<Map<String, dynamic>> formDataList = rM.formDataMapList;
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
      } else {
        if (rM.requestBody != null &&
            rM.requestBody!.isNotEmpty &&
            rM.method != HTTPVerb.get) {
          var templateBody = jj.Template(kTemplateBody);
          result += templateBody.render({"body": rM.requestBody});
        }
      }
      return result;
    } catch (e) {
      return null;
    }
  }
}
