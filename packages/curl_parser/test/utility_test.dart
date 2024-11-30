import 'package:curl_parser/utils/string.dart';
import 'package:test/test.dart';

const defaultTimeout = Timeout(Duration(seconds: 3));

void main() {
  test('parse cURL with single quotes', () async {
    expect(
      splitAsCommandLineArgs(
          r"""--url 'https://api.github.com/repos/foss42/apidash?raw=true' \
  --header 'User-Agent: Test Agent'"""),
      [
        "--url",
        "https://api.github.com/repos/foss42/apidash?raw=true",
        "--header",
        "User-Agent: Test Agent",
      ],
    );
  }, timeout: defaultTimeout);

  test('parse cURL with double quotes', () async {
    expect(
      splitAsCommandLineArgs(
          r'''--url "https://api.github.com/repos/foss42/apidash?raw=true" \
  --header "User-Agent: Test Agent"'''),
      [
        "--url",
        "https://api.github.com/repos/foss42/apidash?raw=true",
        "--header",
        "User-Agent: Test Agent",
      ],
    );
  }, timeout: defaultTimeout);

  test('parse cURL with body', () async {
    expect(
      splitAsCommandLineArgs(r"""--request POST \
  --url 'https://api.apidash.dev/case/lower' \
  --header 'Content-Type: application/json' \
  --data '{
"text": "I LOVE Flutter",
"flag": null,
"male": true,
"female": false,
"no": 1.2,
"arr": ["null", "true", "false", null]
}'"""),
      [
        "--request",
        "POST",
        "--url",
        "https://api.apidash.dev/case/lower",
        "--header",
        "Content-Type: application/json",
        "--data",
        r'''{
"text": "I LOVE Flutter",
"flag": null,
"male": true,
"female": false,
"no": 1.2,
"arr": ["null", "true", "false", null]
}''',
      ],
    );
  }, timeout: defaultTimeout);
}
