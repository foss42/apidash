import 'dart:io';
import 'dart:convert';
import 'package:apidash_core/apidash_core.dart';
import 'package:jinja/jinja.dart' as jj;
import '../../utils/utils.dart';

class RustActixCodeGen {
  final String kTemplateStart = """
{%- if isFormDataRequest -%}
use std::io::Read;
{% endif -%}  
#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "{{url}}";
    let client = awc::Client::default();
    let mut request = client.{{method}}(url);
""";

String kTemplateParams = """
    
    let query_params = [
    {%- for key, values in params %}
        {%- for val in values %}
        ("{{key}}", "{{val}}"),
        {%- endfor %}
    {%- endfor %}
    ];
    request = request.query(&query_params).unwrap();
""";

  String kTemplateBody = """

    let payload = r#"{{body}}"#;

""";

  String kTemplateJson = """

    let payload = serde_json::json!({{body}});

""";
String kTemplateHeaders =
    """
\n    {% for key, val in headers -%}request = request.insert_header(("{{key}}", "{{val}}"));{{ '\n    ' }}{%- endfor -%}""";

  String kTemplateFormHeaderContentType = '''
multipart/form-data; boundary={{boundary}}''';

  final String kStringFormDataBody = r"""

    struct FormDataItem {
        name: String,
        value: String,
        field_type: String,
    }

    let form_data_items: Vec<FormDataItem> = vec![
    {%- for formitem in fields_list %}
        FormDataItem {
        {%- for key, val in formitem %}
            {% if key == "type" %}field_type: "{{ val }}".to_string(),{% else %}{{ key }}: "{{ val }}".to_string(),{% endif %}
        {%- endfor %}
        },
    {%- endfor %}
    ]; 

    fn build_data_list(fields: Vec<FormDataItem>) -> Vec<u8> {
        let mut data_list = Vec::new();
  
        for field in fields {
            data_list.extend_from_slice(b"--{{boundary}}\r\n");
  
            if field.field_type == "text" {
                data_list.extend_from_slice(format!("Content-Disposition: form-data; name=\"{}\"\r\n", field.name).as_bytes());
                data_list.extend_from_slice(b"Content-Type: text/plain\r\n\r\n");
                data_list.extend_from_slice(field.value.as_bytes());
                data_list.extend_from_slice(b"\r\n");
            } else if field.field_type == "file" {
                data_list.extend_from_slice(format!("Content-Disposition: form-data; name=\"{}\"; filename=\"{}\"\r\n", field.name, field.value).as_bytes());
  
                let mime_type = mime_guess::from_path(&field.value).first_or(mime_guess::mime::APPLICATION_OCTET_STREAM);
                data_list.extend_from_slice(format!("Content-Type: {}\r\n\r\n", mime_type).as_bytes());
  
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
""";

  String kStringRequestBody = """\n    let mut response = request.send_body(payload)""";

  String kStringRequestJson = """\n    let mut response = request.send_json(&payload)""";

  String kStringRequestNormal = """\n    let mut response = request.send()""";

  final String kStringRequestEnd = """\n        .await\n        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";

  String? getCode(
    HttpRequestModel requestModel, {
    String? boundary,
  }) {
    try {
      String uuid = getNewUuid();
      String result = "";
      bool hasBody = false;
      bool hasJsonBody = false;

      String url = requestModel.url;

      var rec = getValidRequestUri(
        url,
        requestModel.enabledParams,
      );
      Uri? uri = rec.$1;
      if (uri != null) {
        var baseUrl = stripUriParams(uri);
        var templateStartUrl = jj.Template(kTemplateStart);
        result += templateStartUrl.render({
          "url": baseUrl,
          'isFormDataRequest': requestModel.hasFormData,
          "method": requestModel.method.name.toLowerCase()
        });

        var method = requestModel.method;
        var requestBody = requestModel.body;
        if (kMethodsWithBody.contains(method) && requestBody != null) {
          var contentLength = utf8.encode(requestBody).length;
          if (contentLength > 0) {
            if (requestModel.bodyContentType == ContentType.json) {
              hasJsonBody = true;
              var templateBody = jj.Template(kTemplateJson);
              result += templateBody.render({"body": requestBody});
            } else if (!requestModel.hasFormData) {
              hasBody = true;
              var templateBody = jj.Template(kTemplateBody);
              result += templateBody.render({"body": requestBody});
            }
          }
        }

        if (requestModel.hasFormData) {
          var formDataBodyData = jj.Template(kStringFormDataBody);
          result += formDataBodyData.render(
            {
              "fields_list": requestModel.formDataMapList,
              "boundary": boundary ?? uuid,
            },
          );
        }
        
        var params = requestModel.enabledParamsMap;
        
        if (params.isNotEmpty) {
          var templateParams = jj.Template(kTemplateParams);
          result += templateParams.render({
            "method": method.name.toLowerCase(),
            "params": params,
          });
        } 
          
        var headersList = requestModel.enabledHeaders;
        if (headersList != null || hasBody || requestModel.hasFormData) {
          var headers = requestModel.enabledHeadersMap;
          if (requestModel.hasFormData) {
            var formHeaderTemplate =
                jj.Template(kTemplateFormHeaderContentType);
            headers[HttpHeaders.contentTypeHeader] = formHeaderTemplate.render({
              "boundary": boundary ?? uuid,
            });
          } else if (hasBody) {
            headers[HttpHeaders.contentTypeHeader] =
                requestModel.bodyContentType.header;
          }

          if (headers.isNotEmpty) {
            var templateHeaders = jj.Template(kTemplateHeaders);
            result += templateHeaders.render({"headers": headers});
          }
        }

        if (hasBody || requestModel.hasFormData) {
          result += kStringRequestBody;
        } else if (hasJsonBody) {
          result += kStringRequestJson;
        } else {
          result += kStringRequestNormal;
        }

        result += kStringRequestEnd;
      }
      return result;
    } catch (e) {
      return null;
    }
  }
}
