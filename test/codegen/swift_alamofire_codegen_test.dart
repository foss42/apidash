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
import Alamofire
let url = "https://api.apidash.dev"


AF.request(url, method: .get)

.responseData { response in
    switch response.result {
    case .success(let data):
        if let responseString = String(data: data, encoding: .utf8) {
            print("Response: \(responseString)")
        }
    case .failure(let error):
        print("Error: \(error)")
    }
    exit(0)
}

dispatchMain()""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftAlamofire,
              requestModelGet1,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });

      test('GET 2', () {
        const expectedCode = r"""
import Foundation
import Alamofire
let url = "https://api.apidash.dev/country/data?code=US"


AF.request(url, method: .get)

.responseData { response in
    switch response.result {
    case .success(let data):
        if let responseString = String(data: data, encoding: .utf8) {
            print("Response: \(responseString)")
        }
    case .failure(let error):
        print("Error: \(error)")
    }
    exit(0)
}

dispatchMain()""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftAlamofire,
              requestModelGet2,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });

      test('GET 3', () {
        const expectedCode = r"""
import Foundation
import Alamofire
let url = "https://api.apidash.dev/country/data?code=IND"


AF.request(url, method: .get)

.responseData { response in
    switch response.result {
    case .success(let data):
        if let responseString = String(data: data, encoding: .utf8) {
            print("Response: \(responseString)")
        }
    case .failure(let error):
        print("Error: \(error)")
    }
    exit(0)
}

dispatchMain()""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftAlamofire,
              requestModelGet3,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });

      test('GET 4', () {
        const expectedCode = r"""
import Foundation
import Alamofire
let url = "https://api.apidash.dev/humanize/social?num=8700000&digits=3&system=SS&add_space=true&trailing_zeros=true"


AF.request(url, method: .get)

.responseData { response in
    switch response.result {
    case .success(let data):
        if let responseString = String(data: data, encoding: .utf8) {
            print("Response: \(responseString)")
        }
    case .failure(let error):
        print("Error: \(error)")
    }
    exit(0)
}

dispatchMain()""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftAlamofire,
              requestModelGet4,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });

      test('GET 5', () {
        const expectedCode = r"""
import Foundation
import Alamofire
let url = "https://api.github.com/repos/foss42/apidash"


AF.request(url, method: .get, headers: ["User-Agent": "Test Agent"])

.responseData { response in
    switch response.result {
    case .success(let data):
        if let responseString = String(data: data, encoding: .utf8) {
            print("Response: \(responseString)")
        }
    case .failure(let error):
        print("Error: \(error)")
    }
    exit(0)
}

dispatchMain()""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftAlamofire,
              requestModelGet5,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });

      test('GET 6', () {
        const expectedCode = r"""
import Foundation
import Alamofire
let url = "https://api.github.com/repos/foss42/apidash?raw=true"


AF.request(url, method: .get, headers: ["User-Agent": "Test Agent"])

.responseData { response in
    switch response.result {
    case .success(let data):
        if let responseString = String(data: data, encoding: .utf8) {
            print("Response: \(responseString)")
        }
    case .failure(let error):
        print("Error: \(error)")
    }
    exit(0)
}

dispatchMain()""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftAlamofire,
              requestModelGet6,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });

      test('GET 7', () {
        const expectedCode = r"""
import Foundation
import Alamofire
let url = "https://api.apidash.dev"


AF.request(url, method: .get)

.responseData { response in
    switch response.result {
    case .success(let data):
        if let responseString = String(data: data, encoding: .utf8) {
            print("Response: \(responseString)")
        }
    case .failure(let error):
        print("Error: \(error)")
    }
    exit(0)
}

dispatchMain()""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftAlamofire,
              requestModelGet7,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });

      test('GET 8', () {
        const expectedCode = r"""
import Foundation
import Alamofire
let url = "https://api.github.com/repos/foss42/apidash?raw=true"


AF.request(url, method: .get, headers: ["User-Agent": "Test Agent"])

.responseData { response in
    switch response.result {
    case .success(let data):
        if let responseString = String(data: data, encoding: .utf8) {
            print("Response: \(responseString)")
        }
    case .failure(let error):
        print("Error: \(error)")
    }
    exit(0)
}

dispatchMain()""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftAlamofire,
              requestModelGet8,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });

      test('GET 9', () {
        const expectedCode = r"""
import Foundation
import Alamofire
let url = "https://api.apidash.dev/humanize/social?num=8700000&add_space=true"


AF.request(url, method: .get)

.responseData { response in
    switch response.result {
    case .success(let data):
        if let responseString = String(data: data, encoding: .utf8) {
            print("Response: \(responseString)")
        }
    case .failure(let error):
        print("Error: \(error)")
    }
    exit(0)
}

dispatchMain()""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftAlamofire,
              requestModelGet9,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });

      test('GET 10', () {
        const expectedCode = r"""
import Foundation
import Alamofire
let url = "https://api.apidash.dev/humanize/social"


AF.request(url, method: .get, headers: ["User-Agent": "Test Agent"])

.responseData { response in
    switch response.result {
    case .success(let data):
        if let responseString = String(data: data, encoding: .utf8) {
            print("Response: \(responseString)")
        }
    case .failure(let error):
        print("Error: \(error)")
    }
    exit(0)
}

dispatchMain()""";

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftAlamofire,
              requestModelGet10,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      }
      );
    });}