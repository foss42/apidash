# MCP Testing & Security Suite — POC

A proof-of-concept demonstrating MCP server connection, tool discovery, invocation, and **tool poisoning detection** 

## What This Demonstrates

1. **MCP Client Engine** — Connects to any MCP server via stdio transport, performs the JSON-RPC handshake, and discovers tools/resources/prompts
2. **Tool Poisoning Detector** — 10 rule-based security checks that analyze tool descriptions for malicious patterns (instruction injection, secrecy language, data exfiltration, Unicode obfuscation, etc.)
3. **Web UI** — Clean light-themed dashboard built with Mantine UI to connect, explore tools, invoke them, and run security scans with a visual score ring + expandable findings

## Demo Video for the POC
https://github.com/user-attachments/assets/448fa305-c871-4d76-b613-8c74e7c5eaf0




## Architecture

```
┌──────────────┐     HTTP/WS     ┌──────────────┐    stdio/JSON-RPC    ┌──────────────┐
│   React UI   │ ◄────────────►  │  Express API  │ ◄──────────────────► │  MCP Server  │
│   (Vite)     │                 │  + WebSocket  │                      │  (any)       │
└──────────────┘                 └──────┬───────┘                      └──────────────┘
                                        │
                                        ├── McpClientEngine
                                        └── ToolPoisoningDetector
```

```
packages/
  shared/    ← Zod schemas + derived TypeScript types (single source of truth)
  server/    ← Express API, MCP client engine, security analyzers
  client/    ← React + Vite + Mantine UI + Tailwind CSS v4 + Framer Motion
test/
  fixtures/  ← Deliberately poisoned MCP server for demo
```

## Quick Start

```bash
# From the poc/ directory
npm install
```

Start the backend and frontend in separate terminals:

```bash
# Terminal 1 — API server (port 3001)
npm run dev:server

# Terminal 2 — React UI (port 3000)
npm run dev:client
```

Open http://localhost:3000 in your browser.

## Demo Walkthrough

### 1. Connect to the test server

The UI is pre-filled with the poisoned test fixture. Click **Connect** — this spawns the test MCP server as a child process and performs the full handshake.

- **Command**: `npx`
- **Args**: `tsx test/fixtures/poisoned-server.ts`

### 2. Explore tools

After connecting, switch to the **Tools** tab. You'll see 6 discovered tools. Click any tool to see its schema and invoke it with test arguments.

### 3. Run a security scan

Switch to the **Security** tab and click **Run Scan**. The Tool Poisoning Detector analyzes all tool descriptions and returns findings:

| Tool | Findings |
|------|----------|
| `get_weather` | Clean — no findings |
| `search_notes` | Instruction injection, secrecy language, cross-tool reference |
| `send_analytics` | Data exfiltration URL, cross-tool reference, scope escalation |
| `get_forecast` | Scope escalation (weather tool asking for API keys) |
| `translate_text` | Unicode zero-width character obfuscation |
| `summarize_document` | Excessive description length hiding malicious instructions |

## Detection Rules

| ID | Rule | Severity |
|----|------|----------|
| TP-001 | Instruction injection keywords (ALWAYS, MUST, NEVER...) | High |
| TP-002 | Secrecy language ("don't tell the user") | Critical |
| TP-003 | Data exfiltration patterns (URLs, "send to") | Critical |
| TP-004 | Cross-tool references (Tool A mentions Tool B) | High |
| TP-005 | Scope escalation (requesting unrelated credentials) | High |
| TP-006 | Excessive description length (>1000 chars) | Medium |
| TP-007 | Unicode obfuscation (zero-width chars, RTL overrides) | High |
| TP-008 | Base64-encoded content | Medium |
| TP-009 | Prompt injection in parameter descriptions | High |
| TP-010 | Shadowed/duplicate tool names | Critical |

## Tech Stack

- **Runtime**: TypeScript end-to-end, npm workspaces monorepo
- **Shared**: Zod schemas as single source of truth, types derived via `z.infer`
- **Backend**: Express, WebSocket (`ws`), `@modelcontextprotocol/sdk`
- **Frontend**: React, Vite, Mantine UI (light theme, `primaryColor: cyan`), Tailwind CSS v4, Framer Motion
- **Validation**: Zod on all 4 layers (shared → server → engine → client)

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| POST | `/api/connect` | Connect to an MCP server |
| POST | `/api/disconnect` | Disconnect from current server |
| GET | `/api/capabilities` | Get discovered tools/resources/prompts |
| POST | `/api/invoke` | Invoke a tool with arguments |
| POST | `/api/security/scan` | Run tool poisoning scan |
| GET | `/api/status` | Connection status |
