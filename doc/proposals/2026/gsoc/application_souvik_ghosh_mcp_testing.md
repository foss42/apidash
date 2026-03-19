# GSoC 2026 Proposal: MCP Testing Suite for API Dash

| | |
|---|---|
| **Applicant** | Souvik Ghosh |
| **GitHub** | [@souvikDevloper](https://github.com/souvikDevloper) |
| **Email** | gshbholanath19@gmail.com |
| **Timezone** | IST (UTC+5:30) |
| **Project Idea** | [#1 — MCP Testing](https://github.com/foss42/apidash/discussions/1225) |
| **Demo Video** | https://youtu.be/GAZrTelq_M0 |

---

## About Me

I'm a Computer Science undergraduate with hands-on experience in
React, TypeScript, Node.js, and Dart/Flutter. I've been actively
contributing to API Dash since early March 2026 — writing real
production code, attending weekly connect sessions, and engaging
in Discord daily.

---

## Have you contributed to a FOSS project before?

Yes — I have two active PRs open against foss42/apidash right now,
and both involve real code:

### PR #1349 — feat: add custom AI model support in selector
**Real Flutter/Dart code contribution to the API Dash codebase.**
Addresses issue #1315, which is part of the meta-issue #1269
(revamping the Model Selector dialog). I cloned the repo,
understood the existing widget architecture, and extended the
AI model selector to support custom model names alongside the
built-in presets. This is actual app code — not a document,
not a proposal file.

This PR matters for the MCP Testing project too: the Model
Selector is part of the AI configuration surface that MCP
sessions will eventually hook into.

### PR #1284 — MCP Testing Suite: interactive mockup v10 + working PoC
The primary proposal artifact. Includes:

- **Interactive mockup** (`gsoc/mcp-testing/mockup/index.html`):
  5-page HTML prototype covering the full testing workflow —
  Session Setup, Scenario Runner, Trace Inspection, Replay &
  Compare, and **MCP Apps Preview**. Open in any browser,
  no build step.

- **Working PoC** (`gsoc/mcp-testing/poc/poc.js`): self-contained
  Node.js script — real stdio JSON-RPC 2.0 communication,
  8 automated tests, 4-layer breakdown, zero external
  dependencies, runs in ~7ms.
```bash
  node gsoc/mcp-testing/poc/poc.js
```
```
  ✓ All 8 tests passed  (7ms total)

  Layer Breakdown:
  ■ Transport   ── OK       stdio spawn + stdin/stdout
  ■ Protocol    ── OK       JSON-RPC initialize · serverInfo
  ■ Tool Exec   ── OK       tools/call · contentType assert
  ■ MCP Apps    ── DETECTED _meta.ui.resourceUri
```

- **MCP Apps PoC** (inside the mockup's App Preview page):
  a sandboxed iframe that performs a real `ui/initialize`
  handshake via `postMessage`, receives `hostContext` CSS
  variables from the host, and re-themes the app live.
  Built directly from @ashitaprasad's MCP Apps guide.

Maintainer response to #1284: the `gsoc-2026` label was added
and @ashitaprasad tagged me directly in `#gsoc-foss-apidash`
to include MCP Apps testing — which was already addressed in
the same PR.

### Active community engagement
- Discussion [#1225](https://github.com/foss42/apidash/discussions/1225)
  (MCP Testing) — participating from day one
- Discussion [#1048](https://github.com/foss42/apidash/discussions/1048)
  (Application Guide)
- Attending weekly connect sessions
- Active in `#gsoc-foss-apidash` on Discord daily

---

## What is your one project / achievement you are most proud of?

The `poc.js` proof of concept I built for this proposal.

In a single Node.js file with zero external dependencies, it:
1. Spawns a real MCP server as a child process
2. Connects via `child_process.spawn` + `stdin`/`stdout` pipe
   (that is literally what stdio transport is)
3. Exchanges real JSON-RPC 2.0 messages over that pipe
4. Classifies results across all 4 layers: transport, protocol,
   tool execution, and MCP Apps `_meta.ui.resourceUri` detection

Most proposals describe what they plan to build.
This one shows the core of it already works.

---

## What kind of problems motivate you most?

Developer tooling gaps where the ecosystem has outpaced the
tooling. MCP is now the standard way AI agents discover and
invoke tools — adopted by VS Code, Claude, and dozens of
other hosts. But testing an MCP server today means
hand-crafting JSON-RPC payloads in curl and guessing which
layer broke from a generic error code.

The same gap existed for REST APIs before Postman.
I want to build the Postman moment for MCP, inside API Dash.

---

## Will you be working on GSoC full-time?

Yes. I have no internship or coursework conflicts during the
GSoC period and will dedicate 35–40 hours per week to this.

---

## Do you mind regularly syncing up with mentors?

Not at all — I've been attending every weekly connect session
and am active on Discord daily. Regular sync is something I
actively want, not just tolerate.

---

## Project Proposal

### Abstract

MCP (Model Context Protocol) is becoming the standard API layer
of the AI world — the way agents discover, understand, and invoke
tools. But developers building and debugging MCP servers have no
dedicated testing tooling today.

With the new **MCP Apps** specification introduced by the
maintainers, the problem is now deeper: servers can deliver rich
HTML UI components (`text/html;profile=mcp-app`) to AI hosts,
requiring a `ui/initialize` handshake and `hostContext` CSS
injection. No tool handles this layer at all.

This project builds the **MCP Testing Suite** inside API Dash:
a full-stack, collection-oriented testing workflow that covers
every layer — transport, protocol, tool execution, and the
MCP Apps visual layer — the same way API Dash already covers
REST and GraphQL.

---

### The Problem

| Pain today | After this project |
|---|---|
| Hand-craft JSON-RPC payloads in curl | Configure MCP targets like API Dash collections |
| Generic error codes — which layer broke? | 4-layer trace: transport / protocol / tool-exec / ui-handshake |
| No replay after a server change | Baseline snapshots + one-click replay + payload diff |
| `ui/initialize` handshake — test how? | Sandboxed iframe + live `postMessage` message log |
| `hostContext` CSS injection — validate how? | Host context sandbox with light/dark/custom themes |
| `_meta.ui.resourceUri` — what even triggered? | Auto-detection banner in Scenario Runner |

---

### Architecture

The implementation follows the existing API Dash tech stack
(React + TypeScript + Node) and adds three new modules:
```
src/
  mcp/
    client/
      StdioTransport.ts      # child_process spawn + stdin/stdout
      HttpTransport.ts       # fetch-based HTTP transport
      MCPClient.ts           # JSON-RPC 2.0 layer, pending map
    testing/
      ScenarioRunner.ts      # step-by-step execution engine
      TraceInspector.ts      # 4-layer event classifier
      SnapshotStore.ts       # baseline capture + diff engine
    apps/
      AppPreview.tsx         # sandboxed iframe + postMessage host
      HostContextSandbox.ts  # CSS variable injection + presets
  ui/
    SessionSetup/
    ScenarioRunner/
    TraceInspection/
    ReplayCompare/
    MCPAppsPreview/
```

**Transport layer** works exactly like `poc.js` already
demonstrates: `child_process.spawn`, readline on stdout,
newline-delimited JSON-RPC 2.0. The PoC is the blueprint —
the GSoC work is integrating it into the API Dash UI and
wiring up persistence and state management.

**MCP Apps layer** works exactly like the mockup's App Preview
page already demonstrates: `<iframe sandbox="allow-scripts">`,
`postMessage` listener on the host, the full
`ui/initialize → hostContext → ui/notifications/initialized`
handshake. Already proven in the browser.

---

### Proof of Work

Both artifacts are in PR #1284 and runnable today:

**Mockup** — open `gsoc/mcp-testing/mockup/index.html` in any
browser. Navigate to MCP Apps Preview. The Sales Dashboard
inside the sandboxed iframe performs a real `ui/initialize`
handshake and re-themes when you inject a different
`hostContext`. The postMessage log on the right shows every
JSON-RPC message in real time.

**PoC** — `node gsoc/mcp-testing/poc/poc.js`. Real child
process, real pipe, real JSON-RPC. Not simulated.

---

### Timeline

**Community Bonding (May)**
- Deep-dive into API Dash codebase: collection model, state
  management (Riverpod), request lifecycle
- Finalise architecture with mentors
- Confirm testing strategy and file structure

**Week 1–2 · Transport Layer**
- `StdioTransport.ts`: spawn, readline, timeout guard
- `MCPClient.ts`: JSON-RPC 2.0 pending map, error types
- Unit tests for transport layer
- ✅ Milestone: `client.initialize()` works against a real
  MCP server over stdio

**Week 3–4 · Session Setup UI**
- Session Setup page wired to real `MCPClient`
- Save/load targets as API Dash collection entries
- Validation panel: transport reachable, capabilities
  discovered, env vars resolved
- ✅ Milestone: user can configure, validate, and save
  an MCP target

**Week 5–6 · Scenario Runner**
- `ScenarioRunner.ts`: step execution engine
- Scenario Runner UI: live step status, JSON-RPC output panel
- `_meta.ui.resourceUri` auto-detection banner
- Artifact save after each run
- ✅ Milestone: user can run a multi-step scenario and
  see live JSON-RPC output

**Week 7 · Midterm Buffer**
- Fix issues from midterm evaluation
- Write developer documentation for M1–M3
- Integration tests

**Week 8–9 · Trace Inspection**
- `TraceInspector.ts`: event stream parser, 4-layer
  classifier (transport / protocol / tool-exec / ui-handshake)
- Trace Inspection UI: event timeline, layer breakdown grid,
  raw request/response viewer, reclassify action
- ✅ Milestone: any MCP failure is classified to the
  correct layer with clear error context

**Week 10 · Replay & Compare**
- `SnapshotStore.ts`: capture baseline, field-level diff
- Replay & Compare UI: run history, diff view
  (summary + payload diff tabs)
- ✅ Milestone: regression detected and shown as a
  clear, readable diff

**Week 11 · MCP Apps Layer**
- `AppPreview.tsx`: sandboxed iframe, `postMessage` host
- `HostContextSandbox.ts`: theme presets, CSS injection
- MCP Apps Preview UI: handshake state panel, live
  message log, 3-theme preset switcher
- HTTP transport support
- ✅ Milestone: full MCP Apps testing workflow
  functional end-to-end

**Week 12 · Polish + Final Submission**
- Full test coverage (unit + integration)
- User guide + developer guide for new feature
- Final PR, updated demo video, GSoC final report

---

### Deliverables

| # | Deliverable | Week |
|---|------------|------|
| M1 | `StdioTransport` + `MCPClient` (tested) | 1–2 |
| M2 | Session Setup UI wired to real client | 3–4 |
| M3 | Scenario Runner with live output | 5–6 |
| M4 | Trace Inspection — 4-layer classifier | 8–9 |
| M5 | Replay & Compare with diff engine | 10 |
| M6 | MCP Apps layer + HTTP transport | 11 |
| M7 | Full tests + docs + final report | 12 |

---

### Why I will complete this

The two hardest questions in any GSoC project are
"will it actually work technically?" and "does the
contributor understand the codebase?". Both are already
answered:

- `poc.js` proves stdio JSON-RPC works — the core engine
  is done, the GSoC work is integration
- PR #1349 proves I can read and write production API Dash
  Flutter code — I'm not starting from zero on the codebase
- I've attended every weekly connect and know the direction
  the maintainers want to take the project
- I have no competing commitments during the GSoC period

---

## References

| Resource | Link |
|---|---|
| MCP Testing discussion | [#1225](https://github.com/foss42/apidash/discussions/1225) |
| Application guide | [#1048](https://github.com/foss42/apidash/discussions/1048) |
| Mockup + PoC PR | [#1284](https://github.com/foss42/apidash/pull/1284) |
| Flutter contribution PR | [#1349](https://github.com/foss42/apidash/pull/1349) |
| MCP Apps spec (mentor) | [dev.to/ashita](https://dev.to/ashita/a-practical-guide-to-building-mcp-apps-1bfm) |
| Demo video | [youtu.be/GAZrTelq_M0](https://youtu.be/GAZrTelq_M0) |