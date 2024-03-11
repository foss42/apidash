import 'package:apidash/codegen/python/requests.dart';
import '../request_models.dart';
import 'package:test/test.dart';

void main() {
  final pythonRequestsCodeGen = PythonRequestsCodeGen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""import requests

url = 'https://api.apidash.dev'

response = requests.get(url)

print('Status Code:', response.status_code)
print('Response Body:', response.text)
""";
      expect(pythonRequestsCodeGen.getCode(requestModelGet1, "https"),
          expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r"""import requests

url = 'https://api.apidash.dev/country/data'

params = {
  "code": "US"
}

response = requests.get(url, params=params)

print('Status Code:', response.status_code)
print('Response Body:', response.text)
""";
      expect(pythonRequestsCodeGen.getCode(requestModelGet2, "https"),
          expectedCode);
    });

    test('GET 3', () {
      const expectedCode = r"""import requests

url = 'https://api.apidash.dev/country/data'

params = {
  "code": "IND"
}

response = requests.get(url, params=params)

print('Status Code:', response.status_code)
print('Response Body:', response.text)
""";
      expect(pythonRequestsCodeGen.getCode(requestModelGet3, "https"),
          expectedCode);
    });

    test('GET 4', () {
      const expectedCode = r"""import requests

url = 'https://api.apidash.dev/humanize/social'

params = {
  "num": "8700000",
  "digits": "3",
  "system": "SS",
  "add_space": "true",
  "trailing_zeros": "true"
}

response = requests.get(url, params=params)

print('Status Code:', response.status_code)
print('Response Body:', response.text)
""";
      expect(pythonRequestsCodeGen.getCode(requestModelGet4, "https"),
          expectedCode);
    });

    test('GET 5', () {
      const expectedCode = r"""import requests

url = 'https://api.github.com/repos/foss42/apidash'

headers = {
  "User-Agent": "Test Agent"
}

response = requests.get(url, headers=headers)

print('Status Code:', response.status_code)
print('Response Body:', response.text)
""";
      expect(pythonRequestsCodeGen.getCode(requestModelGet5, "https"),
          expectedCode);
    });

    test('GET 6', () {
      const expectedCode = r"""import requests

url = 'https://api.github.com/repos/foss42/apidash'

params = {
  "raw": "true"
}

headers = {
  "User-Agent": "Test Agent"
}

response = requests.get(url, params=params, headers=headers)

print('Status Code:', response.status_code)
print('Response Body:', response.text)
""";
      expect(pythonRequestsCodeGen.getCode(requestModelGet6, "https"),
          expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r"""import requests

url = 'https://api.apidash.dev'

response = requests.get(url)

print('Status Code:', response.status_code)
print('Response Body:', response.text)
""";
      expect(pythonRequestsCodeGen.getCode(requestModelGet7, "https"),
          expectedCode);
    });

    test('GET 8', () {
      const expectedCode = r"""import requests

url = 'https://api.github.com/repos/foss42/apidash'

params = {
  "raw": "true"
}

headers = {
  "User-Agent": "Test Agent"
}

response = requests.get(url, params=params, headers=headers)

print('Status Code:', response.status_code)
print('Response Body:', response.text)
""";
      expect(pythonRequestsCodeGen.getCode(requestModelGet8, "https"),
          expectedCode);
    });

    test('GET 9', () {
      const expectedCode = r"""import requests

url = 'https://api.apidash.dev/humanize/social'

params = {
  "num": "8700000",
  "add_space": "true"
}

response = requests.get(url, params=params)

print('Status Code:', response.status_code)
print('Response Body:', response.text)
""";
      expect(pythonRequestsCodeGen.getCode(requestModelGet9, "https"),
          expectedCode);
    });

    test('GET 10', () {
      const expectedCode = r"""import requests

url = 'https://api.apidash.dev/humanize/social'

headers = {
  "User-Agent": "Test Agent"
}

response = requests.get(url, headers=headers)

print('Status Code:', response.status_code)
print('Response Body:', response.text)
""";
      expect(
          pythonRequestsCodeGen.getCode(
            requestModelGet10,
            "https",
          ),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode = r"""import requests

url = 'https://api.apidash.dev/humanize/social'

params = {
  "num": "8700000",
  "digits": "3"
}

headers = {
  "User-Agent": "Test Agent"
}

response = requests.get(url, params=params, headers=headers)

print('Status Code:', response.status_code)
print('Response Body:', response.text)
""";
      expect(pythonRequestsCodeGen.getCode(requestModelGet11, "https"),
          expectedCode);
    });

    test('GET 12', () {
      const expectedCode = r"""import requests

url = 'https://api.apidash.dev/humanize/social'

response = requests.get(url)

print('Status Code:', response.status_code)
print('Response Body:', response.text)
""";
      expect(pythonRequestsCodeGen.getCode(requestModelGet12, "https"),
          expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""import requests

url = 'https://api.apidash.dev'

response = requests.head(url)

print('Status Code:', response.status_code)
print('Response Body:', response.text)
""";
      expect(pythonRequestsCodeGen.getCode(requestModelHead1, "https"),
          expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""import requests

url = 'http://api.apidash.dev'

response = requests.head(url)

print('Status Code:', response.status_code)
print('Response Body:', response.text)
""";
      expect(pythonRequestsCodeGen.getCode(requestModelHead2, "http"),
          expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r"""import requests

url = 'https://api.apidash.dev/case/lower'

payload = r'''{
"text": "I LOVE Flutter"
}'''

headers = {
  "content-type": "text/plain"
}

response = requests.post(url, data=payload, headers=headers)

print('Status Code:', response.status_code)
print('Response Body:', response.text)
""";
      expect(pythonRequestsCodeGen.getCode(requestModelPost1, "https"),
          expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r"""import requests

url = 'https://api.apidash.dev/case/lower'

payload = {
"text": "I LOVE Flutter",
"flag": None,
"male": True,
"female": False,
"no": 1.2,
"arr": ["null", "true", "false", None]
}

response = requests.post(url, json=payload)

print('Status Code:', response.status_code)
print('Response Body:', response.text)
""";
      expect(pythonRequestsCodeGen.getCode(requestModelPost2, "https"),
          expectedCode);
    });

    test('POST 3', () {
      const expectedCode = r"""import requests

url = 'https://api.apidash.dev/case/lower'

payload = {
"text": "I LOVE Flutter"
}

headers = {
  "User-Agent": "Test Agent"
}

response = requests.post(url, json=payload, headers=headers)

print('Status Code:', response.status_code)
print('Response Body:', response.text)
""";
      expect(pythonRequestsCodeGen.getCode(requestModelPost3, "https"),
          expectedCode);
    });

    test('POST 4', () {
      const expectedCode = r"""import requests
from requests_toolbelt.multipart.encoder import MultipartEncoder

url = 'https://api.apidash.dev/io/form'

payload = MultipartEncoder({
  "text": "API",
  "sep": "|",
  "times": "3",
})

headers = {
  "content-type": payload.content_type
}

response = requests.post(url, data=payload, headers=headers)

print('Status Code:', response.status_code)
print('Response Body:', response.text)
""";
      expect(pythonRequestsCodeGen.getCode(requestModelPost4, "https"),
          expectedCode);
    });

    test('POST 5', () {
      const expectedCode = r"""import requests
from requests_toolbelt.multipart.encoder import MultipartEncoder

url = 'https://api.apidash.dev/io/form'

payload = MultipartEncoder({
  "text": "API",
  "sep": "|",
  "times": "3",
})

headers = {
  "User-Agent": "Test Agent",
  "content-type": payload.content_type
}

response = requests.post(url, data=payload, headers=headers)

print('Status Code:', response.status_code)
print('Response Body:', response.text)
""";
      expect(pythonRequestsCodeGen.getCode(requestModelPost5, "https"),
          expectedCode);
    });

    test('POST 6', () {
      const expectedCode = r"""import requests
from requests_toolbelt.multipart.encoder import MultipartEncoder

url = 'https://api.apidash.dev/io/img'

payload = MultipartEncoder({
  "token": "xyz",
  "imfile": ("1.png", open("/Documents/up/1.png", "rb")),
})

headers = {
  "content-type": payload.content_type
}

response = requests.post(url, data=payload, headers=headers)

print('Status Code:', response.status_code)
print('Response Body:', response.text)
""";
      expect(pythonRequestsCodeGen.getCode(requestModelPost6, "https"),
          expectedCode);
    });

    test('POST 7', () {
      const expectedCode = r"""import requests
from requests_toolbelt.multipart.encoder import MultipartEncoder

url = 'https://api.apidash.dev/io/img'

payload = MultipartEncoder({
  "token": "xyz",
  "imfile": ("1.png", open("/Documents/up/1.png", "rb")),
})

headers = {
  "content-type": payload.content_type
}

response = requests.post(url, data=payload, headers=headers)

print('Status Code:', response.status_code)
print('Response Body:', response.text)
""";
      expect(pythonRequestsCodeGen.getCode(requestModelPost7, "https"),
          expectedCode);
    });

    test('POST 8', () {
      const expectedCode = r"""import requests
from requests_toolbelt.multipart.encoder import MultipartEncoder

url = 'https://api.apidash.dev/io/form'

params = {
  "size": "2",
  "len": "3"
}

payload = MultipartEncoder({
  "text": "API",
  "sep": "|",
  "times": "3",
})

headers = {
  "content-type": payload.content_type
}

response = requests.post(url, params=params, data=payload, headers=headers)

print('Status Code:', response.status_code)
print('Response Body:', response.text)
""";
      expect(pythonRequestsCodeGen.getCode(requestModelPost8, "https"),
          expectedCode);
    });

    test('POST 9', () {
      const expectedCode = r"""import requests
from requests_toolbelt.multipart.encoder import MultipartEncoder

url = 'https://api.apidash.dev/io/img'

params = {
  "size": "2",
  "len": "3"
}

payload = MultipartEncoder({
  "token": "xyz",
  "imfile": ("1.png", open("/Documents/up/1.png", "rb")),
})

headers = {
  "User-Agent": "Test Agent",
  "Keep-Alive": "true",
  "content-type": payload.content_type
}

response = requests.post(url, params=params, data=payload, headers=headers)

print('Status Code:', response.status_code)
print('Response Body:', response.text)
""";
      expect(pythonRequestsCodeGen.getCode(requestModelPost9, "https"),
          expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT 1', () {
      const expectedCode = r"""import requests

url = 'https://reqres.in/api/users/2'

payload = {
"name": "morpheus",
"job": "zion resident"
}

response = requests.put(url, json=payload)

print('Status Code:', response.status_code)
print('Response Body:', response.text)
""";
      expect(pythonRequestsCodeGen.getCode(requestModelPut1, "https"),
          expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH 1', () {
      const expectedCode = r"""import requests

url = 'https://reqres.in/api/users/2'

payload = {
"name": "marfeus",
"job": "accountant"
}

response = requests.patch(url, json=payload)

print('Status Code:', response.status_code)
print('Response Body:', response.text)
""";
      expect(pythonRequestsCodeGen.getCode(requestModelPatch1, "https"),
          expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode = r"""import requests

url = 'https://reqres.in/api/users/2'

response = requests.delete(url)

print('Status Code:', response.status_code)
print('Response Body:', response.text)
""";
      expect(pythonRequestsCodeGen.getCode(requestModelDelete1, "https"),
          expectedCode);
    });

    test('DELETE 2', () {
      const expectedCode = r"""import requests

url = 'https://reqres.in/api/users/2'

payload = {
"name": "marfeus",
"job": "accountant"
}

response = requests.delete(url, json=payload)

print('Status Code:', response.status_code)
print('Response Body:', response.text)
""";
      expect(pythonRequestsCodeGen.getCode(requestModelDelete2, "https"),
          expectedCode);
    });
  });
}
