### About

1. **Full Name**: Samarth vala
2. **Contact Info**: samarthsinh2660@gmail.com
3. **Discord Handle**: samarthsinh2660 *(API Dash Discord server)*
4. **Home Page**: —
5. **Blog**: —
6. **GitHub**: [github.com/samarthsinh2660](https://github.com/samarthsinh2660)
7. **LinkedIn**: [linkedin.com/in/samarthsinh2660](https://www.linkedin.com/in/samarth-vala-489a3428a/)
8. **Time Zone**: IST (UTC+5:30)
9. **Resume**: [*resume*](https://drive.google.com/file/d/1tbdMyEQdSowR8vY6yq30Ig4VBAh0HrI_/view?usp=drive_link)

---

### University Info

1. **University**: *
Pandit Deendayal Energy University- PDEU*
2. **Program**: *btech computer enigneer*
3. **Year**: *3rd year*
4. **Expected Graduation**: *july 2027*

---

### Motivation & Past Experience

**1. Have you worked on or contributed to a FOSS project before?**

Yes — I am an active contributor to API Dash itself. My recent merged/open contributions include:

- **[Streaming Responses in Dashbot](https://github.com/samarthsinh2660/apidash/pull/new/resolve-issue-1202)** — Wired up the existing `streamGenAIRequest()` SSE infrastructure to deliver real-time token-by-token streaming in Dashbot ([resolve-issue-1202](https://github.com/samarthsinh2260/apidash/tree/resolve-issue-1202)). Used a buffer-and-parse-at-end strategy to handle structured JSON safely during streaming.
- I have studied the full Dashbot architecture end-to-end: `ChatRemoteRepository`, `ChatViewmodel`, `AIAgentService`, `blueprint.dart`, `ai_request_utils.dart`, and the `genai` package's SSE pipeline.

Outside API Dash I have experience with:
- **Jest & integration test infrastructure** — built deterministic test harnesses for backend services in Node/TypeScript
- **CI/CD pipeline authoring** — GitHub Actions, structured diagnostic output
- **Backend systems in Python and TypeScript** — REST/GraphQL service development and validation

**2. What is your one project/achievement that you are most proud of?**

Contributing streaming support to Dashbot (#1202) gave me a deep end-to-end view of API Dash's AI pipeline. I had to trace the entire call chain — from `ChatState` and Riverpod state management through `ChatRemoteRepository`, through `streamGenAIRequest()` and SSE parsing in `ai_request_utils.dart`, to the `ChatBubble` UI — and design a solution that avoided `FormatException` during partial JSON streaming. The "buffer-and-parse-at-end" approach I chose is the same pattern MCP test harnesses need: accumulate protocol messages, validate only when the exchange is complete. That insight directly informs this proposal.

**3. What kind of problems motivate you the most?**

Infrastructure-layer problems: the ones invisible to end users but that determine whether a protocol or ecosystem is trustworthy at scale. Schema validation, structured diagnostics, reproducible test harnesses, and CI integration — these are the foundations that let large teams build confidently. MCP is a young protocol; the absence of a rigorous test harness is the highest-leverage problem in its ecosystem right now.

**4. Will you be working on GSoC full-time?**

Yes, full-time for the GSoC duration.

**5. Do you mind regularly syncing up with the project mentors?**

Not at all — I welcome it. Regular syncs keep the work aligned and surface course corrections early.

**6. What interests you the most about API Dash?**

API Dash occupies a unique position: it is simultaneously a serious developer tool (multi-platform, multi-protocol, OpenAPI/cURL import) and a growing AI-native platform (Dashbot, `genai` package, `AIAgentService`). The monorepo architecture with Melos is clean and designed for extension. The fact that streaming, agentic, and MCP infrastructure are all in early stages means the architectural decisions made now will shape the project for years.

**7. Areas where the project can be improved:**

- **No MCP protocol layer** — API Dash can send and receive HTTP, but has no way to validate that an MCP server's tool manifest conforms to the spec, or that its responses are schema-correct.
- **Agentic engine needs test coverage** — `AIAgentService` and `blueprint.dart` have no dedicated test harness; retry/backoff logic is untested.
- **No headless/CI test mode** — all AI testing requires a live model endpoint; a mock server harness would enable deterministic, offline CI.
- **No structured diagnostic output** — errors from the genai pipeline surface as raw `debugPrint` strings; a typed `ValidationResult` would make failures actionable.

---

### Project Proposal Information

**1. Proposal Title**

MCP Testing Infrastructure for API Dash

**2. Abstract**

The Model Context Protocol (MCP) is the emerging standard for how AI agents discover and interact with tools and data — the equivalent of REST for the AI tooling layer. API Dash's GSoC 2026 idea #1 calls for capabilities to *build and test* MCP servers and clients. Today, no such infrastructure exists in the codebase: there is no schema validator, no mock server harness, no deterministic test runner, and no CI integration for MCP flows.

This proposal delivers a layered MCP testing infrastructure inside the API Dash monorepo:

1. **`packages/mcp_validator/`** — a Dart package that validates MCP tool manifests, server capability declarations, and protocol exchanges against the official JSON Schema spec. Outputs typed `ValidationResult` with structured diagnostics.
2. **`MCPMockServer`** — a minimal headless Dart HTTP server that simulates MCP server behavior for offline, deterministic testing.
3. **`MCPTestRunner`** — a CLI-compatible test runner (melos task) that executes declarative MCP test cases and emits structured output (JSON + TAP) for CI.
4. **API Dash integration** — surface the validator inside Dashbot and the import pipeline so developers get immediate, actionable feedback when connecting an MCP server.

The work is infrastructure-first: no vague "AI agent" features, no UI-heavy sprints. Every deliverable is a precise, testable, independently useful component.

**3. Detailed Description**

---

#### 3.1 Why MCP matters for API Dash

MCP defines a standard JSON-over-HTTP (and stdio) protocol where a *server* exposes `tools`, `resources`, and `prompts` — and a *client* (like Dashbot) calls them. The spec mandates:

- A `tools/list` endpoint returning an array of tool definitions (name, description, `inputSchema` as JSON Schema)
- A `tools/call` endpoint accepting `{name, arguments}` and returning structured `content`
- A `ServerInfo` handshake with `capabilities`, `protocolVersion`

When these contracts are violated — wrong types, missing required fields, schema mismatches — AI agents silently fail or produce garbage. A test harness that catches these violations at development time is the highest-value infrastructure investment in the MCP ecosystem.

API Dash already has:
- `packages/genai/lib/agentic_engine/` — `AIAgent` blueprint + `AIAgentService` with retry/backoff
- `packages/better_networking/` — HTTP client (`sendHttpRequest`, `streamHttpRequest`)
- Melos monorepo with established package conventions

This proposal adds the missing validation and testing layer on top of what already exists.

---

#### 3.2 Component 1 — `packages/mcp_validator/`

**Purpose**: Validate that an MCP server's responses conform to the protocol spec.

**Design**:

```
packages/mcp_validator/
├── lib/
│   ├── mcp_validator.dart           ← public API
│   ├── models/
│   │   ├── mcp_tool.dart            ← Freezed: Tool { name, description, inputSchema }
│   │   ├── mcp_resource.dart        ← Freezed: Resource { uri, name, mimeType }
│   │   ├── mcp_server_info.dart     ← Freezed: ServerInfo { name, version, capabilities }
│   │   ├── mcp_call_result.dart     ← Freezed: CallResult { content, isError }
│   │   └── validation_result.dart   ← Freezed: ValidationResult { isValid, errors: List<ValidationError> }
│   └── validators/
│       ├── tool_manifest_validator.dart   ← validates tools/list response
│       ├── server_info_validator.dart     ← validates initialize handshake
│       ├── call_result_validator.dart     ← validates tools/call response
│       └── json_schema_validator.dart     ← validates tool arguments against inputSchema
└── test/
    ├── tool_manifest_validator_test.dart
    ├── server_info_validator_test.dart
    ├── call_result_validator_test.dart
    └── json_schema_validator_test.dart
```

**Key types**:

```dart
// ValidationError carries enough context to be actionable in CI logs
class ValidationError {
  final String field;       // e.g. "tools[2].inputSchema.properties"
  final String message;     // e.g. "required field 'type' is missing"
  final ErrorSeverity severity; // error | warning
}

class ValidationResult {
  final bool isValid;
  final List<ValidationError> errors;
  final List<ValidationError> warnings;
}
```

**What it validates** (against MCP spec):

| Check | Spec reference |
|---|---|
| `tools/list` → array of `{name: string, description: string, inputSchema: object}` | MCP tools spec §3 |
| Each `inputSchema` is a valid JSON Schema draft-7 object | JSON Schema |
| `tools/call` response has `content: [{type, text/data}]` | MCP tools spec §4 |
| `initialize` response has `protocolVersion`, `capabilities`, `serverInfo` | MCP lifecycle §2 |
| `protocolVersion` matches a known version string | MCP versioning |

This is infrastructure, not opinion. Every check maps to a normative spec requirement.

---

#### 3.2 Component 2 — `MCPMockServer`

**Purpose**: A headless Dart HTTP server that simulates an MCP-compliant server. Allows fully offline, deterministic testing with no live model required.

```dart
final server = MCPMockServer(
  tools: [
    MockTool(
      name: 'get_weather',
      description: 'Returns current weather',
      inputSchema: {'type': 'object', 'properties': {'city': {'type': 'string'}}, 'required': ['city']},
      handler: (args) async => MCPCallResult(content: [MCPContent.text('Sunny, 28°C')]),
    ),
  ],
);
await server.start(port: 0); // ephemeral port for test isolation
```

Features:
- Implements `POST /initialize`, `POST /tools/list`, `POST /tools/call`
- Returns spec-compliant responses by default; can be configured to return malformed responses for negative testing
- Ephemeral port binding — safe to run in parallel test suites
- No Flutter dependency — pure Dart, usable in `dart test` without a device

---

#### 3.3 Component 3 — `MCPTestRunner`

**Purpose**: Declarative, headless test runner for MCP flows. CI-native.

**Test case DSL** (YAML-driven, similar to API Dash's existing collection format):

```yaml
# mcp_tests/get_weather.yaml
name: "Weather tool smoke test"
server: http://localhost:8080
steps:
  - action: initialize
    expect:
      protocolVersion: "2024-11-05"
      capabilities.tools: { listChanged: false }
  - action: tools/list
    expect:
      tools[name=get_weather].inputSchema.required: ["city"]
  - action: tools/call
    input: { name: get_weather, arguments: { city: "London" } }
    expect:
      content[0].type: text
      content[0].text: { contains: "°C" }
```

**Runner output** (structured JSON for CI + human-readable TAP):

```json
{
  "suite": "get_weather",
  "passed": 3,
  "failed": 0,
  "results": [
    { "step": "initialize", "status": "pass", "duration_ms": 12 },
    { "step": "tools/list", "status": "pass", "duration_ms": 8 },
    { "step": "tools/call", "status": "pass", "duration_ms": 34 }
  ]
}
```

**Melos integration**:

```yaml
# melos.yaml addition
scripts:
  mcp-test:
    run: dart run packages/mcp_validator/bin/mcp_test_runner.dart
    description: Run MCP protocol conformance tests
```

---

#### 3.4 Component 4 — API Dash Integration

Once the validator and mock server are solid, surface them inside API Dash:

- **Import pipeline**: when a user adds an MCP server URL (analogous to OpenAPI import), run `MCPSchemaValidator` on the `initialize` + `tools/list` response and surface `ValidationError`s in the UI with actionable messages.
- **Dashbot integration**: when Dashbot calls a tool via MCP, validate the `tools/call` response before passing content to the LLM context. Malformed responses are caught before they cause hallucinations.
- **Settings / connection test**: a "Test MCP Server" button that runs the conformance suite headlessly and shows a pass/fail badge.

---

#### 3.5 Initial PR Signal — Why This Approach

The first merged PR will be the `mcp_validator` package with:
- Typed Freezed models for all MCP protocol objects
- `ToolManifestValidator` with 30+ unit test cases (valid manifests, missing fields, wrong types, malformed `inputSchema`)
- `ValidationResult` with structured `ValidationError` — same diagnostic pattern used in webpack's `StatsError`

This signals:
- **Protocol literacy** — demonstrates reading and implementing spec requirements precisely
- **Testing depth** — >30 unit tests, including negative cases and edge cases
- **Monorepo discipline** — correctly adds a new Melos-managed package with its own `pubspec.yaml`, `analysis_options.yaml`, and test suite
- **Architectural restraint** — no UI, no live network calls, no AI features. Just a clean validator with a typed API.

Mentors recognize this pattern: it is exactly how webpack's `StatsValidator`, Jest's `expect` matchers, and OpenAPI's schema validators are built. It is the foundation every higher-level feature depends on.

---

**4. Weekly Timeline**

| Week | Deliverables |
|---|---|
| **1** | Deep-dive MCP spec (tools, resources, prompts, lifecycle). Audit `genai/agentic_engine/`, `better_networking/`, existing Melos package conventions. Write spec summary doc. |
| **2** | Scaffold `packages/mcp_validator/`. Implement Freezed models: `MCPTool`, `MCPResource`, `MCPServerInfo`, `MCPCallResult`, `ValidationResult`, `ValidationError`. |
| **3** | Implement `ToolManifestValidator` + 30 unit tests. PR #1: validator package (the initial infrastructure PR). |
| **4** | Implement `ServerInfoValidator` + `CallResultValidator`. Add JSON Schema draft-7 validation for `inputSchema` fields. Expand test suite. |
| **5** | Implement `MCPMockServer` (pure Dart HTTP, no Flutter). Ephemeral port binding, configurable tool handlers, error injection mode. |
| **6** | Unit + integration tests for `MCPMockServer`. Validate that `MCPMockServer` ↔ `MCPSchemaValidator` round-trip produces zero validation errors for spec-compliant exchanges. |
| **7** | Design YAML-based test case DSL. Implement `MCPTestRunner` core: parse YAML, execute steps against a running server, collect results. |
| **8** | Implement structured output (JSON + TAP). Melos script integration (`melos run mcp-test`). GitHub Actions workflow: spin up `MCPMockServer`, run `MCPTestRunner`, fail CI on validation errors. |
| **9** | API Dash import pipeline integration: MCP server URL import flow (analogous to OpenAPI import). Calls `initialize` + `tools/list`, runs validator, surfaces errors in UI. |
| **10** | Dashbot integration: validate `tools/call` responses before passing content to LLM context. "Test MCP Server" connection button in settings. |
| **11** | Documentation: dev guide for MCP testing (`doc/dev_guide/mcp_testing.md`). Contributor guide for adding new validator rules. Update architecture doc. |
| **12** | Final integration tests end-to-end. Code review feedback integration. Buffer for scope adjustments. Final PR(s) submitted. |

---

**Relevant GSoC 2026 Ideas:**
- [Idea #1 — MCP Testing](https://github.com/foss42/apidash/discussions/1054) (175 hours, Medium-High)
- [Idea #6 — CLI & MCP Support](https://github.com/foss42/apidash/discussions/1054) (90 hours, Easy-Medium, PR #795)
