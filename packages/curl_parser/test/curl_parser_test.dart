import 'dart:io';
import 'package:curl_parser/curl_parser.dart';
import 'package:seed/seed.dart';
import 'package:test/test.dart';

final apiUri = Uri.parse('https://api.apidash.dev');

void main() {
  test(
    'parse an easy cURL',
    () async {
      expect(
        Curl.parse('curl -X GET https://api.apidash.dev'),
        Curl(
          method: 'GET',
          uri: apiUri,
        ),
      );
    },
  );

  test(
    'parse another easy cURL',
    () async {
      expect(
        Curl.parse(
            r"""curl --location --request GET 'https://dummyimage.com/150/92c952' \
--header 'user-agent: Dart/3.8 (dart:io)' \
--header 'accept-encoding: gzip' \
--header 'content-length: 0' \
--header 'host: dummyimage.com'"""),
        Curl(
            method: 'GET',
            uri: Uri.parse('https://dummyimage.com/150/92c952'),
            headers: {
              'user-agent': 'Dart/3.8 (dart:io)',
              'accept-encoding': 'gzip',
              'content-length': '0',
              'host': 'dummyimage.com'
            },
            location: true),
      );
    },
  );

  test('parse POST request with multipart/form-data', () {
    const curl = r'''curl -X POST 'https://api.apidash.dev/io/img' \
      -H 'Content-Type: multipart/form-data' \
      -F "imfile=@/path/to/image.jpg" \
      -F "token=john"
      ''';

    expect(
      Curl.parse(curl),
      Curl(
        method: 'POST',
        uri: Uri.parse('https://api.apidash.dev/io/img'),
        headers: {"Content-Type": "multipart/form-data"},
        form: true,
        formData: [
          FormDataModel(
            name: "imfile",
            value: "/path/to/image.jpg",
            type: FormDataType.file,
          ),
          FormDataModel(
            name: "token",
            value: "john",
            type: FormDataType.text,
          )
        ],
      ),
    );
  });

  test(
      'parse POST request with multipart/form-data if not specified in headers',
      () {
    const curl = r'''curl -X POST 'https://api.apidash.dev/io/img' \
      -F "imfile=@/path/to/image.jpg" \
      -F "token=john"
      ''';

    expect(
      Curl.parse(curl),
      Curl(
        method: 'POST',
        uri: Uri.parse('https://api.apidash.dev/io/img'),
        headers: {"Content-Type": "multipart/form-data"},
        form: true,
        formData: [
          FormDataModel(
            name: "imfile",
            value: "/path/to/image.jpg",
            type: FormDataType.file,
          ),
          FormDataModel(
            name: "token",
            value: "john",
            type: FormDataType.text,
          )
        ],
      ),
    );
  });

  test(
      'parse POST request with multipart/form-data but some other content type provided by user',
      () {
    const curl = r'''curl -X POST 'https://api.apidash.dev/io/img' \
      -H 'content-type: some-data' \
      -F "imfile=@/path/to/image.jpg" \
      -F "token=john"
      ''';

    expect(
      Curl.parse(curl),
      Curl(
        method: 'POST',
        uri: Uri.parse('https://api.apidash.dev/io/img'),
        headers: {"content-type": "some-data"},
        form: true,
        formData: [
          FormDataModel(
            name: "imfile",
            value: "/path/to/image.jpg",
            type: FormDataType.file,
          ),
          FormDataModel(
            name: "token",
            value: "john",
            type: FormDataType.text,
          )
        ],
      ),
    );
  });

  test('parse POST request with x-www-form-urlencoded', () {
    const curl = r'''curl -X 'POST' \
  'https://api.apidash.dev/io/form' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -d 'text=apidash&sep=%7C&times=3'
      ''';

    expect(
      Curl.parse(curl),
      Curl(
        method: 'POST',
        uri: Uri.parse('https://api.apidash.dev/io/form'),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        data: 'text=apidash&sep=%7C&times=3',
      ),
    );
  });

  test('should throw exception when multipart/form-data is not valid', () {
    const curl = r'''curl -X POST https://api.apidash.dev/upload \
  -F "invalid_format" \
  -F "username=john"
  ''';
    expect(() => Curl.parse(curl), throwsException);
  });

  test(
    'Check quotes support for URL string',
    () async {
      expect(
        Curl.parse('curl -X GET "https://api.apidash.dev"'),
        Curl(method: 'GET', uri: apiUri),
      );
    },
  );

  test(
    'parses two headers',
    () async {
      expect(
        Curl.parse(
          'curl -X GET https://api.apidash.dev -H "${HttpHeaders.contentTypeHeader}: ${ContentType.text}" -H "${HttpHeaders.authorizationHeader}: Bearer %token%"',
        ),
        Curl(
          method: 'GET',
          uri: apiUri,
          headers: {
            HttpHeaders.contentTypeHeader: ContentType.text.toString(),
            HttpHeaders.authorizationHeader: 'Bearer %token%',
          },
        ),
      );
    },
  );

  test(
    'parses a lot of headers',
    () async {
      expect(
        Curl.parse(
          r'''curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36" \
        -H "Upgrade-Insecure-Requests: 1" \
        -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7" \
        -H "Accept-Encoding: gzip, deflate, br" \
        -H "Accept-Language: en,en-GB;q=0.9,en-US;q=0.8,ru;q=0.7" \
        -H "Cache-Control: max-age=0" \
        -H "Dnt: 1" \
        -H "Sec-Ch-Ua: \"Google Chrome\";v=\"117\", \"Not;A=Brand\";v=\"8\", \"Chromium\";v=\"117\"" \
        -H "Sec-Ch-Ua-Mobile: ?0" \
        -H "Sec-Ch-Ua-Platform: \"macOS\"" \
        -H "Sec-Fetch-Dest: document" \
        -H "Sec-Fetch-Mode: navigate" \
        -H "Sec-Fetch-Site: same-origin" \
        -H "Sec-Fetch-User: ?1" https://apidash.dev''',
        ),
        Curl(
          method: 'GET',
          uri: Uri.parse('https://apidash.dev'),
          headers: {
            'User-Agent':
                'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36',
            'Upgrade-Insecure-Requests': '1',
            'Accept':
                'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
            'Accept-Encoding': 'gzip, deflate, br',
            'Accept-Language': 'en,en-GB;q=0.9,en-US;q=0.8,ru;q=0.7',
            'Cache-Control': 'max-age=0',
            'Dnt': '1',
            'Sec-Ch-Ua':
                '"Google Chrome";v="117", "Not;A=Brand";v="8", "Chromium";v="117"',
            'Sec-Ch-Ua-Mobile': '?0',
            'Sec-Ch-Ua-Platform': '"macOS"',
            'Sec-Fetch-Dest': 'document',
            'Sec-Fetch-Mode': 'navigate',
            'Sec-Fetch-Site': 'same-origin',
            'Sec-Fetch-User': '?1'
          },
        ),
      );
    },
  );

  test(
    'throw exception when parses wrong input',
    () async {
      expect(() => Curl.parse('1f'), throwsException);
    },
  );

  test(
    'tryParse return null when parses wrong input',
    () async {
      expect(Curl.tryParse('1f'), null);
    },
  );

  test(
    'tryParse success',
    () async {
      expect(
        Curl.tryParse(
          'curl -X GET https://api.apidash.dev -H "test: Agent"',
        ),
        Curl(
          method: 'GET',
          uri: apiUri,
          headers: {
            'test': 'Agent',
          },
        ),
      );
    },
  );

  test(
    'HEAD 1',
    () async {
      expect(
        Curl.parse(
          r"""curl -I 'https://api.apidash.dev'""",
        ),
        Curl(
          method: 'HEAD',
          uri: apiUri,
        ),
      );
    },
  );

  test(
    'HEAD 2',
    () async {
      expect(
        Curl.parse(
          r"""curl --head 'https://api.apidash.dev'""",
        ),
        Curl(
          method: 'HEAD',
          uri: apiUri,
        ),
      );
    },
  );

  test(
    'GET 1',
    () async {
      expect(
        Curl.parse(
          r"""curl --url 'https://api.apidash.dev'""",
        ),
        Curl(
          method: 'GET',
          uri: apiUri,
        ),
      );
    },
  );

  test(
    'GET 2',
    () async {
      expect(
        Curl.parse(
          r"""curl --url 'https://api.apidash.dev/country/data?code=US'""",
        ),
        Curl(
          method: 'GET',
          uri: Uri.parse('https://api.apidash.dev/country/data?code=US'),
        ),
      );
    },
  );

  test(
    'GET 3',
    () async {
      expect(
        Curl.parse(
          r"""curl 'https://api.apidash.dev/country/data?code=IND'""",
        ),
        Curl(
          method: 'GET',
          uri: Uri.parse('https://api.apidash.dev/country/data?code=IND'),
        ),
      );
    },
  );

  test(
    'GET with GitHub API',
    () async {
      expect(
        Curl.parse(
          r"""curl --url 'https://api.github.com/repos/foss42/apidash' \
  --header 'User-Agent: Test Agent'""",
        ),
        Curl(
          method: 'GET',
          uri: Uri.parse('https://api.github.com/repos/foss42/apidash'),
          headers: {"User-Agent": "Test Agent"},
        ),
      );
    },
  );

  test(
    'GET with GitHub API and raw parameter',
    () async {
      expect(
        Curl.parse(
          r"""curl --url 'https://api.github.com/repos/foss42/apidash?raw=true' \
  --header 'User-Agent: Test Agent'""",
        ),
        Curl(
          method: 'GET',
          uri:
              Uri.parse('https://api.github.com/repos/foss42/apidash?raw=true'),
          headers: {"User-Agent": "Test Agent"},
        ),
      );
    },
  );

  test(
    'POST with text/plain content',
    () async {
      expect(
        Curl.parse(
          r"""curl --request POST \
  --url 'https://api.apidash.dev/case/lower' \
  --header 'Content-Type: text/plain' \
  --data '{
"text": "I LOVE Flutter"
}'""",
        ),
        Curl(
          method: 'POST',
          uri: Uri.parse('https://api.apidash.dev/case/lower'),
          headers: {"Content-Type": "text/plain"},
          data: r"""{
"text": "I LOVE Flutter"
}""",
        ),
      );
    },
  );

  test(
    'POST with application/json content',
    () async {
      expect(
        Curl.parse(
          r"""curl --request POST \
  --url 'https://api.apidash.dev/case/lower' \
  --header 'Content-Type: application/json' \
  --data '{
"text": "I LOVE Flutter",
"flag": null,
"male": true,
"female": false,
"no": 1.2,
"arr": ["null", "true", "false", null]
}'""",
        ),
        Curl(
          method: 'POST',
          uri: Uri.parse('https://api.apidash.dev/case/lower'),
          headers: {"Content-Type": "application/json"},
          data: r"""{
"text": "I LOVE Flutter",
"flag": null,
"male": true,
"female": false,
"no": 1.2,
"arr": ["null", "true", "false", null]
}""",
        ),
      );
    },
  );
}
