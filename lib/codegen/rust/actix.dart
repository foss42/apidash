import 'dart:io';
import 'dart:convert';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart'
    show getNewUuid, getValidRequestUri, padMultilineString, stripUriParams;
import 'package:apidash/models/models.dart' show RequestModel;

class RustActixCodeGen {
  final String kTemplateStart =
      """{% if isFormDataRequest %}use std::io::Read;{% endif %}
#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "{{url}}";
    let mut client = awc::Client::default().{{method}}(url);

""";

  String kTemplateParams = """

    let params = {{params}};

""";
  int kParamsPadding = 9;

  String kTemplateBody = """

    let payload = "{{body}}";

""";

  String kTemplateJson = """

    let payload = serde_json::json!({{body}});

""";

  String kTemplateHeaders = """

    let header_str = r#"{{headers}}"#;
    let headers_map: std::collections::HashMap<&str, &str> = serde_json::from_str(header_str)?;
    for (key, val) in headers_map {
        client = client.insert_header((key, val));
    }

""";
  String kTemplateFormHeaderContentType = '''
multipart/form-data; boundary={{boundary}}''';

  int kHeadersPadding = 10;

  String kTemplateRequest = """

    let mut response = client
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
    fn build_data_list(fields: Vec<FormDataItem>) -> Vec<u8> {
        let mut data_list = Vec::new();
  
        for field in fields {
            data_list.extend_from_slice(b"--{{boundary}}\r\n");
  
            if field.field_type == "text" {
                data_list.extend_from_slice(
                    format!(
                        "Content-Disposition: form-data; name=\"{}\"\r\n",
                        field.name
                    )
                    .as_bytes(),
                );
                data_list.extend_from_slice(b"Content-Type: text/plain\r\n\r\n");
                data_list.extend_from_slice(field.value.as_bytes());
                data_list.extend_from_slice(b"\r\n");
            } else if field.field_type == "file" {
                data_list.extend_from_slice(
                    format!(
                        "Content-Disposition: form-data; name=\"{}\"; filename=\"{}\"\r\n",
                        field.name, field.value
                    )
                    .as_bytes(),
                );
  
                let mime_type = mime_guess::from_path(&field.value)
                    .first_or(mime_guess::mime::APPLICATION_OCTET_STREAM);
                data_list
                    .extend_from_slice(format!("Content-Type: {}\r\n\r\n", mime_type).as_bytes());
  
                let mut file = std::fs::File::open(&field.value).unwrap();
                let mut file_contents = Vec::new();
                file.read_to_end(&mut file_contents).unwrap();
                data_list.extend_from_slice(&file_contents);
                data_list.extend_from_slice(b"\r\n");
            }
        }
  
        data_list.extend_from_slice(b"--{{boundary}}--\r\n");
        data_list
    }
  
    let payload = build_data_list(form_data_items);
''';

  String kStringRequestParams = """\n    .query(&params)\n    .unwrap()
  """;

  String kStringRequestBody = """\n    .send_body(payload)""";

  String kStringRequestJson = """\n    .send_json(&payload)""";

  final String kStringRequestEnd = """\n    .await\n    .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

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
          "method": requestModel.method.name.toLowerCase()
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
          if (requestModel.isFormDataRequest) {
            var formHeaderTemplate =
                jj.Template(kTemplateFormHeaderContentType);
            headers[HttpHeaders.contentTypeHeader] = formHeaderTemplate.render({
              "boundary": uuid,
            });
          }
          if (headers.isNotEmpty || hasBody) {
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
              "boundary": uuid,
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

        if (hasBody || requestModel.isFormDataRequest) {
          result += kStringRequestBody;
        }

        if (hasJsonBody) {
          result += kStringRequestJson;
        }

        result += kStringRequestEnd;
      }
      return result;
    } catch (e) {
      return null;
    }
  }
}
