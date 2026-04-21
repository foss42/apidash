# MCP User Guide

This guide explains how to use API Dash MCP integration so AI clients (for example, Cline) can run API Dash requests, search saved requests, and inspect history.

## What Is MCP Integration in API Dash?

API Dash provides an MCP server package: `apidash_mcp`.

It uses:
- Transport: stdio
- Protocol: JSON-RPC 2.0
- Storage: shared API Dash Hive workspace data via `apidash_cli`

This lets an MCP client call tools that operate on your saved requests and history.

## Prerequisites

1. Dart SDK installed and available in PATH.
2. API Dash repository available locally.
3. A valid API Dash workspace path with Hive files.
4. MCP-compatible client (for example, Cline extension in VS Code).

## MCP Tools Exposed by API Dash

- `apidash_status`
- `apidash_run_request`
- `apidash_rerun_history`
- `apidash_search_requests`
- `apidash_list_history`
- `apidash_get_history_entry`

## Configure MCP in Cline

Open Cline MCP settings and add:

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
- Replace `args` path with your local repository path.
- Replace `APIDASH_WORKSPACE_PATH` with your actual API Dash workspace folder.
- `APIDASH_WORKSPACE_PATH` is strongly recommended to avoid workspace detection mismatches.

## Example Prompts for Cline

Use prompts like:

1. "Use `apidash_status` and tell me if storage is ready"
2. "Use `apidash_search_requests` with query login"
3. "Use `apidash_run_request` with url https://httpbin.org/post, method POST, headers {\"Content-Type\":\"application/json\"}, and data {\"name\":\"Ada\"}"
4. "Use `apidash_list_history` with last 5"
5. "Use `apidash_get_history_entry` for this historyId: <id>"
6. "Use `apidash_rerun_history` for historyId <id> with method GET"

## CLI and MCP Relationship

- `apidash_mcp` reuses `apidash_cli` storage and request execution layers.
- This ensures MCP results and CLI behavior stay consistent.
- Requests executed through MCP are persisted to history when storage is available.

## Troubleshooting

### 1) Storage lock on Windows

If API Dash GUI and CLI/MCP use the same Hive files at the same time, you may get lock errors.

Try this:
1. Close API Dash GUI.
2. Retry MCP call.
3. Reopen GUI after CLI/MCP operations if needed.

### 2) Tools are not visible in Cline

1. Restart the MCP server from Cline MCP panel.
2. Verify `command` and `args` paths.
3. Ensure `dart` works in terminal (`dart --version`).

### 3) Empty results from search/history

1. Verify `APIDASH_WORKSPACE_PATH` points to the correct workspace directory.
2. Confirm workspace contains Hive files like:
   - `apidash-data.hive`
   - `apidash-history-meta.hive`
   - `apidash-history-lazy.hive`

## Security Notes

- MCP server runs local code with access to your local API Dash workspace.
- Do not share sensitive tokens or secrets in public prompts/screenshots.
- Use environment variables for secrets where possible.

## Related Docs

- CLI Guide: `packages/apidash_cli/README.md`
- MCP Package README: `packages/apidash_mcp/README.md`
