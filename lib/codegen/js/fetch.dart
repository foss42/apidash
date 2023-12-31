import 'dart:convert';

import 'package:apidash/consts.dart';
import 'package:apidash/utils/convert_utils.dart';
import 'package:apidash/utils/extensions/request_model_extension.dart';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/utils/utils.dart'
    show getNewUuid, padMultilineString, requestModelToHARJsonRequest;
import 'package:apidash/models/models.dart' show FormDataModel, RequestModel;

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
  body: {{body}}
""";
  String kMultiPartFileReader = '''
function readFile(file) {
  {% if isNodeJs %} return fs.readFile(file, 'binary'); {% else %} return new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.onload = () => resolve(reader.result);
      reader.onerror = reject;
       reader.readAsArrayBuffer(file);
  });
{% endif %}
}

''';
  String kMultiPartBodyTemplate = r'''
async function buildDataList(fields) {
  const dataList = [];
  for (const field of fields) {
      const name = field.name || '';
      const value = field.value || '';
      const type = field.type || 'text';

      dataList.push(`--{{boundary}}`);
      if (type === 'text') {
          dataList.push(`Content-Disposition: form-data; name="${name}"`);
          dataList.push('Content-Type: text/plain');
          dataList.push('');
          dataList.push(value);
      } else if (type === 'file') {
        const fileContent = await readFile(value);
        dataList.push(`Content-Disposition: form-data; name="$name"; filename="${value.name}"`);
        dataList.push(`Content-Type: ${value.type}`);
        dataList.push('');
        {% if isNodeJs %}dataList.push(fileContent);
        {% else %}
        dataList.push(fileContent.content);{% endif %}}
      }

  dataList.push(`--{{boundary}}--`);
  dataList.push('');
  return dataList.join('\r\n');
}
var dataList = [];
buildDataList({{fields_list}})
  .then(data => dataList = data)
  .catch(err => console.error(err));
const payload = dataList.join('\r\n');

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
      List<FormDataModel> formDataList = requestModel.formDataList ?? [];
      String uuid = getNewUuid();
      jj.Template kNodejsImportTemplate = jj.Template(kStringImportNode);
      String importsData = kNodejsImportTemplate.render({
        "isFormDataRequest": requestModel.isFormDataRequest,
      });

      String result = isNodeJs ? importsData : "";
      if (requestModel.isFormDataRequest) {
        jj.Template kMultiPartFileReaderTemplate =
            jj.Template(kMultiPartFileReader);
        result += kMultiPartFileReaderTemplate.render({
          "isNodeJs": isNodeJs,
        });
        var boundary = uuid;
        var templateMultiPartBody = jj.Template(kMultiPartBodyTemplate);
        result += templateMultiPartBody.render({
          "boundary": boundary,
          "isNodeJs": isNodeJs,
          "fields_list": json.encode(rowsToFormDataMap(formDataList)),
        });
      }
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
        if (requestModel.isFormDataRequest) {
          m["Content-Type"] = "multipart/form-data; boundary=$uuid";
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
