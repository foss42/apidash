import 'package:apidash/codegen/csharp/http_client.dart';
import '../request_models.dart';
import 'package:test/test.dart';

void main() {
  final csharpHttpClientCodeGen = CSharpHttpClientCodeGen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""
using System;
using System.Text;
using System.Net.Http;
using System.Threading.Tasks;

string url = "https://api.foss42.com";
HttpMethod method = HttpMethod.Get;

using (HttpClient client = new HttpClient())
{
    HttpRequestMessage request = new HttpRequestMessage(method, url);

    HttpResponseMessage response = await client.SendAsync(request);
    string responseBody = await response.Content.ReadAsStringAsync();

    Console.WriteLine(responseBody);
}
""";
      expect(csharpHttpClientCodeGen.getCode(requestModelGet1, "https"), expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r"""
using System;
using System.Text;
using System.Net.Http;
using System.Threading.Tasks;

string url = "https://api.foss42.com/country/data";
HttpMethod method = HttpMethod.Get;

using (HttpClient client = new HttpClient())
{
    HttpRequestMessage request = new HttpRequestMessage(method, url);

    HttpResponseMessage response = await client.SendAsync(request);
    string responseBody = await response.Content.ReadAsStringAsync();

    Console.WriteLine(responseBody);
}
""";
      expect(csharpHttpClientCodeGen.getCode(requestModelGet2, "https"), expectedCode);
    });

    test('GET 3', () {
      const expectedCode = r"""
using System;
using System.Text;
using System.Net.Http;
using System.Threading.Tasks;

string url = "https://api.foss42.com/country/data?code=US";
HttpMethod method = HttpMethod.Get;

using (HttpClient client = new HttpClient())
{
    HttpRequestMessage request = new HttpRequestMessage(method, url);

    HttpResponseMessage response = await client.SendAsync(request);
    string responseBody = await response.Content.ReadAsStringAsync();

    Console.WriteLine(responseBody);
}
""";
      expect(csharpHttpClientCodeGen.getCode(requestModelGet3, "https"), expectedCode);
    });

    test('GET 4', () {
      const expectedCode = r"""
using System;
using System.Text;
using System.Net.Http;
using System.Threading.Tasks;

string url = "https://api.foss42.com/humanize/social";
HttpMethod method = HttpMethod.Get;

using (HttpClient client = new HttpClient())
{
    HttpRequestMessage request = new HttpRequestMessage(method, url);

    HttpResponseMessage response = await client.SendAsync(request);
    string responseBody = await response.Content.ReadAsStringAsync();

    Console.WriteLine(responseBody);
}
""";
      expect(csharpHttpClientCodeGen.getCode(requestModelGet4, "https"), expectedCode);
    });

    test('GET 5', () {
      const expectedCode = r"""using System;
using System.Text;
using System.Net.Http;
using System.Threading.Tasks;

string url = "https://api.github.com/repos/foss42/apidash";
HttpMethod method = HttpMethod.Get;

using (HttpClient client = new HttpClient())
{
    HttpRequestMessage request = new HttpRequestMessage(method, url);

    var headers = request.Headers;
    headers.Add("User-Agent", "Test Agent");

    HttpResponseMessage response = await client.SendAsync(request);
    string responseBody = await response.Content.ReadAsStringAsync();

    Console.WriteLine(responseBody);
}
""";
      expect(csharpHttpClientCodeGen.getCode(requestModelGet5, "https"), expectedCode);
    });

    test('GET 6', () {
      const expectedCode = r"""
using System;
using System.Text;
using System.Net.Http;
using System.Threading.Tasks;

string url = "https://api.github.com/repos/foss42/apidash";
HttpMethod method = HttpMethod.Get;

using (HttpClient client = new HttpClient())
{
    HttpRequestMessage request = new HttpRequestMessage(method, url);

    var headers = request.Headers;
    headers.Add("User-Agent", "Test Agent");

    HttpResponseMessage response = await client.SendAsync(request);
    string responseBody = await response.Content.ReadAsStringAsync();

    Console.WriteLine(responseBody);
}
""";
      expect(csharpHttpClientCodeGen.getCode(requestModelGet6, "https"), expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r"""
using System;
using System.Text;
using System.Net.Http;
using System.Threading.Tasks;

string url = "https://api.foss42.com";
HttpMethod method = HttpMethod.Get;

using (HttpClient client = new HttpClient())
{
    HttpRequestMessage request = new HttpRequestMessage(method, url);

    HttpResponseMessage response = await client.SendAsync(request);
    string responseBody = await response.Content.ReadAsStringAsync();

    Console.WriteLine(responseBody);
}
""";
      expect(csharpHttpClientCodeGen.getCode(requestModelGet7, "https"), expectedCode);
    });

    test('GET 8', () {
      const expectedCode = r"""
using System;
using System.Text;
using System.Net.Http;
using System.Threading.Tasks;

string url = "https://api.github.com/repos/foss42/apidash";
HttpMethod method = HttpMethod.Get;

using (HttpClient client = new HttpClient())
{
    HttpRequestMessage request = new HttpRequestMessage(method, url);

    var headers = request.Headers;
    headers.Add("User-Agent", "Test Agent");
    headers.Add("", "Bearer XYZ");

    HttpResponseMessage response = await client.SendAsync(request);
    string responseBody = await response.Content.ReadAsStringAsync();

    Console.WriteLine(responseBody);
}
""";
      expect(csharpHttpClientCodeGen.getCode(requestModelGet8, "https"), expectedCode);
    });

    test('GET 9', () {
      const expectedCode = r"""
using System;
using System.Text;
using System.Net.Http;
using System.Threading.Tasks;

string url = "https://api.foss42.com/humanize/social";
HttpMethod method = HttpMethod.Get;

using (HttpClient client = new HttpClient())
{
    HttpRequestMessage request = new HttpRequestMessage(method, url);

    HttpResponseMessage response = await client.SendAsync(request);
    string responseBody = await response.Content.ReadAsStringAsync();

    Console.WriteLine(responseBody);
}
""";
      expect(csharpHttpClientCodeGen.getCode(requestModelGet9, "https"), expectedCode);
    });

    test('GET 10', () {
      const expectedCode = r"""
using System;
using System.Text;
using System.Net.Http;
using System.Threading.Tasks;

string url = "https://api.foss42.com/humanize/social";
HttpMethod method = HttpMethod.Get;

using (HttpClient client = new HttpClient())
{
    HttpRequestMessage request = new HttpRequestMessage(method, url);

    var headers = request.Headers;
    headers.Add("User-Agent", "Test Agent");

    HttpResponseMessage response = await client.SendAsync(request);
    string responseBody = await response.Content.ReadAsStringAsync();

    Console.WriteLine(responseBody);
}
""";
      expect(csharpHttpClientCodeGen.getCode(requestModelGet10, "https"), expectedCode);
    });

    test('GET 11', () {
      const expectedCode = r"""
using System;
using System.Text;
using System.Net.Http;
using System.Threading.Tasks;

string url = "https://api.foss42.com/humanize/social";
HttpMethod method = HttpMethod.Get;

using (HttpClient client = new HttpClient())
{
    HttpRequestMessage request = new HttpRequestMessage(method, url);

    var headers = request.Headers;
    headers.Add("User-Agent", "Test Agent");

    HttpResponseMessage response = await client.SendAsync(request);
    string responseBody = await response.Content.ReadAsStringAsync();

    Console.WriteLine(responseBody);
}
""";
      expect(csharpHttpClientCodeGen.getCode(requestModelGet11, "https"), expectedCode);
    });

    test('GET 12', () {
      const expectedCode = r"""
using System;
using System.Text;
using System.Net.Http;
using System.Threading.Tasks;

string url = "https://api.foss42.com/humanize/social";
HttpMethod method = HttpMethod.Get;

using (HttpClient client = new HttpClient())
{
    HttpRequestMessage request = new HttpRequestMessage(method, url);

    HttpResponseMessage response = await client.SendAsync(request);
    string responseBody = await response.Content.ReadAsStringAsync();

    Console.WriteLine(responseBody);
}
""";
      expect(csharpHttpClientCodeGen.getCode(requestModelGet12, "https"), expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""
using System;
using System.Text;
using System.Net.Http;
using System.Threading.Tasks;

string url = "https://api.foss42.com";
HttpMethod method = HttpMethod.Head;

using (HttpClient client = new HttpClient())
{
    HttpRequestMessage request = new HttpRequestMessage(method, url);

    HttpResponseMessage response = await client.SendAsync(request);
    string responseBody = await response.Content.ReadAsStringAsync();

    Console.WriteLine(responseBody);
}
""";
      expect(csharpHttpClientCodeGen.getCode(requestModelHead1, "https"), expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""
using System;
using System.Text;
using System.Net.Http;
using System.Threading.Tasks;

string url = "api.foss42.com";
HttpMethod method = HttpMethod.Head;

using (HttpClient client = new HttpClient())
{
    HttpRequestMessage request = new HttpRequestMessage(method, url);

    HttpResponseMessage response = await client.SendAsync(request);
    string responseBody = await response.Content.ReadAsStringAsync();

    Console.WriteLine(responseBody);
}
""";
      expect(csharpHttpClientCodeGen.getCode(requestModelHead2, "http"), expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r"""
using System;
using System.Text;
using System.Net.Http;
using System.Threading.Tasks;

string url = "https://api.foss42.com/case/lower";
HttpMethod method = HttpMethod.Post;

using (HttpClient client = new HttpClient())
{
    HttpRequestMessage request = new HttpRequestMessage(method, url);
    request.Content = new StringContent("{\"text\": \"I LOVE Flutter\"}", Encoding.UTF8, "application/json");

    HttpResponseMessage response = await client.SendAsync(request);
    string responseBody = await response.Content.ReadAsStringAsync();

    Console.WriteLine(responseBody);
}
""";
      expect(csharpHttpClientCodeGen.getCode(requestModelPost1, "https"), expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r"""
using System;
using System.Text;
using System.Net.Http;
using System.Threading.Tasks;

string url = "https://api.foss42.com/case/lower";
HttpMethod method = HttpMethod.Post;

using (HttpClient client = new HttpClient())
{
    HttpRequestMessage request = new HttpRequestMessage(method, url);
    request.Content = new StringContent("{\"text\": \"I LOVE Flutter\"}", Encoding.UTF8, "application/json");

    HttpResponseMessage response = await client.SendAsync(request);
    string responseBody = await response.Content.ReadAsStringAsync();

    Console.WriteLine(responseBody);
}
""";
      expect(csharpHttpClientCodeGen.getCode(requestModelPost2, "https"), expectedCode);
    });

    test('POST 3', () {
      const expectedCode = r"""
using System;
using System.Text;
using System.Net.Http;
using System.Threading.Tasks;

string url = "https://api.foss42.com/case/lower";
HttpMethod method = HttpMethod.Post;

using (HttpClient client = new HttpClient())
{
    HttpRequestMessage request = new HttpRequestMessage(method, url);
    request.Content = new StringContent("{\"text\": \"I LOVE Flutter\"}", Encoding.UTF8, "application/json");

    var headers = request.Headers;
    headers.Add("User-Agent", "Test Agent");

    HttpResponseMessage response = await client.SendAsync(request);
    string responseBody = await response.Content.ReadAsStringAsync();

    Console.WriteLine(responseBody);
}
""";
      expect(csharpHttpClientCodeGen.getCode(requestModelPost3, "https"), expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT 1', () {
      const expectedCode = r"""
using System;
using System.Text;
using System.Net.Http;
using System.Threading.Tasks;

string url = "https://reqres.in/api/users/2";
HttpMethod method = HttpMethod.Put;

using (HttpClient client = new HttpClient())
{
    HttpRequestMessage request = new HttpRequestMessage(method, url);
    request.Content = new StringContent("{\"name\": \"morpheus\",\"job\": \"zion resident\"}", Encoding.UTF8, "application/json");

    HttpResponseMessage response = await client.SendAsync(request);
    string responseBody = await response.Content.ReadAsStringAsync();

    Console.WriteLine(responseBody);
}
""";
      expect(csharpHttpClientCodeGen.getCode(requestModelPut1, "https"), expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH 1', () {
      const expectedCode = r"""
using System;
using System.Text;
using System.Net.Http;
using System.Threading.Tasks;

string url = "https://reqres.in/api/users/2";
HttpMethod method = HttpMethod.Patch;

using (HttpClient client = new HttpClient())
{
    HttpRequestMessage request = new HttpRequestMessage(method, url);
    request.Content = new StringContent("{\"name\": \"marfeus\",\"job\": \"accountant\"}", Encoding.UTF8, "application/json");

    HttpResponseMessage response = await client.SendAsync(request);
    string responseBody = await response.Content.ReadAsStringAsync();

    Console.WriteLine(responseBody);
}
""";
      expect(csharpHttpClientCodeGen.getCode(requestModelPatch1, "https"), expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode = r"""
using System;
using System.Text;
using System.Net.Http;
using System.Threading.Tasks;

string url = "https://reqres.in/api/users/2";
HttpMethod method = HttpMethod.Delete;

using (HttpClient client = new HttpClient())
{
    HttpRequestMessage request = new HttpRequestMessage(method, url);

    HttpResponseMessage response = await client.SendAsync(request);
    string responseBody = await response.Content.ReadAsStringAsync();

    Console.WriteLine(responseBody);
}
""";
      expect(csharpHttpClientCodeGen.getCode(requestModelDelete1, "https"), expectedCode);
    });

    test('DELETE 2', () {
      const expectedCode = r"""
using System;
using System.Text;
using System.Net.Http;
using System.Threading.Tasks;

string url = "https://reqres.in/api/users/2";
HttpMethod method = HttpMethod.Delete;

using (HttpClient client = new HttpClient())
{
    HttpRequestMessage request = new HttpRequestMessage(method, url);

    HttpResponseMessage response = await client.SendAsync(request);
    string responseBody = await response.Content.ReadAsStringAsync();

    Console.WriteLine(responseBody);
}
""";
      expect(csharpHttpClientCodeGen.getCode(requestModelDelete2, "https"), expectedCode);
    });
  });
}
