import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:test/test.dart';
import '../models/request_models.dart';

void main() {
  final codeGen = Codegen();

  group('Get Request', () {
    test('GET 1', () {
      const expectedCode = r'''using System;
using System.Net.Http;

string uri = "https://api.apidash.dev";

using (var client = new HttpClient())
using (var request = new HttpRequestMessage(HttpMethod.Get, uri))
{
    HttpResponseMessage response = await client.SendAsync(request);

    Console.WriteLine((int)response.StatusCode);
    Console.WriteLine(await response.Content.ReadAsStringAsync());
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.cSharpHttpClient, requestModelGet1, "https"),
          expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r'''using System;
using System.Net.Http;

string uri = "https://api.apidash.dev/country/data?code=US";

using (var client = new HttpClient())
using (var request = new HttpRequestMessage(HttpMethod.Get, uri))
{
    HttpResponseMessage response = await client.SendAsync(request);

    Console.WriteLine((int)response.StatusCode);
    Console.WriteLine(await response.Content.ReadAsStringAsync());
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.cSharpHttpClient, requestModelGet2, "https"),
          expectedCode);
    });

    test('GET 3', () {
      const expectedCode = r'''using System;
using System.Net.Http;

string uri = "https://api.apidash.dev/country/data?code=IND";

using (var client = new HttpClient())
using (var request = new HttpRequestMessage(HttpMethod.Get, uri))
{
    HttpResponseMessage response = await client.SendAsync(request);

    Console.WriteLine((int)response.StatusCode);
    Console.WriteLine(await response.Content.ReadAsStringAsync());
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.cSharpHttpClient, requestModelGet3, "https"),
          expectedCode);
    });

    test('GET 4', () {
      const expectedCode = r'''using System;
using System.Net.Http;

string uri = "https://api.apidash.dev/humanize/social?num=8700000&digits=3&system=SS&add_space=true&trailing_zeros=true";

using (var client = new HttpClient())
using (var request = new HttpRequestMessage(HttpMethod.Get, uri))
{
    HttpResponseMessage response = await client.SendAsync(request);

    Console.WriteLine((int)response.StatusCode);
    Console.WriteLine(await response.Content.ReadAsStringAsync());
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.cSharpHttpClient, requestModelGet4, "https"),
          expectedCode);
    });

    test('GET 5', () {
      const expectedCode = r'''using System;
using System.Net.Http;

string uri = "https://api.github.com/repos/foss42/apidash";

using (var client = new HttpClient())
using (var request = new HttpRequestMessage(HttpMethod.Get, uri))
{
    request.Headers.Add("User-Agent", "Test Agent");
    
    HttpResponseMessage response = await client.SendAsync(request);

    Console.WriteLine((int)response.StatusCode);
    Console.WriteLine(await response.Content.ReadAsStringAsync());
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.cSharpHttpClient, requestModelGet5, "https"),
          expectedCode);
    });

    test('GET 6', () {
      const expectedCode = r'''using System;
using System.Net.Http;

string uri = "https://api.github.com/repos/foss42/apidash?raw=true";

using (var client = new HttpClient())
using (var request = new HttpRequestMessage(HttpMethod.Get, uri))
{
    request.Headers.Add("User-Agent", "Test Agent");
    
    HttpResponseMessage response = await client.SendAsync(request);

    Console.WriteLine((int)response.StatusCode);
    Console.WriteLine(await response.Content.ReadAsStringAsync());
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.cSharpHttpClient, requestModelGet6, "https"),
          expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r'''using System;
using System.Net.Http;

string uri = "https://api.apidash.dev";

using (var client = new HttpClient())
using (var request = new HttpRequestMessage(HttpMethod.Get, uri))
{
    HttpResponseMessage response = await client.SendAsync(request);

    Console.WriteLine((int)response.StatusCode);
    Console.WriteLine(await response.Content.ReadAsStringAsync());
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.cSharpHttpClient, requestModelGet7, "https"),
          expectedCode);
    });

    test('GET 8', () {
      const expectedCode = r'''using System;
using System.Net.Http;

string uri = "https://api.github.com/repos/foss42/apidash?raw=true";

using (var client = new HttpClient())
using (var request = new HttpRequestMessage(HttpMethod.Get, uri))
{
    request.Headers.Add("User-Agent", "Test Agent");
    
    HttpResponseMessage response = await client.SendAsync(request);

    Console.WriteLine((int)response.StatusCode);
    Console.WriteLine(await response.Content.ReadAsStringAsync());
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.cSharpHttpClient, requestModelGet8, "https"),
          expectedCode);
    });

    test('GET 9', () {
      const expectedCode = r'''using System;
using System.Net.Http;

string uri = "https://api.apidash.dev/humanize/social?num=8700000&add_space=true";

using (var client = new HttpClient())
using (var request = new HttpRequestMessage(HttpMethod.Get, uri))
{
    HttpResponseMessage response = await client.SendAsync(request);

    Console.WriteLine((int)response.StatusCode);
    Console.WriteLine(await response.Content.ReadAsStringAsync());
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.cSharpHttpClient, requestModelGet9, "https"),
          expectedCode);
    });

    test('GET 10', () {
      const expectedCode = r'''using System;
using System.Net.Http;

string uri = "https://api.apidash.dev/humanize/social";

using (var client = new HttpClient())
using (var request = new HttpRequestMessage(HttpMethod.Get, uri))
{
    request.Headers.Add("User-Agent", "Test Agent");
    
    HttpResponseMessage response = await client.SendAsync(request);

    Console.WriteLine((int)response.StatusCode);
    Console.WriteLine(await response.Content.ReadAsStringAsync());
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.cSharpHttpClient, requestModelGet10, "https"),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode = r'''using System;
using System.Net.Http;

string uri = "https://api.apidash.dev/humanize/social?num=8700000&digits=3";

using (var client = new HttpClient())
using (var request = new HttpRequestMessage(HttpMethod.Get, uri))
{
    request.Headers.Add("User-Agent", "Test Agent");
    
    HttpResponseMessage response = await client.SendAsync(request);

    Console.WriteLine((int)response.StatusCode);
    Console.WriteLine(await response.Content.ReadAsStringAsync());
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.cSharpHttpClient, requestModelGet11, "https"),
          expectedCode);
    });

    test('GET 12', () {
      const expectedCode = r'''using System;
using System.Net.Http;

string uri = "https://api.apidash.dev/humanize/social";

using (var client = new HttpClient())
using (var request = new HttpRequestMessage(HttpMethod.Get, uri))
{
    HttpResponseMessage response = await client.SendAsync(request);

    Console.WriteLine((int)response.StatusCode);
    Console.WriteLine(await response.Content.ReadAsStringAsync());
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.cSharpHttpClient, requestModelGet12, "https"),
          expectedCode);
    });
  });

  group('Head Request', () {
    test('HEAD 1', () {
      const expectedCode = r'''using System;
using System.Net.Http;

string uri = "https://api.apidash.dev";

using (var client = new HttpClient())
using (var request = new HttpRequestMessage(HttpMethod.Head, uri))
{
    HttpResponseMessage response = await client.SendAsync(request);

    Console.WriteLine((int)response.StatusCode);
    Console.WriteLine(await response.Content.ReadAsStringAsync());
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.cSharpHttpClient, requestModelHead1, "https"),
          expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r'''using System;
using System.Net.Http;

string uri = "http://api.apidash.dev";

using (var client = new HttpClient())
using (var request = new HttpRequestMessage(HttpMethod.Head, uri))
{
    HttpResponseMessage response = await client.SendAsync(request);

    Console.WriteLine((int)response.StatusCode);
    Console.WriteLine(await response.Content.ReadAsStringAsync());
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.cSharpHttpClient, requestModelHead2, "http"),
          expectedCode);
    });
  });

  group('Post Request', () {
    test('POST 1', () {
      const expectedCode = r'''using System;
using System.Net.Http;

string uri = "https://api.apidash.dev/case/lower";

using (var client = new HttpClient())
using (var request = new HttpRequestMessage(HttpMethod.Post, uri))
{
    var payload = """
{
"text": "I LOVE Flutter"
}
""";
    var content = new StringContent(payload, null, "text/plain");
    request.Content = content;

    HttpResponseMessage response = await client.SendAsync(request);

    Console.WriteLine((int)response.StatusCode);
    Console.WriteLine(await response.Content.ReadAsStringAsync());
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.cSharpHttpClient, requestModelPost1, "https"),
          expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r'''using System;
using System.Net.Http;

string uri = "https://api.apidash.dev/case/lower";

using (var client = new HttpClient())
using (var request = new HttpRequestMessage(HttpMethod.Post, uri))
{
    var payload = """
{
"text": "I LOVE Flutter",
"flag": null,
"male": true,
"female": false,
"no": 1.2,
"arr": ["null", "true", "false", null]
}
""";
    var content = new StringContent(payload, null, "application/json");
    request.Content = content;

    HttpResponseMessage response = await client.SendAsync(request);

    Console.WriteLine((int)response.StatusCode);
    Console.WriteLine(await response.Content.ReadAsStringAsync());
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.cSharpHttpClient, requestModelPost2, "https"),
          expectedCode);
    });

    test('POST 3', () {
      const expectedCode = r'''using System;
using System.Net.Http;

string uri = "https://api.apidash.dev/case/lower";

using (var client = new HttpClient())
using (var request = new HttpRequestMessage(HttpMethod.Post, uri))
{
    request.Headers.Add("User-Agent", "Test Agent");
    
    var payload = """
{
"text": "I LOVE Flutter"
}
""";
    var content = new StringContent(payload, null, "application/json");
    request.Content = content;

    HttpResponseMessage response = await client.SendAsync(request);

    Console.WriteLine((int)response.StatusCode);
    Console.WriteLine(await response.Content.ReadAsStringAsync());
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.cSharpHttpClient, requestModelPost3, "https"),
          expectedCode);
    });

    test('POST 4', () {
      const expectedCode = r'''using System;
using System.Net.Http;
using System.IO;

string uri = "https://api.apidash.dev/io/form";

using (var client = new HttpClient())
using (var request = new HttpRequestMessage(HttpMethod.Post, uri))
{
    var content = new MultipartFormDataContent
    {
        { new StringContent("API"), "text" },
        { new StringContent("|"), "sep" },
        { new StringContent("3"), "times" },
    };
    request.Content = content;

    HttpResponseMessage response = await client.SendAsync(request);

    Console.WriteLine((int)response.StatusCode);
    Console.WriteLine(await response.Content.ReadAsStringAsync());
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.cSharpHttpClient, requestModelPost4, "https"),
          expectedCode);
    });

    test('POST 5', () {
      const expectedCode = r'''using System;
using System.Net.Http;
using System.IO;

string uri = "https://api.apidash.dev/io/form";

using (var client = new HttpClient())
using (var request = new HttpRequestMessage(HttpMethod.Post, uri))
{
    request.Headers.Add("User-Agent", "Test Agent");
    
    var content = new MultipartFormDataContent
    {
        { new StringContent("API"), "text" },
        { new StringContent("|"), "sep" },
        { new StringContent("3"), "times" },
    };
    request.Content = content;

    HttpResponseMessage response = await client.SendAsync(request);

    Console.WriteLine((int)response.StatusCode);
    Console.WriteLine(await response.Content.ReadAsStringAsync());
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.cSharpHttpClient, requestModelPost5, "https"),
          expectedCode);
    });

    test('POST 6', () {
      const expectedCode = r'''using System;
using System.Net.Http;
using System.IO;

string uri = "https://api.apidash.dev/io/img";

using (var client = new HttpClient())
using (var request = new HttpRequestMessage(HttpMethod.Post, uri))
{
    var content = new MultipartFormDataContent
    {
        { new StringContent("xyz"), "token" },
        {
            new StreamContent(File.OpenRead("/Documents/up/1.png")), 
            "imfile", 
            "/Documents/up/1.png"
        },
    };
    request.Content = content;

    HttpResponseMessage response = await client.SendAsync(request);

    Console.WriteLine((int)response.StatusCode);
    Console.WriteLine(await response.Content.ReadAsStringAsync());
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.cSharpHttpClient, requestModelPost6, "https"),
          expectedCode);
    });

    test('POST 7', () {
      const expectedCode = r'''using System;
using System.Net.Http;
using System.IO;

string uri = "https://api.apidash.dev/io/img";

using (var client = new HttpClient())
using (var request = new HttpRequestMessage(HttpMethod.Post, uri))
{
    var content = new MultipartFormDataContent
    {
        { new StringContent("xyz"), "token" },
        {
            new StreamContent(File.OpenRead("/Documents/up/1.png")), 
            "imfile", 
            "/Documents/up/1.png"
        },
    };
    request.Content = content;

    HttpResponseMessage response = await client.SendAsync(request);

    Console.WriteLine((int)response.StatusCode);
    Console.WriteLine(await response.Content.ReadAsStringAsync());
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.cSharpHttpClient, requestModelPost7, "https"),
          expectedCode);
    });

    test('POST 8', () {
      const expectedCode = r'''using System;
using System.Net.Http;
using System.IO;

string uri = "https://api.apidash.dev/io/form?size=2&len=3";

using (var client = new HttpClient())
using (var request = new HttpRequestMessage(HttpMethod.Post, uri))
{
    var content = new MultipartFormDataContent
    {
        { new StringContent("API"), "text" },
        { new StringContent("|"), "sep" },
        { new StringContent("3"), "times" },
    };
    request.Content = content;

    HttpResponseMessage response = await client.SendAsync(request);

    Console.WriteLine((int)response.StatusCode);
    Console.WriteLine(await response.Content.ReadAsStringAsync());
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.cSharpHttpClient, requestModelPost8, "https"),
          expectedCode);
    });

    test('POST 9', () {
      const expectedCode = r'''using System;
using System.Net.Http;
using System.IO;

string uri = "https://api.apidash.dev/io/img?size=2&len=3";

using (var client = new HttpClient())
using (var request = new HttpRequestMessage(HttpMethod.Post, uri))
{
    request.Headers.Add("User-Agent", "Test Agent");
    request.Headers.Add("Keep-Alive", "true");
    
    var content = new MultipartFormDataContent
    {
        { new StringContent("xyz"), "token" },
        {
            new StreamContent(File.OpenRead("/Documents/up/1.png")), 
            "imfile", 
            "/Documents/up/1.png"
        },
    };
    request.Content = content;

    HttpResponseMessage response = await client.SendAsync(request);

    Console.WriteLine((int)response.StatusCode);
    Console.WriteLine(await response.Content.ReadAsStringAsync());
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.cSharpHttpClient, requestModelPost9, "https"),
          expectedCode);
    });
  });

  group('Put Request', () {
    test('PUT 1', () {
      const expectedCode = r'''using System;
using System.Net.Http;

string uri = "https://reqres.in/api/users/2";

using (var client = new HttpClient())
using (var request = new HttpRequestMessage(HttpMethod.Put, uri))
{
    var payload = """
{
"name": "morpheus",
"job": "zion resident"
}
""";
    var content = new StringContent(payload, null, "application/json");
    request.Content = content;

    HttpResponseMessage response = await client.SendAsync(request);

    Console.WriteLine((int)response.StatusCode);
    Console.WriteLine(await response.Content.ReadAsStringAsync());
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.cSharpHttpClient, requestModelPut1, "https"),
          expectedCode);
    });
  });

  group('Patch Request', () {
    test('PATCH 1', () {
      const expectedCode = r'''using System;
using System.Net.Http;

string uri = "https://reqres.in/api/users/2";

using (var client = new HttpClient())
using (var request = new HttpRequestMessage(HttpMethod.Patch, uri))
{
    var payload = """
{
"name": "marfeus",
"job": "accountant"
}
""";
    var content = new StringContent(payload, null, "application/json");
    request.Content = content;

    HttpResponseMessage response = await client.SendAsync(request);

    Console.WriteLine((int)response.StatusCode);
    Console.WriteLine(await response.Content.ReadAsStringAsync());
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.cSharpHttpClient, requestModelPatch1, "https"),
          expectedCode);
    });
  });

  group('Delete Request', () {
    test('DELETE 1', () {
      const expectedCode = r'''using System;
using System.Net.Http;

string uri = "https://reqres.in/api/users/2";

using (var client = new HttpClient())
using (var request = new HttpRequestMessage(HttpMethod.Delete, uri))
{
    HttpResponseMessage response = await client.SendAsync(request);

    Console.WriteLine((int)response.StatusCode);
    Console.WriteLine(await response.Content.ReadAsStringAsync());
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.cSharpHttpClient, requestModelDelete1, "https"),
          expectedCode);
    });

    test('DELETE 2', () {
      const expectedCode = r'''using System;
using System.Net.Http;

string uri = "https://reqres.in/api/users/2";

using (var client = new HttpClient())
using (var request = new HttpRequestMessage(HttpMethod.Delete, uri))
{
    var payload = """
{
"name": "marfeus",
"job": "accountant"
}
""";
    var content = new StringContent(payload, null, "application/json");
    request.Content = content;

    HttpResponseMessage response = await client.SendAsync(request);

    Console.WriteLine((int)response.StatusCode);
    Console.WriteLine(await response.Content.ReadAsStringAsync());
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.cSharpHttpClient, requestModelDelete2, "https"),
          expectedCode);
    });
  });
}
