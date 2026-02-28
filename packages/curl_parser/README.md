# curl Parser

[![Pub Version](https://img.shields.io/pub/v/curl_parser)](https://pub.dev/packages/curl_parser)

Easily parse a cURL command into a Dart object and generate cURL commands from Dart objects.  
A well-tested and better alternative to [curl_converter](https://pub.dev/packages/curl_converter).

## Features

- Parse a cURL command into a `Curl` class instance.
- Format a `Curl` object back into a cURL command.
- Supports various options such as request method, headers, data, cookies, user-agent, and more.

## Contribute

In case you would like to add a feature, feel free to raise an issue in our [repo](https://github.com/foss42/apidash/blob/main/packages/curl_parser/) and send across a Pull Request.

## Usage

1. Add the package to your `pubspec.yaml` file

2. Use the package:

### Example 1: GET

```dart
import 'package:curl_parser/curl_parser.dart';

void main() {
  final curlGetStr = 'curl https://api.apidash.dev/';
  final curlGet = Curl.parse(curlGetStr);

  // Parsed data
  print(curlGet.method);
  // GET
  print(curlGet.uri);
  // https://api.apidash.dev/

  // Object to cURL command
  final formattedCurlGetStr = curlGet.toCurlString();
  print(formattedCurlGetStr);
  // curl "https://api.apidash.dev/"
}
```

### Example 2: HEAD

```dart
import 'package:curl_parser/curl_parser.dart';

void main() {
  final curlHeadStr = 'curl -I https://api.apidash.dev/';
  final curlHead = Curl.parse(curlHeadStr);

  // Access parsed data
  print(curlHead.method);
  // HEAD
  print(curlHead.uri);
  // https://api.apidash.dev/

  // Object to cURL command
  final formattedCurlHeadStr = curlHead.toCurlString();
  print(formattedCurlHeadStr);
  // curl -I "https://api.apidash.dev/"
}
```

### Example 3: GET + HEADERS

```dart
import 'package:curl_parser/curl_parser.dart';

void main() {
  final curlHeadersStr = 'curl -H "X-Header: Test" https://api.apidash.dev/';
  final curlHeader = Curl.parse(curlHeadersStr);

  // Access parsed data
  print(curlHeader.method);
  // GET
  print(curlHeader.uri);
  // https://api.apidash.dev/
  print(curlHeader.headers);
  // {"X-Header": "Test"}

  // Object to cURL command
  final formattedCurlHeaderStr = curlHeader.toCurlString();
  print(formattedCurlHeaderStr);
  // curl "https://api.apidash.dev/" \
  //  -H "X-Header: Test"
}
```

### Example 4: POST

```dart
import 'package:curl_parser/curl_parser.dart';

void main() {
  final curlPostStr = r"""curl -X 'POST' \
  'https://api.apidash.dev/case/lower' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "text": "Grass is green"
}'""";
  final curlPost = Curl.parse(curlPostStr);

  // Access parsed data
  print(curlPost.method);
  // POST
  print(curlPost.uri);
  // https://api.apidash.dev/case/lower
  print(curlPost.headers);
  // {"accept": "application/json", "Content-Type": "application/json"}
  print(curlPost.data);
  // {
  //   "text": "Grass is green"
  // }

  // Object to cURL command
  final formattedCurlPostStr = curlPost.toCurlString();
  print(formattedCurlPostStr);
  // curl -X POST "https://api.apidash.dev/case/lower" \
  //  -H "accept: application/json" \
  //  -H "Content-Type: application/json" \
  //  -d '{
  //   "text": "Grass is green"
  // }'
}
```

Check out [test](https://github.com/foss42/apidash/blob/main/packages/curl_parser/test/curl_parser_test.dart) for more examples.

## Maintainer

- Ashita Prasad ([GitHub](https://github.com/ashitaprasad), [LinkedIn](https://www.linkedin.com/in/ashitaprasad/), [X](https://x.com/ashitaprasad))

## License

This project is licensed under the [Apache License 2.0](https://github.com/foss42/apidash/blob/main/packages/curl_parser/LICENSE).
