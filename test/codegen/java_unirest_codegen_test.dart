import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:test/test.dart';
import '../models/request_models.dart';

void main() {
  final codeGen = Codegen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""import kong.unirest.core.*;

public class Main {
    public static void main(String[] args) {
        final String requestURL = "https://api.apidash.dev";
        HttpResponse<JsonNode> response = Unirest
                .get(requestURL)
                .asJson();
        System.out.println(response.getStatus());
        System.out.println(response.getBody());
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaUnirest, requestModelGet1, "https"),
          expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r"""import kong.unirest.core.*;

public class Main {
    public static void main(String[] args) {
        final String requestURL = "https://api.apidash.dev/country/data";
        HttpResponse<JsonNode> response = Unirest
                .get(requestURL)
                .queryString("code", "US")
                .asJson();
        System.out.println(response.getStatus());
        System.out.println(response.getBody());
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaUnirest, requestModelGet2, "https"),
          expectedCode);
    });

    test('GET 3', () {
      const expectedCode = r"""import kong.unirest.core.*;

public class Main {
    public static void main(String[] args) {
        final String requestURL = "https://api.apidash.dev/country/data";
        HttpResponse<JsonNode> response = Unirest
                .get(requestURL)
                .queryString("code", "IND")
                .asJson();
        System.out.println(response.getStatus());
        System.out.println(response.getBody());
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaUnirest, requestModelGet3, "https"),
          expectedCode);
    });

    test('GET 4', () {
      const expectedCode = r"""import kong.unirest.core.*;

public class Main {
    public static void main(String[] args) {
        final String requestURL = "https://api.apidash.dev/humanize/social";
        HttpResponse<JsonNode> response = Unirest
                .get(requestURL)
                .queryString("num", "8700000")
                .queryString("digits", "3")
                .queryString("system", "SS")
                .queryString("add_space", "true")
                .queryString("trailing_zeros", "true")
                .asJson();
        System.out.println(response.getStatus());
        System.out.println(response.getBody());
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaUnirest, requestModelGet4, "https"),
          expectedCode);
    });

    test('GET 5', () {
      const expectedCode = r"""import kong.unirest.core.*;

public class Main {
    public static void main(String[] args) {
        final String requestURL = "https://api.github.com/repos/foss42/apidash";
        HttpResponse<JsonNode> response = Unirest
                .get(requestURL)
                .header("User-Agent", "Test Agent")
                .asJson();
        System.out.println(response.getStatus());
        System.out.println(response.getBody());
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaUnirest, requestModelGet5, "https"),
          expectedCode);
    });

    test('GET 6', () {
      const expectedCode = r"""import kong.unirest.core.*;

public class Main {
    public static void main(String[] args) {
        final String requestURL = "https://api.github.com/repos/foss42/apidash";
        HttpResponse<JsonNode> response = Unirest
                .get(requestURL)
                .header("User-Agent", "Test Agent")
                .queryString("raw", "true")
                .asJson();
        System.out.println(response.getStatus());
        System.out.println(response.getBody());
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaUnirest, requestModelGet6, "https"),
          expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r"""import kong.unirest.core.*;

public class Main {
    public static void main(String[] args) {
        final String requestURL = "https://api.apidash.dev";
        HttpResponse<JsonNode> response = Unirest
                .get(requestURL)
                .asJson();
        System.out.println(response.getStatus());
        System.out.println(response.getBody());
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaUnirest, requestModelGet7, "https"),
          expectedCode);
    });

    test('GET 8', () {
      const expectedCode = r"""import kong.unirest.core.*;

public class Main {
    public static void main(String[] args) {
        final String requestURL = "https://api.github.com/repos/foss42/apidash";
        HttpResponse<JsonNode> response = Unirest
                .get(requestURL)
                .header("User-Agent", "Test Agent")
                .queryString("raw", "true")
                .asJson();
        System.out.println(response.getStatus());
        System.out.println(response.getBody());
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaUnirest, requestModelGet8, "https"),
          expectedCode);
    });

    test('GET 9', () {
      const expectedCode = r"""import kong.unirest.core.*;

public class Main {
    public static void main(String[] args) {
        final String requestURL = "https://api.apidash.dev/humanize/social";
        HttpResponse<JsonNode> response = Unirest
                .get(requestURL)
                .queryString("num", "8700000")
                .queryString("add_space", "true")
                .asJson();
        System.out.println(response.getStatus());
        System.out.println(response.getBody());
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaUnirest, requestModelGet9, "https"),
          expectedCode);
    });

    test('GET 10', () {
      const expectedCode = r"""import kong.unirest.core.*;

public class Main {
    public static void main(String[] args) {
        final String requestURL = "https://api.apidash.dev/humanize/social";
        HttpResponse<JsonNode> response = Unirest
                .get(requestURL)
                .header("User-Agent", "Test Agent")
                .asJson();
        System.out.println(response.getStatus());
        System.out.println(response.getBody());
    }
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.javaUnirest,
            requestModelGet10,
            "https",
          ),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode = r"""import kong.unirest.core.*;

public class Main {
    public static void main(String[] args) {
        final String requestURL = "https://api.apidash.dev/humanize/social";
        HttpResponse<JsonNode> response = Unirest
                .get(requestURL)
                .header("User-Agent", "Test Agent")
                .queryString("num", "8700000")
                .queryString("digits", "3")
                .asJson();
        System.out.println(response.getStatus());
        System.out.println(response.getBody());
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaUnirest, requestModelGet11, "https"),
          expectedCode);
    });

    test('GET 12', () {
      const expectedCode = r"""import kong.unirest.core.*;

public class Main {
    public static void main(String[] args) {
        final String requestURL = "https://api.apidash.dev/humanize/social";
        HttpResponse<JsonNode> response = Unirest
                .get(requestURL)
                .asJson();
        System.out.println(response.getStatus());
        System.out.println(response.getBody());
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaUnirest, requestModelGet12, "https"),
          expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""import kong.unirest.core.*;

public class Main {
    public static void main(String[] args) {
        final String requestURL = "https://api.apidash.dev";
        HttpResponse<JsonNode> response = Unirest
                .head(requestURL)
                .asJson();
        System.out.println(response.getStatus());
        System.out.println(response.getBody());
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaUnirest, requestModelHead1, "https"),
          expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""import kong.unirest.core.*;

public class Main {
    public static void main(String[] args) {
        final String requestURL = "http://api.apidash.dev";
        HttpResponse<JsonNode> response = Unirest
                .head(requestURL)
                .asJson();
        System.out.println(response.getStatus());
        System.out.println(response.getBody());
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaUnirest, requestModelHead2, "http"),
          expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r'''import kong.unirest.core.*;

public class Main {
    public static void main(String[] args) {
        final String requestURL = "https://api.apidash.dev/case/lower";
        final String requestBody = """
{
"text": "I LOVE Flutter"
}""";
        HttpResponse<JsonNode> response = Unirest
                .post(requestURL)
                .header("Content-Type", "text/plain")
                .body(requestBody)
                .asJson();
        System.out.println(response.getStatus());
        System.out.println(response.getBody());
    }
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaUnirest, requestModelPost1, "https"),
          expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r'''import kong.unirest.core.*;

public class Main {
    public static void main(String[] args) {
        final String requestURL = "https://api.apidash.dev/case/lower";
        final String requestBody = """
{
"text": "I LOVE Flutter",
"flag": null,
"male": true,
"female": false,
"no": 1.2,
"arr": ["null", "true", "false", null]
}""";
        HttpResponse<JsonNode> response = Unirest
                .post(requestURL)
                .header("Content-Type", "application/json")
                .body(requestBody)
                .asJson();
        System.out.println(response.getStatus());
        System.out.println(response.getBody());
    }
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaUnirest, requestModelPost2, "https"),
          expectedCode);
    });

    test('POST 3', () {
      const expectedCode = r'''import kong.unirest.core.*;

public class Main {
    public static void main(String[] args) {
        final String requestURL = "https://api.apidash.dev/case/lower";
        final String requestBody = """
{
"text": "I LOVE Flutter"
}""";
        HttpResponse<JsonNode> response = Unirest
                .post(requestURL)
                .header("User-Agent", "Test Agent")
                .header("Content-Type", "application/json")
                .body(requestBody)
                .asJson();
        System.out.println(response.getStatus());
        System.out.println(response.getBody());
    }
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaUnirest, requestModelPost3, "https"),
          expectedCode);
    });
    test('POST 4', () {
      const expectedCode = r"""import kong.unirest.core.*;

public class Main {
    public static void main(String[] args) {
        final String requestURL = "https://api.apidash.dev/io/form";
        HttpResponse<JsonNode> response = Unirest
                .post(requestURL)
                .field("text", "API")
                .field("sep", "|")
                .field("times", "3")
                .asJson();
        System.out.println(response.getStatus());
        System.out.println(response.getBody());
    }
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.javaUnirest,
            requestModelPost4,
            "https",
          ),
          expectedCode);
    });

    test('POST 5', () {
      const expectedCode = r"""import kong.unirest.core.*;

public class Main {
    public static void main(String[] args) {
        final String requestURL = "https://api.apidash.dev/io/form";
        HttpResponse<JsonNode> response = Unirest
                .post(requestURL)
                .header("User-Agent", "Test Agent")
                .field("text", "API")
                .field("sep", "|")
                .field("times", "3")
                .asJson();
        System.out.println(response.getStatus());
        System.out.println(response.getBody());
    }
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.javaUnirest,
            requestModelPost5,
            "https",
          ),
          expectedCode);
    });
    test('POST 6', () {
      const expectedCode = r"""import kong.unirest.core.*;

import java.io.File;

public class Main {
    public static void main(String[] args) {
        final String requestURL = "https://api.apidash.dev/io/img";
        HttpResponse<JsonNode> response = Unirest
                .post(requestURL)
                .field("token", "xyz")
                .field("imfile", new File("/Documents/up/1.png"))
                .asJson();
        System.out.println(response.getStatus());
        System.out.println(response.getBody());
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaUnirest, requestModelPost6, "https"),
          expectedCode);
    });
    test('POST 7', () {
      const expectedCode = r"""import kong.unirest.core.*;

import java.io.File;

public class Main {
    public static void main(String[] args) {
        final String requestURL = "https://api.apidash.dev/io/img";
        HttpResponse<JsonNode> response = Unirest
                .post(requestURL)
                .field("token", "xyz")
                .field("imfile", new File("/Documents/up/1.png"))
                .asJson();
        System.out.println(response.getStatus());
        System.out.println(response.getBody());
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaUnirest, requestModelPost7, "https"),
          expectedCode);
    });
    test('POST 8', () {
      const expectedCode = r"""import kong.unirest.core.*;

public class Main {
    public static void main(String[] args) {
        final String requestURL = "https://api.apidash.dev/io/form";
        HttpResponse<JsonNode> response = Unirest
                .post(requestURL)
                .queryString("size", "2")
                .queryString("len", "3")
                .field("text", "API")
                .field("sep", "|")
                .field("times", "3")
                .asJson();
        System.out.println(response.getStatus());
        System.out.println(response.getBody());
    }
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.javaUnirest,
            requestModelPost8,
            "https",
          ),
          expectedCode);
    });
    test('POST 9', () {
      const expectedCode = r"""import kong.unirest.core.*;

import java.io.File;

public class Main {
    public static void main(String[] args) {
        final String requestURL = "https://api.apidash.dev/io/img";
        HttpResponse<JsonNode> response = Unirest
                .post(requestURL)
                .header("User-Agent", "Test Agent")
                .header("Keep-Alive", "true")
                .queryString("size", "2")
                .queryString("len", "3")
                .field("token", "xyz")
                .field("imfile", new File("/Documents/up/1.png"))
                .asJson();
        System.out.println(response.getStatus());
        System.out.println(response.getBody());
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaUnirest, requestModelPost9, "https"),
          expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT 1', () {
      const expectedCode = r'''import kong.unirest.core.*;

public class Main {
    public static void main(String[] args) {
        final String requestURL = "https://reqres.in/api/users/2";
        final String requestBody = """
{
"name": "morpheus",
"job": "zion resident"
}""";
        HttpResponse<JsonNode> response = Unirest
                .put(requestURL)
                .header("Content-Type", "application/json")
                .body(requestBody)
                .asJson();
        System.out.println(response.getStatus());
        System.out.println(response.getBody());
    }
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaUnirest, requestModelPut1, "https"),
          expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH 1', () {
      const expectedCode = r'''import kong.unirest.core.*;

public class Main {
    public static void main(String[] args) {
        final String requestURL = "https://reqres.in/api/users/2";
        final String requestBody = """
{
"name": "marfeus",
"job": "accountant"
}""";
        HttpResponse<JsonNode> response = Unirest
                .patch(requestURL)
                .header("Content-Type", "application/json")
                .body(requestBody)
                .asJson();
        System.out.println(response.getStatus());
        System.out.println(response.getBody());
    }
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaUnirest, requestModelPatch1, "https"),
          expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode = r"""import kong.unirest.core.*;

public class Main {
    public static void main(String[] args) {
        final String requestURL = "https://reqres.in/api/users/2";
        HttpResponse<JsonNode> response = Unirest
                .delete(requestURL)
                .asJson();
        System.out.println(response.getStatus());
        System.out.println(response.getBody());
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaUnirest, requestModelDelete1, "https"),
          expectedCode);
    });

    test('DELETE 2', () {
      const expectedCode = r'''import kong.unirest.core.*;

public class Main {
    public static void main(String[] args) {
        final String requestURL = "https://reqres.in/api/users/2";
        final String requestBody = """
{
"name": "marfeus",
"job": "accountant"
}""";
        HttpResponse<JsonNode> response = Unirest
                .delete(requestURL)
                .header("Content-Type", "application/json")
                .body(requestBody)
                .asJson();
        System.out.println(response.getStatus());
        System.out.println(response.getBody());
    }
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaUnirest, requestModelDelete2, "https"),
          expectedCode);
    });
  });
}
