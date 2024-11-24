# curl_parser

A well-tested and improved alternative to [curl_converter](https://pub.dev/packages/curl_converter).

A Dart package that provides a `Curl` class for parsing and formatting cURL commands.

## Usage

1. Add the package to your `pubspec.yaml` file

2. Use the package:

```dart
import 'package:curl_converter/curl_converter.dart';

void main() {
  // Parse a cURL command
  final curlString = 'curl -X GET https://www.example.com/';
  final curl = Curl.parse(curlString);

  // Access parsed data
  print(curl.method); // GET
  print(curl.uri); // https://www.example.com/

  // Format Curl object to a cURL command
  final formattedCurlString = curl.toCurlString();
  print(formattedCurlString); // curl -X GET https://www.example.com/
}
```

See [test](https://github.com/foss42/curl_converter/tree/main/test) folder for more example usages.

## Features

- Parse a cURL command into a `Curl` class instance.
- Format a `Curl` object back into a cURL command.
- Supports various options such as request method, headers, data, cookies, user-agent, and more.

## License

This project is licensed under the [Apache License 2.0](https://github.com/foss42/apidash/blob/main/packages/curl_parser/LICENSE).
Fork of [curl_converter](https://github.com/utopicnarwhal/curl_converter).
