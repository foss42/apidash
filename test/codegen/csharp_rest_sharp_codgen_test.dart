import 'package:apidash/consts.dart';
import 'package:apidash/screens/common_widgets/common_widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import '../models/request_models.dart';

void main() {
  group("Get Request Test", () {
    test("Get 1", () {
      const expectedCode = r"""
using System;
using RestSharp;
using System.Threading.Tasks;

class Program
{
  static async Task Main(){
    try{
      const String _baseUrl = "https://api.apidash.dev";
      var client = new RestClient(_baseUrl);

      var request = new RestRequest("", Method.Get);

      var response = await client.ExecuteAsync(request);
      Console.WriteLine("Status Code: " + (int)response.StatusCode);
      Console.WriteLine("Response Content: " + response.Content);
    }
    catch(Exception ex){
      Console.WriteLine("Error: " + ex);
    }
  }
}
""";
      expect(
          codegen.getCode(
              CodegenLanguage.cSharpRestSharp, requestModelGet1, "https"),
          expectedCode);
    });

    test("Get 2", () {
      const expectedCode = r"""
using System;
using RestSharp;
using System.Threading.Tasks;

class Program
{
  static async Task Main(){
    try{
      const String _baseUrl = "https://api.apidash.dev";
      var client = new RestClient(_baseUrl);

      var request = new RestRequest("/country/data", Method.Get);

      request.AddQueryParameter("code", "US");

      var response = await client.ExecuteAsync(request);
      Console.WriteLine("Status Code: " + (int)response.StatusCode);
      Console.WriteLine("Response Content: " + response.Content);
    }
    catch(Exception ex){
      Console.WriteLine("Error: " + ex);
    }
  }
}
""";

      expect(
          codegen.getCode(
              CodegenLanguage.cSharpRestSharp, requestModelGet2, "https"),
          expectedCode);
    });

    test("Get 3", () {
      const expectedCode = r"""
using System;
using RestSharp;
using System.Threading.Tasks;

class Program
{
  static async Task Main(){
    try{
      const String _baseUrl = "https://api.apidash.dev";
      var client = new RestClient(_baseUrl);

      var request = new RestRequest("/country/data", Method.Get);

      request.AddQueryParameter("code", "IND");

      var response = await client.ExecuteAsync(request);
      Console.WriteLine("Status Code: " + (int)response.StatusCode);
      Console.WriteLine("Response Content: " + response.Content);
    }
    catch(Exception ex){
      Console.WriteLine("Error: " + ex);
    }
  }
}
""";

      expect(
          codegen.getCode(
              CodegenLanguage.cSharpRestSharp, requestModelGet3, "https"),
          expectedCode);
    });

    test("Get 4", () {
      const expectedCode = r"""
using System;
using RestSharp;
using System.Threading.Tasks;

class Program
{
  static async Task Main(){
    try{
      const String _baseUrl = "https://api.apidash.dev";
      var client = new RestClient(_baseUrl);

      var request = new RestRequest("/humanize/social", Method.Get);

      request.AddQueryParameter("num", "8700000");
      request.AddQueryParameter("digits", "3");
      request.AddQueryParameter("system", "SS");
      request.AddQueryParameter("add_space", "true");
      request.AddQueryParameter("trailing_zeros", "true");

      var response = await client.ExecuteAsync(request);
      Console.WriteLine("Status Code: " + (int)response.StatusCode);
      Console.WriteLine("Response Content: " + response.Content);
    }
    catch(Exception ex){
      Console.WriteLine("Error: " + ex);
    }
  }
}
""";

      expect(
          codegen.getCode(
              CodegenLanguage.cSharpRestSharp, requestModelGet4, "https"),
          expectedCode);
    });

    test("Get 5", () {
      const expectedCode = r"""
using System;
using RestSharp;
using System.Threading.Tasks;

class Program
{
  static async Task Main(){
    try{
      const String _baseUrl = "https://api.github.com";
      var client = new RestClient(_baseUrl);

      var request = new RestRequest("/repos/foss42/apidash", Method.Get);

      request.AddHeader("User-Agent", "Test Agent");

      var response = await client.ExecuteAsync(request);
      Console.WriteLine("Status Code: " + (int)response.StatusCode);
      Console.WriteLine("Response Content: " + response.Content);
    }
    catch(Exception ex){
      Console.WriteLine("Error: " + ex);
    }
  }
}
""";

      expect(
          codegen.getCode(
              CodegenLanguage.cSharpRestSharp, requestModelGet5, "https"),
          expectedCode);
    });

    test("Get 6", () {
      const expectedCode = r"""
using System;
using RestSharp;
using System.Threading.Tasks;

class Program
{
  static async Task Main(){
    try{
      const String _baseUrl = "https://api.github.com";
      var client = new RestClient(_baseUrl);

      var request = new RestRequest("/repos/foss42/apidash", Method.Get);

      request.AddQueryParameter("raw", "true");

      request.AddHeader("User-Agent", "Test Agent");

      var response = await client.ExecuteAsync(request);
      Console.WriteLine("Status Code: " + (int)response.StatusCode);
      Console.WriteLine("Response Content: " + response.Content);
    }
    catch(Exception ex){
      Console.WriteLine("Error: " + ex);
    }
  }
}
""";

      expect(
          codegen.getCode(
              CodegenLanguage.cSharpRestSharp, requestModelGet6, "https"),
          expectedCode);
    });

    test("Get 7", () {
      const expectedCode = r"""
using System;
using RestSharp;
using System.Threading.Tasks;

class Program
{
  static async Task Main(){
    try{
      const String _baseUrl = "https://api.apidash.dev";
      var client = new RestClient(_baseUrl);

      var request = new RestRequest("", Method.Get);

      var response = await client.ExecuteAsync(request);
      Console.WriteLine("Status Code: " + (int)response.StatusCode);
      Console.WriteLine("Response Content: " + response.Content);
    }
    catch(Exception ex){
      Console.WriteLine("Error: " + ex);
    }
  }
}
""";

      expect(
          codegen.getCode(
              CodegenLanguage.cSharpRestSharp, requestModelGet7, "https"),
          expectedCode);
    });

    test("Get 8", () {
      const expectedCode = r"""
using System;
using RestSharp;
using System.Threading.Tasks;

class Program
{
  static async Task Main(){
    try{
      const String _baseUrl = "https://api.github.com";
      var client = new RestClient(_baseUrl);

      var request = new RestRequest("/repos/foss42/apidash", Method.Get);

      request.AddQueryParameter("raw", "true");

      request.AddHeader("User-Agent", "Test Agent");

      var response = await client.ExecuteAsync(request);
      Console.WriteLine("Status Code: " + (int)response.StatusCode);
      Console.WriteLine("Response Content: " + response.Content);
    }
    catch(Exception ex){
      Console.WriteLine("Error: " + ex);
    }
  }
}
""";
      expect(
          codegen.getCode(
              CodegenLanguage.cSharpRestSharp, requestModelGet8, "https"),
          expectedCode);
    });

    test("Get 9", () {
      const expectedCode = r"""
using System;
using RestSharp;
using System.Threading.Tasks;

class Program
{
  static async Task Main(){
    try{
      const String _baseUrl = "https://api.apidash.dev";
      var client = new RestClient(_baseUrl);

      var request = new RestRequest("/humanize/social", Method.Get);

      request.AddQueryParameter("num", "8700000");
      request.AddQueryParameter("add_space", "true");

      var response = await client.ExecuteAsync(request);
      Console.WriteLine("Status Code: " + (int)response.StatusCode);
      Console.WriteLine("Response Content: " + response.Content);
    }
    catch(Exception ex){
      Console.WriteLine("Error: " + ex);
    }
  }
}
""";
      expect(
          codegen.getCode(
              CodegenLanguage.cSharpRestSharp, requestModelGet9, "https"),
          expectedCode);
    });

    test("Get 10", () {
      const expectedCode = r"""
using System;
using RestSharp;
using System.Threading.Tasks;

class Program
{
  static async Task Main(){
    try{
      const String _baseUrl = "https://api.apidash.dev";
      var client = new RestClient(_baseUrl);

      var request = new RestRequest("/humanize/social", Method.Get);

      request.AddHeader("User-Agent", "Test Agent");

      var response = await client.ExecuteAsync(request);
      Console.WriteLine("Status Code: " + (int)response.StatusCode);
      Console.WriteLine("Response Content: " + response.Content);
    }
    catch(Exception ex){
      Console.WriteLine("Error: " + ex);
    }
  }
}
""";
      expect(
          codegen.getCode(
              CodegenLanguage.cSharpRestSharp, requestModelGet10, "https"),
          expectedCode);
    });

    test("Get 11", () {
      const expectedCode = r"""
using System;
using RestSharp;
using System.Threading.Tasks;

class Program
{
  static async Task Main(){
    try{
      const String _baseUrl = "https://api.apidash.dev";
      var client = new RestClient(_baseUrl);

      var request = new RestRequest("/humanize/social", Method.Get);

      request.AddQueryParameter("num", "8700000");
      request.AddQueryParameter("digits", "3");

      request.AddHeader("User-Agent", "Test Agent");

      var response = await client.ExecuteAsync(request);
      Console.WriteLine("Status Code: " + (int)response.StatusCode);
      Console.WriteLine("Response Content: " + response.Content);
    }
    catch(Exception ex){
      Console.WriteLine("Error: " + ex);
    }
  }
}
""";
      expect(
          codegen.getCode(
              CodegenLanguage.cSharpRestSharp, requestModelGet11, "https"),
          expectedCode);
    });

    test("Get 12", () {
      const expectedCode = r"""
using System;
using RestSharp;
using System.Threading.Tasks;

class Program
{
  static async Task Main(){
    try{
      const String _baseUrl = "https://api.apidash.dev";
      var client = new RestClient(_baseUrl);

      var request = new RestRequest("/humanize/social", Method.Get);

      var response = await client.ExecuteAsync(request);
      Console.WriteLine("Status Code: " + (int)response.StatusCode);
      Console.WriteLine("Response Content: " + response.Content);
    }
    catch(Exception ex){
      Console.WriteLine("Error: " + ex);
    }
  }
}
""";
      expect(
          codegen.getCode(
              CodegenLanguage.cSharpRestSharp, requestModelGet12, "https"),
          expectedCode);
    });
  });

  group("Head Request Test", () {
    test("Head 1", () {
      const expectedCode = r"""
using System;
using RestSharp;
using System.Threading.Tasks;

class Program
{
  static async Task Main(){
    try{
      const String _baseUrl = "https://api.apidash.dev";
      var client = new RestClient(_baseUrl);

      var request = new RestRequest("", Method.Head);

      var response = await client.ExecuteAsync(request);
      Console.WriteLine("Status Code: " + (int)response.StatusCode);
      Console.WriteLine("Response Content: " + response.Content);
    }
    catch(Exception ex){
      Console.WriteLine("Error: " + ex);
    }
  }
}
""";
      expect(
          codegen.getCode(
              CodegenLanguage.cSharpRestSharp, requestModelHead1, "https"),
          expectedCode);
    });

    test("Head 2", () {
      const expectedCode = r"""
using System;
using RestSharp;
using System.Threading.Tasks;

class Program
{
  static async Task Main(){
    try{
      const String _baseUrl = "http://api.apidash.dev";
      var client = new RestClient(_baseUrl);

      var request = new RestRequest("", Method.Head);

      var response = await client.ExecuteAsync(request);
      Console.WriteLine("Status Code: " + (int)response.StatusCode);
      Console.WriteLine("Response Content: " + response.Content);
    }
    catch(Exception ex){
      Console.WriteLine("Error: " + ex);
    }
  }
}
""";
      expect(
          codegen.getCode(
              CodegenLanguage.cSharpRestSharp, requestModelHead2, "http"),
          expectedCode);
    });
  });

  group("Post Request Test", () {
    test("Post 1", () {
      const expectedCode = r"""
using System;
using RestSharp;
using System.Threading.Tasks;

class Program
{
  static async Task Main(){
    try{
      const String _baseUrl = "https://api.apidash.dev";
      var client = new RestClient(_baseUrl);

      var request = new RestRequest("/case/lower", Method.Post);

      request.AddHeader("Content-Type", "text/plain");

      var textBody = "{\n\"text\": \"I LOVE Flutter\"\n}";
      request.AddStringBody(textBody, ContentType.Plain);

      var response = await client.ExecuteAsync(request);
      Console.WriteLine("Status Code: " + (int)response.StatusCode);
      Console.WriteLine("Response Content: " + response.Content);
    }
    catch(Exception ex){
      Console.WriteLine("Error: " + ex);
    }
  }
}
""";
      expect(
          codegen.getCode(
              CodegenLanguage.cSharpRestSharp, requestModelPost1, "https"),
          expectedCode);
    });
    test("Post 2", () {
      const expectedCode = """
using System;
using RestSharp;
using System.Threading.Tasks;

class Program
{
  static async Task Main(){
    try{
      const String _baseUrl = "https://api.apidash.dev";
      var client = new RestClient(_baseUrl);

      var request = new RestRequest("/case/lower", Method.Post);

      request.AddHeader("Content-Type", "application/json");

      var jsonBody = new {
text = "I LOVE Flutter",
flag = "null",
male = "true",
female = "false",
no = "1.2",
arr = "[null, true, false, null]"
};
      request.AddJsonBody(jsonBody);

      var response = await client.ExecuteAsync(request);
      Console.WriteLine("Status Code: " + (int)response.StatusCode);
      Console.WriteLine("Response Content: " + response.Content);
    }
    catch(Exception ex){
      Console.WriteLine("Error: " + ex);
    }
  }
}
""";
      expect(
          codegen.getCode(
              CodegenLanguage.cSharpRestSharp, requestModelPost2, "https"),
          expectedCode);
    });
    test("Post 3", () {
      const expectedCode = """
using System;
using RestSharp;
using System.Threading.Tasks;

class Program
{
  static async Task Main(){
    try{
      const String _baseUrl = "https://api.apidash.dev";
      var client = new RestClient(_baseUrl);

      var request = new RestRequest("/case/lower", Method.Post);

      request.AddHeader("User-Agent", "Test Agent");
      request.AddHeader("Content-Type", "application/json");

      var jsonBody = new {
text = "I LOVE Flutter"
};
      request.AddJsonBody(jsonBody);

      var response = await client.ExecuteAsync(request);
      Console.WriteLine("Status Code: " + (int)response.StatusCode);
      Console.WriteLine("Response Content: " + response.Content);
    }
    catch(Exception ex){
      Console.WriteLine("Error: " + ex);
    }
  }
}
""";
      expect(
          codegen.getCode(
              CodegenLanguage.cSharpRestSharp, requestModelPost3, "https"),
          expectedCode);
    });
    test("Post 4", () {
      const expectedCode = r"""
using System;
using RestSharp;
using System.Threading.Tasks;

class Program
{
  static async Task Main(){
    try{
      const String _baseUrl = "https://api.apidash.dev";
      var client = new RestClient(_baseUrl);

      var request = new RestRequest("/io/form", Method.Post);

      request.AlwaysMultipartFormData = true;
      request.AddParameter("text", "API", ParameterType.GetOrPost);
      request.AddParameter("sep", "|", ParameterType.GetOrPost);
      request.AddParameter("times", "3", ParameterType.GetOrPost);

      var response = await client.ExecuteAsync(request);
      Console.WriteLine("Status Code: " + (int)response.StatusCode);
      Console.WriteLine("Response Content: " + response.Content);
    }
    catch(Exception ex){
      Console.WriteLine("Error: " + ex);
    }
  }
}
""";
      expect(
          codegen.getCode(
              CodegenLanguage.cSharpRestSharp, requestModelPost4, "https"),
          expectedCode);
    });
    test("Post 5", () {
      const expectedCode = r"""
using System;
using RestSharp;
using System.Threading.Tasks;

class Program
{
  static async Task Main(){
    try{
      const String _baseUrl = "https://api.apidash.dev";
      var client = new RestClient(_baseUrl);

      var request = new RestRequest("/io/form", Method.Post);

      request.AddHeader("User-Agent", "Test Agent");

      request.AlwaysMultipartFormData = true;
      request.AddParameter("text", "API", ParameterType.GetOrPost);
      request.AddParameter("sep", "|", ParameterType.GetOrPost);
      request.AddParameter("times", "3", ParameterType.GetOrPost);

      var response = await client.ExecuteAsync(request);
      Console.WriteLine("Status Code: " + (int)response.StatusCode);
      Console.WriteLine("Response Content: " + response.Content);
    }
    catch(Exception ex){
      Console.WriteLine("Error: " + ex);
    }
  }
}
""";
      expect(
          codegen.getCode(
              CodegenLanguage.cSharpRestSharp, requestModelPost5, "https"),
          expectedCode);
    });
    test("Post 6", () {
      const expectedCode = r"""
using System;
using RestSharp;
using System.Threading.Tasks;

class Program
{
  static async Task Main(){
    try{
      const String _baseUrl = "https://api.apidash.dev";
      var client = new RestClient(_baseUrl);

      var request = new RestRequest("/io/img", Method.Post);

      request.AlwaysMultipartFormData = true;
      var options = new FileParameterOptions
      {
          DisableFilenameEncoding = true
      };
      request.AddParameter("token", "xyz", ParameterType.GetOrPost);
      request.AddFile("imfile", "/Documents/up/1.png", options: options);

      var response = await client.ExecuteAsync(request);
      Console.WriteLine("Status Code: " + (int)response.StatusCode);
      Console.WriteLine("Response Content: " + response.Content);
    }
    catch(Exception ex){
      Console.WriteLine("Error: " + ex);
    }
  }
}
""";
      expect(
          codegen.getCode(
              CodegenLanguage.cSharpRestSharp, requestModelPost6, "https"),
          expectedCode);
    });
    test("Post 7", () {
      const expectedCode = r"""
using System;
using RestSharp;
using System.Threading.Tasks;

class Program
{
  static async Task Main(){
    try{
      const String _baseUrl = "https://api.apidash.dev";
      var client = new RestClient(_baseUrl);

      var request = new RestRequest("/io/img", Method.Post);

      request.AlwaysMultipartFormData = true;
      var options = new FileParameterOptions
      {
          DisableFilenameEncoding = true
      };
      request.AddParameter("token", "xyz", ParameterType.GetOrPost);
      request.AddFile("imfile", "/Documents/up/1.png", options: options);

      var response = await client.ExecuteAsync(request);
      Console.WriteLine("Status Code: " + (int)response.StatusCode);
      Console.WriteLine("Response Content: " + response.Content);
    }
    catch(Exception ex){
      Console.WriteLine("Error: " + ex);
    }
  }
}
""";
      expect(
          codegen.getCode(
              CodegenLanguage.cSharpRestSharp, requestModelPost7, "https"),
          expectedCode);
    });
    test("Post 8", () {
      const expectedCode = r"""
using System;
using RestSharp;
using System.Threading.Tasks;

class Program
{
  static async Task Main(){
    try{
      const String _baseUrl = "https://api.apidash.dev";
      var client = new RestClient(_baseUrl);

      var request = new RestRequest("/io/form", Method.Post);

      request.AddQueryParameter("size", "2");
      request.AddQueryParameter("len", "3");

      request.AlwaysMultipartFormData = true;
      request.AddParameter("text", "API", ParameterType.GetOrPost);
      request.AddParameter("sep", "|", ParameterType.GetOrPost);
      request.AddParameter("times", "3", ParameterType.GetOrPost);

      var response = await client.ExecuteAsync(request);
      Console.WriteLine("Status Code: " + (int)response.StatusCode);
      Console.WriteLine("Response Content: " + response.Content);
    }
    catch(Exception ex){
      Console.WriteLine("Error: " + ex);
    }
  }
}
""";
      expect(
          codegen.getCode(
              CodegenLanguage.cSharpRestSharp, requestModelPost8, "https"),
          expectedCode);
    });
    test("Post 9", () {
      const expectedCode = r"""
using System;
using RestSharp;
using System.Threading.Tasks;

class Program
{
  static async Task Main(){
    try{
      const String _baseUrl = "https://api.apidash.dev";
      var client = new RestClient(_baseUrl);

      var request = new RestRequest("/io/img", Method.Post);

      request.AddQueryParameter("size", "2");
      request.AddQueryParameter("len", "3");

      request.AddHeader("User-Agent", "Test Agent");
      request.AddHeader("Keep-Alive", "true");

      request.AlwaysMultipartFormData = true;
      var options = new FileParameterOptions
      {
          DisableFilenameEncoding = true
      };
      request.AddParameter("token", "xyz", ParameterType.GetOrPost);
      request.AddFile("imfile", "/Documents/up/1.png", options: options);

      var response = await client.ExecuteAsync(request);
      Console.WriteLine("Status Code: " + (int)response.StatusCode);
      Console.WriteLine("Response Content: " + response.Content);
    }
    catch(Exception ex){
      Console.WriteLine("Error: " + ex);
    }
  }
}
""";
      expect(
          codegen.getCode(
              CodegenLanguage.cSharpRestSharp, requestModelPost9, "https"),
          expectedCode);
    });
  });

  group("Put Request Test", () {
    test("Put 1", () {
      const expectedCode = """
using System;
using RestSharp;
using System.Threading.Tasks;

class Program
{
  static async Task Main(){
    try{
      const String _baseUrl = "https://reqres.in";
      var client = new RestClient(_baseUrl);

      var request = new RestRequest("/api/users/2", Method.Put);

      request.AddHeader("Content-Type", "application/json");

      var jsonBody = new {
name = "morpheus",
job = "zion resident"
};
      request.AddJsonBody(jsonBody);

      var response = await client.ExecuteAsync(request);
      Console.WriteLine("Status Code: " + (int)response.StatusCode);
      Console.WriteLine("Response Content: " + response.Content);
    }
    catch(Exception ex){
      Console.WriteLine("Error: " + ex);
    }
  }
}
""";
      expect(
          codegen.getCode(
              CodegenLanguage.cSharpRestSharp, requestModelPut1, "https"),
          expectedCode);
    });
  });

  group("Patch Request Test", () {
    test("Patch 1", () {
      const expectedCode = """
using System;
using RestSharp;
using System.Threading.Tasks;

class Program
{
  static async Task Main(){
    try{
      const String _baseUrl = "https://reqres.in";
      var client = new RestClient(_baseUrl);

      var request = new RestRequest("/api/users/2", Method.Patch);

      request.AddHeader("Content-Type", "application/json");

      var jsonBody = new {
name = "marfeus",
job = "accountant"
};
      request.AddJsonBody(jsonBody);

      var response = await client.ExecuteAsync(request);
      Console.WriteLine("Status Code: " + (int)response.StatusCode);
      Console.WriteLine("Response Content: " + response.Content);
    }
    catch(Exception ex){
      Console.WriteLine("Error: " + ex);
    }
  }
}
""";
      expect(
          codegen.getCode(
              CodegenLanguage.cSharpRestSharp, requestModelPatch1, "https"),
          expectedCode);
    });
  });

  group("Delete Request Test", () {
    test("Delete 1", () {
      const expectedCode = """
using System;
using RestSharp;
using System.Threading.Tasks;

class Program
{
  static async Task Main(){
    try{
      const String _baseUrl = "https://reqres.in";
      var client = new RestClient(_baseUrl);

      var request = new RestRequest("/api/users/2", Method.Delete);

      var response = await client.ExecuteAsync(request);
      Console.WriteLine("Status Code: " + (int)response.StatusCode);
      Console.WriteLine("Response Content: " + response.Content);
    }
    catch(Exception ex){
      Console.WriteLine("Error: " + ex);
    }
  }
}
""";
      expect(
          codegen.getCode(
              CodegenLanguage.cSharpRestSharp, requestModelDelete1, "https"),
          expectedCode);
    });
    test("Delete 2", () {
      const expectedCode = """
using System;
using RestSharp;
using System.Threading.Tasks;

class Program
{
  static async Task Main(){
    try{
      const String _baseUrl = "https://reqres.in";
      var client = new RestClient(_baseUrl);

      var request = new RestRequest("/api/users/2", Method.Delete);

      request.AddHeader("Content-Type", "application/json");

      var jsonBody = new {
name = "marfeus",
job = "accountant"
};
      request.AddJsonBody(jsonBody);

      var response = await client.ExecuteAsync(request);
      Console.WriteLine("Status Code: " + (int)response.StatusCode);
      Console.WriteLine("Response Content: " + response.Content);
    }
    catch(Exception ex){
      Console.WriteLine("Error: " + ex);
    }
  }
}
""";
      expect(
          codegen.getCode(
              CodegenLanguage.cSharpRestSharp, requestModelDelete2, "https"),
          expectedCode);
    });
  });
}
