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

  test('parses with common non-request flags without error', () {
    const cmd = r"""curl \
  --silent --compressed -o out.txt -i --globoff \
  --url 'https://api.apidash.dev/echo' \
  -H 'Accept: */*'""";
    final curl = Curl.tryParse(cmd);
    expect(curl, isNotNull);
    expect(
      curl,
      Curl(
        method: 'GET',
        uri: Uri.parse('https://api.apidash.dev/echo'),
        headers: {'Accept': '*/*'},
      ),
    );
  });

  test('parses with verbose, connect-timeout, retry, and output flags', () {
    const cmd = r"""curl -v \
  --connect-timeout 10 \
  --retry 3 \
  --output response.json \
  --url 'https://api.apidash.dev/echo' \
  -H 'Content-Type: application/json' \
  --data '{"x":1}'""";
    final curl = Curl.tryParse(cmd);
    expect(curl, isNotNull);
    expect(
      curl,
      Curl(
        method: 'POST',
        uri: Uri.parse('https://api.apidash.dev/echo'),
        headers: {'Content-Type': 'application/json'},
        data: '{"x":1}',
      ),
    );
  });

  test('merges multiple data flags and defaults to POST', () {
    const cmd = r"""curl \
  --url 'https://api.apidash.dev/submit' \
  --data-urlencode 'a=hello world' \
  --data-raw 'b=2' \
  --data-binary 'c=3' \
  -H 'Content-Type: application/x-www-form-urlencoded'""";
    final curl = Curl.parse(cmd);
    expect(
      curl,
      Curl(
        method: 'POST',
        uri: Uri.parse('https://api.apidash.dev/submit'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        data: 'a=hello world&b=2&c=3',
      ),
    );
  });

  test('buildResponseFromParsed with cookie referer user-agent', () {
    final curl = Curl.parse(
        "curl -b 'a=1' -e 'https://ref.example' -A 'MyAgent' https://api.apidash.dev/hdr");
    // Verify curl fields are captured
    expect(curl.cookie, contains('a=1'));
    expect(curl.userAgent, contains('MyAgent'));
    expect(curl.referer, contains('ref.example'));
  });

  test('supports PATCH method', () {
    const cmd = r"""curl -X PATCH \
  'https://api.apidash.dev/resource/42' \
  -H 'Content-Type: application/json' \
  --data '{"status":"ok"}'""";
    final curl = Curl.parse(cmd);
    expect(
      curl,
      Curl(
        method: 'PATCH',
        uri: Uri.parse('https://api.apidash.dev/resource/42'),
        headers: {'Content-Type': 'application/json'},
        data: '{"status":"ok"}',
      ),
    );
  });

  test('merges data flags in defined order', () {
    const cmd = r"""curl \
  --url 'https://api.apidash.dev/submit' \
  --data-urlencode 'a=1' \
  --data-raw 'b=2' \
  --data-binary 'c=3' \
  --data 'd=4'""";
    final curl = Curl.parse(cmd);
    expect(curl.data, 'a=1&b=2&c=3&d=4');
    expect(curl.method, 'POST');
  });

  test('HEAD with data stays HEAD (no implicit POST)', () {
    const cmd = r"""curl -I \
  'https://api.apidash.dev/whatever' \
  --data 'should_be_ignored_for_method'""";
    final curl = Curl.parse(cmd);
    expect(curl.method, 'HEAD');
  });

  test('user agent via -A populates userAgent field', () {
    const cmd = r"""curl -A 'MyApp/1.0' \
  'https://api.apidash.dev/ua'""";
    final curl = Curl.parse(cmd);
    expect(
      curl,
      Curl(
        method: 'GET',
        uri: Uri.parse('https://api.apidash.dev/ua'),
        userAgent: 'MyApp/1.0',
      ),
    );
  });

  test('cookie via -b with filename is tolerated', () {
    const cmd = r"""curl -b cookies.txt \
  'https://api.apidash.dev/echo'""";
    final curl = Curl.parse(cmd);
    expect(
      curl,
      Curl(
        method: 'GET',
        uri: Uri.parse('https://api.apidash.dev/echo'),
        cookie: 'cookies.txt',
      ),
    );
  });

  test('maps --oauth2-bearer to Authorization header if absent', () {
    const cmd = r"""curl --url 'https://api.apidash.dev/secure' \
  --oauth2-bearer 'tok_123'""";
    final curl = Curl.parse(cmd);
    expect(
      curl,
      Curl(
        method: 'GET',
        uri: Uri.parse('https://api.apidash.dev/secure'),
        headers: {'Authorization': 'Bearer tok_123'},
      ),
    );
  });

  test('oauth2-bearer does not override existing Authorization', () {
    const cmd = r"""curl \
  --url 'https://api.apidash.dev/secure' \
  -H 'Authorization: Bearer explicit' \
  --oauth2-bearer 'ignored'""";
    final curl = Curl.parse(cmd);
    expect(
      curl,
      Curl(
        method: 'GET',
        uri: Uri.parse('https://api.apidash.dev/secure'),
        headers: {'Authorization': 'Bearer explicit'},
      ),
    );
  });

  test('chooses first http(s) positional URL if --url missing', () {
    const cmd = r"""curl foo bar \
  'https://api.apidash.dev/echo' \
  baz""";
    final curl = Curl.parse(cmd);
    expect(
      curl.uri,
      Uri.parse('https://api.apidash.dev/echo'),
    );
  });

  test('tolerates cookie-jar without affecting request import', () {
    const cmd = r"""curl --url 'https://api.apidash.dev/echo' \
  -c cookies.txt -b 'a=1'""";
    final curl = Curl.parse(cmd);
    expect(
      curl,
      Curl(
        method: 'GET',
        uri: Uri.parse('https://api.apidash.dev/echo'),
        cookie: 'a=1',
      ),
    );
  });

  test('ignores unknown long flags safely', () {
    const cmd = r"""curl --unknown-flag foo \
  --url 'https://api.apidash.dev/echo' \
  --still-unknown=bar \
  -H 'Accept: */*'""";
    final curl = Curl.tryParse(cmd);
    expect(
      curl,
      Curl(
        method: 'GET',
        uri: Uri.parse('https://api.apidash.dev/echo'),
        headers: {'Accept': '*/*'},
      ),
    );
  });

  test('ignores unknown short flags safely', () {
    const cmd = r"""curl -Z -Y \
  'https://api.apidash.dev/echo' \
  -H 'X-Test: 1'""";
    final curl = Curl.tryParse(cmd);
    expect(
      curl,
      Curl(
        method: 'GET',
        uri: Uri.parse('https://api.apidash.dev/echo'),
        headers: {'X-Test': '1'},
      ),
    );
  });

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
