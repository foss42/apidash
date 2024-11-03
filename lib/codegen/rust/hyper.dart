import 'dart:core';
import 'package:apidash_core/apidash_core.dart';
import 'package:jinja/jinja.dart' as jj;

class RustHyperCodeGen {
  final String kTemplateStart = """
{% if hasForm %}extern crate hyper_multipart_rfc7578 as hyper_multipart;
{% endif %}use hyper::{Body, Client, Request, Uri};
{% if isHttps %}use hyper_tls::HttpsConnector;
{% else %}use hyper::client::HttpConnector;
{% endif %}{% if hasForm %}use hyper_multipart::client::multipart;
{% endif %}{% if hasJsonBody %}use serde_json::json;
{% endif %}use tokio;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let http{% if isHttps %}s{% endif %} = Http{% if isHttps %}s{% endif %}Connector::new();
    let client = Client::builder().build::<_, hyper::Body>(http{% if isHttps %}s{% endif %});
    let url = "{{ url }}".parse::<Uri>().unwrap();

""";

  final String kTemplateMethod = """
    let req_builder = Request::builder()
              .method("{{ method }}")
              .uri(url)
""";
  final String kTemplateMethodNoHeadersButForm = """
    let req_builder = Request::builder()
              .method("{{ method }}")
              .uri(url);
""";

  final String kTemplateHeaders = """
        {% for key, val in headers %}
              .header("{{ key }}", "{{ val }}")
        {% endfor %}""";

  final String kTemplateHeadersFormData = """
        {% for key, val in headers %}
              .header("{{ key }}", "{{ val }}"){% if loop.last %};{% endif %}
        {% endfor %}
""";

  final String kTemplateBody = """
        
              .body(Body::from(r#"{{ body }}"#))?;\n
""";

  final String kTemplateJsonBody = """
        
              .body(Body::from(json!({{ body }}).to_string()))?;\n
""";

  final String kTemplateEmptyBody = """

              .body(Body::empty())?;\n
""";

  final String kTemplateFormData = """
    
    let mut form = multipart::Form::default();
    {%- for field in fields_list %}
        {%- if field.type == "file" %}
    form.add_file("{{ field.name }}", r"{{ field.value }}").unwrap();
        {%- else %}
    form.add_text("{{ field.name }}", "{{ field.value }}");
        {%- endif %}
    {%- endfor %}

    let req = form.set_body_convert::<Body, multipart::Body>(req_builder).unwrap();
    
  """;

  final String kTemplateEndForm = """
  let res = client.request(req).await?;
    let status = res.status();
    let body_bytes = hyper::body::to_bytes(res).await?;
    let body = String::from_utf8(body_bytes.to_vec())?;

    println!("Response Status: {}", status);
    println!("Response: {:?}", body);
    

""";

  final String kTemplateRequestEnd = """
    let res = client.request(req_builder).await?;
    let status = res.status();
    let body_bytes = hyper::body::to_bytes(res).await?;
    let body = String::from_utf8(body_bytes.to_vec())?;

    println!("Response Status: {}", status);
    println!("Response: {:?}", body);

""";

  final String kTemplateEnd = """
    Ok(())
}

""";

  String? getCode(HttpRequestModel requestModel) {
    try {
      String result = "";

      String url = requestModel.url;
      var rec = getValidRequestUri(url, requestModel.enabledParams);
      Uri? uri = rec.$1;

      if (uri != null) {
        var headers = requestModel.enabledHeadersMap;
        result += jj.Template(kTemplateStart).render({
          "url": uri,
          "isHttps": uri.scheme == "https" ? true : false,
          'hasJsonBody': requestModel.hasJsonData,
          'hasForm': requestModel.hasFormData,
        });

        if (requestModel.hasFormData && headers.isEmpty) {
          result += jj.Template(kTemplateMethodNoHeadersButForm).render({
            "method": requestModel.method.name.toUpperCase(),
          });
        } else {
          result += jj.Template(kTemplateMethod).render({
            "method": requestModel.method.name.toUpperCase(),
          });
        }

        // Add headers if available

        if (headers.isNotEmpty) {
          if (requestModel.hasFormData) {
            result += jj.Template(kTemplateHeadersFormData)
                .render({"headers": headers});
          } else {
            result +=
                jj.Template(kTemplateHeaders).render({"headers": headers});
          }
        }

        // Handle body (JSON or raw)
        var requestBody = requestModel.body;
        if (requestModel.hasFormData) {
          result += jj.Template(kTemplateFormData).render({
            "fields_list": requestModel.formDataMapList,
          });
        } else if (requestBody == "" ||
            requestBody == null ||
            requestModel.method == HTTPVerb.get ||
            requestModel.method == HTTPVerb.head) {
          result += kTemplateEmptyBody;
        } else if (requestModel.hasJsonData) {
          result +=
              jj.Template(kTemplateJsonBody).render({"body": requestBody});
        } else if (requestModel.hasTextData) {
          result += jj.Template(kTemplateBody).render({"body": requestBody});
        }
        // End request

        if (requestModel.hasFormData && requestModel.method != HTTPVerb.get) {
          result += kTemplateEndForm;
        } else {
          result += kTemplateRequestEnd;
        }
        result += kTemplateEnd;
      }

      return result;
    } catch (e) {
      return null;
    }
  }
}
