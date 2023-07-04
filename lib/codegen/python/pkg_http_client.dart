import 'package:apidash/consts.dart';

import '../../models/request_model.dart';

class PythonHttpClient {
  final String headerSnippet = """
import http.client
import json

""";

  final String footerSnippet = """
res = conn.getresponse()
data = res.read()
print(data.decode("utf-8"))
""";

  String getCode(RequestModel requestModel) {
    String result = "";
    result += headerSnippet;
    result +=
        "conn = http.client.HTTPSConnection('${getUrl(requestModel)["host"]}'${getUrl(requestModel)["port"]})\n";
    result += "payload = json.dumps(${requestModel.requestBody ?? ""})\n";
    result +=
        """headers = {\n'Content-Type':'${requestModel.requestBodyContentType == ContentType.json ? 'application/json' : 'text/plain'}'\n${addHeaders(requestModel)}},\n""";
    result +=
        "conn.request(\"${requestModel.method.name.toUpperCase()}\", \"${getUrl(requestModel)["endpoint"]}${addQueryParams(requestModel)}\", payload, headers)\n";
    result += footerSnippet;

    return result;
  }

  String addHeaders(RequestModel requestModel) {
    String result = "";
    if (requestModel.requestHeaders == null) {
      return result;
    }
    for (final header in requestModel.requestHeaders!) {
      result += """'${header.k}':'${header.v}',\n""";
    }
    return result;
  }

  String addQueryParams(RequestModel requestModel) {
    String result = "";
    if (requestModel.requestParams == null) {
      return result;
    }
    result += "?";
    for (final queryParam in requestModel.requestParams!) {
      result +=
          "${queryParam.k.replaceAll(" ", "%20")}=${queryParam.v.replaceAll(" ", "%20")}&";
    }
    return result.substring(0, result.length - 1);
  }

  Map<String, String> getUrl(RequestModel requestModel) {
    String result = "";
    if (requestModel.url.startsWith('http://') ||
        requestModel.url.startsWith('https://')) {
      result = requestModel.url.substring(requestModel.url.indexOf('://') + 3);
    }else{
      result = requestModel.url;
    }
    Map<String, String> resultMap = {};
    if (result.contains(":")) {
      resultMap["host"] = result.substring(0, result.indexOf(':'));
      resultMap["port"] =
          ",${result.substring(result.indexOf(':') + 1, result.contains('/') ? result.indexOf('/') : result.length)}";
      resultMap["endpoint"] =
          "/${result.substring(result.contains('/') ? result.indexOf('/') + 1 : result.length)}";
    } else {
      resultMap["host"] = result.contains("/")
          ? result.substring(0, result.indexOf('/'))
          : result;
      resultMap["port"] = "";
      resultMap["endpoint"] =
          "/${result.substring(result.contains('/') ? result.indexOf('/') + 1 : result.length)}";
    }
    return resultMap;
  }
}
