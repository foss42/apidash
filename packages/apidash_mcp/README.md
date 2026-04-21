# apidash_mcp

MCP server for API Dash.

This server exposes API Dash request capabilities as MCP tools, so AI clients can use API Dash data and execution flows through Model Context Protocol.

## Exposed Tools

- `apidash_status`
- `apidash_run_request`
- `apidash_rerun_history`
- `apidash_search_requests`
- `apidash_list_history`
- `apidash_get_history_entry`

## How It Works

- Transport: stdio
- Protocol: JSON-RPC 2.0
- Storage: reuses API Dash Hive boxes via `apidash_cli` package
- Request execution: reuses `apidash_cli` request executor

## Run Locally

From repository root:

```bash
dart run packages/apidash_mcp/bin/apidash_mcp.dart
```

## Cline Setup

Cline stores MCP config in `cline_mcp_settings.json`.

Open it from Cline UI:

1. Open Cline panel
2. Click MCP Servers icon
3. Open Configure tab
4. Click Configure MCP Servers

Add this server:

```json
{
  "mcpServers": {
    "apidash-mcp": {
      "command": "dart",
      "args": [
        "run",
        "D:/Code/apidash/packages/apidash_mcp/bin/apidash_mcp.dart"
      ],
      "env": {
        "APIDASH_WORKSPACE_PATH": "D:/Code/Testing"
      },
      "disabled": false
    }
  }
}
```

Notes:

- Replace paths with your local paths.
- `APIDASH_WORKSPACE_PATH` is optional, but recommended to force the exact API Dash workspace Hive path.
- If API Dash desktop app is open and locks Hive files, some tools may fail due to lock conflict on Windows.

## Quick Usage in Cline

After adding server, ask Cline prompts such as:

- "Use `apidash_search_requests` to find login APIs"
- "Run `apidash_run_request` with URL https://httpbin.org/get"
- "List last 5 entries with `apidash_list_history`"
- "Rerun this history id using `apidash_rerun_history`"

## Troubleshooting

- If tool calls fail with storage lock messages:
  1. Close API Dash GUI
  2. Retry MCP tool call
- If Cline does not show tools:
  1. Restart the MCP server from Cline MCP Servers UI
  2. Validate path in `args`
  3. Ensure `dart` is available in PATH
