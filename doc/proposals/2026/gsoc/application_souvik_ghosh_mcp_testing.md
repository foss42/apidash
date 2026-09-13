# GSoC 2026 Application: MCP Testing Suite — Standalone Desktop App

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

Yes — I have contributed to foss42/apidash with real code:

**PR #1349 — feat: add custom AI model support in selector**
Flutter/Dart contribution to the API Dash codebase. Addresses
issue #1315 (part of meta-issue #1269 — revamping the Model
Selector dialog). I cloned the repo, studied the existing
widget architecture, and extended the AI model selector to
support custom model names alongside the built-in presets.
This involved understanding provider patterns, widget
composition, and the existing test structure.
→ https://github.com/foss42/apidash/pull/1349

I've also been actively participating in the project through
Discussion #1225 (MCP Testing), Discussion #1048 (Application
Guide), every weekly connect session, and the `#gsoc-foss-apidash`
Discord channel daily since early March.

**2. What is your one project/achievement you are most proud of?**

A pair of PoCs I built for this proposal — one in Python3
(`poc.py`) and one in Node.js (`poc.js`), each running 12
automated tests with zero external dependencies.

Each PoC spawns a real MCP server as a child process, connects
via stdin/stdout pipes, exchanges real JSON-RPC 2.0 messages,
and classifies every error to the correct layer using a
decision tree I designed:

- `-32700` on the wire → transport layer (malformed JSON)
- `-32601` or `-32602` → protocol layer (bad method or params)
- `isError: true` in response → tool execution layer
- `ui/*` method failure → UI handshake layer

They also detect `_meta.ui.resourceUri` in tool responses and
run a snapshot diff engine for baseline regression detection.
Both support `--json` for structured output matching the format
the app's backend will emit.

```bash
python3 poc.py  # → 12/12 pass, ~90ms
node poc.js     # → 12/12 pass, ~230ms
```

**3. What kind of problems motivate you most?**

Developer tooling gaps. MCP is now the standard way AI agents
discover and invoke tools — VS Code, Claude, and dozens of
hosts use it. But testing an MCP server today means opening a
terminal, hand-writing a JSON-RPC payload in curl, getting
back an error code, and then guessing: was that a transport
problem? A schema mismatch? A bug in the tool itself?

I looked at the existing tools. Anthropic's MCP Inspector is
a browser-based REPL — useful for manual poking, but you
can't save a scenario, replay it after a server change, or
figure out which layer broke. MCPJam's Inspector adds an LLM
playground and some OAuth debugging, which is nice, but it
still doesn't do automated replay, baseline diffing, or
layer classification. Neither of them can test the MCP Apps
`hostContext` injection at all — you'd have to build a custom
iframe setup yourself.

That gap is what this project fills. Not another REPL, but
an automated, replayable, layer-classified testing tool with
MCP Apps sandbox support built in.

**4. Will you be working on GSoC full-time?**

Yes. No internship or coursework conflicts. 35–40 hours/week.

**5. Do you mind regularly syncing up with mentors?**

Not at all. I've been at every weekly connect and on Discord
daily. I actively want regular sync, not just tolerate it.

**6. What interests you most about API Dash?**

It's developer-first — fast, local, no account needed. And
the timing is perfect: the org is building standalone tooling
around MCP, the fastest-growing protocol in the AI ecosystem.
Contributing now means shaping something from the ground up.

**7. Areas where the project can be improved?**

MCP testing is the biggest gap. There's no dedicated tool
to test MCP servers, classify transport vs protocol vs tool
failures, or validate the MCP Apps `ui/initialize` handshake.
This proposal builds that as a standalone desktop app with a
Python3 backend. Beyond this project, snapshot-and-replay for
AI/LLM API calls would be a natural extension.

---

### Project Proposal Information

**1. Proposal Title**

MCP Testing Suite — Standalone Desktop App for Full-Stack
MCP & MCP Apps Testing

**2. Abstract**

MCP is the standard API layer of the AI world. But developers
building MCP servers have no dedicated testing tool. They
craft JSON-RPC payloads by hand, get opaque error codes, and
can't tell whether a failure is in the transport, the protocol,
or the tool itself.

The new MCP Apps spec makes it worse — servers now serve rich
HTML UI components via sandboxed iframes, requiring a
`ui/initialize` handshake and `hostContext` CSS injection.
No existing tool handles any of this.

This project builds the **MCP Testing Suite** as a
**standalone Electron desktop application** with a **Python3
backend** and a **React/TypeScript frontend**. It is a
self-contained app in the API Dash ecosystem — not a tab or
plugin inside the existing API Dash Flutter app.

- **Python3 backend** (runs in Electron main process via
  child process): handles MCP server lifecycle, stdio/HTTP
  transport, JSON-RPC communication, trace classification,
  snapshot storage, and diff computation
- **React/TypeScript frontend** (Electron renderer): all UI
  pages — Session Setup, Scenario Runner, Trace Inspection,
  Replay & Compare, MCP Apps Preview
- **Electron shell**: provides desktop app experience, native
  filesystem access, `<webview>` tag for secure MCP Apps
  sandboxing, and bridges frontend ↔ backend via IPC

**3. Detailed Description**

### Why Standalone? Why Electron? Why Python3 Backend?

Stdio transport requires spawning MCP servers as child
processes and reading their stdin/stdout — this can't run
in a browser. Electron provides the desktop shell.

Python3 is the backend language because:
- The MCP Python SDK (`mcp` package) is mature and
  well-maintained — first-class `stdio` and `sse` client support
- `subprocess.Popen` + `threading` handles stdio transport
  cleanly (proven in `poc.py`)
- `asyncio` enables concurrent scenario execution
- The evaluation harness is naturally Python3
- Aligns with the project's Python skill requirement

The architecture: Electron's main process spawns a Python3
backend process on app startup. The React renderer
communicates with it via local WebSocket or HTTP. The Python
backend owns all MCP logic — transport, client, testing
engine, trace classification, snapshots. The React frontend
is purely the UI layer.

### The Problem

Today, testing an MCP server means opening curl and typing
something like `echo '{"jsonrpc":"2.0","id":1,"method":
"initialize",...}' | npx server-weather`. You get back either
a JSON blob or an error code. If it's `-32602`, is that
because your params were wrong, or because the server
crashed during validation? There's no way to know without
reading the server source code.

After a server update, you re-type the same curl command and
eyeball whether the response changed. There's no saved
baseline, no diff, no regression detection.

If the server delivers an MCP App (a rich HTML component),
you have no way to test the `ui/initialize` handshake or
verify that the app renders correctly under different host
themes without building a custom iframe setup from scratch.

This tool solves each of these:

- **Session Setup** replaces curl with a persistent config —
  transport type, server command, env vars, working directory.
  One click validates the connection end-to-end.
- **Scenario Runner** replaces manual typing with saved,
  ordered test steps. Each step has assertions. Run them all
  at once, see live pass/fail per step.
- **Trace Inspection** replaces guessing with a 4-layer
  classifier that reads the error code and tells you exactly
  which layer broke: transport, protocol, tool execution, or
  UI handshake.
- **Replay & Compare** replaces eyeballing with a snapshot
  diff engine. Pin a baseline, replay after a server change,
  see exactly what fields changed.
- **MCP Apps Preview** replaces building a custom iframe with
  a secure `<webview>` sandbox that runs the full
  `ui/initialize → hostContext → initialized` handshake and
  logs every `postMessage` in real time.

### Architecture

```
mcp-testing-suite/                    # standalone Electron app
├── package.json
├── electron/
│   ├── main.ts                       # spawns Python backend on startup
│   ├── preload.ts                    # contextBridge for renderer
│   └── backend-bridge.ts            # manages Python child process
├── backend/                          # Python3 — all MCP logic
│   ├── requirements.txt              # mcp, websockets, uvicorn
│   ├── main.py                       # entry point, starts WS server
│   ├── transport/
│   │   ├── stdio_transport.py        # subprocess.Popen + readline
│   │   └── http_transport.py         # httpx-based HTTP/SSE client
│   ├── client/
│   │   └── mcp_client.py            # JSON-RPC 2.0 pending map
│   ├── testing/
│   │   ├── scenario_runner.py        # step-by-step execution
│   │   ├── trace_inspector.py        # 4-layer classifier
│   │   └── snapshot_store.py         # baseline capture + diff
│   ├── apps/
│   │   └── host_context.py           # CSS variable presets
│   └── api/
│       └── ws_handler.py            # WebSocket API for frontend
├── src/                              # React/TypeScript frontend
│   ├── pages/
│   │   ├── SessionSetup.tsx
│   │   ├── ScenarioRunner.tsx
│   │   ├── TraceInspection.tsx
│   │   ├── ReplayCompare.tsx
│   │   └── MCPAppsPreview.tsx
│   ├── components/
│   ├── hooks/
│   │   └── useBackend.ts            # WebSocket hook to Python API
│   ├── store/                        # Zustand state management
│   ├── App.tsx
│   └── main.tsx
├── poc/
│   ├── poc.py                        # Python3 PoC (12 tests)
│   └── poc.js                        # Node.js PoC (12 tests)
└── tests/
    ├── test_transport.py
    ├── test_classifier.py
    ├── test_snapshot.py
    └── test_scenario.py
```

### How Each Module Works

**stdio_transport.py** (Python3 backend)

This is the exact pattern proven by `poc.py`:
```python
class StdioTransport:
    def connect(self, command, args, env):
        self.proc = subprocess.Popen(
            [command] + args,
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True, bufsize=1,
            env={**os.environ, **env}
        )
        self._reader = threading.Thread(
            target=self._read_loop, daemon=True
        )
        self._reader.start()

    def send(self, method, params) -> dict:
        id = self._next_id()
        request = {
            "jsonrpc": "2.0", "id": id,
            "method": method, "params": params
        }
        self.proc.stdin.write(json.dumps(request) + "\n")
        self.proc.stdin.flush()
        return self._wait_for(id, timeout=5.0)
```

The React frontend never touches subprocess directly. Instead:
```
React UI
  → useBackend() hook sends WebSocket message
  → Python ws_handler.py receives it
  → calls stdio_transport.send(method, params)
  → returns result back over WebSocket
  → React updates UI
```

**trace_inspector.py** — 4-Layer Classifier

```python
def classify_error(error, context=None):
    code = error.get("code")

    # Layer 1 — Transport
    if context.get("spawn_failed") or context.get("pipe_broken"):
        return "transport"
    if code == -32700:       # parse error = bad JSON on wire
        return "transport"

    # Layer 2 — Protocol
    if code == -32600:       # invalid request structure
        return "protocol"
    if code == -32601:       # method not found
        return "protocol"
    if code == -32602:       # missing/invalid params
        return "protocol"

    # Layer 4 — UI Handshake
    if context.get("method", "").startswith("ui/"):
        return "ui-handshake"

    # Layer 3 — Tool Execution (default)
    return "tool-exec"
```

This isn't pseudocode — it's the actual function from `poc.py`,
tested against real JSON-RPC error codes across 12 tests.

**snapshot_store.py** — Diff Engine

```python
def diff_snapshots(baseline, current, path="$"):
    diffs = []
    if type(baseline) != type(current):
        diffs.append({"path": path, "type": "type-change"})
        return diffs
    if isinstance(baseline, dict):
        all_keys = set(baseline) | set(current)
        for k in all_keys:
            if k not in baseline:
                diffs.append({"path": f"{path}.{k}", "type": "added"})
            elif k not in current:
                diffs.append({"path": f"{path}.{k}", "type": "removed"})
            else:
                diffs.extend(diff_snapshots(baseline[k], current[k], f"{path}.{k}"))
    elif baseline != current:
        diffs.append({"path": path, "type": "value-change",
                       "from": baseline, "to": current})
    return diffs
```

Snapshots are saved as JSON files on the local filesystem.
The Python backend handles all file I/O; the React frontend
just displays the diff.

**MCP Apps Preview** — Electron `<webview>` Sandbox

MCP Apps run inside Electron's `<webview>` tag, which is more
secure than a browser iframe — it runs in an isolated Chromium
process with its own security context:

```html
<webview
  src="ui://mcp-server/dashboard"
  partition="mcp-app-sandbox"
  nodeintegration="false"
/>
```

The handshake flow:
```
App → Host:   ui/initialize { clientInfo }
Host → App:   result { hostContext: { css: { --host-bg, ... } } }
App → Host:   ui/notifications/initialized
```

The Python backend generates the hostContext CSS variable sets.
The React frontend renders the webview and logs every
postMessage bidirectionally. The theme preset switcher (VS Code
Dark, VS Code Light, Custom) lets developers verify their MCP
App renders correctly across different host environments.

### What Exists Today vs What This Builds

The two main tools available right now are Anthropic's MCP
Inspector and MCPJam's Inspector. MCP Inspector is the
official one — you run `npx @modelcontextprotocol/inspector`
and get a browser REPL where you can manually send requests
and see responses. It's good for quick checks, but everything
is manual and ephemeral. You can't save a test, replay it
tomorrow, or figure out which layer of the protocol broke.

MCPJam's version adds some useful features — an LLM playground
where you can chat with a model that uses your MCP tools, and
an OAuth configuration debugger. But the core testing workflow
is still manual. There's no concept of "run these 5 steps in
order and tell me if step 3 regressed since last Tuesday."

Neither tool touches the MCP Apps layer. If your server exposes
a `text/html;profile=mcp-app` resource and you want to verify
the `ui/initialize` handshake works or that your dashboard
re-themes correctly when a host sends different CSS variables,
you're on your own.

This project fills those gaps: saved scenarios that run
automatically, a classifier that maps every error to its
protocol layer, a baseline-and-diff engine for catching
regressions, and a secure webview sandbox for MCP Apps with
live theme switching and postMessage logging.

### Proof of Work

**1. Interactive Mockup v11** (`mockup/index.html`)
Standalone Electron-framed UI with custom title bar, IPC
architecture diagrams, `<webview>` references for MCP Apps,
and explicit "this is NOT inside API Dash" callout. Open in
any browser, no build step.

**2. Python3 PoC** (`poc/poc.py`) — 12 tests, zero deps
```bash
python3 poc/poc.py
```
```
✓ All 12 tests passed  (~90ms total)

Layer Breakdown:
■ Transport      ── OK       subprocess spawn + stdin/stdout
■ Protocol       ── OK       JSON-RPC initialize · error codes
■ Tool Exec      ── OK       tools/call · schema · _meta.ui
■ UI Handshake   ── OK       ui/initialize · hostContext CSS
```

**3. Node.js PoC** (`poc/poc.js`) — 12 tests, zero deps
```bash
node poc/poc.js
```
Same 12 tests, same 4-layer classifier, same snapshot diff.
Supports `--json` for structured output.

**Demo video:** https://youtu.be/GAZrTelq_M0

**4. Weekly Timeline**

**Community Bonding (May)**
- Confirm Electron + Python3 architecture with mentors
- Set up project scaffold: Electron shell, Python backend
  process, React frontend with Vite, WebSocket bridge
- Agree on WebSocket API contract between frontend and backend
- Set up CI pipeline, linting (ruff for Python, eslint for TS)

**Week 1–2 · Python Backend + Transport Layer**
- Scaffold Electron app: main process spawns Python backend
  on startup, preload bridge exposes WebSocket connection
- `stdio_transport.py`: `subprocess.Popen`, readline thread,
  timeout guard, event trace buffer
- `mcp_client.py`: JSON-RPC 2.0 pending map, `send()`,
  `notify()`, `disconnect()`, error type wrappers
- `ws_handler.py`: WebSocket server exposing `connect`,
  `send`, `disconnect` commands to the frontend
- Unit tests: `test_transport.py`, `test_client.py`
- ✅ Milestone: React UI calls `ws.send({cmd: "mcp:send", method: "initialize"})` and gets a real response from a live MCP server

**Week 3–4 · Session Setup UI**
- `SessionSetup.tsx`: form for transport type, server command,
  working directory, environment variables
- On "Validate & Save": frontend sends `connect` command over
  WebSocket → Python backend spawns server → runs initialize
  → returns validation result
- Validation panel: 4 pills (process spawned, pipe open,
  handshake OK, serverInfo received)
- Sessions saved to local JSON file by Python backend
- ✅ Milestone: user configures, validates, and saves an MCP target

**Week 5–6 · Scenario Runner**
- `scenario_runner.py`: ordered step execution — each step
  is `{ method, params, assertions }`, run sequentially,
  stream results to frontend via WebSocket
- `ScenarioRunner.tsx`: live step badges (PENDING → PASS/FAIL),
  JSON-RPC output panel, `_meta.ui.resourceUri` auto-detection
  banner
- After each run: serialize full results + trace to a
  timestamped JSON file on disk
- ✅ Milestone: user runs a multi-step scenario with live output

**Week 7 · Midterm Buffer**
- Address midterm feedback
- Developer docs for backend API + transport module
- Integration tests: spawn real MCP server, run scenario,
  verify trace programmatically

**Week 8–9 · Trace Inspection**
- `trace_inspector.py`: consumes event array from transport,
  applies `classify_error()` to every error, produces
  per-layer summary
- `TraceInspection.tsx`: event timeline with connected line
  and colored dots, layer breakdown grid (4 cards),
  classifier decision tree display, reclassify override action
- ✅ Milestone: any MCP failure classified to the correct layer

**Week 10 · Replay & Compare**
- `snapshot_store.py`: save/load baselines to filesystem,
  `diff_snapshots()` recursive field comparison
- `ReplayCompare.tsx`: run history list, "Pin as Baseline"
  action, diff view (summary + payload tabs with +/- syntax
  highlighting), "Replay Baseline" button
- ✅ Milestone: regression detected and displayed as readable diff

**Week 11 · MCP Apps Layer + HTTP Transport**
- `host_context.py`: theme presets (VS Code Dark, Light, Custom),
  CSS variable generation
- `MCPAppsPreview.tsx`: Electron `<webview>` loading MCP App,
  handshake state panel (READY → SENT → INJECTED → COMPLETE),
  live postMessage log, theme switcher
- `http_transport.py`: `httpx`-based HTTP/SSE transport for
  servers that don't use stdio
- ✅ Milestone: full MCP Apps testing + HTTP transport working

**Week 12 · Polish + Final Submission**
- Test coverage: pytest for backend, Vitest for frontend
- User guide + developer guide
- Final PR, updated demo video, GSoC final report

### Deliverables Summary

| # | Deliverable | Week |
|---|------------|------|
| M1 | Electron shell + Python backend + `stdio_transport` + WebSocket bridge | 1–2 |
| M2 | Session Setup UI wired to real transport | 3–4 |
| M3 | Scenario Runner with live output + `_meta` detection | 5–6 |
| M4 | Trace Inspection — 4-layer classifier + timeline UI | 8–9 |
| M5 | Replay & Compare — snapshots + diff engine + UI | 10 |
| M6 | MCP Apps (`<webview>` + hostContext) + HTTP transport | 11 |
| M7 | Tests + documentation + final report | 12 |

### Why I Will Complete This

- **"Will the core engine work?"** — `poc.py` already does it.
  12 tests, real subprocess, real JSON-RPC, real classifier.
  The backend code is a structured version of what already runs.

- **"Can this person actually write code for this project?"** —
  PR #1349 proves I can read and extend production code.
  The Python PoC proves I can build the backend. The mockup
  proves I've thought through the UX.

- **"Will they stay engaged?"** — Every weekly connect attended,
  Discord active daily, 3 PRs shipped before the deadline,
  zero competing commitments during GSoC.

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
