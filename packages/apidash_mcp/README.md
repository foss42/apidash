
# API Dash MCP Server

`apidash_mcp` exposes API Dash workspace data and request execution through the Model Context Protocol so you can work with saved collections directly from Copilot Chat.

## What It Provides

- A stdio-based MCP server for local development.
- A visual collection browser tool for exploring saved requests.
- A saved-request execution tool for running stored API Dash requests by id.
- MCP APPS support for the collection browser.

## Prerequisites

- `apidash_storage` dependencies fetched with `dart pub get`.
- A valid HIS workspace path available through `APIDASH_WORKSPACE_PATH`.
- VS Code with MCP support enabled.

## Install Dependencies

From the repository root:

```bash
cd packages/apidash_storage
dart pub get

cd ../apidash_mcp
dart pub get
```

## Configure VS Code MCP

Create or update `.vscode/mcp.json` in the repository:

```json
{
    "servers": {
        "apidash": {
            "type": "stdio",
            "command": "dart",
            "args": [
                "run",
                "apidash/packages/apidash_mcp/bin/server.dart"
            ],
            "env": {
                "APIDASH_WORKSPACE_PATH": "/absolute/path/to/your/his/workspace"
            }
        }
    },
    "inputs": []
}
```

Replace `/absolute/path/to/your/his/workspace` with the absolute path to your HIS workspace.

If your VS Code setup launches commands from a different working directory, use an absolute path to `bin/server.dart` instead of the relative path shown above.

## Start The Server

After saving `.vscode/mcp.json`, restart MCP in VS Code or reload the window.


## Available Tools

The server currently exposes two tools:

| Tool | Purpose | Input |
| --- | --- | --- |
| `browse_collections` | Opens the visual collection browser and returns the current collection tree | None |
| `execute_request` | Executes a saved request by request id | `{ "id": "<request-id>" }` |

## Tool Reference

### `browse_collections`

Opens the API Dash collection browser UI and returns the current tree of collections, folders, and requests.

Example Copilot Chat prompts:

```text
Use the apidash MCP server to open browse_collections.
```

```text
Show me my saved API Dash collections with browse_collections.
```

What it does:

- Loads the latest collection tree from the HIS workspace.
- Opens the embedded MCP UI for browsing requests.
- Returns structured content for the current tree.

The browser UI is backed by the `apidash://apps/collection-browser` resource.

### `execute_request`

Executes one saved request from the HIS workspace by request id.

Input schema:

```json
{
    "id": "req_001"
}
```

Example Copilot Chat prompts:

```text
Run apidash tool execute_request with id req_001.
```

```text
Execute the saved request req_001 using the apidash MCP server.
```

What it does:

- Resolves the request across collections and folders.
- Sends the stored HTTP request.
- Returns the execution result as JSON.
- Updates the corresponding request and index files when the request metadata needs to be synchronized.

## Recommended Workflow

1. Save a request into your HIS workspace with the CLI or manually.
2. Start or reload the MCP server in VS Code.
3. Open `browse_collections` to inspect the saved requests.
4. Run `execute_request` on a selected request id.

Example CLI command for creating a saved request:

```bash
cd packages/apidash_cli
dart run bin/apidash_cli.dart exec --url=https://httpbin.org/get --method=GET --save --collection=col_001 --name="HTTPBin GET"
```

## Troubleshooting

- If the server does not start, confirm that `APIDASH_WORKSPACE_PATH` is set and points to a valid HIS workspace.
- If the browser shows no collections, verify that the workspace contains saved request files and that the CLI is writing to the same workspace path.
- If Copilot Chat cannot find the tools, reload VS Code after editing `.vscode/mcp.json`,Then verify in the Copilot Chat **"Configure Tools"** section that the MCP server is enabled.

