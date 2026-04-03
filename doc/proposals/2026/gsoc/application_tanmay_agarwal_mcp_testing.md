### About

1. **Full Name:** Tanmay Agarwal
2. **Contact info:** agarwal.tanmay.work@gmail.com
3. **Discord handle:** tanmay_89797
4. **Home page:** —
5. **Blog:** —
6. **GitHub profile link:** https://github.com/agarwal-tanmay-work
7. **LinkedIn:** https://www.linkedin.com/in/tanmay-agarwal-959178368/
8. **Time zone:** IST (UTC+5:30)
9. **Link to a resume:** https://docs.google.com/document/d/1Vghy9Czy_kpR9L2Hxn2L6G3inuIKeonqKfX3P1ZFUPg/edit?tab=t.0

### University Info

1. **University name:** Masters' Union
2. **Program you are enrolled in:** Data Science and Artificial Intelligence
3. **Year:** 1st Year
4. **Expected graduation date:** 2029

### Motivation & Past Experience

**1. Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?**

Yes, I have contributed to open-source codebases of YC-backed startups on a self-initiated basis. I am also actively contributing to the API Dash project as part of this GSoC application — see my PR addressing Issue #1591 (removing unnecessary Flutter SDK dependency from the `genai` package to enable pure-Dart CLI usage).

- API Dash contribution PR: [Link will be added after PR submission]
- GitHub profile with all contributions: https://github.com/agarwal-tanmay-work

**2. What is your one project/achievement that you are most proud of? Why?**

My self-initiated contributions to open-source codebases of YC-backed startups are what I'm most proud of. As a first-year student, I took the initiative to study production-grade codebases, identify issues, and submit meaningful fixes — without being asked or assigned. This required quickly understanding unfamiliar architectures, following strict contribution guidelines, and writing code that met the quality bar of fast-moving startup teams. It taught me that the best way to learn is to contribute to real-world systems, and it shaped my approach to software engineering.

**3. What kind of problems or challenges motivate you the most to solve them?**

I am most motivated by problems at the intersection of developer tooling and emerging protocols. The Model Context Protocol (MCP) represents a paradigm shift in how AI agents interact with external systems, yet the tooling ecosystem is still nascent. Building robust testing infrastructure for MCP — where developers can visually create, inspect, and debug tool calls — is exactly the type of challenge that excites me: it's technically demanding (multi-transport protocol handling, real-time message inspection), has immediate practical value for the growing MCP ecosystem, and contributes to open-source infrastructure that thousands of developers will rely on.

**4. Will you be working on GSoC full-time? In case not, what will you be studying or working on while working on the project?**

Yes, I will be working on GSoC full-time. The coding period coincides with my summer break at Masters' Union, so I will have no academic obligations and can dedicate my full attention to the project.

**5. Do you mind regularly syncing up with the project mentors?**

Not at all — regular mentor sync-ups are essential for staying aligned with project goals and receiving timely feedback. I am comfortable with weekly video calls, async Discord updates, and PR-based reviews. I believe consistent communication is the foundation of a successful GSoC project.

**6. What interests you the most about API Dash?**

API Dash stands out as a truly cross-platform, open-source API client that takes a fundamentally different approach from commercial tools like Postman. What draws me in specifically:

- **AI-first architecture**: The built-in Dashbot, `genai` package, and the `apitoolgen` module show that API Dash is not just adding AI as an afterthought — it's core to the product vision.
- **Clean Flutter/Dart architecture**: The Riverpod-based state management, Freezed models, and monorepo structure (with `packages/` like `apidash_core`, `better_networking`, `genai`) demonstrate excellent software engineering practices.
- **MCP as a first-class citizen**: This season's focus on MCP testing aligns perfectly with the industry direction. API Dash has the opportunity to become THE tool for MCP development, similar to how Postman became the standard for REST APIs.
- **Community-driven development**: The transparent GSoC process, detailed contribution guides, and responsive maintainers make this a project where contributions have real impact.

**7. Can you mention some areas where the project can be improved?**

Based on my exploration of the codebase and issue tracker:

1. **MCP Testing Gap**: There's currently no native support for testing MCP servers/clients — developers must use separate CLI tools or custom scripts. This is the #1 gap and the focus of my proposal.
2. **SSE Handling**: Issue #873 shows SSE raw response display is incomplete. This is relevant because MCP uses SSE for its HTTP transport.
3. **Anthropic Streaming**: Issue #1592 reveals the SSE event parser doesn't handle `event:` type filtering, causing broken streaming for Anthropic. This parsing logic is directly reusable for MCP transports.
4. **genai Package Coupling**: Issue #1591 highlights that the `genai` package has an unnecessary Flutter SDK dependency, blocking pure-Dart CLI usage — a prerequisite for headless MCP server testing.
5. **Code Generation Coverage**: The codegen module covers 30+ languages but doesn't yet generate MCP client/server integration code.

**8. Have you interacted with and helped API Dash community? (GitHub/Discord links)**

- **Discord**: Introduced myself in the `#gsoc-foss-apidash` channel (handle: tanmay_89797)
- **GitHub PR**: Submitted a contribution fixing Issue #1591 — removing unnecessary Flutter SDK dependency from the `genai` package
- **GitHub Profile**: https://github.com/agarwal-tanmay-work

---

### Project Proposal Information

**1. Proposal Title:**

**MCP Testing — Building Create & Test Capabilities for MCP Servers and Clients in API Dash**

**2. Abstract:**

The Model Context Protocol (MCP) is rapidly becoming the standard interface for AI agents to interact with external tools and data sources. However, developers building MCP servers and clients currently lack a visual testing environment — they rely on raw CLI tools, manual JSON-RPC crafting, and ad-hoc scripts to validate their implementations.

This project proposes building a comprehensive MCP testing suite within API Dash that enables developers to:
- **Register and connect** to MCP servers via both stdio and HTTP+SSE transports
- **Discover tools** by sending `tools/list` requests and exploring the schema visually
- **Invoke tools** with a form-based parameter builder and inspect structured responses
- **View message logs** with a real-time timeline of JSON-RPC messages
- **Generate integration code** in Python and TypeScript for MCP client usage

The implementation will be built as a web-based tool using React, Node.js, and TypeScript, leveraging the official MCP TypeScript SDK. It will integrate naturally alongside API Dash's existing HTTP, GraphQL, and SSE testing capabilities, extending the platform into the MCP ecosystem.

**Key deliverables:**
- MCP Server Registry UI (add/edit/delete server connections)
- Tool Discovery panel with JSON Schema visualization
- Tool Invocation interface with parameter forms
- Response Inspector for structured MCP results
- Message Log timeline for debugging
- Code generation templates for Python and TypeScript MCP clients

**3. Detailed Description:**

#### 3.1 Problem Statement

MCP servers expose tools, resources, and prompts through a JSON-RPC 2.0 protocol over stdio or HTTP+SSE transports. Developers building MCP implementations face these challenges:

1. **No visual testing tool**: Testing requires CLI commands or writing throwaway scripts
2. **Schema discovery is manual**: Understanding what tools a server offers requires parsing raw JSON
3. **Debugging is opaque**: JSON-RPC message flows between client and server are hard to trace
4. **No code generation**: Developers write boilerplate MCP client code from scratch

#### 3.2 Proposed Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     React Frontend (UI)                      │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────────────┐ │
│  │ Server       │ │ Tool         │ │ Response Inspector    │ │
│  │ Registry     │ │ Discovery    │ │ + Message Log         │ │
│  │ (CRUD panel) │ │ (schema viz) │ │ (timeline view)       │ │
│  └──────┬───────┘ └──────┬───────┘ └──────────┬───────────┘ │
│         │                │                     │             │
│  ┌──────┴────────────────┴─────────────────────┴───────────┐ │
│  │              MCP Client Service Layer                    │ │
│  │  (TypeScript — transport abstraction, connection mgmt)   │ │
│  └─────────────────────────┬───────────────────────────────┘ │
└─────────────────────────────┼───────────────────────────────┘
                              │
              ┌───────────────┼───────────────┐
              │               │               │
        ┌─────┴─────┐  ┌─────┴─────┐  ┌──────┴──────┐
        │ MCP Server │  │ MCP Server │  │ MCP Server  │
        │ (stdio)    │  │ (SSE)      │  │ (custom)    │
        └───────────┘  └───────────┘  └─────────────┘
```

#### 3.3 Key Components

**Component 1: Server Registry (Week 4)**

A panel to manage MCP server configurations. Each config stores:

```typescript
interface MCPServerConfig {
  id: string;
  name: string;
  description: string;
  transport: 'stdio' | 'sse';
  // stdio transport
  command?: string;        // e.g., "npx", "python"
  args?: string[];         // e.g., ["-y", "mcp-server-filesystem", "/tmp"]
  // SSE transport
  url?: string;            // e.g., "http://localhost:3001/sse"
  headers?: Record<string, string>;
  // Common
  env?: Record<string, string>;
  status: 'disconnected' | 'connecting' | 'connected' | 'error';
  lastConnected?: Date;
}
```

The registry will persist configs in localStorage (web) and support import/export as JSON files.

**Component 2: Tool Discovery (Week 5)**

After connecting to a server, the system sends `tools/list` and renders results:

```typescript
// MCP tools/list response
interface MCPToolsListResult {
  tools: Array<{
    name: string;
    description: string;
    inputSchema: {
      type: 'object';
      properties: Record<string, JSONSchema>;
      required?: string[];
    };
  }>;
}
```

The UI will render each tool as an expandable card with:
- Tool name and description
- Parameter table derived from `inputSchema.properties`
- Required vs. optional field indicators
- JSON Schema type badges (string, number, boolean, array, object)

**Component 3: Tool Invocation (Week 6)**

When a user selects a tool, a dynamic form is generated from `inputSchema`:

- Text fields for string params
- Number inputs for numeric params
- Boolean toggles
- JSON editors for nested objects/arrays
- Validation based on schema constraints (minLength, enum, pattern)

The invocation sends `tools/call` via JSON-RPC:

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "tools/call",
  "params": {
    "name": "read_file",
    "arguments": {"path": "/etc/hosts"}
  }
}
```

**Component 4: Response Inspector (Week 7)**

MCP tool responses have a structured format:

```json
{
  "content": [
    {"type": "text", "text": "File contents here..."},
    {"type": "image", "data": "base64...", "mimeType": "image/png"}
  ],
  "isError": false
}
```

The inspector will render each content block appropriately:
- `text` → Markdown renderer with syntax highlighting
- `image` → Inline image display with zoom
- `resource` → Linked resource viewer
- Error responses → Red-themed error display with trace details

**Component 5: Message Log (Week 8 & 10)**

A chronological timeline showing all JSON-RPC messages between client and server:

| Timestamp | Direction | Method | Status |
|-----------|-----------|--------|--------|
| 14:30:01 | → Client | initialize | ✅ |
| 14:30:01 | ← Server | initialize result | ✅ |
| 14:30:05 | → Client | tools/list | ✅ |
| 14:30:05 | ← Server | tools/list result | ✅ |
| 14:30:10 | → Client | tools/call (read_file) | ❌ |

Each row is clickable to show the full JSON-RPC message body.

**Component 6: Code Generation (Week 11)**

Generate integration code for MCP clients in Python and TypeScript:

**Python template:**
```python
from mcp import ClientSession, StdioServerParameters
from mcp.client.stdio import stdio_client

async def main():
    server_params = StdioServerParameters(
        command="{{command}}",
        args={{args}},
    )
    async with stdio_client(server_params) as (read, write):
        async with ClientSession(read, write) as session:
            await session.initialize()
            result = await session.call_tool("{{tool_name}}", arguments={{arguments}})
            print(result)
```

**TypeScript template:**
```typescript
import { Client } from "@modelcontextprotocol/sdk/client/index.js";
import { StdioClientTransport } from "@modelcontextprotocol/sdk/client/stdio.js";

const transport = new StdioClientTransport({
  command: "{{command}}",
  args: {{args}},
});

const client = new Client({ name: "api-dash-client", version: "1.0.0" });
await client.connect(transport);
const result = await client.callTool({ name: "{{tool_name}}", arguments: {{arguments}} });
console.log(result);
```

#### 3.4 Integration with API Dash

The MCP testing module will integrate with API Dash's existing architecture:

- **Navigation**: New "MCP" tab in the left sidebar navigation rail (alongside Requests, Variables, History, Logs)
- **Design System**: Uses `apidash_design_system` tokens for consistent Material 3 theming
- **State Management**: React state management (Context + useReducer or Zustand), following patterns similar to Riverpod in the Flutter app
- **Code Gen**: Extends the existing codegen module with MCP-specific templates
- **Data Persistence**: Server configs and test results stored using the same patterns as the existing Hive-based storage

#### 3.5 Technologies

| Technology | Purpose |
|-----------|---------|
| React 18 | Frontend UI framework |
| TypeScript | Type-safe development |
| Node.js | Backend for MCP server process management |
| `@modelcontextprotocol/sdk` | Official MCP TypeScript SDK |
| Vite | Build tool |
| Material UI / Custom components | UI components aligned with `apidash_design_system` |

**4. Weekly Timeline (175 hours — Medium project)**

| Week | Phase | Deliverables | Hours |
|------|-------|-------------|-------|
| **1** | Community Bonding | Deep-dive into MCP spec, study API Dash codebase, discuss architecture with mentors | 10 |
| **2** | Community Bonding | Set up React/Node/TS project scaffold, configure build pipeline | 10 |
| **3** | Community Bonding | Design complete data models, create Figma/wireframe mockups for all screens | 10 |
| **4** | Coding Phase 1 | **Server Registry**: CRUD panel for MCP server configs, localStorage persistence | 15 |
| **5** | Coding Phase 1 | **Tool Discovery**: Connect to servers, send `tools/list`, render tool cards with schema visualization | 15 |
| **6** | Coding Phase 1 | **Tool Invocation**: Dynamic form generation from JSON Schema, parameter validation, `tools/call` | 15 |
| **7** | Coding Phase 1 | **Response Inspector**: Structured content rendering (text/image/resource), error display | 12 |
| **8** | Coding Phase 1 | **Unit & integration tests**, bug fixes, prepare midterm evaluation demo | 13 |
| — | **Midterm** | ✅ Working: Server registry + tool discovery + tool invocation + response inspector | — |
| **9** | Coding Phase 2 | **MCP Client Testing**: Act as server, test incoming client connections | 15 |
| **10** | Coding Phase 2 | **Message Log**: Real-time JSON-RPC timeline with message detail view | 12 |
| **11** | Coding Phase 2 | **Code Generation**: Python & TypeScript MCP client templates | 12 |
| **12** | Coding Phase 2 | **Polish**: Dark mode, accessibility audit, keyboard shortcuts, responsive layout | 10 |
| **13** | Coding Phase 2 | **Documentation**: User guide, developer guide, API reference for the MCP module | 8 |
| **14** | Final | Final submission, demo video recording, code cleanup, final evaluation report | 8 |

**Total: 175 hours**

**Midterm deliverables:**
- Server Registry with full CRUD operations
- Connection manager for stdio and SSE transports
- Tool Discovery with schema visualization
- Tool Invocation with dynamic forms
- Response Inspector with structured rendering
- Passing test suite

**Final deliverables:**
- Complete MCP testing suite as described above
- Message Log timeline for debugging
- Code generation for Python and TypeScript
- Polished UI with dark mode and accessibility
- Comprehensive documentation
- Demo video
