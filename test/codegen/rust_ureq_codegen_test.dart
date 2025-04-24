import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';
import '../models/request_models.dart';

void main() {
  final codeGen = Codegen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""
fn main() -> Result<(), ureq::Error> {
    let url = "https://api.apidash.dev";
    let response = ureq::get(url)
        .call()?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_body().read_to_string()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustUreq,
            requestModelGet1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r"""fn main() -> Result<(), ureq::Error> {
    let url = "https://api.apidash.dev/country/data";
    let response = ureq::get(url)
        .query("code", "US")
        .call()?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_body().read_to_string()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustUreq,
            requestModelGet2,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 3', () {
      const expectedCode = r"""fn main() -> Result<(), ureq::Error> {
    let url = "https://api.apidash.dev/country/data";
    let response = ureq::get(url)
        .query("code", "IND")
        .call()?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_body().read_to_string()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustUreq,
            requestModelGet3,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 4', () {
      const expectedCode = r"""fn main() -> Result<(), ureq::Error> {
    let url = "https://api.apidash.dev/humanize/social";
    let response = ureq::get(url)
        .query("num", "8700000")
        .query("digits", "3")
        .query("system", "SS")
        .query("add_space", "true")
        .query("trailing_zeros", "true")
        .call()?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_body().read_to_string()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustUreq,
            requestModelGet4,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 5', () {
      const expectedCode = r"""fn main() -> Result<(), ureq::Error> {
    let url = "https://api.github.com/repos/foss42/apidash";
    let response = ureq::get(url)
        .header("User-Agent", "Test Agent")
        .call()?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_body().read_to_string()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustUreq,
            requestModelGet5,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 6', () {
      const expectedCode = r"""fn main() -> Result<(), ureq::Error> {
    let url = "https://api.github.com/repos/foss42/apidash";
    let response = ureq::get(url)
        .query("raw", "true")
        .header("User-Agent", "Test Agent")
        .call()?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_body().read_to_string()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustUreq,
            requestModelGet6,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r"""fn main() -> Result<(), ureq::Error> {
    let url = "https://api.apidash.dev";
    let response = ureq::get(url)
        .call()?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_body().read_to_string()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustUreq,
            requestModelGet7,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 8', () {
      const expectedCode = r"""fn main() -> Result<(), ureq::Error> {
    let url = "https://api.github.com/repos/foss42/apidash";
    let response = ureq::get(url)
        .query("raw", "true")
        .header("User-Agent", "Test Agent")
        .call()?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_body().read_to_string()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustUreq,
            requestModelGet8,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 9', () {
      const expectedCode = r"""fn main() -> Result<(), ureq::Error> {
    let url = "https://api.apidash.dev/humanize/social";
    let response = ureq::get(url)
        .query("num", "8700000")
        .query("add_space", "true")
        .call()?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_body().read_to_string()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustUreq,
            requestModelGet9,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 10', () {
      const expectedCode = r"""fn main() -> Result<(), ureq::Error> {
    let url = "https://api.apidash.dev/humanize/social";
    let response = ureq::get(url)
        .header("User-Agent", "Test Agent")
        .call()?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_body().read_to_string()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustUreq,
            requestModelGet10,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode = r"""fn main() -> Result<(), ureq::Error> {
    let url = "https://api.apidash.dev/humanize/social";
    let response = ureq::get(url)
        .query("num", "8700000")
        .query("digits", "3")
        .header("User-Agent", "Test Agent")
        .call()?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_body().read_to_string()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustUreq,
            requestModelGet11,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 12', () {
      const expectedCode = r"""fn main() -> Result<(), ureq::Error> {
    let url = "https://api.apidash.dev/humanize/social";
    let response = ureq::get(url)
        .call()?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_body().read_to_string()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustUreq,
            requestModelGet12,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""fn main() -> Result<(), ureq::Error> {
    let url = "https://api.apidash.dev";
    let response = ureq::head(url)
        .call()?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_body().read_to_string()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustUreq,
            requestModelHead1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""fn main() -> Result<(), ureq::Error> {
    let url = "http://api.apidash.dev";
    let response = ureq::head(url)
        .call()?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_body().read_to_string()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustUreq,
            requestModelHead2,
            SupportedUriSchemes.http,
          ),
          expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r'''fn main() -> Result<(), ureq::Error> {
    let url = "https://api.apidash.dev/case/lower";
    let payload = r#"{
"text": "I LOVE Flutter"
}"#;

    let response = ureq::post(url)
        .header("content-type", "text/plain")
        .send(payload)?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_body().read_to_string()?);

    Ok(())
}
''';
      expect(
          codeGen.getCode(
            CodegenLanguage.rustUreq,
            requestModelPost1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r'''
use serde_json::json;
fn main() -> Result<(), ureq::Error> {
    let url = "https://api.apidash.dev/case/lower";

    let payload = json!({
"text": "I LOVE Flutter",
"flag": null,
"male": true,
"female": false,
"no": 1.2,
"arr": ["null", "true", "false", null]
});

    let response = ureq::post(url)
        .send_json(payload)?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_body().read_to_string()?);

    Ok(())
}
''';
      expect(
          codeGen.getCode(
            CodegenLanguage.rustUreq,
            requestModelPost2,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('POST 3', () {
      const expectedCode = r'''
use serde_json::json;
fn main() -> Result<(), ureq::Error> {
    let url = "https://api.apidash.dev/case/lower";

    let payload = json!({
"text": "I LOVE Flutter"
});

    let response = ureq::post(url)
        .header("User-Agent", "Test Agent")
        .send_json(payload)?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_body().read_to_string()?);

    Ok(())
}
''';
      expect(
          codeGen.getCode(
            CodegenLanguage.rustUreq,
            requestModelPost3,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('POST 4', () {
      const expectedCode = r"""use std::io::Read;
fn main() -> Result<(), ureq::Error> {
    let url = "https://api.apidash.dev/io/form";
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
    let response = ureq::post(url)
        .header("content-type", "multipart/form-data; boundary=test")
        .send_bytes(&payload)?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_body().read_to_string()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustUreq,
            requestModelPost4,
            SupportedUriSchemes.https,
            boundary: "test",
          ),
          expectedCode);
    });
    test('POST 5', () {
      const expectedCode = r"""use std::io::Read;
fn main() -> Result<(), ureq::Error> {
    let url = "https://api.apidash.dev/io/form";
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
    let response = ureq::post(url)
        .header("User-Agent", "Test Agent")
        .header("content-type", "multipart/form-data; boundary=test")
        .send_bytes(&payload)?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_body().read_to_string()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.rustUreq, requestModelPost5,
              SupportedUriSchemes.https,
              boundary: "test"),
          expectedCode);
    });
    test('POST 6', () {
      const expectedCode = r"""use std::io::Read;
fn main() -> Result<(), ureq::Error> {
    let url = "https://api.apidash.dev/io/img";
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
    let response = ureq::post(url)
        .header("content-type", "multipart/form-data; boundary=test")
        .send_bytes(&payload)?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_body().read_to_string()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.rustUreq, requestModelPost6,
              SupportedUriSchemes.https,
              boundary: "test"),
          expectedCode);
    });
    test('POST 7', () {
      const expectedCode = r"""use std::io::Read;
fn main() -> Result<(), ureq::Error> {
    let url = "https://api.apidash.dev/io/img";
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
    let response = ureq::post(url)
        .header("content-type", "multipart/form-data; boundary=test")
        .send_bytes(&payload)?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_body().read_to_string()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.rustUreq, requestModelPost7,
              SupportedUriSchemes.https,
              boundary: "test"),
          expectedCode);
    });
    test('POST 8', () {
      const expectedCode = r"""use std::io::Read;
fn main() -> Result<(), ureq::Error> {
    let url = "https://api.apidash.dev/io/form";
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
    let response = ureq::post(url)
        .query("size", "2")
        .query("len", "3")
        .header("content-type", "multipart/form-data; boundary=test")
        .send_bytes(&payload)?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_body().read_to_string()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.rustUreq, requestModelPost8,
              SupportedUriSchemes.https,
              boundary: "test"),
          expectedCode);
    });
    test('POST 9', () {
      const expectedCode = r"""use std::io::Read;
fn main() -> Result<(), ureq::Error> {
    let url = "https://api.apidash.dev/io/img";
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
    let response = ureq::post(url)
        .query("size", "2")
        .query("len", "3")
        .header("User-Agent", "Test Agent")
        .header("Keep-Alive", "true")
        .header("content-type", "multipart/form-data; boundary=test")
        .send_bytes(&payload)?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_body().read_to_string()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.rustUreq, requestModelPost9,
              SupportedUriSchemes.https,
              boundary: "test"),
          expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT 1', () {
      const expectedCode = r'''use serde_json::json;
fn main() -> Result<(), ureq::Error> {
    let url = "https://reqres.in/api/users/2";

    let payload = json!({
"name": "morpheus",
"job": "zion resident"
});

    let response = ureq::put(url)
        .send_json(payload)?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_body().read_to_string()?);

    Ok(())
}
''';
      expect(
          codeGen.getCode(
            CodegenLanguage.rustUreq,
            requestModelPut1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH 1', () {
      const expectedCode = r'''
use serde_json::json;
fn main() -> Result<(), ureq::Error> {
    let url = "https://reqres.in/api/users/2";

    let payload = json!({
"name": "marfeus",
"job": "accountant"
});

    let response = ureq::patch(url)
        .send_json(payload)?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_body().read_to_string()?);

    Ok(())
}
''';
      expect(
          codeGen.getCode(
            CodegenLanguage.rustUreq,
            requestModelPatch1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode = r"""
fn main() -> Result<(), ureq::Error> {
    let url = "https://reqres.in/api/users/2";
    let response = ureq::delete(url)
        .call()?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_body().read_to_string()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustUreq,
            requestModelDelete1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('DELETE 2', () {
      const expectedCode = r'''
use serde_json::json;
fn main() -> Result<(), ureq::Error> {
    let url = "https://reqres.in/api/users/2";

    let payload = json!({
"name": "marfeus",
"job": "accountant"
});

    let response = ureq::delete(url)
        .send_json(payload)?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_body().read_to_string()?);

    Ok(())
}
''';
      expect(
          codeGen.getCode(
            CodegenLanguage.rustUreq,
            requestModelDelete2,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });
}
