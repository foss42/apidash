# GSoC 2026 Idea Doc — CLI & MCP Support (Project #6)

**Name:** Ashutosh Sharma  
**Email:** itsashutosh769@gmail.com  
**GitHub:** https://github.com/AshutoshSharma-pixel  
**University:** Manipal University Jaipur  
**Program:** B.Tech Computer Science  
**Year:** 3rd year (6th semester)  
**Expected Graduation:** 2027  

**Project:** CLI & MCP Support (Idea #6)  
**Difficulty:** Easy-Medium  
**Length:** 90 hours  

---

## 1. About Me

I am a 3rd year Computer Science student at Manipal University Jaipur. 
I have been working with Dart for over a year and have hands-on experience 
with Flutter (stateful/stateless widgets, state management). I also have 
3 years of experience with C through my engineering curriculum, along with 
solid understanding of OS concepts and Linux/Ubuntu.

Beyond academics, I have built and shipped multiple products:
- **AstroWord** - A Vedic astrology AI platform (Next.js, FastAPI, Firebase, Gemini AI)
- **SuperCart** - A B2B SaaS self-checkout system (Node.js, PostgreSQL, React Native)
- **Hywaiz** - A vehicle assistance platform (pre-incubated by my college)
- **Nyaya AI** - A legal assistance platform for India

My existing contributions to API Dash:
- PR #1361 - Removed Flutter-specific dependency from `better_networking` 
  package by replacing `debugPrint` with `stderr.writeln`, making the package 
  usable in pure Dart CLI context (fixes issue #1360)

---

## 2. Understanding the Project

Project #6 has two core deliverables:

1. **A CLI tool** that exposes API Dash's core capabilities via terminal, 
   allowing developers to run API requests, manage collections, and handle 
   environments without opening the GUI.

2. **An MCP Server** that exposes API Dash as a tool provider so external 
   AI agents (VS Code Copilot, Claude Desktop, Cursor) can interact with 
   API Dash programmatically via the Model Context Protocol.

After reading Ashita's article on MCP Apps, I identified a third dimension 
that significantly enhances the value of this project:

3. **MCP Apps integration** - When an AI agent calls API Dash's MCP server 
   tools (like `execute_request`), instead of returning raw JSON text, API 
   Dash can return a rich interactive HTML UI rendered natively as a sandboxed 
   iframe inside the host (VS Code, Claude Desktop). This transforms API Dash 
   from a passive tool provider into an active visual interface within AI 
   workflows.

This combination of CLI + MCP Server + MCP Apps has not been explored by 
any other contributor and directly addresses the mentor's repeated guidance 
to incorporate MCP Apps into Project 6 proposals.

---

## 3. Current State of the Codebase

After studying the codebase and both 2025 GSoC reports, here is what 
already exists that I will build on:

| Component | Status | Location |
|---|---|---|
| HTTP execution pipeline | Done | `packages/better_networking/lib/services/http_service.dart` |
| Core data models | Done | `packages/apidash_core` |
| SSE/Streaming support | Done | `packages/better_networking` |
| Authentication (all types) | Done | `packages/better_networking/lib/utils/auth/` |
| AI primitives | Done | `packages/genai` |
| Hive local storage | Done | `lib/services/hive_services.dart` |
| Code generation | Done | `lib/codegen/` |

**Key blocker identified and partially fixed:**
`better_networking` has Flutter-specific dependencies (`kIsWeb`, `debugPrint`, 
`flutter_web_auth_2`) that prevent it from being used in a pure Dart CLI. 
My PR #1361 addresses the `debugPrint` issue. The remaining Flutter deps 
(`kIsWeb` in `platform_utils.dart` and `http_client_manager.dart`) will be 
handled in Phase 1 of this project.

---

## 4. Proposed Implementation
### Part 1: Refactor `better_networking` for Pure Dart (Foundation)

Before building the CLI, the `better_networking` package needs to be fully 
decoupled from Flutter. Remaining issues after PR #1361:

- Replace `kIsWeb` in `platform_utils.dart` and `http_client_manager.dart` 
  with `dart:io` Platform checks
- Handle `flutter_web_auth_2` in `oauth2_utils.dart` with conditional imports

This is the foundational work that makes everything else possible.

### Part 2: CLI Tool (`packages/apidash_cli`)

A new pure Dart package inside the monorepo that reuses existing 
infrastructure without duplicating logic.

**Package structure:**
```dart
packages/apidash_cli/
├── bin/
│   └── apidash.dart          # Entry point
├── lib/
│   ├── commands/
│   │   ├── run_command.dart   # apidash run <request-id>
│   │   ├── list_command.dart  # apidash list
│   │   ├── env_command.dart   # apidash env list/active
│   │   └── serve_command.dart # apidash serve --mcp
│   ├── output/
│   │   └── formatter.dart     # Pretty print responses
│   └── storage/
│       └── hive_reader.dart   # Read existing Hive storage
├── pubspec.yaml
└── test/
```

**CLI commands:**
```bash
apidash list                    # List all saved requests
apidash run <request-id>        # Execute a saved request
apidash env list                # List all environments
apidash env active              # Show active environment
apidash serve --mcp             # Start MCP server headlessly
```

**Key design decision:** CLI reads directly from the same Hive storage 
as the GUI. This means requests saved in the GUI are immediately available 
in the CLI and vice versa.

**Packages used:**
- `package:args` - Command and flag parsing
- `package:mason_logger` - Fancy terminal output
- `better_networking` - HTTP execution (after refactor)
- `apidash_core` - Shared data models

### Part 3: MCP Server (`packages/apidash_mcp`)

Exposes API Dash as an MCP Server so external AI agents can interact 
with it via the Model Context Protocol.

**MCP Tools exposed:**
| Tool | Description |
|---|---|
| `execute_request` | Execute a saved API request and return response |
| `list_requests` | List all saved requests with metadata |
| `create_request` | Create a new API request |
| `list_environments` | List all saved environments |
| `get_active_environment` | Get currently active environment variables |

**Transport:** stdio (for Claude Desktop, VS Code, Cursor)

### Part 4: MCP Apps (The Differentiator)

When an AI agent calls `execute_request`, instead of returning raw JSON, 
API Dash returns an MCP App - a rich interactive HTML UI rendered as a 
sandboxed iframe inside the host.

**How it works (based on Ashita's MCP Apps article):**
```typescript
// MCP Server registers execute_request tool with UI resource
server.registerTool(
  "execute_request",
  {
    description: "Execute a saved API request",
    _meta: { ui: { resourceUri: "ui://apidash/response-viewer" } },
  },
  async (args) => {
    // Execute the request using better_networking
    final response = await executeRequest(args.requestId);
    return { content: [{ type: "text", text: response }] };
  }
);

// UI resource returns rich HTML response card
server.registerResource(
  "response-viewer",
  "ui://apidash/response-viewer",
  { mimeType: "text/html;profile=mcp-app" },
  async (uri) => ({
    contents: [{ uri: uri.href, mimeType: "text/html;profile=mcp-app", 
    text: RESPONSE_VIEWER_HTML() }],
  })
);
```

**The response card shows:**
- Status code with color (green 200, red 4xx/5xx)
- Response time
- Headers in collapsible section
- Body with syntax highlighting
- Token usage if AI API call

**Host-aware theming:** Using `applyHostContext()` from Ashita's article 
so the UI blends natively with VS Code or Claude Desktop theme.

**CSP declared properly:** Only approved domains can be accessed from 
the sandboxed iframe.

---

## 5. Timeline (90 Hours)

### Community Bonding (Before May 25)
- Complete remaining `better_networking` Flutter dep refactor
- Study `mcp_dart` package thoroughly
- Finalize CLI command structure with mentor
- Set up `packages/apidash_cli` and `packages/apidash_mcp` scaffolding

### Phase 1 — Foundation & CLI (Weeks 1-3, ~30 hrs)

| Week | Goal | Deliverable |
|---|---|---|
| 1 | Complete better_networking refactor | kIsWeb and flutter_web_auth_2 removed |
| 2 | Build CLI core: list, run commands | `apidash list` and `apidash run` working |
| 3 | Add env commands + output formatting | Full CLI working with pretty output |

### Phase 2 — MCP Server (Weeks 4-6, ~30 hrs)

| Week | Goal | Deliverable |
|---|---|---|
| 4 | Set up MCP server with stdio transport | Server connects to Claude Desktop |
| 5 | Implement execute_request and list_requests tools | AI agent can run API requests |
| 6 | Add remaining tools + Hive storage access | Full MCP server working |

### Phase 3 — MCP Apps + Polish (Weeks 7-9, ~30 hrs)

| Week | Goal | Deliverable |
|---|---|---|
| 7 | Build response viewer MCP App HTML | Rich UI card renders in VS Code |
| 8 | Add host-aware theming + CSP | UI blends with host theme |
| 9 | Tests, docs, final polish | PR ready to merge |

---

## 6. Why Me

- I know Dart well and have Flutter experience, so I can read and extend 
  the existing codebase without a ramp-up period
- My C background and OS theory means I understand systems-level concepts 
  needed for CLI development
- I have already contributed PR #1361 which directly unblocks this project
- I have built and shipped real products (AstroWord, SuperCart) so I 
  understand what production-ready code looks like
- I read Ashita's MCP Apps article carefully and identified an angle 
  nobody else proposed

---

## 7. Open Questions for Mentor

1. Should `apidash serve --mcp` start the MCP server as a subprocess 
   from the CLI, or should it be a completely separate binary?
2. For MCP Apps, should the response viewer HTML be self-contained in 
   the Dart MCP server, or generated dynamically based on the response?
3. Should the CLI support creating new requests from scratch, or focus 
   only on running existing saved requests in this 90-hour scope?
4. What is the preferred approach for safely accessing Hive storage from 
   the CLI without conflicts with the running GUI app?

---

*Idea doc by Ashutosh Sharma | GitHub: AshutoshSharma-pixel | 
Email: itsashutosh769@gmail.com*