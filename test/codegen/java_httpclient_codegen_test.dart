import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:test/test.dart';
import '../models/request_models.dart';

void main() {
  final codeGen = Codegen();

  group('GET Request', () {
    test('GET1', () {
      const expectedCode = r'''
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.io.IOException;

public class Main {
  public static void main(String[] args) {
    try {
      HttpClient client = HttpClient.newHttpClient();
      URI uri = URI.create("https://api.apidash.dev");

      HttpRequest.Builder requestBuilder = HttpRequest.newBuilder(uri).GET();
      HttpResponse<String> response = client.send(requestBuilder.build(), HttpResponse.BodyHandlers.ofString());
      System.out.println("Response body: " + response.body());
      System.out.println("Response code: " + response.statusCode());
    } catch (IOException | InterruptedException e) {
      System.out.println("An error occurred: " + e.getMessage());
    }
  }
  
}''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelGet1, "https"),
          expectedCode);
    });
    test('GET2', () {
      const expectedCode = r'''
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.io.IOException;

public class Main {
  public static void main(String[] args) {
    try {
      HttpClient client = HttpClient.newHttpClient();
      URI uri = URI.create("https://api.apidash.dev/country/data?code=US");

      HttpRequest.Builder requestBuilder = HttpRequest.newBuilder(uri).GET();
      HttpResponse<String> response = client.send(requestBuilder.build(), HttpResponse.BodyHandlers.ofString());
      System.out.println("Response body: " + response.body());
      System.out.println("Response code: " + response.statusCode());
    } catch (IOException | InterruptedException e) {
      System.out.println("An error occurred: " + e.getMessage());
    }
  }
  
}''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelGet2, "https"),
          expectedCode);
    });
    test('GET3', () {
      const expectedCode = r'''
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.io.IOException;

public class Main {
  public static void main(String[] args) {
    try {
      HttpClient client = HttpClient.newHttpClient();
      URI uri = URI.create("https://api.apidash.dev/country/data?code=IND");

      HttpRequest.Builder requestBuilder = HttpRequest.newBuilder(uri).GET();
      HttpResponse<String> response = client.send(requestBuilder.build(), HttpResponse.BodyHandlers.ofString());
      System.out.println("Response body: " + response.body());
      System.out.println("Response code: " + response.statusCode());
    } catch (IOException | InterruptedException e) {
      System.out.println("An error occurred: " + e.getMessage());
    }
  }
  
}''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelGet3, "https"),
          expectedCode);
    });
    test('GET4', () {
      const expectedCode = r'''
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.io.IOException;

public class Main {
  public static void main(String[] args) {
    try {
      HttpClient client = HttpClient.newHttpClient();
      URI uri = URI.create("https://api.apidash.dev/humanize/social?num=8700000&digits=3&system=SS&add_space=true&trailing_zeros=true");

      HttpRequest.Builder requestBuilder = HttpRequest.newBuilder(uri).GET();
      HttpResponse<String> response = client.send(requestBuilder.build(), HttpResponse.BodyHandlers.ofString());
      System.out.println("Response body: " + response.body());
      System.out.println("Response code: " + response.statusCode());
    } catch (IOException | InterruptedException e) {
      System.out.println("An error occurred: " + e.getMessage());
    }
  }
  
}''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelGet4, "https"),
          expectedCode);
    });
    test('GET5', () {
      const expectedCode = r'''
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.io.IOException;

public class Main {
  public static void main(String[] args) {
    try {
      HttpClient client = HttpClient.newHttpClient();
      URI uri = URI.create("https://api.github.com/repos/foss42/apidash");

      HttpRequest.Builder requestBuilder = HttpRequest.newBuilder(uri).GET();
      requestBuilder = requestBuilder.headers(
        "User-Agent", "Test Agent"
      );
      HttpResponse<String> response = client.send(requestBuilder.build(), HttpResponse.BodyHandlers.ofString());
      System.out.println("Response body: " + response.body());
      System.out.println("Response code: " + response.statusCode());
    } catch (IOException | InterruptedException e) {
      System.out.println("An error occurred: " + e.getMessage());
    }
  }
  
}''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelGet5, "https"),
          expectedCode);
    });
    test('GET6', () {
      const expectedCode = r'''
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.io.IOException;

public class Main {
  public static void main(String[] args) {
    try {
      HttpClient client = HttpClient.newHttpClient();
      URI uri = URI.create("https://api.github.com/repos/foss42/apidash?raw=true");

      HttpRequest.Builder requestBuilder = HttpRequest.newBuilder(uri).GET();
      requestBuilder = requestBuilder.headers(
        "User-Agent", "Test Agent"
      );
      HttpResponse<String> response = client.send(requestBuilder.build(), HttpResponse.BodyHandlers.ofString());
      System.out.println("Response body: " + response.body());
      System.out.println("Response code: " + response.statusCode());
    } catch (IOException | InterruptedException e) {
      System.out.println("An error occurred: " + e.getMessage());
    }
  }
  
}''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelGet6, "https"),
          expectedCode);
    });
    test('GET7', () {
      const expectedCode = r'''
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.io.IOException;

public class Main {
  public static void main(String[] args) {
    try {
      HttpClient client = HttpClient.newHttpClient();
      URI uri = URI.create("https://api.apidash.dev");

      HttpRequest.Builder requestBuilder = HttpRequest.newBuilder(uri).GET();
      HttpResponse<String> response = client.send(requestBuilder.build(), HttpResponse.BodyHandlers.ofString());
      System.out.println("Response body: " + response.body());
      System.out.println("Response code: " + response.statusCode());
    } catch (IOException | InterruptedException e) {
      System.out.println("An error occurred: " + e.getMessage());
    }
  }
  
}''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelGet7, "https"),
          expectedCode);
    });
    test('GET8', () {
      const expectedCode = r'''
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.io.IOException;

public class Main {
  public static void main(String[] args) {
    try {
      HttpClient client = HttpClient.newHttpClient();
      URI uri = URI.create("https://api.github.com/repos/foss42/apidash?raw=true");

      HttpRequest.Builder requestBuilder = HttpRequest.newBuilder(uri).GET();
      requestBuilder = requestBuilder.headers(
        "User-Agent", "Test Agent"
      );
      HttpResponse<String> response = client.send(requestBuilder.build(), HttpResponse.BodyHandlers.ofString());
      System.out.println("Response body: " + response.body());
      System.out.println("Response code: " + response.statusCode());
    } catch (IOException | InterruptedException e) {
      System.out.println("An error occurred: " + e.getMessage());
    }
  }
  
}''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelGet8, "https"),
          expectedCode);
    });
    test('GET9', () {
      const expectedCode = r'''
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.io.IOException;

public class Main {
  public static void main(String[] args) {
    try {
      HttpClient client = HttpClient.newHttpClient();
      URI uri = URI.create("https://api.apidash.dev/humanize/social?num=8700000&add_space=true");

      HttpRequest.Builder requestBuilder = HttpRequest.newBuilder(uri).GET();
      HttpResponse<String> response = client.send(requestBuilder.build(), HttpResponse.BodyHandlers.ofString());
      System.out.println("Response body: " + response.body());
      System.out.println("Response code: " + response.statusCode());
    } catch (IOException | InterruptedException e) {
      System.out.println("An error occurred: " + e.getMessage());
    }
  }
  
}''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelGet9, "https"),
          expectedCode);
    });
    test('GET10', () {
      const expectedCode = r'''
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.io.IOException;

public class Main {
  public static void main(String[] args) {
    try {
      HttpClient client = HttpClient.newHttpClient();
      URI uri = URI.create("https://api.apidash.dev/humanize/social");

      HttpRequest.Builder requestBuilder = HttpRequest.newBuilder(uri).GET();
      requestBuilder = requestBuilder.headers(
        "User-Agent", "Test Agent"
      );
      HttpResponse<String> response = client.send(requestBuilder.build(), HttpResponse.BodyHandlers.ofString());
      System.out.println("Response body: " + response.body());
      System.out.println("Response code: " + response.statusCode());
    } catch (IOException | InterruptedException e) {
      System.out.println("An error occurred: " + e.getMessage());
    }
  }
  
}''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelGet10, "https"),
          expectedCode);
    });
    test('GET11', () {
      const expectedCode = r'''
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.io.IOException;

public class Main {
  public static void main(String[] args) {
    try {
      HttpClient client = HttpClient.newHttpClient();
      URI uri = URI.create("https://api.apidash.dev/humanize/social?num=8700000&digits=3");

      HttpRequest.Builder requestBuilder = HttpRequest.newBuilder(uri).GET();
      requestBuilder = requestBuilder.headers(
        "User-Agent", "Test Agent"
      );
      HttpResponse<String> response = client.send(requestBuilder.build(), HttpResponse.BodyHandlers.ofString());
      System.out.println("Response body: " + response.body());
      System.out.println("Response code: " + response.statusCode());
    } catch (IOException | InterruptedException e) {
      System.out.println("An error occurred: " + e.getMessage());
    }
  }
  
}''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelGet11, "https"),
          expectedCode);
    });
    test('GET12', () {
      const expectedCode = r'''
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.io.IOException;

public class Main {
  public static void main(String[] args) {
    try {
      HttpClient client = HttpClient.newHttpClient();
      URI uri = URI.create("https://api.apidash.dev/humanize/social");

      HttpRequest.Builder requestBuilder = HttpRequest.newBuilder(uri).GET();
      HttpResponse<String> response = client.send(requestBuilder.build(), HttpResponse.BodyHandlers.ofString());
      System.out.println("Response body: " + response.body());
      System.out.println("Response code: " + response.statusCode());
    } catch (IOException | InterruptedException e) {
      System.out.println("An error occurred: " + e.getMessage());
    }
  }
  
}''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelGet12, "https"),
          expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD1', () {
      const expectedCode = r'''
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.io.IOException;

public class Main {
  public static void main(String[] args) {
    try {
      HttpClient client = HttpClient.newHttpClient();
      URI uri = URI.create("https://api.apidash.dev");

      HttpRequest.Builder requestBuilder = HttpRequest.newBuilder(uri).method("HEAD", HttpRequest.BodyPublishers.noBody());
      HttpResponse<String> response = client.send(requestBuilder.build(), HttpResponse.BodyHandlers.ofString());
      System.out.println("Response body: " + response.body());
      System.out.println("Response code: " + response.statusCode());
    } catch (IOException | InterruptedException e) {
      System.out.println("An error occurred: " + e.getMessage());
    }
  }
  
}''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelHead1, "https"),
          expectedCode);
    });
    test('HEAD2', () {
      const expectedCode = r'''
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.io.IOException;

public class Main {
  public static void main(String[] args) {
    try {
      HttpClient client = HttpClient.newHttpClient();
      URI uri = URI.create("http://api.apidash.dev");

      HttpRequest.Builder requestBuilder = HttpRequest.newBuilder(uri).method("HEAD", HttpRequest.BodyPublishers.noBody());
      HttpResponse<String> response = client.send(requestBuilder.build(), HttpResponse.BodyHandlers.ofString());
      System.out.println("Response body: " + response.body());
      System.out.println("Response code: " + response.statusCode());
    } catch (IOException | InterruptedException e) {
      System.out.println("An error occurred: " + e.getMessage());
    }
  }
  
}''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelHead2, "http"),
          expectedCode);
    });
  });

  group('POST Request', () {
    test('POST1', () {
      const expectedCode = r'''
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.io.IOException;

public class Main {
  public static void main(String[] args) {
    try {
      HttpClient client = HttpClient.newHttpClient();
      URI uri = URI.create("https://api.apidash.dev/case/lower");
      HttpRequest.BodyPublisher bodyPublisher = HttpRequest.BodyPublishers.ofString("""
      {
"text": "I LOVE Flutter"
}""");
      HttpRequest.Builder requestBuilder = HttpRequest.newBuilder(uri).POST(bodyPublisher);
      requestBuilder = requestBuilder.headers(
        "Content-Type", "text/plain"
      );
      HttpResponse<String> response = client.send(requestBuilder.build(), HttpResponse.BodyHandlers.ofString());
      System.out.println("Response body: " + response.body());
      System.out.println("Response code: " + response.statusCode());
    } catch (IOException | InterruptedException e) {
      System.out.println("An error occurred: " + e.getMessage());
    }
  }
  
}''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelPost1, "https"),
          expectedCode);
    });
    test('POST2', () {
      const expectedCode = r'''
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.io.IOException;

public class Main {
  public static void main(String[] args) {
    try {
      HttpClient client = HttpClient.newHttpClient();
      URI uri = URI.create("https://api.apidash.dev/case/lower");
      HttpRequest.BodyPublisher bodyPublisher = HttpRequest.BodyPublishers.ofString("""
{
"text": "I LOVE Flutter",
"flag": null,
"male": true,
"female": false,
"no": 1.2,
"arr": ["null", "true", "false", null]
}""");
      HttpRequest.Builder requestBuilder = HttpRequest.newBuilder(uri).POST(bodyPublisher);
      requestBuilder = requestBuilder.headers(
        "Content-Type", "application/json"
      );
      HttpResponse<String> response = client.send(requestBuilder.build(), HttpResponse.BodyHandlers.ofString());
      System.out.println("Response body: " + response.body());
      System.out.println("Response code: " + response.statusCode());
    } catch (IOException | InterruptedException e) {
      System.out.println("An error occurred: " + e.getMessage());
    }
  }
  
}''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelPost2, "https"),
          expectedCode);
    });
    test('POST3', () {
      const expectedCode = r'''
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.io.IOException;

public class Main {
  public static void main(String[] args) {
    try {
      HttpClient client = HttpClient.newHttpClient();
      URI uri = URI.create("https://api.apidash.dev/case/lower");
      HttpRequest.BodyPublisher bodyPublisher = HttpRequest.BodyPublishers.ofString("""
{
"text": "I LOVE Flutter"
}""");
      HttpRequest.Builder requestBuilder = HttpRequest.newBuilder(uri).POST(bodyPublisher);
      requestBuilder = requestBuilder.headers(
        "User-Agent", "Test Agent",
        "Content-Type", "application/json"
      );
      HttpResponse<String> response = client.send(requestBuilder.build(), HttpResponse.BodyHandlers.ofString());
      System.out.println("Response body: " + response.body());
      System.out.println("Response code: " + response.statusCode());
    } catch (IOException | InterruptedException e) {
      System.out.println("An error occurred: " + e.getMessage());
    }
  }
  
}''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelPost3, "https"),
          expectedCode);
    });
    test('POST4', () {
      const expectedCode = r'''
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;

public class Main {
  public static void main(String[] args) {
    try {
      HttpClient client = HttpClient.newHttpClient();
      URI uri = URI.create("https://api.apidash.dev/io/form");
      String boundary = "b9826c20-773c-1f0c-814d-a1b3d90cd6b3";
      Map<Object, Object> data = new HashMap<>();
      
      data.put("text", "API");
      data.put("sep", "|");
      data.put("times", "3");
      HttpRequest.BodyPublisher bodyPublisher = buildMultipartFormData(data, boundary);
      HttpRequest.Builder requestBuilder = HttpRequest.newBuilder(uri).POST(bodyPublisher);
      requestBuilder = requestBuilder.headers(
        "Content-Type", "multipart/form-data; boundary=b9826c20-773c-1f0c-814d-a1b3d90cd6b3"
      );
      HttpResponse<String> response = client.send(requestBuilder.build(), HttpResponse.BodyHandlers.ofString());
      System.out.println("Response body: " + response.body());
      System.out.println("Response code: " + response.statusCode());
    } catch (IOException | InterruptedException e) {
      System.out.println("An error occurred: " + e.getMessage());
    }
  }
  
  private static HttpRequest.BodyPublisher buildMultipartFormData(Map<Object, Object> data, String boundary) throws IOException {
    var byteArrays = new ArrayList<byte[]>();
    var CRLF = "\r\n".getBytes(StandardCharsets.UTF_8);

    for (Map.Entry<Object, Object> entry : data.entrySet()) {
        byteArrays.add(("--" + boundary + "\r\n").getBytes(StandardCharsets.UTF_8));
        if (entry.getValue() instanceof Path) {
            var file = (Path) entry.getValue();
            var fileName = file.getFileName().toString();
            byteArrays.add(("Content-Disposition: form-data; name=\"" + entry.getKey() + "\"; filename=\"" + fileName + "\"\r\n").getBytes(StandardCharsets.UTF_8));
            byteArrays.add(("Content-Type: " + Files.probeContentType(file) + "\r\n\r\n").getBytes(StandardCharsets.UTF_8));
            byteArrays.add(Files.readAllBytes(file));
            byteArrays.add(CRLF);
        } else {
            byteArrays.add(("Content-Disposition: form-data; name=\"" + entry.getKey() + "\"\r\n\r\n").getBytes(StandardCharsets.UTF_8));
            byteArrays.add(entry.getValue().toString().getBytes(StandardCharsets.UTF_8));
            byteArrays.add(CRLF);
        }
    }
    byteArrays.add(("--" + boundary + "--\r\n").getBytes(StandardCharsets.UTF_8));

    return HttpRequest.BodyPublishers.ofByteArrays(byteArrays);
  }
}''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelPost4, "https",
              boundary: "b9826c20-773c-1f0c-814d-a1b3d90cd6b3"),
          expectedCode);
    });
    test('POST5', () {
      const expectedCode = r'''
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;

public class Main {
  public static void main(String[] args) {
    try {
      HttpClient client = HttpClient.newHttpClient();
      URI uri = URI.create("https://api.apidash.dev/io/form");
      String boundary = "b9826c20-773c-1f0c-814d-a1b3d90cd6b3";
      Map<Object, Object> data = new HashMap<>();
      
      data.put("text", "API");
      data.put("sep", "|");
      data.put("times", "3");
      HttpRequest.BodyPublisher bodyPublisher = buildMultipartFormData(data, boundary);
      HttpRequest.Builder requestBuilder = HttpRequest.newBuilder(uri).POST(bodyPublisher);
      requestBuilder = requestBuilder.headers(
        "User-Agent", "Test Agent",
        "Content-Type", "multipart/form-data; boundary=b9826c20-773c-1f0c-814d-a1b3d90cd6b3"
      );
      HttpResponse<String> response = client.send(requestBuilder.build(), HttpResponse.BodyHandlers.ofString());
      System.out.println("Response body: " + response.body());
      System.out.println("Response code: " + response.statusCode());
    } catch (IOException | InterruptedException e) {
      System.out.println("An error occurred: " + e.getMessage());
    }
  }
  
  private static HttpRequest.BodyPublisher buildMultipartFormData(Map<Object, Object> data, String boundary) throws IOException {
    var byteArrays = new ArrayList<byte[]>();
    var CRLF = "\r\n".getBytes(StandardCharsets.UTF_8);

    for (Map.Entry<Object, Object> entry : data.entrySet()) {
        byteArrays.add(("--" + boundary + "\r\n").getBytes(StandardCharsets.UTF_8));
        if (entry.getValue() instanceof Path) {
            var file = (Path) entry.getValue();
            var fileName = file.getFileName().toString();
            byteArrays.add(("Content-Disposition: form-data; name=\"" + entry.getKey() + "\"; filename=\"" + fileName + "\"\r\n").getBytes(StandardCharsets.UTF_8));
            byteArrays.add(("Content-Type: " + Files.probeContentType(file) + "\r\n\r\n").getBytes(StandardCharsets.UTF_8));
            byteArrays.add(Files.readAllBytes(file));
            byteArrays.add(CRLF);
        } else {
            byteArrays.add(("Content-Disposition: form-data; name=\"" + entry.getKey() + "\"\r\n\r\n").getBytes(StandardCharsets.UTF_8));
            byteArrays.add(entry.getValue().toString().getBytes(StandardCharsets.UTF_8));
            byteArrays.add(CRLF);
        }
    }
    byteArrays.add(("--" + boundary + "--\r\n").getBytes(StandardCharsets.UTF_8));

    return HttpRequest.BodyPublishers.ofByteArrays(byteArrays);
  }
}''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelPost5, "https",
              boundary: "b9826c20-773c-1f0c-814d-a1b3d90cd6b3"),
          expectedCode);
    });
    test('POST6', () {
      const expectedCode = r'''
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;

public class Main {
  public static void main(String[] args) {
    try {
      HttpClient client = HttpClient.newHttpClient();
      URI uri = URI.create("https://api.apidash.dev/io/img");
      String boundary = "b9826c20-773c-1f0c-814d-a1b3d90cd6b3";
      Map<Object, Object> data = new HashMap<>();
      
      data.put("token", "xyz");
      data.put("imfile", Paths.get("/Documents/up/1.png"));
      HttpRequest.BodyPublisher bodyPublisher = buildMultipartFormData(data, boundary);
      HttpRequest.Builder requestBuilder = HttpRequest.newBuilder(uri).POST(bodyPublisher);
      requestBuilder = requestBuilder.headers(
        "Content-Type", "multipart/form-data; boundary=b9826c20-773c-1f0c-814d-a1b3d90cd6b3"
      );
      HttpResponse<String> response = client.send(requestBuilder.build(), HttpResponse.BodyHandlers.ofString());
      System.out.println("Response body: " + response.body());
      System.out.println("Response code: " + response.statusCode());
    } catch (IOException | InterruptedException e) {
      System.out.println("An error occurred: " + e.getMessage());
    }
  }
  
  private static HttpRequest.BodyPublisher buildMultipartFormData(Map<Object, Object> data, String boundary) throws IOException {
    var byteArrays = new ArrayList<byte[]>();
    var CRLF = "\r\n".getBytes(StandardCharsets.UTF_8);

    for (Map.Entry<Object, Object> entry : data.entrySet()) {
        byteArrays.add(("--" + boundary + "\r\n").getBytes(StandardCharsets.UTF_8));
        if (entry.getValue() instanceof Path) {
            var file = (Path) entry.getValue();
            var fileName = file.getFileName().toString();
            byteArrays.add(("Content-Disposition: form-data; name=\"" + entry.getKey() + "\"; filename=\"" + fileName + "\"\r\n").getBytes(StandardCharsets.UTF_8));
            byteArrays.add(("Content-Type: " + Files.probeContentType(file) + "\r\n\r\n").getBytes(StandardCharsets.UTF_8));
            byteArrays.add(Files.readAllBytes(file));
            byteArrays.add(CRLF);
        } else {
            byteArrays.add(("Content-Disposition: form-data; name=\"" + entry.getKey() + "\"\r\n\r\n").getBytes(StandardCharsets.UTF_8));
            byteArrays.add(entry.getValue().toString().getBytes(StandardCharsets.UTF_8));
            byteArrays.add(CRLF);
        }
    }
    byteArrays.add(("--" + boundary + "--\r\n").getBytes(StandardCharsets.UTF_8));

    return HttpRequest.BodyPublishers.ofByteArrays(byteArrays);
  }
}''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelPost6, "https",
              boundary: "b9826c20-773c-1f0c-814d-a1b3d90cd6b3"),
          expectedCode);
    });
    test('POST7', () {
      const expectedCode = r'''
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;

public class Main {
  public static void main(String[] args) {
    try {
      HttpClient client = HttpClient.newHttpClient();
      URI uri = URI.create("https://api.apidash.dev/io/img");
      String boundary = "b9826c20-773c-1f0c-814d-a1b3d90cd6b3";
      Map<Object, Object> data = new HashMap<>();
      
      data.put("token", "xyz");
      data.put("imfile", Paths.get("/Documents/up/1.png"));
      HttpRequest.BodyPublisher bodyPublisher = buildMultipartFormData(data, boundary);
      HttpRequest.Builder requestBuilder = HttpRequest.newBuilder(uri).POST(bodyPublisher);
      requestBuilder = requestBuilder.headers(
        "Content-Type", "multipart/form-data; boundary=b9826c20-773c-1f0c-814d-a1b3d90cd6b3"
      );
      HttpResponse<String> response = client.send(requestBuilder.build(), HttpResponse.BodyHandlers.ofString());
      System.out.println("Response body: " + response.body());
      System.out.println("Response code: " + response.statusCode());
    } catch (IOException | InterruptedException e) {
      System.out.println("An error occurred: " + e.getMessage());
    }
  }
  
  private static HttpRequest.BodyPublisher buildMultipartFormData(Map<Object, Object> data, String boundary) throws IOException {
    var byteArrays = new ArrayList<byte[]>();
    var CRLF = "\r\n".getBytes(StandardCharsets.UTF_8);

    for (Map.Entry<Object, Object> entry : data.entrySet()) {
        byteArrays.add(("--" + boundary + "\r\n").getBytes(StandardCharsets.UTF_8));
        if (entry.getValue() instanceof Path) {
            var file = (Path) entry.getValue();
            var fileName = file.getFileName().toString();
            byteArrays.add(("Content-Disposition: form-data; name=\"" + entry.getKey() + "\"; filename=\"" + fileName + "\"\r\n").getBytes(StandardCharsets.UTF_8));
            byteArrays.add(("Content-Type: " + Files.probeContentType(file) + "\r\n\r\n").getBytes(StandardCharsets.UTF_8));
            byteArrays.add(Files.readAllBytes(file));
            byteArrays.add(CRLF);
        } else {
            byteArrays.add(("Content-Disposition: form-data; name=\"" + entry.getKey() + "\"\r\n\r\n").getBytes(StandardCharsets.UTF_8));
            byteArrays.add(entry.getValue().toString().getBytes(StandardCharsets.UTF_8));
            byteArrays.add(CRLF);
        }
    }
    byteArrays.add(("--" + boundary + "--\r\n").getBytes(StandardCharsets.UTF_8));

    return HttpRequest.BodyPublishers.ofByteArrays(byteArrays);
  }
}''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelPost7, "https",
              boundary: "b9826c20-773c-1f0c-814d-a1b3d90cd6b3"),
          expectedCode);
    });
    test('POST8', () {
      const expectedCode = r'''
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;

public class Main {
  public static void main(String[] args) {
    try {
      HttpClient client = HttpClient.newHttpClient();
      URI uri = URI.create("https://api.apidash.dev/io/form?size=2&len=3");
      String boundary = "b9826c20-773c-1f0c-814d-a1b3d90cd6b3";
      Map<Object, Object> data = new HashMap<>();
      
      data.put("text", "API");
      data.put("sep", "|");
      data.put("times", "3");
      HttpRequest.BodyPublisher bodyPublisher = buildMultipartFormData(data, boundary);
      HttpRequest.Builder requestBuilder = HttpRequest.newBuilder(uri).POST(bodyPublisher);
      requestBuilder = requestBuilder.headers(
        "Content-Type", "multipart/form-data; boundary=b9826c20-773c-1f0c-814d-a1b3d90cd6b3"
      );
      HttpResponse<String> response = client.send(requestBuilder.build(), HttpResponse.BodyHandlers.ofString());
      System.out.println("Response body: " + response.body());
      System.out.println("Response code: " + response.statusCode());
    } catch (IOException | InterruptedException e) {
      System.out.println("An error occurred: " + e.getMessage());
    }
  }
  
  private static HttpRequest.BodyPublisher buildMultipartFormData(Map<Object, Object> data, String boundary) throws IOException {
    var byteArrays = new ArrayList<byte[]>();
    var CRLF = "\r\n".getBytes(StandardCharsets.UTF_8);

    for (Map.Entry<Object, Object> entry : data.entrySet()) {
        byteArrays.add(("--" + boundary + "\r\n").getBytes(StandardCharsets.UTF_8));
        if (entry.getValue() instanceof Path) {
            var file = (Path) entry.getValue();
            var fileName = file.getFileName().toString();
            byteArrays.add(("Content-Disposition: form-data; name=\"" + entry.getKey() + "\"; filename=\"" + fileName + "\"\r\n").getBytes(StandardCharsets.UTF_8));
            byteArrays.add(("Content-Type: " + Files.probeContentType(file) + "\r\n\r\n").getBytes(StandardCharsets.UTF_8));
            byteArrays.add(Files.readAllBytes(file));
            byteArrays.add(CRLF);
        } else {
            byteArrays.add(("Content-Disposition: form-data; name=\"" + entry.getKey() + "\"\r\n\r\n").getBytes(StandardCharsets.UTF_8));
            byteArrays.add(entry.getValue().toString().getBytes(StandardCharsets.UTF_8));
            byteArrays.add(CRLF);
        }
    }
    byteArrays.add(("--" + boundary + "--\r\n").getBytes(StandardCharsets.UTF_8));

    return HttpRequest.BodyPublishers.ofByteArrays(byteArrays);
  }
}''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelPost8, "https",
              boundary: "b9826c20-773c-1f0c-814d-a1b3d90cd6b3"),
          expectedCode);
    });
    test('POST9', () {
      const expectedCode = r'''
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;

public class Main {
  public static void main(String[] args) {
    try {
      HttpClient client = HttpClient.newHttpClient();
      URI uri = URI.create("https://api.apidash.dev/io/img?size=2&len=3");
      String boundary = "b9826c20-773c-1f0c-814d-a1b3d90cd6b3";
      Map<Object, Object> data = new HashMap<>();
      
      data.put("token", "xyz");
      data.put("imfile", Paths.get("/Documents/up/1.png"));
      HttpRequest.BodyPublisher bodyPublisher = buildMultipartFormData(data, boundary);
      HttpRequest.Builder requestBuilder = HttpRequest.newBuilder(uri).POST(bodyPublisher);
      requestBuilder = requestBuilder.headers(
        "User-Agent", "Test Agent",
        "Keep-Alive", "true",
        "Content-Type", "multipart/form-data; boundary=b9826c20-773c-1f0c-814d-a1b3d90cd6b3"
      );
      HttpResponse<String> response = client.send(requestBuilder.build(), HttpResponse.BodyHandlers.ofString());
      System.out.println("Response body: " + response.body());
      System.out.println("Response code: " + response.statusCode());
    } catch (IOException | InterruptedException e) {
      System.out.println("An error occurred: " + e.getMessage());
    }
  }
  
  private static HttpRequest.BodyPublisher buildMultipartFormData(Map<Object, Object> data, String boundary) throws IOException {
    var byteArrays = new ArrayList<byte[]>();
    var CRLF = "\r\n".getBytes(StandardCharsets.UTF_8);

    for (Map.Entry<Object, Object> entry : data.entrySet()) {
        byteArrays.add(("--" + boundary + "\r\n").getBytes(StandardCharsets.UTF_8));
        if (entry.getValue() instanceof Path) {
            var file = (Path) entry.getValue();
            var fileName = file.getFileName().toString();
            byteArrays.add(("Content-Disposition: form-data; name=\"" + entry.getKey() + "\"; filename=\"" + fileName + "\"\r\n").getBytes(StandardCharsets.UTF_8));
            byteArrays.add(("Content-Type: " + Files.probeContentType(file) + "\r\n\r\n").getBytes(StandardCharsets.UTF_8));
            byteArrays.add(Files.readAllBytes(file));
            byteArrays.add(CRLF);
        } else {
            byteArrays.add(("Content-Disposition: form-data; name=\"" + entry.getKey() + "\"\r\n\r\n").getBytes(StandardCharsets.UTF_8));
            byteArrays.add(entry.getValue().toString().getBytes(StandardCharsets.UTF_8));
            byteArrays.add(CRLF);
        }
    }
    byteArrays.add(("--" + boundary + "--\r\n").getBytes(StandardCharsets.UTF_8));

    return HttpRequest.BodyPublishers.ofByteArrays(byteArrays);
  }
}''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelPost9, "https",
              boundary: "b9826c20-773c-1f0c-814d-a1b3d90cd6b3"),
          expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT1', () {
      const expectedCode = r'''
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.io.IOException;

public class Main {
  public static void main(String[] args) {
    try {
      HttpClient client = HttpClient.newHttpClient();
      URI uri = URI.create("https://reqres.in/api/users/2");
      HttpRequest.BodyPublisher bodyPublisher = HttpRequest.BodyPublishers.ofString("""
{
"name": "morpheus",
"job": "zion resident"
}""");
      HttpRequest.Builder requestBuilder = HttpRequest.newBuilder(uri).PUT(bodyPublisher);
      requestBuilder = requestBuilder.headers(
        "Content-Type", "application/json"
      );
      HttpResponse<String> response = client.send(requestBuilder.build(), HttpResponse.BodyHandlers.ofString());
      System.out.println("Response body: " + response.body());
      System.out.println("Response code: " + response.statusCode());
    } catch (IOException | InterruptedException e) {
      System.out.println("An error occurred: " + e.getMessage());
    }
  }
  
}''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelPut1, "https"),
          expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH1', () {
      const expectedCode = r'''
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.io.IOException;

public class Main {
  public static void main(String[] args) {
    try {
      HttpClient client = HttpClient.newHttpClient();
      URI uri = URI.create("https://reqres.in/api/users/2");
      HttpRequest.BodyPublisher bodyPublisher = HttpRequest.BodyPublishers.ofString("""
{
"name": "marfeus",
"job": "accountant"
}""");
      HttpRequest.Builder requestBuilder = HttpRequest.newBuilder(uri).method("PATCH", bodyPublisher);
      requestBuilder = requestBuilder.headers(
        "Content-Type", "application/json"
      );
      HttpResponse<String> response = client.send(requestBuilder.build(), HttpResponse.BodyHandlers.ofString());
      System.out.println("Response body: " + response.body());
      System.out.println("Response code: " + response.statusCode());
    } catch (IOException | InterruptedException e) {
      System.out.println("An error occurred: " + e.getMessage());
    }
  }
  
}''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelPatch1, "https"),
          expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE1', () {
      const expectedCode = r'''
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.io.IOException;

public class Main {
  public static void main(String[] args) {
    try {
      HttpClient client = HttpClient.newHttpClient();
      URI uri = URI.create("https://reqres.in/api/users/2");

      HttpRequest.Builder requestBuilder = HttpRequest.newBuilder(uri).method("DELETE", HttpRequest.BodyPublishers.noBody());
      HttpResponse<String> response = client.send(requestBuilder.build(), HttpResponse.BodyHandlers.ofString());
      System.out.println("Response body: " + response.body());
      System.out.println("Response code: " + response.statusCode());
    } catch (IOException | InterruptedException e) {
      System.out.println("An error occurred: " + e.getMessage());
    }
  }
  
}''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelDelete1, "https"),
          expectedCode);
    });
    test('DELETE2', () {
      const expectedCode = r'''
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.io.IOException;

public class Main {
  public static void main(String[] args) {
    try {
      HttpClient client = HttpClient.newHttpClient();
      URI uri = URI.create("https://reqres.in/api/users/2");
      HttpRequest.BodyPublisher bodyPublisher = HttpRequest.BodyPublishers.ofString("""
{
"name": "marfeus",
"job": "accountant"
}""");
      HttpRequest.Builder requestBuilder = HttpRequest.newBuilder(uri).method("DELETE", bodyPublisher);
      requestBuilder = requestBuilder.headers(
        "Content-Type", "application/json"
      );
      HttpResponse<String> response = client.send(requestBuilder.build(), HttpResponse.BodyHandlers.ofString());
      System.out.println("Response body: " + response.body());
      System.out.println("Response code: " + response.statusCode());
    } catch (IOException | InterruptedException e) {
      System.out.println("An error occurred: " + e.getMessage());
    }
  }
  
}''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaHttpClient, requestModelDelete2, "https"),
          expectedCode);
    });
  });
}
