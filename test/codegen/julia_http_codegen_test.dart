import 'package:apidash/codegen/julia/http.dart';
import '../request_models.dart';
import 'package:test/test.dart';

void main() {
  final juliaHttpClientCodeGen = JuliaHttpClientCodeGen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.foss42.com"


response = HTTP.get(url)

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(juliaHttpClientCodeGen.getCode(requestModelGet1, "https"),
          expectedCode);
    });
    test('GET 2', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.foss42.com/country/data"


params = Dict(
           "code"=> "US"
         )

response = HTTP.get(url, query=params)

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(juliaHttpClientCodeGen.getCode(requestModelGet2, "https"),
          expectedCode);
    });
    test('GET 3', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.foss42.com/country/data"


params = Dict(
           "code"=> "IND"
         )

response = HTTP.get(url, query=params)

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(juliaHttpClientCodeGen.getCode(requestModelGet3, "https"),
          expectedCode);
    });
    test('GET 4', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.foss42.com/humanize/social"


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
      expect(juliaHttpClientCodeGen.getCode(requestModelGet4, "https"),
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
      expect(juliaHttpClientCodeGen.getCode(requestModelGet5, "https"),
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
      expect(juliaHttpClientCodeGen.getCode(requestModelGet6, "https"),
          expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.foss42.com"


response = HTTP.get(url)

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(juliaHttpClientCodeGen.getCode(requestModelGet7, "https"),
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
      expect(juliaHttpClientCodeGen.getCode(requestModelGet8, "https"),
          expectedCode);
    });

    test('GET 9', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.foss42.com/humanize/social"


params = Dict(
           "num"=> "8700000",
           "add_space"=> "true"
         )

response = HTTP.get(url, query=params)

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(juliaHttpClientCodeGen.getCode(requestModelGet9, "https"),
          expectedCode);
    });

    test('GET 10', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.foss42.com/humanize/social"


headers = Dict(
            "User-Agent"=> "Test Agent"
          )

response = HTTP.get(url, headers=headers)

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(juliaHttpClientCodeGen.getCode(requestModelGet10, "https"),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.foss42.com/humanize/social"


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
      expect(juliaHttpClientCodeGen.getCode(requestModelGet11, "https"),
          expectedCode);
    });

    test('GET 12', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.foss42.com/humanize/social"


response = HTTP.get(url)

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(juliaHttpClientCodeGen.getCode(requestModelGet12, "https"),
          expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.foss42.com"


response = HTTP.head(url)

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(juliaHttpClientCodeGen.getCode(requestModelHead1, "https"),
          expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.foss42.com"


response = HTTP.head(url)

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(juliaHttpClientCodeGen.getCode(requestModelHead2, "https"),
          expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.foss42.com/case/lower"


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
      expect(juliaHttpClientCodeGen.getCode(requestModelPost1, "https"),
          expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.foss42.com/case/lower"


payload = Dict(
"text"=> "I LOVE Flutter"
)

response = HTTP.post(url, JSON.json(payload))

println("Status Code:", response.status)
println("Response Body:", String(response.body))
""";
      expect(juliaHttpClientCodeGen.getCode(requestModelPost2, "https"),
          expectedCode);
    });
    test('POST 3', () {
      const expectedCode = r"""using HTTP,JSON

url = "https://api.foss42.com/case/lower"


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
      expect(juliaHttpClientCodeGen.getCode(requestModelPost3, "https"),
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
      expect(juliaHttpClientCodeGen.getCode(requestModelPut1, "https"),
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
      expect(juliaHttpClientCodeGen.getCode(requestModelPatch1, "https"),
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
      expect(juliaHttpClientCodeGen.getCode(requestModelDelete1, "https"),
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
      expect(juliaHttpClientCodeGen.getCode(requestModelDelete2, "https"),
          expectedCode);
    });
  });
}
