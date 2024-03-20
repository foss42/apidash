import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:test/test.dart';
import '../request_models.dart';

void main() {
  final codeGen = Codegen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.apidash.dev"


response = HTTP.get(url)

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(
          codeGen.getCode(CodegenLanguage.juliaHttp, requestModelGet1, "https"),
          expectedCode);
    });
    test('GET 2', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.apidash.dev/country/data"


params = Dict(
           "code"=> "US"
         )

response = HTTP.get(url, query=params)

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(
          codeGen.getCode(CodegenLanguage.juliaHttp, requestModelGet2, "https"),
          expectedCode);
    });
    test('GET 3', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.apidash.dev/country/data"


params = Dict(
           "code"=> "IND"
         )

response = HTTP.get(url, query=params)

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(
          codeGen.getCode(CodegenLanguage.juliaHttp, requestModelGet3, "https"),
          expectedCode);
    });
    test('GET 4', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.apidash.dev/humanize/social"


params = Dict(
           "num"=> "8700000",
           "digits"=> "3",
           "system"=> "SS",
           "add_space"=> "true",
           "trailing_zeros"=> "true"
         )

response = HTTP.get(url, query=params)

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(
          codeGen.getCode(CodegenLanguage.juliaHttp, requestModelGet4, "https"),
          expectedCode);
    });

    test('GET 5', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.github.com/repos/foss42/apidash"


headers = Dict(
            "User-Agent"=> "Test Agent"
          )

response = HTTP.get(url, headers=headers)

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(
          codeGen.getCode(CodegenLanguage.juliaHttp, requestModelGet5, "https"),
          expectedCode);
    });

    test('GET 6', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.github.com/repos/foss42/apidash"


params = Dict(
           "raw"=> "true"
         )

headers = Dict(
            "User-Agent"=> "Test Agent"
          )

response = HTTP.get(url, query=params, headers=headers)

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(
          codeGen.getCode(CodegenLanguage.juliaHttp, requestModelGet6, "https"),
          expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.apidash.dev"


response = HTTP.get(url)

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(
          codeGen.getCode(CodegenLanguage.juliaHttp, requestModelGet7, "https"),
          expectedCode);
    });

    test('GET 8', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.github.com/repos/foss42/apidash"


params = Dict(
           "raw"=> "true"
         )

headers = Dict(
            "User-Agent"=> "Test Agent"
          )

response = HTTP.get(url, query=params, headers=headers)

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(
          codeGen.getCode(CodegenLanguage.juliaHttp, requestModelGet8, "https"),
          expectedCode);
    });

    test('GET 9', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.apidash.dev/humanize/social"


params = Dict(
           "num"=> "8700000",
           "add_space"=> "true"
         )

response = HTTP.get(url, query=params)

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(
          codeGen.getCode(CodegenLanguage.juliaHttp, requestModelGet9, "https"),
          expectedCode);
    });

    test('GET 10', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.apidash.dev/humanize/social"


headers = Dict(
            "User-Agent"=> "Test Agent"
          )

response = HTTP.get(url, headers=headers)

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.juliaHttp, requestModelGet10, "https"),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.apidash.dev/humanize/social"


params = Dict(
           "num"=> "8700000",
           "digits"=> "3"
         )

headers = Dict(
            "User-Agent"=> "Test Agent"
          )

response = HTTP.get(url, query=params, headers=headers)

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.juliaHttp, requestModelGet11, "https"),
          expectedCode);
    });

    test('GET 12', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.apidash.dev/humanize/social"


response = HTTP.get(url)

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.juliaHttp, requestModelGet12, "https"),
          expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.apidash.dev"


response = HTTP.head(url)

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.juliaHttp, requestModelHead1, "https"),
          expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.apidash.dev"


response = HTTP.head(url)

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.juliaHttp, requestModelHead2, "https"),
          expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.apidash.dev/case/lower"


payload = Dict(
"text"=> "I LOVE Flutter"
)

headers = Dict(
            "content-type"=> "text/plain"
          )

response = HTTP.post(url, payload=payload, headers=headers)

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.juliaHttp, requestModelPost1, "https"),
          expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.apidash.dev/case/lower"


payload = Dict(
"text"=> "I LOVE Flutter",
"flag"=> null,
"male"=> true,
"female"=> false,
"no"=> 1.2,
"arr"=> ["null", "true", "false", null]
)

response = HTTP.post(url, JSON.json(payload))

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.juliaHttp, requestModelPost2, "https"),
          expectedCode);
    });
    test('POST 3', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.apidash.dev/case/lower"


payload = Dict(
"text"=> "I LOVE Flutter"
)

headers = Dict(
            "User-Agent"=> "Test Agent"
          )

response = HTTP.post(url, JSON.json(payload), headers=headers)

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.juliaHttp, requestModelPost3, "https"),
          expectedCode);
    });
    test('POST 4', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.apidash.dev/case/lower"


payload = Dict(
"text"=> "I LOVE Flutter"
)

headers = Dict(
            "User-Agent"=> "Test Agent"
          )

response = HTTP.post(url, JSON.json(payload), headers=headers)

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.juliaHttp, requestModelPost3, "https"),
          expectedCode);
    });
    test('POST 5', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.apidash.dev/case/lower"


payload = Dict(
"text"=> "I LOVE Flutter"
)

headers = Dict(
            "User-Agent"=> "Test Agent"
          )

response = HTTP.post(url, JSON.json(payload), headers=headers)

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.juliaHttp, requestModelPost3, "https"),
          expectedCode);
    });
    test('POST 5', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.apidash.dev/case/lower"


payload = Dict(
"text"=> "I LOVE Flutter"
)

headers = Dict(
            "User-Agent"=> "Test Agent"
          )

response = HTTP.post(url, JSON.json(payload), headers=headers)

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.juliaHttp, requestModelPost3, "https"),
          expectedCode);
    });
    test('POST 7', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.apidash.dev/case/lower"


payload = Dict(
"text"=> "I LOVE Flutter"
)

headers = Dict(
            "User-Agent"=> "Test Agent"
          )

response = HTTP.post(url, JSON.json(payload), headers=headers)

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.juliaHttp, requestModelPost3, "https"),
          expectedCode);
    });
    test('POST 8', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.apidash.dev/case/lower"


payload = Dict(
"text"=> "I LOVE Flutter"
)

headers = Dict(
            "User-Agent"=> "Test Agent"
          )

response = HTTP.post(url, JSON.json(payload), headers=headers)

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.juliaHttp, requestModelPost3, "https"),
          expectedCode);
    });
    test('POST 9', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.apidash.dev/case/lower"


payload = Dict(
"text"=> "I LOVE Flutter"
)

headers = Dict(
            "User-Agent"=> "Test Agent"
          )

response = HTTP.post(url, JSON.json(payload), headers=headers)

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.juliaHttp, requestModelPost3, "https"),
          expectedCode);
    });
  });
  group('PUT Request', () {
    test('PUT 1', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://reqres.in/api/users/2"


payload = Dict(
"name"=> "morpheus",
"job"=> "zion resident"
)

response = HTTP.put(url, JSON.json(payload))

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(
          codeGen.getCode(CodegenLanguage.juliaHttp, requestModelPut1, "https"),
          expectedCode);
    });
  });
  group('PATCH Request', () {
    test('PATCH 1', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://reqres.in/api/users/2"


payload = Dict(
"name"=> "marfeus",
"job"=> "accountant"
)

response = HTTP.patch(url, JSON.json(payload))

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.juliaHttp, requestModelPatch1, "https"),
          expectedCode);
    });
  });
  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://reqres.in/api/users/2"


response = HTTP.delete(url)

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.juliaHttp, requestModelDelete1, "https"),
          expectedCode);
    });
    test('DELETE 2', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://reqres.in/api/users/2"


payload = Dict(
"name"=> "marfeus",
"job"=> "accountant"
)

response = HTTP.delete(url, JSON.json(payload))

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.juliaHttp, requestModelDelete2, "https"),
          expectedCode);
    });
  });
}
