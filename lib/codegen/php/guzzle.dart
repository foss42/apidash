import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/utils/utils.dart'
    show padMultilineString, requestModelToHARJsonRequest, stripUrlParams;
import 'package:apidash/models/models.dart' show RequestModel;
import 'package:apidash/consts.dart';

class PhpGuzzleCodeGen {
  String kStringImportNode = """use GuzzleHttp\\Client;
use GuzzleHttp\\Psr7\\Request;
{% if isFormDataRequest %}use GuzzleHttp\\Psr7\\MultipartStream;{% endif %}


""";

  String kMultiPartBodyTemplate = """
\$multipart = [
{{fields_list}}
];


""";

  String kTemplateParams = """
\$queryParams = [
{{params}}
];
\$queryParamsStr = '?' . http_build_query(\$queryParams);


""";

  String kTemplateHeader = """
\$headers = [
{{headers}}
];


""";

  String kTemplateBody = """
\$body = {{body}};


""";

  String kStringRequest = """
\$client = new Client();

\$request = new Request('{{method}}', '{{url}}'{{queryParams}} {{headers}} {{body}});
\$res = \$client->sendAsync(\$request)->wait();
echo \$res->getBody();
""";

  String? getCode(
    RequestModel requestModel,
    String defaultUriScheme,
  ) {
    try {
      jj.Template kNodejsImportTemplate = jj.Template(kStringImportNode);
      String importsData = kNodejsImportTemplate.render({
        "isFormDataRequest": requestModel.isFormDataRequest,
      });

      String result = importsData;

      if (requestModel.isFormDataRequest &&
          requestModel.formDataMapList.isNotEmpty) {
        var templateMultiPartBody = jj.Template(kMultiPartBodyTemplate);
        var renderedMultiPartBody = templateMultiPartBody.render({
          "fields_list": requestModel.formDataMapList.map((field) {
            return '''
    [
        'name'     => '${field['name']}',
        'contents' => '${field['value']}'
    ],''';
          }).join(),
        });
        result += renderedMultiPartBody;
      }

      String url = requestModel.url;
      if (!url.contains("://") && url.isNotEmpty) {
        url = "$defaultUriScheme://$url";
      }
      var rM = requestModel.copyWith(url: url);

      var harJson = requestModelToHARJsonRequest(rM, useEnabled: true);

      var params = harJson["queryString"];
      if (params.isNotEmpty) {
        var templateParams = jj.Template(kTemplateParams);
        var m = {};
        for (var i in params) {
          m[i["name"]] = i["value"];
        }
        var jsonString = '';
        m.forEach((key, value) {
          jsonString += "\t\t\t\t'$key' => '$value', \n";
        });
        jsonString = jsonString.substring(
            0, jsonString.length - 2); // Removing trailing comma and space
        result += templateParams.render({
          "params": jsonString,
        });
      }

      var headers = harJson["headers"];
      if (headers.isNotEmpty || requestModel.isFormDataRequest) {
        var templateHeader = jj.Template(kTemplateHeader);
        var m = {};
        for (var i in headers) {
          m[i["name"]] = i["value"];
        }
        var headersString = '';
        m.forEach((key, value) {
          headersString += "\t\t\t\t'$key' => '$value', \n";
        });
        if (requestModel.isFormDataRequest) {
          m['Content-Type'] = 'multipart/form-data';
        }
        headersString = headersString.substring(
            0, headersString.length - 2); // Removing trailing comma and space
        result += templateHeader.render({
          "headers": headersString,
        });
      }

      var templateBody = jj.Template(kTemplateBody);
      if (requestModel.isFormDataRequest &&
          requestModel.formDataMapList.isNotEmpty) {
        result += templateBody.render({
          "body": "new MultipartStream(\$multipart)",
        });
      }

      if (harJson["postData"]?["text"] != null) {
        result += templateBody
            .render({"body": kEncoder.convert(harJson["postData"]["text"])});
      }

      String getRequestBody(Map harJson) {
        if (harJson.containsKey("postData")) {
          var postData = harJson["postData"];
          if (postData.containsKey("mimeType")) {
            var mimeType = postData["mimeType"];
            if (mimeType == "text/plain" || mimeType == "application/json") {
              return " \$body";
            } else if (mimeType == "multipart/form-data") {
              return " new MultipartStream(\$multipart)";
            }
          }
        }
        return ""; // Return empty string if postData or formdata is not present
      }

      var templateRequest = jj.Template(kStringRequest);
      result += templateRequest.render({
        "url": stripUrlParams(url),
        "method": harJson["method"].toLowerCase(),
        "queryParams":
            harJson["queryString"].isNotEmpty ? ". \$queryParamsStr," : "",
        "headers": harJson["headers"].isNotEmpty ? " \$headers," : "",
        "body": getRequestBody(harJson),
      });

      return result;
    } catch (e) {
      return null;
    }
  }
}
