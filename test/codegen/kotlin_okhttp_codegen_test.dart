import 'package:apidash/codegen/kotlin/pkg_okhttp.dart';
import 'package:apidash/models/models.dart' show KVRow, RequestModel;
import 'package:test/test.dart';
import 'package:apidash/consts.dart';

void main() {
  group('KotlinOkHttpCodeGen', () {
    final kotlinOkHttpCodeGen = KotlinOkHttpCodeGen();

    test('getCode returns valid code for GET request', () {
      const requestModel = RequestModel(
        url: 'https://api.foss42.com',
        method: HTTPVerb.get,
        id: '',
      );
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
      expect(kotlinOkHttpCodeGen.getCode(requestModel), expectedCode);
    });

    test('getCode returns valid code for POST request', () {
      const requestModel = RequestModel(
        url: 'https://api.foss42.com/case/lower',
        method: HTTPVerb.post,
        requestBody: '{"text": "IS Upper"}',
        requestBodyContentType: ContentType.json,
        id: '1',
      );
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
      expect(kotlinOkHttpCodeGen.getCode(requestModel), expectedCode);
    });

    test('getCode returns valid code for DELETE request', () {
      const requestModel = RequestModel(
        url: 'https://jsonplaceholder.typicode.com/posts/1',
        method: HTTPVerb.delete,
        requestBody: '{"title": "foo","body": "bar","userId": 1}',
        requestBodyContentType: ContentType.json,
        id: '1',
      );
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
      expect(kotlinOkHttpCodeGen.getCode(requestModel), expectedCode);
    });

    test('getCode returns valid code for HEAD request', () {
      const requestModel = RequestModel(
        url: 'https://jsonplaceholder.typicode.com/posts/1',
        method: HTTPVerb.head,
        id: '1',
      );
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
      expect(kotlinOkHttpCodeGen.getCode(requestModel), expectedCode);
    });

    test(
        'getCode returns valid code for requests with headers and query parameters',
        () {
      const requestModel = RequestModel(
        url: 'https://jsonplaceholder.typicode.com/posts',
        method: HTTPVerb.get,
        requestParams: [
          KVRow('userId', 1),
        ],
        requestHeaders: [
          KVRow('Custom-Header-1', 'Value-1'),
          KVRow('Custom-Header-2', 'Value-2')
        ],
        id: '1',
      );
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
      expect(kotlinOkHttpCodeGen.getCode(requestModel), expectedCode);
    });
  });
}
