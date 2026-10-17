# API Dash Core

Contains shared core utilities, models, import/export adapters, and documentation/session generators for API Dash.

## Modules

- `generators`: Pure Dart documentation and reproduction generators (`DocGenerator`, `MarkdownDocGenerator`, `CurlSessionGenerator`, `format_utils.dart`) for exporting requests and responses to Markdown and cURL sessions. Fully validated with 100% test pass rate across unit and edge-case suites (`doc_generator_test.dart`).
- `import_export`: Importers and exporters for various API formats (HAR, Postman, etc.).
- `models`: Core data models such as environments.
