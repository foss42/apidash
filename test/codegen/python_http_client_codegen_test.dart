import 'package:apidash/codegen/python/pkg_http_client.dart';
import 'package:apidash/models/models.dart' show KVRow, RequestModel;
import 'package:apidash/models/name_value_model.dart';
import 'package:test/test.dart';
import 'package:apidash/consts.dart';

void main() {
  group('PythonHttpClient', () {
    final PythonHttpClient pythonHttpClient = PythonHttpClient();

    test('getCode returns valid code for GET request', () {
      const requestModel = RequestModel(
        url: 'https://jsonplaceholder.typicode.com/todos/1',
        method: HTTPVerb.get,
        id: '',
      );
      const expectedCode = """import http.client
import json

conn = http.client.HTTPSConnection('jsonplaceholder.typicode.com')
payload = json.dumps()
headers = {
'Content-Type':'application/json'
},
conn.request("GET", "/todos/1", payload, headers)
res = conn.getresponse()
data = res.read()
print(data.decode("utf-8"))
""";
      expect(pythonHttpClient.getCode(requestModel), expectedCode);
    });

    test('getCode returns valid code for POST request', () {
      const requestModel = RequestModel(
        url: 'https://jsonplaceholder.typicode.com/todos',
        method: HTTPVerb.post,
        requestBody: '{"title": "foo","body": "bar","userId": 1}',
        requestBodyContentType: ContentType.json,
        id: '1',
      );
      const expectedCode = """import http.client
import json

conn = http.client.HTTPSConnection('jsonplaceholder.typicode.com')
payload = json.dumps({"title": "foo","body": "bar","userId": 1})
headers = {
'Content-Type':'application/json'
},
conn.request("POST", "/todos", payload, headers)
res = conn.getresponse()
data = res.read()
print(data.decode("utf-8"))
""";
      expect(pythonHttpClient.getCode(requestModel), expectedCode);
    });

    test('getCode returns valid code for DELETE request', () {
      const requestModel = RequestModel(
        url: 'https://jsonplaceholder.typicode.com/todos/1',
        method: HTTPVerb.delete,
        requestBody: '{"title": "foo","body": "bar","userId": 1}',
        requestBodyContentType: ContentType.json,
        id: '1',
      );
      const expectedCode = """import http.client
import json

conn = http.client.HTTPSConnection('jsonplaceholder.typicode.com')
payload = json.dumps({"title": "foo","body": "bar","userId": 1})
headers = {
'Content-Type':'application/json'
},
conn.request("DELETE", "/todos/1", payload, headers)
res = conn.getresponse()
data = res.read()
print(data.decode("utf-8"))
""";
      expect(pythonHttpClient.getCode(requestModel), expectedCode);
    });

    test('getCode returns valid code for HEAD request', () {
      const requestModel = RequestModel(
        url: 'https://jsonplaceholder.typicode.com/todos/1',
        method: HTTPVerb.head,
        id: '1',
      );
      const expectedCode = """import http.client
import json

conn = http.client.HTTPSConnection('jsonplaceholder.typicode.com')
payload = json.dumps()
headers = {
'Content-Type':'application/json'
},
conn.request("HEAD", "/todos/1", payload, headers)
res = conn.getresponse()
data = res.read()
print(data.decode("utf-8"))
""";
      expect(pythonHttpClient.getCode(requestModel), expectedCode);
    });

    test(
        'getCode returns valid code for requests with headers and query parameters',
        () {
      const requestModel = RequestModel(
        url: 'https://jsonplaceholder.typicode.com/posts',
        method: HTTPVerb.get,
        requestParams: [
          NameValueModel(name: 'userId', value: 1),
        ],
        requestHeaders: [
          NameValueModel(name: 'Custom-Header-1', value: 'Value-1'),
          NameValueModel(name: 'Custom-Header-2', value: 'Value-2')
        ],
        id: '1',
      );
      const expectedCode = """import http.client
import json

conn = http.client.HTTPSConnection('jsonplaceholder.typicode.com')
payload = json.dumps()
headers = {
'Content-Type':'application/json'
'Custom-Header-1':'Value-1',
'Custom-Header-2':'Value-2',
},
conn.request("GET", "/posts?userId=1", payload, headers)
res = conn.getresponse()
data = res.read()
print(data.decode("utf-8"))
""";
      expect(pythonHttpClient.getCode(requestModel), expectedCode);
    });
  });
}
