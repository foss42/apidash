import 'dart:convert';
import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart' show rowsToMap;
import 'package:apidash/models/models.dart' show RequestModel;

Map<String, dynamic> convertRequestModelToHARJson(RequestModel requestModel) {
  Map<String, dynamic> json = {};
  bool hasBody = false;

  json["method"] = requestModel.method.name.toUpperCase();
  json["url"] = requestModel.url;
  json["httpVersion"] = "HTTP/1.1";
  json["queryString"] = [];
  json["headers"] = [];

  var paramsList = requestModel.requestParams;
  if (paramsList != null) {
    var params = rowsToMap(requestModel.requestParams) ?? {};
    if (params.isNotEmpty) {
      for (final k in params.keys) {
        json["queryString"].add({"name": k, "value": params[k]});
      }
    }
  }

  var method = requestModel.method;
  var requestBody = requestModel.requestBody;
  if (kMethodsWithBody.contains(method) && requestBody != null) {
    var contentLength = utf8.encode(requestBody).length;
    if (contentLength > 0) {
      hasBody = true;
      json["postData"] = {};
      json["postData"]["mimeType"] =
          kContentTypeMap[requestModel.requestBodyContentType] ?? "";
      json["postData"]["text"] = requestBody;
    }
  }

  var headersList = requestModel.requestHeaders;
  if (headersList != null || hasBody) {
    var headers = rowsToMap(requestModel.requestHeaders) ?? {};
    if (headers.isNotEmpty || hasBody) {
      if (hasBody) {
        json["headers"].add({
          "name": "Content-Type",
          "value": kContentTypeMap[requestModel.requestBodyContentType] ?? ""
        });
      }
      for (final k in headers.keys) {
        json["headers"].add({"name": k, "value": headers[k]});
      }
    }
  }

  return json;
}

class HARCodeGen {
  String? getCode(RequestModel requestModel) {
    try {
      var harString =
          kEncoder.convert(convertRequestModelToHARJson(requestModel));
      return harString;
    } catch (e) {
      return null;
    }
  }
}
