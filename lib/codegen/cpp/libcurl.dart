import 'dart:convert';

import 'package:apidash/consts.dart';
import 'package:apidash/models/form_data_model.dart';
import 'package:apidash/utils/http_utils.dart';

import '../../models/request_model.dart';

class CppLibcurlCodeGen {
  String getCustomRequestLiteral(HTTPVerb method) {
    switch (method) {
      case HTTPVerb.get:
        return "GET";
      case HTTPVerb.post:
        return "POST";
      case HTTPVerb.put:
        return "PUT";
      case HTTPVerb.head:
        return "HEAD";
      case HTTPVerb.patch:
        return "PATCH";
      case HTTPVerb.delete:
        return "DELETE";
      default:
        return "GET";
    }
  }

  bool postableMethod(HTTPVerb method) {
    return method == HTTPVerb.post || method == HTTPVerb.put || method == HTTPVerb.patch;
  }

  String getPostFieldsFromRequestBody(String requestBody) {
    StringBuffer result = StringBuffer();
    var postFields = jsonEncode(jsonDecode(requestBody));
    result.writeln('    curl_easy_setopt(curl, CURLOPT_POST, 1L);');
    result.writeln(
        '    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, "${postFields.replaceAll('"', '\\"')}");');

    return result.toString();
  }

  String getPostFieldsFromFormData(List<FormDataModel> formDataList) {
    StringBuffer result = StringBuffer();

    // Initialize curl_httppost pointers
    result.writeln('  struct curl_httppost *formpost = NULL;');
    result.writeln('  struct curl_httppost *lastptr = NULL;');

    for (var formData in formDataList) {
      if (formData.type == FormDataType.text) {
        result.writeln(
            '  curl_formadd(&formpost, &lastptr, CURLFORM_COPYNAME, "${formData.name}", CURLFORM_COPYCONTENTS, "${formData.value}", CURLFORM_END);');
      } else if (formData.type == FormDataType.file) {
        result.writeln(
            '  curl_formadd(&formpost, &lastptr, CURLFORM_COPYNAME, "${formData.name}", CURLFORM_FILE, "${formData.value}", CURLFORM_END);');
      }
    }

    // Finalize form data setup
    result.writeln('  curl_easy_setopt(curl, CURLOPT_HTTPPOST, formpost);');

    return result.toString();
  }

  String getCode(RequestModel requestModel, String defaultUriScheme) {
    try {
      StringBuffer result = StringBuffer();

      // Include necessary C++ libraries
      result.writeln('#include <iostream>');
      result.writeln('#include <curl/curl.h>\n');

      // Main function
      result.writeln('int main() {');

      // Initialize libcurl
      result.writeln('  CURL *curl;');
      result.writeln('  CURLcode res;');
      result.writeln('  curl = curl_easy_init();\n');
      result.writeln('  if(curl) {');

      // Set URL
      String url = requestModel.url;
      if (!url.contains("://")) {
        url = "$defaultUriScheme://$url";
      }

      // URL params
      var rec = getValidRequestUri(
        requestModel.url,
        requestModel.enabledRequestParams,
      );
      Uri? uri = rec.$1;
      if (uri != null && uri.hasQuery) {
        var params = uri.queryParameters;
        if (params.isNotEmpty) {
          String queryParams = '';
          params.forEach((key, value) {
            queryParams += '${Uri.encodeQueryComponent(key)}=${Uri.encodeQueryComponent(value)}&';
          });
          queryParams =
              ((url.contains('?')) ? '&' : '?') + queryParams.substring(0, queryParams.length - 1);
          url += queryParams;
        }
      }

      result.writeln('    curl_easy_setopt(curl, CURLOPT_URL, "$url");');

      // Set request method
      result.writeln(
          '    curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "${getCustomRequestLiteral(requestModel.method)}");\n');

      // Set request headers
      var headersList = requestModel.enabledRequestHeaders;
      if (headersList != null && headersList.isNotEmpty) {
        result.writeln('    struct curl_slist *headers = NULL;');
        for (var header in headersList) {
          result.writeln(
              '    headers = curl_slist_append(headers, "${header.name}: ${header.value}");');
        }
        result.writeln('    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);\n');
      }

      if (postableMethod(requestModel.method)) {
        var requestBody = requestModel.requestBody;
        var formDataList = requestModel.formDataList;
        if (requestBody != null && requestBody.isNotEmpty) {
          result.writeln(getPostFieldsFromRequestBody(requestBody));
        }
        if (formDataList.isNotEmpty) {
          result.writeln(getPostFieldsFromFormData(formDataList));
        }
      }

      // Perform the request
      result.writeln('    res = curl_easy_perform(curl);');
      result.writeln('    if(res != CURLE_OK) {');
      result.writeln(
          '      std::cerr << "curl_easy_perform() failed: " << curl_easy_strerror(res) << std::endl;');
      result.writeln('    }\n');

      // Cleanup libcurl resources
      result.writeln('    curl_easy_cleanup(curl);');
      if (headersList != null && headersList.isNotEmpty) {
        result.writeln('    curl_slist_free_all(headers);');
      }
      result.writeln('  }\n');

      // Return code
      result.writeln('  return 0;');

      // Close main function
      result.writeln('}');

      return result.toString();
    } catch (e) {
      return '';
    }
  }
}
