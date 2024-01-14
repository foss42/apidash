import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import '../request_models.dart';
import 'package:test/test.dart';

void main() {
  final codeGen = Codegen();

  group('Test various Code generators', () {
    test('cURL', () {
      const expectedCode = r"""curl --url 'https://api.foss42.com'""";
      expect(codeGen.getCode(CodegenLanguage.curl, requestModelGet1, "https"),
          expectedCode);
    });

    test('Dart Dio', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final response = await dio.Dio.get('https://api.foss42.com');
    print(response.statusCode);
    print(response.data);
  } on DioException catch (e, s) {
    print(e.response?.statusCode);
    print(e.response?.data);
    print(s);
  } catch (e, s) {
    print(e);
    print(s);
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartDio, requestModelGet1, "https"),
          expectedCode);
    });

    test('Dart HTTP', () {
      const expectedCode = r"""import 'package:http/http.dart' as http;

void main() async {
  var uri = Uri.parse('https://api.foss42.com');

  final response = await http.get(uri);

  int statusCode = response.statusCode;
  if (statusCode >= 200 && statusCode < 300) {
    print('Status Code: $statusCode');
    print('Response Body: ${response.body}');
  } else {
    print('Error Status Code: $statusCode');
    print('Error Response Body: ${response.body}');
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartHttp, requestModelGet1, "https"),
          expectedCode);
    });

    test('HAR', () {
      const expectedCode = r"""{
  "method": "GET",
  "url": "https://api.foss42.com",
  "httpVersion": "HTTP/1.1",
  "queryString": [],
  "headers": []
}""";
      expect(codeGen.getCode(CodegenLanguage.har, requestModelGet1, "https"),
          expectedCode);
    });

    test('JS Axios', () {
      const expectedCode = r"""let config = {
  url: 'https://api.foss42.com',
  method: 'get'
};

axios(config)
    .then(function (response) {
        // handle success
        console.log(response.status);
        console.log(response.data);
    })
    .catch(function (error) {
        // handle error
        console.log(error.response.status);
        console.log(error);
    });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsAxios, requestModelGet1, "https"),
          expectedCode);
    });

    test('JS Fetch', () {
      const expectedCode = r"""let url = 'https://api.foss42.com';

let options = {
  method: 'GET'
};

let status;
fetch(url, options)
    .then(res => {
        status = res.status;
        return res.json()
    })
    .then(body => {
        console.log(status);
        console.log(body);
    })
    .catch(err => {
        console.log(status);
        console.error('error:' + err);
    });
""";
      expect(
          codeGen.getCode(CodegenLanguage.jsFetch, requestModelGet1, "https"),
          expectedCode);
    });

    test('Kotlin OkHttp', () {
      const expectedCode = r"""import okhttp3.OkHttpClient
import okhttp3.Request

fun main() {
    val client = OkHttpClient()

    val url = "https://api.foss42.com"

    val request = Request.Builder()
        .url(url)
        .get()
        .build()

    val response = client.newCall(request).execute()

    println(response.code)
    println(response.body?.string())
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.kotlinOkHttp, requestModelGet1, "https"),
          expectedCode);
    });

    test('NodeJs Axios', () {
      const expectedCode = r"""import axios from 'axios';

let config = {
  url: 'https://api.foss42.com',
  method: 'get'
};

axios(config)
    .then(function (response) {
        // handle success
        console.log(response.status);
        console.log(response.data);
    })
    .catch(function (error) {
        // handle error
        console.log(error.response.status);
        console.log(error);
    });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsAxios, requestModelGet1, "https"),
          expectedCode);
    });

    test('Nodejs Fetch', () {
      const expectedCode = r"""import fetch from 'node-fetch';

let url = 'https://api.foss42.com';

let options = {
  method: 'GET'
};

let status;
fetch(url, options)
    .then(res => {
        status = res.status;
        return res.json()
    })
    .then(body => {
        console.log(status);
        console.log(body);
    })
    .catch(err => {
        console.log(status);
        console.error('error:' + err);
    });
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.nodejsFetch, requestModelGet1, "https"),
          expectedCode);
    });

    test('Python http.client', () {
      const expectedCode = r"""import http.client

conn = http.client.HTTPSConnection("api.foss42.com")
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

    test('Python requests', () {
      const expectedCode = r"""import requests

url = 'https://api.foss42.com'

response = requests.get(url)

print('Status Code:', response.status_code)
print('Response Body:', response.text)
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.pythonRequests, requestModelGet1, "https"),
          expectedCode);
    });
  });
}
