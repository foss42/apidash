import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:test/test.dart';
import '../models/request_models.dart';

void main() {
  final codeGen = Codegen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client = reqwest::blocking::Client::new();
    let url = "https://api.apidash.dev";

    let response = client
        .get(url)
        .send()?;

    println!("Status Code: {}", response.status()); 
    println!("Response Body: {}", response.text()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rustReqwest, requestModelGet1, "https"),
          expectedCode);
    });

    test('GET 2', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client = reqwest::blocking::Client::new();
    let url = "https://api.apidash.dev/country/data";

    let response = client
        .get(url)
        .query(&[("code", "US")])
        .send()?;

    println!("Status Code: {}", response.status()); 
    println!("Response Body: {}", response.text()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rustReqwest, requestModelGet2, "https"),
          expectedCode);
    });

    test('GET 3', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client = reqwest::blocking::Client::new();
    let url = "https://api.apidash.dev/country/data";

    let response = client
        .get(url)
        .query(&[("code", "IND")])
        .send()?;

    println!("Status Code: {}", response.status()); 
    println!("Response Body: {}", response.text()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rustReqwest, requestModelGet3, "https"),
          expectedCode);
    });

    test('GET 4', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client = reqwest::blocking::Client::new();
    let url = "https://api.apidash.dev/humanize/social";

    let response = client
        .get(url)
        .query(&[("num", "8700000"), ("digits", "3"), ("system", "SS"), ("add_space", "true"), ("trailing_zeros", "true")])
        .send()?;

    println!("Status Code: {}", response.status()); 
    println!("Response Body: {}", response.text()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rustReqwest, requestModelGet4, "https"),
          expectedCode);
    });

    test('GET 5', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client = reqwest::blocking::Client::new();
    let url = "https://api.github.com/repos/foss42/apidash";

    let response = client
        .get(url)
        .header("User-Agent", "Test Agent")
        .send()?;

    println!("Status Code: {}", response.status()); 
    println!("Response Body: {}", response.text()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rustReqwest, requestModelGet5, "https"),
          expectedCode);
    });

    test('GET 6', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client = reqwest::blocking::Client::new();
    let url = "https://api.github.com/repos/foss42/apidash";

    let response = client
        .get(url)
        .query(&[("raw", "true")])
        .header("User-Agent", "Test Agent")
        .send()?;

    println!("Status Code: {}", response.status()); 
    println!("Response Body: {}", response.text()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rustReqwest, requestModelGet6, "https"),
          expectedCode);
    });

    test('GET 7', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client = reqwest::blocking::Client::new();
    let url = "https://api.apidash.dev";

    let response = client
        .get(url)
        .send()?;

    println!("Status Code: {}", response.status()); 
    println!("Response Body: {}", response.text()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rustReqwest, requestModelGet7, "https"),
          expectedCode);
    });

    test('GET 8', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client = reqwest::blocking::Client::new();
    let url = "https://api.github.com/repos/foss42/apidash";

    let response = client
        .get(url)
        .query(&[("raw", "true")])
        .header("User-Agent", "Test Agent")
        .send()?;

    println!("Status Code: {}", response.status()); 
    println!("Response Body: {}", response.text()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rustReqwest, requestModelGet8, "https"),
          expectedCode);
    });

    test('GET 9', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client = reqwest::blocking::Client::new();
    let url = "https://api.apidash.dev/humanize/social";

    let response = client
        .get(url)
        .query(&[("num", "8700000"), ("add_space", "true")])
        .send()?;

    println!("Status Code: {}", response.status()); 
    println!("Response Body: {}", response.text()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rustReqwest, requestModelGet9, "https"),
          expectedCode);
    });

    test('GET 10', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client = reqwest::blocking::Client::new();
    let url = "https://api.apidash.dev/humanize/social";

    let response = client
        .get(url)
        .header("User-Agent", "Test Agent")
        .send()?;

    println!("Status Code: {}", response.status()); 
    println!("Response Body: {}", response.text()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustReqwest,
            requestModelGet10,
            "https",
          ),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client = reqwest::blocking::Client::new();
    let url = "https://api.apidash.dev/humanize/social";

    let response = client
        .get(url)
        .query(&[("num", "8700000"), ("digits", "3")])
        .header("User-Agent", "Test Agent")
        .send()?;

    println!("Status Code: {}", response.status()); 
    println!("Response Body: {}", response.text()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rustReqwest, requestModelGet11, "https"),
          expectedCode);
    });

    test('GET 12', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client = reqwest::blocking::Client::new();
    let url = "https://api.apidash.dev/humanize/social";

    let response = client
        .get(url)
        .send()?;

    println!("Status Code: {}", response.status()); 
    println!("Response Body: {}", response.text()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rustReqwest, requestModelGet12, "https"),
          expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client = reqwest::blocking::Client::new();
    let url = "https://api.apidash.dev";

    let response = client
        .head(url)
        .send()?;

    println!("Status Code: {}", response.status()); 
    println!("Response Body: {}", response.text()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rustReqwest, requestModelHead1, "https"),
          expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client = reqwest::blocking::Client::new();
    let url = "http://api.apidash.dev";

    let response = client
        .head(url)
        .send()?;

    println!("Status Code: {}", response.status()); 
    println!("Response Body: {}", response.text()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rustReqwest, requestModelHead2, "http"),
          expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client = reqwest::blocking::Client::new();
    let url = "https://api.apidash.dev/case/lower";

    let payload = r#"{
"text": "I LOVE Flutter"
}"#;

    let response = client
        .post(url)
        .header("content-type", "text/plain")
        .body(payload)
        .send()?;

    println!("Status Code: {}", response.status()); 
    println!("Response Body: {}", response.text()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rustReqwest, requestModelPost1, "https"),
          expectedCode);
    });

    test('POST 2', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client = reqwest::blocking::Client::new();
    let url = "https://api.apidash.dev/case/lower";

    let payload = serde_json::json!({
"text": "I LOVE Flutter",
"flag": null,
"male": true,
"female": false,
"no": 1.2,
"arr": ["null", "true", "false", null]
});

    let response = client
        .post(url)
        .json(&payload)
        .send()?;

    println!("Status Code: {}", response.status()); 
    println!("Response Body: {}", response.text()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rustReqwest, requestModelPost2, "https"),
          expectedCode);
    });

    test('POST 3', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client = reqwest::blocking::Client::new();
    let url = "https://api.apidash.dev/case/lower";

    let payload = serde_json::json!({
"text": "I LOVE Flutter"
});

    let response = client
        .post(url)
        .header("User-Agent", "Test Agent")
        .json(&payload)
        .send()?;

    println!("Status Code: {}", response.status()); 
    println!("Response Body: {}", response.text()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rustReqwest, requestModelPost3, "https"),
          expectedCode);
    });
    test('POST 4', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client = reqwest::blocking::Client::new();
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
  
    let mut form = reqwest::blocking::multipart::Form::new();
    
    for item in form_data_items {
        if item.field_type == "text" {
            form = form.text(item.name, item.value);
        } else if item.field_type == "file" {
            form = form.file(item.name, &item.value)?; 
        }
    }
    let response = client
        .post(url)
        .multipart(form)
        .send()?;

    println!("Status Code: {}", response.status()); 
    println!("Response Body: {}", response.text()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustReqwest,
            requestModelPost4,
            "https",
            boundary: "test",
          ),
          expectedCode);
    });
    test('POST 5', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client = reqwest::blocking::Client::new();
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
  
    let mut form = reqwest::blocking::multipart::Form::new();
    
    for item in form_data_items {
        if item.field_type == "text" {
            form = form.text(item.name, item.value);
        } else if item.field_type == "file" {
            form = form.file(item.name, &item.value)?; 
        }
    }
    let response = client
        .post(url)
        .header("User-Agent", "Test Agent")
        .multipart(form)
        .send()?;

    println!("Status Code: {}", response.status()); 
    println!("Response Body: {}", response.text()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rustReqwest, requestModelPost5, "https",
              boundary: "test"),
          expectedCode);
    });
    test('POST 6', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client = reqwest::blocking::Client::new();
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
  
    let mut form = reqwest::blocking::multipart::Form::new();
    
    for item in form_data_items {
        if item.field_type == "text" {
            form = form.text(item.name, item.value);
        } else if item.field_type == "file" {
            form = form.file(item.name, &item.value)?; 
        }
    }
    let response = client
        .post(url)
        .multipart(form)
        .send()?;

    println!("Status Code: {}", response.status()); 
    println!("Response Body: {}", response.text()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rustReqwest, requestModelPost6, "https",
              boundary: "test"),
          expectedCode);
    });
    test('POST 7', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client = reqwest::blocking::Client::new();
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
  
    let mut form = reqwest::blocking::multipart::Form::new();
    
    for item in form_data_items {
        if item.field_type == "text" {
            form = form.text(item.name, item.value);
        } else if item.field_type == "file" {
            form = form.file(item.name, &item.value)?; 
        }
    }
    let response = client
        .post(url)
        .multipart(form)
        .send()?;

    println!("Status Code: {}", response.status()); 
    println!("Response Body: {}", response.text()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rustReqwest, requestModelPost7, "https",
              boundary: "test"),
          expectedCode);
    });
    test('POST 8', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client = reqwest::blocking::Client::new();
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
  
    let mut form = reqwest::blocking::multipart::Form::new();
    
    for item in form_data_items {
        if item.field_type == "text" {
            form = form.text(item.name, item.value);
        } else if item.field_type == "file" {
            form = form.file(item.name, &item.value)?; 
        }
    }
    let response = client
        .post(url)
        .query(&[("size", "2"), ("len", "3")])
        .multipart(form)
        .send()?;

    println!("Status Code: {}", response.status()); 
    println!("Response Body: {}", response.text()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rustReqwest, requestModelPost8, "https",
              boundary: "test"),
          expectedCode);
    });
    test('POST 9', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client = reqwest::blocking::Client::new();
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
  
    let mut form = reqwest::blocking::multipart::Form::new();
    
    for item in form_data_items {
        if item.field_type == "text" {
            form = form.text(item.name, item.value);
        } else if item.field_type == "file" {
            form = form.file(item.name, &item.value)?; 
        }
    }
    let response = client
        .post(url)
        .query(&[("size", "2"), ("len", "3")])
        .header("User-Agent", "Test Agent")
        .header("Keep-Alive", "true")
        .multipart(form)
        .send()?;

    println!("Status Code: {}", response.status()); 
    println!("Response Body: {}", response.text()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rustReqwest, requestModelPost9, "https",
              boundary: "test"),
          expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT 1', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client = reqwest::blocking::Client::new();
    let url = "https://reqres.in/api/users/2";

    let payload = serde_json::json!({
"name": "morpheus",
"job": "zion resident"
});

    let response = client
        .put(url)
        .json(&payload)
        .send()?;

    println!("Status Code: {}", response.status()); 
    println!("Response Body: {}", response.text()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rustReqwest, requestModelPut1, "https"),
          expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH 1', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client = reqwest::blocking::Client::new();
    let url = "https://reqres.in/api/users/2";

    let payload = serde_json::json!({
"name": "marfeus",
"job": "accountant"
});

    let response = client
        .patch(url)
        .json(&payload)
        .send()?;

    println!("Status Code: {}", response.status()); 
    println!("Response Body: {}", response.text()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rustReqwest, requestModelPatch1, "https"),
          expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client = reqwest::blocking::Client::new();
    let url = "https://reqres.in/api/users/2";

    let response = client
        .delete(url)
        .send()?;

    println!("Status Code: {}", response.status()); 
    println!("Response Body: {}", response.text()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rustReqwest, requestModelDelete1, "https"),
          expectedCode);
    });

    test('DELETE 2', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client = reqwest::blocking::Client::new();
    let url = "https://reqres.in/api/users/2";

    let payload = serde_json::json!({
"name": "marfeus",
"job": "accountant"
});

    let response = client
        .delete(url)
        .json(&payload)
        .send()?;

    println!("Status Code: {}", response.status()); 
    println!("Response Body: {}", response.text()?);

    Ok(())
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.rustReqwest, requestModelDelete2, "https"),
          expectedCode);
    });
  });
}
