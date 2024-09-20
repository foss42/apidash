import 'dart:core';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart'
    show  getValidRequestUri;
import 'package:apidash/models/models.dart';


class RustHyperCodeGen {
  final String kTemplateStart = """
use hyper::{Body, Client, Request, Uri};
use hyper::client::HttpConnector;
use hyper_tls::HttpsConnector;
use std::convert::TryInto;
{% if hasForm %}use reqwest::multipart;{% endif %}
{% if hasJsonBody %}use serde_json::json;{% endif %}
use tokio;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let https = HttpsConnector::new();
    let client = Client::builder().build::<_, hyper::Body>(https);
    let url = "{{ url }}".parse::<Uri>().unwrap();

""";


  final String kTemplateMethod = """
    let req = Request::builder()
              .method("{{ method }}")
              .uri(url)
""";



  final String kTemplateHeaders = """
        {% for key, val in headers %}
              .header("{{ key }}", "{{ val }}")
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
    
    let form = reqwest::multipart::Form::new()
    {%- for field in fields_list %}
        {%- if field.type == "file" %}
        .part("{{ field.name }}", reqwest::multipart::Part::file(r"{{ field.value }}")?)
        {%- else %}
        .text("{{ field.name }}", "{{ field.value }}")
        {%- endif %}
        {%- if not loop.last %}.and({%- endif %}
    {%- endfor %};
    
  """;

  final String kTemplateEndReqwest = """
    let clientReqwest = reqwest::Client::new();
    let responseReqwest = clientReqwest
        .post("{{url}}")
        .multipart(form)
        .send()
        .await?;

    println!("Reqwest Status: {}", responseReqwest.status());
    let bodyReqwest = responseReqwest.text().await?;
    println!("Reqwest Body: {}", bodyReqwest);
    

""";

  final String kTemplateRequestEnd = """
    let res = client.request(req).await?;
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


        result += jj.Template(kTemplateStart).render({
          "url": uri,
          'hasJsonBody': requestModel.bodyContentType == ContentType.json,
          'hasForm': requestModel.hasFormData,
        });
        
        
        result += jj.Template(kTemplateMethod).render({
          "method": requestModel.method.name.toUpperCase(),
        });

        // Add headers if available
        var headers = requestModel.enabledHeadersMap;
        if (headers.isNotEmpty) {
          result += jj.Template(kTemplateHeaders).render({"headers": headers});
        }

        // Handle body (JSON or raw)
        var requestBody = requestModel.body;
        if (requestModel.hasFormData) {
          result += kTemplateEmptyBody;
          result += jj.Template(kTemplateFormData).render({
            "fields_list": requestModel.formDataMapList,
          });
        }else if (requestBody == "" || requestBody == null|| requestModel.method ==HTTPVerb.get) {
          result += kTemplateEmptyBody;
        }else if(requestModel.hasJsonData){
          result += jj.Template(kTemplateJsonBody).render({"body": requestBody});

        }else if(requestModel.hasTextData){
          result += jj.Template(kTemplateBody).render({"body": requestBody});
        }
        // End request
        result += kTemplateRequestEnd;
        if(requestModel.hasFormData && requestModel.method!=HTTPVerb.get){
          result+=jj.Template(kTemplateEndReqwest).render({
          "url": uri,
        });;
        }
        result+=kTemplateEnd;
      }

      return result;
    } catch (e) {
      return null;
    }
  }
}
