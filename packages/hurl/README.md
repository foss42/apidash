# hurl

Hurl file parser for API Dash using Flutter Rust Bridge and the official [Hurl](https://hurl.dev/) Rust library.

## Usage

```dart
import 'package:hurl/hurl.dart';

await RustLib.init();
final jsonResult = parseHurlToJson(content: hurlFileContent);
```

## Platform Support

- macOS (tested)
- Linux, Windows (untested, should work via Cargokit)
- iOS/Android (libxml2 dependency blocker)

## Build System

Uses [Cargokit](https://github.com/irondash/cargokit) for automatic Rust compilation during Flutter builds. The `libxml2` system dependency is configured in platform-specific podspec/CMake files.

