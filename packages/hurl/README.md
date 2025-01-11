# hurl

A Dart package that provides Hurl file parsing using a Rust backend for high performance.

## Features

- Parse Hurl files into structured Dart objects
- High-performance Rust-based parsing
- Support for all Hurl features:
  - HTTP methods (GET, POST, PUT, DELETE, etc.)
  - Headers
  - Query parameters
  - Form parameters
  - Basic authentication
  - Cookies
  - Options
  - Captures
  - Assertions
  - JSON/XML bodies

## Installation

```yaml
dependencies:
  hurl: ^0.1.0
```

## Usage

```dart
import 'package:hurl/hurl.dart';

void main() async {
  // Initialize the parser
  final parser = await HurlParser.getInstance();

  // Parse Hurl content
  final hurlFile = parser.parse('''
GET http://api.example.com/users
Authorization: Bearer token123
Accept: application/json

HTTP/1.1 200
[Captures]
user_id: jsonpath "$.users[0].id"
[Asserts]
header "Content-Type" == "application/json"
''');

  // Access the parsed data
  final request = hurlFile.entries.first.request;
  print('Method: ${request.method}');
  print('URL: ${request.url}');
}
```

## Additional information

- [Hurl Documentation](https://hurl.dev)

## License

This project is licensed under the MIT License - see the LICENSE file for details.