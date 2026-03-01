### Initial Idea Submission
  
Full Name: Arman Asif Rayma  | 
University name: Amity University Online | 
Program enrolled (Degree) : Bachelor of Computer Applications | 
Year: 2nd | 
Expected graduation date: 2028 

Project Title: Model Context Protocol (MCP) Support for API Dash

Relevant issues: [#1054](https://github.com/foss42/apidash/discussions/1054)

Idea description:
 Integrating the **Model Context Protocol (MCP)** into API Dash 

**Project Requirements & Packages:**
- **Language Stack:** Dart (Native integration sharing API Dash internal classes for direct state access).
- **Core SDKs:** Standard JSON-RPC 2.0 implementation in Dart (`json_rpc_2`) following the [MCP Specification](https://modelcontextprotocol.io).
- **API Dash Integration:** Hive CE for direct data access and Riverpod/Service integration for synchronized application state.


---

**Refined Implementation Plan (Native Dart Approach):**

Based on our architectural evaluation, we will proceed with a native **Model Context Protocol (MCP)** implementation to ensure maximum performance and seamless integration with API Dash's internal state.

### Proposed File Structure
```text
apidash/
├── bin/
│   └── mcp_server.dart               # [NEW] Native MCP Server Entry Point
├── lib/
│   ├── dashbot/
│   │   ├── providers/
│   │   │   ├── chat_viewmodel.dart   # [MODIFY] Update for MCP Tool calls
│   │   │   └── service_providers.dart# [MODIFY] Register MCP Client service
│   │   └── services/
│   │       ├── agent/
│   │       │   └── prompt_builder.dart# [MODIFY] Inject MCP Resource context
│   │       └── mcp/                   # [NEW] MCP Client Layer
│   │           ├── models.dart       # Protocols & Message types
│   │           ├── transport.dart    # stdio/SSE Interface
│   │           └── mcp_client.dart   # Client Implementation
│   └── mcp_server/                   # [NEW] MCP Server Logic
│       ├── handlers/
│       │   ├── resource_handler.dart # Resource mapping (Hive)
│       │   └── tool_handler.dart     # Tool mapping (Core actions)
│       └── server_core.dart          # Server implementation
```

### Key Components & Connectivity:

1.  **Native MCP Server (Host):** A standalone Dart executable that exposes API Dash's internal state (Hive boxes) as MCP Resources (e.g., `apidash://current-request`) and core actions as MCP Tools.
2.  **Dashbot Integration (Client):** Dashbot's chat engine will be updated to act as an MCP Client, enabling it to discover tools and fetch context-rich resources dynamically.
3.  **External Client Support:** The native server will allow external IDEs (VS Code via *Cline* or *Roo Code*) and AI clients (Claude Desktop) to connect via the standardized `stdio` transport.

### External Client Configuration Example (Claude Desktop):
```json
"mcpServers": {
  "apidash": {
    "command": "path/to/apidash_mcp_server",
    "args": []
  }
}
```

**Testing & Verification Plan:**
1.  **Unit Testing:** Automated suites for JSON-RPC 2.0 serialization/deserialization logic using the `test` package.
2.  **MCP Inspector:** Using the official `@modelcontextprotocol/inspector` to manually verify Tool/Resource responses from `mcp_server.dart`.
3.  **E2E Integration:** Verifying Dashbot's ability to trigger "Debug" or "Explain" actions by fetching context via MCP.

---

**Original System Design Evaluation:**
*The following sections outline the initial exploration and comparison between native and standalone approaches.*

**System Design Approaches:**
A robust system architecture demands a secure, decoupled MCP Server that interfaces with the API Dash core. **Two approaches** will be evaluated during the project development:

**Approach 2: Standalone TypeScript Server**
- **Server Component:** A Node.js-based MCP Server leveraging the official `@modelcontextprotocol/sdk`.
- **Client Hooks:** API Dash acts as the core provider. The TS MCP server reads exported API Dash workspaces or connects via a local HTTP socket if the application is actively running.
- **Development Phases:** 
  1. **Phase 1: Bootstrapping Node Integration:** Initialize the project using `npx @modelcontextprotocol/create-server` and define strict TypeScript schemas for the tools and resources.
  2. **Phase 2: Local File Access Setup:** Create listeners (`src/resources/`) capable of safely reading and parsing API Dash exported `.json` or `.har` workplace definitions.
  3. **Phase 3: Building Execution Handlers:** Develop Node-based tool execution handlers in `src/tools/` using packages like `axios` or `node-fetch` to run specific pre-configured workspace endpoints interactively.
  4. **Phase 4: CLI & IDE Hooks:** Bundle the server configuration to easily integrate with established AI IDEs (Claude Desktop/Cursor) so users can start prompting their APIs seamlessly.

Both approaches will utilize JSON-RPC 2.0 over `stdio`/`SSE` for local AI clients (like Claude Desktop or Cursor) to securely invoke tools.

**Testing & Verification:**
Immediately following the development phases, rigorous testing is essential to ensure the server behaves predictably.
1. **Unit & Integration Testing:** We will develop automated test suites (using `test` for Dart or `jest` for TypeScript) to validate context parsing and tool execution logic completely independently of AI callers.
2. **MCP Inspector Verification:** The official `@modelcontextprotocol/inspector` will act as our primary testing interface. This tool provides a local web UI to simulate LLM connections, allowing us to manually invoke our API Dash "Tools" and assert that the correct JSON-RPC responses (and error codes) are returned perfectly before hooking it into real AI clients.
**Deployment Options:**
We will evaluate two primary distribution methods for users running the MCP Server locally:

**1. Direct Execution**
The MCP server can run directly on the host machine as a lightweight background service.
- **Node.js/TypeScript Option:** Distributed via `npm` (e.g. `npx @apidash/mcp-server`) or pre-packaged binaries using tools like `pkg`.
- **Dart Option:** Compiled into standalone native executables for Windows, macOS, and Linux that require zero end-user dependencies, making it blazing fast and lightweight.
- **Why this approach?** It perfectly matches API Dash's existing ethos of being a fast, native client without heavy middleware requirements.

**2. Docker Sandboxing**
The MCP Server will optionally be built and distributed using Docker, pointing to the Docker Hub registry. 
- **No Dependency Hell:** Users and developers don't need to worry if they have the right version of Typescript, Node, or Dart installed on their computer. The image bundles exactly what is required.
- **Security:** The server runs in a sandbox. It strictly isolates the MCP Server from the host operating system, preventing AI interactions from accessing sensitive host details.
- **Portability:** Containerization guarantees that the MCP Server will run flawlessly on any OS without complicated environment setup configurations.

**Technical Details & Challenges:**
- **Storage Access:** Since API Dash's primary storage is `hive` (binary Dart format), reading native workspace data directly from Node.js is complex. Setting up a local bridge in API Dash or using Docker volumes to access exported workspaces will be necessary. If using the Native Dart Server approach, this challenge is completely mitigated.
- **Protocol:** Handling JSON-RPC 2.0 communication efficiently over `stdio` or `SSE`.
- **State Management:** Integrating the MCP service smoothly with API Dash's existing state management (Riverpod).
- **Process Management:** Ensuring cross-platform compatibility when launching or managing the MCP server processes from within API Dash.
