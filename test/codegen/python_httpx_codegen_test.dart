import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';
import '../models/request_models.dart';

void main() {
  final codeGen = Codegen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""import httpx
url = 'https://api.apidash.dev'
response = httpx.get(url)

print('Status Code:', response.status_code)
print('Response Body:', response.text)
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.pythonHttpx,
            requestModelGet1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r"""import httpx
url = 'https://api.apidash.dev/country/data'
params = {
  "code": "US"
}
response = httpx.get(url, params=params)

print('Status Code:', response.status_code)
print('Response Body:', response.text)
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.pythonHttpx,
            requestModelGet2,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r"""import httpx
url = 'https://api.apidash.dev/case/lower'
payload = r'''{
"text": "I LOVE Flutter"
}'''
headers = {
  "Content-Type": "text/plain"
}
response = httpx.post(url, content=payload, headers=headers)

print('Status Code:', response.status_code)
print('Response Body:', response.text)
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.pythonHttpx,
            requestModelPost1,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r"""import httpx
url = 'https://api.apidash.dev/case/lower'
payload = {
"text": "I LOVE Flutter",
"flag": None,
"male": True,
"female": False,
"no": 1.2,
"arr": ["null", "true", "false", None]
}
response = httpx.post(url, json=payload)

print('Status Code:', response.status_code)
print('Response Body:', response.text)
""";
      expect(
          codeGen.getCode(
            CodegenLanguage.pythonHttpx,
            requestModelPost2,
            SupportedUriSchemes.https,
          ),
          expectedCode);
    });
  });
}
