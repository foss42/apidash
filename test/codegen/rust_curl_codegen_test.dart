import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:test/test.dart';
import '../models/request_models.dart';

void main() {
  final codeGen = Codegen();

  group('GET Request', () {
    test('GET1', () {
      const expectedCode = r"""
use curl::easy::Easy;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
  easy.url("https://api.apidash.dev").unwrap();
  easy.get(true).unwrap();

  {
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
      expect(
          codeGen.getCode(CodegenLanguage.rustCurl, requestModelGet1, "https"),
          expectedCode);
    });
    test('GET2', () {
      const expectedCode = r"""
use curl::easy::Easy;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
  easy.url("https://api.apidash.dev/country/data?code=US").unwrap();
  easy.get(true).unwrap();

  {
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
      expect(
          codeGen.getCode(CodegenLanguage.rustCurl, requestModelGet2, "https"),
          expectedCode);
    });
    test('GET3', () {
      const expectedCode = r"""
use curl::easy::Easy;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
  easy.url("https://api.apidash.dev/country/data?code=IND").unwrap();
  easy.get(true).unwrap();

  {
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
      expect(
          codeGen.getCode(CodegenLanguage.rustCurl, requestModelGet3, "https"),
          expectedCode);
    });
    test('GET4', () {
      const expectedCode = r"""
use curl::easy::Easy;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
  easy.url("https://api.apidash.dev/humanize/social?num=8700000&digits=3&system=SS&add_space=true&trailing_zeros=true").unwrap();
  easy.get(true).unwrap();

  {
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
      expect(
          codeGen.getCode(CodegenLanguage.rustCurl, requestModelGet4, "https"),
          expectedCode);
    });
    test('GET5', () {
      const expectedCode = r"""
use curl::easy::Easy;
use curl::easy::List;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
  easy.url("https://api.github.com/repos/foss42/apidash").unwrap();
  easy.get(true).unwrap();

  let mut list = List::new();
  list.append("User-Agent: Test Agent").unwrap();
  easy.http_headers(list).unwrap();
  
  {
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
      expect(
          codeGen.getCode(CodegenLanguage.rustCurl, requestModelGet5, "https"),
          expectedCode);
    });
    test('GET6', () {
      const expectedCode = r"""
use curl::easy::Easy;
use curl::easy::List;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
  easy.url("https://api.github.com/repos/foss42/apidash?raw=true").unwrap();
  easy.get(true).unwrap();

  let mut list = List::new();
  list.append("User-Agent: Test Agent").unwrap();
  easy.http_headers(list).unwrap();
  
  {
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
      expect(
          codeGen.getCode(CodegenLanguage.rustCurl, requestModelGet6, "https"),
          expectedCode);
    });
    test('GET7', () {
      const expectedCode = r"""
use curl::easy::Easy;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
  easy.url("https://api.apidash.dev").unwrap();
  easy.get(true).unwrap();

  {
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
      expect(
          codeGen.getCode(CodegenLanguage.rustCurl, requestModelGet7, "https"),
          expectedCode);
    });
    test('GET8', () {
      const expectedCode = r"""
use curl::easy::Easy;
use curl::easy::List;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
  easy.url("https://api.github.com/repos/foss42/apidash?raw=true").unwrap();
  easy.get(true).unwrap();

  let mut list = List::new();
  list.append("User-Agent: Test Agent").unwrap();
  easy.http_headers(list).unwrap();
  
  {
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
      expect(
          codeGen.getCode(CodegenLanguage.rustCurl, requestModelGet8, "https"),
          expectedCode);
    });
    test('GET9', () {
      const expectedCode = r"""
use curl::easy::Easy;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
  easy.url("https://api.apidash.dev/humanize/social?num=8700000&add_space=true").unwrap();
  easy.get(true).unwrap();

  {
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
      expect(
          codeGen.getCode(CodegenLanguage.rustCurl, requestModelGet9, "https"),
          expectedCode);
    });
    test('GET10', () {
      const expectedCode = r"""
use curl::easy::Easy;
use curl::easy::List;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
  easy.url("https://api.apidash.dev/humanize/social").unwrap();
  easy.get(true).unwrap();

  let mut list = List::new();
  list.append("User-Agent: Test Agent").unwrap();
  easy.http_headers(list).unwrap();
  
  {
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
      expect(
          codeGen.getCode(CodegenLanguage.rustCurl, requestModelGet10, "https"),
          expectedCode);
    });
    test('GET11', () {
      const expectedCode = r"""
use curl::easy::Easy;
use curl::easy::List;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
  easy.url("https://api.apidash.dev/humanize/social?num=8700000&digits=3").unwrap();
  easy.get(true).unwrap();

  let mut list = List::new();
  list.append("User-Agent: Test Agent").unwrap();
  easy.http_headers(list).unwrap();
  
  {
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
      expect(
          codeGen.getCode(CodegenLanguage.rustCurl, requestModelGet11, "https"),
          expectedCode);
    });
    test('GET12', () {
      const expectedCode = r"""
use curl::easy::Easy;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
  easy.url("https://api.apidash.dev/humanize/social").unwrap();
  easy.get(true).unwrap();

  {
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
      expect(
          codeGen.getCode(CodegenLanguage.rustCurl, requestModelGet12, "https"),
          expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD1', () {
      const expectedCode = r"""
use curl::easy::Easy;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
  easy.url("https://api.apidash.dev").unwrap();
  easy.nobody(true).unwrap();

  {
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
      expect(
          codeGen.getCode(CodegenLanguage.rustCurl, requestModelHead1, "https"),
          expectedCode);
    });
    test('HEAD2', () {
      const expectedCode = r"""
use curl::easy::Easy;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
  easy.url("https://api.apidash.dev").unwrap();
  easy.nobody(true).unwrap();

  {
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
      expect(
          codeGen.getCode(CodegenLanguage.rustCurl, requestModelHead2, "https"),
          expectedCode);
    });
  });

  group('POST Request', () {
    test('POST1', () {
      const expectedCode = r"""
use curl::easy::Easy;
use curl::easy::List;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
  easy.url("https://api.apidash.dev/case/lower").unwrap();
  easy.post(true).unwrap();

  easy.post_fields_copy(r#"{
"text": "I LOVE Flutter"
}"#.as_bytes()).unwrap();

  let mut list = List::new();
  list.append("Content-Type: text/plain").unwrap();
  easy.http_headers(list).unwrap();
  
  {
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
      expect(
          codeGen.getCode(CodegenLanguage.rustCurl, requestModelPost1, "https"),
          expectedCode);
    });
    test('POST2', () {
      const expectedCode = r"""
use curl::easy::Easy;
use serde_json::json;
use curl::easy::List;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
  easy.url("https://api.apidash.dev/case/lower").unwrap();
  easy.post(true).unwrap();

  easy.post_fields_copy(json!({
"text": "I LOVE Flutter",
"flag": null,
"male": true,
"female": false,
"no": 1.2,
"arr": ["null", "true", "false", null]
}).to_string().as_bytes()).unwrap();

  let mut list = List::new();
  list.append("Content-Type: application/json").unwrap();
  easy.http_headers(list).unwrap();
  
  {
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
      expect(
          codeGen.getCode(CodegenLanguage.rustCurl, requestModelPost2, "https"),
          expectedCode);
    });
    test('POST3', () {
      const expectedCode = r"""
use curl::easy::Easy;
use serde_json::json;
use curl::easy::List;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
  easy.url("https://api.apidash.dev/case/lower").unwrap();
  easy.post(true).unwrap();

  easy.post_fields_copy(json!({
"text": "I LOVE Flutter"
}).to_string().as_bytes()).unwrap();

  let mut list = List::new();
  list.append("User-Agent: Test Agent").unwrap();
  list.append("Content-Type: application/json").unwrap();
  easy.http_headers(list).unwrap();
  
  {
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
      expect(
          codeGen.getCode(CodegenLanguage.rustCurl, requestModelPost3, "https"),
          expectedCode);
    });
    test('POST4', () {
      const expectedCode = r"""
use curl::easy::Easy;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
  easy.url("https://api.apidash.dev/io/form").unwrap();
  easy.post(true).unwrap();

  let mut form = curl::easy::Form::new();
  
  form.part("text")
    .contents(b"API")
    .add().unwrap();
  
  form.part("sep")
    .contents(b"|")
    .add().unwrap();
  
  form.part("times")
    .contents(b"3")
    .add().unwrap();
  
  easy.httppost(form).unwrap();
    {
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
      expect(
          codeGen.getCode(CodegenLanguage.rustCurl, requestModelPost4, "https"),
          expectedCode);
    });
    test('POST5', () {
      const expectedCode = r"""
use curl::easy::Easy;
use curl::easy::List;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
  easy.url("https://api.apidash.dev/io/form").unwrap();
  easy.post(true).unwrap();

  let mut form = curl::easy::Form::new();
  
  form.part("text")
    .contents(b"API")
    .add().unwrap();
  
  form.part("sep")
    .contents(b"|")
    .add().unwrap();
  
  form.part("times")
    .contents(b"3")
    .add().unwrap();
  
  easy.httppost(form).unwrap();
    let mut list = List::new();
  list.append("User-Agent: Test Agent").unwrap();
  easy.http_headers(list).unwrap();
  
  {
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
      expect(
          codeGen.getCode(CodegenLanguage.rustCurl, requestModelPost5, "https"),
          expectedCode);
    });
    test('POST6', () {
      const expectedCode = r"""
use curl::easy::Easy;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
  easy.url("https://api.apidash.dev/io/img").unwrap();
  easy.post(true).unwrap();

  let mut form = curl::easy::Form::new();
  
  form.part("token")
    .contents(b"xyz")
    .add().unwrap();
  
  form.part("imfile")
    .file("/Documents/up/1.png")
    .add().unwrap();
  
  easy.httppost(form).unwrap();
    {
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
      expect(
          codeGen.getCode(CodegenLanguage.rustCurl, requestModelPost6, "https"),
          expectedCode);
    });
    test('POST7', () {
      const expectedCode = r"""
use curl::easy::Easy;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
  easy.url("https://api.apidash.dev/io/img").unwrap();
  easy.post(true).unwrap();

  let mut form = curl::easy::Form::new();
  
  form.part("token")
    .contents(b"xyz")
    .add().unwrap();
  
  form.part("imfile")
    .file("/Documents/up/1.png")
    .add().unwrap();
  
  easy.httppost(form).unwrap();
    {
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
      expect(
          codeGen.getCode(CodegenLanguage.rustCurl, requestModelPost7, "https"),
          expectedCode);
    });
    test('POST8', () {
      const expectedCode = r"""
use curl::easy::Easy;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
  easy.url("https://api.apidash.dev/io/form?size=2&len=3").unwrap();
  easy.post(true).unwrap();

  let mut form = curl::easy::Form::new();
  
  form.part("text")
    .contents(b"API")
    .add().unwrap();
  
  form.part("sep")
    .contents(b"|")
    .add().unwrap();
  
  form.part("times")
    .contents(b"3")
    .add().unwrap();
  
  easy.httppost(form).unwrap();
    {
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
      expect(
          codeGen.getCode(CodegenLanguage.rustCurl, requestModelPost8, "https"),
          expectedCode);
    });
    test('POST9', () {
      const expectedCode = r"""
use curl::easy::Easy;
use curl::easy::List;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
  easy.url("https://api.apidash.dev/io/img?size=2&len=3").unwrap();
  easy.post(true).unwrap();

  let mut form = curl::easy::Form::new();
  
  form.part("token")
    .contents(b"xyz")
    .add().unwrap();
  
  form.part("imfile")
    .file("/Documents/up/1.png")
    .add().unwrap();
  
  easy.httppost(form).unwrap();
    let mut list = List::new();
  list.append("User-Agent: Test Agent").unwrap();
  list.append("Keep-Alive: true").unwrap();
  easy.http_headers(list).unwrap();
  
  {
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
      expect(
          codeGen.getCode(CodegenLanguage.rustCurl, requestModelPost9, "https"),
          expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT1', () {
      const expectedCode = r"""
use curl::easy::Easy;
use serde_json::json;
use curl::easy::List;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
  easy.url("https://reqres.in/api/users/2").unwrap();
  easy.put(true).unwrap();

  easy.post_fields_copy(json!({
"name": "morpheus",
"job": "zion resident"
}).to_string().as_bytes()).unwrap();

  let mut list = List::new();
  list.append("Content-Type: application/json").unwrap();
  easy.http_headers(list).unwrap();
  
  {
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
      expect(
          codeGen.getCode(CodegenLanguage.rustCurl, requestModelPut1, "https"),
          expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH1', () {
      const expectedCode = r"""
use curl::easy::Easy;
use serde_json::json;
use curl::easy::List;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
  easy.url("https://reqres.in/api/users/2").unwrap();
  easy.custom_request("PATCH").unwrap();

  easy.post_fields_copy(json!({
"name": "marfeus",
"job": "accountant"
}).to_string().as_bytes()).unwrap();

  let mut list = List::new();
  list.append("Content-Type: application/json").unwrap();
  easy.http_headers(list).unwrap();
  
  {
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
      expect(
          codeGen.getCode(
              CodegenLanguage.rustCurl, requestModelPatch1, "https"),
          expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE1', () {
      const expectedCode = r"""
use curl::easy::Easy;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
  easy.url("https://reqres.in/api/users/2").unwrap();
  easy.custom_request("DELETE").unwrap();

  {
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
      expect(
          codeGen.getCode(
              CodegenLanguage.rustCurl, requestModelDelete1, "https"),
          expectedCode);
    });
    test('DELETE2', () {
      const expectedCode = r"""
use curl::easy::Easy;
use serde_json::json;
use curl::easy::List;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
  easy.url("https://reqres.in/api/users/2").unwrap();
  easy.custom_request("DELETE").unwrap();

  easy.post_fields_copy(json!({
"name": "marfeus",
"job": "accountant"
}).to_string().as_bytes()).unwrap();

  let mut list = List::new();
  list.append("Content-Type: application/json").unwrap();
  easy.http_headers(list).unwrap();
  
  {
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
      expect(
          codeGen.getCode(
              CodegenLanguage.rustCurl, requestModelDelete2, "https"),
          expectedCode);
    });
  });
}
