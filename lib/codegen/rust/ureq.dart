import 'dart:io';
import 'dart:convert';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart'
    show getNewUuid, getValidRequestUri, stripUriParams;
import 'package:apidash/models/models.dart' show RequestModel;

class RustUreqCodeGen {
  final String kTemplateStart = """
{%- if isFormDataRequest -%}
use std::io::Read;
{% endif -%}  
fn main() -> Result<(), ureq::Error> {
    let url = "{{url}}";
""";

  // String kTemplateParams = """\n        .query_pairs({{ params }})""";
  String kTemplateParams =
      """\n        {% for key, val in params -%}.query("{{key}}", "{{val}}"){% if not loop.last %}{{ '\n        ' }}{% endif %}{%- endfor -%}""";

  String kTemplateBody = """

    let payload = r#"{{body}}"#;

""";

  String kTemplateJson = """

    let payload = ureq::json!({{body}});

""";

  String kTemplateHeaders =
      """\n        {% for key, val in headers -%}.set("{{key}}", "{{val}}"){% if not loop.last %}{{ '\n        ' }}{% endif %}{%- endfor -%}""";

  String kTemplateFormHeaderContentType = '''
multipart/form-data; boundary={{boundary}}''';

  String kTemplateRequest = """

    let response = ureq::{{method}}(url)
""";

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

  String kStringRequestBody = """\n        .send_string(payload)?;""";

  String kStringRequestForm = """\n        .send_bytes(&payload)?;""";

  String kStringRequestJson = """\n        .send_json(payload)?;""";

  String kStringRequestNormal = """\n        .call()?;""";

  final String kStringRequestEnd = """\n
    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_string()?);

    Ok(())
}
""";

  String? getCode(
    RequestModel requestModel, {
    String? boundary,
  }) {
    try {
      String result = "";
      bool hasBody = false;
      bool hasJsonBody = false;
      String uuid = getNewUuid();

      String url = requestModel.url;

      var rec = getValidRequestUri(
        url,
        requestModel.enabledRequestParams,
      );
      Uri? uri = rec.$1;
      if (uri != null) {
        var templateStartUrl = jj.Template(kTemplateStart);
        result += templateStartUrl.render({
          "url": stripUriParams(uri),
          'isFormDataRequest': requestModel.hasFormData,
          "method": requestModel.method.name.toLowerCase()
        });

        var method = requestModel.method;
        var requestBody = requestModel.requestBody;
        if (kMethodsWithBody.contains(method) && requestBody != null) {
          var contentLength = utf8.encode(requestBody).length;
          if (contentLength > 0) {
            if (requestModel.requestBodyContentType == ContentType.json) {
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
        var templateRequest = jj.Template(kTemplateRequest);
        result += templateRequest.render({
          "method": method.name.toLowerCase(),
        });

        if (uri.hasQuery) {
          var params = uri.queryParameters;
          if (params.isNotEmpty) {
            var templateParms = jj.Template(kTemplateParams);
            result += templateParms.render({"params": params});
          }
        }

        var headersList = requestModel.enabledRequestHeaders;
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
                requestModel.requestBodyContentType.header;
          }

          if (headers.isNotEmpty) {
            var templateHeaders = jj.Template(kTemplateHeaders);
            result += templateHeaders.render({"headers": headers});
          }
        }
        if (requestModel.hasFormData) {
          result += kStringRequestForm;
        } else if (hasBody) {
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
