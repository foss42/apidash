# DashAssert — Assertion Engine User Guide

DashAssert adds automated response verification to API Dash.
After sending a request, open the **Assertions** tab to define rules
that every response must satisfy.

## Quick Start

1. Send any API request
2. Click the **Assertions** tab in the response pane
3. Click **✨ AI Suggest** to auto-generate rules from the live response, OR
   click **Templates** to apply a preset
4. Click **▶ Run All** to execute all rules
5. View results inline — green ✓ = pass, red ✗ = fail with actual vs. expected diff

## Assertion Types

| Type | What it checks | Example |
|------|---------------|---------|
| Status Code | HTTP status code | `200` |
| JSON Field Exists | Field present via dot-notation | `data.user.id` |
| JSON Field Value | Field has specific value | `status` = `"active"` |
| Header Exists | HTTP header is present | `content-type` |
| Header Value | Header has specific value | `content-type` = `application/json` |
| Body Contains | Substring in response body | `"success"` |
| Response Time Under | Response faster than threshold (ms) | `< 500` |
| **JSON Schema Valid** | Entire body matches JSON Schema | `{"type":"object","required":["id"]}` |

## JSON Path Navigation

Use dot-notation to access nested fields:

```
user.email              → {"user": {"email": "test@example.com"}}
data.items.0.title      → first item in an array
meta.pagination.total   → deeply nested value
```

## Templates

Click **Templates** to instantly apply a preset suite of rules:

| Preset | Rules Included |
|--------|---------------|
| 🌐 REST Standard | Status 200, Content-Type present, time < 2000ms |
| 🔐 Auth Protected | Status 401, WWW-Authenticate header present |
| ✏️ CRUD Success | Status 201, id field exists, time < 1000ms |
| 📋 Paginated List | Status 200, data array exists, total field exists |

Presets are deduplicated — applying the same template twice will not add duplicate rules.

## JSON Schema Validation

Paste or type a JSON Schema to validate the entire response body structure:

```json
{
  "type": "object",
  "required": ["id", "name", "email"],
  "properties": {
    "id":    { "type": "integer" },
    "name":  { "type": "string", "minLength": 1 },
    "email": { "type": "string" },
    "age":   { "type": "integer", "minimum": 0, "maximum": 150 }
  }
}
```

### Supported Schema Keywords

| Keyword | Applies to | Description |
|---------|-----------|-------------|
| `type` | any | `string`, `number`, `integer`, `boolean`, `array`, `object`, `null` |
| `required` | object | Array of required property names |
| `properties` | object | Per-property sub-schemas (recursive) |
| `items` | array | Sub-schema applied to every array element |
| `minimum` / `maximum` | number | Numeric range constraints |
| `minLength` / `maxLength` | string | String length constraints |
| `enum` | any | Value must be one of the listed options |

The **✨ AI Suggest** button will auto-generate a schema based on the top-level
keys of the current response body.

## Exporting Results

Click **Export ▼** to download:
- **Markdown** — human-readable report, perfect for GitHub PRs and wikis
- **JSON** — machine-readable, suitable for CI/CD pipeline integration

## Run History

Every time you click **Run All**, DashAssert saves a result snapshot.
Expand the **Run History** section at the bottom of the panel to see:
- Pass count vs. total over time
- HTTP status code at time of each run
- Relative timestamps ("just now", "5m ago", "2h ago")

History is capped at 20 entries per request.

## Live Tab Badge

After running assertions, the **Assertions** tab shows a live badge
(e.g. `3/4`) indicating how many rules passed. The badge is green when
all rules pass, and red when any rule fails.

## Architecture

DashAssert follows the existing API Dash patterns:

- **Model layer** — `AssertionRule`, `AssertionSuite`, `AssertionRun` in `lib/models/`
- **Service layer** — `AssertionEngine` + `AiAssertionSuggester` in `lib/services/`
- **State layer** — `AssertionSuitesNotifier` (Riverpod) in `lib/providers/`
- **Widget layer** — `AssertionPanel` in `lib/widgets/`, integrated into the response pane

Zero new pub.dev dependencies — all schema validation is implemented from
scratch in pure Dart.
