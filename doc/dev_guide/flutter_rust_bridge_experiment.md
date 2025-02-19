# Flutter Rust Bridge Experiment for Parsing Hurl
*Author: [WrathOP](https://github.com/WrathOP)*

## Background and Initial Approach

When I first started adding hurl parser in API Dash, I wrote a custom parser using `petitparser` for the [hurl grammar](https://hurl.dev/docs/grammar.html). After spending about a week on this approach, I received some feedback from the maintainer to look into some approach of integrating the hurl Rust implementation directly rather than re-implementing the wheel. So that any future changes directly flow into the project.

## Understanding Flutter Rust Bridge

### What is Flutter Rust Bridge?

Flutter Rust Bridge serves as a powerful tool for developing Flutter plugins using Rust. It automatically generates all the necessary code for both Flutter and Rust, creating a seamless bridge between the two languages. This approach is particularly valuable when you want to harness Rust's performance and safety features within Flutter projects.

The [official documentation](https://cjycode.com/flutter_rust_bridge/) highlights three key features:
1. Write standard Rust code, including complex features like arbitrary types, closures, mutable references, async functions, and traits
2. Call Rust code from Flutter as if it were native Flutter code
3. Automatic generation of all intermediate code required for communication

### Why Choose Flutter Rust Bridge?

Two main factors drove my decision to use Flutter Rust Bridge:

1. **Automatic Updates with Upstream Changes**: By using the official Hurl Rust library, any changes made to the `hurl.dev` parser would automatically propagate to our plugin. This ensures long-term maintainability and compatibility.

2. **Performance Benefits**: Rust's renowned performance characteristics and safety guarantees make it ideal for parsing large Hurl files efficiently.

## Implementation Process

### Setting Up the Flutter Rust Bridge Plugin

While there are several examples of Flutter Rust Bridge usage available, such as [flutter smooth](https://github.com/fzyzcjy/flutter_smooth) and the [official documentation demo](https://cjycode.com/flutter_rust_bridge/demo/), I found that plugin-specific examples were scarce. Here's a detailed breakdown of my setup process:

1. **Project Initialization**
Instead of using the standard Flutter plugin template (`flutter create --template=plugin hurl`), Flutter Rust Bridge provides its own initialization command.

Inside the `apidash/packages` directory, I executed:

```bash
flutter_rust_bridge_codegen create hurl --template plugin
```

This command generated three main directories:

1. `cargokit/`: Contains build infrastructure
   - build_tool/: Build system utilities
   - cmake/: CMake configuration files
   - Pod creation scripts for iOS
   - Build scripts for various platforms
   - Gradle configuration for Android

2. `rust/`: The Rust project structure
   - src/
     - api/: Contains the core Rust implementation
       - simple.rs: Main implementation file
       - mod.rs: Module definitions
     - frbgenerated.rs: Auto-generated bridge code
     - lib.rs: Library entry point
   - cargo.toml: Rust dependencies and configuration
   - .gitignore

3. `lib/`: Flutter code
   - rust/: Generated Rust bindings
   - hurl.dart: Package export file

### Implementation Details

The core parsing functionality was implemented in [`rust/src/api/simple.rs`](https://github.com/foss42/apidash/blob/9a201dd10af6e6804c7fd8fab8352701ab722fb2/packages/hurl/rust/src/api/simple.rs):

```rust
/// Parses a Hurl file content and returns its JSON representation
#[flutter_rust_bridge::frb(sync)]
pub fn parse_hurl_to_json(content: String) -> Result<String, String> {
    match parse_hurl_file(&content) {
        Ok(hurl_file) => {
            // Convert to JSON using hurlfmt's format_json
            Ok(format_json(&hurl_file))
        }
        Err(errors) => {
            let mut error_msg = String::new();
            write!(error_msg, "Failed to parse Hurl file: {:?}", errors).unwrap();
            Err(error_msg)
        }
    }
}
```

For dependencies, I added hurlfmt to `cargo.toml`:

```toml
[package]
name = "hurl"
version = "0.1.0"
edition = "2021"

[lib]
crate-type = ["cdylib", "staticlib"]

[dependencies]
flutter_rust_bridge = "=2.7.0"
hurlfmt = "6.0.0"
hurl_core = "6.0.0"
```

### Dart Model Implementation

Based on the Hurl documentation, I identified the core data structures:
- HurlFile: Contains a list of Entries
- Entries: Composed of Request and Response objects

I implemented these models using the `freezed` package in Dart, creating a clean mapping between the JSON output from the Hurl parser and our Dart data structures. This part of the implementation proved particularly successful and robust.

## Compilation Challenges and Platform Support

### Build Process Overview

The compilation process varies by platform, but generally follows these steps:

1. For local testing in the `hurl/tests` directory, building the Rust component requires:
```bash
cd apidash/packages/hurl/rust
cargo build --release
```

2. For actual deployment, cargokit manages the platform-specific build process during Flutter's standard build phase. The process involves:
   - On iOS: Generating and building Pod files
   - On Android: Creating platform-specific binaries
   - On macOS/Linux: Building dynamic libraries
   - On Windows: Generating appropriate DLLs

### Understanding Flutter Rust Bridge on Mobile Platforms

Flutter Rust Bridge generally works seamlessly across platforms as long as the Rust dependencies don't rely on platform-specific implementations. The bridge itself handles the complexity of cross-platform compilation through cargokit, which manages the build process for each target platform. However, when Rust crates depend on system libraries or have platform-specific requirements, complications can arise.

For iOS and Android specifically, the build process involves:
1. For iOS: Compiling Rust code to a static library that gets embedded in the iOS app bundle
2. For Android: Creating platform-specific .so files for each supported architecture (arm64-v8a, armeabi-v7a, x86_64)

The challenge comes when dependencies like `libxml2` expect certain system libraries to be available, which may not exist or behave differently on mobile platforms.

### Platform-Specific Challenges

#### macOS Implementation

The main challenge on macOS involved the `libxml2` dependency. I reported this issue on the [Hurl repository](https://github.com/Orange-OpenSource/hurl/issues/3603). The solution required adding specific linker flags to the `apidash/packages/hurl/macos/hurl.podspec`:

```ruby
spec.pod_target_xcconfig = {
  'OTHER_LDFLAGS' => '-force_load ${BUILT_PRODUCTS_DIR}/libhurl.a -lxml2'
}
```

#### iOS and Android Challenges

The iOS and Android implementations faced more significant hurdles, primarily due to `libxml2` compatibility issues. Unlike macOS, these platforms don't include `libxml2` as a system library, and the Rust crate wrapper doesn't support mobile platforms.

The following approaches were attempted for iOS:
1. Modifying header search paths
2. Adding framework linkage
3. Adjusting Xcode build phases
4. Experimenting with different linking configurations

None of these attempts proved successful, leading to a deeper investigation of the `libxml2` dependency.

#### Maintainer Feedback and Investigation

After reaching out to both the Hurl and Flutter Rust Bridge maintainers, I received valuable feedback from the Hurl maintainer:

> _"I'm not an expert in iOS/Android, but what I would do is try to build something smaller, maybe just calling libxml through a Flutter component, then trying to build with libxml but with the Rust crate wrapper, etc."_ ([GitHub comment](https://github.com/Orange-OpenSource/hurl/issues/3603#issuecomment-2611159759))

This suggestion highlighted a crucial debugging approach: isolating the `libxml2` integration from the rest of the Hurl parsing functionality. The idea is to:

1. First verify that we can call `libxml2` directly from Flutter
2. Then attempt to use the Rust crate wrapper
3. Finally integrate it with the full Hurl parser

This systematic approach could help identify exactly where the build process breaks down on mobile platforms and potentially lead to a workable solution.

### Current Status and Potential Solutions

After extensive testing and consultation with both the Hurl and Flutter Rust Bridge maintainers, I've identified several potential paths forward:

1. **Dart Native FFIs**: This approach is currently experimental but shows promise. The Flutter Rust Bridge maintainer suggested this option in this [Github comment](https://github.com/fzyzcjy/flutter_rust_bridge/issues/2510#issuecomment-2608469143).

2. **Legacy Hurlfmt Version**: We could use a version of the library from before the `libxml` transition. This would avoid the platform compatibility issues but might miss out on recent performance improvements.

3. **Custom Parser Completion**: Returning to and completing the `petitparser`-based implementation could provide a more controlled, albeit maintenance-heavy solution.

## Code Availability

The current implementation is available in two branches of my fork:
- [Hurl Parser with flutter_rust_bridge](https://github.com/WrathOP/apidash/tree/hurl-parser-rust)
- [Hurl Parser with petiteparser](https://github.com/WrathOP/apidash/tree/hurl-parser-added)

Feel free to contribute ideas or suggestions for addressing these challenges!
