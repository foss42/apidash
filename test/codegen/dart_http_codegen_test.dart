import 'package:apidash/codegen/dart/pkg_http.dart';
import 'package:test/test.dart';
import '../request_models.dart';

void main() {
  final dartHttpCodeGen = DartHttpCodeGen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""
""";
      expect(dartHttpCodeGen.getCode(requestModelGet1, "https"), expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r"""
""";
      expect(dartHttpCodeGen.getCode(requestModelGet2, "https"), expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""
""";
      expect(dartHttpCodeGen.getCode(requestModelHead1, "https"), expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""
""";
      expect(dartHttpCodeGen.getCode(requestModelHead2, "http"), expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r"""import 'package:http/http.dart' as http;

void main() async {
  var uri = Uri.parse('https://api.foss42.com/case/lower');

  String body = r'''{
"text":"lower I FLUTTER"
}''';

  var headers = {
                  "content-type": "application/json"
                };

  final response = await http.post(uri,
                                  headers: headers,
                                  body: body);

  int statusCode = response.statusCode;
  if (statusCode >= 200 && statusCode < 300) {
    print('Status Code: $statusCode');
    print('Response Body: ${response.body}');
  }
  else{
    print('Error Status Code: $statusCode');
    print('Error Response Body: ${response.body}');
  }
}
""";
      expect(dartHttpCodeGen.getCode(requestModelPost1, "https"), expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r"""
""";
      expect(dartHttpCodeGen.getCode(requestModelPost2, "https"), expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode = r"""
""";
      expect(
          dartHttpCodeGen.getCode(requestModelDelete1, "https"), expectedCode);
    });
  });
}
