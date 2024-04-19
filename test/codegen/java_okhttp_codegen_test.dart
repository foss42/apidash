import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:test/test.dart';
import '../models/request_models.dart';

void main() {
  final codeGen = Codegen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient().newBuilder().build();

        String url = "https://api.apidash.dev";

        Request request = new Request.Builder()
            .url(url)
            .get()
            .build();

        try (Response response = client.newCall(request).execute()) {
            System.out.println(response.code());
            if (response.body() != null) {
                System.out.println(response.body().string());
            }
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaOkHttp, requestModelGet1, "https"),
          expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r"""import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.HttpUrl;

import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient().newBuilder().build();

        HttpUrl url = HttpUrl.parse("https://api.apidash.dev/country/data").newBuilder()
            .addQueryParameter("code", "US")
            .build();

        Request request = new Request.Builder()
            .url(url)
            .get()
            .build();

        try (Response response = client.newCall(request).execute()) {
            System.out.println(response.code());
            if (response.body() != null) {
                System.out.println(response.body().string());
            }
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaOkHttp, requestModelGet2, "https"),
          expectedCode);
    });

    test('GET 3', () {
      const expectedCode = r"""import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.HttpUrl;

import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient().newBuilder().build();

        HttpUrl url = HttpUrl.parse("https://api.apidash.dev/country/data").newBuilder()
            .addQueryParameter("code", "IND")
            .build();

        Request request = new Request.Builder()
            .url(url)
            .get()
            .build();

        try (Response response = client.newCall(request).execute()) {
            System.out.println(response.code());
            if (response.body() != null) {
                System.out.println(response.body().string());
            }
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaOkHttp, requestModelGet3, "https"),
          expectedCode);
    });

    test('GET 4', () {
      const expectedCode = r"""import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.HttpUrl;

import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient().newBuilder().build();

        HttpUrl url = HttpUrl.parse("https://api.apidash.dev/humanize/social").newBuilder()
            .addQueryParameter("num", "8700000")
            .addQueryParameter("digits", "3")
            .addQueryParameter("system", "SS")
            .addQueryParameter("add_space", "true")
            .addQueryParameter("trailing_zeros", "true")
            .build();

        Request request = new Request.Builder()
            .url(url)
            .get()
            .build();

        try (Response response = client.newCall(request).execute()) {
            System.out.println(response.code());
            if (response.body() != null) {
                System.out.println(response.body().string());
            }
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaOkHttp, requestModelGet4, "https"),
          expectedCode);
    });

    test('GET 5', () {
      const expectedCode = r"""import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient().newBuilder().build();

        String url = "https://api.github.com/repos/foss42/apidash";

        Request request = new Request.Builder()
            .url(url)
            .addHeader("User-Agent", "Test Agent")
            .get()
            .build();

        try (Response response = client.newCall(request).execute()) {
            System.out.println(response.code());
            if (response.body() != null) {
                System.out.println(response.body().string());
            }
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaOkHttp, requestModelGet5, "https"),
          expectedCode);
    });

    test('GET 6', () {
      const expectedCode = r"""import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.HttpUrl;

import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient().newBuilder().build();

        HttpUrl url = HttpUrl.parse("https://api.github.com/repos/foss42/apidash").newBuilder()
            .addQueryParameter("raw", "true")
            .build();

        Request request = new Request.Builder()
            .url(url)
            .addHeader("User-Agent", "Test Agent")
            .get()
            .build();

        try (Response response = client.newCall(request).execute()) {
            System.out.println(response.code());
            if (response.body() != null) {
                System.out.println(response.body().string());
            }
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaOkHttp, requestModelGet6, "https"),
          expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r"""import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient().newBuilder().build();

        String url = "https://api.apidash.dev";

        Request request = new Request.Builder()
            .url(url)
            .get()
            .build();

        try (Response response = client.newCall(request).execute()) {
            System.out.println(response.code());
            if (response.body() != null) {
                System.out.println(response.body().string());
            }
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaOkHttp, requestModelGet7, "https"),
          expectedCode);
    });

    test('GET 8', () {
      const expectedCode = r"""import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.HttpUrl;

import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient().newBuilder().build();

        HttpUrl url = HttpUrl.parse("https://api.github.com/repos/foss42/apidash").newBuilder()
            .addQueryParameter("raw", "true")
            .build();

        Request request = new Request.Builder()
            .url(url)
            .addHeader("User-Agent", "Test Agent")
            .get()
            .build();

        try (Response response = client.newCall(request).execute()) {
            System.out.println(response.code());
            if (response.body() != null) {
                System.out.println(response.body().string());
            }
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaOkHttp, requestModelGet8, "https"),
          expectedCode);
    });

    test('GET 9', () {
      const expectedCode = r"""import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.HttpUrl;

import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient().newBuilder().build();

        HttpUrl url = HttpUrl.parse("https://api.apidash.dev/humanize/social").newBuilder()
            .addQueryParameter("num", "8700000")
            .addQueryParameter("add_space", "true")
            .build();

        Request request = new Request.Builder()
            .url(url)
            .get()
            .build();

        try (Response response = client.newCall(request).execute()) {
            System.out.println(response.code());
            if (response.body() != null) {
                System.out.println(response.body().string());
            }
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaOkHttp, requestModelGet9, "https"),
          expectedCode);
    });

    test('GET 10', () {
      const expectedCode = r"""import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient().newBuilder().build();

        String url = "https://api.apidash.dev/humanize/social";

        Request request = new Request.Builder()
            .url(url)
            .addHeader("User-Agent", "Test Agent")
            .get()
            .build();

        try (Response response = client.newCall(request).execute()) {
            System.out.println(response.code());
            if (response.body() != null) {
                System.out.println(response.body().string());
            }
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaOkHttp, requestModelGet10, "https"),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode = r"""import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.HttpUrl;

import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient().newBuilder().build();

        HttpUrl url = HttpUrl.parse("https://api.apidash.dev/humanize/social").newBuilder()
            .addQueryParameter("num", "8700000")
            .addQueryParameter("digits", "3")
            .build();

        Request request = new Request.Builder()
            .url(url)
            .addHeader("User-Agent", "Test Agent")
            .get()
            .build();

        try (Response response = client.newCall(request).execute()) {
            System.out.println(response.code());
            if (response.body() != null) {
                System.out.println(response.body().string());
            }
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaOkHttp, requestModelGet11, "https"),
          expectedCode);
    });

    test('GET 12', () {
      const expectedCode = r"""import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient().newBuilder().build();

        String url = "https://api.apidash.dev/humanize/social";

        Request request = new Request.Builder()
            .url(url)
            .get()
            .build();

        try (Response response = client.newCall(request).execute()) {
            System.out.println(response.code());
            if (response.body() != null) {
                System.out.println(response.body().string());
            }
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaOkHttp, requestModelGet12, "https"),
          expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient().newBuilder().build();

        String url = "https://api.apidash.dev";

        Request request = new Request.Builder()
            .url(url)
            .head()
            .build();

        try (Response response = client.newCall(request).execute()) {
            System.out.println(response.code());
            if (response.body() != null) {
                System.out.println(response.body().string());
            }
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaOkHttp, requestModelHead1, "https"),
          expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient().newBuilder().build();

        String url = "http://api.apidash.dev";

        Request request = new Request.Builder()
            .url(url)
            .head()
            .build();

        try (Response response = client.newCall(request).execute()) {
            System.out.println(response.code());
            if (response.body() != null) {
                System.out.println(response.body().string());
            }
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaOkHttp, requestModelHead2, "http"),
          expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r'''import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.RequestBody;
import okhttp3.MediaType;

import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient().newBuilder().build();

        String url = "https://api.apidash.dev/case/lower";

        MediaType mediaType = MediaType.parse("text/plain");

        RequestBody body = RequestBody.create("{\n\"text\": \"I LOVE Flutter\"\n}", mediaType);

        Request request = new Request.Builder()
            .url(url)
            .post(body)
            .build();

        try (Response response = client.newCall(request).execute()) {
            System.out.println(response.code());
            if (response.body() != null) {
                System.out.println(response.body().string());
            }
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaOkHttp, requestModelPost1, "https"),
          expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r'''import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.RequestBody;
import okhttp3.MediaType;

import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient().newBuilder().build();

        String url = "https://api.apidash.dev/case/lower";

        MediaType mediaType = MediaType.parse("application/json");

        RequestBody body = RequestBody.create("{\n\"text\": \"I LOVE Flutter\",\n\"flag\": null,\n\"male\": true,\n\"female\": false,\n\"no\": 1.2,\n\"arr\": [\"null\", \"true\", \"false\", null]\n}", mediaType);

        Request request = new Request.Builder()
            .url(url)
            .post(body)
            .build();

        try (Response response = client.newCall(request).execute()) {
            System.out.println(response.code());
            if (response.body() != null) {
                System.out.println(response.body().string());
            }
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaOkHttp, requestModelPost2, "https"),
          expectedCode);
    });

    test('POST 3', () {
      const expectedCode = r'''import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.RequestBody;
import okhttp3.MediaType;

import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient().newBuilder().build();

        String url = "https://api.apidash.dev/case/lower";

        MediaType mediaType = MediaType.parse("application/json");

        RequestBody body = RequestBody.create("{\n\"text\": \"I LOVE Flutter\"\n}", mediaType);

        Request request = new Request.Builder()
            .url(url)
            .addHeader("User-Agent", "Test Agent")
            .post(body)
            .build();

        try (Response response = client.newCall(request).execute()) {
            System.out.println(response.code());
            if (response.body() != null) {
                System.out.println(response.body().string());
            }
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaOkHttp, requestModelPost3, "https"),
          expectedCode);
    });

    test('POST 4', () {
      const expectedCode = r'''import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.RequestBody;
import okhttp3.MultipartBody;

import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient().newBuilder().build();

        String url = "https://api.apidash.dev/io/form";
        RequestBody body = new MultipartBody.Builder().setType(MultipartBody.FORM)
            .addFormDataPart("text","API")
            .addFormDataPart("sep","|")
            .addFormDataPart("times","3")
            .build();

        Request request = new Request.Builder()
            .url(url)
            .post(body)
            .build();

        try (Response response = client.newCall(request).execute()) {
            System.out.println(response.code());
            if (response.body() != null) {
                System.out.println(response.body().string());
            }
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaOkHttp, requestModelPost4, "https"),
          expectedCode);
    });

    test('POST 5', () {
      const expectedCode = r'''import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.RequestBody;
import okhttp3.MultipartBody;

import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient().newBuilder().build();

        String url = "https://api.apidash.dev/io/form";
        RequestBody body = new MultipartBody.Builder().setType(MultipartBody.FORM)
            .addFormDataPart("text","API")
            .addFormDataPart("sep","|")
            .addFormDataPart("times","3")
            .build();

        Request request = new Request.Builder()
            .url(url)
            .addHeader("User-Agent", "Test Agent")
            .post(body)
            .build();

        try (Response response = client.newCall(request).execute()) {
            System.out.println(response.code());
            if (response.body() != null) {
                System.out.println(response.body().string());
            }
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaOkHttp, requestModelPost5, "https"),
          expectedCode);
    });

    test('POST 6', () {
      const expectedCode = r'''import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.RequestBody;
import okhttp3.MultipartBody;

import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient().newBuilder().build();

        String url = "https://api.apidash.dev/io/img";
        RequestBody body = new MultipartBody.Builder().setType(MultipartBody.FORM)
            .addFormDataPart("token","xyz")
            .addFormDataPart("imfile",null,RequestBody.create(MediaType.parse("application/octet-stream"),new File("/Documents/up/1.png")))
            .build();

        Request request = new Request.Builder()
            .url(url)
            .post(body)
            .build();

        try (Response response = client.newCall(request).execute()) {
            System.out.println(response.code());
            if (response.body() != null) {
                System.out.println(response.body().string());
            }
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaOkHttp, requestModelPost6, "https"),
          expectedCode);
    });

    test('POST 7', () {
      const expectedCode = r'''import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.RequestBody;
import okhttp3.MultipartBody;

import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient().newBuilder().build();

        String url = "https://api.apidash.dev/io/img";
        RequestBody body = new MultipartBody.Builder().setType(MultipartBody.FORM)
            .addFormDataPart("token","xyz")
            .addFormDataPart("imfile",null,RequestBody.create(MediaType.parse("application/octet-stream"),new File("/Documents/up/1.png")))
            .build();

        Request request = new Request.Builder()
            .url(url)
            .post(body)
            .build();

        try (Response response = client.newCall(request).execute()) {
            System.out.println(response.code());
            if (response.body() != null) {
                System.out.println(response.body().string());
            }
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaOkHttp, requestModelPost7, "https"),
          expectedCode);
    });

    test('POST 8', () {
      const expectedCode = r'''import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.HttpUrl;
import okhttp3.RequestBody;
import okhttp3.MultipartBody;

import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient().newBuilder().build();

        HttpUrl url = HttpUrl.parse("https://api.apidash.dev/io/form").newBuilder()
            .addQueryParameter("size", "2")
            .addQueryParameter("len", "3")
            .build();
        RequestBody body = new MultipartBody.Builder().setType(MultipartBody.FORM)
            .addFormDataPart("text","API")
            .addFormDataPart("sep","|")
            .addFormDataPart("times","3")
            .build();

        Request request = new Request.Builder()
            .url(url)
            .post(body)
            .build();

        try (Response response = client.newCall(request).execute()) {
            System.out.println(response.code());
            if (response.body() != null) {
                System.out.println(response.body().string());
            }
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaOkHttp, requestModelPost8, "https"),
          expectedCode);
    });

    test('POST 9', () {
      const expectedCode = r'''import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.HttpUrl;
import okhttp3.RequestBody;
import okhttp3.MultipartBody;

import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient().newBuilder().build();

        HttpUrl url = HttpUrl.parse("https://api.apidash.dev/io/img").newBuilder()
            .addQueryParameter("size", "2")
            .addQueryParameter("len", "3")
            .build();
        RequestBody body = new MultipartBody.Builder().setType(MultipartBody.FORM)
            .addFormDataPart("token","xyz")
            .addFormDataPart("imfile",null,RequestBody.create(MediaType.parse("application/octet-stream"),new File("/Documents/up/1.png")))
            .build();

        Request request = new Request.Builder()
            .url(url)
            .addHeader("User-Agent", "Test Agent")
            .addHeader("Keep-Alive", "true")
            .post(body)
            .build();

        try (Response response = client.newCall(request).execute()) {
            System.out.println(response.code());
            if (response.body() != null) {
                System.out.println(response.body().string());
            }
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaOkHttp, requestModelPost9, "https"),
          expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT 1', () {
      const expectedCode = r'''import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.RequestBody;
import okhttp3.MediaType;

import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient().newBuilder().build();

        String url = "https://reqres.in/api/users/2";

        MediaType mediaType = MediaType.parse("application/json");

        RequestBody body = RequestBody.create("{\n\"name\": \"morpheus\",\n\"job\": \"zion resident\"\n}", mediaType);

        Request request = new Request.Builder()
            .url(url)
            .put(body)
            .build();

        try (Response response = client.newCall(request).execute()) {
            System.out.println(response.code());
            if (response.body() != null) {
                System.out.println(response.body().string());
            }
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaOkHttp, requestModelPut1, "https"),
          expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH 1', () {
      const expectedCode = r'''import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.RequestBody;
import okhttp3.MediaType;

import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient().newBuilder().build();

        String url = "https://reqres.in/api/users/2";

        MediaType mediaType = MediaType.parse("application/json");

        RequestBody body = RequestBody.create("{\n\"name\": \"marfeus\",\n\"job\": \"accountant\"\n}", mediaType);

        Request request = new Request.Builder()
            .url(url)
            .patch(body)
            .build();

        try (Response response = client.newCall(request).execute()) {
            System.out.println(response.code());
            if (response.body() != null) {
                System.out.println(response.body().string());
            }
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaOkHttp, requestModelPatch1, "https"),
          expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode = r"""import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient().newBuilder().build();

        String url = "https://reqres.in/api/users/2";

        Request request = new Request.Builder()
            .url(url)
            .delete()
            .build();

        try (Response response = client.newCall(request).execute()) {
            System.out.println(response.code());
            if (response.body() != null) {
                System.out.println(response.body().string());
            }
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.javaOkHttp, requestModelDelete1, "https"),
          expectedCode);
    });

    test('DELETE 2', () {
      const expectedCode = r'''import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.RequestBody;
import okhttp3.MediaType;

import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient().newBuilder().build();

        String url = "https://reqres.in/api/users/2";

        MediaType mediaType = MediaType.parse("application/json");

        RequestBody body = RequestBody.create("{\n\"name\": \"marfeus\",\n\"job\": \"accountant\"\n}", mediaType);

        Request request = new Request.Builder()
            .url(url)
            .delete(body)
            .build();

        try (Response response = client.newCall(request).execute()) {
            System.out.println(response.code());
            if (response.body() != null) {
                System.out.println(response.body().string());
            }
        } catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.javaOkHttp, requestModelDelete2, "https"),
          expectedCode);
    });
  });
}
