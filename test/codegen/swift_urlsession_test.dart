import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:test/test.dart';

import '../models/request_models.dart';

void main() {
  final codeGen = Codegen();

  group('HTTPVerb.get', () {
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
              CodegenLanguage.swiftUrlsession, requestModelGet1, "https"),
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
              CodegenLanguage.swiftUrlsession, requestModelGet2, "https"),
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
              CodegenLanguage.swiftUrlsession, requestModelGet3, "https"),
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
              CodegenLanguage.swiftUrlsession, requestModelGet4, "https"),
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
              CodegenLanguage.swiftUrlsession, requestModelGet5, "https"),
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
              CodegenLanguage.swiftUrlsession, requestModelGet6, "https"),
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
              CodegenLanguage.swiftUrlsession, requestModelGet7, "https"),
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
              CodegenLanguage.swiftUrlsession, requestModelGet8, "https"),
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
              CodegenLanguage.swiftUrlsession, requestModelGet9, "https"),
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
              CodegenLanguage.swiftUrlsession, requestModelGet10, "https"),
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
              CodegenLanguage.swiftUrlsession, requestModelGet11, "https"),
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
              CodegenLanguage.swiftUrlsession, requestModelGet12, "https"),
          expectedCode);
    });
  });

  group('HTTPVerb.head', () {
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
              CodegenLanguage.swiftUrlsession, requestModelHead1, "https"),
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
              CodegenLanguage.swiftUrlsession, requestModelHead2, "https"),
          expectedCode);
    });
  });
  group("HTTPVerb.post", () {
      test('POST 2', () {
        const expectedCode = r"""
""";

        expect(
            codeGen.getCode(
                CodegenLanguage.swiftUrlsession, requestModelPost2, "https"),
            expectedCode);
      });

      test('POST 3', () {
        const expectedCode = r"""
""";

        expect(
            codeGen.getCode(
                CodegenLanguage.swiftUrlsession, requestModelPost3, "https"),
            expectedCode);
      });

      test('POST 4', () {
        const expectedCode = r"""
""";

        expect(
            codeGen.getCode(
                CodegenLanguage.swiftUrlsession, requestModelPost4, "https"),
            expectedCode);
      });

      test('POST 5', () {
        const expectedCode = r"""
""";

        expect(
            codeGen.getCode(
                CodegenLanguage.swiftUrlsession, requestModelPost5, "https"),
            expectedCode);
      });
    });
  group('HTTPVerb.put', () {
    test('PUT 1', () {
      const expectedCode = r"""
""";

      expect(
          codeGen.getCode(
              CodegenLanguage.swiftUrlsession, requestModelPut1, "https"),
          expectedCode);
    });
  });

  group('HTTPVerb.patch', () {
    test('PATCH 1', () {
      const expectedCode = r"""
""";

      expect(
          codeGen.getCode(
              CodegenLanguage.swiftUrlsession, requestModelPatch1, "https"),
          expectedCode);
    });
  });

  group('HTTPVerb.delete', () {
    test('DELETE 1', () {
      const expectedCode = r"""
""";

      expect(
          codeGen.getCode(
              CodegenLanguage.swiftUrlsession, requestModelDelete1, "https"),
          expectedCode);
    });

    test('DELETE 2', () {
      const expectedCode = r"""
""";

      expect(
          codeGen.getCode(
              CodegenLanguage.swiftUrlsession, requestModelDelete2, "https"),
          expectedCode);
    });
  });
}
