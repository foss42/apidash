class APIDashRequestDescription {
  final String endpoint;
  final String method;
  final Map<String, dynamic>? queryParams;
  final List<Map>? formData;
  final Map<String, dynamic>? headers;
  final String? bodyTXT;
  final Map? bodyJSON;
  final String? responseType;
  final dynamic response;

  APIDashRequestDescription({
    required this.endpoint,
    required this.method,
    this.queryParams,
    this.formData,
    this.headers,
    this.bodyTXT,
    this.bodyJSON,
    this.responseType,
    this.response,
  });

  String get generateREQDATA {
    //Note Down the Query parameters
    String queryParamStr = '';
    if (queryParams != null) {
      for (final x in queryParams!.keys) {
        queryParamStr +=
            '\t$x: ${queryParams![x]} <${queryParams![x].runtimeType}>\n';
      }
      queryParamStr = 'QUERY_PARAMETERS: {\n$queryParamStr}';
    }

    //Note Down the Headers
    String headersStr = '';
    if (headers != null) {
      for (final x in headers!.keys) {
        headersStr += '\t$x: ${headers![x]} <${headers![x].runtimeType}>\n';
      }
      headersStr = 'HEADERS: {\n$headersStr}';
    }

    String bodyDetails = '';
    if (bodyTXT != null) {
      bodyDetails = 'BODY_TYPE: TEXT\nBODY_TEXT:$bodyTXT';
    } else if (bodyJSON != null) {
      //Note Down the JSONData
      String jsonBodyStr = '';
      if (bodyJSON != null) {
        getTyp(input, [i = 0]) {
          String indent = "\t";
          for (int j = 0; j < i; j++) {
            indent += "\t";
          }
          if (input.runtimeType.toString().toLowerCase().contains('map')) {
            String typd = '{';
            for (final z in input.keys) {
              typd += "$indent$z: TYPE: ${getTyp(input[z], i + 1)}\n";
            }
            return "$indent$typd}";
          }
          return input.runtimeType.toString();
        }

        for (final x in bodyJSON!.keys) {
          jsonBodyStr += '\t$x: TYPE: <${getTyp(bodyJSON![x])}>\n';
        }
        jsonBodyStr = 'BODY_JSON: {\n$jsonBodyStr}';
      }
      bodyDetails = 'BODY_TYPE: JSON\n$jsonBodyStr';
    } else if (formData != null) {
      //Note Down the FormData
      String formDataStr = '';
      if (formData != null) {
        for (final x in formData!) {
          formDataStr += '\t$x\n';
        }
        formDataStr = 'BODY_FORM_DATA: {\n$formDataStr}';
      }
      bodyDetails = 'BODY_TYPE: FORM-DATA\n$formDataStr';
    }

    String responseDetails = '';
    if (responseType != null && response != null) {
      responseDetails =
          '-----RESPONSE_DETAILS-----\nRESPONSE_TYPE: $responseType\nRESPONSE_BODY: $response';
    }

    return """REST API (HTTP)
METHOD: $method
ENDPOINT: $endpoint
HEADERS: ${headersStr.isEmpty ? '{}' : headersStr}
$queryParamStr
$bodyDetails
$responseDetails
""";
  }
}
