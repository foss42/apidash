# GSoC 2026 Proposal: API Dash MCP Testing Workspace

| | |
|---|---|
| **Organization** | API Dash |
| **Candidate** | Yassine Kolsi |
| **Track** | MCP Testing |
| **Difficulty** | Medium (175 hours) |
| **Time Zone** | UTC+1 |

---

## About Me

| | |
|---|---|
| **Name** | Yassine Kolsi |
| **Location** | Tunis, Tunisia |
| **GitHub** | [github.com/yassinekolsi](https://github.com/yassinekolsi) |
| **Email** | yassine.kolsi@insat.ucar.tn |
| **LinkedIn** | [linkedin.com/in/yassine-kolsi](https://www.linkedin.com/in/yassine-kolsi) |
| **Time Zone** | UTC+1 (CET) |
| **University** | National Institute of Applied Science and Technology |
| **Program** | Software Engineering, 3rd year |
| **Availability** | Full-time during GSoC period |

---

## Problem Statement

Model Context Protocol (MCP) is emerging as the standard integration layer between AI clients and external tools. Yet MCP testing remains fragmented: many teams validate behavior manually, rely on ad-hoc scripts, and lack deterministic replay for regressions.

This causes four recurring issues:

- Protocol regressions are discovered late because compliance checks are inconsistent.
- Failures are difficult to reproduce due to nondeterministic network and server behavior.
- Edge cases such as timeouts, malformed responses, and partial streams are under-tested.
- Contributor onboarding is slower because test setup is expensive.

The goal is to make API Dash a practical MCP testing workspace where server, client, and app interactions can be authored, executed, replayed, and diagnosed with clear artifacts.

---

## Why Me for This Project

My recent API Dash contributions demonstrate a reliability-first engineering style: identify crash paths, harden contracts, add regression tests, and iterate quickly on review feedback. Across 7 PRs I focused on exactly the skills this project needs: failure analysis, deterministic behavior improvements, API contract enforcement, and test coverage.

Outside these PRs, my personal projects shaped how I design systems: modular adapters, typed interfaces, and explicit failure reporting. That maps directly to this MCP testing architecture:

- Adapter-based transport support (`stdio`, `SSE`, mocks).
- Deterministic execution via recording and replay.
- Structured assertions and diagnostics instead of opaque pass/fail.

---

## Relevant Prior Contributions

| PR | Commit(s) | Summary |
|---|---|---|
| [#1436](https://github.com/foss42/apidash/pull/1436) | 0c832b9, 4f67cdc | Implemented missing `ADListTile` variants and added widget regression tests; addressed review feedback on disabled-state semantics. |
| [#1439](https://github.com/foss42/apidash/pull/1439) | cf6cf12 | Removed a runtime crash path in `JsonHighlight.createSpecialText` and added regression coverage. |
| [#1442](https://github.com/foss42/apidash/pull/1442) | 3881539 | Fixed duplicate-row filtering in `getEnabledRows` by moving to positional mapping; added regression test. |
| [#1443](https://github.com/foss42/apidash/pull/1443) | 6c32e1c, 65872d7 | Corrected `stripUrlParams` for query-only input and clarified string-split semantics in docs and tests. |
| [#1444](https://github.com/foss42/apidash/pull/1444) | 509befd | Enforced `ModelProvider` required overrides at compile time to remove latent runtime failures. |
| [#1445](https://github.com/foss42/apidash/pull/1445) | bc222d8, fc53c84, 3c8d0cc | Hardened `ConfigSliderValue.deserialize` with strict tuple length checks and stronger diagnostic tests. |
| [#1446](https://github.com/foss42/apidash/pull/1446) | ea92cf7, 845f8e4 | Prevented out-of-range cursor crashes in autocomplete trigger scanning and improved clamp test assertions. |

---

## Proposed Architecture

### End-to-End Flow

![API Dash MCP Test UI Architecture](images/visual.png)

### Concrete Technical Decisions

**Transport (`stdio` vs `SSE`):**

- Build `stdio` first for deterministic local integration.
- Add `SSE` through the same transport interface; no runner changes required.
- Normalize all messages into one internal event format before assertions.

**Mocking the transport layer:**

- Implement `FakeTransport` with the exact adapter contract used by live transports.
- Unit tests run on `FakeTransport`; integration tests run on real MCP servers.
- Replay mode reuses captured cassettes for deterministic regression runs.

**Assertion engine:**

- Use TypeScript and `Vitest` assertion style in runner tests.
- Add MCP-specific matchers: `pathExists`, `pathEquals`, `contains`, protocol-field checks.
- Emit rich failure records: step id, matcher output, payload excerpt, timeout and retry metadata.

---

## MCP Test Case Schema

Example test-case document consumed by the runner:

```json
{
  "id": "weather-tool-smoke",
  "name": "tools/list and tools/call returns weather response",
  "transport": {
    "type": "stdio",
    "command": "node",
    "args": ["dist/server.js"]
  },
  "timeouts": { "stepMs": 2000, "suiteMs": 15000 },
  "retries": { "network": 1 },
  "steps": [
    {
      "send": {
        "jsonrpc": "2.0",
        "id": "1",
        "method": "tools/list",
        "params": {}
      }
    },
    {
      "expect": {
        "path": "$.result.tools[*].name",
        "contains": "get_weather"
      }
    },
    {
      "send": {
        "jsonrpc": "2.0",
        "id": "2",
        "method": "tools/call",
        "params": {
          "name": "get_weather",
          "arguments": { "city": "Tunis" }
        }
      }
    },
    {
      "expect": {
        "path": "$.result.content[0].text",
        "matches": "(?i).*tunis.*"
      }
    }
  ],
  "replay": {
    "record": true,
    "cassette": "weather-tool-smoke-v1.json"
  },
  "tags": ["smoke", "regression"]
}
```

---

## Implementation Plan

**Foundation and schema:**

- Define and version the MCP test-case schema.
- Add parser and validation with actionable error messages.
- Add initial server, client, and app example suites.

**Runner core and replay:**

- Implement step execution pipeline with timeout, retry, and cancel support.
- Implement message recorder and deterministic replay mode.
- Build protocol-aware assertion matchers and diagnostics.

**Transport and integration:**

- Implement `stdio` adapter and integration harness.
- Implement `SSE` adapter and parity checks.
- Implement `FakeTransport` for isolated tests.

**API Dash UX and handoff:**

- Integrate author, run, and report flows in API Dash.
- Add suite persistence and one-click rerun for regressions.
- Ship docs, examples, and contributor onboarding notes.

---

## Risks and Mitigations

| Risk | Impact | Mitigation |
|---|---|---|
| Stateful MCP servers produce order-dependent outcomes | High | Isolate each suite in a fresh process or session and add explicit setup and teardown hooks with optional reset steps. |
| Nondeterministic model outputs break strict snapshots | High | Prefer structural and path-based assertions with regex and contains checks; add normalization layer before comparison. |
| Network jitter and timeouts cause flaky tests | Medium | Add step-level timeout budgets, bounded retries, and clear failure categories: transport, protocol, or assertion. |
| Behavior drift between `stdio` and `SSE` adapters | Medium | Enforce a shared adapter contract and run identical conformance suites across both transports. |
| Schema changes create migration churn | Medium | Version schema from v1, validate at load time, and publish migration notes for breaking changes. |
| Scope pressure in a 175-hour project | Medium | Prioritize the minimum complete flow first: schema, runner, `stdio`, and reports; treat extras as stretch goals. |

---

## Timeline (175 Hours)

| Period | Phase | Key Tasks |
|---|---|---|
| Pre-GSoC | Community Bonding | Finalize scope, success criteria, and review cadence with mentors; lock initial architecture and collect reference MCP scenarios. |
| Week 1 | Schema foundation | Finalize schema fields (transport, steps, assertions, replay metadata); implement schema validator and error formatter. |
| Week 2 | Parser | Implement scenario parser and execution plan builder; add parser tests for malformed and boundary cases. |
| Week 3 | Runner core | Implement runner step executor and event lifecycle; add timeout, cancellation, and controlled retry primitives. |
| Week 4 | Assertion layer | Implement JSON-path checks, contains, regex, and equality matchers; add rich diagnostics and step-level failure traces. |
| Week 5 | `stdio` adapter | Implement `stdio` adapter and wire first real server integration tests; stabilize transport lifecycle and shutdown handling. |
| Week 6 | Recorder and replay | Implement recorder and cassette replay format; add deterministic replay tests and mismatch reporting. |
| Week 7 | `SSE` adapter | Implement `SSE` adapter with the same runner contract; execute adapter conformance tests for `stdio` and `SSE` parity. |
| Week 8 | `FakeTransport` and edge cases | Implement `FakeTransport` and fixture toolkit; add edge-case suites covering malformed responses, disconnects, and delayed replies. |
| Week 9 | API Dash UI | Integrate test creation and execution in API Dash; add report UI with grouped failures and trace drill-down. |
| Week 10 | Suite management | Add suite persistence, tagging, and one-click rerun; improve UX for flaky-test hints and error readability. |
| Week 11 | Docs and hardening | Write contributor docs, architecture notes, and example suites; harden based on mentor and community feedback. |
| Week 12 | Finalization | Final stabilization and release-quality cleanup; deliver final report, demo walkthrough, and post-GSoC roadmap. |

---

## Closing

This proposal balances architectural clarity with implementation accountability, delivering a practical, maintainable MCP testing engine for immediate use and confident extension.
