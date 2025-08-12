import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';
import '../models/request_models.dart';

void main() {
  final codeGen = Codegen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.apidash.dev";
    let client = awc::Client::default();
    let mut request = client.get(url);
    let mut response = request.send()
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustActix,
            requestModelGet1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.apidash.dev/country/data";
    let client = awc::Client::default();
    let mut request = client.get(url);    
    let query_params = [
        ("code", "US"),
    ];
    request = request.query(&query_params).unwrap();
    let mut response = request.send()
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustActix,
            requestModelGet2,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 3', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.apidash.dev/country/data";
    let client = awc::Client::default();
    let mut request = client.get(url);    
    let query_params = [
        ("code", "IND"),
        ("code", "US"),
    ];
    request = request.query(&query_params).unwrap();
    let mut response = request.send()
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustActix,
            requestModelGet3,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 4', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.apidash.dev/humanize/social";
    let client = awc::Client::default();
    let mut request = client.get(url);    
    let query_params = [
        ("num", "8700000"),
        ("digits", "3"),
        ("system", "SS"),
        ("add_space", "true"),
        ("trailing_zeros", "true"),
    ];
    request = request.query(&query_params).unwrap();
    let mut response = request.send()
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustActix,
            requestModelGet4,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 5', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.github.com/repos/foss42/apidash";
    let client = awc::Client::default();
    let mut request = client.get(url);
    request = request.insert_header(("User-Agent", "Test Agent"));
    
    let mut response = request.send()
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustActix,
            requestModelGet5,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 6', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.github.com/repos/foss42/apidash";
    let client = awc::Client::default();
    let mut request = client.get(url);    
    let query_params = [
        ("raw", "true"),
    ];
    request = request.query(&query_params).unwrap();
    request = request.insert_header(("User-Agent", "Test Agent"));
    
    let mut response = request.send()
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustActix,
            requestModelGet6,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.apidash.dev";
    let client = awc::Client::default();
    let mut request = client.get(url);
    let mut response = request.send()
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustActix,
            requestModelGet7,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 8', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.github.com/repos/foss42/apidash";
    let client = awc::Client::default();
    let mut request = client.get(url);    
    let query_params = [
        ("raw", "true"),
    ];
    request = request.query(&query_params).unwrap();
    request = request.insert_header(("User-Agent", "Test Agent"));
    
    let mut response = request.send()
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustActix,
            requestModelGet8,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 9', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.apidash.dev/humanize/social";
    let client = awc::Client::default();
    let mut request = client.get(url);    
    let query_params = [
        ("num", "8700000"),
        ("add_space", "true"),
    ];
    request = request.query(&query_params).unwrap();
    let mut response = request.send()
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustActix,
            requestModelGet9,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 10', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.apidash.dev/humanize/social";
    let client = awc::Client::default();
    let mut request = client.get(url);
    request = request.insert_header(("User-Agent", "Test Agent"));
    
    let mut response = request.send()
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustActix,
            requestModelGet10,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.apidash.dev/humanize/social";
    let client = awc::Client::default();
    let mut request = client.get(url);    
    let query_params = [
        ("num", "8700000"),
        ("digits", "3"),
    ];
    request = request.query(&query_params).unwrap();
    request = request.insert_header(("User-Agent", "Test Agent"));
    
    let mut response = request.send()
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustActix,
            requestModelGet11,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 12', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.apidash.dev/humanize/social";
    let client = awc::Client::default();
    let mut request = client.get(url);
    let mut response = request.send()
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustActix,
            requestModelGet12,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.apidash.dev";
    let client = awc::Client::default();
    let mut request = client.head(url);
    let mut response = request.send()
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustActix,
            requestModelHead1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "http://api.apidash.dev";
    let client = awc::Client::default();
    let mut request = client.head(url);
    let mut response = request.send()
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustActix,
            requestModelHead2,
            SupportedUriSchemes.http,
          ),
          expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.apidash.dev/case/lower";
    let client = awc::Client::default();
    let mut request = client.post(url);
    let payload = r#"{
"text": "I LOVE Flutter"
}"#;

    request = request.insert_header(("content-type", "text/plain"));
    
    let mut response = request.send_body(payload)
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustActix,
            requestModelPost1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.apidash.dev/case/lower";
    let client = awc::Client::default();
    let mut request = client.post(url);
    let payload = serde_json::json!({
"text": "I LOVE Flutter",
"flag": null,
"male": true,
"female": false,
"no": 1.2,
"arr": ["null", "true", "false", null]
});

    let mut response = request.send_json(&payload)
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustActix,
            requestModelPost2,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('POST 3', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.apidash.dev/case/lower";
    let client = awc::Client::default();
    let mut request = client.post(url);
    let payload = serde_json::json!({
"text": "I LOVE Flutter"
});

    request = request.insert_header(("User-Agent", "Test Agent"));
    
    let mut response = request.send_json(&payload)
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustActix,
            requestModelPost3,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('POST 4', () {
      const expectedCode = r"""use std::io::Read;
#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.apidash.dev/io/form";
    let client = awc::Client::default();
    let mut request = client.post(url);
    struct FormDataItem {
        name: String,
        value: String,
        field_type: String,
    }

    let form_data_items: Vec<FormDataItem> = vec![
        FormDataItem {
            name: "text".to_string(),
            value: "API".to_string(),
            field_type: "text".to_string(),
        },
        FormDataItem {
            name: "sep".to_string(),
            value: "|".to_string(),
            field_type: "text".to_string(),
        },
        FormDataItem {
            name: "times".to_string(),
            value: "3".to_string(),
            field_type: "text".to_string(),
        },
    ]; 

    fn build_data_list(fields: Vec<FormDataItem>) -> Vec<u8> {
        let mut data_list = Vec::new();
  
        for field in fields {
            data_list.extend_from_slice(b"--test\r\n");
  
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
  
        data_list.extend_from_slice(b"--test--\r\n");
        data_list
    }
  
    let payload = build_data_list(form_data_items);
    request = request.insert_header(("content-type", "multipart/form-data; boundary=test"));
    
    let mut response = request.send_body(payload)
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustActix,
            requestModelPost4,
            SupportedUriSchemes.https,
            boundary: "test",
          ),
          expectedCode);
    });
    test('POST 5', () {
      const expectedCode = r"""use std::io::Read;
#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.apidash.dev/io/form";
    let client = awc::Client::default();
    let mut request = client.post(url);
    struct FormDataItem {
        name: String,
        value: String,
        field_type: String,
    }

    let form_data_items: Vec<FormDataItem> = vec![
        FormDataItem {
            name: "text".to_string(),
            value: "API".to_string(),
            field_type: "text".to_string(),
        },
        FormDataItem {
            name: "sep".to_string(),
            value: "|".to_string(),
            field_type: "text".to_string(),
        },
        FormDataItem {
            name: "times".to_string(),
            value: "3".to_string(),
            field_type: "text".to_string(),
        },
    ]; 

    fn build_data_list(fields: Vec<FormDataItem>) -> Vec<u8> {
        let mut data_list = Vec::new();
  
        for field in fields {
            data_list.extend_from_slice(b"--test\r\n");
  
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
  
        data_list.extend_from_slice(b"--test--\r\n");
        data_list
    }
  
    let payload = build_data_list(form_data_items);
    request = request.insert_header(("User-Agent", "Test Agent"));
    request = request.insert_header(("content-type", "multipart/form-data; boundary=test"));
    
    let mut response = request.send_body(payload)
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.rustActix, requestModelPost5,
              SupportedUriSchemes.https,
              boundary: "test"),
          expectedCode);
    });
    test('POST 6', () {
      const expectedCode = r"""use std::io::Read;
#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.apidash.dev/io/img";
    let client = awc::Client::default();
    let mut request = client.post(url);
    struct FormDataItem {
        name: String,
        value: String,
        field_type: String,
    }

    let form_data_items: Vec<FormDataItem> = vec![
        FormDataItem {
            name: "token".to_string(),
            value: "xyz".to_string(),
            field_type: "text".to_string(),
        },
        FormDataItem {
            name: "imfile".to_string(),
            value: "/Documents/up/1.png".to_string(),
            field_type: "file".to_string(),
        },
    ]; 

    fn build_data_list(fields: Vec<FormDataItem>) -> Vec<u8> {
        let mut data_list = Vec::new();
  
        for field in fields {
            data_list.extend_from_slice(b"--test\r\n");
  
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
  
        data_list.extend_from_slice(b"--test--\r\n");
        data_list
    }
  
    let payload = build_data_list(form_data_items);
    request = request.insert_header(("content-type", "multipart/form-data; boundary=test"));
    
    let mut response = request.send_body(payload)
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.rustActix, requestModelPost6,
              SupportedUriSchemes.https,
              boundary: "test"),
          expectedCode);
    });
    test('POST 7', () {
      const expectedCode = r"""use std::io::Read;
#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.apidash.dev/io/img";
    let client = awc::Client::default();
    let mut request = client.post(url);
    struct FormDataItem {
        name: String,
        value: String,
        field_type: String,
    }

    let form_data_items: Vec<FormDataItem> = vec![
        FormDataItem {
            name: "token".to_string(),
            value: "xyz".to_string(),
            field_type: "text".to_string(),
        },
        FormDataItem {
            name: "imfile".to_string(),
            value: "/Documents/up/1.png".to_string(),
            field_type: "file".to_string(),
        },
    ]; 

    fn build_data_list(fields: Vec<FormDataItem>) -> Vec<u8> {
        let mut data_list = Vec::new();
  
        for field in fields {
            data_list.extend_from_slice(b"--test\r\n");
  
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
  
        data_list.extend_from_slice(b"--test--\r\n");
        data_list
    }
  
    let payload = build_data_list(form_data_items);
    request = request.insert_header(("content-type", "multipart/form-data; boundary=test"));
    
    let mut response = request.send_body(payload)
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.rustActix, requestModelPost7,
              SupportedUriSchemes.https,
              boundary: "test"),
          expectedCode);
    });
    test('POST 8', () {
      const expectedCode = r"""use std::io::Read;
#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.apidash.dev/io/form";
    let client = awc::Client::default();
    let mut request = client.post(url);
    struct FormDataItem {
        name: String,
        value: String,
        field_type: String,
    }

    let form_data_items: Vec<FormDataItem> = vec![
        FormDataItem {
            name: "text".to_string(),
            value: "API".to_string(),
            field_type: "text".to_string(),
        },
        FormDataItem {
            name: "sep".to_string(),
            value: "|".to_string(),
            field_type: "text".to_string(),
        },
        FormDataItem {
            name: "times".to_string(),
            value: "3".to_string(),
            field_type: "text".to_string(),
        },
    ]; 

    fn build_data_list(fields: Vec<FormDataItem>) -> Vec<u8> {
        let mut data_list = Vec::new();
  
        for field in fields {
            data_list.extend_from_slice(b"--test\r\n");
  
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
  
        data_list.extend_from_slice(b"--test--\r\n");
        data_list
    }
  
    let payload = build_data_list(form_data_items);    
    let query_params = [
        ("size", "2"),
        ("len", "3"),
    ];
    request = request.query(&query_params).unwrap();
    request = request.insert_header(("content-type", "multipart/form-data; boundary=test"));
    
    let mut response = request.send_body(payload)
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.rustActix, requestModelPost8,
              SupportedUriSchemes.https,
              boundary: "test"),
          expectedCode);
    });
    test('POST 9', () {
      const expectedCode = r"""use std::io::Read;
#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.apidash.dev/io/img";
    let client = awc::Client::default();
    let mut request = client.post(url);
    struct FormDataItem {
        name: String,
        value: String,
        field_type: String,
    }

    let form_data_items: Vec<FormDataItem> = vec![
        FormDataItem {
            name: "token".to_string(),
            value: "xyz".to_string(),
            field_type: "text".to_string(),
        },
        FormDataItem {
            name: "imfile".to_string(),
            value: "/Documents/up/1.png".to_string(),
            field_type: "file".to_string(),
        },
    ]; 

    fn build_data_list(fields: Vec<FormDataItem>) -> Vec<u8> {
        let mut data_list = Vec::new();
  
        for field in fields {
            data_list.extend_from_slice(b"--test\r\n");
  
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
  
        data_list.extend_from_slice(b"--test--\r\n");
        data_list
    }
  
    let payload = build_data_list(form_data_items);    
    let query_params = [
        ("size", "2"),
        ("len", "3"),
    ];
    request = request.query(&query_params).unwrap();
    request = request.insert_header(("User-Agent", "Test Agent"));
    request = request.insert_header(("Keep-Alive", "true"));
    request = request.insert_header(("content-type", "multipart/form-data; boundary=test"));
    
    let mut response = request.send_body(payload)
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.rustActix, requestModelPost9,
              SupportedUriSchemes.https,
              boundary: "test"),
          expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT 1', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://reqres.in/api/users/2";
    let client = awc::Client::default();
    let mut request = client.put(url);
    let payload = serde_json::json!({
"name": "morpheus",
"job": "zion resident"
});

    request = request.insert_header(("x-api-key", "reqres-free-v1"));
    
    let mut response = request.send_json(&payload)
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustActix,
            requestModelPut1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH 1', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://reqres.in/api/users/2";
    let client = awc::Client::default();
    let mut request = client.patch(url);
    let payload = serde_json::json!({
"name": "marfeus",
"job": "accountant"
});

    request = request.insert_header(("x-api-key", "reqres-free-v1"));
    
    let mut response = request.send_json(&payload)
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustActix,
            requestModelPatch1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://reqres.in/api/users/2";
    let client = awc::Client::default();
    let mut request = client.delete(url);
    request = request.insert_header(("x-api-key", "reqres-free-v1"));
    
    let mut response = request.send()
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustActix,
            requestModelDelete1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('DELETE 2', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://reqres.in/api/users/2";
    let client = awc::Client::default();
    let mut request = client.delete(url);
    let payload = serde_json::json!({
"name": "marfeus",
"job": "accountant"
});

    request = request.insert_header(("x-api-key", "reqres-free-v1"));
    
    let mut response = request.send_json(&payload)
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustActix,
            requestModelDelete2,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });
}
