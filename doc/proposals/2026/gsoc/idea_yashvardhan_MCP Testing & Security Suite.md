### Initial Idea Submission

Full Name: Yashvardhan Goel  
University name: Birla Institute of Technology and Science Pilani, Pilani  
Program you are enrolled in (Degree & Major/Minor): M.Sc. Biological Sciences and B.E. Manufacturing Engineering  
Year: Graduated  
Expected graduation date: Graduated  

Project Title: MCP Testing & Security Suite  
Relevant issues: [https://github.com/foss42/apidash/discussions/1054](https://github.com/foss42/apidash/discussions/1054) (GSoC 2026 Ideas — Idea #1: MCP Testing)  

Idea description:  

## Problem

[MCP (Model Context Protocol)](https://modelcontextprotocol.io/) is rapidly becoming the standard API protocol for AI, the way REST and GraphQL are for traditional applications. Thousands of MCP servers now exist, but the developer tooling for testing them is fragmented:

- The official [MCP Inspector](https://github.com/modelcontextprotocol/inspector) supports basic manual tool invocation but has no test suites, no assertions, no saved collections, and no security analysis.
- Standalone security scanners like [Snyk's mcp-scan](https://github.com/invariantlabs-ai/mcp-scan) and [Cisco's mcp-scanner](https://github.com/cisco-ai-defense/mcp-scanner) can detect tool poisoning and vulnerabilities, but they're CLI-only tools completely disconnected from functional testing.
- The new [MCP Apps extension](https://blog.modelcontextprotocol.io/posts/2026-01-26-mcp-apps/) lets tools return interactive UI components rendered in sandboxed iframes, but no testing tool exists to validate UI resource rendering, postMessage-based JSON-RPC communication, App API behavior, or the expanded security surface of iframe-hosted UIs.
- No tool today lets a developer answer both "does this MCP server work correctly?" and "is this MCP server safe to deploy?" from a single interface.

## Solution

I propose building an **MCP Testing & Security Suite** under the API Dash umbrella — a React frontend served by a Node.js backend, where developers can connect to any MCP server, functionally test it, and analyze its security posture, all from one interface with one shared connection. For stdio servers, the backend spawns the local process and proxies the MCP connection to the browser over WebSocket; for Streamable HTTP servers, the backend connects directly. The suite also covers the new **MCP Apps extension** — testing interactive UI components returned by tools, validating App API communication over postMessage, and analyzing the expanded security surface of iframe-rendered UIs.

The core architectural insight is that functional testing and security analysis share ~70% of the infrastructure. The security engine is essentially a specialized set of analyzers running against the same server connection that the MCP test engine uses.

## Engineering Differentiators

|Capability|MCP Inspector|mcp-scan / Cisco Scanner|This Project|
|---|---|---|---|
|Interactive tool invocation|✓|✗|✓|
|Test suites & assertions|✗|✗|✓|
|Chained multi-step tests|✗|✗|✓|
|Environment variables|✗|✗|✓|
|Security scanning|✗|✓ (CLI only)|✓ (integrated UI)|
|Unified functional + security view|✗|✗|✓|
|Visual security dashboard|✗|✗|✓|
|Unified server scorecard|✗|✗|✓|
|CI/CD integration|✗|Partial|✓|
|Saved connection profiles|✗|✗|✓|
|MCP Apps UI resource testing|✗|✗|✓|
|App API (postMessage) validation|✗|✗|✓|
|Iframe sandbox security checks|✗|✗|✓|

## UI Wireframes

The interface follows a consistent four-panel layout: **Sidebar** (navigate between views), **Server Explorer** (left — connected server, discovered capabilities with pass/warn/fail status), **Workspace** (center — the active view), and a collapsible **Security Strip** (right — score and findings count at a glance).

### 1. Connection Setup

![Connection Setup](images/connection_mockup.png)

The first screen a developer sees. Select a transport (stdio or Streamable HTTP per [MCP spec 2025-03-26](https://modelcontextprotocol.io/specification/2025-03-26/basic/transports)), configure the server command, arguments, working directory, and environment variables. Recent connections are listed in the explorer for quick reconnect.

### 2. Tool Invocation

![Tool Invocation](images/invoke_mockup.png)

The primary testing workspace. Auto-generated parameter forms from the tool's schema, keyboard shortcuts for power users (&#8984;&#9166; to invoke, &#8984;S to save), and a response viewer with Tree/Raw/Headers tabs. The security panel collapses to a thin strip showing the score (72) and findings count (7), expandable on demand.

### 3. Test Assertions

![Test Assertions](images/test_assertions_mockup.png)

Build assertion suites per tool. Each assertion defines rules (e.g., `response.isError equals false`, `response.forecast[0].high is type number`) with pass/fail results. A summary bar shows the overall test run status with a visual progress indicator.

### 4. Tool Chaining

![Tool Chaining](images/tool_chaining_mockup.png)

Chain multiple tool calls together with variable extraction. Output from one step (e.g., `$lat ← results[0].latitude`) feeds into the next step's parameters. Each step shows its status, extracted variables, and a response preview. This enables end-to-end workflow testing across multiple tools.

### 5. MCP Apps Testing

The MCP Apps testing view targets tools that return interactive UI components via the [MCP Apps extension](https://blog.modelcontextprotocol.io/posts/2026-01-26-mcp-apps/). The explorer panel lists tools that declare `_meta.ui.resourceUri`, indicating they return `ui://` resources. The center workspace renders the UI resource in a sandboxed iframe alongside a live JSON-RPC message log showing all postMessage traffic between the iframe and host — including `ui/notifications/tool-result` deliveries, `ui/update-model-context` calls, and UI-initiated `tools/call` requests. The central panel also displays App API validation results — whether tool results were correctly delivered to the UI via `ui/notifications/tool-result`, whether UI-initiated tool calls require host approval before execution, and whether `ui/update-model-context` payloads are well-formed. This gives developers full visibility into the behavior of interactive MCP tools.

![MCP Apps Dashboard](images/mcp_apps.png)

### 6. Security Dashboard

![Security Dashboard](images/security_mockup.png)

A dedicated security view with score banner, pluggable analyzer results (Tool Poisoning, Input Injection, Auth/Credentials, Protocol Compliance), and a filterable findings table. Selecting a finding expands inline to show the flagged content and concrete remediation guidance.

## Architecture

![Architecture Diagram](images/architecture_diagram.png)

This will be a **separate web application** under the API Dash umbrella, built entirely in TypeScript (React frontend, Node.js runtime backend). This aligns with the tech stack listed for Idea #1.

The system is organized into four layers:

### 1. Presentation Layer (React + TypeScript)
- **Connection Manager** : for configuring and saving server connections.
- **Test Workbench** : for interactive tool invocation and assertion building.
- **Security Dashboard** : for visualizing scan results and compliance status.
- **MCP Apps Tester** : for rendering and validating UI resources returned by tools, inspecting postMessage traffic, and testing App API interactions.
- **Report Generator** : for exporting unified reports

### 2. Backend Services (TypeScript on Node.js runtime)
- The MCP Client Engine is the shared core that handles connection lifecycle, capability negotiation, and tool invocation across both standard transports (stdio, Streamable HTTP) as defined in [MCP spec 2025-03-26](https://modelcontextprotocol.io/specification/2025-03-26/basic/transports), with backwards-compatible support for the deprecated HTTP+SSE transport. For stdio transports, the backend spawns the server process locally and proxies the MCP session to the React frontend over WebSocket; for Streamable HTTP, the backend connects to the remote server directly. This means all MCP communication flows through the backend regardless of transport.
- The Test Execution Engine runs functional test suites with schema validation, assertions, and chained calls. The Security Analysis Engine runs pluggable security analyzers against discovered capabilities.
- The **MCP Apps Validation Engine** renders `ui://` resources in a headless sandboxed environment, intercepts JSON-RPC over postMessage (including `ui/notifications/tool-result`, `ui/update-model-context`, and `tools/call` messages), validates the App API contract (`@modelcontextprotocol/ext-apps`), and checks that UI-initiated tool calls require host approval before execution.

### 3. Pluggable Analyzer Modules
 - **Tool Poisoning Detector**
 - **Auth & Credential Analyzer** 
 - **Protocol Compliance Checker** 
 - **Injection Tester**
 - **MCP Apps Security Analyzer** — validates iframe sandbox attributes, checks for postMessage origin validation, detects UI-initiated `tools/call` requests without proper host approval, and flags template tampering

 ### 4. Target Layer
 The MCP server under test, which can be a local server (spawned via stdio), a remote server (Streamable HTTP with optional OAuth), or a containerized server (Docker sandbox for untrusted servers).

 ## User Flow
 ![Request Flow Diagram](images/request-flow-diagram-2.png)

 ## Pain Points Addressed

This project directly addresses real-world pain points faced by MCP developers:

- **Manual-only tool invocation** with no way to save, replay, or automate → Test collections and reusable suites
- **No assertion framework** for validating responses → Assertion builder with JSON path, schema, regex matching
- **No multi-step workflow testing** for real agent scenarios → Chained tool calls with output piping
- **No environment variable support** for switching between dev/staging/prod → Env variables in collections
- **Poor debugging visibility** when things fail → Full JSON-RPC message log inspector
- **Tool poisoning attacks** via hidden instructions in tool descriptions that manipulate AI model behavior → Two-pass poisoning detector (rule-based + optional LLM-as-a-judge)
- **Command/SQL injection vulnerabilities** in tool parameters due to unsanitized input reaching backend systems → Input injection tester with known attack payloads
- **Rug-pull attacks** where trusted servers are later updated with malicious code → Schema hashing and change detection between scans
- **Credential exposure** with servers relying on static API keys in plaintext configs instead of secure auth flows → Auth/credential hygiene checks
- **Protocol compliance gaps** with servers implementing outdated spec versions and missing security improvements → Validation against MCP spec 2025-11-25
- **Error message information leakage** exposing stack traces and internal paths in tool error responses → Security engine flags sensitive data in error responses
- **Fragmented tooling** requiring 3+ separate tools for testing and security → Single unified interface
- **No CI/CD integration** for automated test gates → CLI mode with SARIF export and severity gates
- **No MCP Apps testing tooling** — developers building tools that return interactive UI components via `ui://` resources have no way to validate rendering, postMessage communication, or App API behavior → MCP Apps Tester with iframe preview and JSON-RPC message inspector
- **postMessage injection risks** — UI resources communicating via JSON-RPC over postMessage are vulnerable to message spoofing if origin validation is missing → Automated postMessage security checks
- **Iframe sandbox misconfiguration** — overly permissive sandbox attributes can expose the host to XSS or data exfiltration → Sandbox attribute validator against least-privilege baseline
- **UI-initiated tool call approval bypass** — MCP Apps can call server tools from the UI via `tools/call`; missing host approval lets rogue UIs execute tools silently → Host approval enforcement verification tests
- **No unified reporting** across functional and security dimensions → Single server scorecard

## Tech Stack

|Component|Technology|
|---|---|
|Language|TypeScript (end to end)|
|Frontend|React + Shadcn/ui + Recharts|
|Backend Runtime|Node.js|
|MCP Communication|`@modelcontextprotocol/sdk`|
|Schema Validation|Zod|
|MCP Apps Testing|`@modelcontextprotocol/ext-apps`|
|Report Formats|JSON, PDF, SARIF|


## Relevant Links

- [MCP Specification (2025-11-25 — Latest)](https://modelcontextprotocol.io/specification/2025-11-25)
- [MCP Specification (2025-03-26 — Transport Spec)](https://modelcontextprotocol.io/specification/2025-03-26/basic/transports)
- [MCP TypeScript SDK](https://www.npmjs.com/package/@modelcontextprotocol/sdk)
- [MCP Inspector](https://github.com/modelcontextprotocol/inspector)
- [SlowMist MCP Security Checklist](https://github.com/slowmist/MCP-Security-Checklist)
- [Snyk mcp-scan](https://github.com/invariantlabs-ai/mcp-scan)
- [Cisco MCP Scanner](https://github.com/cisco-ai-defense/mcp-scanner)
- [API Dash GSoC 2026 Ideas](https://github.com/foss42/apidash/discussions/1054)
- [MCP Authentication & Authorization Pain Points](https://medium.com/@mustafaturan/mcp-authentication-authorization-pain-points-5506e63dd799)
- [Top 6 MCP Vulnerabilities (and How to Fix Them)](https://www.descope.com/blog/post/mcp-vulnerabilities)
- [MCP Apps Announcement](https://blog.modelcontextprotocol.io/posts/2026-01-26-mcp-apps/)
- [`@modelcontextprotocol/ext-apps` Package](https://www.npmjs.com/package/@modelcontextprotocol/ext-apps)
