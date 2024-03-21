import 'dart:convert';
import 'package:apidash/utils/har_utils.dart';
import 'package:apidash/utils/http_utils.dart';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/models/models.dart' show RequestModel;
import 'package:apidash/consts.dart';

class JavaUnirestGen {
  final String kTemplateUnirestImports = '''
import kong.unirest.core.*;\n
''';

  final String kTemplateFileIoImports = '''
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;\n
''';
  final String kTemplateStart = '''
public class Main {
    public static void main(String[] args) {
''';

  final String kTemplateUrl = '''
        final String requestURL = "{{url}}";\n
''';

  final String kTemplateRequestBodyContent = '''
        final String requestBody = "{{body}}";\n
''';

  final String kTemplateRequestCreation = '''
        HttpResponse<JsonNode> response = Unirest
                .{{method}}(requestURL)\n
''';

  final String kTemplateRequestHeader = '''
                .header("{{name}}", "{{value}}")\n
''';

  final String kTemplateContentType = '''
                .contentType("{{contentType}}")\n
''';

  final String kTemplateUrlQueryParam = '''
                .queryString("{{name}}", "{{value}}")\n
''';

  final String kTemplateRequestTextFormData = '''
                .field("{{name}}", "{{value}}")\n
''';

  final String kTemplateRequestFileFormData = '''
                .field("{{name}}", new File("{{value}}"))\n
''';

  final String kTemplateRequestBodySetup = '''
                .body(requestBody)\n
''';

  final String kTemplateBoundarySetup = '''
                .boundary("{{boundary}}")\n
''';

  final String kTemplateRequestEnd = """
                .asJson();
        System.out.println(response.getStatus());
        System.out.println(response.getBody());
    }
}\n
""";

  String? getCode(RequestModel requestModel, String? boundary) {
    try {
      String result = '';
      bool hasBody = false;

      var rec = getValidRequestUri(
        requestModel.url,
        requestModel.enabledRequestParams,
      );

      // uri is already generated based on url and enabled request params
      Uri? uri = rec.$1;

      if (uri == null) {
        return "";
      }

      // this is the common import and will be imported for every generated code snippet
      result += kTemplateUnirestImports;

      // java file io packages are to be imported only when there is a form with file present
      if (requestModel.hasBody &&
          kMethodsWithBody.contains(requestModel.method) &&
          requestModel.hasFormData &&
          requestModel.hasFileInFormData) {
        result += kTemplateFileIoImports;
      }

      // adding the main method under Main class
      result += kTemplateStart;

      var url = stripUriParams(uri);

      // contains the HTTP method associated with the request
      var method = requestModel.method;

      // contains the entire request body as a string if body is present
      var requestBody = requestModel.requestBody;

      // generating the URL to which the request has to be submitted
      var templateUrl = jj.Template(kTemplateUrl);
      result += templateUrl.render({"url": url});

      // creating request body if available
      var rM = requestModel.copyWith(url: url);
      var harJson = requestModelToHARJsonRequest(rM, useEnabled: true);

      // if request type is not form data, the request method can include
      // a body, and the body of the request is not null, in that case
      // we need to parse the body as it is, and write it to the body
      if (!requestModel.hasFormData &&
          kMethodsWithBody.contains(method) &&
          requestBody != null) {
        // find out the content length for the request, i.e. request body's size
        var contentLength = utf8.encode(requestBody).length;
        if (contentLength > 0) {
          var templateBodyContent = jj.Template(kTemplateRequestBodyContent);
          hasBody = true;
          if (harJson["postData"]?["text"] != null) {
            result += templateBodyContent.render({
              "body": kEncoder.convert(harJson["postData"]["text"]).substring(
                  1, kEncoder.convert(harJson["postData"]["text"]).length - 1)
            });
          }
        }
      }

      var templateRequestCreation = jj.Template(kTemplateRequestCreation);
      result +=
          templateRequestCreation.render({"method": method.name.toLowerCase()});

      // ~~~~~~~~~~~~~~~~~~ request header start ~~~~~~~~~~~~~~~~~~

      var m = <String, String>{};
      for (var i in harJson["headers"]) {
        m[i["name"]] = i["value"];
      }

      // especially sets up Content-Type header if the request has a body
      // and Content-Type is not explicitely set by the developer
      if (requestModel.hasBody &&
          requestModel.hasFormData &&
          !requestModel.hasFileInFormData) {
        m["Content-Type"] = "application/x-www-form-urlencoded";
      }

      // we will use this request boundary to set boundary if multipart formdata is used
      String requestBoundary = "";
      String multipartTypePrefix = "multipart/form-data; boundary=";
      if (m.containsKey("Content-Type") &&
          m["Content-Type"] != null &&
          m["Content-Type"]!.startsWith(RegExp(multipartTypePrefix))) {
        String tmp = m["Content-Type"]!;
        requestBoundary = tmp.substring(multipartTypePrefix.length);

        // if a boundary is provided, we will use that as the default boundary
        if (boundary != null) {
          requestBoundary = boundary;
          m["Content-Type"] = multipartTypePrefix + boundary;
        }
      }

      var templateRequestHeader = jj.Template(kTemplateRequestHeader);

      // setting up rest of the request headers
      m.forEach((name, value) {
        result += templateRequestHeader.render({"name": name, "value": value});
      });

      // if (hasBody && !m.containsKey("Content-Type")) {
      //   var templateContentType = jj.Template(kTemplateContentType);
      //   result += templateContentType.render(
      //       {"contentType": requestModel.requestBodyContentType.header});
      // }

      // ~~~~~~~~~~~~~~~~~~ request header ends ~~~~~~~~~~~~~~~~~~

      // ~~~~~~~~~~~~~~~~~~ query parameters start ~~~~~~~~~~~~~~~~~~

      if (uri.hasQuery) {
        var params = uri.queryParameters;
        var templateUrlQueryParam = jj.Template(kTemplateUrlQueryParam);
        params.forEach((name, value) {
          result +=
              templateUrlQueryParam.render({"name": name, "value": value});
        });
      }

      // ~~~~~~~~~~~~~~~~~~ query parameters end ~~~~~~~~~~~~~~~~~~

      // handling form data
      if (requestModel.hasFormData &&
          requestModel.formDataMapList.isNotEmpty &&
          kMethodsWithBody.contains(method)) {
        // including form data into the request
        var formDataList = requestModel.formDataMapList;
        var templateRequestTextFormData =
            jj.Template(kTemplateRequestTextFormData);
        var templateRequestFileFormData =
            jj.Template(kTemplateRequestFileFormData);
        for (var formDataMap in formDataList) {
          if (formDataMap["type"] == "text") {
            result += templateRequestTextFormData.render({
              "name": formDataMap['name'], //
              "value": formDataMap['value'] //
            });
          } else if (formDataMap["type"] == "file") {
            result += templateRequestFileFormData.render({
              "name": formDataMap['name'], //
              "value": formDataMap['value'] //
            });
          }
        }

        if (requestModel.hasFileInFormData) {
          var templateBoundarySetup = jj.Template(kTemplateBoundarySetup);
          result += templateBoundarySetup.render({"boundary": requestBoundary});
        }

        hasBody = true;
      }

      var templateRequestBodySetup = jj.Template(kTemplateRequestBodySetup);
      if (kMethodsWithBody.contains(method) &&
          hasBody &&
          !requestModel.hasFormData) {
        result += templateRequestBodySetup.render();
      }

      var templateRequestBodyEnd = jj.Template(kTemplateRequestEnd);
      result += templateRequestBodyEnd.render();

      return result;
    } catch (e) {
      return null;
    }
  }
}
