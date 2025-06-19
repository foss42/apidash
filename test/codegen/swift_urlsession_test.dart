import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';

import '../models/request_models.dart';

void main() {
  final codeGen = Codegen();

  group(
    'HTTPVerb.get',
    () {
      test('GET 1', () {
        const expectedCode = r"""
import Foundation

var request = URLRequest(url: URL(string: "https://api.apidash.dev")!)
request.httpMethod = "GET"
let semaphore = DispatchSemaphore(value: 0) 

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
    defer { semaphore.signal() }  

    if let error = error {
        print("Error: \(error.localizedDescription)")
        return
    }
    guard let data = data else {
        print("No data received")
        return
    }
    if let responseString = String(data: data, encoding: .utf8) {
        print("Response: \(responseString)")
    }
}

task.resume()

semaphore.wait()
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

var request = URLRequest(url: URL(string: "https://api.apidash.dev/country/data?code=US")!)
request.httpMethod = "GET"
let semaphore = DispatchSemaphore(value: 0) 

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
    defer { semaphore.signal() }  

    if let error = error {
        print("Error: \(error.localizedDescription)")
        return
    }
    guard let data = data else {
        print("No data received")
        return
    }
    if let responseString = String(data: data, encoding: .utf8) {
        print("Response: \(responseString)")
    }
}

task.resume()

semaphore.wait()
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

var request = URLRequest(url: URL(string: "https://api.apidash.dev/country/data?code=IND")!)
request.httpMethod = "GET"
let semaphore = DispatchSemaphore(value: 0) 

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
    defer { semaphore.signal() }  

    if let error = error {
        print("Error: \(error.localizedDescription)")
        return
    }
    guard let data = data else {
        print("No data received")
        return
    }
    if let responseString = String(data: data, encoding: .utf8) {
        print("Response: \(responseString)")
    }
}

task.resume()

semaphore.wait()
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

var request = URLRequest(url: URL(string: "https://api.apidash.dev/humanize/social?num=8700000&digits=3&system=SS&add_space=true&trailing_zeros=true")!)
request.httpMethod = "GET"
let semaphore = DispatchSemaphore(value: 0) 

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
    defer { semaphore.signal() }  

    if let error = error {
        print("Error: \(error.localizedDescription)")
        return
    }
    guard let data = data else {
        print("No data received")
        return
    }
    if let responseString = String(data: data, encoding: .utf8) {
        print("Response: \(responseString)")
    }
}

task.resume()

semaphore.wait()
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

var request = URLRequest(url: URL(string: "https://api.github.com/repos/foss42/apidash")!)
request.httpMethod = "GET"

request.addValue("Test Agent", forHTTPHeaderField: "User-Agent")

let semaphore = DispatchSemaphore(value: 0) 

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
    defer { semaphore.signal() }  

    if let error = error {
        print("Error: \(error.localizedDescription)")
        return
    }
    guard let data = data else {
        print("No data received")
        return
    }
    if let responseString = String(data: data, encoding: .utf8) {
        print("Response: \(responseString)")
    }
}

task.resume()

semaphore.wait()
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

var request = URLRequest(url: URL(string: "https://api.github.com/repos/foss42/apidash?raw=true")!)
request.httpMethod = "GET"

request.addValue("Test Agent", forHTTPHeaderField: "User-Agent")

let semaphore = DispatchSemaphore(value: 0) 

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
    defer { semaphore.signal() }  

    if let error = error {
        print("Error: \(error.localizedDescription)")
        return
    }
    guard let data = data else {
        print("No data received")
        return
    }
    if let responseString = String(data: data, encoding: .utf8) {
        print("Response: \(responseString)")
    }
}

task.resume()

semaphore.wait()
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

var request = URLRequest(url: URL(string: "https://api.apidash.dev")!)
request.httpMethod = "GET"
let semaphore = DispatchSemaphore(value: 0) 

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
    defer { semaphore.signal() }  

    if let error = error {
        print("Error: \(error.localizedDescription)")
        return
    }
    guard let data = data else {
        print("No data received")
        return
    }
    if let responseString = String(data: data, encoding: .utf8) {
        print("Response: \(responseString)")
    }
}

task.resume()

semaphore.wait()
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
        const expectedCode = r"""
import Foundation

var request = URLRequest(url: URL(string: "https://api.github.com/repos/foss42/apidash?raw=true")!)
request.httpMethod = "GET"

request.addValue("Test Agent", forHTTPHeaderField: "User-Agent")

let semaphore = DispatchSemaphore(value: 0) 

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
    defer { semaphore.signal() }  

    if let error = error {
        print("Error: \(error.localizedDescription)")
        return
    }
    guard let data = data else {
        print("No data received")
        return
    }
    if let responseString = String(data: data, encoding: .utf8) {
        print("Response: \(responseString)")
    }
}

task.resume()

semaphore.wait()
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

var request = URLRequest(url: URL(string: "https://api.apidash.dev/humanize/social?num=8700000&add_space=true")!)
request.httpMethod = "GET"
let semaphore = DispatchSemaphore(value: 0) 

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
    defer { semaphore.signal() }  

    if let error = error {
        print("Error: \(error.localizedDescription)")
        return
    }
    guard let data = data else {
        print("No data received")
        return
    }
    if let responseString = String(data: data, encoding: .utf8) {
        print("Response: \(responseString)")
    }
}

task.resume()

semaphore.wait()
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

var request = URLRequest(url: URL(string: "https://api.apidash.dev/humanize/social")!)
request.httpMethod = "GET"

request.addValue("Test Agent", forHTTPHeaderField: "User-Agent")

let semaphore = DispatchSemaphore(value: 0) 

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
    defer { semaphore.signal() }  

    if let error = error {
        print("Error: \(error.localizedDescription)")
        return
    }
    guard let data = data else {
        print("No data received")
        return
    }
    if let responseString = String(data: data, encoding: .utf8) {
        print("Response: \(responseString)")
    }
}

task.resume()

semaphore.wait()
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

var request = URLRequest(url: URL(string: "https://api.apidash.dev/humanize/social?num=8700000&digits=3")!)
request.httpMethod = "GET"

request.addValue("Test Agent", forHTTPHeaderField: "User-Agent")

let semaphore = DispatchSemaphore(value: 0) 

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
    defer { semaphore.signal() }  

    if let error = error {
        print("Error: \(error.localizedDescription)")
        return
    }
    guard let data = data else {
        print("No data received")
        return
    }
    if let responseString = String(data: data, encoding: .utf8) {
        print("Response: \(responseString)")
    }
}

task.resume()

semaphore.wait()
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

var request = URLRequest(url: URL(string: "https://api.apidash.dev/humanize/social")!)
request.httpMethod = "GET"
let semaphore = DispatchSemaphore(value: 0) 

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
    defer { semaphore.signal() }  

    if let error = error {
        print("Error: \(error.localizedDescription)")
        return
    }
    guard let data = data else {
        print("No data received")
        return
    }
    if let responseString = String(data: data, encoding: .utf8) {
        print("Response: \(responseString)")
    }
}

task.resume()

semaphore.wait()
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
  );

  group(
    'HTTPVerb.head',
    () {
      test('HEAD 1', () {
        const expectedCode = r"""
import Foundation

var request = URLRequest(url: URL(string: "https://api.apidash.dev")!)
request.httpMethod = "HEAD"
let semaphore = DispatchSemaphore(value: 0) 

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
    defer { semaphore.signal() }  

    if let error = error {
        print("Error: \(error.localizedDescription)")
        return
    }
    guard let data = data else {
        print("No data received")
        return
    }
    if let responseString = String(data: data, encoding: .utf8) {
        print("Response: \(responseString)")
    }
}

task.resume()

semaphore.wait()
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

var request = URLRequest(url: URL(string: "https://api.apidash.dev")!)
request.httpMethod = "HEAD"
let semaphore = DispatchSemaphore(value: 0) 

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
    defer { semaphore.signal() }  

    if let error = error {
        print("Error: \(error.localizedDescription)")
        return
    }
    guard let data = data else {
        print("No data received")
        return
    }
    if let responseString = String(data: data, encoding: .utf8) {
        print("Response: \(responseString)")
    }
}

task.resume()

semaphore.wait()
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
  );

  group(
    "HTTPVerb.post",
    () {
      test('POST 1', () {
        const expectedCode = r'''
import Foundation

let postData = """
{
"text": "I LOVE Flutter"
}
""".data(using: .utf8)
var request = URLRequest(url: URL(string: "https://api.apidash.dev/case/lower")!)
request.httpMethod = "POST"

request.addValue("application/json", forHTTPHeaderField: "Content-Type")

request.httpBody = postData

let semaphore = DispatchSemaphore(value: 0) 

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
    defer { semaphore.signal() }  

    if let error = error {
        print("Error: \(error.localizedDescription)")
        return
    }
    guard let data = data else {
        print("No data received")
        return
    }
    if let responseString = String(data: data, encoding: .utf8) {
        print("Response: \(responseString)")
    }
}

task.resume()

semaphore.wait()
''';

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftUrlSession,
              requestModelPost1,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });
      test('POST 2', () {
        const expectedCode = r'''
import Foundation

let postData = """
{
"text": "I LOVE Flutter",
"flag": null,
"male": true,
"female": false,
"no": 1.2,
"arr": ["null", "true", "false", null]
}
""".data(using: .utf8)
var request = URLRequest(url: URL(string: "https://api.apidash.dev/case/lower")!)
request.httpMethod = "POST"

request.addValue("application/json", forHTTPHeaderField: "Content-Type")

request.httpBody = postData

let semaphore = DispatchSemaphore(value: 0) 

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
    defer { semaphore.signal() }  

    if let error = error {
        print("Error: \(error.localizedDescription)")
        return
    }
    guard let data = data else {
        print("No data received")
        return
    }
    if let responseString = String(data: data, encoding: .utf8) {
        print("Response: \(responseString)")
    }
}

task.resume()

semaphore.wait()
''';

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftUrlSession,
              requestModelPost2,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });

      test('POST 3', () {
        const expectedCode = r'''
import Foundation

let postData = """
{
"text": "I LOVE Flutter"
}
""".data(using: .utf8)
var request = URLRequest(url: URL(string: "https://api.apidash.dev/case/lower")!)
request.httpMethod = "POST"

request.addValue("Test Agent", forHTTPHeaderField: "User-Agent")

request.addValue("application/json", forHTTPHeaderField: "Content-Type")

request.httpBody = postData

let semaphore = DispatchSemaphore(value: 0) 

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
    defer { semaphore.signal() }  

    if let error = error {
        print("Error: \(error.localizedDescription)")
        return
    }
    guard let data = data else {
        print("No data received")
        return
    }
    if let responseString = String(data: data, encoding: .utf8) {
        print("Response: \(responseString)")
    }
}

task.resume()

semaphore.wait()
''';

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

import MultipartFormData

let boundary = try! Boundary()
let multipartFormData = try! MultipartFormData(boundary: boundary) {

    
    Subpart {
        ContentDisposition(name: "text")
    } body: {
        Data("API".utf8)
    }
    

    
    Subpart {
        ContentDisposition(name: "sep")
    } body: {
        Data("|".utf8)
    }
    

    
    Subpart {
        ContentDisposition(name: "times")
    } body: {
        Data("3".utf8)
    }
    

}
var request = URLRequest(url: URL(string: "https://api.apidash.dev/io/form")!)
request.httpMethod = "POST"

request.addValue("multipart/form-data; boundary=\(boundary.stringValue)", forHTTPHeaderField: "Content-Type")

request.httpBody = try! multipartFormData.encode()
let semaphore = DispatchSemaphore(value: 0) 

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
    defer { semaphore.signal() }  

    if let error = error {
        print("Error: \(error.localizedDescription)")
        return
    }
    guard let data = data else {
        print("No data received")
        return
    }
    if let responseString = String(data: data, encoding: .utf8) {
        print("Response: \(responseString)")
    }
}

task.resume()

semaphore.wait()
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
        const expectedCode = r"""
import Foundation

import MultipartFormData

let boundary = try! Boundary()
let multipartFormData = try! MultipartFormData(boundary: boundary) {

    
    Subpart {
        ContentDisposition(name: "text")
    } body: {
        Data("API".utf8)
    }
    

    
    Subpart {
        ContentDisposition(name: "sep")
    } body: {
        Data("|".utf8)
    }
    

    
    Subpart {
        ContentDisposition(name: "times")
    } body: {
        Data("3".utf8)
    }
    

}
var request = URLRequest(url: URL(string: "https://api.apidash.dev/io/form")!)
request.httpMethod = "POST"

request.addValue("Test Agent", forHTTPHeaderField: "User-Agent")

request.addValue("multipart/form-data; boundary=\(boundary.stringValue)", forHTTPHeaderField: "Content-Type")

request.httpBody = try! multipartFormData.encode()
let semaphore = DispatchSemaphore(value: 0) 

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
    defer { semaphore.signal() }  

    if let error = error {
        print("Error: \(error.localizedDescription)")
        return
    }
    guard let data = data else {
        print("No data received")
        return
    }
    if let responseString = String(data: data, encoding: .utf8) {
        print("Response: \(responseString)")
    }
}

task.resume()

semaphore.wait()
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
        const expectedCode = r'''
import Foundation

import MultipartFormData

let boundary = try! Boundary()
let multipartFormData = try! MultipartFormData(boundary: boundary) {

    
    Subpart {
        ContentDisposition(name: "token")
    } body: {
        Data("xyz".utf8)
    }
    

    
    try Subpart {
        ContentDisposition(name: "imfile", filename: "1.png")
        ContentType(mimeType: MimeType(pathExtension: "png"))
    } body: {
        try Data(contentsOf: URL(fileURLWithPath: "/Documents/up/1.png"))
    }
    

}
var request = URLRequest(url: URL(string: "https://api.apidash.dev/io/img")!)
request.httpMethod = "POST"

request.addValue("multipart/form-data; boundary=\(boundary.stringValue)", forHTTPHeaderField: "Content-Type")

request.httpBody = try! multipartFormData.encode()
let semaphore = DispatchSemaphore(value: 0) 

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
    defer { semaphore.signal() }  

    if let error = error {
        print("Error: \(error.localizedDescription)")
        return
    }
    guard let data = data else {
        print("No data received")
        return
    }
    if let responseString = String(data: data, encoding: .utf8) {
        print("Response: \(responseString)")
    }
}

task.resume()

semaphore.wait()
''';

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

import MultipartFormData

let boundary = try! Boundary()
let multipartFormData = try! MultipartFormData(boundary: boundary) {

    
    Subpart {
        ContentDisposition(name: "token")
    } body: {
        Data("xyz".utf8)
    }
    

    
    try Subpart {
        ContentDisposition(name: "imfile", filename: "1.png")
        ContentType(mimeType: MimeType(pathExtension: "png"))
    } body: {
        try Data(contentsOf: URL(fileURLWithPath: "/Documents/up/1.png"))
    }
    

}
var request = URLRequest(url: URL(string: "https://api.apidash.dev/io/img")!)
request.httpMethod = "POST"

request.addValue("multipart/form-data; boundary=\(boundary.stringValue)", forHTTPHeaderField: "Content-Type")

request.httpBody = try! multipartFormData.encode()
let semaphore = DispatchSemaphore(value: 0) 

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
    defer { semaphore.signal() }  

    if let error = error {
        print("Error: \(error.localizedDescription)")
        return
    }
    guard let data = data else {
        print("No data received")
        return
    }
    if let responseString = String(data: data, encoding: .utf8) {
        print("Response: \(responseString)")
    }
}

task.resume()

semaphore.wait()
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

import MultipartFormData

let boundary = try! Boundary()
let multipartFormData = try! MultipartFormData(boundary: boundary) {

    
    Subpart {
        ContentDisposition(name: "text")
    } body: {
        Data("API".utf8)
    }
    

    
    Subpart {
        ContentDisposition(name: "sep")
    } body: {
        Data("|".utf8)
    }
    

    
    Subpart {
        ContentDisposition(name: "times")
    } body: {
        Data("3".utf8)
    }
    

}
var request = URLRequest(url: URL(string: "https://api.apidash.dev/io/form?size=2&len=3")!)
request.httpMethod = "POST"

request.addValue("multipart/form-data; boundary=\(boundary.stringValue)", forHTTPHeaderField: "Content-Type")

request.httpBody = try! multipartFormData.encode()
let semaphore = DispatchSemaphore(value: 0) 

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
    defer { semaphore.signal() }  

    if let error = error {
        print("Error: \(error.localizedDescription)")
        return
    }
    guard let data = data else {
        print("No data received")
        return
    }
    if let responseString = String(data: data, encoding: .utf8) {
        print("Response: \(responseString)")
    }
}

task.resume()

semaphore.wait()
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

import MultipartFormData

let boundary = try! Boundary()
let multipartFormData = try! MultipartFormData(boundary: boundary) {

    
    Subpart {
        ContentDisposition(name: "token")
    } body: {
        Data("xyz".utf8)
    }
    

    
    try Subpart {
        ContentDisposition(name: "imfile", filename: "1.png")
        ContentType(mimeType: MimeType(pathExtension: "png"))
    } body: {
        try Data(contentsOf: URL(fileURLWithPath: "/Documents/up/1.png"))
    }
    

}
var request = URLRequest(url: URL(string: "https://api.apidash.dev/io/img?size=2&len=3")!)
request.httpMethod = "POST"

request.addValue("Test Agent", forHTTPHeaderField: "User-Agent")

request.addValue("true", forHTTPHeaderField: "Keep-Alive")

request.addValue("multipart/form-data; boundary=\(boundary.stringValue)", forHTTPHeaderField: "Content-Type")

request.httpBody = try! multipartFormData.encode()
let semaphore = DispatchSemaphore(value: 0) 

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
    defer { semaphore.signal() }  

    if let error = error {
        print("Error: \(error.localizedDescription)")
        return
    }
    guard let data = data else {
        print("No data received")
        return
    }
    if let responseString = String(data: data, encoding: .utf8) {
        print("Response: \(responseString)")
    }
}

task.resume()

semaphore.wait()
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
        const expectedCode = r'''
import Foundation

let postData = """
{
"text": "I LOVE Flutter"
}
""".data(using: .utf8)
var request = URLRequest(url: URL(string: "https://api.apidash.dev/case/lower?size=2&len=3")!)
request.httpMethod = "POST"

request.addValue("application/json", forHTTPHeaderField: "Content-Type")

request.httpBody = postData

let semaphore = DispatchSemaphore(value: 0) 

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
    defer { semaphore.signal() }  

    if let error = error {
        print("Error: \(error.localizedDescription)")
        return
    }
    guard let data = data else {
        print("No data received")
        return
    }
    if let responseString = String(data: data, encoding: .utf8) {
        print("Response: \(responseString)")
    }
}

task.resume()

semaphore.wait()
''';

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftUrlSession,
              requestModelPost10,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });
    },
  );

  group(
    'HTTPVerb.put',
    () {
      test('PUT 1', () {
        const expectedCode = r'''
import Foundation

let postData = """
{
"name": "morpheus",
"job": "zion resident"
}
""".data(using: .utf8)
var request = URLRequest(url: URL(string: "https://reqres.in/api/users/2")!)
request.httpMethod = "PUT"

request.addValue("application/json", forHTTPHeaderField: "Content-Type")

request.httpBody = postData

let semaphore = DispatchSemaphore(value: 0) 

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
    defer { semaphore.signal() }  

    if let error = error {
        print("Error: \(error.localizedDescription)")
        return
    }
    guard let data = data else {
        print("No data received")
        return
    }
    if let responseString = String(data: data, encoding: .utf8) {
        print("Response: \(responseString)")
    }
}

task.resume()

semaphore.wait()
''';

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftUrlSession,
              requestModelPut1,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });
    },
  );

  group(
    'HTTPVerb.patch',
    () {
      test('PATCH 1', () {
        const expectedCode = r'''
import Foundation

let postData = """
{
"name": "marfeus",
"job": "accountant"
}
""".data(using: .utf8)
var request = URLRequest(url: URL(string: "https://reqres.in/api/users/2")!)
request.httpMethod = "PATCH"

request.addValue("application/json", forHTTPHeaderField: "Content-Type")

request.httpBody = postData

let semaphore = DispatchSemaphore(value: 0) 

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
    defer { semaphore.signal() }  

    if let error = error {
        print("Error: \(error.localizedDescription)")
        return
    }
    guard let data = data else {
        print("No data received")
        return
    }
    if let responseString = String(data: data, encoding: .utf8) {
        print("Response: \(responseString)")
    }
}

task.resume()

semaphore.wait()
''';

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftUrlSession,
              requestModelPatch1,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });
    },
  );

  group(
    'HTTPVerb.delete',
    () {
      test('DELETE 1', () {
        const expectedCode = r'''
import Foundation

var request = URLRequest(url: URL(string: "https://reqres.in/api/users/2")!)
request.httpMethod = "DELETE"
let semaphore = DispatchSemaphore(value: 0) 

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
    defer { semaphore.signal() }  

    if let error = error {
        print("Error: \(error.localizedDescription)")
        return
    }
    guard let data = data else {
        print("No data received")
        return
    }
    if let responseString = String(data: data, encoding: .utf8) {
        print("Response: \(responseString)")
    }
}

task.resume()

semaphore.wait()
''';

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftUrlSession,
              requestModelDelete1,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });

      test('DELETE 2', () {
        const expectedCode = r'''
import Foundation

let postData = """
{
"name": "marfeus",
"job": "accountant"
}
""".data(using: .utf8)
var request = URLRequest(url: URL(string: "https://reqres.in/api/users/2")!)
request.httpMethod = "DELETE"

request.addValue("application/json", forHTTPHeaderField: "Content-Type")

request.httpBody = postData

let semaphore = DispatchSemaphore(value: 0) 

let task = URLSession.shared.dataTask(with: request) { data, response, error in 
    defer { semaphore.signal() }  

    if let error = error {
        print("Error: \(error.localizedDescription)")
        return
    }
    guard let data = data else {
        print("No data received")
        return
    }
    if let responseString = String(data: data, encoding: .utf8) {
        print("Response: \(responseString)")
    }
}

task.resume()

semaphore.wait()
''';

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftUrlSession,
              requestModelDelete2,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });
    },
  );
}
