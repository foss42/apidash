import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';
import '../models/request_models.dart';

void main() {
  final codeGen = Codegen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""using HTTP

url = "https://api.apidash.dev"

response = HTTP.request("GET", url, status_exception=false)

println("Status Code: $(response.status)")
println("Response Body: \n$(String(response.body))")
""";
      expect(
        codeGen.getCode(
          CodegenLanguage.juliaHttp,
          requestModelGet1,
          SupportedUriSchemes.https,
        ),
        expectedCode,
      );
    });
    test('GET 2', () {
      const expectedCode = r"""using HTTP

url = "https://api.apidash.dev/country/data"

params = Dict(
    "code" =>["US"],
)

response = HTTP.request("GET", url, query=params, status_exception=false)

println("Status Code: $(response.status)")
println("Response Body: \n$(String(response.body))")
""";
      expect(
        codeGen.getCode(
          CodegenLanguage.juliaHttp,
          requestModelGet2,
          SupportedUriSchemes.https,
        ),
        expectedCode,
      );
    });
    test('GET 3', () {
      const expectedCode = r"""using HTTP

url = "https://api.apidash.dev/country/filtercodes"

params = Dict(
    "country" =>["United States","India"],
)

response = HTTP.request("GET", url, query=params, status_exception=false)

println("Status Code: $(response.status)")
println("Response Body: \n$(String(response.body))")
""";
      expect(
        codeGen.getCode(
          CodegenLanguage.juliaHttp,
          requestModelGet3,
          SupportedUriSchemes.https,
        ),
        expectedCode,
      );
    });
    test('GET 4', () {
      const expectedCode = r"""using HTTP

url = "https://api.apidash.dev/humanize/social"

params = Dict(
    "num" =>["8700000"],
    "digits" =>["3"],
    "system" =>["SS"],
    "add_space" =>["true"],
    "trailing_zeros" =>["true"],
)

response = HTTP.request("GET", url, query=params, status_exception=false)

println("Status Code: $(response.status)")
println("Response Body: \n$(String(response.body))")
""";
      expect(
        codeGen.getCode(
          CodegenLanguage.juliaHttp,
          requestModelGet4,
          SupportedUriSchemes.https,
        ),
        expectedCode,
      );
    });

    test('GET 5', () {
      const expectedCode = r"""using HTTP

url = "https://api.github.com/repos/foss42/apidash"

headers = Dict(
    "User-Agent" => "Test Agent",
)

response = HTTP.request("GET", url, headers=headers, status_exception=false)

println("Status Code: $(response.status)")
println("Response Body: \n$(String(response.body))")
""";
      expect(
        codeGen.getCode(
          CodegenLanguage.juliaHttp,
          requestModelGet5,
          SupportedUriSchemes.https,
        ),
        expectedCode,
      );
    });

    test('GET 6', () {
      const expectedCode = r"""using HTTP

url = "https://api.github.com/repos/foss42/apidash"

params = Dict(
    "raw" =>["true"],
)

headers = Dict(
    "User-Agent" => "Test Agent",
)

response = HTTP.request("GET", url, headers=headers, query=params, status_exception=false)

println("Status Code: $(response.status)")
println("Response Body: \n$(String(response.body))")
""";
      expect(
        codeGen.getCode(
          CodegenLanguage.juliaHttp,
          requestModelGet6,
          SupportedUriSchemes.https,
        ),
        expectedCode,
      );
    });

    test('GET 7', () {
      const expectedCode = r"""using HTTP

url = "https://api.apidash.dev"

response = HTTP.request("GET", url, status_exception=false)

println("Status Code: $(response.status)")
println("Response Body: \n$(String(response.body))")
""";
      expect(
        codeGen.getCode(
          CodegenLanguage.juliaHttp,
          requestModelGet7,
          SupportedUriSchemes.https,
        ),
        expectedCode,
      );
    });

    test('GET 8', () {
      const expectedCode = r"""using HTTP

url = "https://api.github.com/repos/foss42/apidash"

params = Dict(
    "raw" =>["true"],
)

headers = Dict(
    "User-Agent" => "Test Agent",
)

response = HTTP.request("GET", url, headers=headers, query=params, status_exception=false)

println("Status Code: $(response.status)")
println("Response Body: \n$(String(response.body))")
""";
      expect(
        codeGen.getCode(
          CodegenLanguage.juliaHttp,
          requestModelGet8,
          SupportedUriSchemes.https,
        ),
        expectedCode,
      );
    });

    test('GET 9', () {
      const expectedCode = r"""using HTTP

url = "https://api.apidash.dev/humanize/social"

params = Dict(
    "num" =>["8700000"],
    "add_space" =>["true"],
)

response = HTTP.request("GET", url, query=params, status_exception=false)

println("Status Code: $(response.status)")
println("Response Body: \n$(String(response.body))")
""";
      expect(
        codeGen.getCode(
          CodegenLanguage.juliaHttp,
          requestModelGet9,
          SupportedUriSchemes.https,
        ),
        expectedCode,
      );
    });

    test('GET 10', () {
      const expectedCode = r"""using HTTP

url = "https://api.apidash.dev/humanize/social"

headers = Dict(
    "User-Agent" => "Test Agent",
)

response = HTTP.request("GET", url, headers=headers, status_exception=false)

println("Status Code: $(response.status)")
println("Response Body: \n$(String(response.body))")
""";
      expect(
        codeGen.getCode(
          CodegenLanguage.juliaHttp,
          requestModelGet10,
          SupportedUriSchemes.https,
        ),
        expectedCode,
      );
    });

    test('GET 11', () {
      const expectedCode = r"""using HTTP

url = "https://api.apidash.dev/humanize/social"

params = Dict(
    "num" =>["8700000"],
    "digits" =>["3"],
)

headers = Dict(
    "User-Agent" => "Test Agent",
)

response = HTTP.request("GET", url, headers=headers, query=params, status_exception=false)

println("Status Code: $(response.status)")
println("Response Body: \n$(String(response.body))")
""";
      expect(
        codeGen.getCode(
          CodegenLanguage.juliaHttp,
          requestModelGet11,
          SupportedUriSchemes.https,
        ),
        expectedCode,
      );
    });

    test('GET 12', () {
      const expectedCode = r"""using HTTP

url = "https://api.apidash.dev/humanize/social"

response = HTTP.request("GET", url, status_exception=false)

println("Status Code: $(response.status)")
println("Response Body: \n$(String(response.body))")
""";
      expect(
        codeGen.getCode(
          CodegenLanguage.juliaHttp,
          requestModelGet12,
          SupportedUriSchemes.https,
        ),
        expectedCode,
      );
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""using HTTP

url = "https://api.apidash.dev"

response = HTTP.request("HEAD", url, status_exception=false)

println("Status Code: $(response.status)")
println("Response Body: \n$(String(response.body))")
""";
      expect(
        codeGen.getCode(
          CodegenLanguage.juliaHttp,
          requestModelHead1,
          SupportedUriSchemes.https,
        ),
        expectedCode,
      );
    });

    test('HEAD 2', () {
      const expectedCode = r"""using HTTP

url = "http://api.apidash.dev"

response = HTTP.request("HEAD", url, status_exception=false)

println("Status Code: $(response.status)")
println("Response Body: \n$(String(response.body))")
""";
      expect(
        codeGen.getCode(
          CodegenLanguage.juliaHttp,
          requestModelHead2,
          SupportedUriSchemes.http,
        ),
        expectedCode,
      );
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r'''using HTTP

url = "https://api.apidash.dev/case/lower"

payload = """{
"text": "I LOVE Flutter"
}"""

headers = Dict(
    "content-type" => "text/plain",
)

response = HTTP.request("POST", url, headers=headers, body=payload, status_exception=false)

println("Status Code: $(response.status)")
println("Response Body: \n$(String(response.body))")
''';
      expect(
        codeGen.getCode(
          CodegenLanguage.juliaHttp,
          requestModelPost1,
          SupportedUriSchemes.https,
        ),
        expectedCode,
      );
    });

    test('POST 2', () {
      const expectedCode = r'''using HTTP

url = "https://api.apidash.dev/case/lower"

payload = """{
"text": "I LOVE Flutter",
"flag": null,
"male": true,
"female": false,
"no": 1.2,
"arr": ["null", "true", "false", null]
}"""

headers = Dict(
    "content-type" => "application/json",
)

response = HTTP.request("POST", url, headers=headers, body=payload, status_exception=false)

println("Status Code: $(response.status)")
println("Response Body: \n$(String(response.body))")
''';
      expect(
        codeGen.getCode(
          CodegenLanguage.juliaHttp,
          requestModelPost2,
          SupportedUriSchemes.https,
        ),
        expectedCode,
      );
    });
    test('POST 3', () {
      const expectedCode = r'''using HTTP

url = "https://api.apidash.dev/case/lower"

payload = """{
"text": "I LOVE Flutter"
}"""

headers = Dict(
    "User-Agent" => "Test Agent",
    "content-type" => "application/json",
)

response = HTTP.request("POST", url, headers=headers, body=payload, status_exception=false)

println("Status Code: $(response.status)")
println("Response Body: \n$(String(response.body))")
''';
      expect(
        codeGen.getCode(
          CodegenLanguage.juliaHttp,
          requestModelPost3,
          SupportedUriSchemes.https,
        ),
        expectedCode,
      );
    });

    test('POST 4', () {
      const expectedCode = r"""using HTTP

url = "https://api.apidash.dev/io/form"

data = Dict(
    "text" => "API",
    "sep" => "|",
    "times" => "3",
)

payload = HTTP.Form(data)

response = HTTP.request("POST", url, body=payload, status_exception=false)

println("Status Code: $(response.status)")
println("Response Body: \n$(String(response.body))")
""";
      expect(
        codeGen.getCode(
          CodegenLanguage.juliaHttp,
          requestModelPost4,
          SupportedUriSchemes.https,
        ),
        expectedCode,
      );
    });

    test('POST 5', () {
      const expectedCode = r"""using HTTP

url = "https://api.apidash.dev/io/form"

data = Dict(
    "text" => "API",
    "sep" => "|",
    "times" => "3",
)

payload = HTTP.Form(data)

headers = Dict(
    "User-Agent" => "Test Agent",
)

response = HTTP.request("POST", url, headers=headers, body=payload, status_exception=false)

println("Status Code: $(response.status)")
println("Response Body: \n$(String(response.body))")
""";
      expect(
        codeGen.getCode(
          CodegenLanguage.juliaHttp,
          requestModelPost5,
          SupportedUriSchemes.https,
        ),
        expectedCode,
      );
    });
    test('POST 6', () {
      const expectedCode = r"""using HTTP

url = "https://api.apidash.dev/io/img"

data = Dict(
    "token" => "xyz",
    "imfile" => open("/Documents/up/1.png"),
)

payload = HTTP.Form(data)

response = HTTP.request("POST", url, body=payload, status_exception=false)

println("Status Code: $(response.status)")
println("Response Body: \n$(String(response.body))")
""";
      expect(
        codeGen.getCode(
          CodegenLanguage.juliaHttp,
          requestModelPost6,
          SupportedUriSchemes.https,
        ),
        expectedCode,
      );
    });
    test('POST 7', () {
      const expectedCode = r"""using HTTP

url = "https://api.apidash.dev/io/img"

data = Dict(
    "token" => "xyz",
    "imfile" => open("/Documents/up/1.png"),
)

payload = HTTP.Form(data)

response = HTTP.request("POST", url, body=payload, status_exception=false)

println("Status Code: $(response.status)")
println("Response Body: \n$(String(response.body))")
""";
      expect(
        codeGen.getCode(
          CodegenLanguage.juliaHttp,
          requestModelPost7,
          SupportedUriSchemes.https,
        ),
        expectedCode,
      );
    });
    test('POST 8', () {
      const expectedCode = r"""using HTTP

url = "https://api.apidash.dev/io/form"

params = Dict(
    "size" =>["2"],
    "len" =>["3"],
)

data = Dict(
    "text" => "API",
    "sep" => "|",
    "times" => "3",
)

payload = HTTP.Form(data)

response = HTTP.request("POST", url, body=payload, query=params, status_exception=false)

println("Status Code: $(response.status)")
println("Response Body: \n$(String(response.body))")
""";
      expect(
        codeGen.getCode(
          CodegenLanguage.juliaHttp,
          requestModelPost8,
          SupportedUriSchemes.https,
        ),
        expectedCode,
      );
    });
    test('POST 9', () {
      const expectedCode = r"""using HTTP

url = "https://api.apidash.dev/io/img"

params = Dict(
    "size" =>["2"],
    "len" =>["3"],
)

data = Dict(
    "token" => "xyz",
    "imfile" => open("/Documents/up/1.png"),
)

payload = HTTP.Form(data)

headers = Dict(
    "User-Agent" => "Test Agent",
    "Keep-Alive" => "true",
)

response = HTTP.request("POST", url, headers=headers, body=payload, query=params, status_exception=false)

println("Status Code: $(response.status)")
println("Response Body: \n$(String(response.body))")
""";
      expect(
        codeGen.getCode(
          CodegenLanguage.juliaHttp,
          requestModelPost9,
          SupportedUriSchemes.https,
        ),
        expectedCode,
      );
    });
  });
  group('PUT Request', () {
    test('PUT 1', () {
      const expectedCode = r'''using HTTP

url = "https://reqres.in/api/users/2"

payload = """{
"name": "morpheus",
"job": "zion resident"
}"""

headers = Dict(
    "x-api-key" => "reqres-free-v1",
    "content-type" => "application/json",
)

response = HTTP.request("PUT", url, headers=headers, body=payload, status_exception=false)

println("Status Code: $(response.status)")
println("Response Body: \n$(String(response.body))")
''';
      expect(
        codeGen.getCode(
          CodegenLanguage.juliaHttp,
          requestModelPut1,
          SupportedUriSchemes.https,
        ),
        expectedCode,
      );
    });
  });
  group('PATCH Request', () {
    test('PATCH 1', () {
      const expectedCode = r'''using HTTP

url = "https://reqres.in/api/users/2"

payload = """{
"name": "marfeus",
"job": "accountant"
}"""

headers = Dict(
    "x-api-key" => "reqres-free-v1",
    "content-type" => "application/json",
)

response = HTTP.request("PATCH", url, headers=headers, body=payload, status_exception=false)

println("Status Code: $(response.status)")
println("Response Body: \n$(String(response.body))")
''';
      expect(
        codeGen.getCode(
          CodegenLanguage.juliaHttp,
          requestModelPatch1,
          SupportedUriSchemes.https,
        ),
        expectedCode,
      );
    });
  });
  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode = r"""using HTTP

url = "https://reqres.in/api/users/2"

headers = Dict(
    "x-api-key" => "reqres-free-v1",
)

response = HTTP.request("DELETE", url, headers=headers, status_exception=false)

println("Status Code: $(response.status)")
println("Response Body: \n$(String(response.body))")
""";
      expect(
        codeGen.getCode(
          CodegenLanguage.juliaHttp,
          requestModelDelete1,
          SupportedUriSchemes.https,
        ),
        expectedCode,
      );
    });
    test('DELETE 2', () {
      const expectedCode = r'''using HTTP

url = "https://reqres.in/api/users/2"

payload = """{
"name": "marfeus",
"job": "accountant"
}"""

headers = Dict(
    "x-api-key" => "reqres-free-v1",
    "content-type" => "application/json",
)

response = HTTP.request("DELETE", url, headers=headers, body=payload, status_exception=false)

println("Status Code: $(response.status)")
println("Response Body: \n$(String(response.body))")
''';
      expect(
        codeGen.getCode(
          CodegenLanguage.juliaHttp,
          requestModelDelete2,
          SupportedUriSchemes.https,
        ),
        expectedCode,
      );
    });
  });

  group('Escaping', () {
    test('Quotes and newlines in params and headers', () {
      const expectedCode = r"""using HTTP

url = "https://api.apidash.dev/case/lower"

params = Dict(
    "it's" =>["say \"hi\"\nC:\\new"],
)

headers = Dict(
    "If-Match" => "\"abc123\"",
)

response = HTTP.request("GET", url, headers=headers, query=params, status_exception=false)

println("Status Code: $(response.status)")
println("Response Body: \n$(String(response.body))")
""";
      expect(
        codeGen.getCode(
          CodegenLanguage.juliaHttp,
          requestModelEscape1,
          SupportedUriSchemes.https,
          boundary: "b",
        ),
        expectedCode,
      );
    });

    test('Escaped quotes inside a JSON body', () {
      const expectedCode = r"""using HTTP

url = "https://api.apidash.dev/case/lower"

payload = "{\n\"text\": \"say \\\"true\\\" or null\",\n\"path\": \"a\\/b\",\n\"flag\": false\n}"

headers = Dict(
    "content-type" => "application/json",
)

response = HTTP.request("POST", url, headers=headers, body=payload, status_exception=false)

println("Status Code: $(response.status)")
println("Response Body: \n$(String(response.body))")
""";
      expect(
        codeGen.getCode(
          CodegenLanguage.juliaHttp,
          requestModelEscape3,
          SupportedUriSchemes.https,
          boundary: "b",
        ),
        expectedCode,
      );
    });

    test('Quotes and backslashes in form data', () {
      const expectedCode = r"""using HTTP

url = "https://api.apidash.dev/io/form"

data = Dict(
    "note" => "say \"hi\"\nbye",
    "file" => open("C:\\Users\\new\\file.txt"),
)

payload = HTTP.Form(data)

response = HTTP.request("POST", url, body=payload, status_exception=false)

println("Status Code: $(response.status)")
println("Response Body: \n$(String(response.body))")
""";
      expect(
        codeGen.getCode(
          CodegenLanguage.juliaHttp,
          requestModelEscape4,
          SupportedUriSchemes.https,
          boundary: "b",
        ),
        expectedCode,
      );
    });

    test('Quote in the URL', () {
      const expectedCode = r"""using HTTP

url = "https://api.apidash.dev/it's/data"

response = HTTP.request("GET", url, status_exception=false)

println("Status Code: $(response.status)")
println("Response Body: \n$(String(response.body))")
""";
      expect(
        codeGen.getCode(
          CodegenLanguage.juliaHttp,
          requestModelEscape5,
          SupportedUriSchemes.https,
          boundary: "b",
        ),
        expectedCode,
      );
    });

    test('Text body with trailing spaces and shared indentation', () {
      const expectedCode = r"""using HTTP

url = "https://api.apidash.dev/case/lower"

payload = "  name:  \n  value"

headers = Dict(
    "content-type" => "text/plain",
)

response = HTTP.request("POST", url, headers=headers, body=payload, status_exception=false)

println("Status Code: $(response.status)")
println("Response Body: \n$(String(response.body))")
""";
      expect(
        codeGen.getCode(
          CodegenLanguage.juliaHttp,
          requestModelEscape6,
          SupportedUriSchemes.https,
          boundary: "b",
        ),
        expectedCode,
      );
    });

    test('Dollar signs in a JSON body', () {
      const expectedCode = r"""using HTTP

url = "https://api.apidash.dev/case/lower"

payload = "{\n\"cmd\": \"echo \$HOME \${x}\",\n\"price\": \"\$5\"\n}"

headers = Dict(
    "content-type" => "application/json",
)

response = HTTP.request("POST", url, headers=headers, body=payload, status_exception=false)

println("Status Code: $(response.status)")
println("Response Body: \n$(String(response.body))")
""";
      expect(
        codeGen.getCode(
          CodegenLanguage.juliaHttp,
          requestModelEscape7,
          SupportedUriSchemes.https,
          boundary: "b",
        ),
        expectedCode,
      );
    });

    test('Windows line endings in a text body', () {
      const expectedCode = r"""using HTTP

url = "https://api.apidash.dev/case/lower"

payload = "line 1\r\nline 2"

headers = Dict(
    "content-type" => "text/plain",
)

response = HTTP.request("POST", url, headers=headers, body=payload, status_exception=false)

println("Status Code: $(response.status)")
println("Response Body: \n$(String(response.body))")
""";
      expect(
        codeGen.getCode(
          CodegenLanguage.juliaHttp,
          requestModelEscape9,
          SupportedUriSchemes.https,
          boundary: "b",
        ),
        expectedCode,
      );
    });
  });
}
