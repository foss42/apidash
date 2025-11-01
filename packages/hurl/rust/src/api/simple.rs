use hurl_core::parser;
use hurl_core::error::DisplaySourceError;
use hurl_core::ast::SectionValue;

/// Parses a Hurl file content and returns a simplified JSON representation
/// containing just the HTTP requests
#[flutter_rust_bridge::frb(sync)]
pub fn parse_hurl_to_json(content: String) -> Result<String, String> {
    // Parse the Hurl file
    match parser::parse_hurl_file(&content) {
        Ok(hurl_file) => {
            // Extract basic information from entries
            let mut requests = Vec::new();
            
            for entry in &hurl_file.entries {
                let request = &entry.request;
                
                // Get method
                let method = format!("{}", request.method);
                
                // Get URL
                let url = template_to_string(&request.url);
                
                // Extract headers
                let headers: Vec<String> = request
                    .headers
                    .iter()
                    .map(|h| {
                        format!(
                            r#"{{"name":"{}","value":"{}"}}"#,
                            escape_json(&template_to_string(&h.key)),
                            escape_json(&template_to_string(&h.value))
                        )
                    })
                    .collect();
                
                // Extract query parameters from [QueryStringParams] section
                let mut query_params: Vec<String> = Vec::new();
                for section in &request.sections {
                    if let SectionValue::QueryParams(params, _) = &section.value {
                        for param in params {
                            query_params.push(format!(
                                r#"{{"name":"{}","value":"{}"}}"#,
                                escape_json(&template_to_string(&param.key)),
                                escape_json(&template_to_string(&param.value))
                            ));
                        }
                    }
                }
                
                // Extract form parameters from [FormParams] section
                let mut form_params: Vec<String> = Vec::new();
                for section in &request.sections {
                    if let SectionValue::FormParams(params, _) = &section.value {
                        for param in params {
                            form_params.push(format!(
                                r#"{{"name":"{}","value":"{}"}}"#,
                                escape_json(&template_to_string(&param.key)),
                                escape_json(&template_to_string(&param.value))
                            ));
                        }
                    }
                }
                
                // Extract basic auth from [BasicAuth] section
                let mut basic_auth: Option<String> = None;
                for section in &request.sections {
                    if let SectionValue::BasicAuth(kv) = &section.value {
                        if let Some(kv) = kv {
                            // BasicAuth has username and password as key-value
                            let user = template_to_string(&kv.key);
                            let pass = template_to_string(&kv.value);
                            basic_auth = Some(format!(
                                r#"{{"username":"{}","password":"{}"}}"#,
                                escape_json(&user),
                                escape_json(&pass)
                            ));
                        }
                        break;
                    }
                }
                
                // Extract request body
                let body = if let Some(body) = &request.body {
                    // Convert body bytes to string
                    let body_str = bytes_to_string(&body.value);
                    if !body_str.is_empty() {
                        Some(format!(r#""{}""#, escape_json(&body_str)))
                    } else {
                        None
                    }
                } else {
                    None
                };
                
                // Build JSON with optional fields
                let mut json_parts = vec![
                    format!(r#""method":"{}""#, method),
                    format!(r#""url":"{}""#, escape_json(&url)),
                    format!(r#""headers":[{}]"#, headers.join(",")),
                ];
                
                if !query_params.is_empty() {
                    json_parts.push(format!(r#""queryParams":[{}]"#, query_params.join(",")));
                }
                
                if !form_params.is_empty() {
                    json_parts.push(format!(r#""formParams":[{}]"#, form_params.join(",")));
                }
                
                if let Some(auth) = basic_auth {
                    json_parts.push(format!(r#""basicAuth":{}"#, auth));
                }
                
                if let Some(body_content) = body {
                    json_parts.push(format!(r#""body":{}"#, body_content));
                }
                
                let request_json = format!("{{{}}}", json_parts.join(","));
                requests.push(request_json);
            }
            
            // Create JSON output
            let json_output = format!(
                r#"{{"entries":[{}]}}"#,
                requests.join(",")
            );
            
            Ok(json_output)
        }
        Err(error) => {
            // Return error message if parsing fails
            let error_msg = format!(
                "Failed to parse Hurl file at line {}: {}",
                error.pos.line,
                error.description()
            );
            Err(error_msg)
        }
    }
}

/// Convert a Template to a simple string
fn template_to_string(template: &hurl_core::ast::Template) -> String {
    template
        .elements
        .iter()
        .map(|element| match element {
            hurl_core::ast::TemplateElement::String { value, .. } => value.clone(),
            _ => String::from(""), // For now, ignore other template elements
        })
        .collect::<Vec<String>>()
        .join("")
}

/// Convert Bytes to string representation
fn bytes_to_string(bytes: &hurl_core::ast::Bytes) -> String {
    use hurl_core::ast::Bytes;
    
    match bytes {
        Bytes::Json(value) => {
            // JSON body - convert to string
            json_value_to_string(value)
        }
        Bytes::Xml(value) => {
            // XML body
            value.clone()
        }
        Bytes::MultilineString(value) => {
            // Multiline string body
            template_to_string(&value.value())
        }
        Bytes::OnelineString(template) => {
            // Oneline string body
            template_to_string(template)
        }
        Bytes::Base64(value) => {
            // Base64 encoded body - return the source representation
            format!("base64,{}", value.value.iter().map(|b| format!("{:02x}", b)).collect::<String>())
        }
        Bytes::Hex(value) => {
            // Hex encoded body - return the source representation
            format!("hex,{}", value.value.iter().map(|b| format!("{:02x}", b)).collect::<String>())
        }
        Bytes::File(value) => {
            // File reference
            format!("file,{}", template_to_string(&value.filename))
        }
    }
}

/// Convert JSON value to string
fn json_value_to_string(json: &hurl_core::ast::JsonValue) -> String {
    use hurl_core::ast::JsonValue;
    
    match json {
        JsonValue::String(template) => {
            format!(r#""{}""#, escape_json(&template_to_string(template)))
        }
        JsonValue::Number(num) => num.clone(),
        JsonValue::Boolean(b) => b.to_string(),
        JsonValue::Null => "null".to_string(),
        JsonValue::List { elements, .. } => {
            let items: Vec<String> = elements
                .iter()
                .map(|elem| json_value_to_string(&elem.value))
                .collect();
            format!("[{}]", items.join(","))
        }
        JsonValue::Object { elements, .. } => {
            let pairs: Vec<String> = elements
                .iter()
                .map(|elem| {
                    format!(
                        "\"{}\":{}",
                        escape_json(&template_to_string(&elem.name)),
                        json_value_to_string(&elem.value)
                    )
                })
                .collect();
            format!("{{{}}}", pairs.join(","))
        }
        JsonValue::Placeholder(_) => {
            // Placeholder for template variables - skip for now
            "null".to_string()
        }
    }
}

/// Simple JSON string escaping
fn escape_json(s: &str) -> String {
    s.replace('\\', "\\\\")
        .replace('"', "\\\"")
        .replace('\n', "\\n")
        .replace('\r', "\\r")
        .replace('\t', "\\t")
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}
