
Add to your Claude Code MCP config:

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

### Available Tools

#### `send_request`

Send an HTTP request and get the response.
