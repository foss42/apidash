### Initial Idea Submission

Full Name: Khushal Khandelwal

University name: Swarrnim startup and innovation university

Program you are enrolled in (Degree & Major/Minor): B.Tech CSE

Year: Graduated

Expected graduation date: 2025

Project Title: MCP Testing

Relevant discussion: https://github.com/foss42/apidash/discussions/1225

Previous PR: https://github.com/foss42/apidash/pull/1173

## 1. Background:

The Model Context Protocol (MCP) enables AI agents to interact with external tools in a structured way. MCP servers expose tools that agents can call with arguments and receive results from. As MCP adoption grows, developers are building more MCP servers and tools. However, the developer workflow for testing MCP tools is still very manual.

Developers often rely on:
- running a full agent environment
- writing custom scripts
- debugging through logs

According to the MCP architecture documentation, tool calls are part of a larger interaction loop involving prompts, reasoning, and tool execution. This makes debugging more complex compared to traditional APIs.

API Dash already provides strong tooling for inspecting APIs. Extending it with MCP support would help developers debug and test MCP servers more effectively.

## 2. Developer Feedback (Survey Insights):

To better understand developer needs, I created a short survey and shared it within developer communities working with MCP.

The responses highlighted several recurring challenges.

#### 1. Difficulty Testing Tools Independently

Some developers mentioned that testing tools often requires running a full agent environment.

**Example**: “A simple way to test the tool's logic instantly.”

This suggests developers want the ability to test tools directly without running an agent loop.

#### 2. Errors Are Hard to Debug

Another challenge mentioned was debugging issues related to tool arguments and data formats.

**Example**: “It is hard to fix errors when the data format is incorrect.”

This indicates a need for better argument validation and structured response inspection.

#### 3. Lack of Dedicated Testing Workflows

Developers also mentioned difficulties around testing workflows and understanding tool execution behavior.

**Example**: “Testing workflows.”

This suggests that a visual debugging interface could significantly improve the developer experience.

### Useful Feature Requests

Developers also shared features they would find valuable:

**Example**:
- attaching to an existing MCP server
- instantly testing tool logic
- inspecting context size of tools

These insights helped shape the proposed features of the tool.

## 3. Problem Statement:

Developers building MCP servers currently lack a dedicated environment for testing and debugging MCP tools.

Common issues include:

#### 1. Tool testing requires running full agents

Developers often need to run an entire agent system just to test a single tool.

#### 2. Limited visibility into tool execution

It is difficult to clearly see:
- tool arguments
- execution time
- responses
- errors

These gaps make development slower and debugging harder.

## 4. Proposed Solution:

The goal is to create a simple environment where developers can:
- connect to an MCP server
- discover available tools
- manually invoke tools
- inspect the tool execution lifecycle

This allows developers to test MCP tools without needing to run a full agent system. The tool will focus on testing, debugging, and visibility, rather than trying to replace the agent runtime.

## 5. Key Features:

#### 1. MCP Server Connection

Users will be able to connect mcp servers. Once connected, the tool will fetch available tools and their schemas.

#### 2. Tool Explorer

The UI will display available MCP tools and their metadata.

Example information shown:
- tool name
- description
- parameters
- argument schema

This allows developers to easily understand the capabilities exposed by the MCP server.

#### 3. Tool Invocation Tester

Developers can manually invoke a tool by providing arguments.

Arguments can be entered using:
- generated form based on schema
- JSON editor

After invocation the tool will display:
- response data
- status
- execution time
- error messages if any

This helps developers quickly test tool logic.

#### 4. Tool Execution Inspector

Each tool invocation will show a simple lifecycle view:

```
Tool Call
 ↓
Arguments
 ↓
Execution
 ↓
Response
```

This makes it easier to understand what happened during the call.

#### 5. Structured Response Viewer

Responses will be displayed in two modes:

- formatted view
- raw JSON

This makes it easier to inspect complex outputs.

#### 6. Logging Support

Each request will be logged with basic information such as:

- tool name
- arguments
- response
- execution time
- status

This helps developers track and debug issues.

#### Additional
Possible additional enhancements include:

- simulation of agent reasoning flows
- performance metrics for tools
- exporting logs for debugging
- automated test scenarios for tools

These features can be explored after the initial MCP testing support is implemented.

## 6. Expected Impact

This feature will make it much easier for developers to build and debug MCP servers.

Benefits include:
- faster tool testing
- improved debugging visibility
- easier exploration of MCP capabilities
- better developer experience

## 7. Key Insights 

These are the insights i gained from researching MCP. They helped shape the proposed features of the tool.

#### 1. MCP Systems Are Hard to Debug Because They Are Non-Deterministic

One of the biggest insights from MCP monitoring research is that agent behavior is unpredictable. The same prompt can trigger different tool chains depending on the LLM reasoning process.

This means debugging MCP is fundamentally different from debugging REST APIs.

**Feature:** Is to show Execution Timeline (full execution chain). This is something most tools do not visualize today.
```
User Prompt
↓
Agent reasoning step
↓
Tool call
↓
Arguments
↓
Execution time
↓
Result
↓
Agent response
```

#### 2. MCP Requires Multi-Layer Observability

Monitoring MCP systems requires visibility across three layers simultaneously:
1. Transport Layer 
2. Tool Execution Layer 
3. Agent Outcome Layer

**Feature:** An MCP testing tool could include a 3-layer observability panel. This would be extremely valuable.
```
Transport Layer
✓ Connection
✓ Protocol messages

Tool Layer
✓ tool calls
✓ latency
✓ errors

Agent Layer
✓ reasoning
✓ tool selection
✓ final output
```

#### 3. Tool Calls Should Be Treated Like Microservices

Each MCP tool is effectively its own microservice with its own:
- latency
- reliability
- throughput

Monitoring best practices include tracking:
- latency
- traffic
- errors
- saturation

**Feature:** An Tool Performance Panel. This helps developers spot slow tools immediately.
```
weather_tool
Latency: 210ms
Calls: 15
Errors: 1
Success Rate: 93%

search_tool
Latency: 1.2s
Calls: 8
Errors: 0
Success Rate: 100%
```

#### 4. Structured Logging is Critical for MCP Debugging

MCP debugging requires structured logs capturing:
- tool invocation
- parameters
- responses
- timestamps
- trace IDs

**Feature:** Log Explorer UI with filtering:
```
{
  trace_id: "...",
  tool: "weather_tool",
  args: { city: "NYC" },
  latency: 220ms,
  status: success
}
```
```
filter: errors
filter: tool=weather_tool
filter: latency > 1s
```

#### 5.MCP Tool Discovery is Dynamic

Unlike REST APIs, MCP servers dynamically expose capabilities. Clients can discover tools via the protocol itself.

This means testing tools must support:
- dynamic tool discovery
- schema visualization
- automatic form generation

**Feature:** A Tool Explorer
```
Connected Server
├ weather_tool
│  ├ city: string
│  ├ units: string
│
├ search_docs
│  ├ query: string
│  ├ top_k: number
```

#### 6. Security Is a Big Gap in MCP Tools

Research shows MCP systems introduce new attack surfaces, such as:
- tool injection
- malicious tool calls
- prompt injection inside tool arguments

**Feature:** Security Debugging Panel

```
⚠ Suspicious tool call
⚠ repeated failed calls
⚠ abnormal tool arguments
```

#### 7. MCP Needs Testing Without Running a Full Agent

Today many developers must run LLM + agent framework + MCP server + tools. Just to test one tool.

**Feature:** Manual tool invocation. This drastically speeds up development.
```
Tool: weather_tool
Args: { city: "NYC" }
```

## 8. System Architecture:

The system will include three main components.

```
User
 ↓
MCP Testing Tool UI
 ↓
MCP Client Service (Internal)
 ↓
MCP Server (External / Subprocess)
```

#### 1. MCP Testing Tool UI

The UI provides the interface for developers to interact with MCP servers.

#### 2. MCP Client Service

The MCP Client Service is responsible for communicating with the MCP server using the MCP protocol.

#### 3. MCP Server

The MCP server is an external component that exposes tools through the MCP protocol.

### Why This Architecture

Separating the UI and MCP client logic provides several benefits:

- keeps protocol handling isolated from the UI
- makes it easier to support different transports (stdio / SSE)
- allows better logging and debugging of tool calls

This design also aligns with the client–server architecture described in the MCP documentation.

## 9. References

- https://modelcontextprotocol.io/docs/learn/architecture
- https://www.mindstudio.ai/blog/what-are-mcp-servers
- https://www.speakeasy.com/mcp/monitoring-mcp-servers
- https://zeo.org/resources/blog/mcp-server-observability-monitoring-testing-performance-metrics
- https://medium.com/%40yash.p_60148/top-tools-for-real-time-mcp-server-monitoring-and-analytics-dbae42da5aab
- https://github.com/IBM/mcp-context-forge/issues/301
- https://tally.so/r/gDAN6J - Developer Feedback Survey. Collected responses from developers working with MCP tools.

## 10. POC

[POC_MCP_Testing_Tool_Khushal.mp4](images/POC_MCP_Testing_Tool_Khushal.mp4)

