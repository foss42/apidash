import 'package:test/test.dart';
import 'package:apidash/codegen/kotlin/retrofit.dart';
import '../request_models.dart';

void main() {
  final kotlinRetrofitCodeGen = KotlinRetrofitCodeGen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r'''
    @GET("https://api.foss42.com")
    fun callApi()
''';
      expect(kotlinRetrofitCodeGen.getCode(requestModelGet1, "https"),
          expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r'''
    @GET("https://api.foss42.com/country/data")
    fun callApi()
''';
      expect(kotlinRetrofitCodeGen.getCode(requestModelGet2, "https"),
          expectedCode);
    });

    test('GET 3', () {
      const expectedCode = r'''
    @GET("https://api.foss42.com/country/data")
    fun callApi()
''';
      expect(kotlinRetrofitCodeGen.getCode(requestModelGet3, "https"),
          expectedCode);
    });

    // Add tests for other GET requests...
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r'''
    @HEAD("https://api.foss42.com")
    fun callApi()
''';
      expect(kotlinRetrofitCodeGen.getCode(requestModelHead1, "https"),
          expectedCode);
    });

    // Add tests for other HEAD requests...
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r'''
    @POST("https://api.foss42.com/case/lower")
    fun callApi(@Body body: RequestBody)
''';
      expect(kotlinRetrofitCodeGen.getCode(requestModelPost1, "https"),
          expectedCode);
    });

    // Add tests for other POST requests...
  });

  // Add groups and tests for other request types (PUT, PATCH, DELETE)...
}
