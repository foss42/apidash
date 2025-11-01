# hurl

Hurl file parser for API Dash using Flutter Rust Bridge.

## Overview

This package provides Hurl file parsing functionality using the official [Hurl](https://hurl.dev/) Rust library. It bridges Rust code to Dart/Flutter using [Flutter Rust Bridge](https://cjycode.com/flutter_rust_bridge/).

## Features

- Parse Hurl files and extract HTTP requests
- Get method, URL, headers, and query parameters
- Returns data in JSON format for easy consumption by Dart code

## Usage

```dart
import 'package:hurl/hurl.dart';

// Initialize the Rust library
await RustLib.init();

// Parse a Hurl file
final jsonResult = parseHurlToJson(content: hurlFileContent);
```

## Dependencies

- **hurl_core**: Official Hurl parser library (Rust)
- **flutter_rust_bridge**: FFI bridge between Dart and Rust
- **libxml2**: System library dependency (required by hurl_core)

## Platform Support

- ✅ macOS (with libxml2 linked via Podspec)
- ✅ Linux
- ✅ Windows
- ⚠️ iOS/Android (libxml2 dependency may require additional configuration)

## Project structure

This template uses the following structure:

* `src`: Contains the native source code, and a CmakeFile.txt file for building
  that source code into a dynamic library.

* `lib`: Contains the Dart code that defines the API of the plugin, and which
  calls into the native code using `dart:ffi`.

* platform folders (`android`, `ios`, `windows`, etc.): Contains the build files
  for building and bundling the native code library with the platform application.

## Building and bundling native code

The `pubspec.yaml` specifies FFI plugins as follows:

```yaml
  plugin:
    platforms:
      some_platform:
        ffiPlugin: true
```

This configuration invokes the native build for the various target platforms
and bundles the binaries in Flutter applications using these FFI plugins.

This can be combined with dartPluginClass, such as when FFI is used for the
implementation of one platform in a federated plugin:

```yaml
  plugin:
    implements: some_other_plugin
    platforms:
      some_platform:
        dartPluginClass: SomeClass
        ffiPlugin: true
```

A plugin can have both FFI and method channels:

```yaml
  plugin:
    platforms:
      some_platform:
        pluginClass: SomeName
        ffiPlugin: true
```

The native build systems that are invoked by FFI (and method channel) plugins are:

* For Android: Gradle, which invokes the Android NDK for native builds.
  * See the documentation in android/build.gradle.
* For iOS and MacOS: Xcode, via CocoaPods.
  * See the documentation in ios/hurl.podspec.
  * See the documentation in macos/hurl.podspec.
* For Linux and Windows: CMake.
  * See the documentation in linux/CMakeLists.txt.
  * See the documentation in windows/CMakeLists.txt.

## Binding to native code

To use the native code, bindings in Dart are needed.
To avoid writing these by hand, they are generated from the header file
(`src/hurl.h`) by `package:ffigen`.
Regenerate the bindings by running `dart run ffigen --config ffigen.yaml`.

## Invoking native code

Very short-running native functions can be directly invoked from any isolate.
For example, see `sum` in `lib/hurl.dart`.

Longer-running functions should be invoked on a helper isolate to avoid
dropping frames in Flutter applications.
For example, see `sumAsync` in `lib/hurl.dart`.

## Flutter help

For help getting started with Flutter, view our
[online documentation](https://docs.flutter.dev), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

