import 'package:apidash/codegen/rust/actix.dart';
import '../request_models.dart';
import 'package:test/test.dart';

void main() {
  final rustActixCodeGen = RustActixCodeGen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.foss42.com";
    let client = awc::Client::default();

    let mut response = client
        .get(url)
        .send()
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(rustActixCodeGen.getCode(requestModelGet1, "https"), expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.foss42.com/country/data";
    let client = awc::Client::default();

    let mut response = client
        .get(url)
        .query(&[("code", "US")])
        .unwrap()
        .send()
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(rustActixCodeGen.getCode(requestModelGet2, "https"), expectedCode);
    });

    test('GET 3', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.foss42.com/country/data";
    let client = awc::Client::default();

    let mut response = client
        .get(url)
        .query(&[("code", "IND")])
        .unwrap()
        .send()
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(rustActixCodeGen.getCode(requestModelGet3, "https"), expectedCode);
    });

    test('GET 4', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.foss42.com/humanize/social";
    let client = awc::Client::default();

    let mut response = client
        .get(url)
        .query(&[("num", "8700000"), ("digits", "3"), ("system", "SS"), ("add_space", "true"), ("trailing_zeros", "true")])
        .unwrap()
        .send()
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(rustActixCodeGen.getCode(requestModelGet4, "https"), expectedCode);
    });

    test('GET 5', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.github.com/repos/foss42/apidash";
    let client = awc::Client::default();

    let mut response = client
        .get(url)
        .insert_header(("User-Agent", "Test Agent"))
        .send()
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(rustActixCodeGen.getCode(requestModelGet5, "https"), expectedCode);
    });

    test('GET 6', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.github.com/repos/foss42/apidash";
    let client = awc::Client::default();

    let mut response = client
        .get(url)
        .query(&[("raw", "true")])
        .unwrap()
        .insert_header(("User-Agent", "Test Agent"))
        .send()
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(rustActixCodeGen.getCode(requestModelGet6, "https"), expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.foss42.com";
    let client = awc::Client::default();

    let mut response = client
        .get(url)
        .send()
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(rustActixCodeGen.getCode(requestModelGet7, "https"), expectedCode);
    });

    test('GET 8', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.github.com/repos/foss42/apidash";
    let client = awc::Client::default();

    let mut response = client
        .get(url)
        .query(&[("raw", "true")])
        .unwrap()
        .insert_header(("User-Agent", "Test Agent"))
        .send()
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(rustActixCodeGen.getCode(requestModelGet8, "https"), expectedCode);
    });

    test('GET 9', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.foss42.com/humanize/social";
    let client = awc::Client::default();

    let mut response = client
        .get(url)
        .query(&[("num", "8700000"), ("add_space", "true")])
        .unwrap()
        .send()
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(rustActixCodeGen.getCode(requestModelGet9, "https"), expectedCode);
    });

    test('GET 10', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.foss42.com/humanize/social";
    let client = awc::Client::default();

    let mut response = client
        .get(url)
        .insert_header(("User-Agent", "Test Agent"))
        .send()
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
          rustActixCodeGen.getCode(
            requestModelGet10,
            "https",
          ),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.foss42.com/humanize/social";
    let client = awc::Client::default();

    let mut response = client
        .get(url)
        .query(&[("num", "8700000"), ("digits", "3")])
        .unwrap()
        .insert_header(("User-Agent", "Test Agent"))
        .send()
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
          rustActixCodeGen.getCode(requestModelGet11, "https"), expectedCode);
    });

    test('GET 12', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.foss42.com/humanize/social";
    let client = awc::Client::default();

    let mut response = client
        .get(url)
        .send()
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
          rustActixCodeGen.getCode(requestModelGet12, "https"), expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.foss42.com";
    let client = awc::Client::default();

    let mut response = client
        .head(url)
        .send()
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
          rustActixCodeGen.getCode(requestModelHead1, "https"), expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "http://api.foss42.com";
    let client = awc::Client::default();

    let mut response = client
        .head(url)
        .send()
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(rustActixCodeGen.getCode(requestModelHead2, "http"), expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.foss42.com/case/lower";
    let client = awc::Client::default();

    let payload = r#"{
"text": "I LOVE Flutter"
}"#;

    let mut response = client
        .post(url)
        .insert_header(("content-type", "text/plain"))
        .send_body(payload)
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
          rustActixCodeGen.getCode(requestModelPost1, "https"), expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.foss42.com/case/lower";
    let client = awc::Client::default();

    let payload = serde_json::json!({
"text": "I LOVE Flutter"
});

    let mut response = client
        .post(url)
        .send_json(&payload)
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
          rustActixCodeGen.getCode(requestModelPost2, "https"), expectedCode);
    });

    test('POST 3', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://api.foss42.com/case/lower";
    let client = awc::Client::default();

    let payload = serde_json::json!({
"text": "I LOVE Flutter"
});

    let mut response = client
        .post(url)
        .insert_header(("User-Agent", "Test Agent"))
        .send_json(&payload)
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
          rustActixCodeGen.getCode(requestModelPost3, "https"), expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT 1', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://reqres.in/api/users/2";
    let client = awc::Client::default();

    let payload = serde_json::json!({
"name": "morpheus",
"job": "zion resident"
});

    let mut response = client
        .put(url)
        .send_json(&payload)
        .await
        .unwrap();

    let body_bytes = response.body().await.unwrap();
    let body = std::str::from_utf8(&body_bytes).unwrap();
    println!("Response Status: {}", response.status());
    println!("Response: {:?}", body);

    Ok(())
}
""";
      expect(rustActixCodeGen.getCode(requestModelPut1, "https"), expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH 1', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://reqres.in/api/users/2";
    let client = awc::Client::default();

    let payload = serde_json::json!({
"name": "marfeus",
"job": "accountant"
});

    let mut response = client
        .patch(url)
        .send_json(&payload)
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
          rustActixCodeGen.getCode(requestModelPatch1, "https"), expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://reqres.in/api/users/2";
    let client = awc::Client::default();

    let mut response = client
        .delete(url)
        .send()
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
          rustActixCodeGen.getCode(requestModelDelete1, "https"), expectedCode);
    });

    test('DELETE 2', () {
      const expectedCode = r"""#[actix_rt::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = "https://reqres.in/api/users/2";
    let client = awc::Client::default();

    let payload = serde_json::json!({
"name": "marfeus",
"job": "accountant"
});

    let mut response = client
        .delete(url)
        .send_json(&payload)
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
          rustActixCodeGen.getCode(requestModelDelete2, "https"), expectedCode);
    });
  });
}
