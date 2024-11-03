import 'dart:io';
import 'dart:convert';
import 'package:apidash_core/apidash_core.dart';
import 'package:jinja/jinja.dart' as jj;

class RustReqwestCodeGen {
  final String kTemplateStart =
      """fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client = reqwest::blocking::Client::new();
    let url = "{{url}}";

""";

  String kTemplateParams = """\n        .query(&{{params}})""";

  String kTemplateBody = """

    let payload = r#"{{body}}"#;

""";

  String kTemplateJson = """

    let payload = serde_json::json!({{body}});

""";

  String kTemplateHeaders =
      """\n        {% for key, val in headers -%}.header("{{key}}", "{{val}}"){% if not loop.last %}{{ '\n        ' }}{% endif %}{%- endfor -%}""";

  String kTemplateRequest = """

    let response = client\n        .{{method}}(url)
""";

  final String kStringFormDataBody = r'''

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
  
    let mut form = reqwest::blocking::multipart::Form::new();
    
    for item in form_data_items {
        if item.field_type == "text" {
            form = form.text(item.name, item.value);
        } else if item.field_type == "file" {
            form = form.file(item.name, &item.value)?; 
        }
    }
''';

  String kStringRequestBody = """\n        .body(payload)""";

  String kStringRequestJson = """\n        .json(&payload)""";

  String kStringRequestForm = """\n        .multipart(form)""";

  final String kStringRequestEnd = """\n        .send()?;

    println!("Status Code: {}", response.status()); 
    println!("Response Body: {}", response.text()?);

    Ok(())
}
""";

  String? getCode(
    HttpRequestModel requestModel,
  ) {
    try {
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
        var templateStartUrl = jj.Template(kTemplateStart);
        result += templateStartUrl.render({
          "url": stripUriParams(uri),
          'isFormDataRequest': requestModel.hasFormData,
          'isJson': requestModel.bodyContentType == ContentType.json
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
            var tupleStrings = params.entries
                .map((entry) => '("${entry.key}", "${entry.value}")')
                .toList();
            var paramsString = "[${tupleStrings.join(', ')}]";
            var templateParams = jj.Template(kTemplateParams);
            result += templateParams.render({"params": paramsString});
          }
        }

        var headersList = requestModel.enabledHeaders;
        if (headersList != null || hasBody) {
          var headers = requestModel.enabledHeadersMap;
          if (hasBody) {
            headers[HttpHeaders.contentTypeHeader] =
                requestModel.bodyContentType.header;
          }
          if (headers.isNotEmpty) {
            var templateHeaders = jj.Template(kTemplateHeaders);
            result += templateHeaders.render({"headers": headers});
          }
        }

        if (hasBody && !requestModel.hasFormData) {
          result += kStringRequestBody;
        }

        if (hasJsonBody) {
          result += kStringRequestJson;
        }

        if (requestModel.hasFormData) {
          result += kStringRequestForm;
        }

        result += kStringRequestEnd;
      }
      return result;
    } catch (e) {
      return null;
    }
  }
}
