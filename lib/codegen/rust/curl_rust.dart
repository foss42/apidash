
import 'package:apidash_core/apidash_core.dart';
import 'package:jinja/jinja.dart' as jj;

class RustCurlCodeGen {
  final String kTemplateStart = """use curl::easy::Easy;
{% if hasJsonBody %}use serde_json::json;
{% endif %}{% if hasHeaders %}use curl::easy::List;
{% endif %}
fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
   let base_url = "{{baseUrl}}";
""";

  String kTemplateUrlParams = """
 
  {% if params %}
  let params: Vec<(&str, Vec<&str>)> = vec![
    {%- for key, values in params %}
    ("{{key}}", vec![{% if values is iterable and values is not string %}{% for val in values %}"{{val}}", {% endfor %}{% else %}"{{values}}"{% endif %}]),
    {%- endfor %}
  ];
  let query_string: String = params
      .iter()
      .flat_map(|(key, values)| values.iter().map(move |val| format!("{}={}", key, val)))
      .collect::<Vec<_>>()
      .join("&");
  let url = format!("{}?{}", base_url, query_string);
  {% else %}
  let url = base_url.to_string();
  {% endif %}
 
""";

  String kTemplateMethod = """
{% if method == 'get' or method == 'post' or method == 'put' %}
  easy.{{ method }}(true).unwrap();
{% elif method == 'delete' %}
  easy.custom_request("DELETE").unwrap();
{% elif method == 'patch' %}
  easy.custom_request("PATCH").unwrap();
{% elif method == 'head' %}
  easy.nobody(true).unwrap();
{% endif %}

""";

  String kTemplateRawBody = """
  easy.post_fields_copy(r#"{{body}}"#.as_bytes()).unwrap();


""";

  String kTemplateJsonBody = """
  easy.post_fields_copy(json!({{body}}).to_string().as_bytes()).unwrap();


""";

  String kTemplateFormData = """
  let mut form = curl::easy::Form::new();
  {% for field in fields %}
  form.part("{{field.name}}")
    {% if field.type == "file" %}.file("{{field.value}}"){% else %}.contents(b"{{field.value}}"){% endif %}
    .add().unwrap();
  {% endfor %}
  easy.httppost(form).unwrap();
""";

  String kTemplateHeader = """
  {% if headers %}let mut list = List::new();{% for header, value in headers %}
  list.append("{{header}}: {{value}}").unwrap();{% endfor %}
  easy.http_headers(list).unwrap();
  {% endif %}

""";

  final String kTemplateEnd = """
  {
   easy.url(&url).unwrap();
    let mut transfer = easy.transfer();
    transfer.write_function(|new_data| {
        data.extend_from_slice(new_data);
        Ok(new_data.len())
    }).unwrap();
    transfer.perform().unwrap();
  }

  let response_body = String::from_utf8_lossy(&data);
  println!("Response body: {}", response_body);
  println!("Response code: {}", easy.response_code().unwrap());
}""";

  String? getCode(HttpRequestModel requestModel) {
    try {
      String result = "";

      String url = requestModel.url;

      result += jj.Template(kTemplateStart).render({
        "hasJsonBody": requestModel.hasJsonData,
        "hasHeaders": (requestModel.enabledHeaders != null &&
                requestModel.enabledHeaders!.isNotEmpty) ||
            (requestModel.hasJsonData || requestModel.hasTextData),
       "baseUrl": url.split('?').first,
      });

      var rec = getValidRequestUri(
        url,
        requestModel.enabledParams,
      );

      Uri? uri = rec.$1;
      
      if (uri != null) {

        var params = requestModel.enabledParamsMap;

        var templateUrlParams = jj.Template(kTemplateUrlParams);
        result += templateUrlParams.render({
          "params": params.isNotEmpty ? params : null,
        });

        // Method
        var methodTemplate = jj.Template(kTemplateMethod);
        result += methodTemplate.render({"method": requestModel.method.name.toLowerCase()});

        // Request body
        if (requestModel.hasTextData) {
          var templateBody = jj.Template(kTemplateRawBody);
          result += templateBody.render({"body": requestModel.body});
        } else if (requestModel.hasJsonData) {
          var templateBody = jj.Template(kTemplateJsonBody);
          result += templateBody.render({"body": requestModel.body});
        } else if (requestModel.hasFormData) {
          var templateFormData = jj.Template(kTemplateFormData);
          result += templateFormData.render({
            "fields": requestModel.formDataMapList,
          });
        }
              
        var headersList = requestModel.enabledHeaders;
        if (headersList != null || requestModel.hasBody) {
          var headers = requestModel.enabledHeadersMap;
          if (requestModel.hasJsonData || requestModel.hasTextData) {
            headers.putIfAbsent(
                kHeaderContentType, () => requestModel.bodyContentType.header);
          }
          if (headers.isNotEmpty) {
            var templateHeader = jj.Template(kTemplateHeader);
            result += templateHeader.render({
              "headers": headers,
              });
          }
        }
        
        result += kTemplateEnd;
      }

      return result;
    } catch (e) {
      return null;
    }
  }
}
