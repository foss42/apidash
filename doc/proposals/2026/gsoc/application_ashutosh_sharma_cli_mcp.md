### About
1. **Full Name:** Ashutosh Sharma
2. **Contact Info:** itsashutosh769@gmail.com
3. **Discord Handle:** ashutoshsharma_71100
4. **Home Page:** https://github.com/AshutoshSharma-pixel
5. **Blog:** N/A
6. **GitHub:** https://github.com/AshutoshSharma-pixel
7. **LinkedIn:** https://www.linkedin.com/in/ashutosh-sharma-79557728a/
8. **Time Zone:** IST (UTC+5:30)
9. **Resume:** https://drive.google.com/file/d/1brXA_tMiBXW3ofgmV88tgM49GHh_fd8T/view?usp=sharing

---

### University Info
1. **University:** Manipal University Jaipur
2. **Program:** B.Tech Computer Science Engineering
3. **Year:** 3rd Year (6th Semester)
4. **Expected Graduation:** 2027

---

### Motivation & Past Experience

**1. Have you worked on or contributed to a FOSS project before?**

Yes. I have made contributions to multiple FOSS projects:

**API Dash contributions:**
- **PR #1374** (Open): Removes all Flutter-specific dependencies from `better_networking` package, making it usable in pure Dart CLI context
- **Issue #1360** (Open): Documented the Flutter dependency blocker in `better_networking`

**MetaCall contributions (5 merged PRs):**
- **PR #26** (Merged): Fixed 5 critical bugs in MetaCall VS Code extension — activation event, memory leak, helloWorld cleanup, delete task mismatch, template message
- **PR #28** (Merged): Modernized all dependencies, fixed 145+ TypeScript compilation errors
- **PR #31** (Merged): Added GitHub Actions CI lint + cross-platform testing (Ubuntu, macOS, Windows)
- **PR #32** (Merged): Fixed package-lock.json sync to make CI pass
- **PR #34** (Merged): Replaced @microsoft/vscode-azext-utils with native VS Code APIs, eliminated Microsoft telemetry (861 lines removed)

**Working MCP POC:**
I have built a working MCP server for MetaCall Deploy & FaaS: github.com/AshutoshSharma-pixel/metacall-mcp
- 3 MCP tools working: `list_deployments`, `call_function`, `deploy_from_repo`
- Tested in MCP Inspector — all tools visible, connected, functional
- Configured in Claude Desktop — server connects and tools are callable

This cross-project MCP experience (API Dash + MetaCall simultaneously) gives me unique expertise in building MCP servers in both Dart and TypeScript ecosystems.

**2. What is your one project/achievement you are most proud of?**

I am most proud of **AstroWord** — a Vedic astrology AI platform I built and launched independently. The stack includes Next.js 15 on Vercel, FastAPI on Railway, Firebase for auth and database, and Gemini AI for astrological analysis. I launched it on Product Hunt and got organic signups within the first week. What makes me proud is not just the technical execution but solving a real problem for a niche audience — making ancient Vedic astrology accessible through modern AI.

The biggest challenge was a critical SEO bug where an unconditional auth redirect in `AuthProvider.tsx` was blocking Google's crawler from all 7 tool pages. I identified it, added a `PUBLIC_ROUTES` whitelist, and fixed it without breaking authentication. That kind of production debugging under pressure is what I enjoy most.

**3. What kind of problems motivate you the most?**

I am most motivated by problems at the intersection of developer tooling and AI workflows. The idea that AI agents should be able to interact with APIs the same way developers do — but programmatically and with rich visual feedback — is exactly the kind of problem that gets me excited. Project #6 sits right at this intersection.

**4. Will you be working on GSoC full-time?**

I am a 3rd year B.Tech student. I will have regular college during the GSoC period. However, I have no major exams or commitments during the May-August coding period and can commit 5-6 hours daily on weekdays and 8-10 hours on weekends, which comfortably covers the 90-hour project scope over the coding period.

**5. Do you mind regularly syncing up with project mentors?**

Not at all. I have already been attending the weekly connects and actively engaging on Discord and GitHub. Regular sync-ups are something I actively value — they help course-correct early and avoid wasted effort.

**6. What interests you most about API Dash?**

What interests me most is that API Dash is positioned to become the first truly AI-native API testing client. The 2025 GSoC work by Manas and Udhay laid critical infrastructure — `better_networking`, SSE streaming, `genai` package, Dashbot, authentication. Project #6 is the natural next step: taking all of that and making it accessible to AI agents and terminal workflows. I want to build that bridge.

**7. Can you mention areas where the project can be improved?**

- **CLI access**: Developers who work in terminal-heavy workflows (CI/CD pipelines, scripting) currently have no way to use API Dash without opening the GUI. A CLI would unlock a whole new category of users.
- **AI agent integration**: API Dash has powerful AI features (Dashbot, genai) but they're only accessible through the GUI. Exposing them via MCP would let external agents use API Dash as a tool.
- **MCP Apps**: When an MCP tool returns a response, it's just text. Using the MCP Apps spec, API Dash could return rich interactive UI — a response viewer card rendered natively in VS Code or Claude Desktop — dramatically improving the developer experience.

---

### Project Proposal Information

**1. Proposal Title:** CLI & MCP Support with MCP Apps for API Dash

**2. Abstract:**

API Dash is a powerful API testing client but currently only accessible through its GUI. This project adds three new access layers:

1. A **CLI tool** (`apidash`) built in pure Dart that lets developers run API requests, manage collections, and handle environments from the terminal — enabling CI/CD integration and scripting workflows.

2. An **MCP Server** that exposes API Dash as a Model Context Protocol server so AI agents in VS Code, Claude Desktop, and Cursor can interact with API Dash programmatically via stdio transport.

3. **MCP Apps integration** — the key differentiator — where MCP tool responses return rich interactive HTML UIs rendered natively as sandboxed iframes inside AI hosts, instead of plain JSON text. This is based on the MCP Apps spec outlined in the guide by Ashita Prasad and transforms API Dash from a passive tool provider into an active visual interface within AI agent workflows.

The foundational work for this project has already been started: PR #1374 removes all Flutter-specific dependencies from `better_networking`, making it directly importable in a pure Dart CLI context.

**3. Detailed Description:**

#### Background & Current State

After studying both 2025 GSoC reports (Manas Hejmadi and Udhay Adithya) and the full codebase, I understand what already exists:

| Component | Status | Location |
|---|---|---|
| HTTP execution pipeline | ✅ Done | `packages/better_networking` |
| Core data models | ✅ Done | `packages/apidash_core` |
| SSE/Streaming support | ✅ Done | `packages/better_networking` |
| Authentication (all types) | ✅ Done | `packages/better_networking/utils/auth/` |
| AI primitives | ✅ Done | `packages/genai` |
| Hive local storage | ✅ Done | `lib/services/hive_services.dart` |
| Flutter deps in better_networking | ✅ Fixed | PR #1374 |

The CLI and MCP work builds directly on this foundation without duplicating any existing logic.

---

#### Part 1: CLI Tool (`packages/apidash_cli`)

A new pure Dart package inside the monorepo that reuses existing infrastructure.

**Architecture:**
```
packages/apidash_cli/
├── bin/
│   └── apidash.dart              # Entry point
├── lib/
│   ├── commands/
│   │   ├── run_command.dart      # apidash run <request-id>
│   │   ├── list_command.dart     # apidash list
│   │   ├── env_command.dart      # apidash env list/active
│   │   └── serve_command.dart    # apidash serve --mcp
│   ├── output/
│   │   └── formatter.dart        # Pretty print responses
│   └── storage/
│       └── hive_reader.dart      # Headless Hive access
├── pubspec.yaml
└── test/
```

**Commands:**
```bash
apidash list                    # List all saved requests
apidash run <request-id>        # Execute a saved request
apidash env list                # List all environments
apidash env active              # Show active environment
apidash serve --mcp             # Start MCP server headlessly
```

**Storage Approach:**

Based on mentor guidance in the weekly connect, the CLI will use **file-based storage** instead of direct Hive access. The mentor confirmed that Hive has concurrent access issues when both GUI and CLI try to open the same box simultaneously.

The CLI will use a `.apidash/` folder in the project's working directory:
```
.apidash/
├── collections/
│   └── my-api-tests.json     # Saved request collections
├── requests/
│   └── get-users.json        # Individual saved requests
└── config.json               # CLI configuration
```

**Storage strategy:**
- Local workspace (`.apidash/` in current directory) takes priority
- Falls back to global workspace (`~/.apidash/`) if no local workspace found
- Collections stored as JSON files, compatible with API Dash export format
- Ad-hoc requests execute and return without persistence by default
- Use `--save` flag to persist an ad-hoc request
```dart
// CLI workspace detection
String? findWorkspace() {
  final local = Directory('.apidash');
  if (local.existsSync()) return local.path;
  final global = Directory('${Platform.environment['HOME']}/.apidash');
  if (global.existsSync()) return global.path;
  return null;
}
```

This approach is consistent with how tools like `.git`, `.env` work — project-specific API collections live with the project.

**Packages:**
- `package:args` — command and flag parsing
- `package:mason_logger` — terminal output formatting
- `better_networking` (after PR #1374) — HTTP execution
- `apidash_core` — shared data models

---

#### Part 2: MCP Server (`packages/apidash_mcp`)

Exposes API Dash as an MCP Server using `mcp_dart` package with stdio transport.

**Architecture:**
```
packages/apidash_mcp/
├── bin/
│   └── server.dart              # Entry point
├── lib/
│   ├── server.dart              # MCP server setup
│   ├── tools/
│   │   ├── execute_request.dart
│   │   ├── list_requests.dart
│   │   ├── create_request.dart
│   │   ├── list_environments.dart
│   │   └── get_active_env.dart
│   ├── resources/
│   │   ├── collections.dart
│   │   └── environments.dart
│   └── transport/
│       └── stdio_transport.dart
└── pubspec.yaml
```

**MCP Tools with schemas:**
```dart
// execute_request - with MCP App UI linked
server.registerTool(
  "execute_request",
  ToolDefinition(
    description: "Execute a saved API request and return the response",
    inputSchema: {
      "requestId": {"type": "string", "description": "ID of the saved request"}
    },
    meta: ToolMeta(ui: ToolUi(resourceUri: "ui://apidash/response-viewer")),
  ),
  (args) async {
    final response = await executeRequest(args["requestId"]);
    return ToolResult(content: [TextContent(text: jsonEncode(response))]);
  }
);

// list_requests
server.registerTool(
  "list_requests",
  ToolDefinition(description: "List all saved API requests"),
  (_) async {
    final ids = hiveHandler.getIds() as List;
    final requests = ids.map((id) => hiveHandler.getRequestModel(id)).toList();
    return ToolResult(content: [TextContent(text: jsonEncode(requests))]);
  }
);
```

**Claude Desktop config:**
```json
{
  "mcpServers": {
    "apidash": {
      "command": "/path/to/apidash_mcp_server",
      "args": []
    }
  }
}
```

**MCP Resources:**

| Resource URI | Description | Hive Source |
|---|---|---|
| `apidash://requests` | All saved requests | `apidash-data` box |
| `apidash://environments` | All environments | `apidash-environments` box |
| `apidash://environment/active` | Active environment | `apidash-environments` box |

---

#### Part 3: MCP Apps — The Differentiator

Based on Ashita's guide on MCP Apps, when an AI agent calls `execute_request`, instead of returning plain JSON, API Dash returns a rich interactive HTML UI rendered as a sandboxed iframe natively inside VS Code or Claude Desktop.

**The pattern (from the MCP Apps spec):**
```
Server registers UI resource with MIME: text/html;profile=mcp-app
Tool points to UI resource via _meta.ui.resourceUri
Host loads HTML in sandboxed iframe
UI performs handshake: ui/initialize → hostContext → ui/notifications/initialized
UI renders rich response card with host-aware theming
```

**Response Viewer MCP App:**
```dart
String RESPONSE_VIEWER_HTML() => '''
<!DOCTYPE html>
<html>
<head>
  <style>${sharedStyles()}</style>
</head>
<body>
  <div class="response-card">
    <div class="status-bar">
      <span class="status-badge \${statusClass}">...\${statusCode}</span>
      <span class="timing">...\${timing}ms</span>
    </div>
    <div class="headers-section">...</div>
    <div class="body-section">
      <pre id="response-body">...</pre>
      <button onclick="copyToClipboard()">Copy</button>
    </div>
  </div>
  <script>
    \${rpcClientScript()}
    \${messageHandlerScript()}
    \${applyHostContextScript()}
    
    // MCP Apps handshake
    request('ui/initialize', { protocolVersion: '2025-11-21' }).then((res) => {
      applyHostContext(res?.hostContext); // Blend with VS Code/Claude theme
      const caps = res?.hostCapabilities || {};
      notify('ui/notifications/initialized');
    });
    
    // Handle clipboard if host supports it
    async function copyToClipboard() {
      await request('ui/update-model-context', {
        content: [{ type: 'text', text: document.getElementById('response-body').textContent }]
      });
    }
  </script>
</body>
</html>
''';
```

**What the response card looks like in VS Code:**
```
┌─────────────────────────────────────────┐
│  ✅ 200 OK                    124ms      │
├─────────────────────────────────────────┤
│  Headers ▼                              │
│  content-type: application/json         │
├─────────────────────────────────────────┤
│  Body                                   │
│  {                                      │
│    "id": 1,                             │
│    "name": "Ashutosh"                   │
│  }                           [Copy]     │
└─────────────────────────────────────────┘
```

**MCP Apps I will build:**

| MCP Tool | MCP App UI |
|---|---|
| `execute_request` | Response viewer with status, headers, body, timing |
| `list_requests` | Interactive collection browser with method badges |
| `manage_environment` | Env variable editor with add/edit/delete |

**CSP declaration:**
```dart
server.registerResource(
  "response-viewer",
  "$URI/response-viewer",
  ResourceDefinition(
    mimeType: MIME,
    meta: ResourceMeta(ui: ResourceUi(
      csp: CspDefinition(connectDomains: []) // Self-contained, no external domains
    ))
  ),
  ...
);
```

---

**4. Weekly Timeline (90 Hours)**

| Period | Task | Hours |
|---|---|---|
| **Community Bonding** | Study `mcp_dart` package, finalize CLI command structure with mentor, set up package scaffolding | - |
| **Week 1** | Complete `packages/apidash_cli` setup, implement `apidash list` and `apidash run` commands with headless Hive access | 10 |
| **Week 2** | Implement `apidash env list/active`, output formatting with `mason_logger`, write tests for CLI commands | 10 |
| **Week 3** | Set up `packages/apidash_mcp`, implement stdio transport, connect to Claude Desktop and VS Code | 10 |
| **Week 4** | Implement `execute_request` and `list_requests` MCP tools with full schemas | 10 |
| **Week 5** | Implement remaining MCP tools (`create_request`, `list_environments`, `get_active_environment`), MCP resources | 10 |
| **Week 6** | Build response viewer MCP App HTML with MCP Apps handshake flow | 10 |
| **Week 7** | Add host-aware theming via `applyHostContext()`, CSP declaration, `ui/update-model-context` integration | 10 |
| **Week 8** | Build `list_requests` collection browser MCP App and `manage_environment` MCP App | 10 |
| **Week 9** | Write comprehensive tests, documentation, final polish, PR ready to merge | 10 |
| **Total** | | **90 hours** |
