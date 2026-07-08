### Initial Idea Submission

Full Name: Vinícius Melo Almeida
University name: Universidade Federal da Bahia (UFBA)
Program you are enrolled in (Degree & Major/Minor): Bachelor's in Information Systems (Sistemas de Informação)
Year: 4th year
Expected graduation date: December 2029

Project Title: MCP Testing — A Comprehensive Test Harness for MCP Servers and Clients
Relevant issues: [GSoC 2026: List of Ideas - Discussion #1054](https://github.com/foss42/apidash/discussions/1054) (Idea #1 — MCP Testing)

Idea description:

## Problem

The Model Context Protocol (MCP) is becoming the standard interface for AI agent communication, yet the developer tooling ecosystem lacks standardized ways to validate, test, and debug MCP servers and clients. Currently, developers building MCP integrations face several pain points:

- **No schema validation tooling** — There's no way to automatically verify that an MCP server's tool definitions conform to the spec (missing required fields, malformed JSON Schema for parameters, invalid transport configurations).
- **Manual testing workflows** — Developers must manually craft JSON-RPC requests to test tool calls, inspect responses by hand, and mentally track whether the server handles edge cases (malformed input, missing parameters, timeouts).
- **No conformance testing** — There's no standard suite to verify that an MCP server correctly implements the protocol lifecycle: initialization handshake, tool discovery (`tools/list`), tool execution (`tools/call`), error responses, and transport negotiation (stdio, SSE, Streamable HTTP).
- **No client-side testing support** — Applications consuming MCP servers have no mock infrastructure for deterministic testing without depending on live server availability.

## Proposed Approach

I propose building four interconnected components within API Dash:

### 1. Schema Validation Layer

A validation engine that parses MCP server manifests and tool definitions, checking:

- Tool names, descriptions, and `inputSchema` conform to the MCP spec
- JSON Schema types for parameters are valid and complete
- Required vs. optional parameters are properly declared
- Transport configuration (stdio command/args, SSE/HTTP endpoints) is well-formed

This can be invoked both programmatically (as a library) and through the API Dash UI, showing validation results inline with clear error messages and fix suggestions.

### 2. Interactive Test Runner (UI)

A React-based interface integrated into API Dash that lets developers:

- Connect to any MCP server (stdio, SSE, or Streamable HTTP transport)
- Browse discovered tools with their schemas rendered in a readable format
- Execute tool calls with custom parameters via a form auto-generated from `inputSchema`
- Inspect structured responses (JSON, streaming chunks) with syntax highlighting
- Compare expected vs. actual responses side-by-side
- Save and replay test scenarios

### 3. Conformance Test Suite

A pre-built set of test cases (Python) that verify MCP spec compliance:

- **Transport tests:** stdio process lifecycle, SSE connection management, Streamable HTTP request/response
- **Protocol tests:** `initialize` handshake with capability negotiation, `tools/list` discovery, `tools/call` execution, proper JSON-RPC error codes
- **Edge case tests:** malformed requests, unknown tool names, oversized payloads, concurrent requests, connection drops and reconnection
- **Auth flow tests:** OAuth 2.1 authorization when required by the server

The suite outputs a conformance report showing pass/fail per test category, making it easy to identify which parts of the spec a server doesn't fully support.

### 4. Mock MCP Server

A configurable mock server for client-side testing:

- Define tool schemas and fixed/dynamic responses via a simple configuration file (JSON/YAML)
- Supports all three transports (stdio, SSE, Streamable HTTP)
- Deterministic responses for reproducible test runs
- Configurable failure modes (latency injection, error responses, partial results) for resilience testing
- Can be used both standalone and within API Dash's test runner

## Architecture Overview

```
┌─────────────────────────────────────────────────┐
│                  API Dash UI                     │
│  ┌──────────────┐  ┌─────────────────────────┐  │
│  │ Schema       │  │ Interactive Test Runner  │  │
│  │ Validator    │  │ (connect, execute, view) │  │
│  └──────┬───────┘  └────────────┬────────────┘  │
│         │                       │                │
│         ▼                       ▼                │
│  ┌──────────────────────────────────────────┐   │
│  │         MCP Client Library               │   │
│  │   (stdio / SSE / Streamable HTTP)        │   │
│  └──────────────────┬───────────────────────┘   │
└─────────────────────┼───────────────────────────┘
                      │
          ┌───────────┼───────────┐
          ▼           ▼           ▼
   ┌──────────┐ ┌──────────┐ ┌──────────┐
   │ Real MCP │ │ Mock MCP │ │Conformance│
   │ Server   │ │ Server   │ │Test Suite │
   └──────────┘ └──────────┘ └──────────┘
```

## Why Me

I have direct production experience with MCP architecture that goes beyond academic knowledge:

- **Production AI agents:** Built systems using the Anthropic API with tool calling, including a Telegram bot that captures and analyzes content using Claude, and multi-agent architectures with specialized tool catalogs.
- **API integration at scale:** As co-founder and solutions architect at a tech company, I've designed and built API integrations for ERP systems, handling real-world concerns like auth flows, rate limiting, error handling, and schema validation.
- **Testing framework design:** I've been conceptualizing and building a behavior testing framework for AI agents — essentially "Playwright for AI agents" — which directly informs the test runner and conformance suite design.
- **Full-stack TypeScript/Python:** The exact stack required for this project (React + TypeScript for UI, Python for conformance suite, Node.js for test runner) matches my daily working stack.

## Future Extensions

The four core components are designed to be extensible. Natural next steps after the GSoC period:

- **Security profiling:** Extend the schema validator to flag destructive operations (file deletion, database writes), detect tool poisoning patterns, and check for injection vulnerabilities in tool parameters — building on the validation infrastructure already in place.
- **MCP Apps testing:** Add support for validating MCP Apps (interactive UI components) including `ui/initialize` handshake verification, `hostContext` CSS injection, and iframe sandbox compliance.
- **CI/CD integration:** Export conformance test results in standard formats (JUnit XML, TAP) for pipeline integration, and package the test suite as a standalone CLI tool.

## Tech Stack

- **Frontend (Test Runner UI):** React + TypeScript
- **Schema Validator:** TypeScript (shared with frontend, also usable as standalone CLI)
- **Conformance Test Suite:** Python (leverages existing MCP Python SDK)
- **Mock MCP Server:** Node.js/TypeScript (supports stdio, SSE, Streamable HTTP)
