import 'dart:io';
import 'dart:convert';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart'
    show getNewUuid, getValidRequestUri, padMultilineString, stripUriParams;
import 'package:apidash/models/models.dart' show RequestModel;

class RustReqwestCodeGen {
  final String kTemplateStart =
      """fn main() -> Result<(), Box<dyn std::error::Error>> {
  let client = reqwest::blocking::Client::new();
  let url = "{{url}}";

""";

  String kTemplateParams = """

  let params = {{params}};

""";
  int kParamsPadding = 9;

  String kTemplateBody = """

  let payload = b"{{body}}";

""";

  String kTemplateJson = """

  let payload = serde_json::json!({{body}});

""";

  String kTemplateHeaders = """

  let header_str = r#"{{headers}}"#;
    let headers_map: std::collections::HashMap<&str, &str> = serde_json::from_str(header_str)?; // Deserialize as &str
    let mut headers = reqwest::header::HeaderMap::new();
    for (key, val) in headers_map {
        headers.insert(key, reqwest::header::HeaderValue::from_str(val)?);
    }

""";

  int kHeadersPadding = 10;

  String kTemplateRequest = """

  let response = client.{{method}}(url)
""";

  final String kStringFormDataBody = r'''
  #[derive(serde::Deserialize)]
  struct FormDataItem {
      name: String,
      value: String,
      field_type: String,
  }
  let data_str = r#"{{fields_list}}"#; 
  let form_data_items: Vec<FormDataItem> = serde_json::from_str(data_str).unwrap(); 
  
  let mut form = reqwest::blocking::multipart::Form::new();
  
  for item in form_data_items {
      if item.field_type == "text" {
          form = form.text(item.name, item.value);
      } else if item.field_type == "file" {
          form = form.file(item.name, &item.value)?; 
      }
  }
''';

  String kStringRequestParams = """\n    .query(&params)""";

  String kStringRequestBody = """\n    .body(payload.to_vec())""";

  String kStringRequestJson = """\n    .json(&payload)""";

  String kStringRequestForm = """\n    .multipart(form)""";

  String kStringRequestHeaders = """\n    .headers(headers)""";

  final String kStringRequestEnd = """\n    .send()?;

  println!("Status Code: {}", response.status()); 
  println!("Response Body: {}", response.text()?);

  Ok(())
}
""";

  String? getCode(
    RequestModel requestModel,
    String defaultUriScheme,
  ) {
    try {
      String result = "";
      bool hasQuery = false;
      bool hasHeaders = false;
      bool hasBody = false;
      bool hasJsonBody = false;
      String uuid = getNewUuid();

      String url = requestModel.url;
      if (!url.contains("://") && url.isNotEmpty) {
        url = "$defaultUriScheme://$url";
      }

      var rec = getValidRequestUri(
        url,
        requestModel.enabledRequestParams,
      );
      Uri? uri = rec.$1;
      if (uri != null) {
        var templateStartUrl = jj.Template(kTemplateStart);
        result += templateStartUrl.render({
          "url": stripUriParams(uri),
          'isFormDataRequest': requestModel.isFormDataRequest,
          'isJson': requestModel.requestBodyContentType == ContentType.json
        });

        if (uri.hasQuery) {
          var params = uri.queryParameters;
          if (params.isNotEmpty) {
            hasQuery = true;
            var tupleStrings = params.entries
                .map((entry) => '("${entry.key}", "${entry.value}")')
                .toList();
            var paramsString = "[${tupleStrings.join(', ')}]";
            var templateParams = jj.Template(kTemplateParams);
            paramsString = padMultilineString(paramsString, kParamsPadding);
            result += templateParams.render({"params": paramsString});
          }
        }

        var method = requestModel.method;
        var requestBody = requestModel.requestBody;
        if (kMethodsWithBody.contains(method) && requestBody != null) {
          var contentLength = utf8.encode(requestBody).length;
          if (contentLength > 0) {
            if (requestModel.requestBodyContentType == ContentType.json) {
              hasJsonBody = true;
              var templateBody = jj.Template(kTemplateJson);
              result += templateBody.render({"body": requestBody});
            } else if (!requestModel.isFormDataRequest) {
              hasBody = true;
              var templateBody = jj.Template(kTemplateBody);
              result += templateBody.render({"body": requestBody});
            }
          }
        }

        var headersList = requestModel.enabledRequestHeaders;
        if (headersList != null || hasBody) {
          var headers = requestModel.enabledHeadersMap;
          if (headers.isNotEmpty || hasBody) {
            hasHeaders = true;
            if (hasBody) {
              headers[HttpHeaders.contentTypeHeader] =
                  requestModel.requestBodyContentType.header;
            }
            var headersString = kEncoder.convert(headers);
            headersString = padMultilineString(headersString, kHeadersPadding);
            var templateHeaders = jj.Template(kTemplateHeaders);
            result += templateHeaders.render({"headers": headersString});
          }
        }
        if (requestModel.isFormDataRequest) {
          var formDataBodyData = jj.Template(kStringFormDataBody);
          result += formDataBodyData.render(
            {
              "fields_list": json.encode(requestModel.formDataMapList),
            },
          );
        }
        var templateRequest = jj.Template(kTemplateRequest);
        result += templateRequest.render({
          "method": method.name.toLowerCase(),
        });

        if (hasQuery) {
          result += kStringRequestParams;
        }

        if (hasBody && !requestModel.isFormDataRequest) {
          result += kStringRequestBody;
        }

        if (hasJsonBody) {
          result += kStringRequestJson;
        }

        if (requestModel.isFormDataRequest) {
          result += kStringRequestForm;
        }

        if (hasHeaders) {
          result += kStringRequestHeaders;
        }

        result += kStringRequestEnd;
      }
      return result;
    } catch (e) {
      return null;
    }
  }
}
