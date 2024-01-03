import 'dart:convert';
import 'package:apidash/consts.dart';
import 'package:apidash/utils/extensions/request_model_extension.dart';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/utils/utils.dart'
    show
        padMultilineString,
        requestModelToHARJsonRequest,
        rowsToFormDataMap,
        stripUrlParams;
import 'package:apidash/models/models.dart' show FormDataModel, RequestModel;

class AxiosCodeGen {
  AxiosCodeGen({this.isNodeJs = false});

  final bool isNodeJs;

  String kStringImportNode = """import axios from 'axios';
{% if isFormDataRequest and isNodeJs %}const fs = require('fs');
{% endif %}

""";

  String kTemplateStart = """let config = {
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
    .then(function (response) {
        // handle success
        console.log(response.status);
        console.log(response.data);
    })
    .catch(function (error) {
        // handle error
        console.log(error.response.status);
        console.log(error);
    });
""";
  String kMultiPartBodyTemplate = r'''
async function buildFormData(fields) {
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


''';
  var kGetFormDataTemplate = '''buildFormData({{fields_list}});
''';
  String? getCode(
    RequestModel requestModel,
    String defaultUriScheme,
  ) {
    try {
      List<FormDataModel> formDataList = requestModel.formDataList ?? [];
      jj.Template kNodejsImportTemplate = jj.Template(kStringImportNode);
      String importsData = kNodejsImportTemplate.render({
        "isFormDataRequest": requestModel.isFormDataRequest,
        "isNodeJs": isNodeJs,
      });

      String result = importsData;
      var templateMultiPartBody = jj.Template(kMultiPartBodyTemplate);
      var renderedMultiPartBody = templateMultiPartBody.render({
        "isNodeJs": isNodeJs,
      });
      result += renderedMultiPartBody;

      String url = requestModel.url;
      if (!url.contains("://") && url.isNotEmpty) {
        url = "$defaultUriScheme://$url";
      }
      var rM = requestModel.copyWith(url: url);

      var harJson = requestModelToHARJsonRequest(rM);

      var templateStart = jj.Template(kTemplateStart);
      result += templateStart.render({
        "url": stripUrlParams(url),
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
            .render({"params": padMultilineString(kEncoder.convert(m), 2)});
      }

      var headers = harJson["headers"];
      if (headers.isNotEmpty || requestModel.isFormDataRequest) {
        var templateHeader = jj.Template(kTemplateHeader);
        var m = {};
        for (var i in headers) {
          m[i["name"]] = i["value"];
        }
        if (requestModel.isFormDataRequest) {
          m['Content-Type'] = 'multipart/form-data';
        }
        result += templateHeader
            .render({"headers": padMultilineString(kEncoder.convert(m), 2)});
      }
      var templateBody = jj.Template(kTemplateBody);

      if (requestModel.isFormDataRequest) {
        var getFieldDataTemplate = jj.Template(kGetFormDataTemplate);

        result += templateBody.render({
          "body": getFieldDataTemplate.render({
            "fields_list": json.encode(rowsToFormDataMap(formDataList)),
          })
        });
      }
      if (harJson["postData"]?["text"] != null) {
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
