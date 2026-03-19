# GSoC 2026 Application: MCP Testing Suite for API Dash

### About

1. **Full Name:** Souvik Ghosh
2. **Contact Info:** [your public email here]
3. **Discord Handle:** souvik
4. **Home Page:** N/A
5. **Blog:** N/A
6. **GitHub:** https://github.com/souvikDevloper
7. **LinkedIn:** https://www.linkedin.com/in/souvikdev
8. **Time Zone:** IST (UTC+5:30)
9. **Resume:** https://drive.google.com/file/d/10dYf3tqAonj-SYtucNYdIikJ5zAHdrKc/view?usp=sharing

---

### University Info

1. **University:** IIEST, Shibpur
2. **Degree & Major:** B.Tech in Computer Science & Engineering
3. **Year:** 3rd Year
4. **Expected Graduation:** May 2027

---

### Motivation & Past Experience

**1. Have you worked on or contributed to a FOSS project before?**

Yes — I have two active PRs against foss42/apidash:

**PR #1349 — feat: add custom AI model support in selector**
Real Flutter/Dart code contribution to the API Dash codebase.
Addresses issue #1315 (part of meta-issue #1269 — revamping the
Model Selector dialog). I cloned the repo, understood the existing
widget architecture, and extended the AI model selector to support
custom model names alongside built-in presets.
→ https://github.com/foss42/apidash/pull/1349

**PR #1284 — MCP Testing Suite: interactive mockup v10 + working PoC**
Includes a 5-page interactive HTML mockup and a self-contained
Node.js PoC (`poc.js`) — real stdio JSON-RPC 2.0, 8 automated
tests, 4-layer breakdown, zero external dependencies, ~7ms.
The MCP Apps Preview page performs a real `ui/initialize`
handshake in a sandboxed iframe via `postMessage`, built
directly from @ashitaprasad's MCP Apps spec.
→ https://github.com/foss42/apidash/pull/1284

Maintainers added the `gsoc-2026` label to #1284 and
@ashitaprasad tagged me directly in `#gsoc-foss-apidash`
to include MCP Apps testing — which was already done.

**2. What is your one project/achievement you are most proud of?**

The `poc.js` proof of concept I built for this proposal.

In a single Node.js file with zero external dependencies, it:
- Spawns a real MCP server as a child process
- Connects via `child_process.spawn` + `stdin`/`stdout` pipe
  (that is literally what stdio transport is)
- Exchanges real JSON-RPC 2.0 messages over that pipe
- Classifies results across all 4 layers: transport, protocol,
  tool execution, and MCP Apps `_meta.ui.resourceUri` detection
```bash
node poc.js  # → 8/8 pass, ~7ms, zero dependencies
```

Most proposals describe what they plan to build.
This one already shows the core works at the protocol level.

**3. What kind of problems motivate you most?**

Developer tooling gaps where the ecosystem has outpaced the
tooling. MCP is now the standard way AI agents discover and
invoke tools — adopted by VS Code, Claude, and dozens of AI
hosts. But testing an MCP server today means hand-crafting
JSON-RPC payloads in curl and guessing which layer broke from
a generic error code.

The same gap existed for REST APIs before Postman.
I want to build the Postman moment for MCP, inside API Dash.

**4. Will you be working on GSoC full-time?**

Yes. I have no internship or coursework conflicts during the
GSoC period and will dedicate 35–40 hours per week to this
project.

**5. Do you mind regularly syncing up with mentors?**

Not at all. I've been attending every weekly connect session
and am active in `#gsoc-foss-apidash` on Discord daily.
Regular sync is something I actively want, not just tolerate.

**6. What interests you most about API Dash?**

Two things. First, API Dash treats the developer as the user —
it's fast, local-first, and doesn't require an account to get
value. That philosophy is rare. Second, the timing: API Dash
is at the exact inflection point where AI tooling (MCP, agents,
model selectors) is being added on top of a solid REST/GraphQL
foundation. Contributing now means shaping the architecture
of a feature that will matter for years, not just fixing
something that already works.

**7. Areas where the project can be improved?**

- **MCP testing tooling** — the biggest gap right now. No
  dedicated way to test MCP servers, debug transport/protocol
  failures, or validate MCP Apps `ui/initialize` handshakes.
  This proposal addresses it directly.
- **MCP Apps integration** — as Ashita's guide outlines, MCP
  servers can now deliver rich HTML UI components to AI hosts.
  API Dash is uniquely positioned to be the tool that tests
  this entire visual layer, not just the JSON-RPC wire protocol.
- **Regression testing for AI requests** — snapshot and replay
  for AI/LLM API calls, similar to what this proposal builds
  for MCP, would be a natural next step.

---

### Project Proposal Information

**1. Proposal Title**

MCP Testing Suite — Full-Stack MCP & MCP Apps Testing Workflow
for API Dash

**2. Abstract**

MCP (Model Context Protocol) is becoming the standard API layer
of the AI world. But developers building and debugging MCP servers
have no dedicated testing tooling. They craft JSON-RPC payloads
manually, receive opaque error codes, and cannot tell whether a
failure is in the transport, the protocol schema, or the tool
execution layer.

With the new MCP Apps specification, the problem deepens: servers
now deliver rich HTML UI components (`text/html;profile=mcp-app`)
to AI hosts via sandboxed iframes, requiring a `ui/initialize`
handshake and `hostContext` CSS injection. No existing tool
handles this visual layer at all.

This project builds the MCP Testing Suite inside API Dash — a
full-stack, collection-oriented testing workflow covering every
layer of MCP communication: transport, protocol, tool execution,
and the MCP Apps visual layer. The same way API Dash already
covers REST and GraphQL.

**3. Detailed Description**

**The Problem**

| Pain today | After this project |
|---|---|
| Hand-craft JSON-RPC payloads in curl | Configure MCP targets like API Dash collections |
| Generic error — which layer broke? | 4-layer trace: transport / protocol / tool-exec / ui-handshake |
| No replay after a server change | Baseline snapshots + one-click replay + payload diff |
| `ui/initialize` handshake — test how? | Sandboxed iframe + live `postMessage` message log |
| `hostContext` CSS injection — validate how? | Host context sandbox with theme presets |
| `_meta.ui.resourceUri` — auto-detect? | Detection banner in Scenario Runner |

**Architecture**
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

**Proof of Work**

Both artifacts are in PR #1284 and runnable today:

*Mockup* — open `gsoc/mcp-testing/mockup/index.html` in any
browser. MCP Apps Preview page performs a real `ui/initialize`
handshake and re-themes when you inject a different `hostContext`.

*PoC* — `node gsoc/mcp-testing/poc/poc.js`
```
✓ All 8 tests passed  (~7ms total)

Layer Breakdown:
■ Transport   ── OK       stdio spawn + stdin/stdout
■ Protocol    ── OK       JSON-RPC initialize · serverInfo
■ Tool Exec   ── OK       tools/call · contentType assert
■ MCP Apps    ── DETECTED _meta.ui.resourceUri
```

Demo video: https://youtu.be/GAZrTelq_M0

**4. Weekly Timeline**

**Community Bonding (May)**
- Deep-dive into API Dash codebase: collection model, state
  management (Riverpod), request lifecycle
- Finalise module structure and file organisation with mentors
- Confirm testing strategy

**Week 1–2 · Transport Layer**
- `StdioTransport.ts`: spawn, readline, timeout guard
- `MCPClient.ts`: JSON-RPC 2.0 pending map, error types
- Unit tests for transport layer
- ✅ Milestone: `client.initialize()` works against a real
  MCP server over stdio

**Week 3–4 · Session Setup UI**
- Session Setup page wired to real `MCPClient`
- Save/load MCP targets as API Dash collection entries
- Validation panel: transport reachable, capabilities
  discovered, env vars resolved
- ✅ Milestone: user can configure, validate and save
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
- Developer documentation for M1–M3
- Integration tests

**Week 8–9 · Trace Inspection**
- `TraceInspector.ts`: event stream parser, 4-layer
  classifier (transport / protocol / tool-exec / ui-handshake)
- Trace Inspection UI: event timeline, layer breakdown grid,
  raw request/response viewer, reclassify action
- ✅ Milestone: any MCP failure classified to the correct
  layer with clear error context

**Week 10 · Replay & Compare**
- `SnapshotStore.ts`: capture baseline, field-level diff
- Replay & Compare UI: run history, diff view
  (summary + payload diff tabs)
- ✅ Milestone: regression detected and shown as a
  clear readable diff

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
- User guide + developer guide for the new feature
- Final PR, updated demo video, GSoC final report

---

### References

| Resource | Link |
|---|---|
| MCP Testing discussion | https://github.com/foss42/apidash/discussions/1225 |
| Application guide | https://github.com/foss42/apidash/discussions/1048 |
| Flutter contribution PR | https://github.com/foss42/apidash/pull/1349 |
| Mockup + PoC PR | https://github.com/foss42/apidash/pull/1284 |
| MCP Apps spec (mentor) | https://dev.to/ashita/a-practical-guide-to-building-mcp-apps-1bfm |
| Demo video | https://youtu.be/GAZrTelq_M0 |