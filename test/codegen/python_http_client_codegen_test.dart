import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:test/test.dart';
import '../models/request_models.dart';

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

    test('POST 4', () {
      const expectedCode = r"""import http.client
import mimetypes
from codecs import encode

headers = {
  "content-type": "multipart/form-data; boundary=b9826c20-773c-1f0c-814d-a1b3d90cd6b3"
}

def build_data_list(fields):
    dataList = []
    for field in fields:
        name = field.get('name', '')
        value = field.get('value', '')
        type_ = field.get('type', 'text')
        dataList.append(encode('--b9826c20-773c-1f0c-814d-a1b3d90cd6b3'))
        if type_ == 'text':
            dataList.append(encode(f'Content-Disposition: form-data; name="{name}"'))
            dataList.append(encode('Content-Type: text/plain'))
            dataList.append(encode(''))
            dataList.append(encode(value))
        elif type_ == 'file':
            dataList.append(encode(f'Content-Disposition: form-data; name="{name}"; filename="{value}"'))
            dataList.append(encode(f'Content-Type: {mimetypes.guess_type(value)[0] or "application/octet-stream"}'))
            dataList.append(encode(''))
            dataList.append(open(value, 'rb').read())
    dataList.append(encode(f'--b9826c20-773c-1f0c-814d-a1b3d90cd6b3--'))
    dataList.append(encode(''))
    return dataList

dataList = build_data_list([{"name":"text","value":"API","type":"text"},{"name":"sep","value":"|","type":"text"},{"name":"times","value":"3","type":"text"}])
body = b'\r\n'.join(dataList)
conn = http.client.HTTPSConnection("api.apidash.dev")
conn.request("POST", "/io/form",
              body= body,
              headers= headers)

res = conn.getresponse()
data = res.read()

print(data.decode("utf-8"))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.pythonHttpClient, requestModelPost4, "https",
              boundary: "b9826c20-773c-1f0c-814d-a1b3d90cd6b3"),
          expectedCode);
    });

    test('POST 5', () {
      const expectedCode = r"""import http.client
import mimetypes
from codecs import encode

headers = {
  "User-Agent": "Test Agent",
  "content-type": "multipart/form-data; boundary=929dc910-7714-1f0c-814d-a1b3d90cd6b3"
}

def build_data_list(fields):
    dataList = []
    for field in fields:
        name = field.get('name', '')
        value = field.get('value', '')
        type_ = field.get('type', 'text')
        dataList.append(encode('--929dc910-7714-1f0c-814d-a1b3d90cd6b3'))
        if type_ == 'text':
            dataList.append(encode(f'Content-Disposition: form-data; name="{name}"'))
            dataList.append(encode('Content-Type: text/plain'))
            dataList.append(encode(''))
            dataList.append(encode(value))
        elif type_ == 'file':
            dataList.append(encode(f'Content-Disposition: form-data; name="{name}"; filename="{value}"'))
            dataList.append(encode(f'Content-Type: {mimetypes.guess_type(value)[0] or "application/octet-stream"}'))
            dataList.append(encode(''))
            dataList.append(open(value, 'rb').read())
    dataList.append(encode(f'--929dc910-7714-1f0c-814d-a1b3d90cd6b3--'))
    dataList.append(encode(''))
    return dataList

dataList = build_data_list([{"name":"text","value":"API","type":"text"},{"name":"sep","value":"|","type":"text"},{"name":"times","value":"3","type":"text"}])
body = b'\r\n'.join(dataList)
conn = http.client.HTTPSConnection("api.apidash.dev")
conn.request("POST", "/io/form",
              body= body,
              headers= headers)

res = conn.getresponse()
data = res.read()

print(data.decode("utf-8"))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.pythonHttpClient, requestModelPost5, "https",
              boundary: "929dc910-7714-1f0c-814d-a1b3d90cd6b3"),
          expectedCode);
    });

    test('POST 6', () {
      const expectedCode = r"""import http.client
import mimetypes
from codecs import encode

headers = {
  "content-type": "multipart/form-data; boundary=9b1374c0-76e0-1f0c-814d-a1b3d90cd6b3"
}

def build_data_list(fields):
    dataList = []
    for field in fields:
        name = field.get('name', '')
        value = field.get('value', '')
        type_ = field.get('type', 'text')
        dataList.append(encode('--9b1374c0-76e0-1f0c-814d-a1b3d90cd6b3'))
        if type_ == 'text':
            dataList.append(encode(f'Content-Disposition: form-data; name="{name}"'))
            dataList.append(encode('Content-Type: text/plain'))
            dataList.append(encode(''))
            dataList.append(encode(value))
        elif type_ == 'file':
            dataList.append(encode(f'Content-Disposition: form-data; name="{name}"; filename="{value}"'))
            dataList.append(encode(f'Content-Type: {mimetypes.guess_type(value)[0] or "application/octet-stream"}'))
            dataList.append(encode(''))
            dataList.append(open(value, 'rb').read())
    dataList.append(encode(f'--9b1374c0-76e0-1f0c-814d-a1b3d90cd6b3--'))
    dataList.append(encode(''))
    return dataList

dataList = build_data_list([{"name":"token","value":"xyz","type":"text"},{"name":"imfile","value":"/Documents/up/1.png","type":"file"}])
body = b'\r\n'.join(dataList)
conn = http.client.HTTPSConnection("api.apidash.dev")
conn.request("POST", "/io/img",
              body= body,
              headers= headers)

res = conn.getresponse()
data = res.read()

print(data.decode("utf-8"))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.pythonHttpClient, requestModelPost6, "https",
              boundary: "9b1374c0-76e0-1f0c-814d-a1b3d90cd6b3"),
          expectedCode);
    });

    test('POST 7', () {
      const expectedCode = r"""import http.client
import mimetypes
from codecs import encode

headers = {
  "content-type": "multipart/form-data; boundary=defdf240-76b4-1f0c-814d-a1b3d90cd6b3"
}

def build_data_list(fields):
    dataList = []
    for field in fields:
        name = field.get('name', '')
        value = field.get('value', '')
        type_ = field.get('type', 'text')
        dataList.append(encode('--defdf240-76b4-1f0c-814d-a1b3d90cd6b3'))
        if type_ == 'text':
            dataList.append(encode(f'Content-Disposition: form-data; name="{name}"'))
            dataList.append(encode('Content-Type: text/plain'))
            dataList.append(encode(''))
            dataList.append(encode(value))
        elif type_ == 'file':
            dataList.append(encode(f'Content-Disposition: form-data; name="{name}"; filename="{value}"'))
            dataList.append(encode(f'Content-Type: {mimetypes.guess_type(value)[0] or "application/octet-stream"}'))
            dataList.append(encode(''))
            dataList.append(open(value, 'rb').read())
    dataList.append(encode(f'--defdf240-76b4-1f0c-814d-a1b3d90cd6b3--'))
    dataList.append(encode(''))
    return dataList

dataList = build_data_list([{"name":"token","value":"xyz","type":"text"},{"name":"imfile","value":"/Documents/up/1.png","type":"file"}])
body = b'\r\n'.join(dataList)
conn = http.client.HTTPSConnection("api.apidash.dev")
conn.request("POST", "/io/img",
              body= body,
              headers= headers)

res = conn.getresponse()
data = res.read()

print(data.decode("utf-8"))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.pythonHttpClient, requestModelPost7, "https",
              boundary: "defdf240-76b4-1f0c-814d-a1b3d90cd6b3"),
          expectedCode);
    });

    test('POST 8', () {
      const expectedCode = r"""import http.client
import mimetypes
from codecs import encode
from urllib.parse import urlencode

queryParams = {
  "size": "2",
  "len": "3"
}
queryParamsStr = '?' + urlencode(queryParams)

headers = {
  "content-type": "multipart/form-data; boundary=a990b150-7683-1f0c-814d-a1b3d90cd6b3"
}

def build_data_list(fields):
    dataList = []
    for field in fields:
        name = field.get('name', '')
        value = field.get('value', '')
        type_ = field.get('type', 'text')
        dataList.append(encode('--a990b150-7683-1f0c-814d-a1b3d90cd6b3'))
        if type_ == 'text':
            dataList.append(encode(f'Content-Disposition: form-data; name="{name}"'))
            dataList.append(encode('Content-Type: text/plain'))
            dataList.append(encode(''))
            dataList.append(encode(value))
        elif type_ == 'file':
            dataList.append(encode(f'Content-Disposition: form-data; name="{name}"; filename="{value}"'))
            dataList.append(encode(f'Content-Type: {mimetypes.guess_type(value)[0] or "application/octet-stream"}'))
            dataList.append(encode(''))
            dataList.append(open(value, 'rb').read())
    dataList.append(encode(f'--a990b150-7683-1f0c-814d-a1b3d90cd6b3--'))
    dataList.append(encode(''))
    return dataList

dataList = build_data_list([{"name":"text","value":"API","type":"text"},{"name":"sep","value":"|","type":"text"},{"name":"times","value":"3","type":"text"}])
body = b'\r\n'.join(dataList)
conn = http.client.HTTPSConnection("api.apidash.dev")
conn.request("POST", "/io/form" + queryParamsStr,
              body= body,
              headers= headers)

res = conn.getresponse()
data = res.read()

print(data.decode("utf-8"))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.pythonHttpClient, requestModelPost8, "https",
              boundary: "a990b150-7683-1f0c-814d-a1b3d90cd6b3"),
          expectedCode);
    });

    test('POST 9', () {
      const expectedCode = r"""import http.client
import mimetypes
from codecs import encode
from urllib.parse import urlencode

queryParams = {
  "size": "2",
  "len": "3"
}
queryParamsStr = '?' + urlencode(queryParams)

headers = {
  "User-Agent": "Test Agent",
  "Keep-Alive": "true",
  "content-type": "multipart/form-data; boundary=79088e00-75ec-1f0c-814d-a1b3d90cd6b3"
}

def build_data_list(fields):
    dataList = []
    for field in fields:
        name = field.get('name', '')
        value = field.get('value', '')
        type_ = field.get('type', 'text')
        dataList.append(encode('--79088e00-75ec-1f0c-814d-a1b3d90cd6b3'))
        if type_ == 'text':
            dataList.append(encode(f'Content-Disposition: form-data; name="{name}"'))
            dataList.append(encode('Content-Type: text/plain'))
            dataList.append(encode(''))
            dataList.append(encode(value))
        elif type_ == 'file':
            dataList.append(encode(f'Content-Disposition: form-data; name="{name}"; filename="{value}"'))
            dataList.append(encode(f'Content-Type: {mimetypes.guess_type(value)[0] or "application/octet-stream"}'))
            dataList.append(encode(''))
            dataList.append(open(value, 'rb').read())
    dataList.append(encode(f'--79088e00-75ec-1f0c-814d-a1b3d90cd6b3--'))
    dataList.append(encode(''))
    return dataList

dataList = build_data_list([{"name":"token","value":"xyz","type":"text"},{"name":"imfile","value":"/Documents/up/1.png","type":"file"}])
body = b'\r\n'.join(dataList)
conn = http.client.HTTPSConnection("api.apidash.dev")
conn.request("POST", "/io/img" + queryParamsStr,
              body= body,
              headers= headers)

res = conn.getresponse()
data = res.read()

print(data.decode("utf-8"))
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.pythonHttpClient, requestModelPost9, "https",
              boundary: "79088e00-75ec-1f0c-814d-a1b3d90cd6b3"),
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
