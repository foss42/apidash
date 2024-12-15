import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';

import '../models/request_models.dart';

// TODO: Fix tests for URLSession
void main() {
  final codeGen = Codegen();

  group(
    'HTTPVerb.get',
    () {
      test('GET 1', () {
        const expectedCode = r"""
import Foundation

var request = URLRequest(url: URL(string: "https://api.apidash.dev")!,timeoutInterval: Double.infinity)
request.httpMethod = "GET"
let task = URLSession.shared.dataTask(with: request) { data, response, error in 
  guard let data = data else {
    print(String(describing: error))
    return
  }
  print(String(data: data, encoding: .utf8)!)
}
task.resume()
""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftUrlSession,
              requestModelGet1,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });

      test('GET 2', () {
        const expectedCode = r"""
import Foundation

var request = URLRequest(url: URL(string: "https://api.apidash.dev/country/data?code=US")!,timeoutInterval: Double.infinity)
request.httpMethod = "GET"
let task = URLSession.shared.dataTask(with: request) { data, response, error in 
  guard let data = data else {
    print(String(describing: error))
    return
  }
  print(String(data: data, encoding: .utf8)!)
}
task.resume()
""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftUrlSession,
              requestModelGet2,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });

      test('GET 3', () {
        const expectedCode = r"""
import Foundation

var request = URLRequest(url: URL(string: "https://api.apidash.dev/country/data?code=IND")!,timeoutInterval: Double.infinity)
request.httpMethod = "GET"
let task = URLSession.shared.dataTask(with: request) { data, response, error in 
  guard let data = data else {
    print(String(describing: error))
    return
  }
  print(String(data: data, encoding: .utf8)!)
}
task.resume()
""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftUrlSession,
              requestModelGet3,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });

      test('GET 4', () {
        const expectedCode = r"""
import Foundation

var request = URLRequest(url: URL(string: "https://api.apidash.dev/humanize/social?num=8700000&digits=3&system=SS&add_space=true&trailing_zeros=true")!,timeoutInterval: Double.infinity)
request.httpMethod = "GET"
let task = URLSession.shared.dataTask(with: request) { data, response, error in 
  guard let data = data else {
    print(String(describing: error))
    return
  }
  print(String(data: data, encoding: .utf8)!)
}
task.resume()
""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftUrlSession,
              requestModelGet4,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });

      test('GET 5', () {
        const expectedCode = r"""
import Foundation

var request = URLRequest(url: URL(string: "https://api.github.com/repos/foss42/apidash")!,timeoutInterval: Double.infinity)
request.httpMethod = "GET"

request.addValue("Test Agent", forHTTPHeaderField: "User-Agent")

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
  guard let data = data else {
    print(String(describing: error))
    return
  }
  print(String(data: data, encoding: .utf8)!)
}
task.resume()
""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftUrlSession,
              requestModelGet5,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });

      test('GET 6', () {
        const expectedCode = r"""
import Foundation

var request = URLRequest(url: URL(string: "https://api.github.com/repos/foss42/apidash?raw=true")!,timeoutInterval: Double.infinity)
request.httpMethod = "GET"

request.addValue("Test Agent", forHTTPHeaderField: "User-Agent")

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
  guard let data = data else {
    print(String(describing: error))
    return
  }
  print(String(data: data, encoding: .utf8)!)
}
task.resume()
""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftUrlSession,
              requestModelGet6,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });

      test('GET 7', () {
        const expectedCode = r"""
import Foundation

var request = URLRequest(url: URL(string: "https://api.apidash.dev")!,timeoutInterval: Double.infinity)
request.httpMethod = "GET"
let task = URLSession.shared.dataTask(with: request) { data, response, error in 
  guard let data = data else {
    print(String(describing: error))
    return
  }
  print(String(data: data, encoding: .utf8)!)
}
task.resume()
""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftUrlSession,
              requestModelGet7,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });

      test('GET 8', () {
        const expectedCode = r"""import Foundation

var request = URLRequest(url: URL(string: "https://api.github.com/repos/foss42/apidash?raw=true")!,timeoutInterval: Double.infinity)
request.httpMethod = "GET"

request.addValue("Test Agent", forHTTPHeaderField: "User-Agent")

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
  guard let data = data else {
    print(String(describing: error))
    return
  }
  print(String(data: data, encoding: .utf8)!)
}
task.resume()
""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftUrlSession,
              requestModelGet8,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });

      test('GET 9', () {
        const expectedCode = r"""
import Foundation

var request = URLRequest(url: URL(string: "https://api.apidash.dev/humanize/social?num=8700000&add_space=true")!,timeoutInterval: Double.infinity)
request.httpMethod = "GET"
let task = URLSession.shared.dataTask(with: request) { data, response, error in 
  guard let data = data else {
    print(String(describing: error))
    return
  }
  print(String(data: data, encoding: .utf8)!)
}
task.resume()
""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftUrlSession,
              requestModelGet9,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });

      test('GET 10', () {
        const expectedCode = r"""
import Foundation

var request = URLRequest(url: URL(string: "https://api.apidash.dev/humanize/social")!,timeoutInterval: Double.infinity)
request.httpMethod = "GET"

request.addValue("Test Agent", forHTTPHeaderField: "User-Agent")

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
  guard let data = data else {
    print(String(describing: error))
    return
  }
  print(String(data: data, encoding: .utf8)!)
}
task.resume()
""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftUrlSession,
              requestModelGet10,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });

      test('GET 11', () {
        const expectedCode = r"""
import Foundation

var request = URLRequest(url: URL(string: "https://api.apidash.dev/humanize/social?num=8700000&digits=3")!,timeoutInterval: Double.infinity)
request.httpMethod = "GET"

request.addValue("Test Agent", forHTTPHeaderField: "User-Agent")

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
  guard let data = data else {
    print(String(describing: error))
    return
  }
  print(String(data: data, encoding: .utf8)!)
}
task.resume()
""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftUrlSession,
              requestModelGet11,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });

      test('GET 12', () {
        const expectedCode = r"""
import Foundation

var request = URLRequest(url: URL(string: "https://api.apidash.dev/humanize/social")!,timeoutInterval: Double.infinity)
request.httpMethod = "GET"
let task = URLSession.shared.dataTask(with: request) { data, response, error in 
  guard let data = data else {
    print(String(describing: error))
    return
  }
  print(String(data: data, encoding: .utf8)!)
}
task.resume()
""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftUrlSession,
              requestModelGet12,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });
    },
    skip: true,
  );

  group(
    'HTTPVerb.head',
    () {
      test('HEAD 1', () {
        const expectedCode = r"""import Foundation

var request = URLRequest(url: URL(string: "https://api.apidash.dev")!,timeoutInterval: Double.infinity)
request.httpMethod = "HEAD"
let task = URLSession.shared.dataTask(with: request) { data, response, error in 
  guard let data = data else {
    print(String(describing: error))
    return
  }
  print(String(data: data, encoding: .utf8)!)
}
task.resume()
""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftUrlSession,
              requestModelHead1,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });

      test('HEAD 2', () {
        const expectedCode = r"""
import Foundation

var request = URLRequest(url: URL(string: "https://api.apidash.dev")!,timeoutInterval: Double.infinity)
request.httpMethod = "HEAD"
let task = URLSession.shared.dataTask(with: request) { data, response, error in 
  guard let data = data else {
    print(String(describing: error))
    return
  }
  print(String(data: data, encoding: .utf8)!)
}
task.resume()
""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftUrlSession,
              requestModelHead2,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });
    },
    skip: true,
  );

  group(
    "HTTPVerb.post",
    () {
      test('POST 1', () {
        const expectedCode = r"""
import Foundation

let parameters = "{\n\"text\": \"I LOVE Flutter\"\n}"
let postData = parameters.data(using: .utf8)
var request = URLRequest(url: URL(string: "https://api.apidash.dev/case/lower")!,timeoutInterval: Double.infinity)
request.httpMethod = "POST"

request.addValue("text/plain", forHTTPHeaderField: "Content-Type")

request.httpBody = postData

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
  guard let data = data else {
    print(String(describing: error))
    return
  }
  print(String(data: data, encoding: .utf8)!)
}
task.resume()
""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftUrlSession,
              requestModelPost1,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });
      test('POST 2', () {
        const expectedCode = r"""
import Foundation

let parameters = "{\n\"text\": \"I LOVE Flutter\",\n\"flag\": null,\n\"male\": true,\n\"female\": false,\n\"no\": 1.2,\n\"arr\": [\"null\", \"true\", \"false\", null]\n}"
let postData = parameters.data(using: .utf8)
var request = URLRequest(url: URL(string: "https://api.apidash.dev/case/lower")!,timeoutInterval: Double.infinity)
request.httpMethod = "POST"

request.addValue("application/json", forHTTPHeaderField: "Content-Type")

request.httpBody = postData

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
  guard let data = data else {
    print(String(describing: error))
    return
  }
  print(String(data: data, encoding: .utf8)!)
}
task.resume()
""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftUrlSession,
              requestModelPost2,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });

      test('POST 3', () {
        const expectedCode = r"""
import Foundation

let parameters = "{\n\"text\": \"I LOVE Flutter\"\n}"
let postData = parameters.data(using: .utf8)
var request = URLRequest(url: URL(string: "https://api.apidash.dev/case/lower")!,timeoutInterval: Double.infinity)
request.httpMethod = "POST"

request.addValue("Test Agent", forHTTPHeaderField: "User-Agent")

request.addValue("application/json", forHTTPHeaderField: "Content-Type")

request.httpBody = postData

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
  guard let data = data else {
    print(String(describing: error))
    return
  }
  print(String(data: data, encoding: .utf8)!)
}
task.resume()
""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftUrlSession,
              requestModelPost3,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });

      test('POST 4', () {
        const expectedCode = r"""
import Foundation

let parameters = [

  [
    "key": "text",
    "value": "API",
    "type": "text"
  ],

  [
    "key": "sep",
    "value": "|",
    "type": "text"
  ],

  [
    "key": "times",
    "value": "3",
    "type": "text"
  ],

] as [[String: Any]]
let boundary = "Boundary-\(UUID().uuidString)"
var body = Data()
var error: Error? = nil
for param in parameters {
  if param["disabled"] as? Bool == true { continue }
  let paramName = param["key"] as! String
  body.append("--\(boundary)\r\n".data(using: .utf8)!)
  body.append("Content-Disposition:form-data; name=\"\(paramName)\"".data(using: .utf8)!)
  if let contentType = param["contentType"] as? String {
    body.append("\r\nContent-Type: \(contentType)".data(using: .utf8)!)
  }
  let paramType = param["type"] as! String
  if paramType == "text" {
    let paramValue = param["value"] as! String
    body.append("\r\n\r\n\(paramValue)\r\n".data(using: .utf8)!)
  } else if paramType == "file" {
    let paramSrc = param["value"] as! String
    let fileURL = URL(fileURLWithPath: paramSrc)
    if let fileContent = try? Data(contentsOf: fileURL) {
      body.append("; filename=\"\(paramSrc)\"\r\n".data(using: .utf8)!)
      body.append("Content-Type: \"content-type header\"\r\n\r\n".data(using: .utf8)!)
      body.append(fileContent)
      body.append("\r\n".data(using: .utf8)!)
    }
  }
}
body.append("--\(boundary)--\r\n".data(using: .utf8)!)
let postData = body
var request = URLRequest(url: URL(string: "https://api.apidash.dev/io/form")!,timeoutInterval: Double.infinity)
request.httpMethod = "POST"

request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

request.httpBody = postData

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
  guard let data = data else {
    print(String(describing: error))
    return
  }
  print(String(data: data, encoding: .utf8)!)
}
task.resume()
""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftUrlSession,
              requestModelPost4,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });

      test('POST 5', () {
        const expectedCode = r"""import Foundation

let parameters = [

  [
    "key": "text",
    "value": "API",
    "type": "text"
  ],

  [
    "key": "sep",
    "value": "|",
    "type": "text"
  ],

  [
    "key": "times",
    "value": "3",
    "type": "text"
  ],

] as [[String: Any]]
let boundary = "Boundary-\(UUID().uuidString)"
var body = Data()
var error: Error? = nil
for param in parameters {
  if param["disabled"] as? Bool == true { continue }
  let paramName = param["key"] as! String
  body.append("--\(boundary)\r\n".data(using: .utf8)!)
  body.append("Content-Disposition:form-data; name=\"\(paramName)\"".data(using: .utf8)!)
  if let contentType = param["contentType"] as? String {
    body.append("\r\nContent-Type: \(contentType)".data(using: .utf8)!)
  }
  let paramType = param["type"] as! String
  if paramType == "text" {
    let paramValue = param["value"] as! String
    body.append("\r\n\r\n\(paramValue)\r\n".data(using: .utf8)!)
  } else if paramType == "file" {
    let paramSrc = param["value"] as! String
    let fileURL = URL(fileURLWithPath: paramSrc)
    if let fileContent = try? Data(contentsOf: fileURL) {
      body.append("; filename=\"\(paramSrc)\"\r\n".data(using: .utf8)!)
      body.append("Content-Type: \"content-type header\"\r\n\r\n".data(using: .utf8)!)
      body.append(fileContent)
      body.append("\r\n".data(using: .utf8)!)
    }
  }
}
body.append("--\(boundary)--\r\n".data(using: .utf8)!)
let postData = body
var request = URLRequest(url: URL(string: "https://api.apidash.dev/io/form")!,timeoutInterval: Double.infinity)
request.httpMethod = "POST"

request.addValue("Test Agent", forHTTPHeaderField: "User-Agent")

request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

request.httpBody = postData

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
  guard let data = data else {
    print(String(describing: error))
    return
  }
  print(String(data: data, encoding: .utf8)!)
}
task.resume()
""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftUrlSession,
              requestModelPost5,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });
      test('POST 6', () {
        const expectedCode = r"""
import Foundation

let parameters = [

  [
    "key": "token",
    "value": "xyz",
    "type": "text"
  ],

  [
    "key": "imfile",
    "value": "/Documents/up/1.png",
    "type": "file"
  ],

] as [[String: Any]]
let boundary = "Boundary-\(UUID().uuidString)"
var body = Data()
var error: Error? = nil
for param in parameters {
  if param["disabled"] as? Bool == true { continue }
  let paramName = param["key"] as! String
  body.append("--\(boundary)\r\n".data(using: .utf8)!)
  body.append("Content-Disposition:form-data; name=\"\(paramName)\"".data(using: .utf8)!)
  if let contentType = param["contentType"] as? String {
    body.append("\r\nContent-Type: \(contentType)".data(using: .utf8)!)
  }
  let paramType = param["type"] as! String
  if paramType == "text" {
    let paramValue = param["value"] as! String
    body.append("\r\n\r\n\(paramValue)\r\n".data(using: .utf8)!)
  } else if paramType == "file" {
    let paramSrc = param["value"] as! String
    let fileURL = URL(fileURLWithPath: paramSrc)
    if let fileContent = try? Data(contentsOf: fileURL) {
      body.append("; filename=\"\(paramSrc)\"\r\n".data(using: .utf8)!)
      body.append("Content-Type: \"content-type header\"\r\n\r\n".data(using: .utf8)!)
      body.append(fileContent)
      body.append("\r\n".data(using: .utf8)!)
    }
  }
}
body.append("--\(boundary)--\r\n".data(using: .utf8)!)
let postData = body
var request = URLRequest(url: URL(string: "https://api.apidash.dev/io/img")!,timeoutInterval: Double.infinity)
request.httpMethod = "POST"

request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

request.httpBody = postData

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
  guard let data = data else {
    print(String(describing: error))
    return
  }
  print(String(data: data, encoding: .utf8)!)
}
task.resume()
""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftUrlSession,
              requestModelPost6,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });
      test('POST 7', () {
        const expectedCode = r"""
import Foundation

let parameters = [

  [
    "key": "token",
    "value": "xyz",
    "type": "text"
  ],

  [
    "key": "imfile",
    "value": "/Documents/up/1.png",
    "type": "file"
  ],

] as [[String: Any]]
let boundary = "Boundary-\(UUID().uuidString)"
var body = Data()
var error: Error? = nil
for param in parameters {
  if param["disabled"] as? Bool == true { continue }
  let paramName = param["key"] as! String
  body.append("--\(boundary)\r\n".data(using: .utf8)!)
  body.append("Content-Disposition:form-data; name=\"\(paramName)\"".data(using: .utf8)!)
  if let contentType = param["contentType"] as? String {
    body.append("\r\nContent-Type: \(contentType)".data(using: .utf8)!)
  }
  let paramType = param["type"] as! String
  if paramType == "text" {
    let paramValue = param["value"] as! String
    body.append("\r\n\r\n\(paramValue)\r\n".data(using: .utf8)!)
  } else if paramType == "file" {
    let paramSrc = param["value"] as! String
    let fileURL = URL(fileURLWithPath: paramSrc)
    if let fileContent = try? Data(contentsOf: fileURL) {
      body.append("; filename=\"\(paramSrc)\"\r\n".data(using: .utf8)!)
      body.append("Content-Type: \"content-type header\"\r\n\r\n".data(using: .utf8)!)
      body.append(fileContent)
      body.append("\r\n".data(using: .utf8)!)
    }
  }
}
body.append("--\(boundary)--\r\n".data(using: .utf8)!)
let postData = body
var request = URLRequest(url: URL(string: "https://api.apidash.dev/io/img")!,timeoutInterval: Double.infinity)
request.httpMethod = "POST"

request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

request.httpBody = postData

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
  guard let data = data else {
    print(String(describing: error))
    return
  }
  print(String(data: data, encoding: .utf8)!)
}
task.resume()
""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftUrlSession,
              requestModelPost7,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });
      test('POST 8', () {
        const expectedCode = r"""
import Foundation

let parameters = [

  [
    "key": "text",
    "value": "API",
    "type": "text"
  ],

  [
    "key": "sep",
    "value": "|",
    "type": "text"
  ],

  [
    "key": "times",
    "value": "3",
    "type": "text"
  ],

] as [[String: Any]]
let boundary = "Boundary-\(UUID().uuidString)"
var body = Data()
var error: Error? = nil
for param in parameters {
  if param["disabled"] as? Bool == true { continue }
  let paramName = param["key"] as! String
  body.append("--\(boundary)\r\n".data(using: .utf8)!)
  body.append("Content-Disposition:form-data; name=\"\(paramName)\"".data(using: .utf8)!)
  if let contentType = param["contentType"] as? String {
    body.append("\r\nContent-Type: \(contentType)".data(using: .utf8)!)
  }
  let paramType = param["type"] as! String
  if paramType == "text" {
    let paramValue = param["value"] as! String
    body.append("\r\n\r\n\(paramValue)\r\n".data(using: .utf8)!)
  } else if paramType == "file" {
    let paramSrc = param["value"] as! String
    let fileURL = URL(fileURLWithPath: paramSrc)
    if let fileContent = try? Data(contentsOf: fileURL) {
      body.append("; filename=\"\(paramSrc)\"\r\n".data(using: .utf8)!)
      body.append("Content-Type: \"content-type header\"\r\n\r\n".data(using: .utf8)!)
      body.append(fileContent)
      body.append("\r\n".data(using: .utf8)!)
    }
  }
}
body.append("--\(boundary)--\r\n".data(using: .utf8)!)
let postData = body
var request = URLRequest(url: URL(string: "https://api.apidash.dev/io/form?size=2&len=3")!,timeoutInterval: Double.infinity)
request.httpMethod = "POST"

request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

request.httpBody = postData

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
  guard let data = data else {
    print(String(describing: error))
    return
  }
  print(String(data: data, encoding: .utf8)!)
}
task.resume()
""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftUrlSession,
              requestModelPost8,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });
      test('POST 9', () {
        const expectedCode = r"""
import Foundation

let parameters = [

  [
    "key": "token",
    "value": "xyz",
    "type": "text"
  ],

  [
    "key": "imfile",
    "value": "/Documents/up/1.png",
    "type": "file"
  ],

] as [[String: Any]]
let boundary = "Boundary-\(UUID().uuidString)"
var body = Data()
var error: Error? = nil
for param in parameters {
  if param["disabled"] as? Bool == true { continue }
  let paramName = param["key"] as! String
  body.append("--\(boundary)\r\n".data(using: .utf8)!)
  body.append("Content-Disposition:form-data; name=\"\(paramName)\"".data(using: .utf8)!)
  if let contentType = param["contentType"] as? String {
    body.append("\r\nContent-Type: \(contentType)".data(using: .utf8)!)
  }
  let paramType = param["type"] as! String
  if paramType == "text" {
    let paramValue = param["value"] as! String
    body.append("\r\n\r\n\(paramValue)\r\n".data(using: .utf8)!)
  } else if paramType == "file" {
    let paramSrc = param["value"] as! String
    let fileURL = URL(fileURLWithPath: paramSrc)
    if let fileContent = try? Data(contentsOf: fileURL) {
      body.append("; filename=\"\(paramSrc)\"\r\n".data(using: .utf8)!)
      body.append("Content-Type: \"content-type header\"\r\n\r\n".data(using: .utf8)!)
      body.append(fileContent)
      body.append("\r\n".data(using: .utf8)!)
    }
  }
}
body.append("--\(boundary)--\r\n".data(using: .utf8)!)
let postData = body
var request = URLRequest(url: URL(string: "https://api.apidash.dev/io/img?size=2&len=3")!,timeoutInterval: Double.infinity)
request.httpMethod = "POST"

request.addValue("Test Agent", forHTTPHeaderField: "User-Agent")

request.addValue("true", forHTTPHeaderField: "Keep-Alive")

request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

request.httpBody = postData

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
  guard let data = data else {
    print(String(describing: error))
    return
  }
  print(String(data: data, encoding: .utf8)!)
}
task.resume()
""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftUrlSession,
              requestModelPost9,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });
      test('POST 10', () {
        const expectedCode = r"""
import Foundation

let parameters = "{\n\"text\": \"I LOVE Flutter\"\n}"
let postData = parameters.data(using: .utf8)
var request = URLRequest(url: URL(string: "https://api.apidash.dev/case/lower?size=2&len=3")!,timeoutInterval: Double.infinity)
request.httpMethod = "POST"

request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

request.httpBody = postData

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
  guard let data = data else {
    print(String(describing: error))
    return
  }
  print(String(data: data, encoding: .utf8)!)
}
task.resume()
""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftUrlSession,
              requestModelPost10,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });
    },
    skip: true,
  );

  group(
    'HTTPVerb.put',
    () {
      test('PUT 1', () {
        const expectedCode = r"""
import Foundation

let parameters = "{\n\"name\": \"morpheus\",\n\"job\": \"zion resident\"\n}"
let postData = parameters.data(using: .utf8)
var request = URLRequest(url: URL(string: "https://reqres.in/api/users/2")!,timeoutInterval: Double.infinity)
request.httpMethod = "PUT"

request.addValue("application/json", forHTTPHeaderField: "Content-Type")

request.httpBody = postData

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
  guard let data = data else {
    print(String(describing: error))
    return
  }
  print(String(data: data, encoding: .utf8)!)
}
task.resume()
""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftUrlSession,
              requestModelPut1,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });
    },
    skip: true,
  );

  group(
    'HTTPVerb.patch',
    () {
      test('PATCH 1', () {
        const expectedCode = r"""
import Foundation

let parameters = "{\n\"name\": \"marfeus\",\n\"job\": \"accountant\"\n}"
let postData = parameters.data(using: .utf8)
var request = URLRequest(url: URL(string: "https://reqres.in/api/users/2")!,timeoutInterval: Double.infinity)
request.httpMethod = "PATCH"

request.addValue("application/json", forHTTPHeaderField: "Content-Type")

request.httpBody = postData

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
  guard let data = data else {
    print(String(describing: error))
    return
  }
  print(String(data: data, encoding: .utf8)!)
}
task.resume()
""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftUrlSession,
              requestModelPatch1,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });
    },
    skip: true,
  );

  group(
    'HTTPVerb.delete',
    () {
      test('DELETE 1', () {
        const expectedCode = r"""
import Foundation

var request = URLRequest(url: URL(string: "https://reqres.in/api/users/2")!,timeoutInterval: Double.infinity)
request.httpMethod = "DELETE"
let task = URLSession.shared.dataTask(with: request) { data, response, error in 
  guard let data = data else {
    print(String(describing: error))
    return
  }
  print(String(data: data, encoding: .utf8)!)
}
task.resume()
""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftUrlSession,
              requestModelDelete1,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });

      test('DELETE 2', () {
        const expectedCode = r"""
import Foundation

let parameters = "{\n\"name\": \"marfeus\",\n\"job\": \"accountant\"\n}"
let postData = parameters.data(using: .utf8)
var request = URLRequest(url: URL(string: "https://reqres.in/api/users/2")!,timeoutInterval: Double.infinity)
request.httpMethod = "DELETE"

request.addValue("application/json", forHTTPHeaderField: "Content-Type")

request.httpBody = postData

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
  guard let data = data else {
    print(String(describing: error))
    return
  }
  print(String(data: data, encoding: .utf8)!)
}
task.resume()
""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftUrlSession,
              requestModelDelete2,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });
    },
    skip: true,
  );
}
