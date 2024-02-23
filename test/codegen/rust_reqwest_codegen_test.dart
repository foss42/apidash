import 'package:apidash/codegen/rust/reqwest.dart';
import '../request_models.dart';
import 'package:test/test.dart';

void main() {
  final rustReqwestCodeGen = RustReqwestCodeGen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
  let client = reqwest::blocking::Client::new();
  let url = "https://api.foss42.com";

  let response = client.get(url)
    .send()?;

  println!("Status Code: {}", response.status()); 
  println!("Response Body: {}", response.text()?);

  Ok(())
}
""";
      expect(
          rustReqwestCodeGen.getCode(requestModelGet1, "https"), expectedCode);
    });

    test('GET 2', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
  let client = reqwest::blocking::Client::new();
  let url = "https://api.foss42.com/country/data";

  let params = [("code", "US")];

  let response = client.get(url)
    .query(&params)
    .send()?;

  println!("Status Code: {}", response.status()); 
  println!("Response Body: {}", response.text()?);

  Ok(())
}
""";
      expect(
          rustReqwestCodeGen.getCode(requestModelGet2, "https"), expectedCode);
    });

    test('GET 3', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
  let client = reqwest::blocking::Client::new();
  let url = "https://api.foss42.com/country/data";

  let params = [("code", "IND")];

  let response = client.get(url)
    .query(&params)
    .send()?;

  println!("Status Code: {}", response.status()); 
  println!("Response Body: {}", response.text()?);

  Ok(())
}
""";
      expect(
          rustReqwestCodeGen.getCode(requestModelGet3, "https"), expectedCode);
    });

    test('GET 4', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
  let client = reqwest::blocking::Client::new();
  let url = "https://api.foss42.com/humanize/social";

  let params = [("num", "8700000"), ("digits", "3"), ("system", "SS"), ("add_space", "true"), ("trailing_zeros", "true")];

  let response = client.get(url)
    .query(&params)
    .send()?;

  println!("Status Code: {}", response.status()); 
  println!("Response Body: {}", response.text()?);

  Ok(())
}
""";
      expect(
          rustReqwestCodeGen.getCode(requestModelGet4, "https"), expectedCode);
    });

    test('GET 5', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
  let client = reqwest::blocking::Client::new();
  let url = "https://api.github.com/repos/foss42/apidash";

  let header_str = r#"{
            "User-Agent": "Test Agent"
          }"#;
    let headers_map: std::collections::HashMap<&str, &str> = serde_json::from_str(header_str)?; // Deserialize as &str
    let mut headers = reqwest::header::HeaderMap::new();
    for (key, val) in headers_map {
        headers.insert(key, reqwest::header::HeaderValue::from_str(val)?);
    }

  let response = client.get(url)
    .headers(headers)
    .send()?;

  println!("Status Code: {}", response.status()); 
  println!("Response Body: {}", response.text()?);

  Ok(())
}
""";
      expect(
          rustReqwestCodeGen.getCode(requestModelGet5, "https"), expectedCode);
    });

    test('GET 6', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
  let client = reqwest::blocking::Client::new();
  let url = "https://api.github.com/repos/foss42/apidash";

  let params = [("raw", "true")];

  let header_str = r#"{
            "User-Agent": "Test Agent"
          }"#;
    let headers_map: std::collections::HashMap<&str, &str> = serde_json::from_str(header_str)?; // Deserialize as &str
    let mut headers = reqwest::header::HeaderMap::new();
    for (key, val) in headers_map {
        headers.insert(key, reqwest::header::HeaderValue::from_str(val)?);
    }

  let response = client.get(url)
    .query(&params)
    .headers(headers)
    .send()?;

  println!("Status Code: {}", response.status()); 
  println!("Response Body: {}", response.text()?);

  Ok(())
}
""";
      expect(
          rustReqwestCodeGen.getCode(requestModelGet6, "https"), expectedCode);
    });

    test('GET 7', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
  let client = reqwest::blocking::Client::new();
  let url = "https://api.foss42.com";

  let response = client.get(url)
    .send()?;

  println!("Status Code: {}", response.status()); 
  println!("Response Body: {}", response.text()?);

  Ok(())
}
""";
      expect(
          rustReqwestCodeGen.getCode(requestModelGet7, "https"), expectedCode);
    });

    test('GET 8', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
  let client = reqwest::blocking::Client::new();
  let url = "https://api.github.com/repos/foss42/apidash";

  let params = [("raw", "true")];

  let header_str = r#"{
            "User-Agent": "Test Agent"
          }"#;
    let headers_map: std::collections::HashMap<&str, &str> = serde_json::from_str(header_str)?; // Deserialize as &str
    let mut headers = reqwest::header::HeaderMap::new();
    for (key, val) in headers_map {
        headers.insert(key, reqwest::header::HeaderValue::from_str(val)?);
    }

  let response = client.get(url)
    .query(&params)
    .headers(headers)
    .send()?;

  println!("Status Code: {}", response.status()); 
  println!("Response Body: {}", response.text()?);

  Ok(())
}
""";
      expect(
          rustReqwestCodeGen.getCode(requestModelGet8, "https"), expectedCode);
    });

    test('GET 9', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
  let client = reqwest::blocking::Client::new();
  let url = "https://api.foss42.com/humanize/social";

  let params = [("num", "8700000"), ("add_space", "true")];

  let response = client.get(url)
    .query(&params)
    .send()?;

  println!("Status Code: {}", response.status()); 
  println!("Response Body: {}", response.text()?);

  Ok(())
}
""";
      expect(
          rustReqwestCodeGen.getCode(requestModelGet9, "https"), expectedCode);
    });

    test('GET 10', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
  let client = reqwest::blocking::Client::new();
  let url = "https://api.foss42.com/humanize/social";

  let header_str = r#"{
            "User-Agent": "Test Agent"
          }"#;
    let headers_map: std::collections::HashMap<&str, &str> = serde_json::from_str(header_str)?; // Deserialize as &str
    let mut headers = reqwest::header::HeaderMap::new();
    for (key, val) in headers_map {
        headers.insert(key, reqwest::header::HeaderValue::from_str(val)?);
    }

  let response = client.get(url)
    .headers(headers)
    .send()?;

  println!("Status Code: {}", response.status()); 
  println!("Response Body: {}", response.text()?);

  Ok(())
}
""";
      expect(
          rustReqwestCodeGen.getCode(
            requestModelGet10,
            "https",
          ),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
  let client = reqwest::blocking::Client::new();
  let url = "https://api.foss42.com/humanize/social";

  let params = [("num", "8700000"), ("digits", "3")];

  let header_str = r#"{
            "User-Agent": "Test Agent"
          }"#;
    let headers_map: std::collections::HashMap<&str, &str> = serde_json::from_str(header_str)?; // Deserialize as &str
    let mut headers = reqwest::header::HeaderMap::new();
    for (key, val) in headers_map {
        headers.insert(key, reqwest::header::HeaderValue::from_str(val)?);
    }

  let response = client.get(url)
    .query(&params)
    .headers(headers)
    .send()?;

  println!("Status Code: {}", response.status()); 
  println!("Response Body: {}", response.text()?);

  Ok(())
}
""";
      expect(
          rustReqwestCodeGen.getCode(requestModelGet11, "https"), expectedCode);
    });

    test('GET 12', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
  let client = reqwest::blocking::Client::new();
  let url = "https://api.foss42.com/humanize/social";

  let response = client.get(url)
    .send()?;

  println!("Status Code: {}", response.status()); 
  println!("Response Body: {}", response.text()?);

  Ok(())
}
""";
      expect(
          rustReqwestCodeGen.getCode(requestModelGet12, "https"), expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
  let client = reqwest::blocking::Client::new();
  let url = "https://api.foss42.com";

  let response = client.head(url)
    .send()?;

  println!("Status Code: {}", response.status()); 
  println!("Response Body: {}", response.text()?);

  Ok(())
}
""";
      expect(
          rustReqwestCodeGen.getCode(requestModelHead1, "https"), expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
  let client = reqwest::blocking::Client::new();
  let url = "http://api.foss42.com";

  let response = client.head(url)
    .send()?;

  println!("Status Code: {}", response.status()); 
  println!("Response Body: {}", response.text()?);

  Ok(())
}
""";
      expect(
          rustReqwestCodeGen.getCode(requestModelHead2, "http"), expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
  let client = reqwest::blocking::Client::new();
  let url = "https://api.foss42.com/case/lower";

  let payload = b"{
"text": "I LOVE Flutter"
}";

  let header_str = r#"{
            "content-type": "text/plain"
          }"#;
    let headers_map: std::collections::HashMap<&str, &str> = serde_json::from_str(header_str)?; // Deserialize as &str
    let mut headers = reqwest::header::HeaderMap::new();
    for (key, val) in headers_map {
        headers.insert(key, reqwest::header::HeaderValue::from_str(val)?);
    }

  let response = client.post(url)
    .body(payload.to_vec())
    .headers(headers)
    .send()?;

  println!("Status Code: {}", response.status()); 
  println!("Response Body: {}", response.text()?);

  Ok(())
}
""";
      expect(
          rustReqwestCodeGen.getCode(requestModelPost1, "https"), expectedCode);
    });

    test('POST 2', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
  let client = reqwest::blocking::Client::new();
  let url = "https://api.foss42.com/case/lower";

  let payload = serde_json::json!({
"text": "I LOVE Flutter"
});

  let response = client.post(url)
    .json(&payload)
    .send()?;

  println!("Status Code: {}", response.status()); 
  println!("Response Body: {}", response.text()?);

  Ok(())
}
""";
      expect(
          rustReqwestCodeGen.getCode(requestModelPost2, "https"), expectedCode);
    });

    test('POST 3', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
  let client = reqwest::blocking::Client::new();
  let url = "https://api.foss42.com/case/lower";

  let payload = serde_json::json!({
"text": "I LOVE Flutter"
});

  let header_str = r#"{
            "User-Agent": "Test Agent"
          }"#;
    let headers_map: std::collections::HashMap<&str, &str> = serde_json::from_str(header_str)?; // Deserialize as &str
    let mut headers = reqwest::header::HeaderMap::new();
    for (key, val) in headers_map {
        headers.insert(key, reqwest::header::HeaderValue::from_str(val)?);
    }

  let response = client.post(url)
    .json(&payload)
    .headers(headers)
    .send()?;

  println!("Status Code: {}", response.status()); 
  println!("Response Body: {}", response.text()?);

  Ok(())
}
""";
      expect(
          rustReqwestCodeGen.getCode(requestModelPost3, "https"), expectedCode);
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

  let response = client.put(url)
    .json(&payload)
    .send()?;

  println!("Status Code: {}", response.status()); 
  println!("Response Body: {}", response.text()?);

  Ok(())
}
""";
      expect(
          rustReqwestCodeGen.getCode(requestModelPut1, "https"), expectedCode);
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

  let response = client.patch(url)
    .json(&payload)
    .send()?;

  println!("Status Code: {}", response.status()); 
  println!("Response Body: {}", response.text()?);

  Ok(())
}
""";
      expect(rustReqwestCodeGen.getCode(requestModelPatch1, "https"),
          expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode =
          r"""fn main() -> Result<(), Box<dyn std::error::Error>> {
  let client = reqwest::blocking::Client::new();
  let url = "https://reqres.in/api/users/2";

  let response = client.delete(url)
    .send()?;

  println!("Status Code: {}", response.status()); 
  println!("Response Body: {}", response.text()?);

  Ok(())
}
""";
      expect(rustReqwestCodeGen.getCode(requestModelDelete1, "https"),
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

  let response = client.delete(url)
    .json(&payload)
    .send()?;

  println!("Status Code: {}", response.status()); 
  println!("Response Body: {}", response.text()?);

  Ok(())
}
""";
      expect(rustReqwestCodeGen.getCode(requestModelDelete2, "https"),
          expectedCode);
    });
  });
}
