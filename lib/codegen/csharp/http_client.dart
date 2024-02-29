import 'package:apidash/consts.dart';

import '../../models/request_model.dart';

class CSharpHttpClientCodeGen {
  String getCustomRequestLiteral(HTTPVerb method) {
    switch (method) {
      case HTTPVerb.get:
        return "HttpMethod.Get";
      case HTTPVerb.post:
        return "HttpMethod.Post";
      case HTTPVerb.put:
        return "HttpMethod.Put";
      case HTTPVerb.head:
        return "HttpMethod.Head";
      case HTTPVerb.patch:
        return "HttpMethod.Path";
      case HTTPVerb.delete:
        return "HttpMethod.Delete";
      default:
        return "HttpMethod.Get";
    }
  }

  String getCode(RequestModel requestModel, String defaultUriScheme) {
    try {
      StringBuffer result = StringBuffer();

      // Include necessary C# namespace
      result.writeln('using System;');
      result.writeln('using System.Net.Http;');
      result.writeln('using System.Threading.Tasks;\n');

      // Set request URL
      result.writeln('string url = "${requestModel.url}";');

      // Set request method
      result.writeln('HttpMethod method = ${getCustomRequestLiteral(requestModel.method)};\n');

      // Initialize HttpClient
      result.writeln('using (HttpClient client = new HttpClient())\n{');

      // Create HttpRequestMessage
      result.writeln('    HttpRequestMessage request = new HttpRequestMessage(method, url);');

      // Set request headers
      var headersList = requestModel.enabledRequestHeaders;
      if (headersList != null && headersList.isNotEmpty) {
        result.writeln('    HttpRequestHeaderCollection headers = request.Headers;');
        for (var header in headersList) {
          result.writeln('    headers.Add("${header.name}", "${header.value}");');
        }
      }

      // Set request body if exists
      var requestBody = requestModel.requestBody;
      if (requestBody != null && requestBody.isNotEmpty) {
        result.writeln('    request.Content = new StringContent("$requestBody");');
      }

      // Send request and get response
      result.writeln('    HttpResponseMessage response = await client.SendAsync(request);');
      result.writeln('    string responseBody = await response.Content.ReadAsStringAsync();');
      result.writeln('    Console.WriteLine(responseBody);');
      result.writeln('}');

      return result.toString();
    } catch (e) {
      return '';
    }
  }
}
