# Adding a New Code Generator

This guide explains how to add support for a new programming language or library to API Dash's code generation system.

## Overview

API Dash generates runnable code for API requests in 30+ language/library combinations. Each generator is a Dart class that uses Jinja templates to produce code strings from request models.

## Step 1: Add the Enum Value

Add a new entry to the `CodegenLanguage` enum in `lib/consts.dart`:

```dart
enum CodegenLanguage {
  // ... existing entries ...
  myLanguageLib("MyLanguage (mylib)", "mylanguage", "ext"),
}
```

The three parameters are:

| Parameter | Description | Example |
|-----------|-------------|---------|
| `label` | Display name shown in the UI dropdown | `"Python (requests)"` |
| `codeHighlightLang` | Language identifier for syntax highlighting | `"python"` |
| `ext` | File extension for the generated code | `"py"` |

## Step 2: Create the Generator Class

Create a new file under `lib/codegen/`. Follow the existing directory convention — one folder per language, one file per library variant:

```
lib/codegen/
└── mylanguage/
    └── mylib.dart
```

### Implementation Pattern

Every generator class follows the same interface:

```dart
import 'package:apidash_core/apidash_core.dart';
import 'package:jinja/jinja.dart' as jj;

class MyLanguageMyLibCodeGen {
  // 1. Define Jinja templates as class fields
  final String kTemplateStart = """import mylib

url = '{{url}}'
""";

  final String kTemplateParams = """
params = {{params}}
""";

  final String kTemplateHeaders = """
headers = {{headers}}
""";

  final String kTemplateBody = """
body = {{body}}
""";

  final String kTemplateEnd = """
response = mylib.{{method}}(url{{params}}{{headers}}{{body}})
print(response.status_code)
print(response.text)
""";

  // 2. Implement the getCode method
  String? getCode(
    HttpRequestModel requestModel, {
    String? boundary,
  }) {
    try {
      String result = "";

      // Parse and validate the URI
      var rec = getValidRequestUri(
        requestModel.url,
        requestModel.enabledParams,
      );
      Uri? uri = rec.$1;

      if (uri != null) {
        // Render the start template
        var templateStart = jj.Template(kTemplateStart);
        result += templateStart.render({
          "url": stripUriParams(uri),
        });

        // Add query parameters if present
        if (requestModel.enabledParamsMap.isNotEmpty) {
          var templateParams = jj.Template(kTemplateParams);
          result += templateParams.render({
            "params": requestModel.enabledParamsMap.toString(),
          });
        }

        // Add headers if present
        if (requestModel.enabledHeadersMap.isNotEmpty) {
          var templateHeaders = jj.Template(kTemplateHeaders);
          result += templateHeaders.render({
            "headers": requestModel.enabledHeadersMap.toString(),
          });
        }

        // Add body if present
        String? body = requestModel.body;
        if (body != null && body.isNotEmpty) {
          var templateBody = jj.Template(kTemplateBody);
          result += templateBody.render({
            "body": body,
          });
        }

        // Render the final template
        var templateEnd = jj.Template(kTemplateEnd);
        result += templateEnd.render({
          "method": requestModel.method.name.toLowerCase(),
          "params": requestModel.enabledParamsMap.isNotEmpty
              ? ", params=params"
              : "",
          "headers": requestModel.enabledHeadersMap.isNotEmpty
              ? ", headers=headers"
              : "",
          "body": (body != null && body.isNotEmpty) ? ", body=body" : "",
        });
      }
      return result;
    } catch (e) {
      return null;
    }
  }
}
```

### Key APIs Available

| Function | Source | Purpose |
|----------|--------|---------|
| `getValidRequestUri(url, enabledParams)` | `apidash_core` | Parses URL and query params, returns `(Uri?, String?)` |
| `stripUriParams(uri)` | `apidash_core` | Returns URL string without query parameters |
| `kJsonEncoder.convert(data)` | `apidash_core` | Converts data to formatted JSON string |
| `jsonToPyDict(json)` | `lib/codegen/codegen_utils.dart` | Converts JSON to Python dict syntax (useful for Python-like languages) |

### Request Model Properties

The `HttpRequestModel` provides:

| Property | Type | Description |
|----------|------|-------------|
| `url` | `String` | Request URL |
| `method` | `HTTPVerb` | HTTP method (get, post, put, patch, delete, head, options) |
| `enabledParams` | `List<NameValueModel>?` | Active query parameters |
| `enabledParamsMap` | `Map<String, String>` | Query parameters as a map |
| `enabledHeaders` | `List<NameValueModel>?` | Active headers |
| `enabledHeadersMap` | `Map<String, String>` | Headers as a map |
| `body` | `String?` | Request body content |
| `bodyContentType` | `ContentType` | Body content type (json, text, formdata, etc.) |
| `formData` | `List<FormDataModel>?` | Form data entries |
| `hasBody` | `bool` | Whether the request has a body |
| `hasFormData` | `bool` | Whether the request uses form data |

## Step 3: Register the Generator

Add the new generator to the switch statement in `lib/codegen/codegen.dart`:

1. Import the new file:
```dart
import 'mylanguage/mylib.dart';
```

2. Add the case to the `getCode` method:
```dart
case CodegenLanguage.myLanguageLib:
  return MyLanguageMyLibCodeGen().getCode(rM, boundary: boundary);
```

## Step 4: Add Tests

Create a test file at `test/codegen/mylanguage_mylib_codegen_test.dart`:

```dart
import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';
import '../models/request_models.dart';

void main() {
  final codeGen = Codegen();

  group('MyLanguage MyLib Code Generation', () {
    test('GET 1', () {
      const expectedCode = r"""import mylib

url = 'https://api.apidash.dev'

response = mylib.get(url)
print(response.status_code)
print(response.text)
""";
      expect(
        codeGen.getCode(
          CodegenLanguage.myLanguageLib,
          requestModelGet1,
          SupportedUriSchemes.https,
        ),
        expectedCode,
      );
    });

    // Add more tests for POST, PUT, DELETE, headers, params, body, etc.
  });
}
```

### Test Models

Shared test request models are defined in `test/models/request_models.dart`. Use the existing models (e.g., `requestModelGet1`, `requestModelPost1`) to test your generator against standard scenarios.

### Running Tests

```bash
# Run your specific test file
flutter test test/codegen/mylanguage_mylib_codegen_test.dart

# Run all codegen tests
flutter test test/codegen/
```

## Step 5: Verify

1. Run the app locally: `flutter run`
2. Create a request with various configurations (headers, params, body, auth).
3. Open the code generation panel and select your new language.
4. Verify the generated code is correct and runnable.
5. Run the full test suite: `flutter test`

## Checklist

- [ ] Added `CodegenLanguage` enum value in `lib/consts.dart`
- [ ] Created generator class in `lib/codegen/<language>/<library>.dart`
- [ ] Registered the generator in `lib/codegen/codegen.dart`
- [ ] Handles GET requests
- [ ] Handles POST/PUT/PATCH/DELETE with JSON body
- [ ] Handles query parameters
- [ ] Handles custom headers
- [ ] Handles form data (URL-encoded and multipart)
- [ ] Returns `null` on error (never throws)
- [ ] Added tests in `test/codegen/`
- [ ] All existing tests still pass

## Reference Implementations

For well-structured examples, look at these existing generators:

- **Simple:** `lib/codegen/others/curl.dart` — Straightforward template usage.
- **Moderate:** `lib/codegen/python/requests.dart` — Full feature set with conditional imports and body type handling.
- **Complex:** `lib/codegen/rust/reqwest.dart` — Multiple template variants for different body types and auth methods.
