import 'package:test/test.dart';
import 'package:apidash/codegen/java/okhttp.dart';
import '../request_models.dart';

void main() {
  final javaOkHttpCodeGen = JavaOkHttpCodeGen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = """
import okhttp3.*;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient();

        String url = "https://api.foss42.com";

        Request request = new Request.Builder()
                .url(url)
                .get()
                .build();

        try {
            okhttp3.Response response = client.newCall(request).execute();

            System.out.println(response.code());
            System.out.println(response.body().string());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
""";
      expect(
          javaOkHttpCodeGen.getCode(requestModelGet1, "https"), expectedCode);
    });

    test('GET 2', () {
      const expectedCode = """
import okhttp3.*;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient();

        HttpUrl url = HttpUrl.parse("https://api.foss42.com/country/data").newBuilder()
                .addQueryParameter("code", "US")
                .build();

        Request request = new Request.Builder()
                .url(url)
                .get()
                .build();

        try {
            okhttp3.Response response = client.newCall(request).execute();

            System.out.println(response.code());
            System.out.println(response.body().string());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
""";
      expect(
          javaOkHttpCodeGen.getCode(requestModelGet2, "https"), expectedCode);
    });

    test('GET 3', () {
      const expectedCode = """
import okhttp3.*;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient();

        HttpUrl url = HttpUrl.parse("https://api.foss42.com/country/data").newBuilder()
                .addQueryParameter("code", "IND")
                .build();

        Request request = new Request.Builder()
                .url(url)
                .get()
                .build();

        try {
            okhttp3.Response response = client.newCall(request).execute();

            System.out.println(response.code());
            System.out.println(response.body().string());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
""";
      expect(
          javaOkHttpCodeGen.getCode(requestModelGet3, "https"), expectedCode);
    });

    test('GET 4', () {
      const expectedCode = """
import okhttp3.*;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient();

        HttpUrl url = HttpUrl.parse("https://api.foss42.com/humanize/social").newBuilder()
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

        try {
            okhttp3.Response response = client.newCall(request).execute();

            System.out.println(response.code());
            System.out.println(response.body().string());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
""";
      expect(
          javaOkHttpCodeGen.getCode(requestModelGet4, "https"), expectedCode);
    });

    test('GET 5', () {
      const expectedCode = """
import okhttp3.*;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient();

        String url = "https://api.github.com/repos/foss42/apidash";

        Request request = new Request.Builder()
                .url(url)
                .addHeader("User-Agent", "Test Agent")
                .get()
                .build();

        try {
            okhttp3.Response response = client.newCall(request).execute();

            System.out.println(response.code());
            System.out.println(response.body().string());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
""";
      expect(
          javaOkHttpCodeGen.getCode(requestModelGet5, "https"), expectedCode);
    });

    test('GET 6', () {
      const expectedCode = """
import okhttp3.*;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient();

        HttpUrl url = HttpUrl.parse("https://api.github.com/repos/foss42/apidash").newBuilder()
                .addQueryParameter("raw", "true")
                .build();

        Request request = new Request.Builder()
                .url(url)
                .addHeader("User-Agent", "Test Agent")
                .get()
                .build();

        try {
            okhttp3.Response response = client.newCall(request).execute();

            System.out.println(response.code());
            System.out.println(response.body().string());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
""";
      expect(
          javaOkHttpCodeGen.getCode(requestModelGet6, "https"), expectedCode);
    });

    test('GET 7', () {
      const expectedCode = """
import okhttp3.*;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient();

        String url = "https://api.foss42.com";

        Request request = new Request.Builder()
                .url(url)
                .get()
                .build();

        try {
            okhttp3.Response response = client.newCall(request).execute();

            System.out.println(response.code());
            System.out.println(response.body().string());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
""";
      expect(
          javaOkHttpCodeGen.getCode(requestModelGet7, "https"), expectedCode);
    });

    test('GET 8', () {
      const expectedCode = """
import okhttp3.*;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient();

        HttpUrl url = HttpUrl.parse("https://api.github.com/repos/foss42/apidash").newBuilder()
                .addQueryParameter("raw", "true")
                .build();

        Request request = new Request.Builder()
                .url(url)
                .addHeader("User-Agent", "Test Agent")
                .get()
                .build();

        try {
            okhttp3.Response response = client.newCall(request).execute();

            System.out.println(response.code());
            System.out.println(response.body().string());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
""";
      expect(
          javaOkHttpCodeGen.getCode(requestModelGet8, "https"), expectedCode);
    });

    test('GET 9', () {
      const expectedCode = """
import okhttp3.*;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient();

        HttpUrl url = HttpUrl.parse("https://api.foss42.com/humanize/social").newBuilder()
                .addQueryParameter("num", "8700000")
                .addQueryParameter("add_space", "true")
                .build();

        Request request = new Request.Builder()
                .url(url)
                .get()
                .build();

        try {
            okhttp3.Response response = client.newCall(request).execute();

            System.out.println(response.code());
            System.out.println(response.body().string());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
""";
      expect(
          javaOkHttpCodeGen.getCode(requestModelGet9, "https"), expectedCode);
    });

    test('GET 10', () {
      const expectedCode = """
import okhttp3.*;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient();

        String url = "https://api.foss42.com/humanize/social";

        Request request = new Request.Builder()
                .url(url)
                .addHeader("User-Agent", "Test Agent")
                .get()
                .build();

        try {
            okhttp3.Response response = client.newCall(request).execute();

            System.out.println(response.code());
            System.out.println(response.body().string());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
""";
      expect(
          javaOkHttpCodeGen.getCode(requestModelGet10, "https"), expectedCode);
    });

    test('GET 11', () {
      const expectedCode = """
import okhttp3.*;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient();

        HttpUrl url = HttpUrl.parse("https://api.foss42.com/humanize/social").newBuilder()
                .addQueryParameter("num", "8700000")
                .addQueryParameter("digits", "3")
                .build();

        Request request = new Request.Builder()
                .url(url)
                .addHeader("User-Agent", "Test Agent")
                .get()
                .build();

        try {
            okhttp3.Response response = client.newCall(request).execute();

            System.out.println(response.code());
            System.out.println(response.body().string());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
""";
      expect(
          javaOkHttpCodeGen.getCode(requestModelGet11, "https"), expectedCode);
    });

    test('GET 12', () {
      const expectedCode = """
import okhttp3.*;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient();

        String url = "https://api.foss42.com/humanize/social";

        Request request = new Request.Builder()
                .url(url)
                .get()
                .build();

        try {
            okhttp3.Response response = client.newCall(request).execute();

            System.out.println(response.code());
            System.out.println(response.body().string());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
""";
      expect(
          javaOkHttpCodeGen.getCode(requestModelGet12, "https"), expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = """
import okhttp3.*;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient();

        String url = "https://api.foss42.com";

        Request request = new Request.Builder()
                .url(url)
                .head()
                .build();

        try {
            okhttp3.Response response = client.newCall(request).execute();

            System.out.println(response.code());
            System.out.println(response.body().string());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
""";
      expect(
          javaOkHttpCodeGen.getCode(requestModelHead1, "https"), expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = """
import okhttp3.*;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient();

        String url = "http://api.foss42.com";

        Request request = new Request.Builder()
                .url(url)
                .head()
                .build();

        try {
            okhttp3.Response response = client.newCall(request).execute();

            System.out.println(response.code());
            System.out.println(response.body().string());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
""";
      expect(
          javaOkHttpCodeGen.getCode(requestModelHead2, "http"), expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = """
import okhttp3.*;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient();

        String url = "https://api.foss42.com/case/lower";

        MediaType mediaType = MediaType.parse("text/plain");

        RequestBody body = RequestBody.create("{\\n\\"text\\": \\"I LOVE Flutter\\"\\n}", mediaType);

        Request request = new Request.Builder()
                .url(url)
                .post(body)
                .build();

        try {
            okhttp3.Response response = client.newCall(request).execute();

            System.out.println(response.code());
            System.out.println(response.body().string());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
""";
      expect(
          javaOkHttpCodeGen.getCode(requestModelPost1, "https"), expectedCode);
    });

    test('POST 2', () {
      const expectedCode = """
import okhttp3.*;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient();

        String url = "https://api.foss42.com/case/lower";

        MediaType mediaType = MediaType.parse("application/json");

        RequestBody body = RequestBody.create("{\\n\\"text\\": \\"I LOVE Flutter\\"\\n}", mediaType);

        Request request = new Request.Builder()
                .url(url)
                .post(body)
                .build();

        try {
            okhttp3.Response response = client.newCall(request).execute();

            System.out.println(response.code());
            System.out.println(response.body().string());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
""";
      expect(
          javaOkHttpCodeGen.getCode(requestModelPost2, "https"), expectedCode);
    });

    test('POST 3', () {
      const expectedCode = """
import okhttp3.*;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient();

        String url = "https://api.foss42.com/case/lower";

        MediaType mediaType = MediaType.parse("application/json");

        RequestBody body = RequestBody.create("{\\n\\"text\\": \\"I LOVE Flutter\\"\\n}", mediaType);

        Request request = new Request.Builder()
                .url(url)
                .addHeader("User-Agent", "Test Agent")
                .post(body)
                .build();

        try {
            okhttp3.Response response = client.newCall(request).execute();

            System.out.println(response.code());
            System.out.println(response.body().string());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
""";
      expect(
          javaOkHttpCodeGen.getCode(requestModelPost3, "https"), expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT 1', () {
      const expectedCode = """
import okhttp3.*;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient();

        String url = "https://reqres.in/api/users/2";

        MediaType mediaType = MediaType.parse("application/json");

        RequestBody body = RequestBody.create("{\\n\\"name\\": \\"morpheus\\",\\n\\"job\\": \\"zion resident\\"\\n}", mediaType);

        Request request = new Request.Builder()
                .url(url)
                .put(body)
                .build();

        try {
            okhttp3.Response response = client.newCall(request).execute();

            System.out.println(response.code());
            System.out.println(response.body().string());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
""";
      expect(
          javaOkHttpCodeGen.getCode(requestModelPut1, "https"), expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH 1', () {
      const expectedCode = """
import okhttp3.*;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient();

        String url = "https://reqres.in/api/users/2";

        MediaType mediaType = MediaType.parse("application/json");

        RequestBody body = RequestBody.create("{\\n\\"name\\": \\"marfeus\\",\\n\\"job\\": \\"accountant\\"\\n}", mediaType);

        Request request = new Request.Builder()
                .url(url)
                .patch(body)
                .build();

        try {
            okhttp3.Response response = client.newCall(request).execute();

            System.out.println(response.code());
            System.out.println(response.body().string());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
""";
      expect(
          javaOkHttpCodeGen.getCode(requestModelPatch1, "https"), expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode = """
import okhttp3.*;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient();

        String url = "https://reqres.in/api/users/2";

        Request request = new Request.Builder()
                .url(url)
                .delete()
                .build();

        try {
            okhttp3.Response response = client.newCall(request).execute();

            System.out.println(response.code());
            System.out.println(response.body().string());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
""";
      expect(
          javaOkHttpCodeGen.getCode(requestModelDelete1, "https"), expectedCode);
    });

    test('DELETE 2', () {
      const expectedCode = """
import okhttp3.*;

public class Main {
    public static void main(String[] args) {
        OkHttpClient client = new OkHttpClient();

        String url = "https://reqres.in/api/users/2";

        MediaType mediaType = MediaType.parse("application/json");

        RequestBody body = RequestBody.create("{\\n\\"name\\": \\"marfeus\\",\\n\\"job\\": \\"accountant\\"\\n}", mediaType);

        Request request = new Request.Builder()
                .url(url)
                .delete(body)
                .build();

        try {
            okhttp3.Response response = client.newCall(request).execute();

            System.out.println(response.code());
            System.out.println(response.body().string());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
""";
      expect(
          javaOkHttpCodeGen.getCode(requestModelDelete2, "https"), expectedCode);
    });
  });

}

// import 'dart:convert';
// import 'package:jinja/jinja.dart' as jj;
// import 'package:apidash/utils/utils.dart' show getValidRequestUri, requestModelToHARJsonRequest, stripUriParams;
// import '../../models/request_model.dart';
// import 'package:apidash/consts.dart';

// class JavaOkHttpCodeGen {
//   final String kTemplateStart = """import okhttp3.*;

// public class Main {
//     public static void main(String[] args) {
//         OkHttpClient client = new OkHttpClient();

// """;

//   final String kTemplateUrl = '''
//         String url = "{{url}}";

// ''';

//   final String kTemplateUrlQuery = '''

//         HttpUrl url = HttpUrl.parse("{{url}}").newBuilder()
// {{params}}        .build();

// ''';

//   String kTemplateRequestBody = '''

//         MediaType mediaType = MediaType.parse("{{contentType}}");

//         RequestBody body = RequestBody.create({{body}}, mediaType);

// ''';

//   final String kStringRequestStart = """

//         Request request = new Request.Builder()
//                 .url(url)
// """;

//   final String kTemplateRequestEnd = """
//                 .{{method}}({{hasBody}})
//                 .build();

//         try {
//             okhttp3.Response response = client.newCall(request).execute();

//             System.out.println(response.code());
//             System.out.println(response.body().string());
//         } catch (IOException e) {
//             e.printStackTrace();
//         }
//     }
// }

// """;
//   String kFormDataBody = '''

//         FormBody.Builder formBuilder = new FormBody.Builder();
// ''';

//   String? getCode(
//     RequestModel requestModel,
//     String defaultUriScheme,
//   ) {
//     try {
//       String result = "";
//       bool hasQuery = false;
//       bool hasBody = false;

//       String url = requestModel.url;
//       if (!url.contains("://") && url.isNotEmpty) {
//         url = "$defaultUriScheme://$url";
//       }

//       var rec = getValidRequestUri(
//         url,
//         requestModel.enabledRequestParams,
//       );
//       Uri? uri = rec.$1;

//       if (uri != null) {
//         String url = stripUriParams(uri);

//         if (uri.hasQuery) {
//           var params = uri.queryParameters;
//           if (params.isNotEmpty) {
//             hasQuery = true;
//             var templateParams = jj.Template(kTemplateUrlQuery);
//             result += templateParams
//                 .render({"url": url, "params": getQueryParams(params)});
//           }
//         }
//         var rM = requestModel.copyWith(url: url);

//       var harJson = requestModelToHARJsonRequest(rM, useEnabled: true);
//         if (!hasQuery) {
//           var templateUrl = jj.Template(kTemplateUrl);
//           result += templateUrl.render({"url": url});
//         }

//         var method = requestModel.method;
//         var requestBody = requestModel.requestBody;
//         if (requestModel.isFormDataRequest && requestModel.formDataMapList.isNotEmpty) {
//           for (var item in requestModel.formDataMapList) {
//             kFormDataBody += """        formBuilder.add("${item["name"]}", "${item["value"]}");\n""";
//           }
//           result += kFormDataBody;
//           result += """\n        RequestBody body = formBuilder.build();\n""";
//         } else if (kMethodsWithBody.contains(method) && requestBody != null) {
//           var contentLength = utf8.encode(requestBody).length;
//           if (contentLength > 0) {
//             hasBody = true;
//             String contentType = requestModel.requestBodyContentType.header;
//             var templateBody = jj.Template(kTemplateRequestBody);
//             result += templateBody
//                 .render({"contentType": contentType, "body": kEncoder.convert(harJson["postData"]["text"])});
//           }
//         }

//         result = kTemplateStart + result;
//         result += kStringRequestStart;

//         var headersList = requestModel.enabledRequestHeaders;
//         if (headersList != null) {
//           var headers = requestModel.enabledHeadersMap;
//           if (headers.isNotEmpty) {
//             result += getHeaders(headers);
//           }
//         }

//         var templateRequestEnd = jj.Template(kTemplateRequestEnd);
//         result += templateRequestEnd.render({
//           "method": method.name.toLowerCase(),
//           "hasBody": (hasBody || requestModel.isFormDataRequest) ? "body" : "",
//         });
//       }
//       return result;
//     } catch (e) {
//       return null;
//     }
//   }

//   String getQueryParams(Map<String, String> params) {
//     String result = "";
//     for (final k in params.keys) {
//       result = """$result                .addQueryParameter("$k", "${params[k]}")\n""";
//     }
//     return result;
//   }

//   String getHeaders(Map<String, String> headers) {
//     String result = "";
//     for (final k in headers.keys) {
//       result = """$result                .addHeader("$k", "${headers[k]}")\n""";
//     }
//     return result;
//   }
// }

// import 'package:apidash/models/models.dart' show NameValueModel, RequestModel;
// import 'package:apidash/consts.dart';

// /// Basic GET request model
// const requestModelGet1 = RequestModel(
//   id: 'get1',
//   url: 'https://api.foss42.com',
//   method: HTTPVerb.get,
// );

// /// GET request model with query params
// const requestModelGet2 = RequestModel(
//   id: 'get2',
//   url: 'https://api.foss42.com/country/data',
//   method: HTTPVerb.get,
//   requestParams: [
//     NameValueModel(name: 'code', value: 'US'),
//   ],
// );

// /// GET request model with override query params
// const requestModelGet3 = RequestModel(
//   id: 'get3',
//   url: 'https://api.foss42.com/country/data?code=US',
//   method: HTTPVerb.get,
//   requestParams: [
//     NameValueModel(name: 'code', value: 'IND'),
//   ],
// );

// /// GET request model with different types of query params
// const requestModelGet4 = RequestModel(
//   id: 'get4',
//   url: 'https://api.foss42.com/humanize/social',
//   method: HTTPVerb.get,
//   requestParams: [
//     NameValueModel(name: 'num', value: '8700000'),
//     NameValueModel(name: 'digits', value: '3'),
//     NameValueModel(name: 'system', value: 'SS'),
//     NameValueModel(name: 'add_space', value: 'true'),
//     NameValueModel(name: 'trailing_zeros', value: 'true'),
//   ],
// );

// /// GET request model with headers
// const requestModelGet5 = RequestModel(
//   id: 'get5',
//   url: 'https://api.github.com/repos/foss42/apidash',
//   method: HTTPVerb.get,
//   requestHeaders: [
//     NameValueModel(name: 'User-Agent', value: 'Test Agent'),
//   ],
// );

// /// GET request model with headers & query params
// const requestModelGet6 = RequestModel(
//   id: 'get6',
//   url: 'https://api.github.com/repos/foss42/apidash',
//   method: HTTPVerb.get,
//   requestHeaders: [
//     NameValueModel(name: 'User-Agent', value: 'Test Agent'),
//   ],
//   requestParams: [
//     NameValueModel(name: 'raw', value: 'true'),
//   ],
// );

// /// GET request model with body
// const requestModelGet7 = RequestModel(
//   id: 'get7',
//   url: 'https://api.foss42.com',
//   method: HTTPVerb.get,
//   requestBodyContentType: ContentType.text,
//   requestBody:
//       'This is a random text which should not be attached with a GET request',
// );

// /// GET request model with empty header & query param name
// const requestModelGet8 = RequestModel(
//   id: 'get8',
//   url: 'https://api.github.com/repos/foss42/apidash',
//   method: HTTPVerb.get,
//   requestHeaders: [
//     NameValueModel(name: 'User-Agent', value: 'Test Agent'),
//     NameValueModel(name: '', value: 'Bearer XYZ'),
//   ],
//   requestParams: [
//     NameValueModel(name: 'raw', value: 'true'),
//     NameValueModel(name: '', value: 'true'),
//   ],
// );

// /// GET request model with some params enabled
// const requestModelGet9 = RequestModel(
//   id: 'get9',
//   url: 'https://api.foss42.com/humanize/social',
//   method: HTTPVerb.get,
//   requestParams: [
//     NameValueModel(name: 'num', value: '8700000'),
//     NameValueModel(name: 'digits', value: '3'),
//     NameValueModel(name: 'system', value: 'SS'),
//     NameValueModel(name: 'add_space', value: 'true'),
//   ],
//   isParamEnabledList: [
//     true,
//     false,
//     false,
//     true,
//   ],
// );

// /// GET Request model with some headers enabled
// const requestModelGet10 = RequestModel(
//   id: 'get10',
//   url: 'https://api.foss42.com/humanize/social',
//   method: HTTPVerb.get,
//   requestHeaders: [
//     NameValueModel(name: 'User-Agent', value: 'Test Agent'),
//     NameValueModel(name: 'Content-Type', value: 'application/json'),
//   ],
//   isHeaderEnabledList: [
//     true,
//     false,
//   ],
// );

// /// GET Request model with some headers & URL parameters enabled
// const requestModelGet11 = RequestModel(
//   id: 'get11',
//   url: 'https://api.foss42.com/humanize/social',
//   method: HTTPVerb.get,
//   requestParams: [
//     NameValueModel(name: 'num', value: '8700000'),
//     NameValueModel(name: 'digits', value: '3'),
//     NameValueModel(name: 'system', value: 'SS'),
//     NameValueModel(name: 'add_space', value: 'true'),
//   ],
//   requestHeaders: [
//     NameValueModel(name: 'User-Agent', value: 'Test Agent'),
//     NameValueModel(name: 'Content-Type', value: 'application/json'),
//   ],
//   isParamEnabledList: [
//     true,
//     true,
//     false,
//     false,
//   ],
//   isHeaderEnabledList: [
//     true,
//     false,
//   ],
// );

// /// Request model with all headers & URL parameters disabled
// const requestModelGet12 = RequestModel(
//   id: 'get12',
//   url: 'https://api.foss42.com/humanize/social',
//   method: HTTPVerb.get,
//   requestParams: [
//     NameValueModel(name: 'num', value: '8700000'),
//     NameValueModel(name: 'digits', value: '3'),
//     NameValueModel(name: 'system', value: 'SS'),
//     NameValueModel(name: 'add_space', value: 'true'),
//   ],
//   requestHeaders: [
//     NameValueModel(name: 'User-Agent', value: 'Test Agent'),
//     NameValueModel(name: 'Content-Type', value: 'application/json'),
//   ],
//   isParamEnabledList: [
//     false,
//     false,
//     false,
//     false,
//   ],
//   isHeaderEnabledList: [
//     false,
//     false,
//   ],
// );

// /// Basic HEAD request model
// const requestModelHead1 = RequestModel(
//   id: 'head1',
//   url: 'https://api.foss42.com',
//   method: HTTPVerb.head,
// );

// /// Without URI Scheme (pass default as http)
// const requestModelHead2 = RequestModel(
//   id: 'head2',
//   url: 'api.foss42.com',
//   method: HTTPVerb.head,
// );

// /// Basic POST request model (txt body)
// const requestModelPost1 = RequestModel(
//     id: 'post1',
//     url: 'https://api.foss42.com/case/lower',
//     method: HTTPVerb.post,
//     requestBody: r"""{
// "text": "I LOVE Flutter"
// }""",
//     requestBodyContentType: ContentType.text);

// /// POST request model with JSON body
// const requestModelPost2 = RequestModel(
//   id: 'post2',
//   url: 'https://api.foss42.com/case/lower',
//   method: HTTPVerb.post,
//   requestBody: r"""{
// "text": "I LOVE Flutter"
// }""",
// );

// /// POST request model with headers
// const requestModelPost3 = RequestModel(
//   id: 'post3',
//   url: 'https://api.foss42.com/case/lower',
//   method: HTTPVerb.post,
//   requestBody: r"""{
// "text": "I LOVE Flutter"
// }""",
//   requestBodyContentType: ContentType.json,
//   requestHeaders: [
//     NameValueModel(name: 'User-Agent', value: 'Test Agent'),
//   ],
// );

// /// PUT request model
// const requestModelPut1 = RequestModel(
//   id: 'put1',
//   url: 'https://reqres.in/api/users/2',
//   method: HTTPVerb.put,
//   requestBody: r"""{
// "name": "morpheus",
// "job": "zion resident"
// }""",
//   requestBodyContentType: ContentType.json,
// );

// /// PATCH request model
// const requestModelPatch1 = RequestModel(
//   id: 'patch1',
//   url: 'https://reqres.in/api/users/2',
//   method: HTTPVerb.patch,
//   requestBody: r"""{
// "name": "marfeus",
// "job": "accountant"
// }""",
//   requestBodyContentType: ContentType.json,
// );

// /// Basic DELETE request model
// const requestModelDelete1 = RequestModel(
//   id: 'delete1',
//   url: 'https://reqres.in/api/users/2',
//   method: HTTPVerb.delete,
// );

// /// Basic DELETE with body
// const requestModelDelete2 = RequestModel(
//   id: 'delete2',
//   url: 'https://reqres.in/api/users/2',
//   method: HTTPVerb.delete,
//   requestBody: r"""{
// "name": "marfeus",
// "job": "accountant"
// }""",
//   requestBodyContentType: ContentType.json,
// );
