### Initial Idea Submission

Full Name: Khushal Khandelwal

University name: Swarrnim startup and innovation university

Program you are enrolled in (Degree & Major/Minor): B.Tech CSE

Year: Graduated

Expected graduation date: 2025

Project Title: MCP Testing

Relevant issues: https://github.com/foss42/apidash/discussions/1054

## Idea description:

Model Context Protocol (MCP) is a protocol for communication between AI agents and their environment. It allows agents to send and receive messages in a structured format, enabling them to interact with various tools and services. However, debugging and testing MCP servers and clients can be challenging due to the complexity of the protocol and the lack of specialized tools.

MCP Dash is an interactive debugging, testing, and observability tool designed specifically for MCP servers and clients. It provides a user-friendly interface for developers to monitor and analyze the communication between mcp and their environment. With MCP Dash, developers can easily identify issues, test different scenarios, and gain insights into the behavior of their MCP implementations.

### Features:

- Clear request–response inspector.
- See tool invocation lifecycle.
- Structured log tracing.

### Flow:

1. Users connect to the MCP server (url/local).
2. Discover available tools and their schemas.
3. Send test prompt to the MCP server and observe tool calls and their responses.
4. Send manual tool invocation to observe specific tool and its response.

```
Connect to MCP Server
 ↓
User Prompt
 ↓
Agent Reasoning Step
 ↓
Tool Call Initiated
 ↓
Tool Arguments
 ↓
Tool Execution
 ↓
Tool Result
 ↓
Agent Final Response
```

Example:

```
● User Prompt
   "Todys new york climate"
● Agent Reasoning
   "Calling weather_tool"
● Tool Call: weather_tool
   Args: { city: "new_york" }
● Tool Response
   { results: [...] }
● Final Output
   "Todays new york climate is..."
```

### Data Flow:

```
Connect to MCP Server
 ↓
Fetch Tool Metadata
 ↓
User selects tool
 ↓
Generate request form
 ↓
Send request via proxy
 ↓
Capture full lifecycle
 ↓
Render:
   - Structured/Raw JSON
   - Status
   - Timeline
   - Logs
```

### Architecture:

```
┌────────────────────────┐
│ User                   │
└────────────┬───────────┘
             │
             ▼
┌────────────────────────┐
│ MCP Testing UI         │
│ (Next.js + React)      │
└────────────┬───────────┘
             │
             ▼
┌────────────────────────┐
│ MCP Proxy Layer        │   
│ (Node.js + WS/HTTP)    │
└────────────┬───────────┘
             │
             ▼
┌────────────────────────┐
│ MCP Server             │ 
└────────────────────────┘
```

#### MCP Proxy Layer
Instead of directly calling MCP server APIs, all requests will be routed through a proxy layer. This allows us to capture the full lifecycle of tool calls, including request and response data, status, and timing information.

### Tech Stack:

- Frontend: Next.js, Tailwind CSS (shadcn ui), Monaco Editor (JSON editor)
- State Management: Zustand/Redux
- Backend: Node.js, WebSockets/HTTP
- Database: SQLite/PostgreSQL (for logging and analytics)
- Testing: Jest, React Testing Library

### Mockup:

![img_1.png](images/studio_mockup.png)

#### Note: This is an initial idea submission and is subject to change based on feedback and further research.


