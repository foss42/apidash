### Initial Idea Submission

Full Name: Shreyansh Jain

University name: SRM IST

Program you are enrolled in (Degree & Major/Minor): BTech Computer Science Major

Year: Third Year

Expected graduation date: 2027

Project Title: CLI & MCP Support

Relevant issues: https://github.com/foss42/apidash/discussions/1054

Idea description:

## Problem

API Dash is a powerful, AI-powered, open-source, cross-platform API Client built with Flutter. However, it currently only works as a GUI application — developers who prefer terminal workflows, CI/CD pipelines, or AI agent integrations have no way to use API Dash's core capabilities from the command line or through AI-native platforms.

Additionally, with the rise of the Model Context Protocol (MCP) — the emerging standard for AI agents to interact with tools and data — there is no way for agent interfaces like VS Code, Claude Desktop, or Cursor to leverage API Dash's features.

## Proposed Solution

This project has two complementary parts:

### Part 1: CLI Tool (`apidash-cli`)

Create a command-line interface that exposes API Dash's core capabilities via the terminal, enabling:

- **Sending HTTP requests** — `apidash send GET https://api.example.com/users`
- **Managing collections** — `apidash collection run my-tests --env production`
- **Code generation** — `apidash codegen --lang python --method POST --url https://api.example.com/data`
- **Importing/exporting** — `apidash import --format postman collection.json`
- **Response inspection** — Formatted output with status, headers, body, timing

The CLI will be implemented in **Dart** (same stack as API Dash) and will reuse existing packages like `apidash_core` for HTTP models, import/export logic, and code generation.

**Example usage:**
```bash
# Send a request
$ apidash send GET https://httpbin.org/get --header "Authorization: Bearer token123"

# Run a collection
$ apidash collection run api-tests --env staging --output json

# Generate code from a request
$ apidash codegen --method POST --url https://api.example.com/users \
  --body '{"name": "John"}' --lang python

# Import a Postman collection
$ apidash import --format postman my_collection.json
```

### Part 2: MCP Server (`apidash-mcp`)

Expose API Dash as an MCP Server so that it can be run via any agent interface that supports MCP:

**Core MCP Tools:**
- `send_request` — Send HTTP requests (GET, POST, PUT, DELETE, PATCH) with full control over headers, body, and content type, returning status, headers, body, and timing
- `test_endpoint` — Validate API behavior by testing endpoints against expected status codes and response body content
- `inspect_response` — Deep response analysis including status, timing, headers, body schema inference, and response size
- `generate_code` — Generate API integration code in multiple languages (Python, JavaScript, Dart, cURL, etc.)

**Collection & Environment Management (MCP Resources):**
- `apidash://collections` — List and manage API collections
- `apidash://environments` — Manage environment variables (dev, staging, prod)
- `apidash://history` — Access request history

**MCP Prompts:**
- `api_test_plan` — Generate comprehensive test plans covering happy paths, error handling, and edge cases
- `debug_api` — Analyze request/response pairs and suggest fixes

**End User Experience:**

Users connect the MCP server to any MCP-compatible platform:
```json
{
  "mcpServers": {
    "apidash": {
      "command": "uvx",
      "args": ["apidash-mcp"]
    }
  }
}
```

Once connected, users interact with API Dash entirely through natural language — sending requests, testing endpoints, managing collections, and generating code from within Claude Desktop, VS Code, Cursor, etc.

---

## Architecture

![CLI & MCP Support Architecture](doc/proposals/2026/gsoc/images/shreyansh_cli_mcp_support.png)

---

## Existing Work

I've already built the foundation for the MCP server as a proof-of-concept PR:
- `packages/apidash_mcp/` — Python package with FastMCP
- `send_request` tool — working HTTP request tool
- Installable as `apidash-mcp` via `uvx`

This project will expand on this MVP to build the full CLI and MCP feature set.

## Tech Stack

| Component | Technology |
|-----------|------------|
| CLI | Dart (reuses `apidash_core` package) |
| MCP Server | Python 3.10+, FastMCP |
| HTTP Client | `httpx` (async) |
| Testing | `flutter test` (CLI), `pytest` (MCP) |
| Package Distribution | Pub (CLI), PyPI (MCP) |
