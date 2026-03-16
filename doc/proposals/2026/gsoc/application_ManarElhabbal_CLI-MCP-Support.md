
![](images/gsoc_api.png)

# GSOC'26 Proposal - API Dash : CLI MCP Support

## About Me

1. **Name:** Manar Mohamed Hussien Elhabbal
2. **Email:** manar.elhabbal.dev@gmail.com
3. **Discord:** manarelhabbal
4. **Home Page:** N/A
5. **Blog:** N/A
6. **GitHub:** https://github.com/Manar-Elhabbal7
7. **LinkedIn:** https://www.linkedin.com/in/manar-elhabbal7/
8. **Timezone:** UTC+02:00 (Cairo)
9. **Resume:** [Link](https://drive.google.com/file/d/1CmRfSM-Zhz4g8EaYcGc-F9XmhIxv7chb/view?usp=drive_link)

---

## University Info

1. **University:** Mansoura University — Faculty of Computer and Information Sciences
2. **Program:** B.Sc. in Information Systems
3. **Year:** Third Year
4. **Expected Graduation:** 2027

---

### Motivation & Past Experience

### **1. Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?**

Yes, I have worked on a variety of FOSS projects. I contributed to the GSSOC’25 India program, raising 9 merged PRs, and continued making further contributions afterward 
including **bug fixes, feature implementations, tests, workflow automation, and documentation improvements**.

## 🌟 Open Source Contributions


| # | Repository | Contribution | PR Link | Status |
|---|-----------|--------------|--------|--------|
| 1 | taskwarrior | Fix: add obfuscation handling for dependencies in ColumnDepends | [#4072](https://github.com/GothenburgBitFactory/taskwarrior/pull/4072) | Merged |
| 2 | xkaper001/DocPilot | Add GitHub Actions workflow to auto-comment on new issues | [#9](https://github.com/xkaper001/DocPilot/pull/9) | Merged |
| 3 | MasterAffan/OptiFit | Add Unit Tests for Backend | [#57](https://github.com/MasterAffan/OptiFit/pull/57) | Merged |
| 4 | MasterAffan/OptiFit | Bug Report: build fails due to duplicate ndkVersion | [#37](https://github.com/MasterAffan/OptiFit/pull/37) | Merged |
| 5 | MasterAffan/OptiFit | Add Demo Video Section to README | [#35](https://github.com/MasterAffan/OptiFit/pull/35) | Merged |
| 6 | MasterAffan/OptiFit | Add App Icons for All Platforms | [#53](https://github.com/MasterAffan/OptiFit/pull/53) | Merged |
| 7 | SharonIV0x86/CinderPeak | Add examples for CSR-COO storage format | [#47](https://github.com/SharonIV0x86/CinderPeak/pull/47) | Merged |
| 8 | may-tas/TextEditingApp | Edit Text dialog autofocus issue | [#69](https://github.com/may-tas/TextEditingApp/pull/69) | Merged |
| 9 | may-tas/TextEditingApp | Background Color Tray issue solution | [#62](https://github.com/may-tas/TextEditingApp/pull/62) | Merged |
| 10 | may-tas/TextEditingApp | Add more color options | [#53](https://github.com/may-tas/TextEditingApp/pull/53) | Merged |
| 11 | foss42/awesome-generative-ai-apis | Add Humanizer PRO - AI Text Humanizer API | [#359](https://github.com/foss42/awesome-generative-ai-apis/pull/359) | Open |
| 12 | AmrAhmed119/dart-testgen | Delete coverage_import_test.dart after execution | [#58](https://github.com/AmrAhmed119/dart-testgen/pull/58) | Merged |

---

### **2. What is your one project/achievement that you are most proud of? Why?**

I am very proud of my participation in GSSoC'25 (GirlScript Summer of Code). It was my first
open-source experience — I didn't know how to fork a repo or raise a PR, but I taught myself. 
By the end of the program, I had 9 PRs merged, earned 32 points, and
contributed to several different projects.

---

### **3. What kind of problems or challenges motivate you the most to solve them?**

I enjoy solving challenging problems that require creative thinking beyond brute force. I regularly practice on LeetCode and Codeforces, and I’m especially motivated by real-world challenges that push me to learn new concepts. The process of struggling, learning, and eventually solving the problem is what drives me.

---

### **4. Will you be working on GSoC full-time? In case not, what will you be studying or working on while working on the project?**

No, I will be working on GSoC part-time. As a student, I may occasionally have exams or a summer internship at college, which I will note in the timeline. These responsibilities will not affect my contributions to the project, insha'Allah

---

### **5. Do you mind regularly syncing up with the project mentors?**

Not at all  I welcome it. Regular sync-ups are a great opportunity to get feedback, stay on 
track, and learn from the mentors. 

---

### **6. What interests you the most about API Dash?**
API Dash stands out to me for several reasons:

 - Simple and Beautiful UI
API Dash has a clean, simple, and intuitive interface that makes it easy to use, even for beginners.

 - API Dash is truly **cross-platform**, supporting desktop and mobile platforms. This is a rare capability among API clients, as most competitors do not provide mobile support.

 - API Dash is built with **Flutter** and uses Flutter’s **GPU Skia rendering engine**, resulting in a smaller footprint and faster performance.

 - One of the most impressive features is **Dash Bot**, which supports **local LLMs**.  
    This means AI assistance can work **without sending requests to external servers**, making it ideal when working with **sensitive or private data**.

- Multimedia Preview :
    API Dash supports **multimedia previews**, including:
    - Images
    - PDFs
    - Audio
    - Videos

This is a **unique and powerful feature** compared to many other API clients.

- Multi-Language Code Generation:
    API Dash can generate code snippets for **more than 23 programming languages and libraries**, including:

    - Dart
    - Python
    - Node.js
    - and many others

    > This makes it very helpful for developers working across different tech stacks.

- Privacy-Focused Local Operation:
    API Dash works **locally**, helping ensure **privacy and security** while still supporting modern API technologies such as:

    - HTTP
    - GraphQL
    - SSE
    - Streaming
    - AI APIs

- Well-Structured Architecture :
As a developer, what interests me the most is the **well-structured and organized architecture of the codebase**.  
It made it easier for me to understand the project when exploring the source code and helps make the project **maintainable and contributor-friendly**.

---

### ⭐ **Overall Impression:**  
API Dash combines **simplicity, performance, privacy, and powerful developer features**, making it a highly versatile and modern API client.


---

### **7. Can you mention some areas where the project can be improved?**
API Dash's codebase has a few important areas that could be improved and refactored.

-  **test coverage for the core HTTP services is almost nonexistent**.  
The file `better_networking_test.dart` is empty, and `http_service_test.dart` is fully commented out. This means that the core networking layer currently has no automated tests, making it harder to ensure stability and reliability.

- **error handling is too generic**.  
Authentication failures currently return raw strings instead of well-defined exception types. 
so it becomes difficult to distinguish between different problems such as network errors, authentication failures, or response parsing issues.

-  **import failures lack proper feedback**.  
When importing collections from tools like **Postman** or **cURL**, the system sometimes returns `null` if something goes wrong. Since no error message is shown to the user, debugging these import failures will be very hard.

-  **authentication logic is repetitive**.  
In `handle_auth.dart`, similar authentication logic is repeated across multiple authentication types. Refactoring this using a **Strategy pattern** would reduce duplication and make the authentication system cleaner and easier to maintain.

Overall, The code need refactoring and addressing these issues would improve both **code quality and user experience**. Among them, **adding proper test coverage and improving error reporting for imports** should be the highest priority.

---

# Project Proposal Information

## Project Title : CLI & MCP Support

## Abstract
 
API Dash is a beautiful AI-powered open-source cross-platform API client built with Flutter that helps developers create, customize, and test API requests with ease. However, it currently lacks support for **terminal-based workflows** and **integration with AI development assistants**.
 
This project implements two core capabilities:
 
1. **Command Line Interface (CLI):** Enables developers to run requests, import/export collections, execute batch tests, and view request history and more from the terminal. 
This allows automation, scripting, and seamless integration with developer workflows.
 
2. **Model Context Protocol (MCP) Server:** Exposes API Dash functionality to AI tools, enabling AI assistants to execute requests, generate client code, import collections, and run tests from MCP clients like Claude, Cursor, and VS Code.
 
Both the CLI and MCP server will share a common core from `apidash_core` to ensure consistent behavior across interfaces. 

---

# Technical Details 

### Technical Approach & Architecture


## Architecture Overview

Before diving into each component separately, it is important to understand
how the CLI and MCP server fit into the broader API Dash ecosystem.

Both the CLI and the MCP server are independent entry points — one built
for developers working in the terminal, the other for AI assistants working
through natural language. Despite their different interfaces, they share the
same underlying engine: `apidash_core`.

This design means that any logic improvement, bug fix, or new feature added
to the core is automatically available to all three surfaces: the GUI app,
the CLI, and the MCP server — with zero duplication.

The diagram below illustrates these relationships:

<p align="center">
  <img src="images/arch_diagram.png" width="500" alt="Architecture Diagram">
</p>


---
##  1. CLI Support 
To bring API Dash to the terminal, I will implement a dedicated
`apidash_cli` dart package which will be published on [pub.dev](https://pub.dev).

This package gives developers full access to the core functionality
of the API Dash GUI app — sending requests, managing collections,
generating code, and more — without ever leaving the terminal.

Once published, any developer can install it globally with a single command:

```bash
    dart pub global activate apidash_cli
```


### 1. Why This Approach?

| Principle | Description |
|-----------|-------------|
| **Modular Design** | Each command group is encapsulated in a separate module |
| **Package Reuse** | Leverages existing packages (`better_networking`, `curl_parser`, `postman`, `apidash_core`) to avoid code duplication |
| **Monorepo Integration** | Uses Melos for workspace management and dependency coordination |
| **Cross-platform** | Built with the Dart CLI framework to run on Windows, macOS, and Linux |

---

### 2. Package Structure

```dart
|packages/
├── apidash_cli/
│   ├── bin/
│   │   └── apidash.dart              # CLI entry point (`apidash` command)
│   ├── lib/
│   │   ├── main.dart                 # Package export
│   │   ├── commands/                 # Core command implementations
│   │   ├── models/                   # CLI-specific data models
│   │   ├── utils/                    # Utility functions
│   │   └── services/                 # Business logic services
│   ├── test/
│   │   ├── unit/                     # Unit tests
│   │   └── integration/              # Integration tests
│   ├── example/                      # Usage examples
│   └── pubspec.yaml

```

---

### 3. Technology Stack

| Component | Technology | Justification |
|-----------|------------|---------------|
| CLI Framework | `dart:cli` | Native Dart support, no external dependencies |
| Command Parsing | `args` package | Standard Dart CLI argument parser |
| HTTP Client | `better_networking` (exists) | Consistent with GUI app, well-tested |
| cURL Parsing | `curl_parser` (exists) | Proven reliability, maintained by project |
| Collection Import/Export | `postman`, `insomnia_collection`, `har` (exists) | Zero code duplication |
| Config Storage | `yaml` | Human-readable, industry standard |
| Output Formatting | `console` + `ansi_colors` | Rich terminal output, cross-platform |
| Code Generation | Jinja templates (exists) | Consistent with GUI app |
| Testing | `test` + `mockito` | Standard Dart testing stack |

---

### 4. Core Dependencies

```yaml
dependencies:
  better_networking: ^x.x.x        # HTTP request handling
  curl_parser: ^x.x.x              # cURL command parsing
  postman: ^x.x.x                  # Postman collection I/O
  insomnia_collection: ^x.x.x      # Insomnia file I/O
  har: ^x.x.x                      # HAR file I/O
  apidash_core: ^x.x.x             # Core business logic
  genai: ^x.x.x                    # AI integration
  jinja: ^x.x.x                    # Code generation templates
  args: ^2.4.0                     # CLI argument parser
  console: ^4.1.0                  # Terminal output formatting
  ansi_colors: ^0.2.0              # Color support
  yaml: ^3.1.0                     # Config file parsing
  path: ^1.8.0                     # Path operations
  intl: ^0.19.0                    # Internationalization

dev_dependencies:
  test: ^1.24.0                    # Testing framework
  mockito: ^5.4.0                  # Mocking
  build_runner: ^2.4.0             # Code generation
  lints: ^3.0.0                    # Linting rules
```

### Core Commands

The CLI follows a simple, predictable structure across all commands:

```bash
apidash <command> [subcommand] [arguments] [options]
```

Every command produces colored, human-readable output by default.
For scripting and automation, pass `--output json` to get
machine-readable output that pipes cleanly into other tools.

> I will discuss with the mentor to identify and prioritize the most
> important commands first. The commands listed in this section are
> planned examples — the final implementation scope will be agreed
> upon with the mentor based on project needs and GSoC timeline.

---

#### Command Overview

| Command | Description |
|---------|-------------|
| `apidash init` | Initialize a new project |
| `apidash request` | Send HTTP requests |
| `apidash collection` | Manage request collections |
| `apidash import / export` | Import and export collections |
| `apidash generate` | Generate client code |
| `apidash env` | Manage environment variables |
| `apidash ai` | AI-powered request generation |
| `apidash history` | View and replay past requests |

---

#### 1. Project Initialization

```bash
apidash init [name]
```

Creates a new API Dash project with configuration files and a
standard directory structure pre-filled with templates.

---

#### 2. Request Management *(Most Important)*

```bash
apidash request <url> [options]
```

The core command for sending HTTP requests directly from the terminal.
Supports all major HTTP methods, file-based request bodies, cURL
parsing, and streaming via SSE.

Each command is implemented as a class extending `Command` from the
`args` package. Here is a simplified sketch of how `RequestCommand`
is structured:

```dart
class RequestCommand extends Command {
  @override
  final name = 'request';

  @override
  final description = 'Send an HTTP request';

  RequestCommand() {
    addSubcommand(GetCommand());
    addSubcommand(PostCommand());
    addSubcommand(CurlCommand());
  }
}

class GetCommand extends Command {
  @override
  final name = 'get';

  @override
  final description = 'Send a GET request';

  GetCommand() {
    argParser
      ..addOption('env', abbr: 'e', help: 'Environment to use')
      ..addOption('save', help: 'Save request to collection')
      ..addFlag('watch', help: 'Enable watch mode for SSE');
  }

  @override
  Future<void> run() async {
    final url = argResults!.rest.first;
    final result = await RequestService.get(
      url,
      env: argResults!['env'],
    );
    OutputFormatter.print(result);
  }
}
```

**Subcommands**

| Command | Description |
|---------|-------------|
| `apidash request get <url>` | Send a GET request |
| `apidash request post <url> -d '{"key":"value"}'` | Send a POST request with body |
| `apidash request put <url> --file data.json` | Read request body from a file |
| `apidash request curl <curl-command>` | Parse and execute a cURL command |

**Options**

| Flag | Description |
|------|-------------|
| `-H, --header` | Add a request header |
| `-d, --data` | Add body data |
| `-p, --params` | Add query parameters |
| `-e, --env <name>` | Use a specific environment |
| `--save <name>` | Save request to a collection |
| `--watch` | Watch mode — supports SSE and streaming responses |

**Output example**

```bash
$ apidash request get https://api.example.com/users

  200 OK  GET https://api.example.com/users  143ms

{
  "users": [
    { "id": 1, "name": "Manar" },
    { "id": 2, "name": "Elhabbal" }
  ]
}
```

---

#### 3. Collection Management

```bash
apidash collection [subcommand]
```

Manage saved request collections — list, inspect, run as batch
tests, or export to standard formats.

| Subcommand | Description |
|------------|-------------|
| `apidash collection list` | List all collections |
| `apidash collection show <name>` | Show collection details |
| `apidash collection run <name>` | Run entire collection as a batch test |
| `apidash collection export <name> --format postman\|openapi\|curl` | Export a collection |

---

#### 4. Import / Export

```bash
# Import
apidash import <file> [--format postman|insomnia|har|openapi]

# Export
apidash export <collection-name> --format postman|openapi|curl
```

Reuses existing packages (`postman`, `insomnia_collection`, `har`,
`curl_parser`) from the monorepo — zero additional code required.

---

#### 5. Code Generation

```bash
apidash generate <request-name> --language <lang>
```

Generates ready-to-use client code from any saved request using
the existing Jinja templates — consistent with the GUI app output.

 **for example**
| Language | Command |
|----------|---------|
| Dart | `apidash generate my-request --language dart` |
| Python | `apidash generate my-request --language python` |



---

#### 6. Environment Management

```bash
apidash env [subcommand]
```

| Subcommand | Description |
|------------|-------------|
| `apidash env list` | List all environments |
| `apidash env use <name>` | Switch to a specific environment |
| `apidash env add <key> <value>` | Add an environment variable |
| `apidash env remove <key>` | Remove an environment variable |

---

#### 7. AI Integration — DashBot

```bash
apidash ai <prompt>
```

Natural language interface powered by `genai`. DashBot can generate
complete requests from a plain English description, explain response
errors, and suggest fixes — all without leaving the terminal.

The `--debug` flag attaches the last failed request and response to
the prompt automatically, so the AI has the full context it needs to
give a useful answer.

```bash
# Generate a full request from a description
apidash ai "create a POST request to register a new user with name and email"

# Debug the last failed request
apidash ai --debug "why did this request fail?"

# Pipe a response into DashBot for analysis
apidash request get https://api.example.com/users | apidash ai "summarize this response"
```

---

#### 8. History

```bash
apidash history [subcommand]
```

| Subcommand | Description |
|------------|-------------|
| `apidash history list` | View past requests |
| `apidash history replay <id>` | Re-execute a historical request |

---

## CLI UI

As a user, having a beautiful, colorful, and helpful interface is crucial for a good experience.  
As a developer, this section is particularly interesting for me

The CLI UI will be designed to be:

- **Professional and visually appealing**: using colors, ASCII logos, separators, and formatted tables.
- **Helpful and informative**: displaying quick command references and hints for new users.
- **Simple and maintainable**: structured code in `packages/apidash_cli/utils/banner.dart`.

To achieve this, I will use several Dart packages:

| Package       | Purpose                                           |
|---------------|--------------------------------------------------|
| `ansicolor`   | For colored and styled terminal text            |
| `cli_spinner` | For animated spinners during requests or tasks |
| `cli_table`   | To display commands or data in formatted tables|

The current implementation provides a colorful **ASCII banner** for the CLI:

<p align="center">
  <img src="images/banner.png" width="500" alt="CLI Banner Screenshot">
</p>

I intend to **refactor and enhance this banner** to make it more professional, while keeping the interface simple, clear, and intuitive for users.  


## Interactive Features I intend to add 

Progress Indicators

```
$ apidash process large-dataset.csv
Processing: [████████████████████░░] 85% (1,234/1,450 records)

```
Spinner Animation

```
$ apidash sync
⠋ Connecting to remote server... (2s)
```
Autocomplete features

Confirmations
```
This will delete 12 files. Continue? [y/N]
```

This approach ensures that the CLI not only looks professional but also provides a **friendly and productive user experience** in the terminal.

---

## Challenges & Solutions

#### 1. Cross-platform terminal color support

**Challenge:** ANSI color codes work on macOS and Linux but may
render as raw escape characters on Windows CMD and older PowerShell.

**Solution:** 
- Detect terminal capability at runtime using
`stdout.supportsAnsiEscapes` and fall back to plain text on
unsupported terminals. Windows Terminal and new PowerShell versions
are detected via environment variables like `WT_SESSION`.

---

#### 2. Shared state between CLI and GUI

**Challenge:** The GUI stores collections and environments in its
own local storage format. The CLI must read and write the same data
without any corruption.

**Solution:**
- Use `apidash_core` as the single data access layer
through a shared storage interface. The GUI and CLI each provide
their own implementation — neither reads the other's files directly.

---

#### 3. Streaming responses (SSE) in the terminal

**Challenge:** 
- SSE and streaming APIs send data continuously. The
CLI must display each chunk as it arrives and handle `Ctrl+C`
gracefully without leaving the terminal in a broken state.

**Solution:** 
- Use Dart's `Stream` API to print chunks as they arrive,
combined with a `ProcessSignal.sigint` handler to cancel the stream
cleanly on interrupt.

---

#### 4. MCP protocol versioning

**Challenge:** The MCP protocol is still evolving. A client update
could silently break the server if version mismatches are not handled.

**Solution:** 
- Implement version negotiation during the MCP handshake.
The server declares its supported protocol versions and returns a
clear error if the client requests an unsupported one.

---

#### 5. Testing without a real network

**Challenge:** Tests that hit real APIs are slow and fail in CI
environments with no internet access.

**Solution:** 
- Abstract the HTTP layer behind an interface and inject
a `mockito` mock in tests. This allows full command testing with
controlled responses and no network dependency.

---

#### 6. Large response readability

**Challenge:** Responses with thousands of lines will flood the
terminal and make output unreadable.

**Solution:**
- Truncate output to 50 lines by default and show a
hint with the total line count. 
A `--full` flag prints the complete response, and `--output <file>` saves it to disk instead.

> I inted to discuss these challanges and solutions with the mentor to guide me
> and choose the best solution for them.


---
# 2. MCP Support

## Introduction

The Model Context Protocol (MCP) provides a standardized communication layer between AI models, tools, and data sources. It defines a uniform interface that allows AI agents to access and interact with resources, such as local files, databases, and web APIs, without requiring custom integrations for each tool. it will be a great to support mcp to apidash 

This is how the mcp server is connected to any server

<p align="center"> <img src="images/mcp_arch.png" width="500" alt="MCP Architecture Diagram"> </p>

## Base Protocol & Transport

MCP uses **JSON-RPC** to encode all messages. Messages **MUST** be **UTF-8** encoded. The protocol defines two standard transports:

| Transport | Description |
|-----------|-------------|
| **stdio** | Client launches the MCP server as a subprocess; communication over standard input (stdin) and standard output (stdout). |
| **Streamable HTTP** | Server runs as an independent process; client uses HTTP POST to send messages and GET for Server-Sent Events (SSE) to receive server messages. |

Clients such as Cursor, Claude Desktop, and VS Code **SHOULD** support stdio whenever possible. Custom transports are allowed if they preserve the JSON-RPC message format and lifecycle.

---

## Which Transport Will We Use? Why? How?

### 1. Transport choice: **stdio**

The API Dash MCP server will use the **stdio** transport.

**Why stdio?**

- **Fits how MCP clients work:** Tools like Cursor and Claude launch the server as a **subprocess** and talk to it via stdin/stdout. No HTTP server or port configuration is required.
- **Simplicity:** No need to bind to a port, handle CORS, or manage sessions. One process, one bidirectional channel.
- **Security:** No network exposure; communication stays inside the host process.
- **Spec alignment:** The spec recommends that clients support stdio whenever possible, so targeting stdio maximizes compatibility.

### 2. stdio behavior (per MCP spec)

When using stdio, the implementation will adhere to the following:

| Requirement | Implementation |
|-------------|----------------|
| **Message framing** | Messages are **newline-delimited**. Each JSON-RPC message is one line; messages **MUST NOT** contain embedded newlines. |
| **Input** | The server **reads** JSON-RPC messages (requests, notifications, or batches) from **stdin**. |
| **Output** | The server **writes** only valid MCP messages to **stdout**. Nothing else (e.g. logs or debug text) goes to stdout. |
| **Logging** | Optional logging and diagnostics go to **stderr**. Clients may capture, forward, or ignore stderr. |
| **Client responsibility** | The client must not write anything to the server’s stdin that is not a valid MCP message. |

**Lifecycle:** The client launches the server subprocess → message exchange over stdin/stdout → client closes stdin and terminates the subprocess when done.

### 3. How we implement it in Dart

The `apidash_mcp` package uses the **[mcp_dart](https://pub.dev/packages/mcp_dart)** package, which already implements the JSON-RPC and stdio transport semantics. The server is wired to **`StdioServerTransport()`**, which:

- Reads lines from `stdin` (newline-delimited JSON-RPC).
- Writes JSON-RPC responses and notifications to `stdout`.
- Leaves `stderr` available for application logs.

Example (from `bin/apidash_mcp.dart`):

```dart
McpServer server = McpServer(
  Implementation(name: "apidash_mcp", version: "1.0.0"),
  options: ServerOptions(
    capabilities: ServerCapabilities(
      resources: ServerCapabilitiesResources(),
      tools: ServerCapabilitiesTools(),
    ),
  ),
);
server.connect(StdioServerTransport());
```

No custom transport code is required for stdio; `mcp_dart` handles framing and JSON-RPC encoding/decoding.

### 4. Streamable HTTP (future / optional)

We do **not** plan to implement **Streamable HTTP** in the initial GSoC scope. If we add it later, the implementation would need to:

- Expose a **single MCP endpoint** supporting both **POST** (send messages) and **GET** (SSE stream for server-to-client messages).
- Send **Accept: application/json, text/event-stream** on requests.
- **Security (per spec):** Validate the **Origin** header to prevent DNS rebinding, bind to **localhost (127.0.0.1)** when running locally, and consider authentication for connections.
- Optionally support **session management** via the **Mcp-Session-Id** header (returned at initialization, then sent by the client on every subsequent request).

This is documented here so the proposal stays aligned with the official MCP specification (e.g. 2025-11-25) and any future HTTP support can follow the same rules.

---

## Example CLI Commands Using MCP


```shell
apidash mcp list-tools              # List available MCP tools
apidash mcp execute <tool> <args>   # Execute MCP tool via CLI
apidash collection get --mcp        # Retrieve collections through the MCP layer
```

##  Project Structure

The implementation will be organized into  `apidash_mcp` package 

```shell
packages/
├── apidash_cli/      # CLI commands and argument parsing
├── apidash_mcp/      # MCP server implementation and tool definitions
└── apidash_core/     # Shared core logic used by both CLI and MCP
```

This modular structure ensures that the CLI and MCP server share the same core functionality, avoiding **code duplication** while maintaining extensibility.

###  MCP Tools

The following tools will be exposed through the MCP server:

1. **send_request**
Allows the AI agent to execute a specific API request stored in API Dash.

2. **list_collections**
Enables the AI agent to discover available API collections.

3. **generate_code**
Allows the AI to generate code snippets for a saved API request in different programming languages.

###  MCP Resources

Resources provide structured data that AI agents can read as `context`.

1. apidash://collections:
  A dynamic resource that exposes the current state of all user API collections.

2. apidash://history
   Provides recent request logs (e.g., the last 10–20 requests) which can help AI agents assist with debugging and analysis.

## Implementation Details :

1. I will create a dart console project in `packages/apidash_mcp`
 and I will install the packages i will use `mcp_dart` package

2. i will make a stdio server as the client like cursor or any client support mcp 
will communicate with them through standard input and output

<!--  
// use data in apidash? 
//plug to client
//technical details?

-->





## 3. Time Line 
<!--8 weeks as it is easy-->
<!--
should contain screen of running cli with beatiful colors ,bars and like an bar
contain sample of cli commands i will use 
contain codes 
contain challanges with solution 
contain diagrams with images
contain references used 
by the end of this section make a doc file 
submit form for reviewing
refactor what is writing
-->