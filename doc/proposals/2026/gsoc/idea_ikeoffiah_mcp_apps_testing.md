### Initial Idea Submission

**Full Name:** Ikeoffiah Pius  
**University name:** Federal University of Technology Owerri  
**Program you are enrolled in (Degree & Major/Minor):** B.Tech  
**Year:** Graduated  
**Expected graduation date:** 2019  

**Project Title:** Native MCP Apps Sandbox & Testing Suite  
**Relevant issues:** https://github.com/foss42/apidash/discussions/1225  

## Idea description

This proposal introduces a **Native MCP Apps Sandbox** built directly into API Dash. Unlike traditional MCP testing tools that focus solely on backend primitives (Tools, Resources, Prompts), this project specifically targets **testing MCP Apps** — the new sandboxed, interactive UI extensions of MCP.

By building a deeply integrated module within API Dash using **Flutter's native WebView capabilities**, developers will get a zero-setup, cohesive testing environment to interact with both MCP servers and their UI layers without needing a separate web application.

---

## Problem Statement

MCP Apps allow MCP servers to deliver **interactive, sandboxed iframe-based UIs** (like forms or data visualizations) directly to AI hosts. Developers building these MCP Apps currently face severe testing roadblocks:

1. **No Sandbox Testing Harness:** The `ui/initialize` handshake, host capability discovery, and context updates cannot be tested with traditional MCP testing tools.
2. **Opaque iframe Communication:** MCP Apps communicate with hosts via `postMessage`. Debugging this JSON-RPC stream requires a live AI host (like VS Code Insiders); there is no standalone developer tool to inspect these messages.
3. **Untested UI-to-Backend Tool Calls:** When a user clicks a button inside the MCP App, it can trigger `tools/call` to the server. This UI-initiated execution path is invisible to standard tool-testing CLI scripts.
4. **No Capability Mocking:** MCP Apps invoke host capabilities like `open_link`, `add_message_to_chat`, or `resize_iframe`. Developers cannot currently mock these to test how their UI degrades when a host rejects a capability.

---

## Proposed Solution: Native Flutter MCP Apps Sandbox

A new, dedicated **MCP Sandbox Module** built directly into the API Dash Flutter application. It will act as a simulated AI host capable of loading, rendering, and comprehensively testing MCP Apps without leaving the API Dash window.

### Core Architecture

![Architecture Diagram](images/native_mcp_app_sandbox_architecture.png)

**Architecture Description:**
The system integrates directly into the existing **API Dash** application natively. It consists of three primary layers:
1. **API Dash UI Layer:** A Flutter-based "Sandbox Manager" provides the controls for connection and tool selection, while the "Message Inspector UI" streams the live JSON-RPC activity.
2. **Flutter WebView Bridge:** This layer uses platform native webviews to render the embedded MCP App UI (`text/html;profile=mcp-app`) securely inside API Dash. It injects JavascriptChannels to actively intercept and map all `postMessage` protocol communication between the sandboxed UI and the host.
3. **Native Dart MCP Client Layer:** A Dart client module that handles the underlying transport protocol (`stdio` or `Http/SSE`) straight through to the "MCP Server Under Test". When an action occurs in the WebView, this native layer intercepts it and transparently acts as the host bridge to the server.

---

## Key Features

### Feature 1 — Native MCP Client & App Discovery
Built purely in Dart, the client connects to local or remote MCP servers via `stdio` or HTTP/SSE. It auto-discovers capabilities and identifies specific UI resources bound to tools (the `_meta.ui.resourceUri` pattern). 

### Feature 2 — Secure WebView Sandbox
Instead of using an HTML iframe in a React app, this uses Flutter's native webview capabilities (`webview_flutter` or desktop equivalents) to securely render the MCP App's HTML resource inline within API Dash. It acts as the "host" surface.

### Feature 3 — Dart-JS Interop Message Inspector
Through Flutter's JavascriptChannels, the application intercepts every `postMessage` sent from the MCP App to the host window. These messages are serialized and streamed to a beautiful, native Flutter timeline UI, showing:
- Direction (Host → App, App → Host)
- Method names and parameters
- Round-trip latency

### Feature 4 — Flutter-Mocked Host Capabilities
When the loaded MCP App requests something from the host (e.g., `open_link`), the Flutter app catches it. The developer can configure the API Dash Sandbox to:
- **Auto-Allow:** e.g., natively open the link using `url_launcher`.
- **Auto-Deny:** Simulate a restricted host, ensuring the MCP app handles the rejection gracefully without crashing.
- **Mock:** Simulate `add_message_to_chat` by showing a mock chat bubble in the test dashboard.

### Feature 5 — Bridging tools/call from the UI
If a developer clicks a "Submit" button inside the rendered MCP App, the app requests the host to execute `tools/call`. The Dart client intercepts this, performs the actual RPC call to the underlying MCP Server, and routes the response back into the WebView. This allows end-to-end testing of UI-driven tool execution.

### Feature 6 — Automated Protocol Compliance Runner
A single-click Dart test runner that asserts:
- Was `ui/initialize` dispatched under 3 seconds?
- Is the MIME type exactly `text/html;profile=mcp-app`?
- Does the App handle capability rejection without generating an unhandled promise rejection?

---

## Implementation Plan & Milestones

### Milestone 1 — Dart MCP Client & Core Connectivity
- Implement JSON-RPC 2.0 communication over `stdio` and HTTP/SSE natively in Dart.
- Add support for discovering resources and tool schemas.
- Implement the fetch logic for `ui://` protocols.

### Milestone 2 — WebView Integration & JavascriptChannel Bridge
- Integrate a cross-platform WebView into API Dash's UI.
- Implement the JavaScript interception layer to strictly capture `postMessage` events emitted by the MCP App.
- Implement the `ui/initialize` → `ui/notifications/initialized` handshake.

### Milestone 3 — Inspector Dashboard & Capability Mocking
- Build the Flutter UI panel for the real-time Message Inspector.
- Build the settings panel to configure Host Capability behavior (Allow/Deny/Mock).
- Wire up the UI-to-Backend `tools/call` forwarding logic.

### Milestone 4 — Compliance Engine & Polish
- Implement the automated compliance test runner for verifying spec adherence.
- Ensure cross-platform stability (macOS, Windows, Web/Linux where WebView permits).
- Finalize documentation and create demo testing projects.
