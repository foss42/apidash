import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:test/test.dart';
import '../request_models.dart';

void main() {
  final codeGen = Codegen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""import http.client

conn = http.client.HTTPSConnection("api.apidash.dev")
conn.request("GET", "")

res = conn.getresponse()
data = res.read()

print(data.decode("utf-8"))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.pythonHttpClient, requestModelGet1, "https"),
          expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r"""import http.client
from urllib.parse import urlencode

queryParams = {
                "code": "US"
              }
queryParamsStr = '?' + urlencode(queryParams)

conn = http.client.HTTPSConnection("api.apidash.dev")
conn.request("GET", "/country/data" + queryParamsStr)

res = conn.getresponse()
data = res.read()

print(data.decode("utf-8"))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.pythonHttpClient, requestModelGet2, "https"),
          expectedCode);
    });

    test('GET 3', () {
      const expectedCode = r"""import http.client
from urllib.parse import urlencode

queryParams = {
                "code": "IND"
              }
queryParamsStr = '?' + urlencode(queryParams)

conn = http.client.HTTPSConnection("api.apidash.dev")
conn.request("GET", "/country/data" + queryParamsStr)

res = conn.getresponse()
data = res.read()

print(data.decode("utf-8"))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.pythonHttpClient, requestModelGet3, "https"),
          expectedCode);
    });

    test('GET 4', () {
      const expectedCode = r"""import http.client
from urllib.parse import urlencode

queryParams = {
                "num": "8700000",
                "digits": "3",
                "system": "SS",
                "add_space": "true",
                "trailing_zeros": "true"
              }
queryParamsStr = '?' + urlencode(queryParams)

conn = http.client.HTTPSConnection("api.apidash.dev")
conn.request("GET", "/humanize/social" + queryParamsStr)

res = conn.getresponse()
data = res.read()

print(data.decode("utf-8"))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.pythonHttpClient, requestModelGet4, "https"),
          expectedCode);
    });

    test('GET 5', () {
      const expectedCode = r"""import http.client

headers = {
            "User-Agent": "Test Agent"
          }

conn = http.client.HTTPSConnection("api.github.com")
conn.request("GET", "/repos/foss42/apidash",
              headers= headers)

res = conn.getresponse()
data = res.read()

print(data.decode("utf-8"))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.pythonHttpClient, requestModelGet5, "https"),
          expectedCode);
    });

    test('GET 6', () {
      const expectedCode = r"""import http.client
from urllib.parse import urlencode

queryParams = {
                "raw": "true"
              }
queryParamsStr = '?' + urlencode(queryParams)

headers = {
            "User-Agent": "Test Agent"
          }

conn = http.client.HTTPSConnection("api.github.com")
conn.request("GET", "/repos/foss42/apidash" + queryParamsStr,
              headers= headers)

res = conn.getresponse()
data = res.read()

print(data.decode("utf-8"))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.pythonHttpClient, requestModelGet6, "https"),
          expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r"""import http.client

conn = http.client.HTTPSConnection("api.apidash.dev")
conn.request("GET", "")

res = conn.getresponse()
data = res.read()

print(data.decode("utf-8"))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.pythonHttpClient, requestModelGet7, "https"),
          expectedCode);
    });

    test('GET 8', () {
      const expectedCode = r"""import http.client
from urllib.parse import urlencode

queryParams = {
                "raw": "true"
              }
queryParamsStr = '?' + urlencode(queryParams)

headers = {
            "User-Agent": "Test Agent"
          }

conn = http.client.HTTPSConnection("api.github.com")
conn.request("GET", "/repos/foss42/apidash" + queryParamsStr,
              headers= headers)

res = conn.getresponse()
data = res.read()

print(data.decode("utf-8"))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.pythonHttpClient, requestModelGet8, "https"),
          expectedCode);
    });

    test('GET 9', () {
      const expectedCode = r"""import http.client
from urllib.parse import urlencode

queryParams = {
                "num": "8700000",
                "add_space": "true"
              }
queryParamsStr = '?' + urlencode(queryParams)

conn = http.client.HTTPSConnection("api.apidash.dev")
conn.request("GET", "/humanize/social" + queryParamsStr)

res = conn.getresponse()
data = res.read()

print(data.decode("utf-8"))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.pythonHttpClient, requestModelGet9, "https"),
          expectedCode);
    });

    test('GET 10', () {
      const expectedCode = r"""import http.client

headers = {
            "User-Agent": "Test Agent"
          }

conn = http.client.HTTPSConnection("api.apidash.dev")
conn.request("GET", "/humanize/social",
              headers= headers)

res = conn.getresponse()
data = res.read()

print(data.decode("utf-8"))
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.pythonHttpClient,
            requestModelGet10,
            "https",
          ),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode = r"""import http.client
from urllib.parse import urlencode

queryParams = {
                "num": "8700000",
                "digits": "3"
              }
queryParamsStr = '?' + urlencode(queryParams)

headers = {
            "User-Agent": "Test Agent"
          }

conn = http.client.HTTPSConnection("api.apidash.dev")
conn.request("GET", "/humanize/social" + queryParamsStr,
              headers= headers)

res = conn.getresponse()
data = res.read()

print(data.decode("utf-8"))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.pythonHttpClient, requestModelGet11, "https"),
          expectedCode);
    });

    test('GET 12', () {
      const expectedCode = r"""import http.client

conn = http.client.HTTPSConnection("api.apidash.dev")
conn.request("GET", "/humanize/social")

res = conn.getresponse()
data = res.read()

print(data.decode("utf-8"))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.pythonHttpClient, requestModelGet12, "https"),
          expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""import http.client

conn = http.client.HTTPSConnection("api.apidash.dev")
conn.request("HEAD", "")

res = conn.getresponse()
data = res.read()

print(data.decode("utf-8"))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.pythonHttpClient, requestModelHead1, "https"),
          expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""import http.client

conn = http.client.HTTPConnection("api.apidash.dev")
conn.request("HEAD", "")

res = conn.getresponse()
data = res.read()

print(data.decode("utf-8"))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.pythonHttpClient, requestModelHead2, "http"),
          expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r"""import http.client

body = r'''{
"text": "I LOVE Flutter"
}'''

headers = {
            "content-type": "text/plain"
          }

conn = http.client.HTTPSConnection("api.apidash.dev")
conn.request("POST", "/case/lower",
              body= body,
              headers= headers)

res = conn.getresponse()
data = res.read()

print(data.decode("utf-8"))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.pythonHttpClient, requestModelPost1, "https"),
          expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r"""import http.client

body = r'''{
"text": "I LOVE Flutter",
"flag": null,
"male": true,
"female": false,
"no": 1.2,
"arr": ["null", "true", "false", null]
}'''

headers = {
            "content-type": "application/json"
          }

conn = http.client.HTTPSConnection("api.apidash.dev")
conn.request("POST", "/case/lower",
              body= body,
              headers= headers)

res = conn.getresponse()
data = res.read()

print(data.decode("utf-8"))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.pythonHttpClient, requestModelPost2, "https"),
          expectedCode);
    });

    test('POST 3', () {
      const expectedCode = r"""import http.client

body = r'''{
"text": "I LOVE Flutter"
}'''

headers = {
            "User-Agent": "Test Agent",
            "content-type": "application/json"
          }

conn = http.client.HTTPSConnection("api.apidash.dev")
conn.request("POST", "/case/lower",
              body= body,
              headers= headers)

res = conn.getresponse()
data = res.read()

print(data.decode("utf-8"))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.pythonHttpClient, requestModelPost3, "https"),
          expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT 1', () {
      const expectedCode = r"""import http.client

body = r'''{
"name": "morpheus",
"job": "zion resident"
}'''

headers = {
            "content-type": "application/json"
          }

conn = http.client.HTTPSConnection("reqres.in")
conn.request("PUT", "/api/users/2",
              body= body,
              headers= headers)

res = conn.getresponse()
data = res.read()

print(data.decode("utf-8"))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.pythonHttpClient, requestModelPut1, "https"),
          expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH 1', () {
      const expectedCode = r"""import http.client

body = r'''{
"name": "marfeus",
"job": "accountant"
}'''

headers = {
            "content-type": "application/json"
          }

conn = http.client.HTTPSConnection("reqres.in")
conn.request("PATCH", "/api/users/2",
              body= body,
              headers= headers)

res = conn.getresponse()
data = res.read()

print(data.decode("utf-8"))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.pythonHttpClient, requestModelPatch1, "https"),
          expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode = r"""import http.client

conn = http.client.HTTPSConnection("reqres.in")
conn.request("DELETE", "/api/users/2")

res = conn.getresponse()
data = res.read()

print(data.decode("utf-8"))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.pythonHttpClient, requestModelDelete1, "https"),
          expectedCode);
    });

    test('DELETE 2', () {
      const expectedCode = r"""import http.client

body = r'''{
"name": "marfeus",
"job": "accountant"
}'''

headers = {
            "content-type": "application/json"
          }

conn = http.client.HTTPSConnection("reqres.in")
conn.request("DELETE", "/api/users/2",
              body= body,
              headers= headers)

res = conn.getresponse()
data = res.read()

print(data.decode("utf-8"))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.pythonHttpClient, requestModelDelete2, "https"),
          expectedCode);
    });
  });
}
