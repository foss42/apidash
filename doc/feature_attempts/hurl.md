### Feature Implementation Writeup: HurlParser Wrapper for API Dash

I initially started with the approach of writing my own parser using `petitparser` and creating a custom implementation. However, after about a week, the maintainer recommended against this approach. They highlighted that building a custom parser would lack future-proofing if `hurl.dev` were to implement changes. While I abandoned this route, the code is still available in a branch. My custom parser had progressed to the point where requests and assertions were working, though it was far from complete.

#### Transition to Hurl Parser Wrapper Using Flutter Rust Bridge

Following the maintainer's suggestion, I began developing a wrapper for the Hurl parser using `flutter_rust_bridge`. Since the documentation for the library can be sparse, I’ve documented my steps for clarity:

1. **Creating the Library:**
    
    - I ran the command:
        
        `flutter_rust_bridge_codegen create hurl --template plugin`
        
    - This initialized the project.
2. **Adding the Parse Function:**
    
    - I added the library code and the `parse_hurl` function in `rust/src/api/simple.rs`.
3. **Generating the Flutter Side Code:**
    
    - I ran:
        
        
        `flutter_rust_bridge_codegen generate`
        
    - This generated all the necessary code for Flutter and all the targeted platforms.

`flutter_rust_bridge` uses a tool called `cargokit` to manage dependencies, acting as a glue layer between Flutter and Rust. Unfortunately, `cargokit` is still experimental, with little documentation available. The [blog post by Matej Knopp](https://matejknopp.com/post/flutter_plugin_in_rust_with_no_prebuilt_binaries/) provided valuable insights. One crucial takeaway was avoiding the Homebrew installation of Rust and instead using `rustup`. This resolved platform compilation issues for me, though the project is still not compiling entirely.

#### Implementing the Wrapper

I postponed multi-platform compilation issues to focus on writing the wrapper code. By reviewing the `hurl.dev` documentation and examples, I identified the required structure:

- `HurlFile` → List of `Entries`
- `Entries` → `Request` and `Response`

Based on this, I created models in Dart using the `freezed` package. The goal was to convert the JSON output from the Hurl parser into Dart data models. I am confident this part turned out well.

After writing tests for Hurl parsing and model generation, I shifted focus to building the project.

#### Compilation Challenges

During compilation, I encountered an issue, which I reported on the [Hurl repository](https://github.com/Orange-OpenSource/hurl/issues/3603). The Hurl parser depends on the `libxml2` crate for XML parsing. To resolve this, I had to add:

`OTHER_LDFLAGS => -force_load ${BUILT_PRODUCTS_DIR}/libhurl.a -lxml2`

This fixed the macOS build.

However, testing on iOS and Android proved problematic, as I didn’t have access to Windows or Linux systems. For iOS, adding similar flags didn’t work. I tried various fixes, such as modifying the header search paths, linking frameworks, and changing build phases in Xcode, but none succeeded.

#### Investigation into `libxml2`

I learned that `libxml2` is not a system library but a crate that wraps platform-specific libraries. Unfortunately, `libxml2` does not support Android or iOS, causing persistent errors. After consulting the maintainers of Hurl and `flutter_rust_bridge`, I received the following suggestion from the Hurl maintainer:

> _"I'm not an expert in iOS/Android, but what I would do is try to build something smaller, maybe just calling libxml through a Flutter component, then trying to build with libxml but with the Rust crate wrapper, etc."_ ([GitHub comment](https://github.com/Orange-OpenSource/hurl/issues/3603#issuecomment-2611159759))

#### Current Status and Potential Solutions

At this point, I’ve committed all my code to the repository in a fork. Here are some potential solutions I believe might work:

1. **Use Dart Native FFIs**: Currently under an experimental flag, as suggested by the `flutter_rust_bridge` maintainer.
2. **Revert to an Older Version of Hurlfmt**: Use a version of the library from before it transitioned to `libxml` for performance improvements.
3. **Revisit My Custom Parser**: Complete the parser I started building with `petitparser`.

If anyone knows a solution to these challenges or has suggestions, I’d appreciate the help!
