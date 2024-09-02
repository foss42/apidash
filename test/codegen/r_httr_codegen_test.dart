import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:test/test.dart';
import '../models/request_models.dart';

void main() {
  final codeGen = Codegen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""library(httr)

request <- httr::VERB(
  'GET',
  url = 'https://api.apidash.dev')
response <- request

print(status_code(response))
print(content(response))
""";
      expect(codeGen.getCode(CodegenLanguage.rHttr, requestModelGet1, "https"),
          expectedCode);
    });

    test('GET 2', () {
      const expectedCode = r"""library(httr)

request <- httr::VERB(
  'GET',
  url = 'https://api.apidash.dev/country/data',
  query = list("code" = "US"))
response <- request

print(status_code(response))
print(content(response))
""";
      expect(codeGen.getCode(CodegenLanguage.rHttr, requestModelGet2, "https"),
          expectedCode);
    });

    test('GET 3', () {
      const expectedCode = r"""library(httr)

request <- httr::VERB(
  'GET',
  url = 'https://api.apidash.dev/country/data',
  query = list("code" = "IND"))
response <- request

print(status_code(response))
print(content(response))
""";
      expect(codeGen.getCode(CodegenLanguage.rHttr, requestModelGet3, "https"),
          expectedCode);
    });

    test('GET 4', () {
      const expectedCode = r"""library(httr)

request <- httr::VERB(
  'GET',
  url = 'https://api.apidash.dev/humanize/social',
  query = list("num" = "8700000", "digits" = "3", "system" = "SS", "add_space" = "true", "trailing_zeros" = "true"))
response <- request

print(status_code(response))
print(content(response))
""";
      expect(codeGen.getCode(CodegenLanguage.rHttr, requestModelGet4, "https"),
          expectedCode);
    });

    test('GET 5', () {
      const expectedCode = r"""library(httr)

request <- httr::VERB(
  'GET',
  url = 'https://api.github.com/repos/foss42/apidash',
  add_headers("User-Agent" = "Test Agent"))
response <- request

print(status_code(response))
print(content(response))
""";
      expect(codeGen.getCode(CodegenLanguage.rHttr, requestModelGet5, "https"),
          expectedCode);
    });

    test('GET 6', () {
      const expectedCode = r"""library(httr)

request <- httr::VERB(
  'GET',
  url = 'https://api.github.com/repos/foss42/apidash',
  query = list("raw" = "true"),
  add_headers("User-Agent" = "Test Agent"))
response <- request

print(status_code(response))
print(content(response))
""";
      expect(codeGen.getCode(CodegenLanguage.rHttr, requestModelGet6, "https"),
          expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r"""library(httr)

request <- httr::VERB(
  'GET',
  url = 'https://api.apidash.dev')
response <- request

print(status_code(response))
print(content(response))
""";
      expect(codeGen.getCode(CodegenLanguage.rHttr, requestModelGet7, "https"),
          expectedCode);
    });

    test('GET 8', () {
      const expectedCode = r"""library(httr)

request <- httr::VERB(
  'GET',
  url = 'https://api.github.com/repos/foss42/apidash',
  query = list("raw" = "true"),
  add_headers("User-Agent" = "Test Agent"))
response <- request

print(status_code(response))
print(content(response))
""";
      expect(codeGen.getCode(CodegenLanguage.rHttr, requestModelGet8, "https"),
          expectedCode);
    });

    test('GET 9', () {
      const expectedCode = r"""library(httr)

request <- httr::VERB(
  'GET',
  url = 'https://api.apidash.dev/humanize/social',
  query = list("num" = "8700000", "add_space" = "true"))
response <- request

print(status_code(response))
print(content(response))
""";
      expect(codeGen.getCode(CodegenLanguage.rHttr, requestModelGet9, "https"),
          expectedCode);
    });

    test('GET 10', () {
      const expectedCode = r"""library(httr)

request <- httr::VERB(
  'GET',
  url = 'https://api.apidash.dev/humanize/social',
  add_headers("User-Agent" = "Test Agent"))
response <- request

print(status_code(response))
print(content(response))
""";
      expect(codeGen.getCode(CodegenLanguage.rHttr, requestModelGet10, "https"),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode = r"""library(httr)

request <- httr::VERB(
  'GET',
  url = 'https://api.apidash.dev/humanize/social',
  query = list("num" = "8700000", "digits" = "3"),
  add_headers("User-Agent" = "Test Agent"))
response <- request

print(status_code(response))
print(content(response))
""";
      expect(codeGen.getCode(CodegenLanguage.rHttr, requestModelGet11, "https"),
          expectedCode);
    });

    test('GET 12', () {
      const expectedCode = r"""library(httr)

request <- httr::VERB(
  'GET',
  url = 'https://api.apidash.dev/humanize/social')
response <- request

print(status_code(response))
print(content(response))
""";
      expect(codeGen.getCode(CodegenLanguage.rHttr, requestModelGet12, "https"),
          expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""library(httr)

request <- httr::VERB(
  'HEAD',
  url = 'https://api.apidash.dev')
response <- request

print(status_code(response))
print(content(response))
""";
      expect(codeGen.getCode(CodegenLanguage.rHttr, requestModelHead1, "https"),
          expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""library(httr)

request <- httr::VERB(
  'HEAD',
  url = 'http://api.apidash.dev')
response <- request

print(status_code(response))
print(content(response))
""";
      expect(codeGen.getCode(CodegenLanguage.rHttr, requestModelHead2, "http"),
          expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r"""library(httr)

request <- httr::VERB(
  'POST',
  url = 'https://api.apidash.dev/case/lower',
  add_headers("Content-Type" = "text/plain"),
  body = "{
\"text\": \"I LOVE Flutter\"
}")
response <- request

print(status_code(response))
print(content(response))
""";
      expect(codeGen.getCode(CodegenLanguage.rHttr, requestModelPost1, "https"),
          expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r"""library(httr)

request <- httr::VERB(
  'POST',
  url = 'https://api.apidash.dev/case/lower',
  add_headers("Content-Type" = "application/json"),
  body = "{
\"text\": \"I LOVE Flutter\",
\"flag\": null,
\"male\": true,
\"female\": false,
\"no\": 1.2,
\"arr\": [\"null\", \"true\", \"false\", null]
}")
response <- request

print(status_code(response))
print(content(response))
""";
      expect(codeGen.getCode(CodegenLanguage.rHttr, requestModelPost2, "https"),
          expectedCode);
    });

    test('POST 3', () {
      const expectedCode = r"""library(httr)

request <- httr::VERB(
  'POST',
  url = 'https://api.apidash.dev/case/lower',
  add_headers("Content-Type" = "application/json", "User-Agent" = "Test Agent"),
  body = "{
\"text\": \"I LOVE Flutter\"
}")
response <- request

print(status_code(response))
print(content(response))
""";
      expect(codeGen.getCode(CodegenLanguage.rHttr, requestModelPost3, "https"),
          expectedCode);
    });

    test('POST 4', () {
      const expectedCode = r"""library(httr)

request <- httr::VERB(
  'POST',
  url = 'https://api.apidash.dev/io/form',
  add_headers("Content-Type" = "multipart/form-data"),
  body = "text" = ""API"".replaceAll(', '\), "sep" = ""|"".replaceAll(', '\), "times" = ""3"".replaceAll(', '\))
response <- request

print(status_code(response))
print(content(response))
""";
      expect(codeGen.getCode(CodegenLanguage.rHttr, requestModelPost4, "https"),
          expectedCode);
    });

    test('POST 5', () {
      const expectedCode = r"""library(httr)

request <- httr::VERB(
  'POST',
  url = 'https://api.apidash.dev/io/form',
  add_headers("Content-Type" = "multipart/form-data", "User-Agent" = "Test Agent"),
  body = "text" = ""API"".replaceAll(', '\), "sep" = ""|"".replaceAll(', '\), "times" = ""3"".replaceAll(', '\))
response <- request

print(status_code(response))
print(content(response))
""";
      expect(codeGen.getCode(CodegenLanguage.rHttr, requestModelPost5, "https"),
          expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT 1', () {
      const expectedCode = r"""library(httr)

request <- httr::VERB(
  'PUT',
  url = 'https://reqres.in/api/users/2',
  add_headers("Content-Type" = "application/json"),
  body = "{
\"name\": \"morpheus\",
\"job\": \"zion resident\"
}")
response <- request

print(status_code(response))
print(content(response))
""";
      expect(codeGen.getCode(CodegenLanguage.rHttr, requestModelPut1, "https"),
          expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH 1', () {
      const expectedCode = r"""library(httr)

request <- httr::VERB(
  'PATCH',
  url = 'https://reqres.in/api/users/2',
  add_headers("Content-Type" = "application/json"),
  body = "{
\"name\": \"marfeus\",
\"job\": \"accountant\"
}")
response <- request

print(status_code(response))
print(content(response))
""";
      expect(
          codeGen.getCode(CodegenLanguage.rHttr, requestModelPatch1, "https"),
          expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode = r"""library(httr)

request <- httr::VERB(
  'DELETE',
  url = 'https://reqres.in/api/users/2')
response <- request

print(status_code(response))
print(content(response))
""";
      expect(
          codeGen.getCode(CodegenLanguage.rHttr, requestModelDelete1, "https"),
          expectedCode);
    });

    test('DELETE 2', () {
      const expectedCode = r"""library(httr)

request <- httr::VERB(
  'DELETE',
  url = 'https://reqres.in/api/users/2',
  add_headers("Content-Type" = "application/json"),
  body = "{
\"name\": \"marfeus\",
\"job\": \"accountant\"
}")
response <- request

print(status_code(response))
print(content(response))
""";
      expect(
          codeGen.getCode(CodegenLanguage.rHttr, requestModelDelete2, "https"),
          expectedCode);
    });
  });
}
