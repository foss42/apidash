import 'dart:convert';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/utils/utils.dart'
    show padMultilineString, requestModelToHARJsonRequest;
import 'package:apidash/models/models.dart' show RequestModel;
import 'package:apidash/consts.dart';

class FetchCodeGen {
  FetchCodeGen({this.isNodeJs = false});

  final bool isNodeJs;

  String kStringImportNode = """
import fetch from 'node-fetch';
{% if isFormDataRequest %}const fs = require('fs');{% endif %}

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

  String kMultiPartBodyTemplate = r'''
async function buildDataList(fields) {
  var formdata = new FormData();
  for (const field of fields) {
      const name = field.name || '';
      const value = field.value || '';
      const type = field.type || 'text';

      if (type === 'text') {
        formdata.append(name, value);
      } else if (type === 'file') {
        formdata.append(name,{% if isNodeJs %} fs.createReadStream(value){% else %} fileInput.files[0],value{% endif %});
      }
    }
  return formdata;
}

const payload = buildDataList({{fields_list}});

''';
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
      jj.Template kNodejsImportTemplate = jj.Template(kStringImportNode);
      String importsData = kNodejsImportTemplate.render({
        "isFormDataRequest": requestModel.isFormDataRequest,
      });

      String result = isNodeJs ? importsData : "";
      if (requestModel.isFormDataRequest) {
        var templateMultiPartBody = jj.Template(kMultiPartBodyTemplate);
        result += templateMultiPartBody.render({
          "isNodeJs": isNodeJs,
          "fields_list": json.encode(requestModel.formDataMapList),
        });
      }
      String url = requestModel.url;
      if (!url.contains("://") && url.isNotEmpty) {
        url = "$defaultUriScheme://$url";
      }
      var rM = requestModel.copyWith(url: url);

      var harJson = requestModelToHARJsonRequest(rM, useEnabled: true);

      var templateStart = jj.Template(kTemplateStart);
      result += templateStart.render({
        "url": harJson["url"],
        "method": harJson["method"],
      });

      var headers = harJson["headers"];

      if (headers.isNotEmpty) {
        var templateHeader = jj.Template(kTemplateHeader);
        var m = {};
        if (requestModel.isFormDataRequest) {
          m["Content-Type"] = "multipart/form-data";
        }
        for (var i in headers) {
          m[i["name"]] = i["value"];
        }
        result += templateHeader.render({
          "headers": padMultilineString(kEncoder.convert(m), 2),
        });
      }

      if (harJson["postData"]?["text"] != null) {
        var templateBody = jj.Template(kTemplateBody);
        result += templateBody.render({
          "body": kEncoder.convert(harJson["postData"]["text"]),
        });
      } else if (requestModel.isFormDataRequest) {
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
