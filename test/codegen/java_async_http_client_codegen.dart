import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:test/test.dart';
import '../models/request_models.dart';

void main() {
  final codeGen = Codegen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r'''import org.asynchttpclient.*;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.stream.Collectors;

public class Main {
    public static void main(String[] args) {
        try (AsyncHttpClient asyncHttpClient = Dsl.asyncHttpClient()) {
            String url = "https://api.apidash.dev";
            BoundRequestBuilder requestBuilder = asyncHttpClient.prepare("GET", url);
            Future<Response> whenResponse = requestBuilder.execute();
            Response response = whenResponse.get();
            InputStream is = response.getResponseBodyAsStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
            String respBody = br.lines().collect(Collectors.joining("\n"));
            System.out.println(response.getStatusCode());
            System.out.println(respBody);
        } catch (InterruptedException | ExecutionException | IOException ignored) {

        }
    }
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaAsyncHttpClient, requestModelGet1, "https"),
          expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r"""import org.asynchttpclient.*;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.stream.Collectors;

public class Main {
    public static void main(String[] args) {
        try (AsyncHttpClient asyncHttpClient = Dsl.asyncHttpClient()) {
            String url = "https://api.apidash.dev/country/data";
            BoundRequestBuilder requestBuilder = asyncHttpClient.prepare("GET", url);
            requestBuilder
                .addQueryParam("code", "US");
            Future<Response> whenResponse = requestBuilder.execute();
            Response response = whenResponse.get();
            InputStream is = response.getResponseBodyAsStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
            String respBody = br.lines().collect(Collectors.joining("\n"));
            System.out.println(response.getStatusCode());
            System.out.println(respBody);
        } catch (InterruptedException | ExecutionException | IOException ignored) {

        }
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaAsyncHttpClient, requestModelGet2, "https"),
          expectedCode);
    });

    test('GET 3', () {
      const expectedCode = r"""import org.asynchttpclient.*;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.stream.Collectors;

public class Main {
    public static void main(String[] args) {
        try (AsyncHttpClient asyncHttpClient = Dsl.asyncHttpClient()) {
            String url = "https://api.apidash.dev/country/data";
            BoundRequestBuilder requestBuilder = asyncHttpClient.prepare("GET", url);
            requestBuilder
                .addQueryParam("code", "IND");
            Future<Response> whenResponse = requestBuilder.execute();
            Response response = whenResponse.get();
            InputStream is = response.getResponseBodyAsStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
            String respBody = br.lines().collect(Collectors.joining("\n"));
            System.out.println(response.getStatusCode());
            System.out.println(respBody);
        } catch (InterruptedException | ExecutionException | IOException ignored) {

        }
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaAsyncHttpClient, requestModelGet3, "https"),
          expectedCode);
    });

    test('GET 4', () {
      const expectedCode = r"""import org.asynchttpclient.*;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.stream.Collectors;

public class Main {
    public static void main(String[] args) {
        try (AsyncHttpClient asyncHttpClient = Dsl.asyncHttpClient()) {
            String url = "https://api.apidash.dev/humanize/social";
            BoundRequestBuilder requestBuilder = asyncHttpClient.prepare("GET", url);
            requestBuilder
                .addQueryParam("num", "8700000")
                .addQueryParam("digits", "3")
                .addQueryParam("system", "SS")
                .addQueryParam("add_space", "true")
                .addQueryParam("trailing_zeros", "true");
            Future<Response> whenResponse = requestBuilder.execute();
            Response response = whenResponse.get();
            InputStream is = response.getResponseBodyAsStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
            String respBody = br.lines().collect(Collectors.joining("\n"));
            System.out.println(response.getStatusCode());
            System.out.println(respBody);
        } catch (InterruptedException | ExecutionException | IOException ignored) {

        }
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaAsyncHttpClient, requestModelGet4, "https"),
          expectedCode);
    });

    test('GET 5', () {
      const expectedCode = r"""import org.asynchttpclient.*;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.stream.Collectors;

public class Main {
    public static void main(String[] args) {
        try (AsyncHttpClient asyncHttpClient = Dsl.asyncHttpClient()) {
            String url = "https://api.github.com/repos/foss42/apidash";
            BoundRequestBuilder requestBuilder = asyncHttpClient.prepare("GET", url);
            requestBuilder
                .addHeader("User-Agent", "Test Agent");
            Future<Response> whenResponse = requestBuilder.execute();
            Response response = whenResponse.get();
            InputStream is = response.getResponseBodyAsStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
            String respBody = br.lines().collect(Collectors.joining("\n"));
            System.out.println(response.getStatusCode());
            System.out.println(respBody);
        } catch (InterruptedException | ExecutionException | IOException ignored) {

        }
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaAsyncHttpClient, requestModelGet5, "https"),
          expectedCode);
    });

    test('GET 6', () {
      const expectedCode = r"""import org.asynchttpclient.*;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.stream.Collectors;

public class Main {
    public static void main(String[] args) {
        try (AsyncHttpClient asyncHttpClient = Dsl.asyncHttpClient()) {
            String url = "https://api.github.com/repos/foss42/apidash";
            BoundRequestBuilder requestBuilder = asyncHttpClient.prepare("GET", url);
            requestBuilder
                .addQueryParam("raw", "true");
            requestBuilder
                .addHeader("User-Agent", "Test Agent");
            Future<Response> whenResponse = requestBuilder.execute();
            Response response = whenResponse.get();
            InputStream is = response.getResponseBodyAsStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
            String respBody = br.lines().collect(Collectors.joining("\n"));
            System.out.println(response.getStatusCode());
            System.out.println(respBody);
        } catch (InterruptedException | ExecutionException | IOException ignored) {

        }
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaAsyncHttpClient, requestModelGet6, "https"),
          expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r"""import org.asynchttpclient.*;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.stream.Collectors;

public class Main {
    public static void main(String[] args) {
        try (AsyncHttpClient asyncHttpClient = Dsl.asyncHttpClient()) {
            String url = "https://api.apidash.dev";
            BoundRequestBuilder requestBuilder = asyncHttpClient.prepare("GET", url);
            Future<Response> whenResponse = requestBuilder.execute();
            Response response = whenResponse.get();
            InputStream is = response.getResponseBodyAsStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
            String respBody = br.lines().collect(Collectors.joining("\n"));
            System.out.println(response.getStatusCode());
            System.out.println(respBody);
        } catch (InterruptedException | ExecutionException | IOException ignored) {

        }
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaAsyncHttpClient, requestModelGet7, "https"),
          expectedCode);
    });

    test('GET 8', () {
      const expectedCode = r"""import org.asynchttpclient.*;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.stream.Collectors;

public class Main {
    public static void main(String[] args) {
        try (AsyncHttpClient asyncHttpClient = Dsl.asyncHttpClient()) {
            String url = "https://api.github.com/repos/foss42/apidash";
            BoundRequestBuilder requestBuilder = asyncHttpClient.prepare("GET", url);
            requestBuilder
                .addQueryParam("raw", "true");
            requestBuilder
                .addHeader("User-Agent", "Test Agent");
            Future<Response> whenResponse = requestBuilder.execute();
            Response response = whenResponse.get();
            InputStream is = response.getResponseBodyAsStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
            String respBody = br.lines().collect(Collectors.joining("\n"));
            System.out.println(response.getStatusCode());
            System.out.println(respBody);
        } catch (InterruptedException | ExecutionException | IOException ignored) {

        }
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaAsyncHttpClient, requestModelGet8, "https"),
          expectedCode);
    });

    test('GET 9', () {
      const expectedCode = r"""import org.asynchttpclient.*;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.stream.Collectors;

public class Main {
    public static void main(String[] args) {
        try (AsyncHttpClient asyncHttpClient = Dsl.asyncHttpClient()) {
            String url = "https://api.apidash.dev/humanize/social";
            BoundRequestBuilder requestBuilder = asyncHttpClient.prepare("GET", url);
            requestBuilder
                .addQueryParam("num", "8700000")
                .addQueryParam("add_space", "true");
            Future<Response> whenResponse = requestBuilder.execute();
            Response response = whenResponse.get();
            InputStream is = response.getResponseBodyAsStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
            String respBody = br.lines().collect(Collectors.joining("\n"));
            System.out.println(response.getStatusCode());
            System.out.println(respBody);
        } catch (InterruptedException | ExecutionException | IOException ignored) {

        }
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaAsyncHttpClient, requestModelGet9, "https"),
          expectedCode);
    });

    test('GET 10', () {
      const expectedCode = r"""import org.asynchttpclient.*;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.stream.Collectors;

public class Main {
    public static void main(String[] args) {
        try (AsyncHttpClient asyncHttpClient = Dsl.asyncHttpClient()) {
            String url = "https://api.apidash.dev/humanize/social";
            BoundRequestBuilder requestBuilder = asyncHttpClient.prepare("GET", url);
            requestBuilder
                .addHeader("User-Agent", "Test Agent");
            Future<Response> whenResponse = requestBuilder.execute();
            Response response = whenResponse.get();
            InputStream is = response.getResponseBodyAsStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
            String respBody = br.lines().collect(Collectors.joining("\n"));
            System.out.println(response.getStatusCode());
            System.out.println(respBody);
        } catch (InterruptedException | ExecutionException | IOException ignored) {

        }
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaAsyncHttpClient, requestModelGet10, "https"),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode = r"""import org.asynchttpclient.*;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.stream.Collectors;

public class Main {
    public static void main(String[] args) {
        try (AsyncHttpClient asyncHttpClient = Dsl.asyncHttpClient()) {
            String url = "https://api.apidash.dev/humanize/social";
            BoundRequestBuilder requestBuilder = asyncHttpClient.prepare("GET", url);
            requestBuilder
                .addQueryParam("num", "8700000")
                .addQueryParam("digits", "3");
            requestBuilder
                .addHeader("User-Agent", "Test Agent");
            Future<Response> whenResponse = requestBuilder.execute();
            Response response = whenResponse.get();
            InputStream is = response.getResponseBodyAsStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
            String respBody = br.lines().collect(Collectors.joining("\n"));
            System.out.println(response.getStatusCode());
            System.out.println(respBody);
        } catch (InterruptedException | ExecutionException | IOException ignored) {

        }
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaAsyncHttpClient, requestModelGet11, "https"),
          expectedCode);
    });

    test('GET 12', () {
      const expectedCode = r"""import org.asynchttpclient.*;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.stream.Collectors;

public class Main {
    public static void main(String[] args) {
        try (AsyncHttpClient asyncHttpClient = Dsl.asyncHttpClient()) {
            String url = "https://api.apidash.dev/humanize/social";
            BoundRequestBuilder requestBuilder = asyncHttpClient.prepare("GET", url);
            Future<Response> whenResponse = requestBuilder.execute();
            Response response = whenResponse.get();
            InputStream is = response.getResponseBodyAsStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
            String respBody = br.lines().collect(Collectors.joining("\n"));
            System.out.println(response.getStatusCode());
            System.out.println(respBody);
        } catch (InterruptedException | ExecutionException | IOException ignored) {

        }
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaAsyncHttpClient, requestModelGet12, "https"),
          expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""import org.asynchttpclient.*;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.stream.Collectors;

public class Main {
    public static void main(String[] args) {
        try (AsyncHttpClient asyncHttpClient = Dsl.asyncHttpClient()) {
            String url = "https://api.apidash.dev";
            BoundRequestBuilder requestBuilder = asyncHttpClient.prepare("HEAD", url);
            Future<Response> whenResponse = requestBuilder.execute();
            Response response = whenResponse.get();
            InputStream is = response.getResponseBodyAsStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
            String respBody = br.lines().collect(Collectors.joining("\n"));
            System.out.println(response.getStatusCode());
            System.out.println(respBody);
        } catch (InterruptedException | ExecutionException | IOException ignored) {

        }
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaAsyncHttpClient, requestModelHead1, "https"),
          expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""import org.asynchttpclient.*;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.stream.Collectors;

public class Main {
    public static void main(String[] args) {
        try (AsyncHttpClient asyncHttpClient = Dsl.asyncHttpClient()) {
            String url = "http://api.apidash.dev";
            BoundRequestBuilder requestBuilder = asyncHttpClient.prepare("HEAD", url);
            Future<Response> whenResponse = requestBuilder.execute();
            Response response = whenResponse.get();
            InputStream is = response.getResponseBodyAsStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
            String respBody = br.lines().collect(Collectors.joining("\n"));
            System.out.println(response.getStatusCode());
            System.out.println(respBody);
        } catch (InterruptedException | ExecutionException | IOException ignored) {

        }
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaAsyncHttpClient, requestModelHead2, "http"),
          expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r'''import org.asynchttpclient.*;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.stream.Collectors;

public class Main {
    public static void main(String[] args) {
        try (AsyncHttpClient asyncHttpClient = Dsl.asyncHttpClient()) {
            String url = "https://api.apidash.dev/case/lower";
            String bodyContent = """
{
"text": "I LOVE Flutter"
}""";
            BoundRequestBuilder requestBuilder = asyncHttpClient.prepare("POST", url);
            requestBuilder
                .addHeader("Content-Type", "text/plain");
            requestBuilder.setBody(bodyContent);
            Future<Response> whenResponse = requestBuilder.execute();
            Response response = whenResponse.get();
            InputStream is = response.getResponseBodyAsStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
            String respBody = br.lines().collect(Collectors.joining("\n"));
            System.out.println(response.getStatusCode());
            System.out.println(respBody);
        } catch (InterruptedException | ExecutionException | IOException ignored) {

        }
    }
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaAsyncHttpClient, requestModelPost1, "https"),
          expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r'''import org.asynchttpclient.*;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.stream.Collectors;

public class Main {
    public static void main(String[] args) {
        try (AsyncHttpClient asyncHttpClient = Dsl.asyncHttpClient()) {
            String url = "https://api.apidash.dev/case/lower";
            String bodyContent = """
{
"text": "I LOVE Flutter",
"flag": null,
"male": true,
"female": false,
"no": 1.2,
"arr": ["null", "true", "false", null]
}""";
            BoundRequestBuilder requestBuilder = asyncHttpClient.prepare("POST", url);
            requestBuilder
                .addHeader("Content-Type", "application/json");
            requestBuilder.setBody(bodyContent);
            Future<Response> whenResponse = requestBuilder.execute();
            Response response = whenResponse.get();
            InputStream is = response.getResponseBodyAsStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
            String respBody = br.lines().collect(Collectors.joining("\n"));
            System.out.println(response.getStatusCode());
            System.out.println(respBody);
        } catch (InterruptedException | ExecutionException | IOException ignored) {

        }
    }
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaAsyncHttpClient, requestModelPost2, "https"),
          expectedCode);
    });

    test('POST 3', () {
      const expectedCode = r'''import org.asynchttpclient.*;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.stream.Collectors;

public class Main {
    public static void main(String[] args) {
        try (AsyncHttpClient asyncHttpClient = Dsl.asyncHttpClient()) {
            String url = "https://api.apidash.dev/case/lower";
            String bodyContent = """
{
"text": "I LOVE Flutter"
}""";
            BoundRequestBuilder requestBuilder = asyncHttpClient.prepare("POST", url);
            requestBuilder
                .addHeader("User-Agent", "Test Agent")
                .addHeader("Content-Type", "application/json");
            requestBuilder.setBody(bodyContent);
            Future<Response> whenResponse = requestBuilder.execute();
            Response response = whenResponse.get();
            InputStream is = response.getResponseBodyAsStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
            String respBody = br.lines().collect(Collectors.joining("\n"));
            System.out.println(response.getStatusCode());
            System.out.println(respBody);
        } catch (InterruptedException | ExecutionException | IOException ignored) {

        }
    }
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaAsyncHttpClient, requestModelPost3, "https"),
          expectedCode);
    });

    test('POST 4', () {
      const expectedCode = r'''import org.asynchttpclient.*;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.stream.Collectors;

import java.util.Map;
import java.util.HashMap;
import org.asynchttpclient.request.body.multipart.StringPart;

public class Main {
    public static void main(String[] args) {
        try (AsyncHttpClient asyncHttpClient = Dsl.asyncHttpClient()) {
            String url = "https://api.apidash.dev/io/form";
            BoundRequestBuilder requestBuilder = asyncHttpClient.prepare("POST", url);

            Map<String, String> params = new HashMap<>() {
                { 
                    put("text", "API");
                    put("sep", "|");
                    put("times", "3");
                }
            };

            for (String paramName : params.keySet()) {
                requestBuilder.addBodyPart(new StringPart(
                    paramName, params.get(paramName)
                ));
            }

            Future<Response> whenResponse = requestBuilder.execute();
            Response response = whenResponse.get();
            InputStream is = response.getResponseBodyAsStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
            String respBody = br.lines().collect(Collectors.joining("\n"));
            System.out.println(response.getStatusCode());
            System.out.println(respBody);
        } catch (InterruptedException | ExecutionException | IOException ignored) {

        }
    }
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaAsyncHttpClient, requestModelPost4, "https"),
          expectedCode);
    });

    test('POST 5', () {
      const expectedCode = r'''import org.asynchttpclient.*;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.stream.Collectors;

import java.util.Map;
import java.util.HashMap;
import org.asynchttpclient.request.body.multipart.StringPart;

public class Main {
    public static void main(String[] args) {
        try (AsyncHttpClient asyncHttpClient = Dsl.asyncHttpClient()) {
            String url = "https://api.apidash.dev/io/form";
            BoundRequestBuilder requestBuilder = asyncHttpClient.prepare("POST", url);
            requestBuilder
                .addHeader("User-Agent", "Test Agent");

            Map<String, String> params = new HashMap<>() {
                { 
                    put("text", "API");
                    put("sep", "|");
                    put("times", "3");
                }
            };

            for (String paramName : params.keySet()) {
                requestBuilder.addBodyPart(new StringPart(
                    paramName, params.get(paramName)
                ));
            }

            Future<Response> whenResponse = requestBuilder.execute();
            Response response = whenResponse.get();
            InputStream is = response.getResponseBodyAsStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
            String respBody = br.lines().collect(Collectors.joining("\n"));
            System.out.println(response.getStatusCode());
            System.out.println(respBody);
        } catch (InterruptedException | ExecutionException | IOException ignored) {

        }
    }
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaAsyncHttpClient, requestModelPost5, "https"),
          expectedCode);
    });

    test('POST 6', () {
      const expectedCode = r'''import org.asynchttpclient.*;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.stream.Collectors;

import java.util.Map;
import java.util.HashMap;
import org.asynchttpclient.request.body.multipart.StringPart;
import org.asynchttpclient.request.body.multipart.FilePart;

public class Main {
    public static void main(String[] args) {
        try (AsyncHttpClient asyncHttpClient = Dsl.asyncHttpClient()) {
            String url = "https://api.apidash.dev/io/img";
            BoundRequestBuilder requestBuilder = asyncHttpClient.prepare("POST", url);

            Map<String, String> params = new HashMap<>() {
                { 
                    put("token", "xyz");
                }
            };

            for (String paramName : params.keySet()) {
                requestBuilder.addBodyPart(new StringPart(
                    paramName, params.get(paramName)
                ));
            }

            Map<String, String> files = new HashMap<>() {
                { 
                    put("imfile", "/Documents/up/1.png");
                }
            };

            for (String paramName : files.keySet()) {
                File file = new File(files.get(paramName));
                requestBuilder.addBodyPart(new FilePart(
                        paramName,
                        file,
                        "application/octet-stream",
                        StandardCharsets.UTF_8,
                        file.getName()
                ));
            }

            Future<Response> whenResponse = requestBuilder.execute();
            Response response = whenResponse.get();
            InputStream is = response.getResponseBodyAsStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
            String respBody = br.lines().collect(Collectors.joining("\n"));
            System.out.println(response.getStatusCode());
            System.out.println(respBody);
        } catch (InterruptedException | ExecutionException | IOException ignored) {

        }
    }
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaAsyncHttpClient, requestModelPost6, "https"),
          expectedCode);
    });

    test('POST 7', () {
      const expectedCode = r'''import org.asynchttpclient.*;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.stream.Collectors;

import java.util.Map;
import java.util.HashMap;
import org.asynchttpclient.request.body.multipart.StringPart;
import org.asynchttpclient.request.body.multipart.FilePart;

public class Main {
    public static void main(String[] args) {
        try (AsyncHttpClient asyncHttpClient = Dsl.asyncHttpClient()) {
            String url = "https://api.apidash.dev/io/img";
            BoundRequestBuilder requestBuilder = asyncHttpClient.prepare("POST", url);

            Map<String, String> params = new HashMap<>() {
                { 
                    put("token", "xyz");
                }
            };

            for (String paramName : params.keySet()) {
                requestBuilder.addBodyPart(new StringPart(
                    paramName, params.get(paramName)
                ));
            }

            Map<String, String> files = new HashMap<>() {
                { 
                    put("imfile", "/Documents/up/1.png");
                }
            };

            for (String paramName : files.keySet()) {
                File file = new File(files.get(paramName));
                requestBuilder.addBodyPart(new FilePart(
                        paramName,
                        file,
                        "application/octet-stream",
                        StandardCharsets.UTF_8,
                        file.getName()
                ));
            }

            Future<Response> whenResponse = requestBuilder.execute();
            Response response = whenResponse.get();
            InputStream is = response.getResponseBodyAsStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
            String respBody = br.lines().collect(Collectors.joining("\n"));
            System.out.println(response.getStatusCode());
            System.out.println(respBody);
        } catch (InterruptedException | ExecutionException | IOException ignored) {

        }
    }
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaAsyncHttpClient, requestModelPost7, "https"),
          expectedCode);
    });

    test('POST 8', () {
      const expectedCode = r'''import org.asynchttpclient.*;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.stream.Collectors;

import java.util.Map;
import java.util.HashMap;
import org.asynchttpclient.request.body.multipart.StringPart;

public class Main {
    public static void main(String[] args) {
        try (AsyncHttpClient asyncHttpClient = Dsl.asyncHttpClient()) {
            String url = "https://api.apidash.dev/io/form";
            BoundRequestBuilder requestBuilder = asyncHttpClient.prepare("POST", url);
            requestBuilder
                .addQueryParam("size", "2")
                .addQueryParam("len", "3");

            Map<String, String> params = new HashMap<>() {
                { 
                    put("text", "API");
                    put("sep", "|");
                    put("times", "3");
                }
            };

            for (String paramName : params.keySet()) {
                requestBuilder.addBodyPart(new StringPart(
                    paramName, params.get(paramName)
                ));
            }

            Future<Response> whenResponse = requestBuilder.execute();
            Response response = whenResponse.get();
            InputStream is = response.getResponseBodyAsStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
            String respBody = br.lines().collect(Collectors.joining("\n"));
            System.out.println(response.getStatusCode());
            System.out.println(respBody);
        } catch (InterruptedException | ExecutionException | IOException ignored) {

        }
    }
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaAsyncHttpClient, requestModelPost8, "https"),
          expectedCode);
    });

    test('POST 9', () {
      const expectedCode = r'''import org.asynchttpclient.*;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.stream.Collectors;

import java.util.Map;
import java.util.HashMap;
import org.asynchttpclient.request.body.multipart.StringPart;
import org.asynchttpclient.request.body.multipart.FilePart;

public class Main {
    public static void main(String[] args) {
        try (AsyncHttpClient asyncHttpClient = Dsl.asyncHttpClient()) {
            String url = "https://api.apidash.dev/io/img";
            BoundRequestBuilder requestBuilder = asyncHttpClient.prepare("POST", url);
            requestBuilder
                .addQueryParam("size", "2")
                .addQueryParam("len", "3");
            requestBuilder
                .addHeader("User-Agent", "Test Agent")
                .addHeader("Keep-Alive", "true");

            Map<String, String> params = new HashMap<>() {
                { 
                    put("token", "xyz");
                }
            };

            for (String paramName : params.keySet()) {
                requestBuilder.addBodyPart(new StringPart(
                    paramName, params.get(paramName)
                ));
            }

            Map<String, String> files = new HashMap<>() {
                { 
                    put("imfile", "/Documents/up/1.png");
                }
            };

            for (String paramName : files.keySet()) {
                File file = new File(files.get(paramName));
                requestBuilder.addBodyPart(new FilePart(
                        paramName,
                        file,
                        "application/octet-stream",
                        StandardCharsets.UTF_8,
                        file.getName()
                ));
            }

            Future<Response> whenResponse = requestBuilder.execute();
            Response response = whenResponse.get();
            InputStream is = response.getResponseBodyAsStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
            String respBody = br.lines().collect(Collectors.joining("\n"));
            System.out.println(response.getStatusCode());
            System.out.println(respBody);
        } catch (InterruptedException | ExecutionException | IOException ignored) {

        }
    }
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaAsyncHttpClient, requestModelPost9, "https"),
          expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT 1', () {
      const expectedCode = r'''import org.asynchttpclient.*;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.stream.Collectors;

public class Main {
    public static void main(String[] args) {
        try (AsyncHttpClient asyncHttpClient = Dsl.asyncHttpClient()) {
            String url = "https://reqres.in/api/users/2";
            String bodyContent = """
{
"name": "morpheus",
"job": "zion resident"
}""";
            BoundRequestBuilder requestBuilder = asyncHttpClient.prepare("PUT", url);
            requestBuilder
                .addHeader("Content-Type", "application/json");
            requestBuilder.setBody(bodyContent);
            Future<Response> whenResponse = requestBuilder.execute();
            Response response = whenResponse.get();
            InputStream is = response.getResponseBodyAsStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
            String respBody = br.lines().collect(Collectors.joining("\n"));
            System.out.println(response.getStatusCode());
            System.out.println(respBody);
        } catch (InterruptedException | ExecutionException | IOException ignored) {

        }
    }
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaAsyncHttpClient, requestModelPut1, "https"),
          expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH 1', () {
      const expectedCode = r'''import org.asynchttpclient.*;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.stream.Collectors;

public class Main {
    public static void main(String[] args) {
        try (AsyncHttpClient asyncHttpClient = Dsl.asyncHttpClient()) {
            String url = "https://reqres.in/api/users/2";
            String bodyContent = """
{
"name": "marfeus",
"job": "accountant"
}""";
            BoundRequestBuilder requestBuilder = asyncHttpClient.prepare("PATCH", url);
            requestBuilder
                .addHeader("Content-Type", "application/json");
            requestBuilder.setBody(bodyContent);
            Future<Response> whenResponse = requestBuilder.execute();
            Response response = whenResponse.get();
            InputStream is = response.getResponseBodyAsStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
            String respBody = br.lines().collect(Collectors.joining("\n"));
            System.out.println(response.getStatusCode());
            System.out.println(respBody);
        } catch (InterruptedException | ExecutionException | IOException ignored) {

        }
    }
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaAsyncHttpClient, requestModelPatch1, "https"),
          expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode = r"""import org.asynchttpclient.*;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.stream.Collectors;

public class Main {
    public static void main(String[] args) {
        try (AsyncHttpClient asyncHttpClient = Dsl.asyncHttpClient()) {
            String url = "https://reqres.in/api/users/2";
            BoundRequestBuilder requestBuilder = asyncHttpClient.prepare("DELETE", url);
            Future<Response> whenResponse = requestBuilder.execute();
            Response response = whenResponse.get();
            InputStream is = response.getResponseBodyAsStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
            String respBody = br.lines().collect(Collectors.joining("\n"));
            System.out.println(response.getStatusCode());
            System.out.println(respBody);
        } catch (InterruptedException | ExecutionException | IOException ignored) {

        }
    }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.javaAsyncHttpClient,
              requestModelDelete1, "https"),
          expectedCode);
    });

    test('DELETE 2', () {
      const expectedCode = r'''import org.asynchttpclient.*;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.stream.Collectors;

public class Main {
    public static void main(String[] args) {
        try (AsyncHttpClient asyncHttpClient = Dsl.asyncHttpClient()) {
            String url = "https://reqres.in/api/users/2";
            String bodyContent = """
{
"name": "marfeus",
"job": "accountant"
}""";
            BoundRequestBuilder requestBuilder = asyncHttpClient.prepare("DELETE", url);
            requestBuilder
                .addHeader("Content-Type", "application/json");
            requestBuilder.setBody(bodyContent);
            Future<Response> whenResponse = requestBuilder.execute();
            Response response = whenResponse.get();
            InputStream is = response.getResponseBodyAsStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
            String respBody = br.lines().collect(Collectors.joining("\n"));
            System.out.println(response.getStatusCode());
            System.out.println(respBody);
        } catch (InterruptedException | ExecutionException | IOException ignored) {

        }
    }
}
''';
      expect(
          codeGen.getCode(CodegenLanguage.javaAsyncHttpClient,
              requestModelDelete2, "https"),
          expectedCode);
    });
  });
}
