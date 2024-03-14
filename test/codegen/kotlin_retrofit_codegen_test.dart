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
              CodegenLanguage.kotlinRetrofit, requestModelGet2, "https"),
          expectedCode);
    });
  });

  group('POST Request', () {
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
    // Add test cases for PUT requests...
  });

  group('DELETE Request', () {
    // Add test cases for DELETE requests...
  });
}
