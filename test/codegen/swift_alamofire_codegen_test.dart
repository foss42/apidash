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
      });

      test('GET 11', () {
        const expectedCode = r"""
import Foundation
import Alamofire
let url = "https://api.apidash.dev/humanize/social?num=8700000&digits=3"


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
              requestModelGet11,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });

      test('GET 12', () {
        const expectedCode = r"""
import Foundation
import Alamofire
let url = "https://api.apidash.dev/humanize/social"


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
import Alamofire
let url = "https://api.apidash.dev"


AF.request(url, method: .head)

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
              requestModelHead1,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });

      test('HEAD 2', () {
        const expectedCode = r"""
import Foundation
import Alamofire
let url = "https://api.apidash.dev"


AF.request(url, method: .head)

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
import Alamofire
let textString = """
{\n\"text\": \"I LOVE Flutter\"\n}
"""
let textData = textString.data(using: .utf8)
let url = "https://api.apidash.dev/case/lower"


AF.upload(textData!, to: url, method: .post, headers: ["Content-Type": "text/plain"])

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

dispatchMain()''';

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftAlamofire,
              requestModelPost1,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });
      test('POST 2', () {
        const expectedCode = r'''
import Foundation
import Alamofire
let jsonString = """
{\n\"text\": \"I LOVE Flutter\",\n\"flag\": null,\n\"male\": true,\n\"female\": false,\n\"no\": 1.2,\n\"arr\": [\"null\", \"true\", \"false\", null]\n}
"""
let jsonData = jsonString.data(using: .utf8)
let url = "https://api.apidash.dev/case/lower"


AF.upload(jsonData!, to: url, method: .post, headers: ["Content-Type": "application/json"])

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

dispatchMain()''';

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftAlamofire,
              requestModelPost2,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });

      test('POST 3', () {
        const expectedCode = r'''
import Foundation
import Alamofire
let jsonString = """
{\n\"text\": \"I LOVE Flutter\"\n}
"""
let jsonData = jsonString.data(using: .utf8)
let url = "https://api.apidash.dev/case/lower"


AF.upload(jsonData!, to: url, method: .post, headers: ["User-Agent": "Test Agent", "Content-Type": "application/json"])

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

dispatchMain()''';

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftAlamofire,
              requestModelPost3,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });

      test('POST 4', () {
        const expectedCode = r"""
import Foundation
import Alamofire
let multipartFormData = MultipartFormData()
    multipartFormData.append(Data("API".utf8), withName: "text")    
    multipartFormData.append(Data("|".utf8), withName: "sep")    
    multipartFormData.append(Data("3".utf8), withName: "times")    
let url = "https://api.apidash.dev/io/form"


AF.upload(multipartFormData: multipartFormData, to: url, method: .post)

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
              requestModelPost4,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });

      test('POST 5', () {
        const expectedCode = r"""
import Foundation
import Alamofire
let multipartFormData = MultipartFormData()
    multipartFormData.append(Data("API".utf8), withName: "text")    
    multipartFormData.append(Data("|".utf8), withName: "sep")    
    multipartFormData.append(Data("3".utf8), withName: "times")    
let url = "https://api.apidash.dev/io/form"


AF.upload(multipartFormData: multipartFormData, to: url, method: .post, headers: ["User-Agent": "Test Agent"])

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
              requestModelPost5,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });


      test('POST 6', () {
        const expectedCode = r"""
import Foundation
import Alamofire
let multipartFormData = MultipartFormData()
    multipartFormData.append(Data("xyz".utf8), withName: "token")    
    
let fileURL = URL(fileURLWithPath: "/Documents/up/1.png")
multipartFormData.append(fileURL, withName: "imfile", fileName: "1.png", mimeType: "application/octet-stream")
    
let url = "https://api.apidash.dev/io/img"


AF.upload(multipartFormData: multipartFormData, to: url, method: .post)

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
              requestModelPost6,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });




      test('POST 7', () {
        const expectedCode = r"""
import Foundation
import Alamofire
let multipartFormData = MultipartFormData()
    multipartFormData.append(Data("xyz".utf8), withName: "token")    
    
let fileURL = URL(fileURLWithPath: "/Documents/up/1.png")
multipartFormData.append(fileURL, withName: "imfile", fileName: "1.png", mimeType: "application/octet-stream")
    
let url = "https://api.apidash.dev/io/img"


AF.upload(multipartFormData: multipartFormData, to: url, method: .post)

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
              requestModelPost7,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });
      test('POST 8', () {
        const expectedCode = r"""
import Foundation
import Alamofire
let multipartFormData = MultipartFormData()
    multipartFormData.append(Data("API".utf8), withName: "text")    
    multipartFormData.append(Data("|".utf8), withName: "sep")    
    multipartFormData.append(Data("3".utf8), withName: "times")    
let url = "https://api.apidash.dev/io/form?size=2&len=3"


AF.upload(multipartFormData: multipartFormData, to: url, method: .post)

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
              requestModelPost8,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });
      test('POST 9', () {
        const expectedCode = r"""
import Foundation
import Alamofire
let multipartFormData = MultipartFormData()
    multipartFormData.append(Data("xyz".utf8), withName: "token")    
    
let fileURL = URL(fileURLWithPath: "/Documents/up/1.png")
multipartFormData.append(fileURL, withName: "imfile", fileName: "1.png", mimeType: "application/octet-stream")
    
let url = "https://api.apidash.dev/io/img?size=2&len=3"


AF.upload(multipartFormData: multipartFormData, to: url, method: .post, headers: ["User-Agent": "Test Agent", "Keep-Alive": "true"])

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
              requestModelPost9,
              SupportedUriSchemes.https,
            ),
            expectedCode);
     });
      test('POST 10', () {
        const expectedCode = r'''
import Foundation
import Alamofire
let jsonString = """
{\n\"text\": \"I LOVE Flutter\"\n}
"""
let jsonData = jsonString.data(using: .utf8)
let url = "https://api.apidash.dev/case/lower?size=2&len=3"


AF.upload(jsonData!, to: url, method: .post, headers: ["Content-Type": "application/json; charset=utf-8"])

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

dispatchMain()''';

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftAlamofire,
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
import Alamofire
let jsonString = """
{\n\"name\": \"morpheus\",\n\"job\": \"zion resident\"\n}
"""
let jsonData = jsonString.data(using: .utf8)
let url = "https://reqres.in/api/users/2"


AF.upload(jsonData!, to: url, method: .put, headers: ["Content-Type": "application/json"])

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

dispatchMain()''';

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftAlamofire,
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
import Alamofire
let jsonString = """
{\n\"name\": \"marfeus\",\n\"job\": \"accountant\"\n}
"""
let jsonData = jsonString.data(using: .utf8)
let url = "https://reqres.in/api/users/2"


AF.upload(jsonData!, to: url, method: .patch, headers: ["Content-Type": "application/json"])

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

dispatchMain()''';

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftAlamofire,
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
        const expectedCode = r"""
import Foundation
import Alamofire
let url = "https://reqres.in/api/users/2"


AF.request(url, method: .delete)

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
              requestModelDelete1,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });

      test('DELETE 2', () {
        const expectedCode = r'''
import Foundation
import Alamofire
let jsonString = """
{\n\"name\": \"marfeus\",\n\"job\": \"accountant\"\n}
"""
let jsonData = jsonString.data(using: .utf8)
let url = "https://reqres.in/api/users/2"


AF.upload(jsonData!, to: url, method: .delete, headers: ["Content-Type": "application/json"])

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

dispatchMain()''';

        expect(
            codeGen.getCode(
              CodegenLanguage.swiftAlamofire,
              requestModelDelete2,
              SupportedUriSchemes.https,
            ),
            expectedCode);
      });
    },
     
  );
}
