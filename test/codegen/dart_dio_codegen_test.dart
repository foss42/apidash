import 'package:apidash/codegen/dart/dio.dart';
import 'package:test/test.dart';

import '../request_models.dart';

void main() {
  final dartDioCodeGen = DartDioCodeGen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final response = await dio.Dio.get('https://api.foss42.com');
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
      expect(dartDioCodeGen.getCode(requestModelGet1, "https"), expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final queryParams = {'code': 'US'};
    final response = await dio.Dio.get(
      'https://api.foss42.com/country/data',
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
      expect(dartDioCodeGen.getCode(requestModelGet2, "https"), expectedCode);
    });

    test('GET 3', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final queryParams = {'code': 'IND'};
    final response = await dio.Dio.get(
      'https://api.foss42.com/country/data?code=US',
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
      expect(dartDioCodeGen.getCode(requestModelGet3, "https"), expectedCode);
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
      'https://api.foss42.com/humanize/social',
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
      expect(dartDioCodeGen.getCode(requestModelGet4, "https"), expectedCode);
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
      expect(dartDioCodeGen.getCode(requestModelGet5, "https"), expectedCode);
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
      expect(dartDioCodeGen.getCode(requestModelGet6, "https"), expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final response = await dio.Dio.get('https://api.foss42.com');
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
      expect(dartDioCodeGen.getCode(requestModelGet7, "https"), expectedCode);
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
      expect(dartDioCodeGen.getCode(requestModelGet8, "https"), expectedCode);
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
      'https://api.foss42.com/humanize/social',
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
      expect(dartDioCodeGen.getCode(requestModelGet9, "https"), expectedCode);
    });

    test('GET 10', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final headers = {'User-Agent': 'Test Agent'};
    final response = await dio.Dio.get(
      'https://api.foss42.com/humanize/social',
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
          dartDioCodeGen.getCode(
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
      'https://api.foss42.com/humanize/social',
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
      expect(dartDioCodeGen.getCode(requestModelGet11, "https"), expectedCode);
    });

    test('GET 12', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final response = await dio.Dio.get('https://api.foss42.com/humanize/social');
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
      expect(dartDioCodeGen.getCode(requestModelGet12, "https"), expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final response = await dio.Dio.head('https://api.foss42.com');
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
      expect(dartDioCodeGen.getCode(requestModelHead1, "https"), expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final response = await dio.Dio.head('http://api.foss42.com');
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
      expect(dartDioCodeGen.getCode(requestModelHead2, "http"), expectedCode);
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
      'https://api.foss42.com/case/lower',
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
      expect(dartDioCodeGen.getCode(requestModelPost1, "https"), expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;
import 'dart:convert' as convert;

void main() async {
  try {
    final data = convert.json.decode(r'''{
"text": "I LOVE Flutter"
}''');
    final response = await dio.Dio.post(
      'https://api.foss42.com/case/lower',
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
      expect(dartDioCodeGen.getCode(requestModelPost2, "https"), expectedCode);
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
      'https://api.foss42.com/case/lower',
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
      expect(dartDioCodeGen.getCode(requestModelPost3, "https"), expectedCode);
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
      expect(dartDioCodeGen.getCode(requestModelPut1, "https"), expectedCode);
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
      expect(dartDioCodeGen.getCode(requestModelPatch1, "https"), expectedCode);
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
          dartDioCodeGen.getCode(requestModelDelete1, "https"), expectedCode);
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
          dartDioCodeGen.getCode(requestModelDelete2, "https"), expectedCode);
    });
  });
}
