import 'package:apidash/codegen/python/pkg_request.dart';
import 'package:apidash/models/models.dart';
import 'package:test/test.dart';
import 'package:apidash/consts.dart';

void main() {
  group('PythonRequestCodeGen', () {
    final pythonRequestCodeGen = PythonRequestCodeGen();

    test('getCode returns valid code for GET request', () {
      const requestModel = RequestModel(
        url: 'https://jsonplaceholder.typicode.com/todos/1',
        method: HTTPVerb.get,
        id: '',
      );
      const expectedCode = """import requests

def main():
    url = 'https://jsonplaceholder.typicode.com/todos/1'

    response = requests.get(
        url
    )

    status_code = response.status_code
    if 200 <= status_code < 300:
        print('Status Code:', status_code)
        print('Response Body:', response.text)
    else:
        print('Error Status Code:', status_code)
        print('Error Response Body:', response.reason)

main()""";
      expect(pythonRequestCodeGen.getCode(requestModel, 'https'), expectedCode);
    });

    test('getCode returns valid code for POST request', () {
      const requestModel = RequestModel(
        url: 'https://jsonplaceholder.typicode.com/posts',
        method: HTTPVerb.post,
        requestBody: '{"title": "foo","body": "bar","userId": 1}',
        requestBodyContentType: ContentType.json,
        id: '1',
      );
      const expectedCode = """import requests

def main():
    url = 'https://jsonplaceholder.typicode.com/posts'

    data = '''{"title": "foo","body": "bar","userId": 1}'''

    headers = {
                  "content-type": "application/json"
                }

    response = requests.post(
        url, headers=headers, data=data
    )

    status_code = response.status_code
    if 200 <= status_code < 300:
        print('Status Code:', status_code)
        print('Response Body:', response.text)
    else:
        print('Error Status Code:', status_code)
        print('Error Response Body:', response.reason)

main()""";
      expect(pythonRequestCodeGen.getCode(requestModel, 'https'), expectedCode);
    });

    test('getCode returns valid code for DELETE request', () {
      const requestModel = RequestModel(
        url: 'https://jsonplaceholder.typicode.com/posts/1',
        method: HTTPVerb.delete,
        requestBody: '{"title": "foo","body": "bar","userId": 1}',
        requestBodyContentType: ContentType.json,
        id: '1',
      );
      const expectedCode = """import requests

def main():
    url = 'https://jsonplaceholder.typicode.com/posts/1'

    data = '''{"title": "foo","body": "bar","userId": 1}'''

    headers = {
                  "content-type": "application/json"
                }

    response = requests.delete(
        url, headers=headers, data=data
    )

    status_code = response.status_code
    if 200 <= status_code < 300:
        print('Status Code:', status_code)
        print('Response Body:', response.text)
    else:
        print('Error Status Code:', status_code)
        print('Error Response Body:', response.reason)

main()""";
      expect(pythonRequestCodeGen.getCode(requestModel, 'https'), expectedCode);
    });

    test('getCode returns valid code for HEAD request', () {
      const requestModel = RequestModel(
        url: 'https://jsonplaceholder.typicode.com/posts/1',
        method: HTTPVerb.head,
        id: '1',
      );
      const expectedCode = """import requests

def main():
    url = 'https://jsonplaceholder.typicode.com/posts/1'

    response = requests.head(
        url
    )

    status_code = response.status_code
    if 200 <= status_code < 300:
        print('Status Code:', status_code)
        print('Response Body:', response.text)
    else:
        print('Error Status Code:', status_code)
        print('Error Response Body:', response.reason)

main()""";
      expect(pythonRequestCodeGen.getCode(requestModel, 'https'), expectedCode);
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
      const expectedCode = """import requests

def main():
    url = 'https://jsonplaceholder.typicode.com/posts'

    params = {
        "userId": "1", 
    }

    headers = {
                  "Custom-Header-1": "Value-1",
                  "Custom-Header-2": "Value-2"
                }

    response = requests.get(
        url, params=params, headers=headers
    )

    status_code = response.status_code
    if 200 <= status_code < 300:
        print('Status Code:', status_code)
        print('Response Body:', response.text)
    else:
        print('Error Status Code:', status_code)
        print('Error Response Body:', response.reason)

main()""";
      expect(pythonRequestCodeGen.getCode(requestModel, 'https'), expectedCode);
    });
  });
}
