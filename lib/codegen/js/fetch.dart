import 'package:apidash/consts.dart';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/utils/utils.dart'
    show requestModelToHARJsonRequest, padMultilineString;
import 'package:apidash/models/models.dart' show RequestModel;

// ignore: camel_case_types
class FetchCodeGen {
  FetchCodeGen({this.isNodeJs = false});

  final bool isNodeJs;

  String kStringImportNode = """import fetch from 'node-fetch';

""";

  String kTemplateStart = """let url = '{{url}}';

let options = {
  method: '{{method}}'
""";

  String kTemplateHeader = """,
  headers: {{headers}}
""";

  String kTemplateBody = """,
  body: 
{{body}}
""";

  String kStringRequest = """

};

let status;
fetch(url, options)
    .then(res => {
        status = res.status;
        return res.json()
    })
    .then(body => {
        console.log(status);
        console.log(body);
    })
    .catch(err => {
        console.log(status);
        console.error('error:' + err);
    });
""";

  String? getCode(
    RequestModel requestModel,
    String defaultUriScheme,
  ) {
    try {
      String result = isNodeJs ? kStringImportNode : "";

      String url = requestModel.url;
      if (!url.contains("://") && url.isNotEmpty) {
        url = "$defaultUriScheme://$url";
      }
      var rM = requestModel.copyWith(url: url);

      var harJson = requestModelToHARJsonRequest(rM);

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
          m[i["name"]] = i["value"];
        }
        result += templateHeader
            .render({"headers": padMultilineString(kEncoder.convert(m), 2)});
      }

      if (harJson["postData"]?["text"] != null) {
        var templateBody = jj.Template(kTemplateBody);
        result += templateBody
            .render({"body": kEncoder.convert(harJson["postData"]["text"])});
      }
      result += kStringRequest;
      return result;
    } catch (e) {
      return null;
    }
  }
}
