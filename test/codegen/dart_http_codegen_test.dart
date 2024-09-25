import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:test/test.dart';
import '../models/request_models.dart';

void main() {
  final codeGen = Codegen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""import 'package:http/http.dart' as http;

void main() async {
  var uri = Uri.parse('https://api.apidash.dev');

  final response = await http.get(uri);

  int statusCode = response.statusCode;
  if (statusCode >= 200 && statusCode < 300) {
    print('Status Code: $statusCode');
    print('Response Body: ${response.body}');
  } else {
    print('Error Status Code: $statusCode');
    print('Error Response Body: ${response.body}');
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartHttp, requestModelGet1, "https"),
          expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r"""import 'package:http/http.dart' as http;

void main() async {
  var uri = Uri.parse('https://api.apidash.dev/country/data');

  var queryParams = {'code': 'US'};
  uri = uri.replace(queryParameters: queryParams);

  final response = await http.get(uri);

  int statusCode = response.statusCode;
  if (statusCode >= 200 && statusCode < 300) {
    print('Status Code: $statusCode');
    print('Response Body: ${response.body}');
  } else {
    print('Error Status Code: $statusCode');
    print('Error Response Body: ${response.body}');
  }
}
""";

      expect(
          codeGen.getCode(CodegenLanguage.dartHttp, requestModelGet2, "https"),
          expectedCode);
    });

    test('GET 3', () {
      const expectedCode = r"""import 'package:http/http.dart' as http;

void main() async {
  var uri = Uri.parse('https://api.apidash.dev/country/data?code=US');

  var queryParams = {'code': 'IND'};
  var urlQueryParams = Map<String, String>.from(uri.queryParameters);
  urlQueryParams.addAll(queryParams);
  uri = uri.replace(queryParameters: urlQueryParams);

  final response = await http.get(uri);

  int statusCode = response.statusCode;
  if (statusCode >= 200 && statusCode < 300) {
    print('Status Code: $statusCode');
    print('Response Body: ${response.body}');
  } else {
    print('Error Status Code: $statusCode');
    print('Error Response Body: ${response.body}');
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartHttp, requestModelGet3, "https"),
          expectedCode);
    });

    test('GET 4', () {
      const expectedCode = r"""import 'package:http/http.dart' as http;

void main() async {
  var uri = Uri.parse('https://api.apidash.dev/humanize/social');

  var queryParams = {
    'num': '8700000',
    'digits': '3',
    'system': 'SS',
    'add_space': 'true',
    'trailing_zeros': 'true',
  };
  uri = uri.replace(queryParameters: queryParams);

  final response = await http.get(uri);

  int statusCode = response.statusCode;
  if (statusCode >= 200 && statusCode < 300) {
    print('Status Code: $statusCode');
    print('Response Body: ${response.body}');
  } else {
    print('Error Status Code: $statusCode');
    print('Error Response Body: ${response.body}');
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartHttp, requestModelGet4, "https"),
          expectedCode);
    });

    test('GET 5', () {
      const expectedCode = r"""import 'package:http/http.dart' as http;

void main() async {
  var uri = Uri.parse('https://api.github.com/repos/foss42/apidash');

  var headers = {'User-Agent': 'Test Agent'};

  final response = await http.get(
    uri,
    headers: headers,
  );

  int statusCode = response.statusCode;
  if (statusCode >= 200 && statusCode < 300) {
    print('Status Code: $statusCode');
    print('Response Body: ${response.body}');
  } else {
    print('Error Status Code: $statusCode');
    print('Error Response Body: ${response.body}');
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartHttp, requestModelGet5, "https"),
          expectedCode);
    });

    test('GET 6', () {
      const expectedCode = r"""import 'package:http/http.dart' as http;

void main() async {
  var uri = Uri.parse('https://api.github.com/repos/foss42/apidash');

  var queryParams = {'raw': 'true'};
  uri = uri.replace(queryParameters: queryParams);

  var headers = {'User-Agent': 'Test Agent'};

  final response = await http.get(
    uri,
    headers: headers,
  );

  int statusCode = response.statusCode;
  if (statusCode >= 200 && statusCode < 300) {
    print('Status Code: $statusCode');
    print('Response Body: ${response.body}');
  } else {
    print('Error Status Code: $statusCode');
    print('Error Response Body: ${response.body}');
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartHttp, requestModelGet6, "https"),
          expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r"""import 'package:http/http.dart' as http;

void main() async {
  var uri = Uri.parse('https://api.apidash.dev');

  final response = await http.get(uri);

  int statusCode = response.statusCode;
  if (statusCode >= 200 && statusCode < 300) {
    print('Status Code: $statusCode');
    print('Response Body: ${response.body}');
  } else {
    print('Error Status Code: $statusCode');
    print('Error Response Body: ${response.body}');
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartHttp, requestModelGet7, "https"),
          expectedCode);
    });

    test('GET 8', () {
      const expectedCode = r"""import 'package:http/http.dart' as http;

void main() async {
  var uri = Uri.parse('https://api.github.com/repos/foss42/apidash');

  var queryParams = {'raw': 'true'};
  uri = uri.replace(queryParameters: queryParams);

  var headers = {'User-Agent': 'Test Agent'};

  final response = await http.get(
    uri,
    headers: headers,
  );

  int statusCode = response.statusCode;
  if (statusCode >= 200 && statusCode < 300) {
    print('Status Code: $statusCode');
    print('Response Body: ${response.body}');
  } else {
    print('Error Status Code: $statusCode');
    print('Error Response Body: ${response.body}');
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartHttp, requestModelGet8, "https"),
          expectedCode);
    });

    test('GET 9', () {
      const expectedCode = r"""import 'package:http/http.dart' as http;

void main() async {
  var uri = Uri.parse('https://api.apidash.dev/humanize/social');

  var queryParams = {
    'num': '8700000',
    'add_space': 'true',
  };
  uri = uri.replace(queryParameters: queryParams);

  final response = await http.get(uri);

  int statusCode = response.statusCode;
  if (statusCode >= 200 && statusCode < 300) {
    print('Status Code: $statusCode');
    print('Response Body: ${response.body}');
  } else {
    print('Error Status Code: $statusCode');
    print('Error Response Body: ${response.body}');
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartHttp, requestModelGet9, "https"),
          expectedCode);
    });

    test('GET 10', () {
      const expectedCode = r"""import 'package:http/http.dart' as http;

void main() async {
  var uri = Uri.parse('https://api.apidash.dev/humanize/social');

  var headers = {'User-Agent': 'Test Agent'};

  final response = await http.get(
    uri,
    headers: headers,
  );

  int statusCode = response.statusCode;
  if (statusCode >= 200 && statusCode < 300) {
    print('Status Code: $statusCode');
    print('Response Body: ${response.body}');
  } else {
    print('Error Status Code: $statusCode');
    print('Error Response Body: ${response.body}');
  }
}
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.dartHttp,
            requestModelGet10,
            "https",
          ),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode = r"""import 'package:http/http.dart' as http;

void main() async {
  var uri = Uri.parse('https://api.apidash.dev/humanize/social');

  var queryParams = {
    'num': '8700000',
    'digits': '3',
  };
  uri = uri.replace(queryParameters: queryParams);

  var headers = {'User-Agent': 'Test Agent'};

  final response = await http.get(
    uri,
    headers: headers,
  );

  int statusCode = response.statusCode;
  if (statusCode >= 200 && statusCode < 300) {
    print('Status Code: $statusCode');
    print('Response Body: ${response.body}');
  } else {
    print('Error Status Code: $statusCode');
    print('Error Response Body: ${response.body}');
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartHttp, requestModelGet11, "https"),
          expectedCode);
    });

    test('GET 12', () {
      const expectedCode = r"""import 'package:http/http.dart' as http;

void main() async {
  var uri = Uri.parse('https://api.apidash.dev/humanize/social');

  final response = await http.get(uri);

  int statusCode = response.statusCode;
  if (statusCode >= 200 && statusCode < 300) {
    print('Status Code: $statusCode');
    print('Response Body: ${response.body}');
  } else {
    print('Error Status Code: $statusCode');
    print('Error Response Body: ${response.body}');
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartHttp, requestModelGet12, "https"),
          expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""import 'package:http/http.dart' as http;

void main() async {
  var uri = Uri.parse('https://api.apidash.dev');

  final response = await http.head(uri);

  int statusCode = response.statusCode;
  if (statusCode >= 200 && statusCode < 300) {
    print('Status Code: $statusCode');
    print('Response Body: ${response.body}');
  } else {
    print('Error Status Code: $statusCode');
    print('Error Response Body: ${response.body}');
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartHttp, requestModelHead1, "https"),
          expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""import 'package:http/http.dart' as http;

void main() async {
  var uri = Uri.parse('http://api.apidash.dev');

  final response = await http.head(uri);

  int statusCode = response.statusCode;
  if (statusCode >= 200 && statusCode < 300) {
    print('Status Code: $statusCode');
    print('Response Body: ${response.body}');
  } else {
    print('Error Status Code: $statusCode');
    print('Error Response Body: ${response.body}');
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartHttp, requestModelHead2, "http"),
          expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r"""import 'package:http/http.dart' as http;

void main() async {
  var uri = Uri.parse('https://api.apidash.dev/case/lower');

  String body = r'''{
"text": "I LOVE Flutter"
}''';

  var headers = {'content-type': 'text/plain'};

  final response = await http.post(
    uri,
    headers: headers,
    body: body,
  );

  int statusCode = response.statusCode;
  if (statusCode >= 200 && statusCode < 300) {
    print('Status Code: $statusCode');
    print('Response Body: ${response.body}');
  } else {
    print('Error Status Code: $statusCode');
    print('Error Response Body: ${response.body}');
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartHttp, requestModelPost1, "https"),
          expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r"""import 'package:http/http.dart' as http;

void main() async {
  var uri = Uri.parse('https://api.apidash.dev/case/lower');

  String body = r'''{
"text": "I LOVE Flutter",
"flag": null,
"male": true,
"female": false,
"no": 1.2,
"arr": ["null", "true", "false", null]
}''';

  var headers = {'content-type': 'application/json'};

  final response = await http.post(
    uri,
    headers: headers,
    body: body,
  );

  int statusCode = response.statusCode;
  if (statusCode >= 200 && statusCode < 300) {
    print('Status Code: $statusCode');
    print('Response Body: ${response.body}');
  } else {
    print('Error Status Code: $statusCode');
    print('Error Response Body: ${response.body}');
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartHttp, requestModelPost2, "https"),
          expectedCode);
    });

    test('POST 3', () {
      const expectedCode = r"""import 'package:http/http.dart' as http;

void main() async {
  var uri = Uri.parse('https://api.apidash.dev/case/lower');

  String body = r'''{
"text": "I LOVE Flutter"
}''';

  var headers = {
    'User-Agent': 'Test Agent',
    'content-type': 'application/json',
  };

  final response = await http.post(
    uri,
    headers: headers,
    body: body,
  );

  int statusCode = response.statusCode;
  if (statusCode >= 200 && statusCode < 300) {
    print('Status Code: $statusCode');
    print('Response Body: ${response.body}');
  } else {
    print('Error Status Code: $statusCode');
    print('Error Response Body: ${response.body}');
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartHttp, requestModelPost3, "https"),
          expectedCode);
    });
    test('POST 4', () {
      const expectedCode = r"""import 'package:http/http.dart' as http;

void main() async {
  var uri = Uri.parse('https://api.apidash.dev/io/form');

  final formDataList = [
    {"name": "text", "value": "API", "type": "text"},
    {"name": "sep", "value": "|", "type": "text"},
    {"name": "times", "value": "3", "type": "text"}
  ];
  final request = http.MultipartRequest(
    "POST",
    uri,
  );
  for (var formData in formDataList) {
    if (formData != null) {
      final name = formData['name'];
      final value = formData['value'];
      final type = formData['type'];

      if (name != null && value != null && type != null) {
        if (type == 'text') {
          request.fields.addAll({name: value});
        } else {
          request.files.add(
            await http.MultipartFile.fromPath(
              name,
              value,
            ),
          );
        }
      } else {
        print('Error: formData has null name, value, or type.');
      }
    } else {
      print('Error: formData is null.');
    }
  }

  final response = await request.send();
  final responseBody = await response.stream.bytesToString();
  int statusCode = response.statusCode;

  if (statusCode >= 200 && statusCode < 300) {
    print('Status Code: $statusCode');
    print('Response Body: :$responseBody');
  } else {
    print('Error Status Code: $statusCode');
    print('Error Response Body: :$responseBody');
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartHttp, requestModelPost4, "https"),
          expectedCode);
    });
    test('POST 5', () {
      const expectedCode = r"""import 'package:http/http.dart' as http;

void main() async {
  var uri = Uri.parse('https://api.apidash.dev/io/form');

  var headers = {'User-Agent': 'Test Agent'};

  final formDataList = [
    {"name": "text", "value": "API", "type": "text"},
    {"name": "sep", "value": "|", "type": "text"},
    {"name": "times", "value": "3", "type": "text"}
  ];
  final request = http.MultipartRequest(
    "POST",
    uri,
  );
  for (var formData in formDataList) {
    if (formData != null) {
      final name = formData['name'];
      final value = formData['value'];
      final type = formData['type'];

      if (name != null && value != null && type != null) {
        if (type == 'text') {
          request.fields.addAll({name: value});
        } else {
          request.files.add(
            await http.MultipartFile.fromPath(
              name,
              value,
            ),
          );
        }
      } else {
        print('Error: formData has null name, value, or type.');
      }
    } else {
      print('Error: formData is null.');
    }
  }

  request.headers.addAll(headers);
  final response = await request.send();
  final responseBody = await response.stream.bytesToString();
  int statusCode = response.statusCode;

  if (statusCode >= 200 && statusCode < 300) {
    print('Status Code: $statusCode');
    print('Response Body: :$responseBody');
  } else {
    print('Error Status Code: $statusCode');
    print('Error Response Body: :$responseBody');
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartHttp, requestModelPost5, "https"),
          expectedCode);
    });
    test('POST 6', () {
      const expectedCode = r"""import 'package:http/http.dart' as http;

void main() async {
  var uri = Uri.parse('https://api.apidash.dev/io/img');

  final formDataList = [
    {"name": "token", "value": "xyz", "type": "text"},
    {"name": "imfile", "value": "/Documents/up/1.png", "type": "file"}
  ];
  final request = http.MultipartRequest(
    "POST",
    uri,
  );
  for (var formData in formDataList) {
    if (formData != null) {
      final name = formData['name'];
      final value = formData['value'];
      final type = formData['type'];

      if (name != null && value != null && type != null) {
        if (type == 'text') {
          request.fields.addAll({name: value});
        } else {
          request.files.add(
            await http.MultipartFile.fromPath(
              name,
              value,
            ),
          );
        }
      } else {
        print('Error: formData has null name, value, or type.');
      }
    } else {
      print('Error: formData is null.');
    }
  }

  final response = await request.send();
  final responseBody = await response.stream.bytesToString();
  int statusCode = response.statusCode;

  if (statusCode >= 200 && statusCode < 300) {
    print('Status Code: $statusCode');
    print('Response Body: :$responseBody');
  } else {
    print('Error Status Code: $statusCode');
    print('Error Response Body: :$responseBody');
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartHttp, requestModelPost6, "https"),
          expectedCode);
    });
    test('POST 7', () {
      const expectedCode = r"""import 'package:http/http.dart' as http;

void main() async {
  var uri = Uri.parse('https://api.apidash.dev/io/img');

  final formDataList = [
    {"name": "token", "value": "xyz", "type": "text"},
    {"name": "imfile", "value": "/Documents/up/1.png", "type": "file"}
  ];
  final request = http.MultipartRequest(
    "POST",
    uri,
  );
  for (var formData in formDataList) {
    if (formData != null) {
      final name = formData['name'];
      final value = formData['value'];
      final type = formData['type'];

      if (name != null && value != null && type != null) {
        if (type == 'text') {
          request.fields.addAll({name: value});
        } else {
          request.files.add(
            await http.MultipartFile.fromPath(
              name,
              value,
            ),
          );
        }
      } else {
        print('Error: formData has null name, value, or type.');
      }
    } else {
      print('Error: formData is null.');
    }
  }

  final response = await request.send();
  final responseBody = await response.stream.bytesToString();
  int statusCode = response.statusCode;

  if (statusCode >= 200 && statusCode < 300) {
    print('Status Code: $statusCode');
    print('Response Body: :$responseBody');
  } else {
    print('Error Status Code: $statusCode');
    print('Error Response Body: :$responseBody');
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartHttp, requestModelPost7, "https"),
          expectedCode);
    });
    test('POST 8', () {
      const expectedCode = r"""import 'package:http/http.dart' as http;

void main() async {
  var uri = Uri.parse('https://api.apidash.dev/io/form');

  var queryParams = {
    'size': '2',
    'len': '3',
  };
  uri = uri.replace(queryParameters: queryParams);

  final formDataList = [
    {"name": "text", "value": "API", "type": "text"},
    {"name": "sep", "value": "|", "type": "text"},
    {"name": "times", "value": "3", "type": "text"}
  ];
  final request = http.MultipartRequest(
    "POST",
    uri,
  );
  for (var formData in formDataList) {
    if (formData != null) {
      final name = formData['name'];
      final value = formData['value'];
      final type = formData['type'];

      if (name != null && value != null && type != null) {
        if (type == 'text') {
          request.fields.addAll({name: value});
        } else {
          request.files.add(
            await http.MultipartFile.fromPath(
              name,
              value,
            ),
          );
        }
      } else {
        print('Error: formData has null name, value, or type.');
      }
    } else {
      print('Error: formData is null.');
    }
  }

  final response = await request.send();
  final responseBody = await response.stream.bytesToString();
  int statusCode = response.statusCode;

  if (statusCode >= 200 && statusCode < 300) {
    print('Status Code: $statusCode');
    print('Response Body: :$responseBody');
  } else {
    print('Error Status Code: $statusCode');
    print('Error Response Body: :$responseBody');
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartHttp, requestModelPost8, "https"),
          expectedCode);
    });
    test('POST 9', () {
      const expectedCode = r"""import 'package:http/http.dart' as http;

void main() async {
  var uri = Uri.parse('https://api.apidash.dev/io/img');

  var queryParams = {
    'size': '2',
    'len': '3',
  };
  uri = uri.replace(queryParameters: queryParams);

  var headers = {
    'User-Agent': 'Test Agent',
    'Keep-Alive': 'true',
  };

  final formDataList = [
    {"name": "token", "value": "xyz", "type": "text"},
    {"name": "imfile", "value": "/Documents/up/1.png", "type": "file"}
  ];
  final request = http.MultipartRequest(
    "POST",
    uri,
  );
  for (var formData in formDataList) {
    if (formData != null) {
      final name = formData['name'];
      final value = formData['value'];
      final type = formData['type'];

      if (name != null && value != null && type != null) {
        if (type == 'text') {
          request.fields.addAll({name: value});
        } else {
          request.files.add(
            await http.MultipartFile.fromPath(
              name,
              value,
            ),
          );
        }
      } else {
        print('Error: formData has null name, value, or type.');
      }
    } else {
      print('Error: formData is null.');
    }
  }

  request.headers.addAll(headers);
  final response = await request.send();
  final responseBody = await response.stream.bytesToString();
  int statusCode = response.statusCode;

  if (statusCode >= 200 && statusCode < 300) {
    print('Status Code: $statusCode');
    print('Response Body: :$responseBody');
  } else {
    print('Error Status Code: $statusCode');
    print('Error Response Body: :$responseBody');
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartHttp, requestModelPost9, "https"),
          expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT 1', () {
      const expectedCode = r"""import 'package:http/http.dart' as http;

void main() async {
  var uri = Uri.parse('https://reqres.in/api/users/2');

  String body = r'''{
"name": "morpheus",
"job": "zion resident"
}''';

  var headers = {'content-type': 'application/json'};

  final response = await http.put(
    uri,
    headers: headers,
    body: body,
  );

  int statusCode = response.statusCode;
  if (statusCode >= 200 && statusCode < 300) {
    print('Status Code: $statusCode');
    print('Response Body: ${response.body}');
  } else {
    print('Error Status Code: $statusCode');
    print('Error Response Body: ${response.body}');
  }
}
""";
      expect(
          codeGen.getCode(CodegenLanguage.dartHttp, requestModelPut1, "https"),
          expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH 1', () {
      const expectedCode = r"""import 'package:http/http.dart' as http;

void main() async {
  var uri = Uri.parse('https://reqres.in/api/users/2');

  String body = r'''{
"name": "marfeus",
"job": "accountant"
}''';

  var headers = {'content-type': 'application/json'};

  final response = await http.patch(
    uri,
    headers: headers,
    body: body,
  );

  int statusCode = response.statusCode;
  if (statusCode >= 200 && statusCode < 300) {
    print('Status Code: $statusCode');
    print('Response Body: ${response.body}');
  } else {
    print('Error Status Code: $statusCode');
    print('Error Response Body: ${response.body}');
  }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.dartHttp, requestModelPatch1, "https"),
          expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode = r"""import 'package:http/http.dart' as http;

void main() async {
  var uri = Uri.parse('https://reqres.in/api/users/2');

  final response = await http.delete(uri);

  int statusCode = response.statusCode;
  if (statusCode >= 200 && statusCode < 300) {
    print('Status Code: $statusCode');
    print('Response Body: ${response.body}');
  } else {
    print('Error Status Code: $statusCode');
    print('Error Response Body: ${response.body}');
  }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.dartHttp, requestModelDelete1, "https"),
          expectedCode);
    });

    test('DELETE 2', () {
      const expectedCode = r"""import 'package:http/http.dart' as http;

void main() async {
  var uri = Uri.parse('https://reqres.in/api/users/2');

  String body = r'''{
"name": "marfeus",
"job": "accountant"
}''';

  var headers = {'content-type': 'application/json'};

  final response = await http.delete(
    uri,
    headers: headers,
    body: body,
  );

  int statusCode = response.statusCode;
  if (statusCode >= 200 && statusCode < 300) {
    print('Status Code: $statusCode');
    print('Response Body: ${response.body}');
  } else {
    print('Error Status Code: $statusCode');
    print('Error Response Body: ${response.body}');
  }
}
""";
      expect(
          codeGen.getCode(
              CodegenLanguage.dartHttp, requestModelDelete2, "https"),
          expectedCode);
    });
  });
}
