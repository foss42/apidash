import '../../models/request_model.dart';

class CSharpHttpClientCodeGen {
  String getCode(RequestModel requestModel) {
    try {
      StringBuffer result = StringBuffer();

      // Include necessary C# namespace
      result.writeln('using System;');
      result.writeln('using System.Net.Http;');
      result.writeln('using System.Threading.Tasks;');

      // Define class
      result.writeln('public class ApiCaller {');

      // Define method for making API call
      result.writeln('  public async Task<string> MakeRequestAsync() {');

      // Initialize HttpClient
      result.writeln('    using (var client = new HttpClient()) {');

      // Set request URL
      result.writeln('      var url = "${requestModel.url}";');

      // Set request method
      result.writeln('      var method = HttpMethod.${requestModel.method};');

      // Create HttpRequestMessage
      result.writeln('      var request = new HttpRequestMessage(method, url);');

      // Set request headers
      var headersList = requestModel.enabledRequestHeaders;
      if (headersList != null && headersList.isNotEmpty) {
        for (var header in headersList) {
          result.writeln(
            '      request.Headers.Add("${header.name}", "${header.value}");',
          );
        }
      }

      // Set request body if exists
      var requestBody = requestModel.requestBody;
      if (requestBody != null && requestBody.isNotEmpty) {
        result.writeln('      request.Content = new StringContent("$requestBody");');
      }

      // Send request and get response
      result.writeln('      var response = await client.SendAsync(request);');
      result.writeln('      var responseBody = await response.Content.ReadAsStringAsync();');
      result.writeln('      return responseBody;');
      result.writeln('    }');

      // Close method
      result.writeln('  }');

      // Close class
      result.writeln('}');

      return result.toString();
    } catch (e) {
      return '';
    }
  }
}
