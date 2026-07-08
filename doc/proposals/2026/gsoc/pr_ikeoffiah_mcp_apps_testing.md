# Add GSoC 2026 Proposal: MCPApps Tester

This PR introduces a new GSoC 2026 project proposal for **MCPApps Tester** (`idea_ikeoffiah_mcp_apps_testing.md`). 

The proposal aims to create a dedicated testing and debugging environment for MCP Apps, filling a major tooling gap for developers building interactive UI extensions for MCP servers. While current tools focus on fundamental backend primitives (tools, resources), there is no dedicated sandbox for validating the rich UI/iframe layer of MCP Apps and its opaque `postMessage` JSON-RPC communication.

## What is proposed?
The **MCPApps Tester** will be built as a standalone suite capable of loading, rendering, and thoroughly testing MCP Apps. It will include:
1. **MCP App Discovery & Loader**: Render any MCP App in a spec-compliant sandbox.
2. **Simulated Host & Handshake**: Emulate the `ui/initialize` sequence.
3. **Bidirectional Message Inspector**: Transparent logging of the JSON-RPC traffic over `postMessage`.
4. **Host Capability Mocking**: Test UI resilience by mocking host responses (e.g. `open_link`).
5. **UI-to-Backend Tracing**: Follow `tools/call` events from UI click all the way to the backend MCP Server.
6. **Automated Protocol Compliance**: Programmatic testing of correct iframe implementation.

---

## Prototype / Proof of Concept

To validate the feasibility of this architecture, I built a functional prototype demo app (`host-sandbox-ui`).

### What was built:
- **React Frontend (Sandbox Loader)**: Implemented an iframe container capable of rendering a sandboxed UI securely.
- **Frontend Bridging Logic**: Built a mechanism to intercept `postMessage` requests, respond locally to standard `ui/initialize` handshakes, and route backend-bound traffic.
- **Message Inspector UI**: Created a React component to visualize and debug the JSON-RPC stream between the iframe and the host in real-time.
- **Node.js + Express Backend Proxy**: Initialized a backend using the official `@modelcontextprotocol/sdk`. It connects to a target MCP server and acts as a generic bridge, proxying JSON-RPC requests from the frontend sandbox to the actual server capabilities.

This prototype successfully demonstrated the ability to intercept, inspect, and proxy interactive MCP app data accurately securely.

---

## Demo Video

> **[Insert Demo Video Here]** 
*This video demonstrates the prototype connecting to an MCP Server, loading the sandboxed UI, and the inspector tracing live `postMessage` JSON-RPC traffic.*
