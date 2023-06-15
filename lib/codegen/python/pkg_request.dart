import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/models/models.dart' show RequestModel;

class PythonRequestCodeGen {
  String kPythonTemplate = '''
import requests

def main():
    url = '{{url}}'

    {{params}}

    {{body}}

    headers = {{headers}}

    response = requests.{{method}}(url{{request_headers}}{{request_body}})

    status_code = response.status_code
    if 200 <= status_code < 300:
        print('Status Code:', status_code)
        print('Response Body:', response.text)
    else:
        print('Error Status Code:', status_code)
        print('Error Response Body:', response.text)

main()
''';

  String? getCode(RequestModel requestModel, String defaultUriScheme) {
    try {
      bool hasHeaders = false;
      bool hasBody = false;

      String url = requestModel.url;
      if (!url.contains('://') && url.isNotEmpty) {
        url = '$defaultUriScheme://$url';
      }

      var paramsList = requestModel.requestParams;
      String params = '';
      if (paramsList != null) {
        params = '';
        for (var param in paramsList) {
          params += '${param.k} = ${param.v}\n    ';
        }
      }

      var method = requestModel.method.name.toLowerCase();

      var requestBody = requestModel.requestBody;
      String requestBodyString = '';
      if (requestBody != null) {
        hasBody = true;
        requestBodyString = "data = '''$requestBody'''\n    ";
      }

      var headersList = requestModel.requestHeaders;
      String headers = '';
      if (headersList != null || hasBody) {
        headers = '';
        for (var header in headersList ?? []) {
          headers += "'${header.k}': '${header.v}',\n    ";
        }
        if (hasBody) {
          headers +=
              "'Content-Type': '${requestModel.requestBodyContentType}',\n    ";
        }
        hasHeaders = headers.isNotEmpty;
      }

      var template = jj.Template(kPythonTemplate);
      var pythonCode = template.render({
        'url': url,
        'params': params,
        'body': requestBodyString,
        'headers': '{\n    $headers}',
        'method': method,
        'request_headers': hasHeaders ? 'headers=headers,\n    ' : '',
        'request_body': hasBody ? 'data=data,\n    ' : '',
      });

      return pythonCode;
    } catch (e) {
      return null;
    }
  }
}
