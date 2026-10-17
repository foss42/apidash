# [Feat] Add Markdown API Documentation and Session Exporter for Request & Response

## Feature Summary
Currently, API Dash offers powerful code generation for client libraries (Dart, Python, JavaScript, etc.) and allows exporting collections as HAR files. However, developers frequently need to share a snapshot of an API interaction (request headers, body, parameters, and received response) in:
- Issue trackers (GitHub Issues, Jira tickets)
- Engineering pull request descriptions
- Team documentation and wiki pages (Notion, Obsidian, Confluence)
- Quick debugging / triage chats

To support this workflow, we propose adding a **Markdown API Documentation & Reproduction Session Exporter**.

---

## Proposed Solution & User Flow
1. **Trigger in Response Pane Header**: When an active request has been executed and response data is present, an **"Export API Documentation"** button (`Icons.description_outlined`) appears in the `ResponsePaneHeader`.
2. **Interactive Preview Dialog (`ExportDocumentDialog`)**:
   - Offers two segmented format options:
     - **Markdown (.md)**: Formats method, endpoint URL, headers table, parameters table, formatted payload, response status, latency, and syntax-highlighted response body into clean GitHub Flavored Markdown.
     - **cURL Session**: Multi-line bash-executable `curl` command with flag breakdown (`-X`, `-H`, `--data`, `-F`) and appended response comment (`# Response: 200 OK (45 ms)`) for instant shell reproduction.
   - Built-in syntax preview using `PreviewerCode`.
   - Action controls: **Copy to Clipboard** (with SnackBar feedback) and **Save to File** (using native OS file dialog via `file_selector`).
3. **Cross-Platform Responsive UX**:
   - Desktop: Opens an ergonomic 700x500 modal.
   - Mobile: Adapts to a full-width draggable/scrollable bottom sheet (`ExportDocumentSheet`).
4. **State Management**:
   - Clean Riverpod computed provider `selectedDocExportProvider` caching formatted output reactively.
5. **Zero Server Footprint**:
   - 100% offline client-side generation without transmitting data or invoking cloud endpoints.

---

## Scope & Implementation Breakdown
- **Milestone 1**: Core Data Contracts, `MarkdownDocGenerator`, and `CurlSessionGenerator` in `packages/apidash_core/lib/generators/`.
- **Milestone 2**: UI Trigger in `ResponsePaneHeader`, `ExportDocumentDialog`, `FlutterClipboard` integration, and native file saving via `file_selector`.
- **Milestone 3**: Riverpod state wiring and responsive layout constraints (`context.isMediumWindow`, `context.isSmallWindow`).
- **Milestone 4**: Quality Assurance with unit tests, widget tests, and Melos workspace verification.
- **Milestone 5**: User guides and documentation.

---

## Community Feedback
We welcome feedback from the maintainers and community on output template structure or additional desired formats!
