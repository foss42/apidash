import 'package:test/test.dart';
import 'package:apidash/codegen/java/httpclient.dart';
import '../request_models.dart';

void main() {
  final javaHttpClientCodeGen = JavaHttpClientCodeGen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = """
import java.io.IOException;
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

        String url = "https://api.foss42.com";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .GET()
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}

""";
      expect(javaHttpClientCodeGen.getCode(requestModelGet1, "https"), expectedCode);
    });

    test('GET 2', () {
    const expectedCode = """
import java.io.IOException;
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

        String url = "https://api.foss42.com/country/data";
        try {
            URI uri = new URI(url);
            url = uri.resolve("code=US").toString();
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .GET()
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}

""";
    expect(javaHttpClientCodeGen.getCode(requestModelGet2, "https"), expectedCode);
  });

  test('GET 3', () {
    const expectedCode = """
import java.io.IOException;
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

        String url = "https://api.foss42.com/country/data";
        try {
            URI uri = new URI(url);
            url = uri.resolve("code=IND").toString();
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .GET()
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}

""";
    expect(javaHttpClientCodeGen.getCode(requestModelGet3, "https"), expectedCode);
  });

  test('GET 4', () {
    const expectedCode = """
import java.io.IOException;
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

        String url = "https://api.foss42.com/humanize/social";
        try {
            URI uri = new URI(url);
            url = uri.resolve("num=8700000&digits=3&system=SS&add_space=true&trailing_zeros=true").toString();
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .GET()
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}

""";
    expect(javaHttpClientCodeGen.getCode(requestModelGet4, "https"), expectedCode);
  });

  test('GET 5', () {
    const expectedCode = """
import java.io.IOException;
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
}

""";
    expect(javaHttpClientCodeGen.getCode(requestModelGet5, "https"), expectedCode);
  });

  test('GET 6', () {
    const expectedCode = """
import java.io.IOException;
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
        try {
            URI uri = new URI(url);
            url = uri.resolve("raw=true").toString();
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .header("User-Agent", "Test Agent")
                .GET()
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}

""";
    expect(javaHttpClientCodeGen.getCode(requestModelGet6, "https"), expectedCode);
  });

  test('GET 7', () {
    const expectedCode = """
import java.io.IOException;
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

        String url = "https://api.foss42.com";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .GET()
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}

""";
    expect(javaHttpClientCodeGen.getCode(requestModelGet7, "https"), expectedCode);
  });

  test('GET 8', () {
    const expectedCode = """
import java.io.IOException;
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
        try {
            URI uri = new URI(url);
            url = uri.resolve("raw=true").toString();
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .header("User-Agent", "Test Agent")
                .GET()
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}

""";
    expect(javaHttpClientCodeGen.getCode(requestModelGet8, "https"), expectedCode);
  });

  test('GET 9', () {
    const expectedCode = """
import java.io.IOException;
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

        String url = "https://api.foss42.com/humanize/social";
        try {
            URI uri = new URI(url);
            url = uri.resolve("num=8700000&add_space=true").toString();
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .GET()
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}

""";
    expect(javaHttpClientCodeGen.getCode(requestModelGet9, "https"), expectedCode);
  });

  test('GET 10', () {
    const expectedCode = """
import java.io.IOException;
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

        String url = "https://api.foss42.com/humanize/social";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .header("User-Agent", "Test Agent")
                .GET()
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}

""";
    expect(javaHttpClientCodeGen.getCode(requestModelGet10, "https"), expectedCode);
  });

  test('GET 11', () {
    const expectedCode = """
import java.io.IOException;
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

        String url = "https://api.foss42.com/humanize/social";
        try {
            URI uri = new URI(url);
            url = uri.resolve("num=8700000&digits=3").toString();
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .header("User-Agent", "Test Agent")
                .GET()
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}

""";
    expect(javaHttpClientCodeGen.getCode(requestModelGet11, "https"), expectedCode);
  });

  test('GET 12', () {
    const expectedCode = """
import java.io.IOException;
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

        String url = "https://api.foss42.com/humanize/social";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .GET()
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}

""";
    expect(javaHttpClientCodeGen.getCode(requestModelGet12, "https"), expectedCode);
  });

  test('HEAD 1', () {
    const expectedCode = """
import java.io.IOException;
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

        String url = "https://api.foss42.com";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .HEAD()
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}

""";
    expect(javaHttpClientCodeGen.getCode(requestModelHead1, "https"), expectedCode);
  });

  test('HEAD 2', () {
    const expectedCode = """
import java.io.IOException;
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

        String url = "https://api.foss42.com";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .HEAD()
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}

""";
    expect(javaHttpClientCodeGen.getCode(requestModelHead2, "https"), expectedCode);
  });
});

group('POST Request', () {
  test('POST 1', () {
    const expectedCode = """
import java.io.IOException;
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

        String url = "https://api.foss42.com/case/lower";

        String body = "{\\n\\"text\\": \\"I LOVE Flutter\\"\\n}";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .header("Content-Type", "text/plain")
                .POST(BodyPublishers.ofString(body))
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}

""";
    expect(javaHttpClientCodeGen.getCode(requestModelPost1, "https"), expectedCode);
  });

  test('POST 2', () {
    const expectedCode = """
import java.io.IOException;
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

        String url = "https://api.foss42.com/case/lower";

        String body = "{\\n\\"text\\": \\"I LOVE Flutter\\"\\n}";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .header("Content-Type", "application/json")
                .POST(BodyPublishers.ofString(body))
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}

""";
    expect(javaHttpClientCodeGen.getCode(requestModelPost2, "https"), expectedCode);
  });

  test('POST 3', () {
    const expectedCode = """
import java.io.IOException;
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

        String url = "https://api.foss42.com/case/lower";

        String body = "{\\n\\"text\\": \\"I LOVE Flutter\\"\\n}";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .header("Content-Type", "application/json")
                .header("User-Agent", "Test Agent")
                .POST(BodyPublishers.ofString(body))
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}

""";
    expect(javaHttpClientCodeGen.getCode(requestModelPost3, "https"), expectedCode);
  });
});

group('PUT Request', () {
  test('PUT 1', () {
    const expectedCode = """
import java.io.IOException;
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

        String body = "{\\n\\"name\\": \\"morpheus\\",\\n\\"job\\": \\"zion resident\\"\\n}";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .header("Content-Type", "application/json")
                .PUT(BodyPublishers.ofString(body))
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}

""";
    expect(javaHttpClientCodeGen.getCode(requestModelPut1, "https"), expectedCode);
  });
});

group('PATCH Request', () {
  test('PATCH 1', () {
    const expectedCode = """
import java.io.IOException;
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

        String body = "{\\n\\"name\\": \\"marfeus\\",\\n\\"job\\": \\"accountant\\"\\n}";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .header("Content-Type", "application/json")
                .PATCH(BodyPublishers.ofString(body))
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}

""";
    expect(javaHttpClientCodeGen.getCode(requestModelPatch1, "https"), expectedCode);
  });
});

group('DELETE Request', () {
  test('DELETE 1', () {
    const expectedCode = """
import java.io.IOException;
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

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .DELETE(BodyPublishers.noBody())
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}

""";
    expect(javaHttpClientCodeGen.getCode(requestModelDelete1, "https"), expectedCode);
  });

  test('DELETE 2', () {
    const expectedCode = """
import java.io.IOException;
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

        String body = "{\\n\\"name\\": \\"marfeus\\",\\n\\"job\\": \\"accountant\\"\\n}";

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .header("Content-Type", "application/json")
                .DELETE(BodyPublishers.ofString(body))
                .build();

        HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        System.out.println(response.statusCode());
        System.out.println(response.body());
    }
}

""";
    expect(javaHttpClientCodeGen.getCode(requestModelDelete2, "https"), expectedCode);
  });
});



}