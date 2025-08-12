import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';
import '../models/request_models.dart';

void main() {
  final codeGen = Codegen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final response = await dio.Dio().get('https://api.apidash.dev');
    print(response.statusCode);
    print(response.data);
  } on dio.DioException catch (e, s) {
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
            requestModelGet1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final queryParams = {
      'code': ['US']
    };
    final response = await dio.Dio().get(
      'https://api.apidash.dev/country/data',
      queryParameters: queryParams,
    );
    print(response.statusCode);
    print(response.data);
  } on dio.DioException catch (e, s) {
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
            requestModelGet2,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 3', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final queryParams = {
      'code': [
        'IND',
        'US',
      ]
    };
    final response = await dio.Dio().get(
      'https://api.apidash.dev/country/data',
      queryParameters: queryParams,
    );
    print(response.statusCode);
    print(response.data);
  } on dio.DioException catch (e, s) {
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
            requestModelGet3,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 4', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final queryParams = {
      'num': ['8700000'],
      'digits': ['3'],
      'system': ['SS'],
      'add_space': ['true'],
      'trailing_zeros': ['true'],
    };
    final response = await dio.Dio().get(
      'https://api.apidash.dev/humanize/social',
      queryParameters: queryParams,
    );
    print(response.statusCode);
    print(response.data);
  } on dio.DioException catch (e, s) {
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
            requestModelGet4,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 5', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final headers = {'User-Agent': 'Test Agent'};
    final response = await dio.Dio().get(
      'https://api.github.com/repos/foss42/apidash',
      options: dio.Options(headers: headers),
    );
    print(response.statusCode);
    print(response.data);
  } on dio.DioException catch (e, s) {
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
            requestModelGet5,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 6', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final queryParams = {
      'raw': ['true']
    };
    final headers = {'User-Agent': 'Test Agent'};
    final response = await dio.Dio().get(
      'https://api.github.com/repos/foss42/apidash',
      queryParameters: queryParams,
      options: dio.Options(headers: headers),
    );
    print(response.statusCode);
    print(response.data);
  } on dio.DioException catch (e, s) {
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
            requestModelGet6,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final response = await dio.Dio().get('https://api.apidash.dev');
    print(response.statusCode);
    print(response.data);
  } on dio.DioException catch (e, s) {
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
            requestModelGet7,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 8', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final queryParams = {
      'raw': ['true']
    };
    final headers = {'User-Agent': 'Test Agent'};
    final response = await dio.Dio().get(
      'https://api.github.com/repos/foss42/apidash',
      queryParameters: queryParams,
      options: dio.Options(headers: headers),
    );
    print(response.statusCode);
    print(response.data);
  } on dio.DioException catch (e, s) {
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
            requestModelGet8,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 9', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final queryParams = {
      'num': ['8700000'],
      'add_space': ['true'],
    };
    final response = await dio.Dio().get(
      'https://api.apidash.dev/humanize/social',
      queryParameters: queryParams,
    );
    print(response.statusCode);
    print(response.data);
  } on dio.DioException catch (e, s) {
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
            requestModelGet9,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 10', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final headers = {'User-Agent': 'Test Agent'};
    final response = await dio.Dio().get(
      'https://api.apidash.dev/humanize/social',
      options: dio.Options(headers: headers),
    );
    print(response.statusCode);
    print(response.data);
  } on dio.DioException catch (e, s) {
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
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final queryParams = {
      'num': ['8700000'],
      'digits': ['3'],
    };
    final headers = {'User-Agent': 'Test Agent'};
    final response = await dio.Dio().get(
      'https://api.apidash.dev/humanize/social',
      queryParameters: queryParams,
      options: dio.Options(headers: headers),
    );
    print(response.statusCode);
    print(response.data);
  } on dio.DioException catch (e, s) {
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
            requestModelGet11,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 12', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final response = await dio.Dio().get('https://api.apidash.dev/humanize/social');
    print(response.statusCode);
    print(response.data);
  } on dio.DioException catch (e, s) {
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
            requestModelGet12,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final response = await dio.Dio().head('https://api.apidash.dev');
    print(response.statusCode);
    print(response.data);
  } on dio.DioException catch (e, s) {
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
            requestModelHead1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final response = await dio.Dio().head('http://api.apidash.dev');
    print(response.statusCode);
    print(response.data);
  } on dio.DioException catch (e, s) {
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
            requestModelHead2,
            SupportedUriSchemes.http,
          ),
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
    final response = await dio.Dio().post(
      'https://api.apidash.dev/case/lower',
      data: data,
    );
    print(response.statusCode);
    print(response.data);
  } on dio.DioException catch (e, s) {
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
            requestModelPost1,
            SupportedUriSchemes.https,
          ),
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
    final response = await dio.Dio().post(
      'https://api.apidash.dev/case/lower',
      data: data,
    );
    print(response.statusCode);
    print(response.data);
  } on dio.DioException catch (e, s) {
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
            requestModelPost2,
            SupportedUriSchemes.https,
          ),
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
    final response = await dio.Dio().post(
      'https://api.apidash.dev/case/lower',
      options: dio.Options(headers: headers),
      data: data,
    );
    print(response.statusCode);
    print(response.data);
  } on dio.DioException catch (e, s) {
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
            requestModelPost3,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
    test('POST 4', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final data = dio.FormData();
    final List<Map<String, String>> formDataList = [
      {"name": "text", "value": "API", "type": "text"},
      {"name": "sep", "value": "|", "type": "text"},
      {"name": "times", "value": "3", "type": "text"}
    ];
    for (var formField in formDataList) {
      if (formField['type'] == 'file') {
        if (formField['value'] != null) {
          data.files.add(MapEntry(
            formField['name']!,
            await dio.MultipartFile.fromFile(formField['value']!,
                filename: formField['value']!),
          ));
        }
      } else {
        if (formField['value'] != null) {
          data.fields
              .add(MapEntry(formField['name']!, formField['value']!));
        }
      }
    }

    final response = await dio.Dio().post(
      'https://api.apidash.dev/io/form',
      data: data,
    );
    print(response.statusCode);
    print(response.data);
  } on dio.DioException catch (e, s) {
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
            requestModelPost4,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('POST 5', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final headers = {'User-Agent': 'Test Agent'};
    final data = dio.FormData();
    final List<Map<String, String>> formDataList = [
      {"name": "text", "value": "API", "type": "text"},
      {"name": "sep", "value": "|", "type": "text"},
      {"name": "times", "value": "3", "type": "text"}
    ];
    for (var formField in formDataList) {
      if (formField['type'] == 'file') {
        if (formField['value'] != null) {
          data.files.add(MapEntry(
            formField['name']!,
            await dio.MultipartFile.fromFile(formField['value']!,
                filename: formField['value']!),
          ));
        }
      } else {
        if (formField['value'] != null) {
          data.fields
              .add(MapEntry(formField['name']!, formField['value']!));
        }
      }
    }

    final response = await dio.Dio().post(
      'https://api.apidash.dev/io/form',
      options: dio.Options(headers: headers),
      data: data,
    );
    print(response.statusCode);
    print(response.data);
  } on dio.DioException catch (e, s) {
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
            requestModelPost5,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('POST 6', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final data = dio.FormData();
    final List<Map<String, String>> formDataList = [
      {"name": "token", "value": "xyz", "type": "text"},
      {
        "name": "imfile",
        "value": "/Documents/up/1.png",
        "type": "file"
      }
    ];
    for (var formField in formDataList) {
      if (formField['type'] == 'file') {
        if (formField['value'] != null) {
          data.files.add(MapEntry(
            formField['name']!,
            await dio.MultipartFile.fromFile(formField['value']!,
                filename: formField['value']!),
          ));
        }
      } else {
        if (formField['value'] != null) {
          data.fields
              .add(MapEntry(formField['name']!, formField['value']!));
        }
      }
    }

    final response = await dio.Dio().post(
      'https://api.apidash.dev/io/img',
      data: data,
    );
    print(response.statusCode);
    print(response.data);
  } on dio.DioException catch (e, s) {
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
            requestModelPost6,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('POST 7', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final data = dio.FormData();
    final List<Map<String, String>> formDataList = [
      {"name": "token", "value": "xyz", "type": "text"},
      {
        "name": "imfile",
        "value": "/Documents/up/1.png",
        "type": "file"
      }
    ];
    for (var formField in formDataList) {
      if (formField['type'] == 'file') {
        if (formField['value'] != null) {
          data.files.add(MapEntry(
            formField['name']!,
            await dio.MultipartFile.fromFile(formField['value']!,
                filename: formField['value']!),
          ));
        }
      } else {
        if (formField['value'] != null) {
          data.fields
              .add(MapEntry(formField['name']!, formField['value']!));
        }
      }
    }

    final response = await dio.Dio().post(
      'https://api.apidash.dev/io/img',
      data: data,
    );
    print(response.statusCode);
    print(response.data);
  } on dio.DioException catch (e, s) {
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
            requestModelPost7,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('POST 8', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final queryParams = {
      'size': ['2'],
      'len': ['3'],
    };
    final data = dio.FormData();
    final List<Map<String, String>> formDataList = [
      {"name": "text", "value": "API", "type": "text"},
      {"name": "sep", "value": "|", "type": "text"},
      {"name": "times", "value": "3", "type": "text"}
    ];
    for (var formField in formDataList) {
      if (formField['type'] == 'file') {
        if (formField['value'] != null) {
          data.files.add(MapEntry(
            formField['name']!,
            await dio.MultipartFile.fromFile(formField['value']!,
                filename: formField['value']!),
          ));
        }
      } else {
        if (formField['value'] != null) {
          data.fields
              .add(MapEntry(formField['name']!, formField['value']!));
        }
      }
    }

    final response = await dio.Dio().post(
      'https://api.apidash.dev/io/form',
      queryParameters: queryParams,
      data: data,
    );
    print(response.statusCode);
    print(response.data);
  } on dio.DioException catch (e, s) {
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
            requestModelPost8,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('POST 9', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final queryParams = {
      'size': ['2'],
      'len': ['3'],
    };
    final headers = {
      'User-Agent': 'Test Agent',
      'Keep-Alive': 'true',
    };
    final data = dio.FormData();
    final List<Map<String, String>> formDataList = [
      {"name": "token", "value": "xyz", "type": "text"},
      {
        "name": "imfile",
        "value": "/Documents/up/1.png",
        "type": "file"
      }
    ];
    for (var formField in formDataList) {
      if (formField['type'] == 'file') {
        if (formField['value'] != null) {
          data.files.add(MapEntry(
            formField['name']!,
            await dio.MultipartFile.fromFile(formField['value']!,
                filename: formField['value']!),
          ));
        }
      } else {
        if (formField['value'] != null) {
          data.fields
              .add(MapEntry(formField['name']!, formField['value']!));
        }
      }
    }

    final response = await dio.Dio().post(
      'https://api.apidash.dev/io/img',
      queryParameters: queryParams,
      options: dio.Options(headers: headers),
      data: data,
    );
    print(response.statusCode);
    print(response.data);
  } on dio.DioException catch (e, s) {
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
            requestModelPost9,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });
  group('PUT Request', () {
    test('PUT 1', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;
import 'dart:convert' as convert;

void main() async {
  try {
    final headers = {'x-api-key': 'reqres-free-v1'};
    final data = convert.json.decode(r'''{
"name": "morpheus",
"job": "zion resident"
}''');
    final response = await dio.Dio().put(
      'https://reqres.in/api/users/2',
      options: dio.Options(headers: headers),
      data: data,
    );
    print(response.statusCode);
    print(response.data);
  } on dio.DioException catch (e, s) {
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
            requestModelPut1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH 1', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;
import 'dart:convert' as convert;

void main() async {
  try {
    final headers = {'x-api-key': 'reqres-free-v1'};
    final data = convert.json.decode(r'''{
"name": "marfeus",
"job": "accountant"
}''');
    final response = await dio.Dio().patch(
      'https://reqres.in/api/users/2',
      options: dio.Options(headers: headers),
      data: data,
    );
    print(response.statusCode);
    print(response.data);
  } on dio.DioException catch (e, s) {
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
            requestModelPatch1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;

void main() async {
  try {
    final headers = {'x-api-key': 'reqres-free-v1'};
    final response = await dio.Dio().delete(
      'https://reqres.in/api/users/2',
      options: dio.Options(headers: headers),
    );
    print(response.statusCode);
    print(response.data);
  } on dio.DioException catch (e, s) {
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
            requestModelDelete1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('DELETE 2', () {
      const expectedCode = r"""import 'package:dio/dio.dart' as dio;
import 'dart:convert' as convert;

void main() async {
  try {
    final headers = {'x-api-key': 'reqres-free-v1'};
    final data = convert.json.decode(r'''{
"name": "marfeus",
"job": "accountant"
}''');
    final response = await dio.Dio().delete(
      'https://reqres.in/api/users/2',
      options: dio.Options(headers: headers),
      data: data,
    );
    print(response.statusCode);
    print(response.data);
  } on dio.DioException catch (e, s) {
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
            requestModelDelete2,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });
}
