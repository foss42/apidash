import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:test/test.dart';
import '../request_models.dart';

void main() {
  final codeGen = Codegen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final response = await dio.Dio.get('https://api.apidash.dev');
    print(response.statusCode);
    print(response.data);
  } on DioException catch (e, s) {
    print(e.response?.statusCode);
    print(e.response?.data);
    print(s);
  } catch (e, s) {
    print(e);
    print(s);
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartDio, requestModelGet1, "https"),
          expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final queryParams = {'code': 'US'};
    final response = await dio.Dio.get(
      'https://api.apidash.dev/country/data',
      queryParameters: queryParams,
    );
    print(response.statusCode);
    print(response.data);
  } on DioException catch (e, s) {
    print(e.response?.statusCode);
    print(e.response?.data);
    print(s);
  } catch (e, s) {
    print(e);
    print(s);
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartDio, requestModelGet2, "https"),
          expectedCode);
    });

    test('GET 3', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final queryParams = {'code': 'IND'};
    final response = await dio.Dio.get(
      'https://api.apidash.dev/country/data?code=US',
      queryParameters: queryParams,
    );
    print(response.statusCode);
    print(response.data);
  } on DioException catch (e, s) {
    print(e.response?.statusCode);
    print(e.response?.data);
    print(s);
  } catch (e, s) {
    print(e);
    print(s);
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartDio, requestModelGet3, "https"),
          expectedCode);
    });

    test('GET 4', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final queryParams = {
      'num': '8700000',
      'digits': '3',
      'system': 'SS',
      'add_space': 'true',
      'trailing_zeros': 'true',
    };
    final response = await dio.Dio.get(
      'https://api.apidash.dev/humanize/social',
      queryParameters: queryParams,
    );
    print(response.statusCode);
    print(response.data);
  } on DioException catch (e, s) {
    print(e.response?.statusCode);
    print(e.response?.data);
    print(s);
  } catch (e, s) {
    print(e);
    print(s);
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartDio, requestModelGet4, "https"),
          expectedCode);
    });

    test('GET 5', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final headers = {'User-Agent': 'Test Agent'};
    final response = await dio.Dio.get(
      'https://api.github.com/repos/foss42/apidash',
      options: Options(headers: headers),
    );
    print(response.statusCode);
    print(response.data);
  } on DioException catch (e, s) {
    print(e.response?.statusCode);
    print(e.response?.data);
    print(s);
  } catch (e, s) {
    print(e);
    print(s);
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartDio, requestModelGet5, "https"),
          expectedCode);
    });

    test('GET 6', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final queryParams = {'raw': 'true'};
    final headers = {'User-Agent': 'Test Agent'};
    final response = await dio.Dio.get(
      'https://api.github.com/repos/foss42/apidash',
      queryParameters: queryParams,
      options: Options(headers: headers),
    );
    print(response.statusCode);
    print(response.data);
  } on DioException catch (e, s) {
    print(e.response?.statusCode);
    print(e.response?.data);
    print(s);
  } catch (e, s) {
    print(e);
    print(s);
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartDio, requestModelGet6, "https"),
          expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final response = await dio.Dio.get('https://api.apidash.dev');
    print(response.statusCode);
    print(response.data);
  } on DioException catch (e, s) {
    print(e.response?.statusCode);
    print(e.response?.data);
    print(s);
  } catch (e, s) {
    print(e);
    print(s);
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartDio, requestModelGet7, "https"),
          expectedCode);
    });

    test('GET 8', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final queryParams = {'raw': 'true'};
    final headers = {'User-Agent': 'Test Agent'};
    final response = await dio.Dio.get(
      'https://api.github.com/repos/foss42/apidash',
      queryParameters: queryParams,
      options: Options(headers: headers),
    );
    print(response.statusCode);
    print(response.data);
  } on DioException catch (e, s) {
    print(e.response?.statusCode);
    print(e.response?.data);
    print(s);
  } catch (e, s) {
    print(e);
    print(s);
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartDio, requestModelGet8, "https"),
          expectedCode);
    });

    test('GET 9', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final queryParams = {
      'num': '8700000',
      'add_space': 'true',
    };
    final response = await dio.Dio.get(
      'https://api.apidash.dev/humanize/social',
      queryParameters: queryParams,
    );
    print(response.statusCode);
    print(response.data);
  } on DioException catch (e, s) {
    print(e.response?.statusCode);
    print(e.response?.data);
    print(s);
  } catch (e, s) {
    print(e);
    print(s);
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartDio, requestModelGet9, "https"),
          expectedCode);
    });

    test('GET 10', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final headers = {'User-Agent': 'Test Agent'};
    final response = await dio.Dio.get(
      'https://api.apidash.dev/humanize/social',
      options: Options(headers: headers),
    );
    print(response.statusCode);
    print(response.data);
  } on DioException catch (e, s) {
    print(e.response?.statusCode);
    print(e.response?.data);
    print(s);
  } catch (e, s) {
    print(e);
    print(s);
  }
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.dartDio,
            requestModelGet10,
            "https",
          ),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final queryParams = {
      'num': '8700000',
      'digits': '3',
    };
    final headers = {'User-Agent': 'Test Agent'};
    final response = await dio.Dio.get(
      'https://api.apidash.dev/humanize/social',
      queryParameters: queryParams,
      options: Options(headers: headers),
    );
    print(response.statusCode);
    print(response.data);
  } on DioException catch (e, s) {
    print(e.response?.statusCode);
    print(e.response?.data);
    print(s);
  } catch (e, s) {
    print(e);
    print(s);
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartDio, requestModelGet11, "https"),
          expectedCode);
    });

    test('GET 12', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final response = await dio.Dio.get('https://api.apidash.dev/humanize/social');
    print(response.statusCode);
    print(response.data);
  } on DioException catch (e, s) {
    print(e.response?.statusCode);
    print(e.response?.data);
    print(s);
  } catch (e, s) {
    print(e);
    print(s);
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartDio, requestModelGet12, "https"),
          expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final response = await dio.Dio.head('https://api.apidash.dev');
    print(response.statusCode);
    print(response.data);
  } on DioException catch (e, s) {
    print(e.response?.statusCode);
    print(e.response?.data);
    print(s);
  } catch (e, s) {
    print(e);
    print(s);
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartDio, requestModelHead1, "https"),
          expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final response = await dio.Dio.head('http://api.apidash.dev');
    print(response.statusCode);
    print(response.data);
  } on DioException catch (e, s) {
    print(e.response?.statusCode);
    print(e.response?.data);
    print(s);
  } catch (e, s) {
    print(e);
    print(s);
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartDio, requestModelHead2, "http"),
          expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final data = r'''{
"text": "I LOVE Flutter"
}''';
    final response = await dio.Dio.post(
      'https://api.apidash.dev/case/lower',
      data: data,
    );
    print(response.statusCode);
    print(response.data);
  } on DioException catch (e, s) {
    print(e.response?.statusCode);
    print(e.response?.data);
    print(s);
  } catch (e, s) {
    print(e);
    print(s);
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartDio, requestModelPost1, "https"),
          expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;
import 'dart:convert' as convert;

void main() async {
  try {
    final data = convert.json.decode(r'''{
"text": "I LOVE Flutter",
"flag": null,
"male": true,
"female": false,
"no": 1.2,
"arr": ["null", "true", "false", null]
}''');
    final response = await dio.Dio.post(
      'https://api.apidash.dev/case/lower',
      data: data,
    );
    print(response.statusCode);
    print(response.data);
  } on DioException catch (e, s) {
    print(e.response?.statusCode);
    print(e.response?.data);
    print(s);
  } catch (e, s) {
    print(e);
    print(s);
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartDio, requestModelPost2, "https"),
          expectedCode);
    });

    test('POST 3', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;
import 'dart:convert' as convert;

void main() async {
  try {
    final headers = {'User-Agent': 'Test Agent'};
    final data = convert.json.decode(r'''{
"text": "I LOVE Flutter"
}''');
    final response = await dio.Dio.post(
      'https://api.apidash.dev/case/lower',
      options: Options(headers: headers),
      data: data,
    );
    print(response.statusCode);
    print(response.data);
  } on DioException catch (e, s) {
    print(e.response?.statusCode);
    print(e.response?.data);
    print(s);
  } catch (e, s) {
    print(e);
    print(s);
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartDio, requestModelPost3, "https"),
          expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT 1', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;
import 'dart:convert' as convert;

void main() async {
  try {
    final data = convert.json.decode(r'''{
"name": "morpheus",
"job": "zion resident"
}''');
    final response = await dio.Dio.put(
      'https://reqres.in/api/users/2',
      data: data,
    );
    print(response.statusCode);
    print(response.data);
  } on DioException catch (e, s) {
    print(e.response?.statusCode);
    print(e.response?.data);
    print(s);
  } catch (e, s) {
    print(e);
    print(s);
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartDio, requestModelPut1, "https"),
          expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH 1', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;
import 'dart:convert' as convert;

void main() async {
  try {
    final data = convert.json.decode(r'''{
"name": "marfeus",
"job": "accountant"
}''');
    final response = await dio.Dio.patch(
      'https://reqres.in/api/users/2',
      data: data,
    );
    print(response.statusCode);
    print(response.data);
  } on DioException catch (e, s) {
    print(e.response?.statusCode);
    print(e.response?.data);
    print(s);
  } catch (e, s) {
    print(e);
    print(s);
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartDio, requestModelPatch1, "https"),
          expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final response = await dio.Dio.delete('https://reqres.in/api/users/2');
    print(response.statusCode);
    print(response.data);
  } on DioException catch (e, s) {
    print(e.response?.statusCode);
    print(e.response?.data);
    print(s);
  } catch (e, s) {
    print(e);
    print(s);
  }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.dartDio, requestModelDelete1, "https"),
          expectedCode);
    });

    test('DELETE 2', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;
import 'dart:convert' as convert;

void main() async {
  try {
    final data = convert.json.decode(r'''{
"name": "marfeus",
"job": "accountant"
}''');
    final response = await dio.Dio.delete(
      'https://reqres.in/api/users/2',
      data: data,
    );
    print(response.statusCode);
    print(response.data);
  } on DioException catch (e, s) {
    print(e.response?.statusCode);
    print(e.response?.data);
    print(s);
  } catch (e, s) {
    print(e);
    print(s);
  }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.dartDio, requestModelDelete2, "https"),
          expectedCode);
    });
  });
}
