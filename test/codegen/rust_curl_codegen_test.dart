import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';
import '../models/request_models.dart';

void main() {
  final codeGen = Codegen();

  group('GET Request', () {
    test('GET1', () {
      const expectedCode = r"""use curl::easy::Easy;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
   let base_url = "https://api.apidash.dev"; 
  
  let url = base_url.to_string();
  
 
  easy.get(true).unwrap();

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
      expect(
          codeGen.getCode(
            CodegenLanguage.rustCurl,
            requestModelGet1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('GET2', () {
      const expectedCode = r"""use curl::easy::Easy;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
   let base_url = "https://api.apidash.dev/country/data"; 
  
  let params: Vec<(&str, Vec<&str>)> = vec![
    ("code", vec!["US", ]),
  ];
  let query_string: String = params.iter().flat_map(|(key, values)| values.iter().map(move |val| format!("{}={}", key, val)))      .collect::<Vec<_>>().join("&");
  let url = format!("{}?{}", base_url, query_string);
  
 
  easy.get(true).unwrap();

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
      expect(
          codeGen.getCode(
            CodegenLanguage.rustCurl,
            requestModelGet2,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('GET3', () {
      const expectedCode = r"""use curl::easy::Easy;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
   let base_url = "https://api.apidash.dev/country/data"; 
  
  let params: Vec<(&str, Vec<&str>)> = vec![
    ("code", vec!["IND", "US", ]),
  ];
  let query_string: String = params.iter().flat_map(|(key, values)| values.iter().map(move |val| format!("{}={}", key, val)))      .collect::<Vec<_>>().join("&");
  let url = format!("{}?{}", base_url, query_string);
  
 
  easy.get(true).unwrap();

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
      expect(
          codeGen.getCode(
            CodegenLanguage.rustCurl,
            requestModelGet3,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('GET4', () {
      const expectedCode = r"""use curl::easy::Easy;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
   let base_url = "https://api.apidash.dev/humanize/social"; 
  
  let params: Vec<(&str, Vec<&str>)> = vec![
    ("num", vec!["8700000", ]),
    ("digits", vec!["3", ]),
    ("system", vec!["SS", ]),
    ("add_space", vec!["true", ]),
    ("trailing_zeros", vec!["true", ]),
  ];
  let query_string: String = params.iter().flat_map(|(key, values)| values.iter().map(move |val| format!("{}={}", key, val)))      .collect::<Vec<_>>().join("&");
  let url = format!("{}?{}", base_url, query_string);
  
 
  easy.get(true).unwrap();

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
      expect(
          codeGen.getCode(
            CodegenLanguage.rustCurl,
            requestModelGet4,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('GET5', () {
      const expectedCode = r"""use curl::easy::Easy;
use curl::easy::List;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
   let base_url = "https://api.github.com/repos/foss42/apidash"; 
  
  let url = base_url.to_string();
  
 
  easy.get(true).unwrap();

  let mut list = List::new();
  list.append("User-Agent: Test Agent").unwrap();
  easy.http_headers(list).unwrap();
  
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
      expect(
          codeGen.getCode(
            CodegenLanguage.rustCurl,
            requestModelGet5,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('GET6', () {
      const expectedCode = r"""use curl::easy::Easy;
use curl::easy::List;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
   let base_url = "https://api.github.com/repos/foss42/apidash"; 
  
  let params: Vec<(&str, Vec<&str>)> = vec![
    ("raw", vec!["true", ]),
  ];
  let query_string: String = params.iter().flat_map(|(key, values)| values.iter().map(move |val| format!("{}={}", key, val)))      .collect::<Vec<_>>().join("&");
  let url = format!("{}?{}", base_url, query_string);
  
 
  easy.get(true).unwrap();

  let mut list = List::new();
  list.append("User-Agent: Test Agent").unwrap();
  easy.http_headers(list).unwrap();
  
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
      expect(
          codeGen.getCode(
            CodegenLanguage.rustCurl,
            requestModelGet6,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('GET7', () {
      const expectedCode = r"""use curl::easy::Easy;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
   let base_url = "https://api.apidash.dev"; 
  
  let url = base_url.to_string();
  
 
  easy.get(true).unwrap();

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
      expect(
          codeGen.getCode(
            CodegenLanguage.rustCurl,
            requestModelGet7,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('GET8', () {
      const expectedCode = r"""use curl::easy::Easy;
use curl::easy::List;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
   let base_url = "https://api.github.com/repos/foss42/apidash"; 
  
  let params: Vec<(&str, Vec<&str>)> = vec![
    ("raw", vec!["true", ]),
  ];
  let query_string: String = params.iter().flat_map(|(key, values)| values.iter().map(move |val| format!("{}={}", key, val)))      .collect::<Vec<_>>().join("&");
  let url = format!("{}?{}", base_url, query_string);
  
 
  easy.get(true).unwrap();

  let mut list = List::new();
  list.append("User-Agent: Test Agent").unwrap();
  easy.http_headers(list).unwrap();
  
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
      expect(
          codeGen.getCode(
            CodegenLanguage.rustCurl,
            requestModelGet8,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('GET9', () {
      const expectedCode = r"""use curl::easy::Easy;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
   let base_url = "https://api.apidash.dev/humanize/social"; 
  
  let params: Vec<(&str, Vec<&str>)> = vec![
    ("num", vec!["8700000", ]),
    ("add_space", vec!["true", ]),
  ];
  let query_string: String = params.iter().flat_map(|(key, values)| values.iter().map(move |val| format!("{}={}", key, val)))      .collect::<Vec<_>>().join("&");
  let url = format!("{}?{}", base_url, query_string);
  
 
  easy.get(true).unwrap();

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
      expect(
          codeGen.getCode(
            CodegenLanguage.rustCurl,
            requestModelGet9,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('GET10', () {
      const expectedCode = r"""use curl::easy::Easy;
use curl::easy::List;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
   let base_url = "https://api.apidash.dev/humanize/social"; 
  
  let url = base_url.to_string();
  
 
  easy.get(true).unwrap();

  let mut list = List::new();
  list.append("User-Agent: Test Agent").unwrap();
  easy.http_headers(list).unwrap();
  
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
      expect(
          codeGen.getCode(
            CodegenLanguage.rustCurl,
            requestModelGet10,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('GET11', () {
      const expectedCode = r"""use curl::easy::Easy;
use curl::easy::List;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
   let base_url = "https://api.apidash.dev/humanize/social"; 
  
  let params: Vec<(&str, Vec<&str>)> = vec![
    ("num", vec!["8700000", ]),
    ("digits", vec!["3", ]),
  ];
  let query_string: String = params.iter().flat_map(|(key, values)| values.iter().map(move |val| format!("{}={}", key, val)))      .collect::<Vec<_>>().join("&");
  let url = format!("{}?{}", base_url, query_string);
  
 
  easy.get(true).unwrap();

  let mut list = List::new();
  list.append("User-Agent: Test Agent").unwrap();
  easy.http_headers(list).unwrap();
  
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
      expect(
          codeGen.getCode(
            CodegenLanguage.rustCurl,
            requestModelGet11,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('GET12', () {
      const expectedCode = r"""use curl::easy::Easy;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
   let base_url = "https://api.apidash.dev/humanize/social"; 
  
  let url = base_url.to_string();
  
 
  easy.get(true).unwrap();

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
      expect(
          codeGen.getCode(
            CodegenLanguage.rustCurl,
            requestModelGet12,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD1', () {
      const expectedCode = r"""use curl::easy::Easy;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
   let base_url = "https://api.apidash.dev"; 
  
  let url = base_url.to_string();
  
 
  easy.nobody(true).unwrap();

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
      expect(
          codeGen.getCode(
            CodegenLanguage.rustCurl,
            requestModelHead1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('HEAD2', () {
      const expectedCode = r"""use curl::easy::Easy;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
   let base_url = "https://api.apidash.dev"; 
  
  let url = base_url.to_string();
  
 
  easy.nobody(true).unwrap();

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
      expect(
          codeGen.getCode(
            CodegenLanguage.rustCurl,
            requestModelHead2,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('POST Request', () {
    test('POST1', () {
      const expectedCode = r"""use curl::easy::Easy;
use curl::easy::List;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
   let base_url = "https://api.apidash.dev/case/lower"; 
  
  let url = base_url.to_string();
  
 
  easy.post(true).unwrap();

  easy.post_fields_copy(r#"{
"text": "I LOVE Flutter"
}"#.as_bytes()).unwrap();

  let mut list = List::new();
  list.append("Content-Type: text/plain").unwrap();
  easy.http_headers(list).unwrap();
  
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
      expect(
          codeGen.getCode(
            CodegenLanguage.rustCurl,
            requestModelPost1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST2', () {
      const expectedCode = r"""use curl::easy::Easy;
use serde_json::json;
use curl::easy::List;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
   let base_url = "https://api.apidash.dev/case/lower"; 
  
  let url = base_url.to_string();
  
 
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
      expect(
          codeGen.getCode(
            CodegenLanguage.rustCurl,
            requestModelPost2,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST3', () {
      const expectedCode = r"""use curl::easy::Easy;
use serde_json::json;
use curl::easy::List;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
   let base_url = "https://api.apidash.dev/case/lower"; 
  
  let url = base_url.to_string();
  
 
  easy.post(true).unwrap();

  easy.post_fields_copy(json!({
"text": "I LOVE Flutter"
}).to_string().as_bytes()).unwrap();

  let mut list = List::new();
  list.append("User-Agent: Test Agent").unwrap();
  list.append("Content-Type: application/json").unwrap();
  easy.http_headers(list).unwrap();
  
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
      expect(
          codeGen.getCode(
            CodegenLanguage.rustCurl,
            requestModelPost3,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST4', () {
      const expectedCode = r"""use curl::easy::Easy;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
   let base_url = "https://api.apidash.dev/io/form"; 
  
  let url = base_url.to_string();
  
 
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
  
  easy.httppost(form).unwrap();  {
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
      expect(
          codeGen.getCode(
            CodegenLanguage.rustCurl,
            requestModelPost4,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST5', () {
      const expectedCode = r"""use curl::easy::Easy;
use curl::easy::List;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
   let base_url = "https://api.apidash.dev/io/form"; 
  
  let url = base_url.to_string();
  
 
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
  
  easy.httppost(form).unwrap();  let mut list = List::new();
  list.append("User-Agent: Test Agent").unwrap();
  easy.http_headers(list).unwrap();
  
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
      expect(
          codeGen.getCode(
            CodegenLanguage.rustCurl,
            requestModelPost5,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST6', () {
      const expectedCode = r"""use curl::easy::Easy;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
   let base_url = "https://api.apidash.dev/io/img"; 
  
  let url = base_url.to_string();
  
 
  easy.post(true).unwrap();

  let mut form = curl::easy::Form::new();
  
  form.part("token")
    .contents(b"xyz")
    .add().unwrap();
  
  form.part("imfile")
    .file("/Documents/up/1.png")
    .add().unwrap();
  
  easy.httppost(form).unwrap();  {
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
      expect(
          codeGen.getCode(
            CodegenLanguage.rustCurl,
            requestModelPost6,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST7', () {
      const expectedCode = r"""use curl::easy::Easy;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
   let base_url = "https://api.apidash.dev/io/img"; 
  
  let url = base_url.to_string();
  
 
  easy.post(true).unwrap();

  let mut form = curl::easy::Form::new();
  
  form.part("token")
    .contents(b"xyz")
    .add().unwrap();
  
  form.part("imfile")
    .file("/Documents/up/1.png")
    .add().unwrap();
  
  easy.httppost(form).unwrap();  {
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
      expect(
          codeGen.getCode(
            CodegenLanguage.rustCurl,
            requestModelPost7,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST8', () {
      const expectedCode = r"""use curl::easy::Easy;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
   let base_url = "https://api.apidash.dev/io/form"; 
  
  let params: Vec<(&str, Vec<&str>)> = vec![
    ("size", vec!["2", ]),
    ("len", vec!["3", ]),
  ];
  let query_string: String = params.iter().flat_map(|(key, values)| values.iter().map(move |val| format!("{}={}", key, val)))      .collect::<Vec<_>>().join("&");
  let url = format!("{}?{}", base_url, query_string);
  
 
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
  
  easy.httppost(form).unwrap();  {
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
      expect(
          codeGen.getCode(
            CodegenLanguage.rustCurl,
            requestModelPost8,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST9', () {
      const expectedCode = r"""use curl::easy::Easy;
use curl::easy::List;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
   let base_url = "https://api.apidash.dev/io/img"; 
  
  let params: Vec<(&str, Vec<&str>)> = vec![
    ("size", vec!["2", ]),
    ("len", vec!["3", ]),
  ];
  let query_string: String = params.iter().flat_map(|(key, values)| values.iter().map(move |val| format!("{}={}", key, val)))      .collect::<Vec<_>>().join("&");
  let url = format!("{}?{}", base_url, query_string);
  
 
  easy.post(true).unwrap();

  let mut form = curl::easy::Form::new();
  
  form.part("token")
    .contents(b"xyz")
    .add().unwrap();
  
  form.part("imfile")
    .file("/Documents/up/1.png")
    .add().unwrap();
  
  easy.httppost(form).unwrap();  let mut list = List::new();
  list.append("User-Agent: Test Agent").unwrap();
  list.append("Keep-Alive: true").unwrap();
  easy.http_headers(list).unwrap();
  
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
      expect(
          codeGen.getCode(
            CodegenLanguage.rustCurl,
            requestModelPost9,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT1', () {
      const expectedCode = r"""use curl::easy::Easy;
use serde_json::json;
use curl::easy::List;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
   let base_url = "https://reqres.in/api/users/2"; 
  
  let url = base_url.to_string();
  
 
  easy.put(true).unwrap();

  easy.post_fields_copy(json!({
"name": "morpheus",
"job": "zion resident"
}).to_string().as_bytes()).unwrap();

  let mut list = List::new();
  list.append("x-api-key: reqres-free-v1").unwrap();
  list.append("Content-Type: application/json").unwrap();
  easy.http_headers(list).unwrap();
  
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
      expect(
          codeGen.getCode(
            CodegenLanguage.rustCurl,
            requestModelPut1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH1', () {
      const expectedCode = r"""use curl::easy::Easy;
use serde_json::json;
use curl::easy::List;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
   let base_url = "https://reqres.in/api/users/2"; 
  
  let url = base_url.to_string();
  
 
  easy.custom_request("PATCH").unwrap();

  easy.post_fields_copy(json!({
"name": "marfeus",
"job": "accountant"
}).to_string().as_bytes()).unwrap();

  let mut list = List::new();
  list.append("x-api-key: reqres-free-v1").unwrap();
  list.append("Content-Type: application/json").unwrap();
  easy.http_headers(list).unwrap();
  
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
      expect(
          codeGen.getCode(
            CodegenLanguage.rustCurl,
            requestModelPatch1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE1', () {
      const expectedCode = r"""use curl::easy::Easy;
use curl::easy::List;

fn main() {
  let mut easy = Easy::new();
  let mut data = Vec::new();
   let base_url = "https://reqres.in/api/users/2"; 
  
  let url = base_url.to_string();
  
 
  easy.custom_request("DELETE").unwrap();

  let mut list = List::new();
  list.append("x-api-key: reqres-free-v1").unwrap();
  easy.http_headers(list).unwrap();
  
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
      expect(
          codeGen.getCode(
            CodegenLanguage.rustCurl,
            requestModelDelete1,
            SupportedUriSchemes.https,
          ),
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
   let base_url = "https://reqres.in/api/users/2"; 
  
  let url = base_url.to_string();
  
 
  easy.custom_request("DELETE").unwrap();

  easy.post_fields_copy(json!({
"name": "marfeus",
"job": "accountant"
}).to_string().as_bytes()).unwrap();

  let mut list = List::new();
  list.append("x-api-key: reqres-free-v1").unwrap();
  list.append("Content-Type: application/json").unwrap();
  easy.http_headers(list).unwrap();
  
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
      expect(
          codeGen.getCode(
            CodegenLanguage.rustCurl,
            requestModelDelete2,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });
}
