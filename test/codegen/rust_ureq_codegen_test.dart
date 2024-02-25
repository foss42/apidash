import 'package:apidash/codegen/rust/ureq.dart';
import 'package:test/test.dart';
import '../request_models.dart';

void main() {
  final rustUreqCodeGen = RustUreqCodeGen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""fn main() -> Result<(), ureq::Error> {
    let url = "https://api.foss42.com";
    let response = ureq::get(url)
        .call()?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_string()?);

    Ok(())
}
""";
      expect(rustUreqCodeGen.getCode(requestModelGet1, "https"), expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r"""fn main() -> Result<(), ureq::Error> {
    let url = "https://api.foss42.com/country/data";
    let response = ureq::get(url)
        .query("code", "US")
        .call()?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_string()?);

    Ok(())
}
""";
      expect(rustUreqCodeGen.getCode(requestModelGet2, "https"), expectedCode);
    });

    test('GET 3', () {
      const expectedCode = r"""fn main() -> Result<(), ureq::Error> {
    let url = "https://api.foss42.com/country/data";
    let response = ureq::get(url)
        .query("code", "IND")
        .call()?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_string()?);

    Ok(())
}
""";
      expect(rustUreqCodeGen.getCode(requestModelGet3, "https"), expectedCode);
    });

    test('GET 4', () {
      const expectedCode = r"""fn main() -> Result<(), ureq::Error> {
    let url = "https://api.foss42.com/humanize/social";
    let response = ureq::get(url)
        .query("num", "8700000")
        .query("digits", "3")
        .query("system", "SS")
        .query("add_space", "true")
        .query("trailing_zeros", "true")
        .call()?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_string()?);

    Ok(())
}
""";
      expect(rustUreqCodeGen.getCode(requestModelGet4, "https"), expectedCode);
    });

    test('GET 5', () {
      const expectedCode = r"""fn main() -> Result<(), ureq::Error> {
    let url = "https://api.github.com/repos/foss42/apidash";
    let response = ureq::get(url)
        .set("User-Agent", "Test Agent")
        .call()?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_string()?);

    Ok(())
}
""";
      expect(rustUreqCodeGen.getCode(requestModelGet5, "https"), expectedCode);
    });

    test('GET 6', () {
      const expectedCode = r"""fn main() -> Result<(), ureq::Error> {
    let url = "https://api.github.com/repos/foss42/apidash";
    let response = ureq::get(url)
        .query("raw", "true")
        .set("User-Agent", "Test Agent")
        .call()?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_string()?);

    Ok(())
}
""";
      expect(rustUreqCodeGen.getCode(requestModelGet6, "https"), expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r"""fn main() -> Result<(), ureq::Error> {
    let url = "https://api.foss42.com";
    let response = ureq::get(url)
        .call()?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_string()?);

    Ok(())
}
""";
      expect(rustUreqCodeGen.getCode(requestModelGet7, "https"), expectedCode);
    });

    test('GET 8', () {
      const expectedCode = r"""fn main() -> Result<(), ureq::Error> {
    let url = "https://api.github.com/repos/foss42/apidash";
    let response = ureq::get(url)
        .query("raw", "true")
        .set("User-Agent", "Test Agent")
        .call()?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_string()?);

    Ok(())
}
""";
      expect(rustUreqCodeGen.getCode(requestModelGet8, "https"), expectedCode);
    });

    test('GET 9', () {
      const expectedCode = r"""fn main() -> Result<(), ureq::Error> {
    let url = "https://api.foss42.com/humanize/social";
    let response = ureq::get(url)
        .query("num", "8700000")
        .query("add_space", "true")
        .call()?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_string()?);

    Ok(())
}
""";
      expect(rustUreqCodeGen.getCode(requestModelGet9, "https"), expectedCode);
    });

    test('GET 10', () {
      const expectedCode = r"""fn main() -> Result<(), ureq::Error> {
    let url = "https://api.foss42.com/humanize/social";
    let response = ureq::get(url)
        .set("User-Agent", "Test Agent")
        .call()?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_string()?);

    Ok(())
}
""";
      expect(
          rustUreqCodeGen.getCode(
            requestModelGet10,
            "https",
          ),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode = r"""fn main() -> Result<(), ureq::Error> {
    let url = "https://api.foss42.com/humanize/social";
    let response = ureq::get(url)
        .query("num", "8700000")
        .query("digits", "3")
        .set("User-Agent", "Test Agent")
        .call()?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_string()?);

    Ok(())
}
""";
      expect(rustUreqCodeGen.getCode(requestModelGet11, "https"), expectedCode);
    });

    test('GET 12', () {
      const expectedCode = r"""fn main() -> Result<(), ureq::Error> {
    let url = "https://api.foss42.com/humanize/social";
    let response = ureq::get(url)
        .call()?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_string()?);

    Ok(())
}
""";
      expect(rustUreqCodeGen.getCode(requestModelGet12, "https"), expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""fn main() -> Result<(), ureq::Error> {
    let url = "https://api.foss42.com";
    let response = ureq::head(url)
        .call()?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_string()?);

    Ok(())
}
""";
      expect(rustUreqCodeGen.getCode(requestModelHead1, "https"), expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""fn main() -> Result<(), ureq::Error> {
    let url = "http://api.foss42.com";
    let response = ureq::head(url)
        .call()?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_string()?);

    Ok(())
}
""";
      expect(rustUreqCodeGen.getCode(requestModelHead2, "http"), expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r'''fn main() -> Result<(), ureq::Error> {
    let url = "https://api.foss42.com/case/lower";
    let payload = r#"{
"text": "I LOVE Flutter"
}"#;

    let response = ureq::post(url)
        .set("content-type", "text/plain")
        .send_string(payload)?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_string()?);

    Ok(())
}
''';
      expect(rustUreqCodeGen.getCode(requestModelPost1, "https"), expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r'''fn main() -> Result<(), ureq::Error> {
    let url = "https://api.foss42.com/case/lower";
    let payload = ureq::json!({
"text": "I LOVE Flutter"
});

    let response = ureq::post(url)
        .send_json(payload)?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_string()?);

    Ok(())
}
''';
      expect(rustUreqCodeGen.getCode(requestModelPost2, "https"), expectedCode);
    });

    test('POST 3', () {
      const expectedCode = r'''fn main() -> Result<(), ureq::Error> {
    let url = "https://api.foss42.com/case/lower";
    let payload = ureq::json!({
"text": "I LOVE Flutter"
});

    let response = ureq::post(url)
        .set("User-Agent", "Test Agent")
        .send_json(payload)?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_string()?);

    Ok(())
}
''';
      expect(rustUreqCodeGen.getCode(requestModelPost3, "https"), expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT 1', () {
      const expectedCode = r'''fn main() -> Result<(), ureq::Error> {
    let url = "https://reqres.in/api/users/2";
    let payload = ureq::json!({
"name": "morpheus",
"job": "zion resident"
});

    let response = ureq::put(url)
        .send_json(payload)?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_string()?);

    Ok(())
}
''';
      expect(rustUreqCodeGen.getCode(requestModelPut1, "https"), expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH 1', () {
      const expectedCode = r'''fn main() -> Result<(), ureq::Error> {
    let url = "https://reqres.in/api/users/2";
    let payload = ureq::json!({
"name": "marfeus",
"job": "accountant"
});

    let response = ureq::patch(url)
        .send_json(payload)?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_string()?);

    Ok(())
}
''';
      expect(
          rustUreqCodeGen.getCode(requestModelPatch1, "https"), expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode = r"""fn main() -> Result<(), ureq::Error> {
    let url = "https://reqres.in/api/users/2";
    let response = ureq::delete(url)
        .call()?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_string()?);

    Ok(())
}
""";
      expect(
          rustUreqCodeGen.getCode(requestModelDelete1, "https"), expectedCode);
    });

    test('DELETE 2', () {
      const expectedCode = r'''fn main() -> Result<(), ureq::Error> {
    let url = "https://reqres.in/api/users/2";
    let payload = ureq::json!({
"name": "marfeus",
"job": "accountant"
});

    let response = ureq::delete(url)
        .send_json(payload)?;

    println!("Response Status: {}", response.status());
    println!("Response: {}", response.into_string()?);

    Ok(())
}
''';
      expect(
          rustUreqCodeGen.getCode(requestModelDelete2, "https"), expectedCode);
    });
  });
}
