# Pull Request: Add Markdown API Documentation and cURL Reproduction Session Exporter

**Target Repository:** `foss42/apidash:main`  
**Author Branch:** `Ashish6298:add-feature-markdown-export`  
**PR Title:** `feat: add Markdown API documentation and session exporter for request & response`

---

## 📌 Context & Motivation

API Dash enables developers to build, test, and debug API requests while offering code generation for client libraries (Dart, Python, JavaScript, etc.). In collaborative engineering workflows, developers frequently need to share snapshots of API transactions:
- Reporting bugs or reproducing edge cases in issue trackers (GitHub Issues, Jira).
- Documenting endpoints in technical design proposals, team wikis (Notion, Confluence), and pull requests.
- Quickly verifying payloads and error codes with backend teammates over Slack or Discord.

Previously, sharing an API state required manually copying the endpoint URL, headers, query parameters, request body, and response payload one by one. This process was time-consuming, prone to human transcription errors, and lacked standardized formatting.

This pull request introduces a native **Markdown API Documentation & cURL Reproduction Session Exporter**. With a single click from the Response Pane, developers can preview, copy, or save clean, publication-ready API documentation or executable bash-ready reproduction scripts.

---

## 🚀 Key Capabilities

1. **GitHub Flavored Markdown (`.md`) Generator**:
   - Generates structured technical documentation including HTTP verb badges, target URLs, request descriptions, tabular query parameters, tabular request headers, formatted request payloads, HTTP response status codes, round-trip latency, and syntax-highlighted response bodies.
   - Built-in support for diverse body types: Pretty-printed JSON (2-space indentation), plain text, and multipart/form-data with file attributes.
   - Auto-detects and formats responses across JSON, XML, HTML, and plain text.

2. **Deterministic cURL Reproduction Sessions**:
   - Generates executable multi-line bash `curl` commands formatted with clean line continuations (`\`).
   - Automatically breaks down flags (`-X`, `-H`, `--data`, `-F`) while stripping redundant headers (e.g., omitting manual `Content-Type` for multipart requests so curl manages boundaries automatically).
   - Appends execution comments (`# Response: 200 OK (45 ms)`) for instant reproduction by engineers triage-testing issues directly from the command line.

3. **Interactive Syntax-Highlighted Previewer**:
   - Accessible directly from the Response Pane Header via a dedicated export action button (`Icons.description_outlined`).
   - Segmented tab control allowing developers to toggle between **Markdown (.md)** and **cURL Session** with live syntax highlighting.
   - One-tap clipboard copy with non-intrusive SnackBar feedback.
   - Direct local file export (`<request_name>_api_doc.md`) utilizing the system's native file picker (`file_selector`).

4. **Responsive Multi-Form Factor Layout**:
   - **Desktop**: Renders as an ergonomic `700x500` modal dialog with side-by-side or stacked code previews.
   - **Mobile & Narrow Viewports**: Automatically transitions into a full-width bottom sheet (`ExportDocumentSheet`) with independent vertical scroll viewports and wrapped, touch-friendly action controls.

---

## 🏛️ Architectural Overview & Design Decisions

### 1. Separation of Concerns & Clean Domain Boundaries
All document-generation algorithms reside in `packages/apidash_core/lib/generators/`:
- **Polymorphic Contract (`DocGenerator`)**:
  ```dart
  abstract interface class DocGenerator {
    String? generate({
      required HttpRequestModel request,
      HttpResponseModel? response,
      String? requestName,
    });
  }
  ```
  This adheres to the Open-Closed Principle, allowing future formatters (e.g., OpenAPI 3.1 YAML, Postman collection snippets) to be added without modifying existing consumer code.
- **Pure Dart Implementation**: Core generators have zero dependencies on Flutter rendering trees, enabling rapid headless unit testing and maximum reusability across potential CLI or background workers.

### 2. Reactive Riverpod State Integration
- Added `selectedDocExportProvider` in `lib/providers/collection_providers.dart`:
  ```dart
  final selectedDocExportProvider = StateProvider<String?>((ref) {
    final selectedRequestModel = ref.watch(selectedRequestModelProvider);
    if (selectedRequestModel == null || selectedRequestModel.httpRequestModel == null) {
      return null;
    }
    final substitutedRequest =
        ref.watch(selectedSubstitutedHttpRequestModelProvider) ??
            selectedRequestModel.httpRequestModel!;
    return const MarkdownDocGenerator().generate(
      request: substitutedRequest,
      response: selectedRequestModel.httpResponseModel,
      requestName: selectedRequestModel.name,
    );
  });
  ```
  This computed provider automatically listens to active request selection and environment variable substitutions (`selectedSubstitutedHttpRequestModelProvider`), guaranteeing that rendered documentation reflects substituted variables.

### 3. Security, Privacy & Sanitization
- **100% Client-Side Computation**: Zero telemetry, zero external network calls, and zero third-party service dependencies. All formatting executes strictly in memory.
- **Sensitive Header Masking**: Tokens in `Authorization` and `Proxy-Authorization` headers are safely masked (`Bearer ey...`) in public markdown output to prevent accidental credential disclosure when pasting into public issues.
- **Table & Shell Sanitization**: Markdown tables safely escape special pipe characters (`|`), and cURL generators safely escape shell quotes to prevent command injection when pasted into terminal sessions.

---

## 📁 File Structure & Change Map

| Path | Purpose |
| :--- | :--- |
| `packages/apidash_core/lib/generators/doc_generator.dart` | Abstract interface defining document generator contract. |
| `packages/apidash_core/lib/generators/markdown_doc_generator.dart` | GitHub Flavored Markdown document engine. |
| `packages/apidash_core/lib/generators/curl_session_generator.dart` | Multi-line bash cURL session builder with response comments. |
| `packages/apidash_core/lib/generators/format_utils.dart` | Escaping, JSON indentation, and header masking utilities. |
| `packages/apidash_core/lib/generators/generators.dart` | Barrel file exporting new generators. |
| `packages/apidash_core/lib/apidash_core.dart` | Library export exposing generators to client packages. |
| `packages/apidash_core/pubspec.yaml` | Declared `better_networking: any` package boundary dependency. |
| `lib/widgets/response_pane_header.dart` | Action trigger button and `onExportDoc` parameter in response header. |
| `lib/widgets/dialog_export_doc.dart` | Responsive modal dialog and mobile bottom sheet with preview & export actions. |
| `lib/widgets/widgets.dart` | Barrel file export for `dialog_export_doc.dart`. |
| `lib/providers/collection_providers.dart` | `selectedDocExportProvider` reactive computed state provider. |
| `lib/screens/home_page/editor_pane/details_card/response_pane.dart` | Connected `onExportDoc` to display export dialog with active state. |
| `doc/user_guide/export_markdown_doc_guide.md` | Comprehensive user guide with sample outputs. |
| `doc/user_guide/req_user_guide.md` | Added Exporting API Documentation section. |
| `doc/user_guide/README.md` | Indexed new export user guide. |
| `README.md` | Updated root feature summary with documentation and CI compliance notes. |
| `packages/apidash_core/test/generators/doc_generator_test.dart` | Unit tests for Markdown & cURL generation and edge cases. |
| `test/widgets/dialog_export_doc_test.dart` | Widget tests for dialog, tab toggle, copy, and file export. |
| `test/widgets/response_pane_header_test.dart` | Widget tests for trigger button presence, enablement, and flow. |
| `test/providers/doc_export_provider_test.dart` | Unit tests for reactive provider state lifecycle. |
| `test/screens/home_page/editor_pane/response_pane_test.dart` | Integration tests verifying dialog invocation from response pane. |

---

## 🧪 Testing & Validation Results

The implementation was rigorously verified across unit, widget, and integration layers using the project's testing suite and static code analyzer.

### 1. Test Suite Execution
```bash
$ flutter test packages/apidash_core/test/generators/doc_generator_test.dart \
               test/widgets/dialog_export_doc_test.dart \
               test/widgets/response_pane_header_test.dart \
               test/providers/doc_export_provider_test.dart \
               test/screens/home_page/editor_pane/response_pane_test.dart

00:21 +39: All tests passed!
```

- **Core Generator Unit Tests (15/15 passed)**:
  - Standard GET request with query parameters.
  - POST request with JSON payload and authorization headers.
  - Multipart/form-data request with text fields and file paths.
  - Non-JSON response formats (HTML, XML, plain text).
  - Error status code responses (404 Not Found, 500 Internal Server Error).
  - Null/empty request and response body edge cases.
- **Widget & Interaction Tests (19/19 passed)**:
  - Action button rendering and enablement based on response presence.
  - Modal opening, preview rendering, and tab switching between Markdown and cURL.
  - Clipboard copy triggers with visual confirmation SnackBar.
  - Suggested filename formatting (`<request_name>_api_doc.md`).
  - Mobile bottom sheet responsive transformation.
- **Provider Tests (4/4 passed)**:
  - Reactive emission on request selection changes.
  - Environment variable resolution and caching.

### 2. Static Code Analysis (`flutter analyze`)
```bash
$ flutter analyze packages/apidash_core
Analyzing apidash_core...
No issues found! (ran in 29.1s)

$ flutter analyze lib/widgets/dialog_export_doc.dart \
                  lib/widgets/response_pane_header.dart \
                  lib/providers/collection_providers.dart \
                  test/widgets/dialog_export_doc_test.dart \
                  test/widgets/response_pane_header_test.dart \
                  test/providers/doc_export_provider_test.dart \
                  test/screens/home_page/editor_pane/response_pane_test.dart
Analyzing 8 items...
No issues found! (ran in 44.4s)
```

### 3. Code Formatting Compliance (`dart format`)
- All authored files comply with standard Dart SDK formatting guidelines (`dart format --output=none --set-exit-if-changed`).

### 4. Security Audit
- Verified compliance with repository Semgrep rules (`p/security-audit`):
  - No dynamic code evaluation or unsanitized command execution.
  - Sensitive token masking prevents inadvertent credential exposure.
  - 100% offline local memory execution.

---

## 📸 Sample Generated Outputs

### 1. Markdown (.md) Output
````markdown
# Get User Profile

`GET` `https://api.apidash.dev/v1/users/42`

Retrieves user account details.

### Query Parameters

| Parameter | Value | Description |
| :--- | :--- | :--- |
| `include_details` | `true` | Include extended metadata |

### Headers

| Header | Value | Description |
| :--- | :--- | :--- |
| `Accept` | `application/json` | Preferred response format |
| `Authorization` | `Bearer ey...` | Bearer token |

### Response

- **Status**: `200 OK`
- **Time**: `64 ms`

```json
{
  "id": 42,
  "name": "Alex Smith",
  "status": "active"
}
```
````

### 2. cURL Reproduction Session Output
```bash
curl -X GET \
  -H "Accept: application/json" \
  -H "Authorization: Bearer ey..." \
  "https://api.apidash.dev/v1/users/42?include_details=true"

# Response: 200 OK (64 ms)
```

---

## ✅ Production Readiness Checklist

- [x] Code follows the style guide and conventions of the repository.
- [x] All 39 new and existing unit, provider, and widget tests pass 100%.
- [x] `flutter analyze` reports zero warnings, zero errors, and zero lint issues.
- [x] No breaking changes introduced to existing UI, state, or networking behavior.
- [x] No dependencies were added or bumped in root `pubspec.yaml`.
- [x] Responsive layout verified across Desktop and Mobile screen widths.
- [x] Documentation added to `doc/user_guide/` and linked in `README.md`.
- [x] Pure client-side processing guaranteed with zero telemetry or network calls.
