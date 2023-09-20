import 'package:apidash/codegen/kotlin/pkg_okhttp.dart';
import 'package:test/test.dart';
import '../request_models.dart';

void main() {
  group('KotlinOkHttpCodeGen', () {
    final kotlinOkHttpCodeGen = KotlinOkHttpCodeGen();

    test('getCode returns valid code for GET request', () {
      const expectedCode = r"""import okhttp3.MediaType.Companion.toMediaType
import okhttp3.MultipartBody
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import okhttp3.RequestBody.Companion.asRequestBody
import java.io.File
import java.util.concurrent.TimeUnit

val client = OkHttpClient()
val request = Request.Builder()
  .url("https://api.foss42.com")
  .build()
val response = client.newCall(request).execute()

println(response.body!!.string())
""";
      expect(kotlinOkHttpCodeGen.getCode(requestModelGet1), expectedCode);
    });

    test('getCode returns valid code for POST request', () {
      const expectedCode = r"""import okhttp3.MediaType.Companion.toMediaType
import okhttp3.MultipartBody
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import okhttp3.RequestBody.Companion.asRequestBody
import java.io.File
import java.util.concurrent.TimeUnit

val client = OkHttpClient()
val mediaType = "application/json".toMediaType()
val body = "{"text": "IS Upper"}".toRequestBody(mediaType)
val request = Request.Builder()
  .url("https://api.foss42.com/case/lower")
  .post(body)
  .build()
val response = client.newCall(request).execute()

println(response.body!!.string())
""";
      expect(kotlinOkHttpCodeGen.getCode(requestModelPost1), expectedCode);
    });

    test('getCode returns valid code for DELETE request', () {
      const expectedCode = r"""import okhttp3.MediaType.Companion.toMediaType
import okhttp3.MultipartBody
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import okhttp3.RequestBody.Companion.asRequestBody
import java.io.File
import java.util.concurrent.TimeUnit

val client = OkHttpClient()
val mediaType = "application/json".toMediaType()
val body = "{"title": "foo","body": "bar","userId": 1}".toRequestBody(mediaType)
val request = Request.Builder()
  .url("https://jsonplaceholder.typicode.com/posts/1")
  .method("DELETE", body)
  .build()
val response = client.newCall(request).execute()

println(response.body!!.string())
""";
      expect(kotlinOkHttpCodeGen.getCode(requestModelDelete1), expectedCode);
    });

    test('getCode returns valid code for HEAD request', () {
      const expectedCode = """import okhttp3.MediaType.Companion.toMediaType
import okhttp3.MultipartBody
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import okhttp3.RequestBody.Companion.asRequestBody
import java.io.File
import java.util.concurrent.TimeUnit

val client = OkHttpClient()
val request = Request.Builder()
  .url("https://jsonplaceholder.typicode.com/posts/1")
  .head()
  .build()
val response = client.newCall(request).execute()

println(response.body!!.string())
""";
      expect(kotlinOkHttpCodeGen.getCode(requestModelHead1), expectedCode);
    });

    test(
        'getCode returns valid code for requests with headers and query parameters',
        () {
      const expectedCode = """import okhttp3.MediaType.Companion.toMediaType
import okhttp3.MultipartBody
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import okhttp3.RequestBody.Companion.asRequestBody
import java.io.File
import java.util.concurrent.TimeUnit

val client = OkHttpClient()
val request = Request.Builder()
  .url("https://jsonplaceholder.typicode.com/posts")
  .addQueryParameter("userId", "1")
  .addHeader("Custom-Header-1", "Value-1")
  .addHeader("Custom-Header-2", "Value-2")
  .build()
val response = client.newCall(request).execute()

println(response.body!!.string())
""";
      expect(kotlinOkHttpCodeGen.getCode(requestModelGet2), expectedCode);
    });
  });
}
