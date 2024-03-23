import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:test/test.dart';
import '../request_models.dart';

void main() {
  final codeGen = Codegen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpHeaders;
import java.net.http.HttpRequest.BodyPublishers;
import java.net.http.HttpResponse.BodyHandlers;

public class JavaHttpClientExample {
    public static void main(String[] args) throws IOException, InterruptedException {
        HttpClient client = HttpClient.newHttpClient();

        String url = "https://api.apidash.dev";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .GET()
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelGet1, "https"),
          expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r"""import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpHeaders;
import java.net.http.HttpRequest.BodyPublishers;
import java.net.http.HttpResponse.BodyHandlers;

public class JavaHttpClientExample {
    public static void main(String[] args) throws IOException, InterruptedException {
        HttpClient client = HttpClient.newHttpClient();

        String url = "https://api.apidash.dev/country/data";

        url += "?" + "code=US";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .GET()
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}""";

      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelGet2, "https"),
          expectedCode);
    });

    test('GET 3', () {
      const expectedCode = r"""import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpHeaders;
import java.net.http.HttpRequest.BodyPublishers;
import java.net.http.HttpResponse.BodyHandlers;

public class JavaHttpClientExample {
    public static void main(String[] args) throws IOException, InterruptedException {
        HttpClient client = HttpClient.newHttpClient();

        String url = "https://api.apidash.dev/country/data";

        url += "?" + "code=IND";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .GET()
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelGet3, "https"),
          expectedCode);
    });

    test('GET 4', () {
      const expectedCode = r"""import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpHeaders;
import java.net.http.HttpRequest.BodyPublishers;
import java.net.http.HttpResponse.BodyHandlers;

public class JavaHttpClientExample {
    public static void main(String[] args) throws IOException, InterruptedException {
        HttpClient client = HttpClient.newHttpClient();

        String url = "https://api.apidash.dev/humanize/social";

        url += "?" + "num=8700000&digits=3&system=SS&add_space=true&trailing_zeros=true";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .GET()
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelGet4, "https"),
          expectedCode);
    });

    test('GET 5', () {
      const expectedCode = r"""import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpHeaders;
import java.net.http.HttpRequest.BodyPublishers;
import java.net.http.HttpResponse.BodyHandlers;

public class JavaHttpClientExample {
    public static void main(String[] args) throws IOException, InterruptedException {
        HttpClient client = HttpClient.newHttpClient();

        String url = "https://api.github.com/repos/foss42/apidash";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .header("User-Agent", "Test Agent")
                .GET()
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelGet5, "https"),
          expectedCode);
    });

    test('GET 6', () {
      const expectedCode = r"""import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpHeaders;
import java.net.http.HttpRequest.BodyPublishers;
import java.net.http.HttpResponse.BodyHandlers;

public class JavaHttpClientExample {
    public static void main(String[] args) throws IOException, InterruptedException {
        HttpClient client = HttpClient.newHttpClient();

        String url = "https://api.github.com/repos/foss42/apidash";

        url += "?" + "raw=true";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .header("User-Agent", "Test Agent")
                .GET()
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelGet6, "https"),
          expectedCode);
    });

    test('GET 7', () {
      //check others tests too as body is not showing
      const expectedCode = r"""import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpHeaders;
import java.net.http.HttpRequest.BodyPublishers;
import java.net.http.HttpResponse.BodyHandlers;

public class JavaHttpClientExample {
    public static void main(String[] args) throws IOException, InterruptedException {
        HttpClient client = HttpClient.newHttpClient();

        String url = "https://api.apidash.dev";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .GET()
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelGet7, "https"),
          expectedCode);
    });

    test('GET 8', () {
      const expectedCode = r"""import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpHeaders;
import java.net.http.HttpRequest.BodyPublishers;
import java.net.http.HttpResponse.BodyHandlers;

public class JavaHttpClientExample {
    public static void main(String[] args) throws IOException, InterruptedException {
        HttpClient client = HttpClient.newHttpClient();

        String url = "https://api.github.com/repos/foss42/apidash";

        url += "?" + "raw=true";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .header("User-Agent", "Test Agent")
                .GET()
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelGet8, "https"),
          expectedCode);
    });

    test('GET 9', () {
      const expectedCode = r"""import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpHeaders;
import java.net.http.HttpRequest.BodyPublishers;
import java.net.http.HttpResponse.BodyHandlers;

public class JavaHttpClientExample {
    public static void main(String[] args) throws IOException, InterruptedException {
        HttpClient client = HttpClient.newHttpClient();

        String url = "https://api.apidash.dev/humanize/social";

        url += "?" + "num=8700000&add_space=true";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .GET()
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelGet9, "https"),
          expectedCode);
    });

    test('GET 10', () {
      const expectedCode = r"""import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpHeaders;
import java.net.http.HttpRequest.BodyPublishers;
import java.net.http.HttpResponse.BodyHandlers;

public class JavaHttpClientExample {
    public static void main(String[] args) throws IOException, InterruptedException {
        HttpClient client = HttpClient.newHttpClient();

        String url = "https://api.apidash.dev/humanize/social";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .header("User-Agent", "Test Agent")
                .GET()
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}""";
      expect(
          codeGen.getCode(
            CodegenLanguage.javaHttpClient,
            requestModelGet10,
            "https",
          ),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode = r"""import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpHeaders;
import java.net.http.HttpRequest.BodyPublishers;
import java.net.http.HttpResponse.BodyHandlers;

public class JavaHttpClientExample {
    public static void main(String[] args) throws IOException, InterruptedException {
        HttpClient client = HttpClient.newHttpClient();

        String url = "https://api.apidash.dev/humanize/social";

        url += "?" + "num=8700000&digits=3";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .header("User-Agent", "Test Agent")
                .GET()
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelGet11, "https"),
          expectedCode);
    });

    test('GET 12', () {
      const expectedCode = r"""import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpHeaders;
import java.net.http.HttpRequest.BodyPublishers;
import java.net.http.HttpResponse.BodyHandlers;

public class JavaHttpClientExample {
    public static void main(String[] args) throws IOException, InterruptedException {
        HttpClient client = HttpClient.newHttpClient();

        String url = "https://api.apidash.dev/humanize/social";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .GET()
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelGet12, "https"),
          expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpHeaders;
import java.net.http.HttpRequest.BodyPublishers;
import java.net.http.HttpResponse.BodyHandlers;

public class JavaHttpClientExample {
    public static void main(String[] args) throws IOException, InterruptedException {
        HttpClient client = HttpClient.newHttpClient();

        String url = "https://api.apidash.dev";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .HEAD()
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelHead1, "https"),
          expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpHeaders;
import java.net.http.HttpRequest.BodyPublishers;
import java.net.http.HttpResponse.BodyHandlers;

public class JavaHttpClientExample {
    public static void main(String[] args) throws IOException, InterruptedException {
        HttpClient client = HttpClient.newHttpClient();

        String url = "http://api.apidash.dev";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .HEAD()
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelHead2, "http"),
          expectedCode);
    });
  });

  group('POST Request', () {
    //check for the text body=> whether to send 'i love flutter' or the entire thing
    test('POST 1', () {
      const expectedCode = r"""import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpHeaders;
import java.net.http.HttpRequest.BodyPublishers;
import java.net.http.HttpResponse.BodyHandlers;

public class JavaHttpClientExample {
    public static void main(String[] args) throws IOException, InterruptedException {
        HttpClient client = HttpClient.newHttpClient();

        String url = "https://api.apidash.dev/case/lower";

        String body = "{\n\"text\": \"I LOVE Flutter\"\n}";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .POST(BodyPublishers.ofString(body))
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelPost1, "https"),
          expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r"""import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpHeaders;
import java.net.http.HttpRequest.BodyPublishers;
import java.net.http.HttpResponse.BodyHandlers;

public class JavaHttpClientExample {
    public static void main(String[] args) throws IOException, InterruptedException {
        HttpClient client = HttpClient.newHttpClient();

        String url = "https://api.apidash.dev/case/lower";

        String body = "{\n\"text\": \"I LOVE Flutter\",\n\"flag\": null,\n\"male\": true,\n\"female\": false,\n\"no\": 1.2,\n\"arr\": [\"null\", \"true\", \"false\", null]\n}";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .POST(BodyPublishers.ofString(body))
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelPost2, "https"),
          expectedCode);
    });

    test('POST 3', () {
      const expectedCode = r"""import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpHeaders;
import java.net.http.HttpRequest.BodyPublishers;
import java.net.http.HttpResponse.BodyHandlers;

public class JavaHttpClientExample {
    public static void main(String[] args) throws IOException, InterruptedException {
        HttpClient client = HttpClient.newHttpClient();

        String url = "https://api.apidash.dev/case/lower";

        String body = "{\n\"text\": \"I LOVE Flutter\"\n}";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .header("User-Agent", "Test Agent")
                .POST(BodyPublishers.ofString(body))
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelPost3, "https"),
          expectedCode);
    });

    String importPackagesforMultiPartHandling = '''import java.io.File;
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

    String multiPartHandlerClassString = '''

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
    test('POST 4', () {
      const expectedCode = r"""import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpHeaders;
import java.net.http.HttpRequest.BodyPublishers;
import java.net.http.HttpResponse.BodyHandlers;

public class JavaHttpClientExample {
    public static void main(String[] args) throws IOException, InterruptedException {
        HttpClient client = HttpClient.newHttpClient();

        String url = "https://api.apidash.dev/io/form";

        var bldr = new HTTPRequestMultipartBody.Builder();
        Map<String, String> mp = new HashMap<>() {
            {
                put("text", "API");
                put("sep", "|");
                put("times", "3");
            }
        };

        for (String key : mp.keySet()) {
            bldr.addPart(key, mp.get(key));
        }

        HTTPRequestMultipartBody multipartBody = bldr.build();


        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .header("Content-Type", multipartBody.getContentType())
                .POST(HttpRequest.BodyPublishers.ofByteArray(multipartBody.getBody()))
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelPost4, "https"),
          importPackagesforMultiPartHandling +
              expectedCode +
              multiPartHandlerClassString);
    });
    test('POST 5', () {
      const expectedCode = r"""import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpHeaders;
import java.net.http.HttpRequest.BodyPublishers;
import java.net.http.HttpResponse.BodyHandlers;

public class JavaHttpClientExample {
    public static void main(String[] args) throws IOException, InterruptedException {
        HttpClient client = HttpClient.newHttpClient();

        String url = "https://api.apidash.dev/io/form";

        var bldr = new HTTPRequestMultipartBody.Builder();
        Map<String, String> mp = new HashMap<>() {
            {
                put("text", "API");
                put("sep", "|");
                put("times", "3");
            }
        };

        for (String key : mp.keySet()) {
            bldr.addPart(key, mp.get(key));
        }

        HTTPRequestMultipartBody multipartBody = bldr.build();


        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .header("Content-Type", multipartBody.getContentType())
                .header("User-Agent", "Test Agent")
                .POST(HttpRequest.BodyPublishers.ofByteArray(multipartBody.getBody()))
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelPost5, "https"),
          importPackagesforMultiPartHandling +
              expectedCode +
              multiPartHandlerClassString);
    });
    test('POST 6', () {
      const expectedCode = r"""import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpHeaders;
import java.net.http.HttpRequest.BodyPublishers;
import java.net.http.HttpResponse.BodyHandlers;

public class JavaHttpClientExample {
    public static void main(String[] args) throws IOException, InterruptedException {
        HttpClient client = HttpClient.newHttpClient();

        String url = "https://api.apidash.dev/io/img";

        var bldr = new HTTPRequestMultipartBody.Builder();
        Map<String, String> mp = new HashMap<>() {
            {
                put("token", "xyz");
            }
        };

        for (String key : mp.keySet()) {
            bldr.addPart(key, mp.get(key));
        }

        String[][] files = {
                { "imfile", "/Documents/up/1.png"}
        };

        for (int i = 0; i < files.length; ++i) {
            File f = new File(files[i][1]);
            bldr.addPart(files[i][0], f, null, f.getName());
        }

        HTTPRequestMultipartBody multipartBody = bldr.build();


        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .header("Content-Type", multipartBody.getContentType())
                .POST(HttpRequest.BodyPublishers.ofByteArray(multipartBody.getBody()))
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelPost6, "https"),
          importPackagesforMultiPartHandling +
              expectedCode +
              multiPartHandlerClassString);
    });
    test('POST 7', () {
      const expectedCode = r"""import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpHeaders;
import java.net.http.HttpRequest.BodyPublishers;
import java.net.http.HttpResponse.BodyHandlers;

public class JavaHttpClientExample {
    public static void main(String[] args) throws IOException, InterruptedException {
        HttpClient client = HttpClient.newHttpClient();

        String url = "https://api.apidash.dev/io/img";

        var bldr = new HTTPRequestMultipartBody.Builder();
        Map<String, String> mp = new HashMap<>() {
            {
                put("token", "xyz");
            }
        };

        for (String key : mp.keySet()) {
            bldr.addPart(key, mp.get(key));
        }

        String[][] files = {
                { "imfile", "/Documents/up/1.png"}
        };

        for (int i = 0; i < files.length; ++i) {
            File f = new File(files[i][1]);
            bldr.addPart(files[i][0], f, null, f.getName());
        }

        HTTPRequestMultipartBody multipartBody = bldr.build();


        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .header("Content-Type", multipartBody.getContentType())
                .POST(HttpRequest.BodyPublishers.ofByteArray(multipartBody.getBody()))
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelPost7, "https"),
          importPackagesforMultiPartHandling +
              expectedCode +
              multiPartHandlerClassString);
    });
    test('POST 8', () {
      const expectedCode = r"""import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpHeaders;
import java.net.http.HttpRequest.BodyPublishers;
import java.net.http.HttpResponse.BodyHandlers;

public class JavaHttpClientExample {
    public static void main(String[] args) throws IOException, InterruptedException {
        HttpClient client = HttpClient.newHttpClient();

        String url = "https://api.apidash.dev/io/form";

        url += "?" + "size=2&len=3";

        var bldr = new HTTPRequestMultipartBody.Builder();
        Map<String, String> mp = new HashMap<>() {
            {
                put("text", "API");
                put("sep", "|");
                put("times", "3");
            }
        };

        for (String key : mp.keySet()) {
            bldr.addPart(key, mp.get(key));
        }

        HTTPRequestMultipartBody multipartBody = bldr.build();


        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .header("Content-Type", multipartBody.getContentType())
                .POST(HttpRequest.BodyPublishers.ofByteArray(multipartBody.getBody()))
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelPost8, "https"),
          importPackagesforMultiPartHandling +
              expectedCode +
              multiPartHandlerClassString);
    });
    test('POST 9', () {
      const expectedCode = r"""import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpHeaders;
import java.net.http.HttpRequest.BodyPublishers;
import java.net.http.HttpResponse.BodyHandlers;

public class JavaHttpClientExample {
    public static void main(String[] args) throws IOException, InterruptedException {
        HttpClient client = HttpClient.newHttpClient();

        String url = "https://api.apidash.dev/io/img";

        url += "?" + "size=2&len=3";

        var bldr = new HTTPRequestMultipartBody.Builder();
        Map<String, String> mp = new HashMap<>() {
            {
                put("token", "xyz");
            }
        };

        for (String key : mp.keySet()) {
            bldr.addPart(key, mp.get(key));
        }

        String[][] files = {
                { "imfile", "/Documents/up/1.png"}
        };

        for (int i = 0; i < files.length; ++i) {
            File f = new File(files[i][1]);
            bldr.addPart(files[i][0], f, null, f.getName());
        }

        HTTPRequestMultipartBody multipartBody = bldr.build();


        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .header("Content-Type", multipartBody.getContentType())
                .header("User-Agent", "Test Agent")
                .header("Keep-Alive", "true")
                .POST(HttpRequest.BodyPublishers.ofByteArray(multipartBody.getBody()))
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelPost9, "https"),
          importPackagesforMultiPartHandling +
              expectedCode +
              multiPartHandlerClassString);
    });
  });

  group('PUT Request', () {
    test('PUT 1', () {
      const expectedCode = r"""import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpHeaders;
import java.net.http.HttpRequest.BodyPublishers;
import java.net.http.HttpResponse.BodyHandlers;

public class JavaHttpClientExample {
    public static void main(String[] args) throws IOException, InterruptedException {
        HttpClient client = HttpClient.newHttpClient();

        String url = "https://reqres.in/api/users/2";

        String body = "{\n\"name\": \"morpheus\",\n\"job\": \"zion resident\"\n}";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .PUT(BodyPublishers.ofString(body))
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelPut1, "https"),
          expectedCode);
    });
  });

}
