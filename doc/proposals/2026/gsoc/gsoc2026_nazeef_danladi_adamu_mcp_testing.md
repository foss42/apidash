# GSoC 2026 Proposal: Model Context Protocol (MCP) Testing and Development Framework

## Contributor Information

| Field | Details |
|-------|---------|
| **Name** | Nazeef Danladi Adamu |
| **Email** | Nazeefdk@gmail.com |
| **GitHub** | [github.com/nazifsco](https://github.com/nazifsco) |
| **LinkedIn** | [linkedin.com/in/nazeefos](https://www.linkedin.com/in/nazeefos) |
| **Location** | Nigeria (WAT, UTC+1) |
| **University** | Abubakar Tafawa Balewa University (ATBU) |
| **Program** | Postgraduate Diploma (current); B.Eng Civil Engineering (graduated) |
| **Project Size** | Large - 350 hours |
| **Mentors** | Ankit Mahato, Ashita Prasad, Ragul Raj M, Manas Hejmadi |

---

## 1. Abstract

The Model Context Protocol (MCP) is rapidly becoming the standard interface connecting agentic AI systems to external tools, data sources, and services. As adoption accelerates across the developer ecosystem, the absence of a dedicated open-source testing framework creates a critical gap: teams building MCP servers and clients today have no standardised way to validate protocol correctness, simulate edge cases, or integrate conformance checks into CI/CD pipelines.

This proposal describes the design and implementation of a comprehensive MCP Testing and Development Framework for API Dash. The framework consists of three integrated components:

1. A **Python-based headless test runner** for automated conformance testing and CI/CD integration
2. A **configurable mock MCP server** for client-side development and edge-case simulation
3. A **React-powered interactive playground** for schema visualisation and manual exploration

All three components are designed as standalone companion tools distributed alongside API Dash — invokable from the API Dash UI via platform channels (Flutter's `Process.run` / `dart:io`) — so they extend rather than replace the existing Flutter/Dart architecture. Together they give the growing MCP developer community a reliable, batteries-included toolkit for building and validating MCP-compliant software.

---

## 2. Motivation and Community Impact

We are at an inflection point in software development. Agentic AI systems that autonomously call tools, browse data, and chain actions are transitioning from research novelty to production reality. The Model Context Protocol is the infrastructure layer that makes this possible: a structured, JSON-RPC-based protocol that standardises how AI agents discover and invoke capabilities exposed by servers.

The pain point is real and well-documented. MCP server developers frequently report protocol-compliance issues that only surface at runtime: malformed JSON-RPC envelopes, missing required fields, and silent failures when tool schemas drift from what clients expect. Without a systematic testing tool, the only recourse is manual inspection or waiting for integration failures in production.

My interest in this project is grounded in direct experience. I built an AI-powered research orchestration tool ([research-dossier-app](https://github.com/nazifsco/research-dossier-app)) that coordinates multiple AI capabilities across a Python backend — the same architectural pattern MCP formalises. While building that system, I encountered the exact pain point this project addresses: there was no systematic way to test whether tool interfaces behaved correctly, handled errors gracefully, or conformed to the specification under load.

The impact of this project extends across three dimensions:

- **For MCP server authors:** automated conformance testing prevents protocol drift and catches breaking changes before they reach production
- **For MCP client developers:** a mock server enables thorough testing without requiring live infrastructure
- **For the AI/open-source ecosystem:** a high-quality, openly available testing framework raises the reliability bar across every MCP integration built on top of it

API Dash is already the most capable open-source API client for REST, GraphQL, and code generation. Adding first-class MCP testing reinforces its position as the definitive tool for developers building AI-connected applications.

---

## 3. Codebase Integration

API Dash is a Flutter/Dart desktop application. The three components proposed here are Python and TypeScript tools, so the integration strategy is deliberate and explicit.

**Distribution model:** The Python test runner and mock server are packaged as standalone CLI tools (installable via `pip`) and bundled with API Dash releases. The React playground is served as a local web app launched by API Dash on demand. This is a standard pattern for extending native apps with non-native tooling (VS Code's Python extension follows the same model).

**Flutter invocation layer:** API Dash will invoke the Python CLI tools using `dart:io`'s `Process.run` / `Process.start`, capturing stdout/stderr for display. A thin Dart wrapper class (`McpTestRunner`) will encapsulate the subprocess calls and parse the JSON output format. This keeps the Flutter codebase clean — it never needs to understand MCP protocol internals, only structured JSON results.

**Playground launch:** The React playground is launched as a local HTTP server (`localhost:7430`) via the same `Process.start` mechanism. API Dash opens it in the system browser or an embedded WebView. This approach was chosen over rebuilding the playground in Flutter because `react-jsonschema-form` provides battle-tested, schema-driven form generation that would require significant custom widget development to replicate in Flutter.

**Minimal Flutter-side changes required:** A new "MCP Testing" panel in the API Dash sidebar, a `McpTestRunner` Dart class (~150 lines), and a settings entry for the Python executable path. All MCP logic remains in the Python layer.

This design ensures the project ships real value even if Flutter integration is descoped — the CLI tools work independently from day one.

---

## 4. Technical Approach

### 4.1 System Architecture

```
+------------------------------------------------------------------------+
|              MCP TESTING AND DEVELOPMENT FRAMEWORK                     |
+------------------------+--------------------+---------------------------+
| COMPONENT A            | COMPONENT B        | COMPONENT C               |
| Headless Test Runner   | Mock MCP Server    | React Playground          |
| (Python CLI)           | (Python)           | (TypeScript/React)        |
+------------------------+--------------------+---------------------------+
| - YAML/JSON test specs | - Stub config      | - Schema visualisation    |
| - Protocol validator   | - Error injection  | - Auto param forms        |
| - HTML/JSON/MD reports | - Latency sim      | - Live result view        |
| - CI/CD integration    | - Auth simulation  | - Request history         |
+------------------------+--------------------+---------------------------+
                                   |
                 +---------------------------------+
                 |   TRANSPORT LAYER ABSTRACTION   |
                 |   stdio transport | HTTP/SSE    |
                 +---------------------------------+
                                   |
                   +------------------------------+
                   |     REAL MCP SERVER (DUT)    |
                   |   any MCP-compliant server   |
                   +------------------------------+

+--------------------------------------+
| FLUTTER INTEGRATION LAYER            |
| McpTestRunner (Dart)                 |
| - Process.start / Process.run        |
| - JSON result parsing                |
| - MCP panel UI in API Dash sidebar   |
+--------------------------------------+
         |                    |
   Component A CLI      Component C (localhost:7430)
```

### 4.2 MCP Spec Version

This project targets **MCP specification version 2025-03-26** (the current stable release as of the community bonding period). The conformance validator will pin to this version and expose a `--spec-version` flag so it remains usable as the spec evolves. Version negotiation logic will be abstracted into a `SpecRegistry` class to make adding future versions a one-file change.

### 4.3 Component A: Headless Test Runner (Python CLI)

The test runner acts as an MCP client, connects to any MCP server under test, and executes a suite of specification-driven test cases.

**Tech stack:** Python 3.11+, `mcp` SDK (PyPI: `mcp`), PyYAML, Jinja2, JSON Schema (`jsonschema`), `asyncio`, `typer` (CLI, built on `click` for fallback compatibility)

**Test specification format (YAML):**

```yaml
name: "Weather Tool Conformance Suite"
spec_version: "2025-03-26"
server:
  transport: stdio               # or http_sse
  command: "python weather_server.py"

tests:
  - name: "Tool discovery returns valid schema"
    action: list_tools
    expect:
      status: success
      schema_valid: true

  - name: "get_weather returns temperature field"
    action: call_tool
    tool: get_weather
    params: { city: "Lagos" }
    expect:
      status: success
      contains_field: temperature

  - name: "Missing required param returns error"
    action: call_tool
    tool: get_weather
    params: {}
    expect:
      status: error
      error_code: -32602        # JSON-RPC invalid params

  - name: "Prompt discovery returns valid schema"
    action: list_prompts
    expect:
      status: success
      schema_valid: true

  - name: "get_summary prompt renders correctly"
    action: get_prompt
    prompt: get_summary
    arguments: { topic: "climate" }
    expect:
      status: success
      contains_field: messages
```

The runner validates responses against JSON-RPC 2.0, the MCP specification, and user-defined assertions, then produces structured reports in HTML, JSON, and Markdown formats ready for CI/CD artifact pipelines (GitHub Actions, GitLab CI, Jenkins).

**Supported MCP operations:** `list_tools`, `call_tool`, `list_resources`, `read_resource`, `list_prompts`, `get_prompt`, `initialize`, `ping`

### 4.4 Component B: Mock MCP Server (Python)

The mock server allows client developers to test against a fully controllable MCP server without live infrastructure.

**Example mock configuration (`mock_config.json`):**

```json
{
  "tools": [
    {
      "name": "get_weather",
      "description": "Returns weather data for a city",
      "inputSchema": {
        "type": "object",
        "properties": { "city": { "type": "string" } },
        "required": ["city"]
      },
      "response": { "temperature": 28, "unit": "celsius", "city": "Lagos" }
    }
  ],
  "faults": [
    {
      "trigger": "call_tool:get_weather:params.city=timeout",
      "type": "timeout",
      "delay_ms": 5000
    },
    {
      "trigger": "call_tool:nonexistent_tool",
      "type": "error",
      "code": -32601,
      "message": "Method not found"
    }
  ],
  "latency": { "base_ms": 50, "jitter_ms": 20 },
  "auth": { "type": "bearer", "token": "test-token-abc123" }
}
```

Key capabilities:
- Configurable stub responses loaded from JSON fixture files
- Fault injection: configurable error responses, malformed JSON-RPC, network timeouts
- Latency simulation (fixed delay + random jitter)
- Auth simulation stubs (API key, Bearer token)
- Request capture for verifying client-side behaviour

### 4.5 Component C: React Interactive Playground (TypeScript)

A browser-based UI served locally that wraps the test runner and mock server with a visual interface. Developers can discover a server's tools, inspect JSON Schema definitions, construct parameterised calls with auto-generated forms, and view live results without writing test code.

**Tech stack:** React 18, TypeScript, Tailwind CSS, `@rjsf/core` (react-jsonschema-form) with custom widget overrides for complex `$ref`-heavy schemas, Zustand

**REST API (playground ↔ Python runner):**

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/connect` | POST | Establish connection to an MCP server |
| `/api/tools` | GET | List available tools from connected server |
| `/api/call` | POST | Invoke a tool and return the result |
| `/api/history` | GET | Return paginated request/response log |
| `/api/export` | POST | Export request history as YAML test spec |

The Python runner exposes this API via a lightweight FastAPI server launched on `localhost:7430`. The REST layer is thin — it is a direct proxy to the underlying `mcp` SDK calls, not a reimplementation.

### 4.6 Transport Layer

Both the test runner and mock server implement a clean transport abstraction supporting:

- **stdio transport:** for local servers launched as subprocesses (Claude Desktop, VS Code extensions)
- **HTTP/SSE transport:** for remote servers over standard HTTP with Server-Sent Events

New transports (WebSocket) can be added without touching core logic.

### 4.7 JSON-RPC Conformance Validation

Every response is validated across three layers:

1. JSON-RPC 2.0 envelope structure
2. MCP protocol schema constraints (pinned to `spec_version`)
3. User-defined assertions in the test spec

Validation errors produce human-readable diagnostic messages pinpointing exactly which field violated which rule. Example output:

```
FAIL  get_weather response — MCP conformance error
      Field:    result.content[0].type
      Expected: one of ["text", "image", "resource"]
      Got:      "blob"
      Rule:     MCP 2025-03-26 §4.2.3 Tool Result Content Types
```

---

## 5. Deliverables

### Must-Have (committed)

- [ ] Python MCP Client Library with stdio and HTTP/SSE transport support
- [ ] JSON-RPC + MCP Conformance Validator (spec-version-pinned, human-readable diagnostics)
- [ ] Headless Test Runner CLI (YAML/JSON spec input, CI/CD exit codes)
- [ ] Report Generator (HTML, JSON, Markdown output formats)
- [ ] Configurable Mock MCP Server with fault injection and latency simulation
- [ ] React Interactive Playground with schema visualisation, auto-generated forms, and REST API backend
- [ ] Dart `McpTestRunner` integration class for API Dash Flutter shell
- [ ] GitHub Actions and GitLab CI example workflow files
- [ ] Comprehensive test suite with >85% code coverage
- [ ] Full documentation with quickstart guide and 3 end-to-end examples

### Stretch Goals (if time permits)

- [ ] VS Code Extension Integration with inline pass/fail annotations
- [ ] OpenAPI to MCP Test Generator that auto-generates test specs from OpenAPI definitions

---

## 6. Risk Mitigation

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|-----------|
| MCP spec updates during coding period | Medium | High | Pin to `spec_version: 2025-03-26`; abstract validator into a `SpecRegistry` so adding a new spec version is a one-file change. Monitor the `modelcontextprotocol/specification` repo for releases. |
| Flutter/Python subprocess integration complexity | Medium | Medium | The Dart `McpTestRunner` wrapper is scoped to ~150 lines and designed in Week 1. If platform-channel integration proves more complex than expected, the CLI tools remain fully functional standalone — Flutter integration becomes a stretch goal without losing the core deliverables. |
| `react-jsonschema-form` rendering failures on complex schemas | Low | Medium | Use `@rjsf/core` with custom widget overrides (not the default theme). Identify 3 real-world MCP server schemas during community bonding and validate form rendering against them before committing to the library. `react-hook-form` + manual schema traversal is the identified fallback. |
| React playground scope creep | High | Medium | Week 10 MVP is locked to: connect panel, tool list, form generation, invoke + display result. History log, export, and REST API are Week 11. Anything beyond this is a stretch goal. |
| Mentor availability or scope change at midterm | Low | High | All Component A deliverables are complete at midterm and independently deployable. The second half (mock server + playground) is additive. A scope reduction at midterm loses the playground but not the core value. |

---

## 7. Timeline (350 hours over 13 weeks)

### Community Bonding Period: May 1 - May 24

Set up development environment. Study API Dash Flutter codebase architecture — specifically how existing external tool integrations are handled. Deep-dive into the MCP specification (version 2025-03-26). Install and run 3 real-world MCP servers against the official MCP inspector to understand real-world compliance gaps. Validate `react-jsonschema-form` against complex real-world MCP schemas. Attend weekly mentor calls. Finalise component interfaces with mentors. Draft internal technical design document.

---

### Week 1: May 25 - May 31 — Transport Layer and Core Client

- Implement stdio transport adapter
- Implement HTTP/SSE transport adapter
- Build base MCP client class with connection lifecycle management
- Implement `initialize` and `ping` handshake
- Design and implement Dart `McpTestRunner` wrapper class skeleton
- Write unit tests for both transports
- Verify against reference MCP server

**Hours:** 30

---

### Week 2: Jun 1 - Jun 7 — Tool, Resource, and Prompt Operations

- Implement `list_tools`, `call_tool`, `list_resources`, `read_resource` MCP operations
- Implement `list_prompts`, `get_prompt` MCP operations
- Build JSON-RPC 2.0 message serialiser/deserialiser
- Implement request ID tracking and response correlation
- Write integration tests against a real MCP server

**Hours:** 30

---

### Week 3: Jun 8 - Jun 14 — Conformance Validator

- Implement JSON-RPC 2.0 envelope validator
- Implement MCP schema conformance checker for all response types (pinned to `spec_version`)
- Implement `SpecRegistry` abstraction for future spec versions
- Build human-readable diagnostic message generator
- Write tests covering valid responses, malformed envelopes, missing fields, and type mismatches

**Hours:** 30

---

### Week 4: Jun 15 - Jun 21 — Test Spec Parser and Runner Engine

- Design and implement YAML/JSON test specification schema (including `list_prompts`/`get_prompt` actions)
- Build spec parser with full validation and helpful error messages
- Implement test runner engine: spec loading, server connection, test execution, result collection
- Build assertion engine (status checks, field presence, value matching, schema validation)

**Hours:** 30

---

### Week 5: Jun 22 - Jun 28 — CLI Interface and Report Generator

- Build CLI using `typer`: `mcp-test run spec.yaml`, `mcp-test validate`, `mcp-test report`
- Implement HTML report template using Jinja2
- Implement JSON and Markdown report formats
- Add CI/CD exit code handling (0 = all pass, 1 = failures)
- Write GitHub Actions and GitLab CI example workflows

**Hours:** 30

---

### Week 6: Jun 29 - Jul 5 — Integration Testing and Buffer

- End-to-end testing of Component A against 3 real-world MCP servers
- Identify and fix edge cases discovered during testing
- Improve error messages based on testing experience
- Reach >85% test coverage for all Python components
- Internal code review and cleanup
- **Buffer:** absorb any overrun from Weeks 1-5

**Hours:** 25

---

### Week 7: Jul 6 - Jul 12 — MIDTERM EVALUATION + Mock Server Core

**Deliverables complete at midterm:**
- Transport layer (stdio + HTTP/SSE)
- MCP client library (Tools + Resources + Prompts)
- JSON-RPC + MCP conformance validator
- Headless test runner CLI
- HTML/JSON/Markdown report generator
- GitHub Actions / GitLab CI examples
- Unit and integration test suite (>85% coverage)

Mentor review and scope adjustment. In parallel, begin mock server scaffold to avoid dead time:

- Implement configurable mock MCP server skeleton
- Stub response system: load fixtures from JSON files, map tool/prompt names to responses

**Hours:** 20

---

### Week 8: Jul 13 - Jul 19 — Mock MCP Server Core

- Complete both stdio and HTTP/SSE transport modes for mock server
- Implement request capture to record all incoming requests
- Build assertion helpers for verifying client-side request behaviour
- Write unit tests for stub response routing

**Hours:** 30

---

### Week 9: Jul 20 - Jul 26 — Mock MCP Server Advanced Features

- Implement fault injection: configurable error responses, malformed JSON-RPC, network timeouts
- Add latency simulation (fixed delay and random jitter)
- Add auth simulation stubs (API key, Bearer token)
- Write comprehensive tests for all mock server behaviours
- Document mock server configuration format with full reference

**Hours:** 30

---

### Week 10: Jul 27 - Aug 2 — React Playground Foundation (MVP)

- Scaffold React + TypeScript + Tailwind project
- Implement FastAPI REST backend (`/api/connect`, `/api/tools`, `/api/call`)
- Implement server connection panel (URL input, transport selection, connect/disconnect)
- Implement tool discovery view with JSON Schema visualisation
- Implement parameter form generation from JSON Schema using `@rjsf/core`
- Validate form rendering against 3 real-world MCP server schemas

**Hours:** 30

---

### Week 11: Aug 3 - Aug 9 — React Playground: Results, History, and Export

- Implement tool invocation with live response display
- Add `/api/history` endpoint and request/response history log with expandable detail view
- Add `/api/export` endpoint for exporting history as YAML test spec
- Complete Dart `McpTestRunner` integration class and API Dash sidebar panel
- End-to-end browser testing and cross-platform subprocess testing (Windows, macOS, Linux)

**Hours:** 30

---

### Week 12: Aug 10 - Aug 17 — Documentation, Polish, and Final Submission

- Write complete documentation: quickstart guide, test spec format reference, mock config reference, REST API reference
- Write 3 end-to-end examples testing real-world MCP servers
- Add inline code comments to all public APIs
- Final cross-platform testing
- Prepare final GSoC report and submit code for final evaluation
- **Buffer / Stretch:** if ahead of schedule, begin VS Code integration stretch goal

**Hours:** 25

---

## 8. About Me

I am Nazeef Danladi Adamu, a software developer and postgraduate diploma student at ATBU, Nigeria. My Civil Engineering background shaped how I write software: correctness first, plan before implementing, edge cases are requirements. My most significant project is [research-dossier-app](https://github.com/nazifsco/research-dossier-app) — a production-deployed, full-stack AI orchestration tool with a Python backend and TypeScript frontend that coordinates multiple AI capabilities through a directive-execution architecture. Building it gave me hands-on experience with the exact patterns MCP formalises, and the exact pain point this project solves.

### Technical Skills

- **Languages:** Python (primary), JavaScript, TypeScript
- **Frameworks/Tools:** Django, REST APIs, FastAPI, React (intermediate), Git, asyncio
- **Protocols/Formats:** JSON Schema, YAML, REST, HTTP/SSE
- **AI/Agent tooling:** Hands-on experience building agent orchestration pipelines

---

## 9. Time Commitment and Availability

I have no employment, academic examinations, or major commitments during the GSoC coding period (May 25 to August 17, 2026). I am fully available to treat this as my primary professional focus.

| Period | Hours per Week | Status |
|--------|---------------|--------|
| Community Bonding (May 1 - May 24) | 20 hrs/week | Available |
| Coding Period (May 25 - Aug 17) | 30 hrs/week | Fully Available |
| Final Submission Week (Aug 17 - Aug 24) | 25 hrs/week | Available |

I commit to posting a daily brief update in the project Discord channel and a formal weekly progress report every Friday covering: work completed, blockers encountered, plan for the following week, and any scope adjustments.

I am available for synchronous calls with mentors during WAT business hours (08:00 to 18:00 UTC+1) and can accommodate mentor timezones with advance scheduling.

---

## 10. Pre-Application Contributions

- Joined the API Dash Discord server and introduced myself in `#gsoc-foss-apidash`
- Studied the full codebase architecture, CONTRIBUTING.md, and GSoC project discussions
- Engaged in Discussion [#1225 (MCP Testing)](https://github.com/foss42/apidash/discussions/1225) with a technical proposal outline
- Commented on Issue [#527](https://github.com/foss42/apidash/issues/527) to contribute documentation improvements
- Opened [PR #1465](https://github.com/foss42/apidash/pull/1465): fixed a positional index bug in `getEnabledRows` (package `better_networking`) where duplicate rows with identical name/value were incorrectly sharing the same enabled flag. Added a regression test. All 33 tests passing.

---

*Nazeef Danladi Adamu | Nazeefdk@gmail.com | [github.com/nazifsco](https://github.com/nazifsco) | [linkedin.com/in/nazeefos](https://www.linkedin.com/in/nazeefos)*
