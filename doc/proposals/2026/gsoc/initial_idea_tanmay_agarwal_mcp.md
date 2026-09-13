# Initial Idea: MCP Testing — Building Create & Test Capabilities for MCP Servers and Clients in API Dash

## 1. Contributor Information
- **Full Name**: Tanmay Agarwal
- **GitHub username**: agarwal-tanmay-work
- **Email**: agarwal.tanmay.work@gmail.com
- **Discord username**: tanmay_89797
- **Country & Timezone**: India, IST (UTC+5:30)
- **Educational background**: Masters' Union, Data Science and Artificial Intelligence (1st Year, Expected 2029)
- **Links to past contributions**: https://github.com/agarwal-tanmay-work

## 2. Idea Overview
- **Chosen Idea**: Idea 1 — MCP Testing
- **Elevator Pitch**: The Model Context Protocol (MCP) lacks a dedicated, visual testing client. This project integrates MCP testing directly into API Dash, allowing developers to connect to MCP servers (via stdio/SSE), visually discover tools mapped from JSON Schema, and invoke them with automatic parameter forms.
- **Why it is important**: It positions API Dash as the premier tool for the rapidly growing Agentic AI ecosystem, giving developers a Postman-like visual environment tailored specifically for MCP tool debugging.

## 3. Problem Statement
The MCP specification defines how AI accesses external tools, but tooling for developers building MCP servers is currently restricted to CLI scripts and manual raw JSON-RPC over stdio. There is no open-source, user-friendly UI to debug tool calls, view schemas, handle SSE streaming connections, and accurately view tool response content (text, imagery, and resources).

## 4. Proposed Solution
I will build an MCP Testing workspace in API Dash. This requires a strong bridging layer between API Dash's Dart/Flutter frontend and a Node.js/TypeScript-powered backend (leveraging `@modelcontextprotocol/sdk`). The system will provide UI to:
- Register stdio + SSE servers
- Introspect & list exposed tools/resources
- Dynamically build input forms from JSON schemas
- Inspect visual JSON-RPC timelines

## 5. Technical Architecture
1. **Frontend (React/TypeScript UI)**: Hosted inside API Dash's web surface / embedded webview, featuring Server Registry, Tool Explorer, and Response Inspector panels.
2. **Backend (Node.js Proxy)**: Spawns child processes for `stdio` MCP servers or initiates HTTP/SSE requests. Exposes a unified local WebSocket or REST API to the frontend.
3. **Integration**: Plugs into API Dash's existing design system and storage patterns.

## 6. Deliverables
**Core (Must-have)**:
- Server Configuration Registry (CRUD for stdio/SSE configs)
- Tool Discovery UI (Schema visualization)
- Dynamic Parameter Input Forms
- Response Inspector (Text & Image representation)

**Stretch Goals (Nice-to-have)**:
- Live JSON-RPC Message Log timeline
- Python & TypeScript integration code generation for the tested tools

## 7. Timeline
- **Bonding (Weeks 1-3)**: Prototypes, architecture lock-in, UI mockups.
- **Phase 1 (Weeks 4-7)**: Server registry, Tool Discovery schema parsing, and dynamic form generation. *(Midterm: Working tool invocation)*
- **Phase 2 (Weeks 8-12)**: Response inspector styling, message logs, and codegen.
- **Final (Weeks 13-14)**: Polish, robust local testing, documentation, and video demo.

## 8. Prior Work
- Extensive review of the official MCP specification.
- Submitted Bug Fix PR #1591 (Removing `flutter` SDK dependencies from pure-Dart CLI portions of `packages/genai` to prove structural capabilities).

## 9. Skills & Why Me
I possess a firm grasp of both TypeScript (for the MCP SDK layer) and architectural design. My self-initiated contributions to existing production codebases of YC-backed startups show my ability to jump into a huge ecosystem, understand the standard practices, and deliver clean solutions — a perfect match for GSoC with API Dash.
