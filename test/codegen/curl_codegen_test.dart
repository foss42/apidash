import 'package:test/test.dart';
import 'package:apidash/codegen/others/curl.dart';
import '../request_models.dart';

void main() {
  final curlCodeGen = cURLCodeGen();

  group('GET Request', () {
    test('GET 1', () {
      const expectedCode = r"""curl --url 'https://api.apidash.dev'""";
      expect(curlCodeGen.getCode(requestModelGet1, "https"), expectedCode);
    });

    test('GET 2', () {
      const expectedCode =
          r"""curl --url 'https://api.apidash.dev/country/data?code=US'""";
      expect(curlCodeGen.getCode(requestModelGet2, "https"), expectedCode);
    });

    test('GET 3', () {
      const expectedCode =
          r"""curl --url 'https://api.apidash.dev/country/data?code=IND'""";
      expect(curlCodeGen.getCode(requestModelGet3, "https"), expectedCode);
    });

    test('GET 4', () {
      const expectedCode =
          r"""curl --url 'https://api.apidash.dev/humanize/social?num=8700000&digits=3&system=SS&add_space=true&trailing_zeros=true'""";
      expect(curlCodeGen.getCode(requestModelGet4, "https"), expectedCode);
    });

    test('GET 5', () {
      const expectedCode =
          r"""curl --url 'https://api.github.com/repos/foss42/apidash' \
  --header 'User-Agent: Test Agent'""";
      expect(curlCodeGen.getCode(requestModelGet5, "https"), expectedCode);
    });

    test('GET 6', () {
      const expectedCode =
          r"""curl --url 'https://api.github.com/repos/foss42/apidash?raw=true' \
  --header 'User-Agent: Test Agent'""";
      expect(curlCodeGen.getCode(requestModelGet6, "https"), expectedCode);
    });

    test('GET 7', () {
      const expectedCode = r"""curl --url 'https://api.apidash.dev'""";
      expect(curlCodeGen.getCode(requestModelGet7, "https"), expectedCode);
    });

    test('GET 8', () {
      const expectedCode =
          r"""curl --url 'https://api.github.com/repos/foss42/apidash?raw=true' \
  --header 'User-Agent: Test Agent'""";
      expect(curlCodeGen.getCode(requestModelGet8, "https"), expectedCode);
    });

    test('GET 9', () {
      const expectedCode =
          r"""curl --url 'https://api.apidash.dev/humanize/social?num=8700000&add_space=true'""";
      expect(curlCodeGen.getCode(requestModelGet9, "https"), expectedCode);
    });

    test('GET 10', () {
      const expectedCode =
          r"""curl --url 'https://api.apidash.dev/humanize/social' \
  --header 'User-Agent: Test Agent'""";
      expect(
          curlCodeGen.getCode(
            requestModelGet10,
            "https",
          ),
          expectedCode);
    });

    test('GET 11', () {
      const expectedCode =
          r"""curl --url 'https://api.apidash.dev/humanize/social?num=8700000&digits=3' \
  --header 'User-Agent: Test Agent'""";
      expect(curlCodeGen.getCode(requestModelGet11, "https"), expectedCode);
    });

    test('GET 12', () {
      const expectedCode =
          r"""curl --url 'https://api.apidash.dev/humanize/social'""";
      expect(curlCodeGen.getCode(requestModelGet12, "https"), expectedCode);
    });
  });

  group('HEAD Request', () {
    test('HEAD 1', () {
      const expectedCode = r"""curl --head --url 'https://api.apidash.dev'""";
      expect(curlCodeGen.getCode(requestModelHead1, "https"), expectedCode);
    });

    test('HEAD 2', () {
      const expectedCode = r"""curl --head --url 'http://api.apidash.dev'""";
      expect(curlCodeGen.getCode(requestModelHead2, "http"), expectedCode);
    });
  });

  group('POST Request', () {
    test('POST 1', () {
      const expectedCode = r"""curl --request POST \
  --url 'https://api.apidash.dev/case/lower' \
  --header 'Content-Type: text/plain' \
  --data '{
"text": "I LOVE Flutter"
}'""";
      expect(curlCodeGen.getCode(requestModelPost1, "https"), expectedCode);
    });

    test('POST 2', () {
      const expectedCode = r"""curl --request POST \
  --url 'https://api.apidash.dev/case/lower' \
  --header 'Content-Type: application/json' \
  --data '{
"text": "I LOVE Flutter"
}'""";
      expect(curlCodeGen.getCode(requestModelPost2, "https"), expectedCode);
    });

    test('POST 3', () {
      const expectedCode = r"""curl --request POST \
  --url 'https://api.apidash.dev/case/lower' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: Test Agent' \
  --data '{
"text": "I LOVE Flutter"
}'""";
      expect(curlCodeGen.getCode(requestModelPost3, "https"), expectedCode);
    });

    test('POST 4', () {
      const expectedCode = r"""curl --request POST \
  --url 'https://api.apidash.dev/io/form' \
  --form 'text=API' \
  --form 'sep=|' \
  --form 'times=3'""";
      expect(curlCodeGen.getCode(requestModelPost4, "https"), expectedCode);
    });

    test('POST 5', () {
      const expectedCode = r"""curl --request POST \
  --url 'https://api.apidash.dev/io/form' \
  --header 'User-Agent: Test Agent' \
  --form 'text=API' \
  --form 'sep=|' \
  --form 'times=3'""";
      expect(curlCodeGen.getCode(requestModelPost5, "https"), expectedCode);
    });

    test('POST 6', () {
      const expectedCode = r"""curl --request POST \
  --url 'https://api.apidash.dev/io/img' \
  --form 'token=xyz' \
  --form 'imfile=@/Documents/up/1.png'""";
      expect(curlCodeGen.getCode(requestModelPost6, "https"), expectedCode);
    });

    test('POST 7', () {
      const expectedCode = r"""curl --request POST \
  --url 'https://api.apidash.dev/io/img' \
  --form 'token=xyz' \
  --form 'imfile=@/Documents/up/1.png'""";
      expect(curlCodeGen.getCode(requestModelPost7, "https"), expectedCode);
    });

    test('POST 8', () {
      const expectedCode = r"""curl --request POST \
  --url 'https://api.apidash.dev/io/form?size=2&len=3' \
  --form 'text=API' \
  --form 'sep=|' \
  --form 'times=3'""";
      expect(curlCodeGen.getCode(requestModelPost8, "https"), expectedCode);
    });

    test('POST 9', () {
      const expectedCode = r"""curl --request POST \
  --url 'https://api.apidash.dev/io/img?size=2&len=3' \
  --header 'User-Agent: Test Agent' \
  --header 'Keep-Alive: true' \
  --form 'token=xyz' \
  --form 'imfile=@/Documents/up/1.png'""";
      expect(curlCodeGen.getCode(requestModelPost9, "https"), expectedCode);
    });
  });

  group('PUT Request', () {
    test('PUT 1', () {
      const expectedCode = r"""curl --request PUT \
  --url 'https://reqres.in/api/users/2' \
  --header 'Content-Type: application/json' \
  --data '{
"name": "morpheus",
"job": "zion resident"
}'""";
      expect(curlCodeGen.getCode(requestModelPut1, "https"), expectedCode);
    });
  });

  group('PATCH Request', () {
    test('PATCH 1', () {
      const expectedCode = r"""curl --request PATCH \
  --url 'https://reqres.in/api/users/2' \
  --header 'Content-Type: application/json' \
  --data '{
"name": "marfeus",
"job": "accountant"
}'""";
      expect(curlCodeGen.getCode(requestModelPatch1, "https"), expectedCode);
    });
  });

  group('DELETE Request', () {
    test('DELETE 1', () {
      const expectedCode = r"""curl --request DELETE \
  --url 'https://reqres.in/api/users/2'""";
      expect(curlCodeGen.getCode(requestModelDelete1, "https"), expectedCode);
    });

    test('DELETE 2', () {
      const expectedCode = r"""curl --request DELETE \
  --url 'https://reqres.in/api/users/2' \
  --header 'Content-Type: application/json' \
  --data '{
"name": "marfeus",
"job": "accountant"
}'""";
      expect(curlCodeGen.getCode(requestModelDelete2, "https"), expectedCode);
    });
  });
}
