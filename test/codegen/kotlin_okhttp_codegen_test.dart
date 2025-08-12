import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';
import '../models/request_models.dart';

void main() {
  final codeGen = Codegen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""import okhttp3.OkHttpClient
import okhttp3.Request

fun main() {
    val client = OkHttpClient()

    val url = "https://api.apidash.dev"

    val request = Request.Builder()
        .url(url)
        .get()
        .build()

    val response = client.newCall(request).execute()

    println(response.code)
    println(response.body?.string())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.kotlinOkHttp,
            requestModelGet1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r"""import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.HttpUrl.Companion.toHttpUrl

fun main() {
    val client = OkHttpClient()

    val url = "https://api.apidash.dev/country/data".toHttpUrl().newBuilder()
            .addQueryParameter("code", "US")
            .build()

    val request = Request.Builder()
        .url(url)
        .get()
        .build()

    val response = client.newCall(request).execute()

    println(response.code)
    println(response.body?.string())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.kotlinOkHttp,
            requestModelGet2,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 3', () {
      const expectedCode = r"""import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.HttpUrl.Companion.toHttpUrl

fun main() {
    val client = OkHttpClient()

    val url = "https://api.apidash.dev/country/data".toHttpUrl().newBuilder()
            .addQueryParameter("code", "IND")
            .addQueryParameter("code", "US")
            .build()

    val request = Request.Builder()
        .url(url)
        .get()
        .build()

    val response = client.newCall(request).execute()

    println(response.code)
    println(response.body?.string())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.kotlinOkHttp,
            requestModelGet3,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 4', () {
      const expectedCode = r"""import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.HttpUrl.Companion.toHttpUrl

fun main() {
    val client = OkHttpClient()

    val url = "https://api.apidash.dev/humanize/social".toHttpUrl().newBuilder()
            .addQueryParameter("num", "8700000")
            .addQueryParameter("digits", "3")
            .addQueryParameter("system", "SS")
            .addQueryParameter("add_space", "true")
            .addQueryParameter("trailing_zeros", "true")
            .build()

    val request = Request.Builder()
        .url(url)
        .get()
        .build()

    val response = client.newCall(request).execute()

    println(response.code)
    println(response.body?.string())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.kotlinOkHttp,
            requestModelGet4,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 5', () {
      const expectedCode = r"""import okhttp3.OkHttpClient
import okhttp3.Request

fun main() {
    val client = OkHttpClient()

    val url = "https://api.github.com/repos/foss42/apidash"

    val request = Request.Builder()
        .url(url)
        .addHeader("User-Agent", "Test Agent")
        .get()
        .build()

    val response = client.newCall(request).execute()

    println(response.code)
    println(response.body?.string())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.kotlinOkHttp,
            requestModelGet5,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 6', () {
      const expectedCode = r"""import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.HttpUrl.Companion.toHttpUrl

fun main() {
    val client = OkHttpClient()

    val url = "https://api.github.com/repos/foss42/apidash".toHttpUrl().newBuilder()
            .addQueryParameter("raw", "true")
            .build()

    val request = Request.Builder()
        .url(url)
        .addHeader("User-Agent", "Test Agent")
        .get()
        .build()

    val response = client.newCall(request).execute()

    println(response.code)
    println(response.body?.string())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.kotlinOkHttp,
            requestModelGet6,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r"""import okhttp3.OkHttpClient
import okhttp3.Request

fun main() {
    val client = OkHttpClient()

    val url = "https://api.apidash.dev"

    val request = Request.Builder()
        .url(url)
        .get()
        .build()

    val response = client.newCall(request).execute()

    println(response.code)
    println(response.body?.string())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.kotlinOkHttp,
            requestModelGet7,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 8', () {
      const expectedCode = r"""import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.HttpUrl.Companion.toHttpUrl

fun main() {
    val client = OkHttpClient()

    val url = "https://api.github.com/repos/foss42/apidash".toHttpUrl().newBuilder()
            .addQueryParameter("raw", "true")
            .build()

    val request = Request.Builder()
        .url(url)
        .addHeader("User-Agent", "Test Agent")
        .get()
        .build()

    val response = client.newCall(request).execute()

    println(response.code)
    println(response.body?.string())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.kotlinOkHttp,
            requestModelGet8,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 9', () {
      const expectedCode = r"""import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.HttpUrl.Companion.toHttpUrl

fun main() {
    val client = OkHttpClient()

    val url = "https://api.apidash.dev/humanize/social".toHttpUrl().newBuilder()
            .addQueryParameter("num", "8700000")
            .addQueryParameter("add_space", "true")
            .build()

    val request = Request.Builder()
        .url(url)
        .get()
        .build()

    val response = client.newCall(request).execute()

    println(response.code)
    println(response.body?.string())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.kotlinOkHttp,
            requestModelGet9,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 10', () {
      const expectedCode = r"""import okhttp3.OkHttpClient
import okhttp3.Request

fun main() {
    val client = OkHttpClient()

    val url = "https://api.apidash.dev/humanize/social"

    val request = Request.Builder()
        .url(url)
        .addHeader("User-Agent", "Test Agent")
        .get()
        .build()

    val response = client.newCall(request).execute()

    println(response.code)
    println(response.body?.string())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.kotlinOkHttp,
            requestModelGet10,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode = r"""import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.HttpUrl.Companion.toHttpUrl

fun main() {
    val client = OkHttpClient()

    val url = "https://api.apidash.dev/humanize/social".toHttpUrl().newBuilder()
            .addQueryParameter("num", "8700000")
            .addQueryParameter("digits", "3")
            .build()

    val request = Request.Builder()
        .url(url)
        .addHeader("User-Agent", "Test Agent")
        .get()
        .build()

    val response = client.newCall(request).execute()

    println(response.code)
    println(response.body?.string())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.kotlinOkHttp,
            requestModelGet11,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 12', () {
      const expectedCode = r"""import okhttp3.OkHttpClient
import okhttp3.Request

fun main() {
    val client = OkHttpClient()

    val url = "https://api.apidash.dev/humanize/social"

    val request = Request.Builder()
        .url(url)
        .get()
        .build()

    val response = client.newCall(request).execute()

    println(response.code)
    println(response.body?.string())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.kotlinOkHttp,
            requestModelGet12,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""import okhttp3.OkHttpClient
import okhttp3.Request

fun main() {
    val client = OkHttpClient()

    val url = "https://api.apidash.dev"

    val request = Request.Builder()
        .url(url)
        .head()
        .build()

    val response = client.newCall(request).execute()

    println(response.code)
    println(response.body?.string())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.kotlinOkHttp,
            requestModelHead1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""import okhttp3.OkHttpClient
import okhttp3.Request

fun main() {
    val client = OkHttpClient()

    val url = "http://api.apidash.dev"

    val request = Request.Builder()
        .url(url)
        .head()
        .build()

    val response = client.newCall(request).execute()

    println(response.code)
    println(response.body?.string())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.kotlinOkHttp,
            requestModelHead2,
            SupportedUriSchemes.http,
          ),
          expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r'''import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import okhttp3.MediaType.Companion.toMediaType

fun main() {
    val client = OkHttpClient()

    val url = "https://api.apidash.dev/case/lower"

    val mediaType = "text/plain".toMediaType()

    val body = """{
"text": "I LOVE Flutter"
}""".toRequestBody(mediaType)

    val request = Request.Builder()
        .url(url)
        .post(body)
        .build()

    val response = client.newCall(request).execute()

    println(response.code)
    println(response.body?.string())
}
''';
      expect(
          codeGen.getCode(
            CodegenLanguage.kotlinOkHttp,
            requestModelPost1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r'''import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import okhttp3.MediaType.Companion.toMediaType

fun main() {
    val client = OkHttpClient()

    val url = "https://api.apidash.dev/case/lower"

    val mediaType = "application/json".toMediaType()

    val body = """{
"text": "I LOVE Flutter",
"flag": null,
"male": true,
"female": false,
"no": 1.2,
"arr": ["null", "true", "false", null]
}""".toRequestBody(mediaType)

    val request = Request.Builder()
        .url(url)
        .post(body)
        .build()

    val response = client.newCall(request).execute()

    println(response.code)
    println(response.body?.string())
}
''';
      expect(
          codeGen.getCode(
            CodegenLanguage.kotlinOkHttp,
            requestModelPost2,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('POST 3', () {
      const expectedCode = r'''import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import okhttp3.MediaType.Companion.toMediaType

fun main() {
    val client = OkHttpClient()

    val url = "https://api.apidash.dev/case/lower"

    val mediaType = "application/json".toMediaType()

    val body = """{
"text": "I LOVE Flutter"
}""".toRequestBody(mediaType)

    val request = Request.Builder()
        .url(url)
        .addHeader("User-Agent", "Test Agent")
        .post(body)
        .build()

    val response = client.newCall(request).execute()

    println(response.code)
    println(response.body?.string())
}
''';
      expect(
          codeGen.getCode(
            CodegenLanguage.kotlinOkHttp,
            requestModelPost3,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST 4', () {
      const expectedCode = r'''import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.MultipartBody

fun main() {
    val client = OkHttpClient()

    val url = "https://api.apidash.dev/io/form"
    val body = MultipartBody.Builder().setType(MultipartBody.FORM).addFormDataPart("text","API")
          .addFormDataPart("sep","|")
          .addFormDataPart("times","3")
          .build()
    val request = Request.Builder()
        .url(url)
        .post(body)
        .build()

    val response = client.newCall(request).execute()

    println(response.code)
    println(response.body?.string())
}
''';
      expect(
          codeGen.getCode(
            CodegenLanguage.kotlinOkHttp,
            requestModelPost4,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('POST 5', () {
      const expectedCode = r'''import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.MultipartBody

fun main() {
    val client = OkHttpClient()

    val url = "https://api.apidash.dev/io/form"
    val body = MultipartBody.Builder().setType(MultipartBody.FORM).addFormDataPart("text","API")
          .addFormDataPart("sep","|")
          .addFormDataPart("times","3")
          .build()
    val request = Request.Builder()
        .url(url)
        .addHeader("User-Agent", "Test Agent")
        .post(body)
        .build()

    val response = client.newCall(request).execute()

    println(response.code)
    println(response.body?.string())
}
''';
      expect(
          codeGen.getCode(
            CodegenLanguage.kotlinOkHttp,
            requestModelPost5,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST 6', () {
      const expectedCode = r'''import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.MultipartBody
import java.io.File
import okhttp3.RequestBody.Companion.asRequestBody
import okhttp3.MediaType.Companion.toMediaType

fun main() {
    val client = OkHttpClient()

    val url = "https://api.apidash.dev/io/img"
    val body = MultipartBody.Builder().setType(MultipartBody.FORM).addFormDataPart("token","xyz")
          
          .addFormDataPart("imfile",File("Documents/up/1.png").name,File("Documents/up/1.png").asRequestBody("application/octet-stream".toMediaType()))
          .build()
    val request = Request.Builder()
        .url(url)
        .post(body)
        .build()

    val response = client.newCall(request).execute()

    println(response.code)
    println(response.body?.string())
}
''';
      expect(
          codeGen.getCode(
            CodegenLanguage.kotlinOkHttp,
            requestModelPost6,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST 7', () {
      const expectedCode = r'''import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.MultipartBody
import java.io.File
import okhttp3.RequestBody.Companion.asRequestBody
import okhttp3.MediaType.Companion.toMediaType

fun main() {
    val client = OkHttpClient()

    val url = "https://api.apidash.dev/io/img"
    val body = MultipartBody.Builder().setType(MultipartBody.FORM).addFormDataPart("token","xyz")
          
          .addFormDataPart("imfile",File("Documents/up/1.png").name,File("Documents/up/1.png").asRequestBody("application/octet-stream".toMediaType()))
          .build()
    val request = Request.Builder()
        .url(url)
        .post(body)
        .build()

    val response = client.newCall(request).execute()

    println(response.code)
    println(response.body?.string())
}
''';
      expect(
          codeGen.getCode(
            CodegenLanguage.kotlinOkHttp,
            requestModelPost7,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST 8', () {
      const expectedCode = r'''import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.HttpUrl.Companion.toHttpUrl
import okhttp3.MultipartBody

fun main() {
    val client = OkHttpClient()

    val url = "https://api.apidash.dev/io/form".toHttpUrl().newBuilder()
            .addQueryParameter("size", "2")
            .addQueryParameter("len", "3")
            .build()
    val body = MultipartBody.Builder().setType(MultipartBody.FORM).addFormDataPart("text","API")
          .addFormDataPart("sep","|")
          .addFormDataPart("times","3")
          .build()
    val request = Request.Builder()
        .url(url)
        .post(body)
        .build()

    val response = client.newCall(request).execute()

    println(response.code)
    println(response.body?.string())
}
''';
      expect(
          codeGen.getCode(
            CodegenLanguage.kotlinOkHttp,
            requestModelPost8,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST 9', () {
      const expectedCode = r'''import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.HttpUrl.Companion.toHttpUrl
import okhttp3.MultipartBody
import java.io.File
import okhttp3.RequestBody.Companion.asRequestBody
import okhttp3.MediaType.Companion.toMediaType

fun main() {
    val client = OkHttpClient()

    val url = "https://api.apidash.dev/io/img".toHttpUrl().newBuilder()
            .addQueryParameter("size", "2")
            .addQueryParameter("len", "3")
            .build()
    val body = MultipartBody.Builder().setType(MultipartBody.FORM).addFormDataPart("token","xyz")
          
          .addFormDataPart("imfile",File("Documents/up/1.png").name,File("Documents/up/1.png").asRequestBody("application/octet-stream".toMediaType()))
          .build()
    val request = Request.Builder()
        .url(url)
        .addHeader("User-Agent", "Test Agent")
        .addHeader("Keep-Alive", "true")
        .post(body)
        .build()

    val response = client.newCall(request).execute()

    println(response.code)
    println(response.body?.string())
}
''';
      expect(
          codeGen.getCode(
            CodegenLanguage.kotlinOkHttp,
            requestModelPost9,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT 1', () {
      const expectedCode = r'''import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import okhttp3.MediaType.Companion.toMediaType

fun main() {
    val client = OkHttpClient()

    val url = "https://reqres.in/api/users/2"

    val mediaType = "application/json".toMediaType()

    val body = """{
"name": "morpheus",
"job": "zion resident"
}""".toRequestBody(mediaType)

    val request = Request.Builder()
        .url(url)
        .addHeader("x-api-key", "reqres-free-v1")
        .put(body)
        .build()

    val response = client.newCall(request).execute()

    println(response.code)
    println(response.body?.string())
}
''';
      expect(
          codeGen.getCode(
            CodegenLanguage.kotlinOkHttp,
            requestModelPut1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH 1', () {
      const expectedCode = r'''import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import okhttp3.MediaType.Companion.toMediaType

fun main() {
    val client = OkHttpClient()

    val url = "https://reqres.in/api/users/2"

    val mediaType = "application/json".toMediaType()

    val body = """{
"name": "marfeus",
"job": "accountant"
}""".toRequestBody(mediaType)

    val request = Request.Builder()
        .url(url)
        .addHeader("x-api-key", "reqres-free-v1")
        .patch(body)
        .build()

    val response = client.newCall(request).execute()

    println(response.code)
    println(response.body?.string())
}
''';
      expect(
          codeGen.getCode(
            CodegenLanguage.kotlinOkHttp,
            requestModelPatch1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode = r"""import okhttp3.OkHttpClient
import okhttp3.Request

fun main() {
    val client = OkHttpClient()

    val url = "https://reqres.in/api/users/2"

    val request = Request.Builder()
        .url(url)
        .addHeader("x-api-key", "reqres-free-v1")
        .delete()
        .build()

    val response = client.newCall(request).execute()

    println(response.code)
    println(response.body?.string())
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.kotlinOkHttp,
            requestModelDelete1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('DELETE 2', () {
      const expectedCode = r'''import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import okhttp3.MediaType.Companion.toMediaType

fun main() {
    val client = OkHttpClient()

    val url = "https://reqres.in/api/users/2"

    val mediaType = "application/json".toMediaType()

    val body = """{
"name": "marfeus",
"job": "accountant"
}""".toRequestBody(mediaType)

    val request = Request.Builder()
        .url(url)
        .addHeader("x-api-key", "reqres-free-v1")
        .delete(body)
        .build()

    val response = client.newCall(request).execute()

    println(response.code)
    println(response.body?.string())
}
''';
      expect(
          codeGen.getCode(
            CodegenLanguage.kotlinOkHttp,
            requestModelDelete2,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });
}
