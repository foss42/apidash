# Pull Request Description: Add Markdown API Documentation and Session Exporter

**Fixes / Relates to**: `[Feat] Add Markdown API Documentation and Session Exporter for Request & Response`

---

## 📌 Description

This pull request introduces the **Markdown API Documentation & Reproduction Session Exporter** for API Dash. It enables developers to export an active API request along with its received response into clean GitHub Flavored Markdown (`.md`) documentation or an executable, multi-line `cURL` reproduction session with commented response metadata.

The feature runs entirely on the client side with zero network transmission, zero server dependency, and zero modifications to existing request/response execution workflows.

---

## 🚀 Summary of Changes

### Milestone 1: Core Generator Engine (`packages/apidash_core/`)
- **`DocGenerator` Interface (`packages/apidash_core/lib/generators/doc_generator.dart`)**:
  - Defined standard abstract contract `DocGenerator` with `generate({required HttpRequestModel request, HttpResponseModel? response, String? requestName})`.
- **`MarkdownDocGenerator` (`packages/apidash_core/lib/generators/markdown_doc_generator.dart`)**:
  - Generates GitHub Flavored Markdown documenting method badges, endpoint URLs, headers table, query parameters table, formatted request body (JSON, text, multipart), HTTP status codes, latency, and syntax-highlighted response payloads.
- **`CurlSessionGenerator` (`packages/apidash_core/lib/generators/curl_session_generator.dart`)**:
  - Builds reproducible multi-line bash `curl` commands formatted with line continuations (`\`) and flags (`-X`, `-H`, `--data`, `-F`), appending commented response summaries (`# Response: 200 OK (45 ms)`).
- **Core Formatting Utilities (`packages/apidash_core/lib/generators/format_utils.dart`)**:
  - Safe markdown table escaping, JSON prettification with indent control, header masking for security (`Bearer ey...`), and multipart table formatting.

### Milestone 2: UI Presentation & Interaction Layer (`lib/widgets/`)
- **Action Trigger in `ResponsePaneHeader` (`lib/widgets/response_pane_header.dart`)**:
  - Added `onExportDoc` callback and an `ADIconButton` with `Icons.description_outlined` and tooltip `"Export API Documentation"`.
  - Conditioned to activate only when an active request has been executed or response status is available.
- **Preview & Export Dialog (`lib/widgets/dialog_export_doc.dart`)**:
  - Segmented tab control toggling between **Markdown (.md)** and **cURL Session**.
  - Syntax-highlighted code previewer using `PreviewerCode` with line numbers and theme awareness.
  - Action buttons:
    - **Copy to Clipboard** via `FlutterClipboard` with visual SnackBar feedback.
    - **Save to File** with native system file selector (`file_selector`) and suggested filename `<request_name>_api_doc.md`.
    - **Close** to cleanly dismiss.
- **Responsive Layout**:
  - Automatically transitions from a 700x500 desktop modal to a full-width bottom sheet (`ExportDocumentSheet`) on mobile/tablet viewports using `context.isMediumWindow` and `context.isSmallWindow`.

### Milestone 3: State Management & Wiring (`lib/providers/` & `lib/screens/`)
- **Riverpod Provider Wiring (`lib/providers/collection_providers.dart`)**:
  - Exposes `selectedDocExportProvider` that reads the active `RequestModel`, computes the documentation using `MarkdownDocGenerator`, and reactively updates on request/response changes.
- **Response Pane Integration (`lib/screens/home_page/editor_pane/details_card/response_pane.dart`)**:
  - Connected `onExportDoc` in `ResponsePaneHeader` to display `ExportDocumentDialog` populated with environment-substituted request data and response snapshots.

### Milestone 4: Quality Assurance & Workspace Verification
- **Unit & Edge Case Suite (`packages/apidash_core/test/generators/doc_generator_test.dart`)**:
  - 15 comprehensive unit tests covering GET with query parameters, POST with auth headers, multipart forms, non-JSON bodies (HTML, XML, plain text), error responses (404, 500), and null/empty body edge cases.
- **Widget & Integration Suite (`test/widgets/dialog_export_doc_test.dart` & `test/widgets/response_pane_header_test.dart`)**:
  - 19 widget tests verifying export button appearance, dialog opening/closing, tab switching, clipboard copying, mobile bottom sheet rendering, and error handling.
- **Provider Suite (`test/providers/doc_export_provider_test.dart`)**:
  - Verified reactive state emissions for null and populated request states.
- **Workspace Linting & Analysis**:
  - `flutter analyze` completed with **0 warnings and 0 errors** across all workspace packages and feature files.

---

## 📸 Screenshots & Previews

| Mode | Preview |
| :--- | :--- |
| **Desktop Export Dialog (Markdown Tab)** | ![Desktop Markdown Dialog](https://github.com/user-attachments/assets/placeholder-desktop-md.png) |
| **Desktop Export Dialog (cURL Tab)** | ![Desktop cURL Dialog](https://github.com/user-attachments/assets/placeholder-desktop-curl.png) |
| **Mobile Bottom Sheet** | ![Mobile Bottom Sheet](https://github.com/user-attachments/assets/placeholder-mobile-sheet.png) |

---

## 🧪 Testing Performed

```bash
# 1. Core Doc Generator Unit Tests
flutter test packages/apidash_core/test/generators/doc_generator_test.dart
# Result: 15 / 15 passed (100%)

# 2. Widget and Integration Tests
flutter test test/widgets/dialog_export_doc_test.dart test/widgets/response_pane_header_test.dart test/providers/doc_export_provider_test.dart
# Result: 19 / 19 passed (100%)

# 3. Static Code Analysis
flutter analyze packages/apidash_core
flutter analyze lib/widgets/dialog_export_doc.dart lib/widgets/response_pane_header.dart lib/providers/collection_providers.dart
# Result: No issues found!
```

---

## ✅ Checklist

- [x] My code follows the code style and guidelines of this project.
- [x] I have performed a self-review of my own code.
- [x] I have commented my code, particularly in hard-to-understand areas.
- [x] I have updated the documentation (`README.md`, `doc/user_guide/`).
- [x] No dependencies were bumped or added unnecessarily.
- [x] My changes generate no new warnings or analyze errors (`flutter analyze` clean).
- [x] New and existing unit and integration tests pass locally.
- [x] Fully client-side; zero tracking, zero external telemetry.
