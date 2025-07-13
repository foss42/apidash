import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';
import '../models/request_models.dart';

void main() {
  final codeGen = Codegen();
  group('GET Request', () {
    test('GET1', () {
      const expectedCode = r"""use hyper::{Body, Client, Request};
use hyper_tls::HttpsConnector;
use tokio;
use url::Url;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let https = HttpsConnector::new();
    let client = Client::builder().build::<_, hyper::Body>(https);
    let mut url = Url::parse("https://api.apidash.dev")?;
        let req_builder = Request::builder()
        .method("GET").uri(url.as_str())
        .body(Body::empty())?;

    let res = client.request(req_builder).await?;
    let status = res.status();
    let body_bytes = hyper::body::to_bytes(res).await?;
    let body = String::from_utf8(body_bytes.to_vec())?;

    println!("Response Status: {}", status);
    println!("Response: {:?}", body);

    Ok(())
}

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustHyper,
            requestModelGet1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('GET2', () {
      const expectedCode = r"""use hyper::{Body, Client, Request};
use hyper_tls::HttpsConnector;
use tokio;
use url::Url;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let https = HttpsConnector::new();
    let client = Client::builder().build::<_, hyper::Body>(https);
    let mut url = Url::parse("https://api.apidash.dev/country/data")?;
        
    url.query_pairs_mut().append_pair("code", "US");
        let req_builder = Request::builder()
        .method("GET").uri(url.as_str())
        .body(Body::empty())?;

    let res = client.request(req_builder).await?;
    let status = res.status();
    let body_bytes = hyper::body::to_bytes(res).await?;
    let body = String::from_utf8(body_bytes.to_vec())?;

    println!("Response Status: {}", status);
    println!("Response: {:?}", body);

    Ok(())
}

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustHyper,
            requestModelGet2,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET3', () {
      const expectedCode = r"""use hyper::{Body, Client, Request};
use hyper_tls::HttpsConnector;
use tokio;
use url::Url;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let https = HttpsConnector::new();
    let client = Client::builder().build::<_, hyper::Body>(https);
    let mut url = Url::parse("https://api.apidash.dev/country/data")?;
        
    url.query_pairs_mut().append_pair("code", "IND");
    url.query_pairs_mut().append_pair("code", "US");
        let req_builder = Request::builder()
        .method("GET").uri(url.as_str())
        .body(Body::empty())?;

    let res = client.request(req_builder).await?;
    let status = res.status();
    let body_bytes = hyper::body::to_bytes(res).await?;
    let body = String::from_utf8(body_bytes.to_vec())?;

    println!("Response Status: {}", status);
    println!("Response: {:?}", body);

    Ok(())
}

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustHyper,
            requestModelGet3,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET4', () {
      const expectedCode = r"""use hyper::{Body, Client, Request};
use hyper_tls::HttpsConnector;
use tokio;
use url::Url;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let https = HttpsConnector::new();
    let client = Client::builder().build::<_, hyper::Body>(https);
    let mut url = Url::parse("https://api.apidash.dev/humanize/social")?;
        
    url.query_pairs_mut().append_pair("num", "8700000");
    url.query_pairs_mut().append_pair("digits", "3");
    url.query_pairs_mut().append_pair("system", "SS");
    url.query_pairs_mut().append_pair("add_space", "true");
    url.query_pairs_mut().append_pair("trailing_zeros", "true");
        let req_builder = Request::builder()
        .method("GET").uri(url.as_str())
        .body(Body::empty())?;

    let res = client.request(req_builder).await?;
    let status = res.status();
    let body_bytes = hyper::body::to_bytes(res).await?;
    let body = String::from_utf8(body_bytes.to_vec())?;

    println!("Response Status: {}", status);
    println!("Response: {:?}", body);

    Ok(())
}

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustHyper,
            requestModelGet4,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET5', () {
      const expectedCode = r"""use hyper::{Body, Client, Request};
use hyper_tls::HttpsConnector;
use tokio;
use url::Url;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let https = HttpsConnector::new();
    let client = Client::builder().build::<_, hyper::Body>(https);
    let mut url = Url::parse("https://api.github.com/repos/foss42/apidash")?;
        let req_builder = Request::builder()
        .method("GET").uri(url.as_str())    
        .header("User-Agent", "Test Agent")
    
        .body(Body::empty())?;

    let res = client.request(req_builder).await?;
    let status = res.status();
    let body_bytes = hyper::body::to_bytes(res).await?;
    let body = String::from_utf8(body_bytes.to_vec())?;

    println!("Response Status: {}", status);
    println!("Response: {:?}", body);

    Ok(())
}

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustHyper,
            requestModelGet5,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET6', () {
      const expectedCode = r"""use hyper::{Body, Client, Request};
use hyper_tls::HttpsConnector;
use tokio;
use url::Url;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let https = HttpsConnector::new();
    let client = Client::builder().build::<_, hyper::Body>(https);
    let mut url = Url::parse("https://api.github.com/repos/foss42/apidash")?;
        
    url.query_pairs_mut().append_pair("raw", "true");
        let req_builder = Request::builder()
        .method("GET").uri(url.as_str())    
        .header("User-Agent", "Test Agent")
    
        .body(Body::empty())?;

    let res = client.request(req_builder).await?;
    let status = res.status();
    let body_bytes = hyper::body::to_bytes(res).await?;
    let body = String::from_utf8(body_bytes.to_vec())?;

    println!("Response Status: {}", status);
    println!("Response: {:?}", body);

    Ok(())
}

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustHyper,
            requestModelGet6,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET7', () {
      const expectedCode = r"""use hyper::{Body, Client, Request};
use hyper_tls::HttpsConnector;
use tokio;
use url::Url;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let https = HttpsConnector::new();
    let client = Client::builder().build::<_, hyper::Body>(https);
    let mut url = Url::parse("https://api.apidash.dev")?;
        let req_builder = Request::builder()
        .method("GET").uri(url.as_str())
        .body(Body::empty())?;

    let res = client.request(req_builder).await?;
    let status = res.status();
    let body_bytes = hyper::body::to_bytes(res).await?;
    let body = String::from_utf8(body_bytes.to_vec())?;

    println!("Response Status: {}", status);
    println!("Response: {:?}", body);

    Ok(())
}

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustHyper,
            requestModelGet7,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET8', () {
      const expectedCode = r"""use hyper::{Body, Client, Request};
use hyper_tls::HttpsConnector;
use tokio;
use url::Url;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let https = HttpsConnector::new();
    let client = Client::builder().build::<_, hyper::Body>(https);
    let mut url = Url::parse("https://api.github.com/repos/foss42/apidash")?;
        
    url.query_pairs_mut().append_pair("raw", "true");
        let req_builder = Request::builder()
        .method("GET").uri(url.as_str())    
        .header("User-Agent", "Test Agent")
    
        .body(Body::empty())?;

    let res = client.request(req_builder).await?;
    let status = res.status();
    let body_bytes = hyper::body::to_bytes(res).await?;
    let body = String::from_utf8(body_bytes.to_vec())?;

    println!("Response Status: {}", status);
    println!("Response: {:?}", body);

    Ok(())
}

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustHyper,
            requestModelGet8,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('GET9', () {
      const expectedCode = r"""use hyper::{Body, Client, Request};
use hyper_tls::HttpsConnector;
use tokio;
use url::Url;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let https = HttpsConnector::new();
    let client = Client::builder().build::<_, hyper::Body>(https);
    let mut url = Url::parse("https://api.apidash.dev/humanize/social")?;
        
    url.query_pairs_mut().append_pair("num", "8700000");
    url.query_pairs_mut().append_pair("add_space", "true");
        let req_builder = Request::builder()
        .method("GET").uri(url.as_str())
        .body(Body::empty())?;

    let res = client.request(req_builder).await?;
    let status = res.status();
    let body_bytes = hyper::body::to_bytes(res).await?;
    let body = String::from_utf8(body_bytes.to_vec())?;

    println!("Response Status: {}", status);
    println!("Response: {:?}", body);

    Ok(())
}

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustHyper,
            requestModelGet9,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET10', () {
      const expectedCode = r"""use hyper::{Body, Client, Request};
use hyper_tls::HttpsConnector;
use tokio;
use url::Url;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let https = HttpsConnector::new();
    let client = Client::builder().build::<_, hyper::Body>(https);
    let mut url = Url::parse("https://api.apidash.dev/humanize/social")?;
        let req_builder = Request::builder()
        .method("GET").uri(url.as_str())    
        .header("User-Agent", "Test Agent")
    
        .body(Body::empty())?;

    let res = client.request(req_builder).await?;
    let status = res.status();
    let body_bytes = hyper::body::to_bytes(res).await?;
    let body = String::from_utf8(body_bytes.to_vec())?;

    println!("Response Status: {}", status);
    println!("Response: {:?}", body);

    Ok(())
}

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustHyper,
            requestModelGet10,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET11', () {
      const expectedCode = r"""use hyper::{Body, Client, Request};
use hyper_tls::HttpsConnector;
use tokio;
use url::Url;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let https = HttpsConnector::new();
    let client = Client::builder().build::<_, hyper::Body>(https);
    let mut url = Url::parse("https://api.apidash.dev/humanize/social")?;
        
    url.query_pairs_mut().append_pair("num", "8700000");
    url.query_pairs_mut().append_pair("digits", "3");
        let req_builder = Request::builder()
        .method("GET").uri(url.as_str())    
        .header("User-Agent", "Test Agent")
    
        .body(Body::empty())?;

    let res = client.request(req_builder).await?;
    let status = res.status();
    let body_bytes = hyper::body::to_bytes(res).await?;
    let body = String::from_utf8(body_bytes.to_vec())?;

    println!("Response Status: {}", status);
    println!("Response: {:?}", body);

    Ok(())
}

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustHyper,
            requestModelGet11,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET12', () {
      const expectedCode = r"""use hyper::{Body, Client, Request};
use hyper_tls::HttpsConnector;
use tokio;
use url::Url;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let https = HttpsConnector::new();
    let client = Client::builder().build::<_, hyper::Body>(https);
    let mut url = Url::parse("https://api.apidash.dev/humanize/social")?;
        let req_builder = Request::builder()
        .method("GET").uri(url.as_str())
        .body(Body::empty())?;

    let res = client.request(req_builder).await?;
    let status = res.status();
    let body_bytes = hyper::body::to_bytes(res).await?;
    let body = String::from_utf8(body_bytes.to_vec())?;

    println!("Response Status: {}", status);
    println!("Response: {:?}", body);

    Ok(())
}

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustHyper,
            requestModelGet12,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD1', () {
      const expectedCode = """use hyper::{Body, Client, Request};
use hyper_tls::HttpsConnector;
use tokio;
use url::Url;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let https = HttpsConnector::new();
    let client = Client::builder().build::<_, hyper::Body>(https);
    let mut url = Url::parse("https://api.apidash.dev")?;
        let req_builder = Request::builder()
        .method("HEAD").uri(url.as_str())
        .body(Body::empty())?;

    let res = client.request(req_builder).await?;
    let status = res.status();
    let body_bytes = hyper::body::to_bytes(res).await?;
    let body = String::from_utf8(body_bytes.to_vec())?;

    println!("Response Status: {}", status);
    println!("Response: {:?}", body);

    Ok(())
}

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustHyper,
            requestModelHead1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('HEAD2', () {
      const expectedCode = """use hyper::{Body, Client, Request};
use hyper::client::HttpConnector;
use tokio;
use url::Url;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let http = HttpConnector::new();
    let client = Client::builder().build::<_, hyper::Body>(http);
    let mut url = Url::parse("http://api.apidash.dev")?;
        let req_builder = Request::builder()
        .method("HEAD").uri(url.as_str())
        .body(Body::empty())?;

    let res = client.request(req_builder).await?;
    let status = res.status();
    let body_bytes = hyper::body::to_bytes(res).await?;
    let body = String::from_utf8(body_bytes.to_vec())?;

    println!("Response Status: {}", status);
    println!("Response: {:?}", body);

    Ok(())
}

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustHyper,
            requestModelHead2,
            SupportedUriSchemes.http,
          ),
          expectedCode);
    });
  });

  group('POST Request', () {
    test('POST1', () {
      const expectedCode = r"""use hyper::{Body, Client, Request};
use hyper_tls::HttpsConnector;
use tokio;
use url::Url;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let https = HttpsConnector::new();
    let client = Client::builder().build::<_, hyper::Body>(https);
    let mut url = Url::parse("https://api.apidash.dev/case/lower")?;
        let req_builder = Request::builder()
        .method("POST").uri(url.as_str())
        .body(Body::from(r#"{
"text": "I LOVE Flutter"
}"#))?;
    let res = client.request(req_builder).await?;
    let status = res.status();
    let body_bytes = hyper::body::to_bytes(res).await?;
    let body = String::from_utf8(body_bytes.to_vec())?;

    println!("Response Status: {}", status);
    println!("Response: {:?}", body);

    Ok(())
}

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustHyper,
            requestModelPost1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST2', () {
      const expectedCode = r"""use hyper::{Body, Client, Request};
use hyper_tls::HttpsConnector;
use serde_json::json;
use tokio;
use url::Url;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let https = HttpsConnector::new();
    let client = Client::builder().build::<_, hyper::Body>(https);
    let mut url = Url::parse("https://api.apidash.dev/case/lower")?;
        let req_builder = Request::builder()
        .method("POST").uri(url.as_str())
        .body(Body::from(json!({
"text": "I LOVE Flutter",
"flag": null,
"male": true,
"female": false,
"no": 1.2,
"arr": ["null", "true", "false", null]
}).to_string()))?;
    let res = client.request(req_builder).await?;
    let status = res.status();
    let body_bytes = hyper::body::to_bytes(res).await?;
    let body = String::from_utf8(body_bytes.to_vec())?;

    println!("Response Status: {}", status);
    println!("Response: {:?}", body);

    Ok(())
}

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustHyper,
            requestModelPost2,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST3', () {
      const expectedCode = r"""use hyper::{Body, Client, Request};
use hyper_tls::HttpsConnector;
use serde_json::json;
use tokio;
use url::Url;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let https = HttpsConnector::new();
    let client = Client::builder().build::<_, hyper::Body>(https);
    let mut url = Url::parse("https://api.apidash.dev/case/lower")?;
        let req_builder = Request::builder()
        .method("POST").uri(url.as_str())    
        .header("User-Agent", "Test Agent")
    
        .body(Body::from(json!({
"text": "I LOVE Flutter"
}).to_string()))?;
    let res = client.request(req_builder).await?;
    let status = res.status();
    let body_bytes = hyper::body::to_bytes(res).await?;
    let body = String::from_utf8(body_bytes.to_vec())?;

    println!("Response Status: {}", status);
    println!("Response: {:?}", body);

    Ok(())
}

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustHyper,
            requestModelPost3,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST4', () {
      const expectedCode = r"""extern crate hyper_multipart_rfc7578 as hyper_multipart;
use hyper::{Body, Client, Request};
use hyper_tls::HttpsConnector;
use hyper_multipart::client::multipart;
use tokio;
use url::Url;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let https = HttpsConnector::new();
    let client = Client::builder().build::<_, hyper::Body>(https);
    let mut url = Url::parse("https://api.apidash.dev/io/form")?;
        let req_builder = Request::builder()
        .method("POST")
        .uri(url.as_str());
    let mut form = multipart::Form::default();
    form.add_text("text", "API");
    form.add_text("sep", "|");
    form.add_text("times", "3");

    let req = form.set_body_convert::<Body, multipart::Body>(req_builder).unwrap();
    let res = client.request(req).await?;
    let status = res.status();
    let body_bytes = hyper::body::to_bytes(res).await?;
    let body = String::from_utf8(body_bytes.to_vec())?;

    println!("Response Status: {}", status);
    println!("Response: {:?}", body);


    Ok(())
}

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustHyper,
            requestModelPost4,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST5', () {
      const expectedCode = r"""extern crate hyper_multipart_rfc7578 as hyper_multipart;
use hyper::{Body, Client, Request};
use hyper_tls::HttpsConnector;
use hyper_multipart::client::multipart;
use tokio;
use url::Url;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let https = HttpsConnector::new();
    let client = Client::builder().build::<_, hyper::Body>(https);
    let mut url = Url::parse("https://api.apidash.dev/io/form")?;
        let req_builder = Request::builder()
        .method("POST").uri(url.as_str())    
        .header("User-Agent", "Test Agent");
    
    let mut form = multipart::Form::default();
    form.add_text("text", "API");
    form.add_text("sep", "|");
    form.add_text("times", "3");

    let req = form.set_body_convert::<Body, multipart::Body>(req_builder).unwrap();
    let res = client.request(req).await?;
    let status = res.status();
    let body_bytes = hyper::body::to_bytes(res).await?;
    let body = String::from_utf8(body_bytes.to_vec())?;

    println!("Response Status: {}", status);
    println!("Response: {:?}", body);


    Ok(())
}

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustHyper,
            requestModelPost5,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST6', () {
      const expectedCode = r"""extern crate hyper_multipart_rfc7578 as hyper_multipart;
use hyper::{Body, Client, Request};
use hyper_tls::HttpsConnector;
use hyper_multipart::client::multipart;
use tokio;
use url::Url;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let https = HttpsConnector::new();
    let client = Client::builder().build::<_, hyper::Body>(https);
    let mut url = Url::parse("https://api.apidash.dev/io/img")?;
        let req_builder = Request::builder()
        .method("POST")
        .uri(url.as_str());
    let mut form = multipart::Form::default();
    form.add_text("token", "xyz");
    form.add_file("imfile", r"/Documents/up/1.png").unwrap();

    let req = form.set_body_convert::<Body, multipart::Body>(req_builder).unwrap();
    let res = client.request(req).await?;
    let status = res.status();
    let body_bytes = hyper::body::to_bytes(res).await?;
    let body = String::from_utf8(body_bytes.to_vec())?;

    println!("Response Status: {}", status);
    println!("Response: {:?}", body);


    Ok(())
}

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustHyper,
            requestModelPost6,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST7', () {
      const expectedCode = r"""extern crate hyper_multipart_rfc7578 as hyper_multipart;
use hyper::{Body, Client, Request};
use hyper_tls::HttpsConnector;
use hyper_multipart::client::multipart;
use tokio;
use url::Url;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let https = HttpsConnector::new();
    let client = Client::builder().build::<_, hyper::Body>(https);
    let mut url = Url::parse("https://api.apidash.dev/io/img")?;
        let req_builder = Request::builder()
        .method("POST")
        .uri(url.as_str());
    let mut form = multipart::Form::default();
    form.add_text("token", "xyz");
    form.add_file("imfile", r"/Documents/up/1.png").unwrap();

    let req = form.set_body_convert::<Body, multipart::Body>(req_builder).unwrap();
    let res = client.request(req).await?;
    let status = res.status();
    let body_bytes = hyper::body::to_bytes(res).await?;
    let body = String::from_utf8(body_bytes.to_vec())?;

    println!("Response Status: {}", status);
    println!("Response: {:?}", body);


    Ok(())
}

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustHyper,
            requestModelPost7,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST8', () {
      const expectedCode = r"""extern crate hyper_multipart_rfc7578 as hyper_multipart;
use hyper::{Body, Client, Request};
use hyper_tls::HttpsConnector;
use hyper_multipart::client::multipart;
use tokio;
use url::Url;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let https = HttpsConnector::new();
    let client = Client::builder().build::<_, hyper::Body>(https);
    let mut url = Url::parse("https://api.apidash.dev/io/form")?;
        
    url.query_pairs_mut().append_pair("size", "2");
    url.query_pairs_mut().append_pair("len", "3");
        let req_builder = Request::builder()
        .method("POST")
        .uri(url.as_str());
    let mut form = multipart::Form::default();
    form.add_text("text", "API");
    form.add_text("sep", "|");
    form.add_text("times", "3");

    let req = form.set_body_convert::<Body, multipart::Body>(req_builder).unwrap();
    let res = client.request(req).await?;
    let status = res.status();
    let body_bytes = hyper::body::to_bytes(res).await?;
    let body = String::from_utf8(body_bytes.to_vec())?;

    println!("Response Status: {}", status);
    println!("Response: {:?}", body);


    Ok(())
}

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustHyper,
            requestModelPost8,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST9', () {
      const expectedCode = r"""extern crate hyper_multipart_rfc7578 as hyper_multipart;
use hyper::{Body, Client, Request};
use hyper_tls::HttpsConnector;
use hyper_multipart::client::multipart;
use tokio;
use url::Url;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let https = HttpsConnector::new();
    let client = Client::builder().build::<_, hyper::Body>(https);
    let mut url = Url::parse("https://api.apidash.dev/io/img")?;
        
    url.query_pairs_mut().append_pair("size", "2");
    url.query_pairs_mut().append_pair("len", "3");
        let req_builder = Request::builder()
        .method("POST").uri(url.as_str())    
        .header("User-Agent", "Test Agent")
    
        .header("Keep-Alive", "true");
    
    let mut form = multipart::Form::default();
    form.add_text("token", "xyz");
    form.add_file("imfile", r"/Documents/up/1.png").unwrap();

    let req = form.set_body_convert::<Body, multipart::Body>(req_builder).unwrap();
    let res = client.request(req).await?;
    let status = res.status();
    let body_bytes = hyper::body::to_bytes(res).await?;
    let body = String::from_utf8(body_bytes.to_vec())?;

    println!("Response Status: {}", status);
    println!("Response: {:?}", body);


    Ok(())
}

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustHyper,
            requestModelPost9,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT1', () {
      const expectedCode = """use hyper::{Body, Client, Request};
use hyper_tls::HttpsConnector;
use serde_json::json;
use tokio;
use url::Url;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let https = HttpsConnector::new();
    let client = Client::builder().build::<_, hyper::Body>(https);
    let mut url = Url::parse("https://reqres.in/api/users/2")?;
        let req_builder = Request::builder()
        .method("PUT").uri(url.as_str())    
        .header("x-api-key", "reqres-free-v1")
    
        .body(Body::from(json!({
"name": "morpheus",
"job": "zion resident"
}).to_string()))?;
    let res = client.request(req_builder).await?;
    let status = res.status();
    let body_bytes = hyper::body::to_bytes(res).await?;
    let body = String::from_utf8(body_bytes.to_vec())?;

    println!("Response Status: {}", status);
    println!("Response: {:?}", body);

    Ok(())
}

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustHyper,
            requestModelPut1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH1', () {
      const expectedCode = """use hyper::{Body, Client, Request};
use hyper_tls::HttpsConnector;
use serde_json::json;
use tokio;
use url::Url;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let https = HttpsConnector::new();
    let client = Client::builder().build::<_, hyper::Body>(https);
    let mut url = Url::parse("https://reqres.in/api/users/2")?;
        let req_builder = Request::builder()
        .method("PATCH").uri(url.as_str())    
        .header("x-api-key", "reqres-free-v1")
    
        .body(Body::from(json!({
"name": "marfeus",
"job": "accountant"
}).to_string()))?;
    let res = client.request(req_builder).await?;
    let status = res.status();
    let body_bytes = hyper::body::to_bytes(res).await?;
    let body = String::from_utf8(body_bytes.to_vec())?;

    println!("Response Status: {}", status);
    println!("Response: {:?}", body);

    Ok(())
}

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustHyper,
            requestModelPatch1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE1', () {
      const expectedCode = r"""use hyper::{Body, Client, Request};
use hyper_tls::HttpsConnector;
use tokio;
use url::Url;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let https = HttpsConnector::new();
    let client = Client::builder().build::<_, hyper::Body>(https);
    let mut url = Url::parse("https://reqres.in/api/users/2")?;
        let req_builder = Request::builder()
        .method("DELETE").uri(url.as_str())    
        .header("x-api-key", "reqres-free-v1")
    
        .body(Body::empty())?;

    let res = client.request(req_builder).await?;
    let status = res.status();
    let body_bytes = hyper::body::to_bytes(res).await?;
    let body = String::from_utf8(body_bytes.to_vec())?;

    println!("Response Status: {}", status);
    println!("Response: {:?}", body);

    Ok(())
}

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustHyper,
            requestModelDelete1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('DELETE2', () {
      const expectedCode = r"""use hyper::{Body, Client, Request};
use hyper_tls::HttpsConnector;
use serde_json::json;
use tokio;
use url::Url;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let https = HttpsConnector::new();
    let client = Client::builder().build::<_, hyper::Body>(https);
    let mut url = Url::parse("https://reqres.in/api/users/2")?;
        let req_builder = Request::builder()
        .method("DELETE").uri(url.as_str())    
        .header("x-api-key", "reqres-free-v1")
    
        .body(Body::from(json!({
"name": "marfeus",
"job": "accountant"
}).to_string()))?;
    let res = client.request(req_builder).await?;
    let status = res.status();
    let body_bytes = hyper::body::to_bytes(res).await?;
    let body = String::from_utf8(body_bytes.to_vec())?;

    println!("Response Status: {}", status);
    println!("Response: {:?}", body);

    Ok(())
}

""";
      expect(
          codeGen.getCode(
            CodegenLanguage.rustHyper,
            requestModelDelete2,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });
}
