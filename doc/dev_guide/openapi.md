# OpenAPI

The OpenAPI import feature was failing when trying to import specifications from URLs like https://catfact.ninja/docs?api-docs.json. The error "The fetched content does not look like a valid OpenAPI spec (JSON or YAML)" was shown even though the content was a valid OpenAPI 3.0 specification. This was caused by a bug in the openapi_spec package (v0.15.0) that cannot parse OpenAPI specs containing "security": [[]] (empty security arrays), which is valid according to the OpenAPI 3.0 specification.

> Fix

Added a workaround in OpenApiImportService.tryParseSpec() that detects parsing failures and automatically removes problematic security fields containing empty arrays before retrying the parse operation. This is a temporary workaround until the upstream package is fixed.

- [APIDash](https://drive.google.com/file/d/1CWocxCVW99-bEWkZlwInGq0JykHalv9a/view?usp=sharing) - Works without any fix
- [Cat Fact API](https://drive.google.com/file/d/1ox71b3tT4Lv-9jw7zV1ronWQR_uW3K25/view?usp=drive_link) - Works with this fix
- [DigitalOcean Droplet Metadata API](https://drive.google.com/file/d/1XKZXJvrwvAVm3OVBEZFhScOuCMjPJBZh/view?usp=drive_link) - Works without any fix
- [GitHub v3 REST API](https://drive.google.com/file/d/1WcJXSosHPD0uiybJrqpJSknM5FA0De02/view?usp=drive_link) - Doesn't Work
- [Swagger Petstore](https://drive.google.com/file/d/1LBqBrlcsXo7Clr7VKn7CYe75c_H4U8zQ/view?usp=drive_link) - Doesn't Work
- [RailwayStations REST API](https://drive.google.com/file/d/1jVFk-hNf_gb_VeBuAomOgh6tWByU9Fyi/view?usp=drive_link) - Doesn't Work
- [UniProt REST API Server](https://drive.google.com/file/d/1KTIqKC7SludxsyCYN6kXWQySve4GpbhD/view?usp=drive_link) - Doesn't Work
- [VIT-AP VTOP API](https://drive.google.com/file/d/1B5Mh3IK2uUBoRSocEKQd2Dvf7SZWm03M/view?usp=drive_link) - Works without any fix

It’s not our parser that causes the issue. The failures come from the documents themselves and how the openapi_spec package (correctly) enforces OpenAPI shapes. Valid security fields work fine as per the package docs; the broken cases are due to invalid spec content.

### Findings per document

- cat_facts.json (also the Cat Facts URL)

  - Problem: Top-level security is malformed: security: [[]]
  - Why it fails: In OpenAPI 3.0, top-level security must be an array of SecurityRequirement objects (maps). Examples:
    - Valid: security: [] (no requirements) or security: [ { api_key: [] } ]
    - Invalid: security: [[]] (array of arrays)
  - openapi_spec error: type 'List<dynamic>' is not a subtype of type 'Map<String, dynamic>'
  - Conclusion: The document is invalid. This is not a general “security field” issue, just this malformed shape.

- railway-stations.yaml

  - Problem: Component parameter reference points to a Parameter missing required fields (e.g., 'in').
  - Error: CheckedFromJsonException: Could not create Parameter. There is a problem with "in". Invalid union type "null"!
  - The stack/message points at $ref: #/components/parameters/Authorization.
  - Conclusion: Not related to security. The referenced Parameter definition is incomplete (missing in: header|query|path|cookie) or otherwise invalid.

- travel.yaml

  - Problem: Same class of failure as railway-stations.yaml, with a parameter ref like $ref: #/components/parameters/page.
  - Error: CheckedFromJsonException... problem with "in" (Invalid union type "null").
  - Note: components.securitySchemes is present here and is not the cause.
  - Conclusion: Also a spec issue with parameter component definitions/references.

- digitalocean.yaml
  - Result: Parses successfully with openapi_spec.
  - Note: No top-level security; nothing problematic here.
  - Conclusion: Confirms the parser handles valid documents correctly.

Steps to reproduce failures from local files,

```
import 'dart:io';
import 'package:openapi_spec/openapi_spec.dart';

void main(List<String> args) async {

  // Pass file paths as args below.
  final paths = args.isNotEmpty
      ? args
      : <String>[
          './cat_facts.json',
          './railway-stations.yaml',
        ];

  for (final p in paths) {
    stdout.writeln('\n=== Parsing: $p ===');
    final f = File(p);
    if (!await f.exists()) {
      stdout.writeln('Skip: file not found');
      continue;
    }

    final content = await f.readAsString();

    try {
      final spec = OpenApi.fromString(source: content, format: null);
      stdout.writeln('SUCCESS: title="${spec.info.title}", version="${spec.info.version}"');
      stdout.writeln('Paths: ${spec.paths?.length ?? 0}');
    } catch (e, st) {
      final err = e.toString();
      stdout.writeln('FAIL: ${err.substring(0, err.length.clamp(0, 400))}...');
      // Stack Trace
      final stStr = st.toString();
      if (stStr.isNotEmpty) {
        stdout.writeln('Stack:\n$stStr');
      }
    }
  }
}
```

### How to run

- Create a new dart project, put the openapi spec file and this script there.
- Add the depndency, `dart pub add openapi_spec: ^0.15.0`
- Run:
  - `dart run path/to/this/file`

### Expected outcomes

- `cat_facts.json`

  - FAIL with an error like:
    - type 'List<dynamic>' is not a subtype of type 'Map<String, dynamic>'
  - This is triggered by the invalid top-level security shape: security: [[]]

- `railway-stations.yaml`
  - FAIL with an error like:
    - CheckedFromJsonException: Could not create `Parameter`. There is a problem with "in". Invalid union type "null"!
  - This points to a components/parameters reference missing required “in”.
