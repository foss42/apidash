# GSoC 2026 Application: CLI and MCP Support

> **Disclaimer**: This application was drafted with the assistance of AI tools (Google Gemini / Antigravity). AI was used to help structure, format, and refine the document. All technical ideas, code prototypes, design decisions, and project understanding are my own original work.

---

## About

| Field | Details |
|:---|:---|
| **Full Name** | Arman Asif Rayma |
| **Email** | armanrayma10@gmail.com |
| **Discord** | arman_22411 |
| **GitHub** | [armanraymagit](https://github.com/armanraymagit) |
| **LinkedIn** | [arman-rayma](https://www.linkedin.com/in/arman-rayma/) |
| **Time Zone** | IST |
| **Resume** | [CV (PDF)](https://github.com/user-attachments/files/26220893/CV.2.pdf) |

---

## University Info

| Field | Details |
|:---|:---|
| **University** | Amity University Online |
| **Program** | Bachelor of Computer Application |
| **Year** | 2nd |
| **Expected Graduation** | 2028 |

---

## Motivation & Past Experience

AI Developer with experience in building real-world applications. Interned at the AI/ML Program by Edunet Foundation, IBM Skills Build, AICTE.

### Q&A

**1. Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?**

No, I have not worked with any FOSS project before.

**2. What is your one project/achievement that you are most proud of? Why?**

The one project that I am most proud of is the **AllyMind AI Project** where I built a full-stack AI application from the ground up. It has a complete React frontend system with its own Django backend system, local-first architecture using Ollama for data and security. I automated all workflows of testing and deployment through GitHub Actions and additionally used Docker for creating an image of the software to be delivered cross-platform.

**3. What kind of problems or challenges motivate you the most to solve them?**

I like debugging the issues and bugs that appear in red — my motivation is seeing my screen turn green.

**4. Will you be working on GSoC full-time? In case not, what will you be studying or working on while working on the project?**

Yes, I will be working on GSoC full-time.

**5. Do you mind regularly syncing up with the project mentors?**

Not at all. I don't mind regularly syncing with project mentors and will be available to take up any calls.

**6. What interests you the most about API Dash?**

Its system design and GitHub repository that are well maintained.

**7. Can you mention some areas where the project can be improved?**

Yes, areas like DashBot can be improved. From my understanding, when I first tried DashBot the one thing I noticed was the Ollama provider was not responding and returned a 400 invalid request on the POST API request — this can be further improved. Additionally, the capabilities of DashBot are limited.

---

## 1. Project Proposal Information

**1.1 Proposal Title** — CLI and MCP Support

**1.2 Abstract:**
In this project I will be building a CLI tool with TypeScript, Node.js, and npm packages that can be published later. I will also be building full MCP Support for API Dash with the `mcp_dart` 2.1.0 package. All work will be done under my mentor's guidance and supervision.

---

## 2. Tech Stack

### 2.1 API Dash CLI
- **Language**: [TypeScript](https://www.typescriptlang.org/) (v5.3+)
- **Runtime**: [Node.js](https://nodejs.org/) (v18+)
- **Execution**: [tsx](https://tsx.is/) for seamless TypeScript execution and hot-reloading.
- **SDK**: [@modelcontextprotocol/sdk](https://www.npmjs.com/package/@modelcontextprotocol/sdk) for connecting to MCP servers.
- **Tooling**: ESLint for linting, Prettier for formatting, and npm workspaces for monorepo management.

### 2.2 MCP (Model Context Protocol) Implementation
- **MCP Server (Dart)**:
  - **SDK**: [mcp_dart](https://pub.dev/packages/mcp_dart) (v2.1+) for implementing server capabilities.
  - **Protocol Layer**: [json_rpc_2](https://pub.dev/packages/json_rpc_2) for handling RPC methods.
  - **Transport**: `stream_channel` and `dart:io` for Stdio-based communication.
- **MCP Host (Flutter)**:
  - **State Management**: [Riverpod](https://riverpod.dev/) for managing server connections and tool discovery.
  - **Core Integration**: Built-in support for multiple MCP server configurations within the DashBot settings.
- **Common Standards**:
  - **Communication**: JSON-RPC 2.0.
  - **Data Exchange**: JSON using `json_annotation` for type-safe models.

### 2.3 System Architecture

| Layer | Technology | Role |
|:---|:---|:---|
| **Host (Inside)** | Flutter + `mcp_dart` | **DashBot** — Internal AI agent orchestrating tools. |
| **Host (Outside)** | TypeScript + `@modelcontextprotocol/sdk` | **API Dash CLI** — Command-line agent loop. |
| **Server** | Dart + `json_rpc_2` | **ApidashMcpServer** — Exposes local collections as MCP tools. |
| **Transport** | Stdio / SSE | Secure communication channel between Hosts and Servers. |
| **Sandbox** | Webview | **McpAppViewer** — Isolated environment for interactive tool UIs. |

---

## 3. 12-Week Roadmap & Milestones

| Timeline | Milestone | Key Deliverables |
|:---|:---|:---|
| **Week 1–2** | **Core MCP Stabilization** | Refined Dart MCP Server, SSE transport support, and CLI connection logic. |
| **Week 3–4** | **Standard Tool Suite** | Implementation of `http_request`, `graphql_query`, and `replay_request` tools. |
| **Week 5–6** | **Agentic Testing Alpha** | Launch `ai_api_test` tool for autonomous multi-step validation. |
| **Week 7–8** | **CLI & Advanced Protocol** | Standalone Node.js package, WebSocket support, and secure sandboxing. |
| **Week 9–10** | **Integrations & Code Review** | Cross-platform testing, server load testing, and code reviews. |
| **Week 11–12** | **Documentation & Launch** | Final technical reports, contributor guides, and production deployment. |

---

## 4. Integration Models

### 4.1 "Inside" — DashBot as MCP Host (Dart)

DashBot connects to external MCP servers to orchestrate complex tasks.

- **Example**: Querying a SQLite DB via an external MCP server to populate API headers.
- **UI**: Visualizing data through interactive **MCP Apps** (sandboxed HTML/JS) in the app.

### 4.2 "Outside" — API Dash as MCP Server (Dart)

External AI hosts (Claude Desktop, Cursor) connect to API Dash's data via stdio.

- **Example**: Claude browsing `apidash://requests` to see local history.
- **Tooling**: Claude replaying a saved request via the `replay_request` tool.

### 4.3 "The Bridge" — TypeScript CLI

A standalone node package that connects to the Dart MCP Server for terminal-based agentic testing.

- **Agent Loop**: AI iterates through tools (`http`, `graphql`, `ai_test`) until the user's query is resolved.

---

## 5. Code Snapshots

### 5.1 TypeScript MCP Client (CLI)

```typescript
// apidash_cli/packages/cli/src/services/McpClientService.ts
import { Client } from '@modelcontextprotocol/sdk/client/index.js';
import { StdioClientTransport } from '@modelcontextprotocol/sdk/client/stdio.js';

export class McpClientService {
  async connectServer(server: McpServerConfig): Promise<void> {
    const transport = new StdioClientTransport({
      command: server.command,
      args: server.args,
    });
    const client = new Client(
      { name: 'apidash_cli', version: '1.0.0' },
      { capabilities: {} }
    );
    await client.connect(transport);
    const result = await client.listTools();
    // ... cache connections and tools
  }
}
```

### 5.2 Dart MCP Server (Core Engine)

```dart
// lib/mcp/server_core.dart
class ServerCore {
  final Transport transport;
  late final json_rpc.Server _server;

  ServerCore(this.transport) {
    _server.registerMethod('tools/list', () async {
      final tools = <ToolDescriptor>[];
      if (_toolHandler != null) {
        tools.addAll(await _toolHandler!.listTools());
      }
      return {'tools': tools.map((t) => t.toJson()).toList()};
    });

    _server.registerMethod('tools/call', (parameters) async {
       // Logic to invoke API Dash engine for HTTP/GraphQL requests
    });
  }
}
```

---

## 6. Tool Specification

| Tool | Purpose |
|:---|:---|
| `http_request` | Generic HTTP execution via API Dash engine. |
| `graphql_query` | Specialized GraphQL execution with schema support. |
| `ai_api_test` | Autonomous multi-step validation and report generation. |
| `replay_request` | Re-executes a saved Hive request by UUID. |
| `create_request` | Adds a new request to the local collection. |

---

## 7. Prototypes & Repositories

- **API Dash CLI**: https://github.com/armanraymagit/cli_tool.git
- **MCP Core Server**: https://github.com/armanraymagit/MCP_dart_server.git

---

## 8. Capabilities Supported

| Capability | Inside (DashBot → External) | Outside (Claude → API Dash) |
|:---|:---|:---|
| **Tools** | Discover & call tools on external servers | `replay_request`, `create_request`, `list_environments` |
| **Resources** | Read resources from external servers | `apidash://requests`, `apidash://environments`, `apidash://history` |
| **Prompts** | Discover & get prompts from external servers | Curated DashBot prompt templates |
| **Sampling** | Forward LLM requests from servers to configured AI model | N/A (Claude has its own LLM) |
| **Roots** | Provide workspace folder as root to servers | N/A |
| **Completions** | Aggregate completions from all servers | |
| **Elicitation** | UI dialog for server-requested user input | N/A |
| **MCP Apps** | Render interactive HTML from tool calls | Return interactive UI for Claude to render |

---

## 9. Sample UI for DashBot Update

<img width="677" height="700" alt="DashBot MCP Settings UI" src="https://github.com/user-attachments/assets/cbe588a4-752d-4f6c-b8ec-13175a044ffb" />

<img width="802" height="837" alt="DashBot MCP Server Selector" src="https://github.com/user-attachments/assets/3871bbac-64e6-45da-b601-d8b92122600c" />

<img width="802" height="824" alt="DashBot MCP App Viewer" src="https://github.com/user-attachments/assets/bbaf9d3e-99f7-4cd2-bf06-c7a5dde3441b" />
