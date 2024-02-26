import 'package:apidash/codegen/swift/urlsession.dart';
import '../request_models.dart';
import 'package:test/test.dart';

void main() {
  final swiftUrlsessionCodeGen = SwiftUrlsessionCodeGen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""import Foundation

let group = DispatchGroup()
group.enter()

var request = URLRequest(url: URL(string: "https://api.foss42.com")!)
request.httpMethod = "GET"

let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
    defer { group.leave() }

    if let error = error {
        print("Error: \(error)")
    } else if let httpResponse = response as? HTTPURLResponse {
        print("Status Code: \(httpResponse.statusCode)")

        if let data = data, let bodyText = String(data: data, encoding: .utf8) {
            if (200..<300).contains(httpResponse.statusCode) {
                print("Response Body: \(bodyText)")
            } else {
                print("Error Response Body: \(bodyText)")
            }
        }
    }
}

task.resume()
group.wait()
""";
      expect(swiftUrlsessionCodeGen.getCode(requestModelGet1, "https"),
          expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r'''import Foundation

let group = DispatchGroup()
group.enter()

var request = URLRequest(url: URL(string: "https://api.foss42.com/country/data?code=US")!)
request.httpMethod = "GET"

let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
    defer { group.leave() }

    if let error = error {
        print("Error: \(error)")
    } else if let httpResponse = response as? HTTPURLResponse {
        print("Status Code: \(httpResponse.statusCode)")

        if let data = data, let bodyText = String(data: data, encoding: .utf8) {
            if (200..<300).contains(httpResponse.statusCode) {
                print("Response Body: \(bodyText)")
            } else {
                print("Error Response Body: \(bodyText)")
            }
        }
    }
}

task.resume()
group.wait()
''';
      expect(swiftUrlsessionCodeGen.getCode(requestModelGet2, "https"),
          expectedCode);
    });

    test('GET 3', () {
      const expectedCode = r'''import Foundation

let group = DispatchGroup()
group.enter()

var request = URLRequest(url: URL(string: "https://api.foss42.com/country/data?code=IND")!)
request.httpMethod = "GET"

let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
    defer { group.leave() }

    if let error = error {
        print("Error: \(error)")
    } else if let httpResponse = response as? HTTPURLResponse {
        print("Status Code: \(httpResponse.statusCode)")

        if let data = data, let bodyText = String(data: data, encoding: .utf8) {
            if (200..<300).contains(httpResponse.statusCode) {
                print("Response Body: \(bodyText)")
            } else {
                print("Error Response Body: \(bodyText)")
            }
        }
    }
}

task.resume()
group.wait()
''';
      expect(swiftUrlsessionCodeGen.getCode(requestModelGet3, "https"),
          expectedCode);
    });

    test('GET 4', () {
      const expectedCode = r'''import Foundation

let group = DispatchGroup()
group.enter()

var request = URLRequest(url: URL(string: "https://api.foss42.com/humanize/social?num=8700000&digits=3&system=SS&add_space=true&trailing_zeros=true")!)
request.httpMethod = "GET"

let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
    defer { group.leave() }

    if let error = error {
        print("Error: \(error)")
    } else if let httpResponse = response as? HTTPURLResponse {
        print("Status Code: \(httpResponse.statusCode)")

        if let data = data, let bodyText = String(data: data, encoding: .utf8) {
            if (200..<300).contains(httpResponse.statusCode) {
                print("Response Body: \(bodyText)")
            } else {
                print("Error Response Body: \(bodyText)")
            }
        }
    }
}

task.resume()
group.wait()
''';
      expect(swiftUrlsessionCodeGen.getCode(requestModelGet4, "https"),
          expectedCode);
    });

    test('GET 5', () {
      const expectedCode = r'''import Foundation

let group = DispatchGroup()
group.enter()

var request = URLRequest(url: URL(string: "https://api.github.com/repos/foss42/apidash")!)
request.httpMethod = "GET"
request.addValue("Test Agent", forHTTPHeaderField: "User-Agent")

let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
    defer { group.leave() }

    if let error = error {
        print("Error: \(error)")
    } else if let httpResponse = response as? HTTPURLResponse {
        print("Status Code: \(httpResponse.statusCode)")

        if let data = data, let bodyText = String(data: data, encoding: .utf8) {
            if (200..<300).contains(httpResponse.statusCode) {
                print("Response Body: \(bodyText)")
            } else {
                print("Error Response Body: \(bodyText)")
            }
        }
    }
}

task.resume()
group.wait()
''';
      expect(swiftUrlsessionCodeGen.getCode(requestModelGet5, "https"),
          expectedCode);
    });

    test('GET 6', () {
      const expectedCode = r'''import Foundation

let group = DispatchGroup()
group.enter()

var request = URLRequest(url: URL(string: "https://api.github.com/repos/foss42/apidash?raw=true")!)
request.httpMethod = "GET"
request.addValue("Test Agent", forHTTPHeaderField: "User-Agent")

let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
    defer { group.leave() }

    if let error = error {
        print("Error: \(error)")
    } else if let httpResponse = response as? HTTPURLResponse {
        print("Status Code: \(httpResponse.statusCode)")

        if let data = data, let bodyText = String(data: data, encoding: .utf8) {
            if (200..<300).contains(httpResponse.statusCode) {
                print("Response Body: \(bodyText)")
            } else {
                print("Error Response Body: \(bodyText)")
            }
        }
    }
}

task.resume()
group.wait()
''';
      expect(swiftUrlsessionCodeGen.getCode(requestModelGet6, "https"),
          expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r'''import Foundation

let group = DispatchGroup()
group.enter()

var request = URLRequest(url: URL(string: "https://api.foss42.com")!)
request.httpMethod = "GET"

let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
    defer { group.leave() }

    if let error = error {
        print("Error: \(error)")
    } else if let httpResponse = response as? HTTPURLResponse {
        print("Status Code: \(httpResponse.statusCode)")

        if let data = data, let bodyText = String(data: data, encoding: .utf8) {
            if (200..<300).contains(httpResponse.statusCode) {
                print("Response Body: \(bodyText)")
            } else {
                print("Error Response Body: \(bodyText)")
            }
        }
    }
}

task.resume()
group.wait()
''';
      expect(swiftUrlsessionCodeGen.getCode(requestModelGet7, "https"),
          expectedCode);
    });

    test('GET 8', () {
      const expectedCode = r'''import Foundation

let group = DispatchGroup()
group.enter()

var request = URLRequest(url: URL(string: "https://api.github.com/repos/foss42/apidash?raw=true")!)
request.httpMethod = "GET"
request.addValue("Test Agent", forHTTPHeaderField: "User-Agent")

let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
    defer { group.leave() }

    if let error = error {
        print("Error: \(error)")
    } else if let httpResponse = response as? HTTPURLResponse {
        print("Status Code: \(httpResponse.statusCode)")

        if let data = data, let bodyText = String(data: data, encoding: .utf8) {
            if (200..<300).contains(httpResponse.statusCode) {
                print("Response Body: \(bodyText)")
            } else {
                print("Error Response Body: \(bodyText)")
            }
        }
    }
}

task.resume()
group.wait()
''';
      expect(swiftUrlsessionCodeGen.getCode(requestModelGet8, "https"),
          expectedCode);
    });

    test('GET 9', () {
      const expectedCode = r'''import Foundation

let group = DispatchGroup()
group.enter()

var request = URLRequest(url: URL(string: "https://api.foss42.com/humanize/social?num=8700000&add_space=true")!)
request.httpMethod = "GET"

let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
    defer { group.leave() }

    if let error = error {
        print("Error: \(error)")
    } else if let httpResponse = response as? HTTPURLResponse {
        print("Status Code: \(httpResponse.statusCode)")

        if let data = data, let bodyText = String(data: data, encoding: .utf8) {
            if (200..<300).contains(httpResponse.statusCode) {
                print("Response Body: \(bodyText)")
            } else {
                print("Error Response Body: \(bodyText)")
            }
        }
    }
}

task.resume()
group.wait()
''';
      expect(swiftUrlsessionCodeGen.getCode(requestModelGet9, "https"),
          expectedCode);
    });

    test('GET 10', () {
      const expectedCode = r'''import Foundation

let group = DispatchGroup()
group.enter()

var request = URLRequest(url: URL(string: "https://api.foss42.com/humanize/social")!)
request.httpMethod = "GET"
request.addValue("Test Agent", forHTTPHeaderField: "User-Agent")

let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
    defer { group.leave() }

    if let error = error {
        print("Error: \(error)")
    } else if let httpResponse = response as? HTTPURLResponse {
        print("Status Code: \(httpResponse.statusCode)")

        if let data = data, let bodyText = String(data: data, encoding: .utf8) {
            if (200..<300).contains(httpResponse.statusCode) {
                print("Response Body: \(bodyText)")
            } else {
                print("Error Response Body: \(bodyText)")
            }
        }
    }
}

task.resume()
group.wait()
''';
      expect(
          swiftUrlsessionCodeGen.getCode(
            requestModelGet10,
            "https",
          ),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode = r'''import Foundation

let group = DispatchGroup()
group.enter()

var request = URLRequest(url: URL(string: "https://api.foss42.com/humanize/social?num=8700000&digits=3")!)
request.httpMethod = "GET"
request.addValue("Test Agent", forHTTPHeaderField: "User-Agent")

let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
    defer { group.leave() }

    if let error = error {
        print("Error: \(error)")
    } else if let httpResponse = response as? HTTPURLResponse {
        print("Status Code: \(httpResponse.statusCode)")

        if let data = data, let bodyText = String(data: data, encoding: .utf8) {
            if (200..<300).contains(httpResponse.statusCode) {
                print("Response Body: \(bodyText)")
            } else {
                print("Error Response Body: \(bodyText)")
            }
        }
    }
}

task.resume()
group.wait()
''';
      expect(swiftUrlsessionCodeGen.getCode(requestModelGet11, "https"),
          expectedCode);
    });

    test('GET 12', () {
      const expectedCode = r'''import Foundation

let group = DispatchGroup()
group.enter()

var request = URLRequest(url: URL(string: "https://api.foss42.com/humanize/social")!)
request.httpMethod = "GET"

let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
    defer { group.leave() }

    if let error = error {
        print("Error: \(error)")
    } else if let httpResponse = response as? HTTPURLResponse {
        print("Status Code: \(httpResponse.statusCode)")

        if let data = data, let bodyText = String(data: data, encoding: .utf8) {
            if (200..<300).contains(httpResponse.statusCode) {
                print("Response Body: \(bodyText)")
            } else {
                print("Error Response Body: \(bodyText)")
            }
        }
    }
}

task.resume()
group.wait()
''';
      expect(swiftUrlsessionCodeGen.getCode(requestModelGet12, "https"),
          expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r'''import Foundation

let group = DispatchGroup()
group.enter()

var request = URLRequest(url: URL(string: "https://api.foss42.com")!)
request.httpMethod = "HEAD"

let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
    defer { group.leave() }

    if let error = error {
        print("Error: \(error)")
    } else if let httpResponse = response as? HTTPURLResponse {
        print("Status Code: \(httpResponse.statusCode)")

        if let data = data, let bodyText = String(data: data, encoding: .utf8) {
            if (200..<300).contains(httpResponse.statusCode) {
                print("Response Body: \(bodyText)")
            } else {
                print("Error Response Body: \(bodyText)")
            }
        }
    }
}

task.resume()
group.wait()
''';
      expect(swiftUrlsessionCodeGen.getCode(requestModelHead1, "https"),
          expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r'''import Foundation

let group = DispatchGroup()
group.enter()

var request = URLRequest(url: URL(string: "https://api.foss42.com")!)
request.httpMethod = "HEAD"

let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
    defer { group.leave() }

    if let error = error {
        print("Error: \(error)")
    } else if let httpResponse = response as? HTTPURLResponse {
        print("Status Code: \(httpResponse.statusCode)")

        if let data = data, let bodyText = String(data: data, encoding: .utf8) {
            if (200..<300).contains(httpResponse.statusCode) {
                print("Response Body: \(bodyText)")
            } else {
                print("Error Response Body: \(bodyText)")
            }
        }
    }
}

task.resume()
group.wait()
''';
      expect(swiftUrlsessionCodeGen.getCode(requestModelHead2, "http"),
          expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r'''import Foundation

let group = DispatchGroup()
group.enter()

var request = URLRequest(url: URL(string: "https://api.foss42.com/case/lower")!)
request.httpMethod = "POST"
request.addValue("text/plain", forHTTPHeaderField: "Content-Type")

request.httpBody = """
{
"text": "I LOVE Flutter"
}
""".data(using: .utf8)!

let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
    defer { group.leave() }

    if let error = error {
        print("Error: \(error)")
    } else if let httpResponse = response as? HTTPURLResponse {
        print("Status Code: \(httpResponse.statusCode)")

        if let data = data, let bodyText = String(data: data, encoding: .utf8) {
            if (200..<300).contains(httpResponse.statusCode) {
                print("Response Body: \(bodyText)")
            } else {
                print("Error Response Body: \(bodyText)")
            }
        }
    }
}

task.resume()
group.wait()
''';

      expect(swiftUrlsessionCodeGen.getCode(requestModelPost1, "https"),
          expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r'''import Foundation

let group = DispatchGroup()
group.enter()

var request = URLRequest(url: URL(string: "https://api.foss42.com/case/lower")!)
request.httpMethod = "POST"
request.addValue("application/json", forHTTPHeaderField: "Content-Type")

request.httpBody = """
{
"text": "I LOVE Flutter"
}
""".data(using: .utf8)!

let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
    defer { group.leave() }

    if let error = error {
        print("Error: \(error)")
    } else if let httpResponse = response as? HTTPURLResponse {
        print("Status Code: \(httpResponse.statusCode)")

        if let data = data, let bodyText = String(data: data, encoding: .utf8) {
            if (200..<300).contains(httpResponse.statusCode) {
                print("Response Body: \(bodyText)")
            } else {
                print("Error Response Body: \(bodyText)")
            }
        }
    }
}

task.resume()
group.wait()
''';
      expect(swiftUrlsessionCodeGen.getCode(requestModelPost2, "https"),
          expectedCode);
    });

    test('POST 3', () {
      const expectedCode = r'''import Foundation

let group = DispatchGroup()
group.enter()

var request = URLRequest(url: URL(string: "https://api.foss42.com/case/lower")!)
request.httpMethod = "POST"
request.addValue("application/json", forHTTPHeaderField: "Content-Type")
request.addValue("Test Agent", forHTTPHeaderField: "User-Agent")

request.httpBody = """
{
"text": "I LOVE Flutter"
}
""".data(using: .utf8)!

let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
    defer { group.leave() }

    if let error = error {
        print("Error: \(error)")
    } else if let httpResponse = response as? HTTPURLResponse {
        print("Status Code: \(httpResponse.statusCode)")

        if let data = data, let bodyText = String(data: data, encoding: .utf8) {
            if (200..<300).contains(httpResponse.statusCode) {
                print("Response Body: \(bodyText)")
            } else {
                print("Error Response Body: \(bodyText)")
            }
        }
    }
}

task.resume()
group.wait()
''';
      expect(swiftUrlsessionCodeGen.getCode(requestModelPost3, "https"),
          expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT 1', () {
      const expectedCode = r'''import Foundation

let group = DispatchGroup()
group.enter()

var request = URLRequest(url: URL(string: "https://reqres.in/api/users/2")!)
request.httpMethod = "PUT"
request.addValue("application/json", forHTTPHeaderField: "Content-Type")

request.httpBody = """
{
"name": "morpheus",
"job": "zion resident"
}
""".data(using: .utf8)!

let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
    defer { group.leave() }

    if let error = error {
        print("Error: \(error)")
    } else if let httpResponse = response as? HTTPURLResponse {
        print("Status Code: \(httpResponse.statusCode)")

        if let data = data, let bodyText = String(data: data, encoding: .utf8) {
            if (200..<300).contains(httpResponse.statusCode) {
                print("Response Body: \(bodyText)")
            } else {
                print("Error Response Body: \(bodyText)")
            }
        }
    }
}

task.resume()
group.wait()
''';
      expect(swiftUrlsessionCodeGen.getCode(requestModelPut1, "https"),
          expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH 1', () {
      const expectedCode = r'''import Foundation

let group = DispatchGroup()
group.enter()

var request = URLRequest(url: URL(string: "https://reqres.in/api/users/2")!)
request.httpMethod = "PATCH"
request.addValue("application/json", forHTTPHeaderField: "Content-Type")

request.httpBody = """
{
"name": "marfeus",
"job": "accountant"
}
""".data(using: .utf8)!

let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
    defer { group.leave() }

    if let error = error {
        print("Error: \(error)")
    } else if let httpResponse = response as? HTTPURLResponse {
        print("Status Code: \(httpResponse.statusCode)")

        if let data = data, let bodyText = String(data: data, encoding: .utf8) {
            if (200..<300).contains(httpResponse.statusCode) {
                print("Response Body: \(bodyText)")
            } else {
                print("Error Response Body: \(bodyText)")
            }
        }
    }
}

task.resume()
group.wait()
''';
      expect(swiftUrlsessionCodeGen.getCode(requestModelPatch1, "https"),
          expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode = r"""import Foundation

let group = DispatchGroup()
group.enter()

var request = URLRequest(url: URL(string: "https://reqres.in/api/users/2")!)
request.httpMethod = "DELETE"

let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
    defer { group.leave() }

    if let error = error {
        print("Error: \(error)")
    } else if let httpResponse = response as? HTTPURLResponse {
        print("Status Code: \(httpResponse.statusCode)")

        if let data = data, let bodyText = String(data: data, encoding: .utf8) {
            if (200..<300).contains(httpResponse.statusCode) {
                print("Response Body: \(bodyText)")
            } else {
                print("Error Response Body: \(bodyText)")
            }
        }
    }
}

task.resume()
group.wait()
""";
      expect(swiftUrlsessionCodeGen.getCode(requestModelDelete1, "https"),
          expectedCode);
    });

    test('DELETE 2', () {
      const expectedCode = r'''import Foundation

let group = DispatchGroup()
group.enter()

var request = URLRequest(url: URL(string: "https://reqres.in/api/users/2")!)
request.httpMethod = "DELETE"
request.addValue("application/json", forHTTPHeaderField: "Content-Type")

request.httpBody = """
{
"name": "marfeus",
"job": "accountant"
}
""".data(using: .utf8)!

let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
    defer { group.leave() }

    if let error = error {
        print("Error: \(error)")
    } else if let httpResponse = response as? HTTPURLResponse {
        print("Status Code: \(httpResponse.statusCode)")

        if let data = data, let bodyText = String(data: data, encoding: .utf8) {
            if (200..<300).contains(httpResponse.statusCode) {
                print("Response Body: \(bodyText)")
            } else {
                print("Error Response Body: \(bodyText)")
            }
        }
    }
}

task.resume()
group.wait()
''';
      expect(swiftUrlsessionCodeGen.getCode(requestModelDelete2, "https"),
          expectedCode);
    });
  });
}
