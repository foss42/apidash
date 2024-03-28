import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:test/test.dart';
import '../request_models.dart';

void main() {
  final codeGen = Codegen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = '''
import retrofit2.http.*
import retrofit2.Call
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

interface ApiService {
    @GET("")
    fun (): Call<ResponseBody>
}

fun main() {
    val service = Retrofit.Builder()
        .baseUrl("https://api.apidash.dev")
        .addConverterFactory(GsonConverterFactory.create())
        .build()
        .create(ApiService::class.java)

    // Call your API methods here using service object
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.kotlinRetrofit, requestModelGet1, "https"),
          expectedCode);
    });

    test('GET 2', () {
      const expectedCode = '''
import retrofit2.http.*
import retrofit2.Call
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

interface ApiService {
    @GET("/country/data", @Query("code") code: String)
    fun (): Call<ResponseBody>
}

fun main() {
    val service = Retrofit.Builder()
        .baseUrl("https://api.apidash.dev")
        .addConverterFactory(GsonConverterFactory.create())
        .build()
        .create(ApiService::class.java)

    // Call your API methods here using service object
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.kotlinRetrofit, requestModelGet2, "https"),
          expectedCode);
    });

    test('GET 3', () {
      const expectedCode = '''
import retrofit2.http.*
import retrofit2.Call
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

interface ApiService {
    @GET("/country/data", @Query("code") code: String)
    fun (): Call<ResponseBody>
}

fun main() {
    val service = Retrofit.Builder()
        .baseUrl("https://api.apidash.dev")
        .addConverterFactory(GsonConverterFactory.create())
        .build()
        .create(ApiService::class.java)

    // Call your API methods here using service object
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.kotlinRetrofit, requestModelGet3, "https"),
          expectedCode);
    });

    test('GET 4', () {
      const expectedCode = '''
import retrofit2.http.*
import retrofit2.Call
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

interface ApiService {
    @GET("/humanize/social", @Query("num") num: String, @Query("digits") digits: String, @Query("system") system: String, @Query("add_space") add_space: String, @Query("trailing_zeros") trailing_zeros: String)
    fun (): Call<ResponseBody>
}

fun main() {
    val service = Retrofit.Builder()
        .baseUrl("https://api.apidash.dev")
        .addConverterFactory(GsonConverterFactory.create())
        .build()
        .create(ApiService::class.java)

    // Call your API methods here using service object
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.kotlinRetrofit, requestModelGet4, "https"),
          expectedCode);
    });

    test('GET 5', () {
      const expectedCode = '''
import retrofit2.http.*
import retrofit2.Call
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

interface ApiService {
    @GET("/repos/foss42/apidash")@Header("Test Agent") User-Agent: String
    fun (): Call<ResponseBody>
}

fun main() {
    val service = Retrofit.Builder()
        .baseUrl("https://api.github.com")
        .addConverterFactory(GsonConverterFactory.create())
        .build()
        .create(ApiService::class.java)

    // Call your API methods here using service object
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.kotlinRetrofit, requestModelGet5, "https"),
          expectedCode);
    });

    test('GET 6', () {
      const expectedCode = '''
import retrofit2.http.*
import retrofit2.Call
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

interface ApiService {
    @GET("/repos/foss42/apidash", @Query("raw") raw: String)@Header("Test Agent") User-Agent: String
    fun (): Call<ResponseBody>
}

fun main() {
    val service = Retrofit.Builder()
        .baseUrl("https://api.github.com")
        .addConverterFactory(GsonConverterFactory.create())
        .build()
        .create(ApiService::class.java)

    // Call your API methods here using service object
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.kotlinRetrofit, requestModelGet6, "https"),
          expectedCode);
    });

    test('GET 7', () {
      const expectedCode = '''
import retrofit2.http.*
import retrofit2.Call
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

interface ApiService {
    @GET("", @Body requestBody: RequestBody)
    fun (): Call<ResponseBody>
}

fun main() {
    val service = Retrofit.Builder()
        .baseUrl("https://api.apidash.dev")
        .addConverterFactory(GsonConverterFactory.create())
        .build()
        .create(ApiService::class.java)

    // Call your API methods here using service object
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.kotlinRetrofit, requestModelGet7, "https"),
          expectedCode);
    });

    test('GET 8', () {
      const expectedCode = '''
import retrofit2.http.*
import retrofit2.Call
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

interface ApiService {
    @GET("/repos/foss42/apidash", @Query("raw") raw: String)@Header("Test Agent") User-Agent: String
    fun (): Call<ResponseBody>
}

fun main() {
    val service = Retrofit.Builder()
        .baseUrl("https://api.github.com")
        .addConverterFactory(GsonConverterFactory.create())
        .build()
        .create(ApiService::class.java)

    // Call your API methods here using service object
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.kotlinRetrofit, requestModelGet8, "https"),
          expectedCode);
    });

    test('GET 9', () {
      const expectedCode = '''
import retrofit2.http.*
import retrofit2.Call
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

interface ApiService {
    @GET("/humanize/social", @Query("num") num: String, @Query("add_space") add_space: String)
    fun (): Call<ResponseBody>
}

fun main() {
    val service = Retrofit.Builder()
        .baseUrl("https://api.apidash.dev")
        .addConverterFactory(GsonConverterFactory.create())
        .build()
        .create(ApiService::class.java)

    // Call your API methods here using service object
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.kotlinRetrofit, requestModelGet9, "https"),
          expectedCode);
    });

    test('GET 10', () {
      const expectedCode = '''
import retrofit2.http.*
import retrofit2.Call
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

interface ApiService {
    @GET("/humanize/social")@Header("Test Agent") User-Agent: String
    fun (): Call<ResponseBody>
}

fun main() {
    val service = Retrofit.Builder()
        .baseUrl("https://api.apidash.dev")
        .addConverterFactory(GsonConverterFactory.create())
        .build()
        .create(ApiService::class.java)

    // Call your API methods here using service object
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.kotlinRetrofit, requestModelGet10, "https"),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode = '''
import retrofit2.http.*
import retrofit2.Call
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

interface ApiService {
    @GET("/humanize/social", @Query("num") num: String, @Query("digits") digits: String)@Header("Test Agent") User-Agent: String
    fun (): Call<ResponseBody>
}

fun main() {
    val service = Retrofit.Builder()
        .baseUrl("https://api.apidash.dev")
        .addConverterFactory(GsonConverterFactory.create())
        .build()
        .create(ApiService::class.java)

    // Call your API methods here using service object
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.kotlinRetrofit, requestModelGet11, "https"),
          expectedCode);
    });

    test('GET 12', () {
      const expectedCode = '''
import retrofit2.http.*
import retrofit2.Call
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

interface ApiService {
    @GET("/humanize/social")
    fun (): Call<ResponseBody>
}

fun main() {
    val service = Retrofit.Builder()
        .baseUrl("https://api.apidash.dev")
        .addConverterFactory(GsonConverterFactory.create())
        .build()
        .create(ApiService::class.java)

    // Call your API methods here using service object
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.kotlinRetrofit, requestModelGet12, "https"),
          expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = '''
import retrofit2.http.*
import retrofit2.Call
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

interface ApiService {
    @POST("/case/lower", @Body requestBody: RequestBody)
    fun (): Call<ResponseBody>
}

fun main() {
    val service = Retrofit.Builder()
        .baseUrl("https://api.apidash.dev")
        .addConverterFactory(GsonConverterFactory.create())
        .build()
        .create(ApiService::class.java)

    // Call your API methods here using service object
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.kotlinRetrofit, requestModelPost1, "https"),
          expectedCode);
    });

    test('POST 2', () {
      const expectedCode = '''
import retrofit2.http.*
import retrofit2.Call
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

interface ApiService {
    @POST("/case/lower", @Body requestBody: RequestBody)
    fun (): Call<ResponseBody>
}

fun main() {
    val service = Retrofit.Builder()
        .baseUrl("https://api.apidash.dev")
        .addConverterFactory(GsonConverterFactory.create())
        .build()
        .create(ApiService::class.java)

    // Call your API methods here using service object
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.kotlinRetrofit, requestModelPost2, "https"),
          expectedCode);
    });

    test('POST 3', () {
      const expectedCode = '''
import retrofit2.http.*
import retrofit2.Call
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

interface ApiService {
    @POST("/case/lower", @Body requestBody: RequestBody)@Header("Test Agent") User-Agent: String
    fun (): Call<ResponseBody>
}

fun main() {
    val service = Retrofit.Builder()
        .baseUrl("https://api.apidash.dev")
        .addConverterFactory(GsonConverterFactory.create())
        .build()
        .create(ApiService::class.java)

    // Call your API methods here using service object
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.kotlinRetrofit, requestModelPost3, "https"),
          expectedCode);
    });
    test('POST 4', () {
      const expectedCode = '''
import retrofit2.http.*
import retrofit2.Call
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

interface ApiService {
    @POST("/io/form")
    fun (@Field("API") text : String,@Field("|") sep : String,@Field("3") times : String): Call<ResponseBody>
}

fun main() {
    val service = Retrofit.Builder()
        .baseUrl("https://api.apidash.dev")
        .addConverterFactory(GsonConverterFactory.create())
        .build()
        .create(ApiService::class.java)

    // Call your API methods here using service object
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.kotlinRetrofit, requestModelPost4, "https"),
          expectedCode);
    });

    test('POST 5', () {
      const expectedCode = '''
import retrofit2.http.*
import retrofit2.Call
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

interface ApiService {
    @POST("/io/form")@Header("Test Agent") User-Agent: String
    fun (@Field("API") text : String,@Field("|") sep : String,@Field("3") times : String): Call<ResponseBody>
}

fun main() {
    val service = Retrofit.Builder()
        .baseUrl("https://api.apidash.dev")
        .addConverterFactory(GsonConverterFactory.create())
        .build()
        .create(ApiService::class.java)

    // Call your API methods here using service object
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.kotlinRetrofit, requestModelPost5, "https"),
          expectedCode);
    });

    test('POST 6', () {
      const expectedCode = '''
import retrofit2.http.*
import retrofit2.Call
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

interface ApiService {
    @POST("/io/img")
    fun (@Field("xyz") token : String,@Field("/Documents/up/1.png") imfile : String): Call<ResponseBody>
}

fun main() {
    val service = Retrofit.Builder()
        .baseUrl("https://api.apidash.dev")
        .addConverterFactory(GsonConverterFactory.create())
        .build()
        .create(ApiService::class.java)

    // Call your API methods here using service object
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.kotlinRetrofit, requestModelPost6, "https"),
          expectedCode);
    });

    test('POST 7', () {
      const expectedCode = '''
import retrofit2.http.*
import retrofit2.Call
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

interface ApiService {
    @POST("/io/img")
    fun (@Field("xyz") token : String,@Field("/Documents/up/1.png") imfile : String): Call<ResponseBody>
}

fun main() {
    val service = Retrofit.Builder()
        .baseUrl("https://api.apidash.dev")
        .addConverterFactory(GsonConverterFactory.create())
        .build()
        .create(ApiService::class.java)

    // Call your API methods here using service object
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.kotlinRetrofit, requestModelPost7, "https"),
          expectedCode);
    });

    test('POST 8', () {
      const expectedCode = '''
import retrofit2.http.*
import retrofit2.Call
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

interface ApiService {
    @POST("/io/form", @Query("size") size: String, @Query("len") len: String)
    fun (@Field("API") text : String,@Field("|") sep : String,@Field("3") times : String): Call<ResponseBody>
}

fun main() {
    val service = Retrofit.Builder()
        .baseUrl("https://api.apidash.dev")
        .addConverterFactory(GsonConverterFactory.create())
        .build()
        .create(ApiService::class.java)

    // Call your API methods here using service object
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.kotlinRetrofit, requestModelPost8, "https"),
          expectedCode);
    });

    test('POST 9', () {
      const expectedCode = '''
import retrofit2.http.*
import retrofit2.Call
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

interface ApiService {
    @POST("/io/img", @Query("size") size: String, @Query("len") len: String)@Header("Test Agent") User-Agent: String
    @Header("true") Keep-Alive: String
    fun (@Field("xyz") token : String,@Field("/Documents/up/1.png") imfile : String): Call<ResponseBody>
}

fun main() {
    val service = Retrofit.Builder()
        .baseUrl("https://api.apidash.dev")
        .addConverterFactory(GsonConverterFactory.create())
        .build()
        .create(ApiService::class.java)

    // Call your API methods here using service object
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.kotlinRetrofit, requestModelPost9, "https"),
          expectedCode);
    });
  });

  group('PUT Request', () {
    test('Put 1', () {
      const expectedCode = '''
import retrofit2.http.*
import retrofit2.Call
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

interface ApiService {
    @PUT("/api/users/2", @Body requestBody: RequestBody)
    fun (): Call<ResponseBody>
}

fun main() {
    val service = Retrofit.Builder()
        .baseUrl("https://reqres.in")
        .addConverterFactory(GsonConverterFactory.create())
        .build()
        .create(ApiService::class.java)

    // Call your API methods here using service object
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.kotlinRetrofit, requestModelPut1, "https"),
          expectedCode);
    });
  });

  group('PATCH Request', () {
    test('Patch 1', () {
      const expectedCode = '''
import retrofit2.http.*
import retrofit2.Call
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

interface ApiService {
    @PATCH("/api/users/2", @Body requestBody: RequestBody)
    fun (): Call<ResponseBody>
}

fun main() {
    val service = Retrofit.Builder()
        .baseUrl("https://reqres.in")
        .addConverterFactory(GsonConverterFactory.create())
        .build()
        .create(ApiService::class.java)

    // Call your API methods here using service object
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.kotlinRetrofit, requestModelPatch1, "https"),
          expectedCode);
    });
  });
  group('DELETE Request', () {
    test('Delete 1', () {
      const expectedCode = '''
import retrofit2.http.*
import retrofit2.Call
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

interface ApiService {
    @DELETE("/api/users/2")
    fun (): Call<ResponseBody>
}

fun main() {
    val service = Retrofit.Builder()
        .baseUrl("https://reqres.in")
        .addConverterFactory(GsonConverterFactory.create())
        .build()
        .create(ApiService::class.java)

    // Call your API methods here using service object
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.kotlinRetrofit, requestModelDelete1, "https"),
          expectedCode);
    });

    test('Delete 2', () {
      const expectedCode = '''
import retrofit2.http.*
import retrofit2.Call
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

interface ApiService {
    @DELETE("/api/users/2", @Body requestBody: RequestBody)
    fun (): Call<ResponseBody>
}

fun main() {
    val service = Retrofit.Builder()
        .baseUrl("https://reqres.in")
        .addConverterFactory(GsonConverterFactory.create())
        .build()
        .create(ApiService::class.java)

    // Call your API methods here using service object
}
''';
      expect(
          codeGen.getCode(
              CodegenLanguage.kotlinRetrofit, requestModelDelete2, "https"),
          expectedCode);
    });
  });
}
