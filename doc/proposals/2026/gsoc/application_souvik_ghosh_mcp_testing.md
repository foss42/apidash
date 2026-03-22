# GSoC 2026 Application: MCP Testing Suite — Standalone Electron App

### About

1. **Full Name:** Souvik Ghosh
2. **Contact Info:** gshbholanath19@gmail.com
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

Yes — I have multiple active contributions to foss42/apidash:

**PR #1349 — feat: add custom AI model support in selector**
Real Flutter/Dart code contribution to the API Dash codebase.
Addresses issue #1315 (part of meta-issue #1269 — revamping the
Model Selector dialog). I cloned the repo, understood the existing
widget architecture, and extended the AI model selector to support
custom model names alongside built-in presets.
→ https://github.com/foss42/apidash/pull/1349

**PR #1336 — Refined MCP Testing idea and PoC**
Contains the interactive 5-page HTML mockup (v10) and the
self-contained Node.js PoC (`poc.js`) demonstrating real stdio
JSON-RPC 2.0 communication, 4-layer failure classification,
and MCP Apps `_meta.ui.resourceUri` detection. The MCP Apps
Preview page performs a working `ui/initialize` handshake in a
sandboxed iframe via `postMessage`, built directly from
@ashitaprasad's MCP Apps specification.
→ https://github.com/foss42/apidash/pull/1336

**PR #1284 — Initial idea submission for MCP Testing**
The original prototype that started the conversation with
maintainers. Led to feedback that shaped the refined version.
→ https://github.com/foss42/apidash/pull/1284

Maintainers added the `gsoc-2026` label and @ashitaprasad
tagged me directly in `#gsoc-foss-apidash` to incorporate
MCP Apps testing — which was already addressed.

**2. What is your one project/achievement you are most proud of?**

The PoC I built for this proposal — now available in both
Node.js (`poc.js`) and Python3 (`poc.py`), each with 12
automated tests and zero external dependencies.

In a single file, each PoC:
1. Spawns a real MCP server as a child process
2. Connects via `child_process.spawn` (Node) or
   `subprocess.Popen` (Python) + stdin/stdout pipe
3. Exchanges real JSON-RPC 2.0 messages over that pipe
4. Classifies every error to the correct layer using a
   decision tree: `-32700` → transport, `-32601/-32602` →
   protocol, `isError:true` → tool-exec, `ui/*` → ui-handshake
5. Detects `_meta.ui.resourceUri` in tool responses
6. Runs a snapshot diff engine for baseline regression detection

```bash
node poc.js    # → 12/12 pass, ~230ms, zero deps
python3 poc.py # → 12/12 pass, ~90ms,  zero deps
```

Both PoCs also support `--json` for structured output — the
exact format the Electron main process will send to the React
renderer via IPC. Most proposals describe what they plan to
build. This one already runs at the protocol level.

**3. What kind of problems motivate you most?**

Developer tooling gaps where the ecosystem has outpaced the
tooling. MCP is now the standard way AI agents discover and
invoke tools — adopted by VS Code, Claude, and dozens of AI
hosts. But testing an MCP server today means hand-crafting
JSON-RPC payloads in curl and guessing which layer broke from
a generic error code.

Existing tools like **MCP Inspector** (Anthropic's official
tool) are browser-based REPLs — good for manual poking, but
they have no saved scenarios, no automation, no replay, no
diff, and no MCP Apps hostContext injection testing.
**MCPJam Inspector** adds an LLM playground but still lacks
automated replayable testing and layer classification.

The gap is clear: no tool does automated, replayable,
layer-classified MCP testing today. I want to build that.

**4. Will you be working on GSoC full-time?**

Yes. I have no internship or coursework conflicts during the
GSoC period and will dedicate 35–40 hours per week.

**5. Do you mind regularly syncing up with mentors?**

Not at all. I've been attending every weekly connect session
and am active in `#gsoc-foss-apidash` on Discord daily.

**6. What interests you most about API Dash?**

API Dash treats the developer as the user — fast, local-first,
no account required. The timing is perfect: MCP is the fastest-
growing protocol in the AI ecosystem, and the API Dash org is
building dedicated standalone tooling around it. Contributing
now means shaping the architecture of a tool that will matter
for years, not patching something already finished.

**7. Areas where the project can be improved?**

- **MCP testing tooling** — the single biggest gap. No dedicated
  way to test MCP servers, debug transport/protocol failures,
  or validate MCP Apps `ui/initialize` handshakes. This proposal
  builds it as a **standalone Electron desktop app**.
- **MCP Apps validation** — as Ashita's guide outlines, MCP
  servers can deliver rich HTML UI components. A standalone
  tester can sandbox these with Electron's `<webview>` tag
  (more secure than browser iframes) and test `hostContext`
  CSS injection across different host themes.
- **Regression testing** — snapshot and replay for MCP scenarios
  with payload-level diffing, saved to the local filesystem.

---

### Project Proposal Information

**1. Proposal Title**

MCP Testing Suite — Standalone Electron Desktop App for
Full-Stack MCP & MCP Apps Testing

**2. Abstract**

MCP (Model Context Protocol) is the standard API layer of
the AI world. But developers building MCP servers have no
dedicated testing tooling. They craft JSON-RPC payloads
manually, receive opaque error codes, and cannot tell whether
a failure is in the transport, the protocol schema, or the
tool execution layer.

With the new **MCP Apps** specification, the problem deepens:
servers now deliver rich HTML UI components via sandboxed
iframes, requiring a `ui/initialize` handshake and
`hostContext` CSS injection. No existing tool handles this.

This project builds the **MCP Testing Suite** as a
**standalone Electron desktop application** in the API Dash
ecosystem. It is a self-contained app — not a tab or plugin
inside the existing API Dash Flutter app. It uses React +
TypeScript in the Electron renderer process for the UI, and
Node.js in the Electron main process for stdio transport,
file system access, and MCP server lifecycle management.

**3. Detailed Description**

### Why Standalone Electron?

Stdio transport **requires** `child_process.spawn` — this
cannot run in a browser. An Electron app provides:

- **Main process (Node.js):** spawns MCP servers as child
  processes, reads stdin/stdout via `readline`, manages
  snapshots on the local filesystem, handles timeout guards
- **Renderer process (React):** all UI — Session Setup,
  Scenario Runner, Trace Inspection, Replay & Compare,
  MCP Apps Preview
- **IPC bridge (preload.ts):** secure communication between
  main and renderer via `ipcMain.handle` / `ipcRenderer.invoke`
- **`<webview>` tag:** Electron's secure alternative to
  `<iframe>` for sandboxing MCP Apps — native `postMessage`
  support, isolated process, content security policy enforced

This is the same architectural pattern used by VS Code,
Postman, and MCP Inspector.

### The Problem

| Pain today | After this tool |
|---|---|
| Hand-craft JSON-RPC payloads in curl | Configure MCP targets, save as reusable sessions |
| Generic error — which layer broke? | 4-layer trace: transport · protocol · tool-exec · ui-handshake |
| No replay after a server change | Baseline snapshots + one-click replay + field-level diff |
| `ui/initialize` handshake — test how? | Electron `<webview>` sandbox + live `postMessage` log |
| `hostContext` CSS — validate how? | Theme preset switcher with live re-render |
| `_meta.ui.resourceUri` — undetectable | Auto-detection banner in Scenario Runner |

### Architecture

```
mcp-testing-suite/                  # standalone Electron app
├── package.json
├── electron/
│   ├── main.ts                     # Electron main process entry
│   ├── preload.ts                  # IPC bridge (contextBridge)
│   └── ipc/
│       ├── transport-handlers.ts   # mcp:connect, mcp:send, mcp:disconnect
│       └── snapshot-handlers.ts    # snapshot:save, snapshot:load, snapshot:diff
├── src/
│   ├── client/
│   │   ├── StdioTransport.ts       # child_process.spawn + readline
│   │   ├── HttpTransport.ts        # fetch-based HTTP/SSE transport
│   │   └── MCPClient.ts            # JSON-RPC 2.0 pending map + error types
│   ├── testing/
│   │   ├── ScenarioRunner.ts       # step-by-step execution engine
│   │   ├── TraceInspector.ts       # 4-layer event classifier
│   │   └── SnapshotStore.ts        # baseline capture + diff engine
│   ├── apps/
│   │   ├── AppPreview.tsx          # <webview> for MCP Apps sandbox
│   │   └── HostContextSandbox.ts   # CSS variable injection + presets
│   ├── ui/
│   │   ├── pages/
│   │   │   ├── SessionSetup.tsx
│   │   │   ├── ScenarioRunner.tsx
│   │   │   ├── TraceInspection.tsx
│   │   │   ├── ReplayCompare.tsx
│   │   │   └── MCPAppsPreview.tsx
│   │   ├── components/             # shared React components
│   │   └── store/                  # Zustand for state management
│   ├── App.tsx
│   └── main.tsx                    # React entry point
├── poc/
│   ├── poc.js                      # Node.js PoC (12 tests)
│   └── poc.py                      # Python3 PoC (12 tests)
└── tests/
    ├── unit/
    └── integration/
```

### How Each Module Works (Implementation Detail)

**StdioTransport.ts** (runs in Electron main process)

This is the exact code pattern proven by `poc.js`:
```
constructor(command, args, env):
  this.process = child_process.spawn(command, args, {
    stdio: ['pipe', 'pipe', 'pipe'],
    env: { ...process.env, ...env }
  })
  this.readline = readline.createInterface(this.process.stdout)
  this.readline.on('line', msg => this.handleResponse(msg))

send(method, params) → Promise<result>:
  id = this.nextId++
  this.pending.set(id, { resolve, reject, timer })
  this.process.stdin.write(JSON.stringify({
    jsonrpc: '2.0', id, method, params
  }) + '\n')

handleResponse(line):
  msg = JSON.parse(line)
  entry = this.pending.get(msg.id)
  clearTimeout(entry.timer)
  if msg.error → entry.reject(msg.error)
  else → entry.resolve(msg.result)
```

The renderer never touches `child_process` directly. Instead:
```
// renderer (React)
const result = await window.mcpBridge.send('initialize', params)

// preload.ts (contextBridge)
mcpBridge: {
  send: (method, params) => ipcRenderer.invoke('mcp:send', method, params)
}

// main.ts (ipcMain)
ipcMain.handle('mcp:send', (_, method, params) => {
  return transport.send(method, params)
})
```

**TraceInspector.ts** — 4-Layer Classifier

The classifier uses a decision tree proven in both PoCs:
```
classifyError(error, context):
  // Layer 1 — Transport
  if context.spawnFailed or context.pipeBroken → TRANSPORT
  if error.code == -32700 → TRANSPORT  // malformed JSON on wire

  // Layer 2 — Protocol
  if error.code == -32600 → PROTOCOL   // invalid request
  if error.code == -32601 → PROTOCOL   // method not found
  if error.code == -32602 → PROTOCOL   // invalid params
  if context.missingField → PROTOCOL   // e.g. no serverInfo

  // Layer 4 — UI Handshake
  if context.method.startsWith('ui/') → UI_HANDSHAKE
  if context.hostContextRejected → UI_HANDSHAKE

  // Layer 3 — Tool Execution (default)
  → TOOL_EXEC
```

This is not theoretical — it's the exact `classifyError()`
function exported from both `poc.js` and `poc.py`, tested
against real JSON-RPC error codes.

**SnapshotStore.ts** — Diff Engine

```
captureSnapshot(label, data):
  return { label, timestamp, data: deepClone(data) }
  // saved to filesystem via ipcMain.handle('snapshot:save')

diffSnapshots(baseline, current):
  recursively compare objects field by field
  emit { path, type, from, to } for each difference
  types: 'value-change' | 'added' | 'removed' | 'type-change'
```

The diff engine in `poc.js` already detects version changes,
tool count changes, and validation state regressions. The
GSoC implementation adds filesystem persistence via Electron's
main process and a React diff viewer in the renderer.

**AppPreview.tsx** — MCP Apps Sandbox

In Electron, MCP Apps run inside a `<webview>` tag (not an
`<iframe>`). The `<webview>` is an isolated Chromium process
with its own security context:

```tsx
<webview
  src={resourceUri}
  partition="mcp-app-sandbox"
  nodeintegration={false}
  preload="./app-preload.js"
/>
```

The host (our Electron app) listens for `postMessage` from
the webview, responds with `hostContext` CSS variables, and
logs every message bidirectionally:

```
App → Host:  ui/initialize { clientInfo }
Host → App:  result { hostContext: { css: { --host-bg, --host-fg, ... } } }
App → Host:  ui/notifications/initialized
```

The theme preset switcher lets developers test their MCP App
against different host themes (VS Code Dark, VS Code Light,
custom) — a real pain point called out in Ashita's blog.

### Proof of Work

Three artifacts demonstrate feasibility:

**1. Interactive Mockup v11** (`mockup/index.html`)
Updated to show standalone Electron UI with custom title bar,
IPC architecture diagrams, `<webview>` references, and
explicit "this is NOT inside API Dash" callout.

**2. Node.js PoC** (`poc/poc.js`) — 12 tests
```bash
node poc/poc.js
```
```
✓ All 12 tests passed  (~230ms total)

Layer Breakdown:
■ Transport      ── OK       stdio spawn + stdin/stdout pipe
■ Protocol       ── OK       JSON-RPC initialize · error codes
■ Tool Exec      ── OK       tools/call · schema · _meta.ui
■ UI Handshake   ── OK       ui/initialize · hostContext CSS
```

Supports `--json` flag for structured output matching
the IPC format the Electron main process will emit.

**3. Python3 PoC** (`poc/poc.py`) — 12 tests
```bash
python3 poc/poc.py
```
```
✓ All 12 tests passed  (~90ms total)
```

Same 4-layer classifier, same snapshot diff engine,
zero external dependencies. Serves as evaluation harness.

**Demo video:** https://youtu.be/GAZrTelq_M0

### Comparison with Existing Tools

| Feature | MCP Inspector | MCPJam Inspector | **This project** |
|---|---|---|---|
| Manual testing | ✓ | ✓ | ✓ |
| Saved scenarios | ✗ | ✗ | **✓** |
| Automated replay | ✗ | ✗ | **✓** |
| Layer classification | ✗ | ✗ | **✓ (4 layers)** |
| Baseline + diff | ✗ | ✗ | **✓** |
| MCP Apps preview | ✗ | Partial | **✓ (webview)** |
| hostContext testing | ✗ | ✗ | **✓ (theme presets)** |
| `_meta.ui.resourceUri` | ✗ | ✗ | **✓ (auto-detect)** |
| Standalone desktop app | ✗ (browser) | ✗ (browser) | **✓ (Electron)** |

**4. Weekly Timeline**

**Community Bonding (May)**
- Deep-dive into project structure and confirm Electron
  scaffolding approach with mentors (electron-forge or
  electron-vite for build tooling)
- Set up monorepo structure, CI pipeline, linting
- Agree on IPC contract between main and renderer process
- Review React state management approach (Zustand preferred
  for simplicity; confirm with mentors)

**Week 1–2 · Electron Shell + Transport Layer**
- Scaffold Electron app: main process, preload bridge,
  React renderer with Vite
- Implement `StdioTransport.ts` in main process:
  `child_process.spawn`, `readline`, timeout guard,
  event tracing
- Implement `MCPClient.ts`: JSON-RPC 2.0 pending map,
  `send()` / `notify()` / `disconnect()`
- Wire IPC handlers: `mcp:connect`, `mcp:send`,
  `mcp:disconnect`
- Unit tests for transport and client modules
- ✅ Milestone: `ipcRenderer.invoke('mcp:send', 'initialize', params)` works against a real MCP server

**Week 3–4 · Session Setup UI**
- `SessionSetup.tsx`: form for transport type, server
  command, working directory, environment variables
- On "Validate & Save": renderer calls `mcp:connect`
  via IPC, main process spawns server, runs initialize
  handshake, returns validation result
- Validation panel shows 4 pills: process spawned,
  pipe open, handshake OK, serverInfo received
- Sessions saved to local JSON file via `snapshot:save` IPC
- ✅ Milestone: user configures, validates, and saves an MCP target

**Week 5–6 · Scenario Runner**
- `ScenarioRunner.ts`: ordered step execution engine —
  each step is a `{ method, params, assertions }` object
- `ScenarioRunner.tsx`: live step status badges
  (PENDING → RUNNING → PASS/FAIL), JSON-RPC output panel
  showing raw request/response for each step
- `_meta.ui.resourceUri` auto-detection: after each
  `tools/call` response, check `result._meta?.ui?.resourceUri`
  — if present, show pink banner linking to MCP Apps page
- Artifact save: after each run, serialize the full
  step results + trace log to a timestamped JSON file
- ✅ Milestone: user runs a multi-step scenario with live output and `_meta` detection

**Week 7 · Midterm Buffer**
- Address midterm evaluation feedback
- Developer documentation for transport + runner modules
- Integration tests: spawn real MCP server, run scenario,
  verify trace output programmatically

**Week 8–9 · Trace Inspection**
- `TraceInspector.ts`: consumes the event array from
  `StdioTransport.getTrace()`, applies `classifyError()`
  decision tree to every error event, produces a
  per-layer summary
- `TraceInspection.tsx`:
  - Event timeline: vertical connected line with colored
    dots (green = pass, red = fail), timestamps, expandable
    raw request/response
  - Layer breakdown grid: 4 cards showing OK/FAIL per layer
  - Classifier decision tree: visual display of which error
    codes map to which layers (educational + debuggable)
  - Reclassify action: user can override if they believe
    the automatic classification is wrong
- ✅ Milestone: any MCP failure classified to the correct layer

**Week 10 · Replay & Compare**
- `SnapshotStore.ts`: save/load baselines to filesystem
  via IPC, `diffSnapshots()` field-level comparison
- `ReplayCompare.tsx`:
  - Run history list with timestamps, pass/fail counts
  - "Pin as Baseline" action on any run
  - Diff view: summary tab (field-level changes) +
    payload diff tab (git-style +/- syntax highlighting)
  - "Replay Baseline" button: re-runs the saved scenario
    and auto-diffs against the pinned baseline
- ✅ Milestone: regression detected and displayed as readable diff

**Week 11 · MCP Apps Layer + HTTP Transport**
- `AppPreview.tsx`: Electron `<webview>` tag loading the
  MCP App HTML from the server's resource URI
- `HostContextSandbox.ts`: 3 theme presets (VS Code Dark,
  VS Code Light, Custom) — each injects a different set
  of CSS variables via `postMessage`
- `MCPAppsPreview.tsx`:
  - Webview frame showing the live MCP App
  - Handshake state panel: READY → SENT → INJECTED → COMPLETE
  - Live postMessage log: every JSON-RPC message between
    host and app, timestamped, color-coded (in/out)
  - Theme switcher: click preset, app re-renders live
- `HttpTransport.ts`: fetch-based HTTP/SSE transport for
  servers that don't use stdio
- ✅ Milestone: full MCP Apps testing + HTTP transport end-to-end

**Week 12 · Polish + Final Submission**
- Full test coverage (unit + integration + E2E with Playwright)
- User guide: how to configure, run, inspect, compare
- Developer guide: architecture, IPC contract, adding new layers
- Final PR, updated demo video, GSoC final report

### Deliverables Summary

| # | Deliverable | Week |
|---|------------|------|
| M1 | Electron shell + `StdioTransport` + `MCPClient` + IPC | 1–2 |
| M2 | Session Setup UI (wired to real transport via IPC) | 3–4 |
| M3 | Scenario Runner with live output + `_meta` detection | 5–6 |
| M4 | Trace Inspection — 4-layer classifier + timeline UI | 8–9 |
| M5 | Replay & Compare — snapshots + diff engine + UI | 10 |
| M6 | MCP Apps layer (`<webview>` + hostContext) + HTTP transport | 11 |
| M7 | Full tests + documentation + final report | 12 |

### Why I Will Complete This

The three hardest questions in any GSoC project are already
answered:

- **"Will the transport layer actually work?"** — `poc.js`
  already does it. 12 tests, real stdio, real JSON-RPC.
  The Electron main process code is a typed version of
  what already runs.

- **"Does the contributor understand the architecture?"** —
  The mockup shows the Electron IPC flow. PR #1349 proves
  I can read and extend real production code. The Python3
  PoC proves the concept is language-agnostic.

- **"Will they stay engaged?"** — I've attended every weekly
  connect, posted in Discord daily, and shipped 3 PRs before
  the proposal deadline. I have zero competing commitments
  during GSoC.

---

### References

| Resource | Link |
|---|---|
| MCP Testing discussion | https://github.com/foss42/apidash/discussions/1225 |
| Application guide | https://github.com/foss42/apidash/discussions/1048 |
| Flutter contribution PR | https://github.com/foss42/apidash/pull/1349 |
| Refined idea + PoC PR | https://github.com/foss42/apidash/pull/1336 |
| Initial idea PR | https://github.com/foss42/apidash/pull/1284 |
| MCP Apps spec (mentor) | https://dev.to/ashita/a-practical-guide-to-building-mcp-apps-1bfm |
| Demo video | https://youtu.be/GAZrTelq_M0 |
