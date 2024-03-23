import 'dart:convert';
import 'dart:io';
import 'package:jinja/jinja.dart' as jj;
import 'package:apidash/utils/utils.dart'
    show getValidRequestUri, requestModelToHARJsonRequest, stripUriParams;
import '../../models/request_model.dart';
import 'package:apidash/consts.dart';

class JavaHttpClientCodeGen {
  final String kTemplatePackageImportsForFormdata = '''
import java.io.File;
import java.util.List;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.HashMap;
import java.math.BigInteger;
import java.security.SecureRandom;
import java.io.ObjectOutputStream;
import java.io.ByteArrayOutputStream;
import java.nio.charset.StandardCharsets;
import java.util.Map;
''';

  final String kTemplatePackageImports = '''
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpHeaders;
import java.net.http.HttpRequest.BodyPublishers;
import java.net.http.HttpResponse.BodyHandlers;
''';

  final String kTemplateStartClass = '''

public class JavaHttpClientExample {
    public static void main(String[] args) throws IOException, InterruptedException {
        HttpClient client = HttpClient.newHttpClient();
''';

  final String kTemplateUrl = '''

        String url = "{{url}}";

''';

  final String kTemplateUrlQuery = '''

        url += "?" + "{{params}}";

''';

  final String kTemplateMultiPartBuilder = '''

        var bldr = new HTTPRequestMultipartBody.Builder();
''';

  final String kTemplateFormdataFieldsStarter = '''
        Map<String, String> mp = new HashMap<>() {
            {
''';

  final String kTemplateFormdataFields = '''
                put("{{name}}", "{{value}}");''';

  final String kTemplateFormdataFieldsEnder = '''
            }
        };

        for (String key : mp.keySet()) {
            bldr.addPart(key, mp.get(key));
        }

''';

  final String kTemplateFormdataFilesStarter = '''
        String[][] files = {''';

  final String kTemplateFormdataFiles = '''
                { "{{name}}", "{{value}}"}''';

  final String kTemplateFormdataFilesEnder = '''
        };

        for (int i = 0; i < files.length; ++i) {
            File f = new File(files[i][1]);
            bldr.addPart(files[i][0], f, null, f.getName());
        }

''';

  final String kTemplateMultiPartBuildCaller = '''
        HTTPRequestMultipartBody multipartBody = bldr.build();

''';

  String kTemplateRequestBody = '''

        String body = "{{body}}";

''';

  final String kStringRequestStart = '''

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
''';

  final String kTemplateRequestEndExceptPatchAndDelete = '''
                .{{method}}({{body}})
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}
''';

  final String kTemplateRequestEndForPatchAndDelete = '''
                .method("{{method}}", {{body}})
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}
''';

  final String kTemplateMultiPartBodyClass = '''\n
class HTTPRequestMultipartBody {

    private byte[] bytes;

    public String getBoundary() {
        return boundary;
    }

    public void setBoundary(String boundary) {
        this.boundary = boundary;
    }

    private String boundary;

    private HTTPRequestMultipartBody(byte[] bytes, String boundary) {
        this.bytes = bytes;
        this.boundary = boundary;
    }

    public String getContentType() {
        return "multipart/form-data; boundary=" + this.getBoundary();
    }

    public byte[] getBody() {
        return this.bytes;
    }

    public static class Builder {
        private final String DEFAULT_MIMETYPE = "text/plain";

        public static class MultiPartRecord {
            private String fieldName;
            private String filename;
            private String contentType;
            private Object content;

            public String getFieldName() {
                return fieldName;
            }

            public void setFieldName(String fieldName) {
                this.fieldName = fieldName;
            }

            public String getFilename() {
                return filename;
            }

            public void setFilename(String filename) {
                this.filename = filename;
            }

            public String getContentType() {
                return contentType;
            }

            public void setContentType(String contentType) {
                this.contentType = contentType;
            }

            public Object getContent() {
                return content;
            }

            public void setContent(Object content) {
                this.content = content;
            }
        }

        List<MultiPartRecord> parts;

        public Builder() {
            this.parts = new ArrayList<>();
        }

        public Builder addPart(String fieldName, String fieldValue) {
            MultiPartRecord part = new MultiPartRecord();
            part.setFieldName(fieldName);
            part.setContent(fieldValue);
            part.setContentType(DEFAULT_MIMETYPE);
            this.parts.add(part);
            return this;
        }

        public Builder addPart(String fieldName, String fieldValue, String contentType) {
            MultiPartRecord part = new MultiPartRecord();
            part.setFieldName(fieldName);
            part.setContent(fieldValue);
            part.setContentType(contentType);
            this.parts.add(part);
            return this;
        }

        public Builder addPart(String fieldName, Object fieldValue, String contentType, String fileName) {
            MultiPartRecord part = new MultiPartRecord();
            part.setFieldName(fieldName);
            part.setContent(fieldValue);
            part.setContentType(contentType);
            part.setFilename(fileName);
            this.parts.add(part);
            return this;
        }

        public HTTPRequestMultipartBody build() throws IOException {
            String boundary = new BigInteger(256, new SecureRandom()).toString();
            ByteArrayOutputStream out = new ByteArrayOutputStream();
            for (MultiPartRecord record : parts) {
                StringBuilder stringBuilder = new StringBuilder();
                stringBuilder.append(
                        "--" + boundary + "\\r\\n" + "Content-Disposition: form-data; name=\\"" + record.getFieldName());
                if (record.getFilename() != null) {
                    stringBuilder.append("\\"; filename=\\"" + record.getFilename());
                }
                out.write(stringBuilder.toString().getBytes(StandardCharsets.UTF_8));
                out.write(("\\"\\r\\n").getBytes(StandardCharsets.UTF_8));
                Object content = record.getContent();
                if (content instanceof String) {
                    out.write(("\\r\\n").getBytes(StandardCharsets.UTF_8));
                    out.write(((String) content).getBytes(StandardCharsets.UTF_8));
                } else if (content instanceof byte[]) {
                    out.write(("Content-Type: application/octet-stream\\r\\n").getBytes(StandardCharsets.UTF_8));
                    out.write((byte[]) content);
                } else if (content instanceof File) {
                    out.write(("Content-Type: application/octet-stream\\r\\n\\r\\n").getBytes(StandardCharsets.UTF_8));
                    Files.copy(((File) content).toPath(), out);
                } else {
                    out.write(("Content-Type: application/octet-stream\\r\\n").getBytes(StandardCharsets.UTF_8));
                    ObjectOutputStream objectOutputStream = new ObjectOutputStream(out);
                    objectOutputStream.writeObject(content);
                    objectOutputStream.flush();
                }
                out.write("\\r\\n".getBytes(StandardCharsets.UTF_8));
            }
            out.write(("--" + boundary + "--\\r\\n").getBytes(StandardCharsets.UTF_8));

            HTTPRequestMultipartBody httpRequestMultipartBody = new HTTPRequestMultipartBody(out.toByteArray(),
                    boundary);
            return httpRequestMultipartBody;
        }
    }
}
''';

  String? getCode(
    RequestModel requestModel,
  ) {
    try {
      String result = "";
      bool hasQuery = false;
      bool hasBody = false;
      bool hasJsonBody = false;

      var rec = getValidRequestUri(
        requestModel.url,
        requestModel.enabledRequestParams,
      );
      Uri? uri = rec.$1;

      if (uri != null) {
        // importing the packages
        if (requestModel.hasFormData) {
          result += kTemplatePackageImportsForFormdata;
        }
        result += kTemplatePackageImports;

        String url = stripUriParams(uri);

        var rM = requestModel.copyWith(url: url);
        var harJson = requestModelToHARJsonRequest(rM, useEnabled: true);

        // contains the HTTP method associated with the request
        var method = requestModel.method;

        // contains the entire request body as a string if body is present
        var requestBody = requestModel.requestBody;

        //adding the starting class for the generated code
        result += kTemplateStartClass;

        // generating the URL to which the request has to be submitted
        if (!hasQuery) {
          var templateUrl = jj.Template(kTemplateUrl);
          result += templateUrl.render({"url": url});
        }

        //adding the query  params
        if (uri.hasQuery) {
          var params = uri.queryParameters;

          if (params.isNotEmpty) {
            hasQuery = true;
            var templateParams = jj.Template(kTemplateUrlQuery);
            result += templateParams.render({"params": uri.query});
          }
        }

        //handling FormData
        if (requestModel.hasFormData &&
            requestModel.formDataMapList.isNotEmpty &&
            kMethodsWithBody.contains(method)) {
          var formDataList = requestModel.formDataMapList;

          result += kTemplateMultiPartBuilder;

          //Adding formdata of type text
          if (requestModel.hasFormData) {
            result += kTemplateFormdataFieldsStarter;
            var templateFormdataFields = jj.Template(kTemplateFormdataFields);
            for (var i = 0; i < formDataList.length; i++) {
              if (formDataList[i]["type"] == 'text') {
                result += templateFormdataFields.render({
                  "name": formDataList[i]["name"],
                  "value": formDataList[i]["value"]
                });
                result += "\n";
              }
            }

            result += kTemplateFormdataFieldsEnder;
          }

          //Adding formdata of type file
          bool firstfile = true;
          if (requestModel.hasFileInFormData) {
            result += kTemplateFormdataFilesStarter;
            var templateFormdataFiles = jj.Template(kTemplateFormdataFiles);
            for (var i = 0; i < formDataList.length; i++) {
              if (formDataList[i]["type"] != 'text') {
                if (firstfile) {
                  result += "\n";
                  firstfile = false;
                } else if (firstfile == false) {
                  result += ",\n";
                }

                String path = formDataList[i]["value"] as String;
                path = path.replaceAll('\\', '\\\\');
                result += templateFormdataFiles
                    .render({"name": formDataList[i]["name"], "value": path});
              }
            }
            result += "\n";
            result += kTemplateFormdataFilesEnder;
          }
          result += kTemplateMultiPartBuildCaller;
          hasBody = true;
        } else if (kMethodsWithBody.contains(method) && requestBody != null) {
          // if request type is not form data, the request method can include
          // a body, and the body of the request is not null, in that case
          // we need to parse the body as it is, and write it to the body

          var contentLength = utf8.encode(requestBody).length;
          if (contentLength > 0) {
            var templateBody = jj.Template(kTemplateRequestBody);
            hasBody = true;
            hasJsonBody =
                requestBody.startsWith("{") && requestBody.endsWith("}");
            if (harJson["postData"]?["text"] != null) {
              result += templateBody.render({
                "body": kEncoder.convert(harJson["postData"]["text"]).substring(
                    1, kEncoder.convert(harJson["postData"]["text"]).length - 1)
              });
            }
          }
        }

        //beginning of the request
        result += kStringRequestStart;

        //setting up headers
        var headers = harJson["headers"];
        var m = {};
        for (var i in headers) {
          m[i["name"]] = i["value"];
        }

        if (requestModel.hasBody &&
            requestModel.hasFormData &&
            !requestModel.hasFileInFormData) {
          m['Content-Type'] = 'application/x-www-form-urlencoded';
        } else if (requestModel.hasFormData) {
          m['Content-Type'] = 'multipart/form-data';
        }

        if (hasBody &&
            !requestModel.enabledHeadersMap.containsKey('Content-Type') &&
            requestModel.hasFormData) {
          result =
              """$result                .header("Content-Type", multipartBody.getContentType())\n""";
        } else {}

        var headersList = requestModel.enabledRequestHeaders;
        if (headersList != null) {
          var headers = requestModel.enabledHeadersMap;
          if (headers.isNotEmpty) {
            result += getHeaders(headers, hasJsonBody);
            //getHeaders method is defined at the end
          }
        }

        var templateRequestEnd = jj.Template(kTemplateRequestEnd);

        if (kMethodsWithBody.contains(method)) {
          result += templateRequestEnd.render({
            "method": method.name.toUpperCase(),
            "body": hasBody
                ? "BodyPublishers.ofString(body)"
                : "BodyPublishers.noBody()"
          });
        } else {
          result += templateRequestEnd
              .render({"method": method.name.toUpperCase(), "body": ""});
        }
      }

      //adding the template for HttpRequestMultiPartBody Class for handling Multipart requests.
      if (requestModel.hasBody && requestModel.hasFormData) {
        result += kTemplateMultiPartBodyClass;
      }
      return result;
    } catch (e) {
      return null;
    }
  }

  //defining the getHeaders method for adding the headers to the request in the result
  String getHeaders(Map<String, String> headers, hasJsonBody) {
    String result = "";
    for (final k in headers.keys) {
      if (k.toLowerCase() == 'authorization') {
        result = """$result                .header("$k", "${headers[k]}")\n""";
      } else {
        result = """$result                .header("$k", "${headers[k]}")\n""";
      }
    }
    return result;
  }
}
